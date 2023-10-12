Import-Module -Name Terminal-Icons

Remove-Alias -Name rm

Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Blue
    "Parameter" = [ConsoleColor]::White
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::DarkBlue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}

function np {
    $FileNameArray = $args -split " " 
    foreach( $FileName in $FileNameArray) {
        notepad.exe $FileName
    }
}

function rm {
    $FileNameArray = $args -split " " 
    foreach( $FileName in $FileNameArray) {
        Remove-Item $FileName
    }
}

function Update-Path {
    $newUserPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
    $newSystemPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
    $newPath = $newUserPath + $newSystemPath
    $Env:Path = $newPath
}

function Prompt {
    Update-Path
    
    Write-Host "(" -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Green -NoNewline
    Write-Host "@" -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Cyan -NoNewline
    Write-Host ")[" -NoNewline
    Write-Host $PWD -ForegroundColor Black -NoNewline
    Write-Host "]->" -NoNewline
    return " "
}