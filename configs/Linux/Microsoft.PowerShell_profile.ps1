function PromptPwd {
    $pwd_dirs = $PWD.ToString().Split("/") | Select-Object -Skip 1
    if (("/" + $pwd_dirs[0] + "/" + $pwd_dirs[1]) -ne $HOME.ToString()) {
        return $PWD
    }
    
    $prompt_pwd = "~"

    foreach($current_dir in $pwd_dirs) {
        if($pwd_dirs.IndexOf($current_dir) -lt 2) {
            continue
        }
        $prompt_pwd += "/" + $current_dir[0]
    }

    return $prompt_pwd
}

function RefreshPath {
    $pathToXml = $HOME+"/.config/powershell/ExtraPaths.xml"
    $xmlData = [xml](Get-Content $pathToXml)
    Write-Host $currentPaths
    foreach($selectedPath in $xmlData.ExtraPaths) {
        if($selectedPath.Path -notin $Env:PATH.Split(":")){
            $Env:PATH += ":"+$selectedPath.Path
        }
    }
}

function AddPath {
    $pathToXml = $HOME+"/.config/powershell/ExtraPaths.xml"

    if((Test-Path $pathToXml -PathType Leaf) -ne "True"){
        Write-Host "Creating ExtraPaths file..."
        New-Item $pathToXml

        $xmlData = [xml](Get-Content $pathToXml)
        $xmlWriter = New-Object System.Xml.XmlTextWriter($pathToXml, $Null)

        $xmlWriter.Formatting = "Indented"
        $xmlWriter.Indentation = 1
        $xmlWriter.IndentChar = "`t"
        $xmlWriter.WriteStartDocument()

        $xmlWriter.WriteStartElement("ExtraPaths")

        $xmlWriter.WriteEndElement()

        $xmlWriter.WriteEndDocument()
        $xmlWriter.Flush()
        $xmlWriter.Close()
        
    }
    $xmlData = [xml](Get-Content $pathToXml)
    [string[]]$paths 
    
    foreach ($item in $args) {
        if($item -notin $paths){
            $paths += $item
        }
    }
 
    
    foreach($currentPath in $paths) {
        if($currentPath -in $xmlData.ExtraPaths.Path){
            Write-Host "AddPath: Error: $currentPath is already in path"
            continue
        }
        if($currentPath -eq ""){
            continue
        }
        if((Test-Path $currentPath) -ne "True") {
            Write-Host "AddPath: Error, $currentPath is not a valid path"
            continue
        }
        $parentElement = $xmlData.SelectSingleNode("//ExtraPaths")
        $textElement = $xmlData.CreateElement("Path")
        $textElement.InnerText = $currentPath
        $parentElement.AppendChild($textElement)
    }
    $xmlData.Save($pathToXml)
    RefreshPath
}

function Prompt {
    $prompt_pwd = PromptPwd
    $prompt_pwd = " " + $prompt_pwd
    Write-Host "[" -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Green -NoNewline
    Write-Host "@" -NoNewline
    Write-Host $env:HOSTNAME -ForegroundColor Cyan -NoNewline
    Write-Host $prompt_pwd -ForegroundColor Gray -NoNewline
    Write-Host "]->" -NoNewline
    return " "
}
