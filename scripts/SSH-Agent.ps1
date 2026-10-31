git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
Set-Service ssh-agent -startuptype automatic
Start-Service ssh-agent