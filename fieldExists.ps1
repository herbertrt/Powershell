param (
    [string]$folderPath,
    [string]$fieldName
)

# Check if the folder exists
if (-Not (Test-Path -Path $folderPath)) {
    Write-Host "The specified folder does not exist."
    exit
}

# Get all NDJSON files in the folder
$ndjsonFiles = Get-ChildItem -Path $folderPath -Filter *

# Initialize a flag to track if any row is missing the specified field
$missingFieldFound = $false

foreach ($file in $ndjsonFiles) {
    # Read each line in the NDJSON file
    $lines = Get-Content -Path $file.FullName
    foreach ($line in $lines) {
        # Convert the line from JSON
        $jsonObject = $line | ConvertFrom-Json
        if (-Not $jsonObject.PSObject.Properties[$fieldName]) {
            Write-Host "Missing field '$fieldName' in file: $($file.FullName)"
            $missingFieldFound = $true
            break
        }
    }
}

if (-Not $missingFieldFound) {
    Write-Host "All rows contain the field '$fieldName'."
}