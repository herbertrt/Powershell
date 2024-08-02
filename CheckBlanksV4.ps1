param (
    [string]$folderPath,
    [string]$fieldName,
    [string[]]$outputFields
)

# Function to check if a field is blank and output specific fields
function Check-BlankField {
    param (
        [string]$filePath,
        [string]$fieldName,
        [string[]]$outputFields
    )

    $hasBlankField = $false
    $lines = Get-Content -Path $filePath

    foreach ($line in $lines) {
        $jsonObject = $line | ConvertFrom-Json
        if ($null -eq $jsonObject.$fieldName -or $jsonObject.$fieldName -eq "") {
            $hasBlankField = $true
            $outputRecord = @{}
            foreach ($field in $outputFields) {
                $outputRecord[$field] = $jsonObject.$field
            }
            #Write-Host "Blank field found in file '$filePath':"
            Write-Host ($outputRecord | ConvertTo-Json -Compress)
        }
    }

    #return $hasBlankField
}

Write-Output "Start"
# Get all NDJSON files in the specified folder
$ndjsonFiles = Get-ChildItem -Path $folderPath -Filter interaction-*
Write-Output "Got Files"


foreach ($file in $ndjsonFiles) {
    $result = Check-BlankField -filePath $file.FullName -fieldName $fieldName -outputFields $outputFields
    if ($result) {
        #Write-Output "File '$($file.Name)' contains records with a blank '$fieldName' field."
    } else {
        #Write-Output "File '$($file.Name)' does not contain any records with a blank '$fieldName' field."
    }
}