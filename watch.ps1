$IN_DIR = "/files-in"
$OUT_DIR = "/files-out"

$previous_file_name = $null

if ($IN_DIR -eq $OUT_DIR) {
    throw "In- and out-dir are the same: $IN_DIR"
}

inotifywait -q -m -e CLOSE_WRITE $IN_DIR | Foreach-Object {
    $parts = $_.Split(" ")

    if ($parts.Count -ne 3) {
        throw "Could not process event $_ - Does the file name contain spaces?"
    }

    $file_name = $parts[2]

    Write-Information "Got $file_name`: $parts"
    if ([System.IO.Path]::GetExtension($file_name) -eq ".pdf") {   
        if ($previous_file_name -eq $null) {
            $previous_file_name = $file_name
        } else {
            $out_file = Join-Path $OUT_DIR $previous_file_name
            $file_name = Join-Path $IN_DIR $file_name
            $previous_file_name = Join-Path $IN_DIR $previous_file_name

            Write-Information "Executing pdftk A=$previous_file_name B=$file_name shuffle A Bend-1 output $out_file"
            # todo does not ask before overwriting
            pdftk A=$previous_file_name B=$file_name shuffle A Bend-1 output $out_file

            if (-not $?) {
                throw "pdftk errored; exiting."
            }
            Remove-Item $file_name, $previous_file_name
            $previous_file_name = $null
        }
    } else {
        Write-Warning "Expected .pdf file, got $file_name. Skipping."
    }
}
