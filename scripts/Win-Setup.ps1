$homeDirectory = $env:USERPROFILE

# Define a list of tools to install
$toolsToInstall = @(
    "Microsoft.Powershell",
    "Mozilla.Firefox",
    "Git.Git"
    "OpenJS.NodeJS.LTS"
    "sharkdp.fd",
    "BurntSushi.ripgrep.MSVC",
    "Neovim.Neovim"
)
# Set the log file path
$logFolderPath = Join-Path -Path $PSScriptRoot -ChildPath "Logs"
$logFilePath = Join-Path -Path $logFolderPath -ChildPath "WinSetupLog.txt"
$failedInstallations = @()

# Create Log directory if it doesn't exist
if (-not (Test-Path -Path $logFolderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $logFolderPath | Out-Null
}

# Function to log messages to a file
function Write-Log {
    param (
        [string]$Message
    )

    $LogEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"
    $LogEntry | Out-File -Append -FilePath $logFilePath
}

# Loop through the list and install each tool
foreach ($tool in $toolsToInstall) {
    Write-Host "Installing $tool..."
    Write-Log "Installing $tool..."
    
    # Try to install the tool
    try {
        winget install --id $tool -e --source winget
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$tool installed successfully!"
            Write-Log "$tool installed successfully!"
        } else {
            $errorMessage = "Failed to install $tool. Exit code: $LASTEXITCODE"
            Write-Host "Error: $errorMessage"
            Write-Log "Error: $errorMessage"
            $failedInstallations += $tool
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Error: $errorMessage"
        Write-Log "Error: $errorMessage"
        $failedInstallations += $tool
        # You can choose to handle errors as needed, such as exiting the script or continuing with the next tool
    }
}

# Display a summary of failed installations
if ($failedInstallations.Count -gt 0) {
    Write-Host "Failed to install the following tools:"
    foreach ($failedTool in $failedInstallations) {
        Write-Host "- $failedTool"
    }
}


# Define an array of objects with source and destination paths
$linkPaths = @(
    @{ SourcePath = Join-Path $homeDirectory ".dotfiles\nvim"; DestinationPath = Join-Path $homeDirectory "AppData\Local\Nvim" },
    @{ SourcePath = Join-Path $homeDirectory ".dotfiles\.angular-config.json"; DestinationPath = Join-Path $homeDirectory ".angular-config.json"}
    # Add more objects as needed
)

# Loop through each object and create symbolic links
foreach ($link in $linkPaths) {
    $sourcePath = $link.SourcePath
    $destinationPath = $link.DestinationPath

    try {
        # Check if the source directory exists
        if (Test-Path -Path $sourcePath) {
            # Check if the destination already exists
            if (Test-Path -Path $destinationPath) {
                Write-Host "Symbolic link creation aborted. Destination '$destinationPath' already exists."
            } else {
                # Create the symbolic link
                New-Item -ItemType SymbolicLink -Path $destinationPath -Target $sourcePath -Force
                Write-Host "Symbolic link from $sourcePath to $destinationPath created successfully."
            }
        } else {
            Write-Host "Source '$sourcePath' does not exist. Please provide a valid source path."
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Error: $errorMessage"
    }
}


Write-Host "Script execution completed."
Write-Log "Script execution completed."

