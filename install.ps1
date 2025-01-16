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

    # Set the URL for Visual Studio 2022 (you can change this to other versions if necessary)
    $url = "https://aka.ms/vs/17/release/vs_installer.exe"
    
    $installerPath = Join-Path -Path $env:TEMP -ChildPath 'vs_installer.exe'

    Write-Host "Downloading Visual Studio installer from $url..."

    try {
        # Download the file and check if the response is successful
        $response = Invoke-WebRequest -Uri $url -OutFile $installerPath -ErrorAction Stop

        if ($response.StatusCode -ne 200) {
            Write-Error "Failed to download Visual Studio installer. HTTP Status: $($response.StatusCode)"
            exit
        }
    } catch {
        Write-Error "Failed to download Visual Studio installer: $_"
    }

    # Check if the installer exists and has a valid file size
    if (-not (Test-Path $installerPath)) {
        Write-Error "Installer not downloaded successfully."
    }

    $fileSize = (Get-Item $installerPath).length
    Write-Host "Downloaded installer size: $fileSize bytes"
    
    if ($fileSize -lt 1000000) {  # Minimum size check (1MB)
        Write-Error "The installer file appears to be corrupted or incomplete. File size: $fileSize bytes."
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
