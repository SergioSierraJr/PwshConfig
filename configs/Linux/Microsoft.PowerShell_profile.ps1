$Env:PATH += ":"+"/home/sergios/.local/bin/"
$Env:PATH += ":"+"/home/sergios/.cargo/bin/"

function PromptPwd {
    $prompt_pwd
    $in_home 
    $pwd_dirs = $PWD.ToString().Split("/")

    if (("/" + $pwd_dirs[1] + "/" + $pwd_dirs[2]) -eq $HOME.ToString()) {
        $prompt_pwd += "~"
        $in_home = true
    }
    
    foreach($current_dir in $pwd_dirs) {
        
        if($in_home && $pwd_dirs.IndexOf($current_dir) -lt 3) {
            continue;
        }
        $prompt_pwd += "/" + $current_dir[0]
    }

    return $prompt_pwd
}

function ls {
    exa -l --no-permissions $args
}

function Prompt {
    $prompt_pwd = PromptPwd
    Write-Host "[" -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Green -NoNewline
    Write-Host "@" -NoNewline
    Write-Host $env:HOSTNAME -ForegroundColor Cyan -NoNewline
    Write-Host $prompt_pwd -ForegroundColor Gray -NoNewline
    Write-Host "]->" -NoNewline
    return " "
}
