$ConfigContent = @"
[init]
    defaultBranch = main
[user]
    email = toreorheim@gmail.com
    name = Tore Orheim
[core]
    editor = nvim
    sshCommand = C:/Windows/System32/OpenSSH/ssh.exe
[fetch]
    prune = true
[alias]
    c = commit -m
    ca = commit -am
    sts = status
    sw = switch
    a = add
[status]
    short = true
"@

$GitConfigPath = "$env:USERPROFILE\.gitconfig"
Set-Content -Path $GitConfigPath -Value $ConfigContent

if (Test-Path $GitConfigPath -PathType Leaf) {
    Write-Host "The .gitconfig file has been generated."
} else {
    Write-Host "There was an issue generating the .gitconfig file."
}


