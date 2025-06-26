# MesloLGS NF Font Auto Installer for Windows
# Run PowerShell as Administrator

param(
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "MesloLGS NF Font Installer for Windows" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Check Administrator privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "This script requires Administrator privileges."
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Font URL definitions
$urls = @(
    @{
        Name = "MesloLGS NF Regular"
        Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        FileName = "MesloLGS NF Regular.ttf"
    },
    @{
        Name = "MesloLGS NF Bold"
        Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        FileName = "MesloLGS NF Bold.ttf"
    },
    @{
        Name = "MesloLGS NF Italic"
        Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        FileName = "MesloLGS NF Italic.ttf"
    },
    @{
        Name = "MesloLGS NF Bold Italic"
        Url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
        FileName = "MesloLGS NF Bold Italic.ttf"
    }
)

# Font folder path
$fontsFolder = [Environment]::GetFolderPath("Fonts")

# Check existing fonts
$installedFonts = Get-ChildItem -Path $fontsFolder -Filter "*MesloLGS*" -ErrorAction SilentlyContinue

if ($installedFonts.Count -gt 0 -and -not $Force) {
    Write-Host "MesloLGS NF fonts are already installed:" -ForegroundColor Green
    $installedFonts | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor Gray }
    Write-Host ""
    $choice = Read-Host "Do you want to reinstall? (y/N)"
    if ($choice -notmatch "^[yY]$") {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "Downloading and installing fonts..." -ForegroundColor Green
Write-Host ""

$successCount = 0
$totalCount = $urls.Count

foreach ($font in $urls) {
    try {
        Write-Host "Downloading $($font.Name)..." -ForegroundColor Yellow
        
        # Temporary file path
        $tempFile = Join-Path $env:TEMP $font.FileName
        
        # Download
        Invoke-WebRequest -Uri $font.Url -OutFile $tempFile -UseBasicParsing
        
        Write-Host "Installing $($font.Name)..." -ForegroundColor Yellow
        
        # Install font
        $shell = New-Object -ComObject Shell.Application
        $fontsFolderShell = $shell.Namespace(0x14)
        $fontsFolderShell.CopyHere($tempFile, 0x10 + 0x4)
        
        # Remove temporary file
        Remove-Item $tempFile -Force
        
        Write-Host "Successfully installed $($font.Name)." -ForegroundColor Green
        $successCount++
        
    } catch {
        Write-Error "Failed to install $($font.Name): $($_.Exception.Message)"
    }
    
    Write-Host ""
}

Write-Host "======================================" -ForegroundColor Cyan
if ($successCount -eq $totalCount) {
    Write-Host "All fonts ($successCount/$totalCount) installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart VS Code/Cursor" -ForegroundColor White
    Write-Host "  2. Add this to settings.json:" -ForegroundColor White
    Write-Host '     "terminal.integrated.fontFamily": "MesloLGS NF"' -ForegroundColor Gray
    Write-Host "  3. Rebuild your devcontainer" -ForegroundColor White
} else {
    Write-Host "Some fonts failed to install ($successCount/$totalCount)" -ForegroundColor Yellow
    Write-Host "Please try manual installation." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"