$htmlTemplate = Get-Content -Raw _subject.template

function main{
    $subjectRoot = Join-Path subject-guide -ChildPath tex | Join-Path -ChildPath courses | Join-Path -ChildPath subjects  
    $allCourses = @()
    Get-ChildItem $subjectRoot | ForEach-Object {
        $itemMap = @()
        $file = Get-Content -Raw (Join-Path $subjectRoot -ChildPath $_)
        $itemMap = parse -fileName $file
        save -itemMap $itemMap
        $allCourses += @{$itemMap['code'] = $itemMap}
    }
    makeIndex -itemMap $allCourses
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
        $values = $values += ($_.ToString().trim("{", "}") -replace "\\item", "<li>" -replace "\\", "" -replace "  ", "" -replace "\r\n", "<br/>")
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
    Param(
        $itemMap
    )
    $content = ""
    $subjectFile = Join-Path subject-guide -ChildPath tex | Join-Path -ChildPath courses | Join-Path -ChildPath subjects.tex
    $pattern = [regex] "{([\s\S]*?)}"
    Get-Content $subjectFile | ForEach-Object {
        if ($_.StartsWith('\section')) {
            $pattern.Matches($_) | ForEach-Object {
                $_ = $_.ToString().trim("{", "}")
                $content += "<tr><td><b>$_</b><td></tr>"
            }
        } elseif ($_.StartsWith('\input')) {
            $pattern.Matches($_) | ForEach-Object {
                $_ = $_.ToString().trim("{", "}")
                $name = $_.Split('/')
                $code = $name[2]
                $content += "<tr><td><a href='subjects/" + $code + ".html'>" + $code + " - " + ($itemMap.Values | Where-Object {$_.code -eq $code}).title + "</a><td></tr>"
            }
        }
    }
    (Get-Content -Raw _index.template) -f $content | Out-File -Encoding ascii index.html
}

main