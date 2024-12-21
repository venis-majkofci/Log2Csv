# Function to check if the input string matches any pattern in the provided list.
function checkMatch {
    param (
        [string]$inputString,
        [string[]]$patterns
    )
        
    foreach($pattern in $patterns){
        if($inputString -match $pattern){
            return $true
        }
    }

    return $false
}
