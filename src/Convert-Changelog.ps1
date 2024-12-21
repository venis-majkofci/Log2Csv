[CmdletBinding()]

param (
    [Parameter(Mandatory=$true)] [string]$changelogName,
    [Parameter(Mandatory=$false)] [string]$minVersion = "oldest",
    [Parameter(Mandatory=$false)] [string]$maxVersion = "latest",
    [Parameter(Mandatory=$false)] [string[]]$scopes = @(""),
    [Parameter(Mandatory=$false)] [bool]$strictScope = $false,
    [Parameter(Mandatory=$false)] [string]$configPath = ".\config\changelog-config.json"
)

# Import helper functions
try {
    . .\src\functions\Check-Version.ps1
    . .\src\functions\Check-Match.ps1
    . .\src\functions\Write-Log.ps1
} catch {
    Write-Error "[$($MyInvocation.MyCommand.Name)] Error: Failed to import helper functions. Please check the file paths and try again."
    return
}

Write-Log -message "[$($MyInvocation.MyCommand.Name)] Starting the changelog conversion process..." "Blue" -level 1

function checkChangeCategory {
    param (
        [PSCustomObject]$changeCategorys,
        [string]$line
    )

    $res = [PSCustomObject]@{
        found = $false
        name = ""
    }

    foreach($category in $changeCategorys) {
        if($category.name -eq "__default") {
            continue # Skip the default category (used as fallback)
        }

        if(($line -replace '[^a-zA-Z0-9 ]', '').Trim() -match $category."name-pattern") { 
            $res.found = $true
            $res.name = $category.name

            break
        }
    }

    return $res
}

# Load and parse changelog configuration
try {
    $config = (Get-Content -Path $configPath -Raw | ConvertFrom-Json).$changelogName
} catch {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Error: Failed to load or parse the changelog configuration file '$configPath'." "Red" -level 1

    return
}

# Retrieve the raw changelog from the configured URL
try {
    $changelogRaw = Invoke-WebRequest -Uri $config."changelog-url" -UseBasicParsing | Select-Object -ExpandProperty Content
} catch {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Error: Failed to retrieve the changelog from the URL '$($config.'changelog-url')'. Please check the URL and network connectivity." "Red" -level 1
    
    return
}

$changelog = @() # Initialize the processed changelog array
$entry = New-Object PSObject
$entryType = $null # Type of the current entry being processed
$regexs = $config."regex-patterns" # Retrieve regex patterns from config
$curentVersion = ""

foreach($line in ($changelogRaw -split "\n")) {
    $line = ($line -replace "[\r\n;]", "").Trim() # Clean up the line

    if($line -eq "") {
        continue # Skip empty lines
    } 

    # Check if the line matches a change category
    $changeCategoryInfo = checkChangeCategory $regexs."change-categories" $line
    
    if($line -match $regexs."version-line") { # Check if $line is version
        $curentVersion = (($line -match $regexs.version) | Out-Null) + $matches[0]
        
        # Skip entries outside the specified version range
        if(!($maxVersion -eq "latest") -and !(checkVersionMax -version $curentVersion -maxVersion $maxVersion)) {
            $entry = New-Object PSObject
            continue
        }
        
        if(!($minVersion -eq "oldest") -and !(checkVersionMin -version $curentVersion -minVersion $minVersion)) {
            break
        }
        
        # Add completed entry to the changelog
        if(($entry.PSObject.Properties.Value.Count -gt 1) -and ($null -ne $entry.PSObject.Properties["version"])) {
            $changelog += $entry
        }

        # Initialize a new entry for this version
        $entry = New-Object PSObject
        $entry | Add-Member -Type NoteProperty -Name "version" -Value $curentVersion

    } elseif($changeCategoryInfo.found) { # Check if $line is a change category
        $entryType = $changeCategoryInfo.name

    } else { # Change row
        if(!(checkMatch -inputString $line -patterns $scopes)){
            continue # Skip lines not matching the scope
        }

        if(checkMatch -inputString $line -patterns $regexs.ignore){
            continue # Skip ignored lines
        }

        $log = New-Object PSObject
        $defaultPattern = $regexs."change-categories"[0]

        # Process "special" patterns first
        foreach($special in $regexs.specials) {
            if($line -match $special) {
                $log | Add-Member -Type NoteProperty -Name "name" -Value ""
                $log | Add-Member -Type NoteProperty -Name "description" -Value $line
                
                break
            }
        }
        
        # Process "change categories" patterns
        if($log.PSObject.Properties.Value.Count -eq 0) {
            foreach($change in $regexs."change-categories") {
                if($change.name -eq "__default") {
                    continue
                }

                if($entryType -eq $change.name) {
                    $patterns = ($change."default-pattern" -eq $true) ? $defaultPattern.patterns : $change.patterns

                    $nameMatchPattern = $patterns.match?.name ?? ""
                    $descriptionMatchPattern = $patterns.match?.description ?? ""
                    $nameReplacePattern = $patterns.replace?.name ?? ""
                    $descriptionReplacePattern = $patterns.replace?.description ?? ""
                
                    $name = ((($line -match $nameMatchPattern | Out-Null) + $matches[0]) -replace $nameReplacePattern, "")
                    $description = ((($line -match $descriptionMatchPattern | Out-Null) + $matches[0]) -replace $descriptionReplacePattern, "")
                
                    $log | Add-Member -Type NoteProperty -Name "name" -Value $name
                    $log | Add-Member -Type NoteProperty -Name "description" -Value $description

                    break
                }
            }
        }

        if($strictScope -and !(checkMatch -inputString $log.name -patterns $scopes)) {
            continue
        }

        if($null -ne $entry.$entryType) {
            $entry.$entryType += $log

        }else {
            $entry | Add-Member -Type NoteProperty -Name $entryType -Value @($log)
        
        }
    }
    
}

$changelog += $entry # Add the last entry

# Log positive message if changelog was successfully extracted
if($changelog.Count -gt 0) {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Success: Changelog extracted successfully" "Green" -level 1
} else {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Warning: No entries were found for the changelog." "Yellow" -level 1
}

return $changelog