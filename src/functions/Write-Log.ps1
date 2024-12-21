function Write-Log {
    param(
        [string]$message,
        [string]$color,
        [int]$level
    )
    
    # Create indentation based on the level provided (e.g., for nested log entries)
    $tab = "`t" * $level
    $timestamp = Get-Date -Format "[MM/dd/yyyy HH:mm:ss]"

    # Print the log message with timestamp, indentation, and color
    Write-Host "$timestamp$($tab) - $message" -ForegroundColor $color
}