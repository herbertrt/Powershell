Function DeGZip-File{
    Param(
        $infile,
        $outfile       
        )

    $input = New-Object System.IO.FileStream $inFile, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
    $output = New-Object System.IO.FileStream $outFile, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
    $gzipStream = New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress)

    $buffer = New-Object byte[](1024)
    while($true){
        $read = $gzipstream.Read($buffer, 0, 1024)
        if ($read -le 0){break}
        $output.Write($buffer, 0, $read)
        }

    $gzipStream.Close()
    $output.Close()
    $input.Close()
}

$infile="C:\Users\hthevasagayam\Downloads\interaction-0-pegarealtime5bd9b9c59bkvg8w2781720712751471-20240711154452_498.json"
$outfile="C:\Users\hthevasagayam\Downloads\out\UATinteraction-0-pegarealtime5bd9b9c59bkvg8w2781720712751471-20240711154452_498"

DeGZip-File $infile $outfile