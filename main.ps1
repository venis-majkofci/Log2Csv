# Import helper functions
try {
    . .\src\functions\Write-Log.ps1
} catch {
    Write-Error "[$($MyInvocation.MyCommand.Name)] Error: Failed to import helper functions. Please check the file paths and try again."
    return
}

# Set parameters
$changelogName = "azurerm-v3"
$maxVersion = "latest"
$minVersion = "oldest"
$scopes = @("")

Write-Log -message "[$($MyInvocation.MyCommand.Name)] Starting the changelog extraction process for changelog '$changelogName'..." "Blue" -level 0

try {
    # Convert changelog
    $changelog = .\src\Convert-Changelog.ps1 -changelogName $changelogName -scopes $scopes -maxVersion $maxVersion -minVersion $minVersion -strictScope $false

    # Export changelog to CSV
    .\src\Export-ChangelogCSV.ps1 -changelog $changelog -changelogName $changelogName
    
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Changelog successfully exported." "Green" -level 0

} catch {
    Write-Log -message "[$($MyInvocation.MyCommand.Name)] Error: An issue occurred during the process - $_" "Red" -level 0

}