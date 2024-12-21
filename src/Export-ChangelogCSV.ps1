[CmdletBinding()]

param (
    [Parameter(Mandatory=$true)] [PSObject]$changelog,
    [Parameter(Mandatory=$true)] [string]$changelogName,
    [Parameter(Mandatory=$false)] [string]$outputDir = ".\output\",
    [Parameter(Mandatory=$false)] [string]$csvSeparator = "^",
    [Parameter(Mandatory=$false)] [string]$configPath = ".\config\csv-config.json"
)

# Import helper functions
try {
    . .\src\functions\Write-Log.ps1
} catch {
    Write-Error "[$($MyInvocation.MyCommand.Name)] Error: Failed to import helper functions. Please check the file paths and try again."
    return
}

Write-Log -message "[$($MyInvocation.MyCommand.Name)] Starting the CSV export process..." "Blue" -level 1

try{
    # Load and parse the CSV configuration file
    $config = (Get-Content -Path $configPath -Raw | ConvertFrom-Json)
    $columns = $config."columns-names"

    # Initialize an array to hold the CSV data
    $csvData = @()

    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Processing changelog entries..." "Blue" -level 1

    foreach($entry in $changelog){
        $version = $entry.version
        
        foreach($property in $entry.PSObject.Properties){
            $key = $property.Name

            if($key -ne "version"){ # Skip the version property    
                $records = $entry.$key
                
                foreach($record in $records){
                    $csvData += [PSCustomObject]@{
                        ($columns.version -replace "\$csvSeparator", "")       = ($version -replace "\$csvSeparator", "")
                        ($columns."update-type" -replace "\$csvSeparator", "") = ($key -replace "\$csvSeparator", "")
                        ($columns.resource -replace "\$csvSeparator", "")      = ($record.name -replace "\$csvSeparator", "")
                        ($columns.description -replace "\$csvSeparator", "")   = ($record.description -replace "\$csvSeparator", "")
                    }
                }
            }
        }

    }

    # Generate a unique output CSV file name
    $outputCsvPath = "$($outputDir)$($config."file-prefix")-$($changelogName)-$("{0:D4}" -f (Get-Random -Minimum 0 -Maximum 10000)).csv"

    # Ensure the output directory exists
    if(-not (Test-Path -Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory | Out-Null
    }

    # Export the CSV data to the output file
    $csvData | Export-Csv -Path $outputCsvPath -NoTypeInformation -Force -Delimiter "^"

    # Add the separator prefix to the CSV content
    $csvContent = Get-Content -Path $outputCsvPath -Raw
    ("sep=$csvSeparator`r") + $csvContent | Set-Content -Path $outputCsvPath

    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Changelog CSV export completed successfully. Rows: $($csvData.Count). Path: '$outputCsvPath'" "Green" -level 1

} catch {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Error: An issue occurred during the CSV export process - $_" "Red" -level 1
    
}