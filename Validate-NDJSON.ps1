## Usage Validate-NDJSON.ps1 <File-name>

$filename = $args[0]
$location = pwd
$path = Convert-Path $location.toString()
$fullpath = "$path\$filename"

$reader = [System.IO.File]::OpenText($fullpath)
$i = 1
while($null -ne ($line = $reader.ReadLine())) {
    try {
        $powershellRepresentation = ConvertFrom-Json $line -ErrorAction Stop;
        $validJson = $true;
    } catch {
        $validJson = $false;
    }
    
    if ($validJson) {
        Write-Host "Line $i - Provided text has been correctly parsed to JSON";
    } else {
        Write-Host "Line $i - Provided text is not a valid JSON string";
        Read-Host -Prompt "Press any key to continue"
    }
    $i++
}
