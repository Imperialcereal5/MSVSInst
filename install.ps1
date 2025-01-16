param (
    [Parameter(Mandatory)]
    [string]$VisualStudioVersion = 'latest',

    [Parameter(Mandatory)]
    [string]$InstallDrive = 'C:'
)

# Function to download the Visual Studio installer
function Download-VisualStudioInstaller {
    param (
        [string]$Version
    )

    # Direct URL to the Visual Studio installer for the latest version (change for specific versions)
    $url = "https://aka.ms/vs/17/release/vs_installer.exe"
    
    $installerPath = Join-Path -Path $env:TEMP -ChildPath 'vs_installer.exe'

    Write-Host "Downloading Visual Studio installer from $url..."

    try {
        Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop
    } catch {
        Write-Error "Failed to download Visual Studio installer: $_"
        exit
    }

    # Check if the installer exists and has a valid file size
    if (-not (Test-Path $installerPath)) {
        Write-Error "Installer not downloaded successfully."
        exit
    }

    $fileSize = (Get-Item $installerPath).length
    if ($fileSize -lt 1000000) {  # Minimum size check (1MB)
        Write-Error "The installer file appears to be corrupted or incomplete. File size: $fileSize bytes."
        exit
    }

    Write-Host "Installer downloaded successfully to $installerPath"
    return $installerPath
}
# Function to install Visual Studio
function Install-VisualStudio {
    param (
        [string]$InstallerPath,
        [string]$InstallDrive
    )

    Write-Host "Starting Visual Studio installation to $InstallDrive..."

    # Custom installation path, assuming Visual Studio will accept the path argument
    $installPath = Join-Path -Path $InstallDrive -ChildPath 'VisualStudio'

    # Install Visual Studio with the specified path
    Start-Process -FilePath $InstallerPath -ArgumentList "--quiet --wait --path $installPath" -Wait

    Write-Host "Visual Studio installation completed."
}

# Download and install Visual Studio
$installerPath = Download-VisualStudioInstaller -Version $VisualStudioVersion
Install-VisualStudio -InstallerPath $installerPath -InstallDrive $InstallDrive
