param (
    [Parameter(Mandatory)]
    [string]$VisualStudioVersion = 'latest'
)

# Function to download the Visual Studio installer
function Download-VisualStudioInstaller {
    param (
        [string]$Version
    )

    $url = "https://aka.ms/vs/$Version/install"
    $installerPath = Join-Path -Path $env:TEMP -ChildPath 'vs_installer.exe'

    Write-Host "Downloading Visual Studio installer..."
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    return $installerPath
}

# Function to install Visual Studio
function Install-VisualStudio {
    param (
        [string]$InstallerPath
    )

    Write-Host "Starting Visual Studio installation..."

    # Install Visual Studio with the default options
    Start-Process -FilePath $InstallerPath -ArgumentList "--quiet --wait" -Wait

    Write-Host "Visual Studio installation completed."
}

# Download and install Visual Studio
$installerPath = Download-VisualStudioInstaller -Version $VisualStudioVersion
Install-VisualStudio -InstallerPath $installerPath
