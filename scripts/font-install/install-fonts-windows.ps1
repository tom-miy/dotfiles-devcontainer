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

# Check for GitHub CLI
if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Warning "GitHub CLI (gh) is required but not installed."
    Write-Host "Please install GitHub CLI from https://cli.github.com/" -ForegroundColor Yellow
    Write-Host "Or use: winget install --id GitHub.cli" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Direct TTF downloads (MesloLGS NF)
$directFonts = @(
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

# ZIP font packages (Japanese fonts) - URLs will be updated dynamically
$zipFonts = @(
    @{
        Name = "HackGen"
        ZipUrl = ""  # Will be updated by GitHub CLI
        Fonts = @(
            "HackGen-Regular.ttf",
            "HackGen-Bold.ttf",
            "HackGen35-Regular.ttf",
            "HackGen35-Bold.ttf",
            "HackGenNerd-Regular.ttf",
            "HackGenNerd-Bold.ttf",
            "HackGenNerd35-Regular.ttf",
            "HackGenNerd35-Bold.ttf"
        )
    },
    @{
        Name = "UDEV Gothic"
        ZipUrl = ""  # Will be updated by GitHub CLI
        Fonts = @(
            "UDEVGothic-Regular.ttf",
            "UDEVGothic-Bold.ttf",
            "UDEVGothic-Italic.ttf",
            "UDEVGothic-BoldItalic.ttf",
            "UDEVGothicNF-Regular.ttf",
            "UDEVGothicNF-Bold.ttf",
            "UDEVGothicNF-Italic.ttf",
            "UDEVGothicNF-BoldItalic.ttf"
        )
    },
    @{
        Name = "Moralerspace"
        ZipUrl = ""  # Will be updated by GitHub CLI
        Fonts = @(
            "Moralerspace-Regular.ttf",
            "Moralerspace-Bold.ttf",
            "Moralerspace-Italic.ttf",
            "Moralerspace-BoldItalic.ttf",
            "MoralerspaceNF-Regular.ttf",
            "MoralerspaceNF-Bold.ttf",
            "MoralerspaceNF-Italic.ttf",
            "MoralerspaceNF-BoldItalic.ttf"
        )
    },
    @{
        Name = "Cica"
        ZipUrl = ""  # Will be updated by GitHub CLI
        Fonts = @(
            "Cica-Regular.ttf",
            "Cica-Bold.ttf",
            "Cica-RegularItalic.ttf",
            "Cica-BoldItalic.ttf"
        )
    }
)

# GitHub CLI function to get latest release URL
function Get-LatestReleaseUrl {
    param (
        [string]$Repo,
        [string]$Pattern
    )
    
    try {
        $assets = gh release view --repo $Repo --json assets | ConvertFrom-Json
        $matchingAsset = $assets.assets | Where-Object { $_.name -match $Pattern } | Select-Object -First 1
        
        if ($matchingAsset) {
            return $matchingAsset.url
        } else {
            Write-Warning "No asset matching pattern '$Pattern' found in $Repo"
            return $null
        }
    } catch {
        Write-Warning "Failed to get latest release from $Repo : $($_.Exception.Message)"
        return $null
    }
}

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
$totalCount = $directFonts.Count + ($zipFonts | ForEach-Object { $_.Fonts.Count } | Measure-Object -Sum).Sum

# Install direct TTF fonts (MesloLGS NF)
Write-Host "Installing MesloLGS NF fonts..." -ForegroundColor Cyan
foreach ($font in $directFonts) {
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

# Install ZIP font packages (Japanese fonts)
Write-Host "Getting latest release URLs using GitHub CLI..." -ForegroundColor Cyan

# Get latest release URLs dynamically
$latestHackGenUrl = Get-LatestReleaseUrl "yuru7/HackGen" "HackGen_v.*\.zip"
$latestUdevUrl = Get-LatestReleaseUrl "yuru7/udev-gothic" "UDEVGothic_v.*\.zip"
$latestMoralerspaceUrl = Get-LatestReleaseUrl "yuru7/moralerspace" "Moralerspace_v.*\.zip"
$latestCicaUrl = Get-LatestReleaseUrl "miiton/Cica" "Cica_v.*\.zip"

# Update URLs if we got them successfully
if ($latestHackGenUrl) { $zipFonts[0].ZipUrl = $latestHackGenUrl; Write-Host "✅ HackGen latest URL obtained" -ForegroundColor Green }
if ($latestUdevUrl) { $zipFonts[1].ZipUrl = $latestUdevUrl; Write-Host "✅ UDEV Gothic latest URL obtained" -ForegroundColor Green }
if ($latestMoralerspaceUrl) { $zipFonts[2].ZipUrl = $latestMoralerspaceUrl; Write-Host "✅ Moralerspace latest URL obtained" -ForegroundColor Green }
if ($latestCicaUrl) { $zipFonts[3].ZipUrl = $latestCicaUrl; Write-Host "✅ Cica latest URL obtained" -ForegroundColor Green }

if (!$latestHackGenUrl -or !$latestUdevUrl -or !$latestMoralerspaceUrl -or !$latestCicaUrl) {
    Write-Host "❌ Failed to obtain latest release URLs. Please check GitHub CLI configuration." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

foreach ($fontPackage in $zipFonts) {
    try {
        Write-Host "Installing $($fontPackage.Name) fonts..." -ForegroundColor Cyan
        
        # Temporary paths
        $tempZip = Join-Path $env:TEMP "$($fontPackage.Name -replace '\s','').zip"
        $tempExtractDir = Join-Path $env:TEMP "$($fontPackage.Name -replace '\s','')_extract"
        
        Write-Host "Downloading $($fontPackage.Name) package..." -ForegroundColor Yellow
        
        # Download ZIP
        Invoke-WebRequest -Uri $fontPackage.ZipUrl -OutFile $tempZip -UseBasicParsing
        
        Write-Host "Extracting $($fontPackage.Name) fonts..." -ForegroundColor Yellow
        
        # Extract ZIP
        if (Test-Path $tempExtractDir) {
            Remove-Item $tempExtractDir -Recurse -Force
        }
        Expand-Archive -Path $tempZip -DestinationPath $tempExtractDir -Force
        
        # Install each font from the package
        foreach ($fontFile in $fontPackage.Fonts) {
            try {
                # Find the font file in extracted directory (may be in subdirectories)
                $fontPaths = Get-ChildItem -Path $tempExtractDir -Name $fontFile -Recurse -ErrorAction SilentlyContinue
                
                if ($fontPaths) {
                    $fontPath = $fontPaths | Select-Object -First 1
                    $fullFontPath = Get-ChildItem -Path $tempExtractDir -Name $fontFile -Recurse | Select-Object -First 1 -ExpandProperty FullName
                    
                    Write-Host "Installing $fontFile..." -ForegroundColor Yellow
                    
                    # Install font
                    $shell = New-Object -ComObject Shell.Application
                    $fontsFolderShell = $shell.Namespace(0x14)
                    $fontsFolderShell.CopyHere($fullFontPath, 0x10 + 0x4)
                    
                    Write-Host "Successfully installed $fontFile." -ForegroundColor Green
                    $successCount++
                } else {
                    Write-Warning "Font file $fontFile not found in $($fontPackage.Name) package."
                }
            } catch {
                Write-Warning "Failed to install $fontFile from $($fontPackage.Name): $($_.Exception.Message)"
            }
        }
        
        # Cleanup
        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item $tempExtractDir -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-Host "Completed $($fontPackage.Name) installation." -ForegroundColor Green
        
    } catch {
        Write-Error "Failed to install $($fontPackage.Name) package: $($_.Exception.Message)"
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