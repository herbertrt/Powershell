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

# Initialize a hash set to store distinct values
$distinctValues = [System.Collections.Generic.HashSet[string]]::new()

foreach ($file in $ndjsonFiles) {
    # Read each line in the NDJSON file
	
    $lines = Get-Content -Path $file.FullName
    foreach ($line in $lines) {
        # Convert the line from JSON
        $jsonObject = $line | ConvertFrom-Json
		$value = $jsonObject.$fieldName
		$valueType = $value.GetType().Name
		$composite = "" + $value + ":" + $valueType
        if ($jsonObject.PSObject.Properties[$fieldName]) {
            if ($distinctValues.Add($composite)){
				Write-Host $file.FullName
				Write-Host $jsonObject.$fieldName
			}
        }
    }
}

Write-Host "~~~~"

# Output all distinct values
$distinctValues | ForEach-Object { Write-Host $_ }

# Output the number of distinct values
Write-Host "Number of distinct values: $($distinctValues.Count)"