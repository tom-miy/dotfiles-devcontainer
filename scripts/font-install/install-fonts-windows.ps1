# MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica Font Auto Installer for Windows
# Run PowerShell as Administrator

param(
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica Font Installer for Windows" -ForegroundColor Cyan
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
    # MesloLGS NF fonts
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
    },
    # HackGen fonts
    @{
        Name = "HackGen Regular"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGen-Regular.ttf"
        FileName = "HackGen-Regular.ttf"
    },
    @{
        Name = "HackGen Bold"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGen-Bold.ttf"
        FileName = "HackGen-Bold.ttf"
    },
    @{
        Name = "HackGen35 Regular"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGen35-Regular.ttf"
        FileName = "HackGen35-Regular.ttf"
    },
    @{
        Name = "HackGen35 Bold"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGen35-Bold.ttf"
        FileName = "HackGen35-Bold.ttf"
    },
    @{
        Name = "HackGenNerd Regular"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGenNerd-Regular.ttf"
        FileName = "HackGenNerd-Regular.ttf"
    },
    @{
        Name = "HackGenNerd Bold"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGenNerd-Bold.ttf"
        FileName = "HackGenNerd-Bold.ttf"
    },
    @{
        Name = "HackGenNerd35 Regular"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGenNerd35-Regular.ttf"
        FileName = "HackGenNerd35-Regular.ttf"
    },
    @{
        Name = "HackGenNerd35 Bold"
        Url = "https://github.com/yuru7/HackGen/releases/latest/download/HackGenNerd35-Bold.ttf"
        FileName = "HackGenNerd35-Bold.ttf"
    },
    # UDEV Gothic fonts
    @{
        Name = "UDEVGothic Regular"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothic-Regular.ttf"
        FileName = "UDEVGothic-Regular.ttf"
    },
    @{
        Name = "UDEVGothic Bold"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothic-Bold.ttf"
        FileName = "UDEVGothic-Bold.ttf"
    },
    @{
        Name = "UDEVGothic Italic"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothic-Italic.ttf"
        FileName = "UDEVGothic-Italic.ttf"
    },
    @{
        Name = "UDEVGothic BoldItalic"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothic-BoldItalic.ttf"
        FileName = "UDEVGothic-BoldItalic.ttf"
    },
    @{
        Name = "UDEVGothicNF Regular"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothicNF-Regular.ttf"
        FileName = "UDEVGothicNF-Regular.ttf"
    },
    @{
        Name = "UDEVGothicNF Bold"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothicNF-Bold.ttf"
        FileName = "UDEVGothicNF-Bold.ttf"
    },
    @{
        Name = "UDEVGothicNF Italic"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothicNF-Italic.ttf"
        FileName = "UDEVGothicNF-Italic.ttf"
    },
    @{
        Name = "UDEVGothicNF BoldItalic"
        Url = "https://github.com/yuru7/udev-gothic/releases/latest/download/UDEVGothicNF-BoldItalic.ttf"
        FileName = "UDEVGothicNF-BoldItalic.ttf"
    },
    # Moralerspace fonts
    @{
        Name = "Moralerspace Regular"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace-Regular.ttf"
        FileName = "Moralerspace-Regular.ttf"
    },
    @{
        Name = "Moralerspace Bold"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace-Bold.ttf"
        FileName = "Moralerspace-Bold.ttf"
    },
    @{
        Name = "Moralerspace Italic"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace-Italic.ttf"
        FileName = "Moralerspace-Italic.ttf"
    },
    @{
        Name = "Moralerspace BoldItalic"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/Moralerspace-BoldItalic.ttf"
        FileName = "Moralerspace-BoldItalic.ttf"
    },
    @{
        Name = "MoralerspaceNF Regular"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/MoralerspaceNF-Regular.ttf"
        FileName = "MoralerspaceNF-Regular.ttf"
    },
    @{
        Name = "MoralerspaceNF Bold"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/MoralerspaceNF-Bold.ttf"
        FileName = "MoralerspaceNF-Bold.ttf"
    },
    @{
        Name = "MoralerspaceNF Italic"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/MoralerspaceNF-Italic.ttf"
        FileName = "MoralerspaceNF-Italic.ttf"
    },
    @{
        Name = "MoralerspaceNF BoldItalic"
        Url = "https://github.com/yuru7/moralerspace/releases/latest/download/MoralerspaceNF-BoldItalic.ttf"
        FileName = "MoralerspaceNF-BoldItalic.ttf"
    },
    # Cica fonts
    @{
        Name = "Cica Regular"
        Url = "https://github.com/miiton/Cica/releases/latest/download/Cica-Regular.ttf"
        FileName = "Cica-Regular.ttf"
    },
    @{
        Name = "Cica Bold"
        Url = "https://github.com/miiton/Cica/releases/latest/download/Cica-Bold.ttf"
        FileName = "Cica-Bold.ttf"
    },
    @{
        Name = "Cica RegularItalic"
        Url = "https://github.com/miiton/Cica/releases/latest/download/Cica-RegularItalic.ttf"
        FileName = "Cica-RegularItalic.ttf"
    },
    @{
        Name = "Cica BoldItalic"
        Url = "https://github.com/miiton/Cica/releases/latest/download/Cica-BoldItalic.ttf"
        FileName = "Cica-BoldItalic.ttf"
    }
)

