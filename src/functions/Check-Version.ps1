# Function to check if the version is greater than or equal to the minimum version
function checkVersionMin {
    param (
        [string]$version,
        [string]$minVersion
    )

    # Convert the version strings to [version] type for comparison
    $v = [version]$version
    $min = [version]$minVersion

    if($v -ge $min){
        return $true
    }

    return $false
}

# Function to check if the version is less than or equal to the maximum version
function checkVersionMax {
    param (
        [string]$version,
        [string]$maxVersion
    )

    # Convert the version strings to [version] type for comparison
    $v = [version]$version
    $max = [version]$maxVersion

    if($v -le $max){
        return $true
    }

    return $false
}