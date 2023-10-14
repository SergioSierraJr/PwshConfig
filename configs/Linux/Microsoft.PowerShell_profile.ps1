# skip to last line(s) for init

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
    if(-not (Test-Path $pathToXml)){
        return
    }

    $xmlData = [xml](Get-Content $pathToXml)
    foreach($selectedPath in $xmlData.ExtraPaths) {
        if($selectedPath.Path -notin $Env:PATH.Split(":")){
            $Env:PATH += ":"+$selectedPath.Path
        }
    }
}

function AddPath {
    $pathToXml = $HOME+"/.config/powershell/ExtraPaths.xml"

    if(-not (Test-Path $pathToXml)){
        Write-Host "AddPath: Creating ExtraPaths.xml file"
        New-Item $pathToXml | Out-Null

        $xmlCreation = New-Object System.Xml.XmlDocument
        $xmlCreation.AppendChild($xmlCreation.CreateXmlDeclaration("1.0", "UTF-8", $Null)) | Out-Null
        $xmlCreation.AppendChild($xmlCreation.CreateElement("ExtraPaths")) | Out-Null
        $xmlCreation.Save($pathToXml)  
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
            Write-Host "AddPath: Error $currentPath is already in path"
            continue
        }
        if($currentPath -eq ""){
            continue
        }
        if(-not (Test-Path $currentPath)) {
            Write-Host "AddPath: Error $currentPath is not a valid path"
            continue
        }
        $parentElement = $xmlData.SelectSingleNode("ExtraPaths")
        $textElement = $xmlData.CreateElement("Path")
        $textElement.InnerText = $currentPath
        $parentElement.AppendChild($textElement) | Out-Null
    }
    $xmlData.Save($pathToXml)
    RefreshPath
}

function ls {
    exa -l --no-permissions $args
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

RefreshPath