# Font folder path
$fontsFolder = [Environment]::GetFolderPath("Fonts")

# Check existing fonts
$installedMeslo = Get-ChildItem -Path $fontsFolder -Filter "*MesloLGS*" -ErrorAction SilentlyContinue
$installedHackGen = Get-ChildItem -Path $fontsFolder -Filter "*HackGen*" -ErrorAction SilentlyContinue
$installedUDEV = Get-ChildItem -Path $fontsFolder -Filter "*UDEV*" -ErrorAction SilentlyContinue
$installedMoralerspace = Get-ChildItem -Path $fontsFolder -Filter "*Moralerspace*" -ErrorAction SilentlyContinue
$installedCica = Get-ChildItem -Path $fontsFolder -Filter "*Cica*" -ErrorAction SilentlyContinue

$hasExistingFonts = ($installedMeslo.Count -gt 0) -or ($installedHackGen.Count -gt 0) -or ($installedUDEV.Count -gt 0) -or ($installedMoralerspace.Count -gt 0) -or ($installedCica.Count -gt 0)

if ($hasExistingFonts -and -not $Force) {
    Write-Host "Fonts are already installed:" -ForegroundColor Green
    if ($installedMeslo.Count -gt 0) {
        Write-Host "  MesloLGS NF fonts:" -ForegroundColor White
        $installedMeslo | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor Gray }
    }
    if ($installedHackGen.Count -gt 0) {
        Write-Host "  HackGen fonts:" -ForegroundColor White
        $installedHackGen | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor Gray }
    }
    if ($installedUDEV.Count -gt 0) {
        Write-Host "  UDEV Gothic fonts:" -ForegroundColor White
        $installedUDEV | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor Gray }
    }
    if ($installedMoralerspace.Count -gt 0) {
        Write-Host "  Moralerspace fonts:" -ForegroundColor White
        $installedMoralerspace | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor Gray }
    }
    if ($installedCica.Count -gt 0) {
        Write-Host "  Cica fonts:" -ForegroundColor White
        $installedCica | ForEach-Object { Write-Host "     - $($_.Name)" -ForegroundColor Gray }
    }
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
    Write-Host "  2. Add one of these to settings.json:" -ForegroundColor White
    Write-Host '     "terminal.integrated.fontFamily": "MesloLGS NF"        # Powerlevel10k用' -ForegroundColor Gray
    Write-Host '     "terminal.integrated.fontFamily": "HackGenNerd"        # 日本語対応' -ForegroundColor Gray
    Write-Host '     "terminal.integrated.fontFamily": "UDEVGothicNF"      # モダンな日本語対応' -ForegroundColor Gray
    Write-Host '     "terminal.integrated.fontFamily": "MoralerspaceNF"    # スタイリッシュな日本語対応' -ForegroundColor Gray
    Write-Host '     "terminal.integrated.fontFamily": "Cica"              # シンプルな日本語対応' -ForegroundColor Gray
    Write-Host "  3. Rebuild your devcontainer" -ForegroundColor White
} else {
    Write-Host "Some fonts failed to install ($successCount/$totalCount)" -ForegroundColor Yellow
    Write-Host "Please try manual installation." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"