$htmlTemplate = Get-Content -Raw _subject.template

function main{
    $subjectRoot = Join-Path subject-guide -ChildPath tex | Join-Path -ChildPath courses | Join-Path -ChildPath subjects  
    Get-ChildItem $subjectRoot | ForEach-Object {
        $itemMap = @()
        $file = Get-Content -Raw (Join-Path $subjectRoot -ChildPath $_)
        $itemMap = parse $file
        save $itemMap
        makeIndex
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
        $itemMap
    )
    $jsonPath = Join-Path '_data' -ChildPath ($itemMap.code + '.json')
    $htmlPath = Join-Path 'subjects' -ChildPath ($itemMap.code + '.html')
    ConvertTo-Json $itemMap | Out-File $jsonPath -Encoding ascii
    $htmlTemplate -f $itemMap.code | Out-File $htmlPath -Encoding ascii
}

function makeIndex{
    $indexTemplate = Get-Content -Raw _index.template
    $list = ""
    Get-ChildItem subjects | ForEach-Object {
        $list += "<tr><td><a href='subjects/$_'>" + $_.BaseName + "</a></td></tr>"
    }
    $indexTemplate -f $list | Out-File -Encoding ascii index.html
}

main