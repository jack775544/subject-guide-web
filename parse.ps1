#$file = Get-Content -Raw .\infs4205.tex

function main{
    Get-ChildItem .\subject-guide\tex\courses\subjects | ForEach-Object {
        $file = Get-Content -Raw $_
        $name = $_.BaseName
        $itemMap = parse $file
        save $itemMap, Join-Path 'subjects', $file + '.html'
    }    
}


function parse{
    Param(
        # The file to parsing the course data for
        [Parameter(Mandatory=$true)]
        [String]
        $fileName
    )
    # Extract out the key fields
    $keys = @()
    $keyPattern = [regex] "(.*?)="
    $keyPattern.Matches($file) | ForEach-Object {
        $keys = $keys += ($_.ToString().trim(" ", "="))
    }

    # Extract out the value fields
    $values = @()
    $pattern = [regex] "{([\s\S]*?)}"
    $pattern.Matches($file) | ForEach-Object {
        $values = $values += ($_.ToString().trim("{", "}") -replace "\\", "" -replace "  ", "" -replace "\r\n", "<br/>")
    }

    # Combine the arrays into an associative list
    $itemMap 
    for ($i = 0; $i -lt $keys.length; $i++){
        $itemMap += @{$keys[$i] = $values[$i]}
    }

    return $itemMap
}

function save{
    Param(
        # The parsed itemmap
        [Parameter(Mandatory=$true)]
        [String]
        $itemMap,
        # The filepath for the json output
        [parameter(Mandatory=$true)]
        [String]
        $filePath
    )
    ConvertTo-Json $itemMap | Out-File $filePath -Encoding ascii
}