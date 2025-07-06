# MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica フォントインストールスクリプト

Powerlevel10k で使用する MesloLGS NF フォント、日本語対応の HackGen フォント、モダンな日本語対応の UDEV Gothic フォント、スタイリッシュな日本語対応の Moralerspace フォント、およびシンプルな日本語対応の Cica フォントを自動インストールするスクリプト集です。

## 使用方法

### Windows

PowerShell を**管理者として**実行し、以下を実行：

```powershell
# リポジトリをクローン（まだの場合）
git clone https://github.com/tom-miy/dotfiles-devcontainer.git
cd dotfiles-devcontainer

# フォントインストール実行
.\scripts\font-install\install-fonts-windows.ps1
```

**強制再インストール**:
```powershell
.\scripts\font-install\install-fonts-windows.ps1 -Force
```

### macOS

ターミナルで以下を実行：

```bash
# リポジトリをクローン（まだの場合）
git clone https://github.com/tom-miy/dotfiles-devcontainer.git
cd dotfiles-devcontainer

# フォントインストール実行
bash scripts/font-install/install-fonts-macos.sh
```

**強制再インストール**:
```bash
bash scripts/font-install/install-fonts-macos.sh --force
```

### Linux

ターミナルで以下を実行：

```bash
# リポジトリをクローン（まだの場合）
git clone https://github.com/tom-miy/dotfiles-devcontainer.git
cd dotfiles-devcontainer

# フォントインストール実行
bash scripts/font-install/install-fonts-linux.sh
```

**強制再インストール**:
```bash
bash scripts/font-install/install-fonts-linux.sh --force
```

## インストール後の設定

フォントインストール後、VS Code/Cursor の `settings.json` に以下のいずれかを追加：

### MesloLGS NF（Powerlevel10k用）
```json
{
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Cascadia Code PL', monospace",
  "terminal.integrated.fontSize": 14
}
```

### HackGen（日本語対応）
```json
{
  "terminal.integrated.fontFamily": "'HackGenNerd', 'Cascadia Code PL', monospace",
  "terminal.integrated.fontSize": 14
}
```

### UDEV Gothic（モダンな日本語対応）
```json
{
  "terminal.integrated.fontFamily": "'UDEVGothicNF', 'Cascadia Code PL', monospace",
  "terminal.integrated.fontSize": 14
}
```

### Moralerspace（スタイリッシュな日本語対応）
```json
{
  "terminal.integrated.fontFamily": "'MoralerspaceNF', 'Cascadia Code PL', monospace",
  "terminal.integrated.fontSize": 14
}
```

### Cica（シンプルな日本語対応）
```json
{
  "terminal.integrated.fontFamily": "'Cica', 'Cascadia Code PL', monospace",
  "terminal.integrated.fontSize": 14
}
```

## トラブルシューティング

### Windows
- **管理者権限エラー**: PowerShell を右クリック → 「管理者として実行」
- **実行ポリシーエラー**: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### macOS
- **権限エラー**: `sudo` は使用せず、ユーザーフォントディレクトリ（`~/Library/Fonts/`）にインストール
- **フォントが認識されない**: アプリケーションを再起動

### Linux
- **curl/wget がない**: `sudo apt install curl` または `sudo yum install curl`
- **fc-cache がない**: `sudo apt install fontconfig`
- **フォントが認識されない**: ログアウト/ログインまたは再起動

## ファイル一覧

- `install-fonts-windows.ps1` - Windows用インストールスクリプト
- `install-fonts-macos.sh` - macOS用インストールスクリプト  
- `install-fonts-linux.sh` - Linux用インストールスクリプト
- `README.md` - このファイル

## 対象フォント

### MesloLGS NF（Powerlevel10k用）
以下の4つのフォントファイルがインストールされます：

- MesloLGS NF Regular.ttf
- MesloLGS NF Bold.ttf
- MesloLGS NF Italic.ttf
- MesloLGS NF Bold Italic.ttf

### HackGen（日本語対応）
以下の8つのフォントファイルがインストールされます：

- HackGen-Regular.ttf
- HackGen-Bold.ttf
- HackGen35-Regular.ttf
- HackGen35-Bold.ttf
- HackGenNerd-Regular.ttf
- HackGenNerd-Bold.ttf
- HackGenNerd35-Regular.ttf
- HackGenNerd35-Bold.ttf

### UDEV Gothic（モダンな日本語対応）
以下の8つのフォントファイルがインストールされます：

- UDEVGothic-Regular.ttf
- UDEVGothic-Bold.ttf
- UDEVGothic-Italic.ttf
- UDEVGothic-BoldItalic.ttf
- UDEVGothicNF-Regular.ttf
- UDEVGothicNF-Bold.ttf
- UDEVGothicNF-Italic.ttf
- UDEVGothicNF-BoldItalic.ttf

### Moralerspace（スタイリッシュな日本語対応）
以下の8つのフォントファイルがインストールされます：

- Moralerspace-Regular.ttf
- Moralerspace-Bold.ttf
- Moralerspace-Italic.ttf
- Moralerspace-BoldItalic.ttf
- MoralerspaceNF-Regular.ttf
- MoralerspaceNF-Bold.ttf
- MoralerspaceNF-Italic.ttf
- MoralerspaceNF-BoldItalic.ttf

### Cica（シンプルな日本語対応）
以下の4つのフォントファイルがインストールされます：

- Cica-Regular.ttf
- Cica-Bold.ttf
- Cica-RegularItalic.ttf
- Cica-BoldItalic.ttf

## ライセンス

- **MesloLGS NF**: [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) プロジェクトで配布されているものを使用
- **HackGen**: [yuru7/HackGen](https://github.com/yuru7/HackGen) プロジェクトで配布されているものを使用（SIL Open Font License 1.1）
- **UDEV Gothic**: [yuru7/udev-gothic](https://github.com/yuru7/udev-gothic) プロジェクトで配布されているものを使用（SIL Open Font License 1.1）
- **Moralerspace**: [yuru7/moralerspace](https://github.com/yuru7/moralerspace) プロジェクトで配布されているものを使用（SIL Open Font License 1.1）
- **Cica**: [miiton/Cica](https://github.com/miiton/Cica) プロジェクトで配布されているものを使用（SIL Open Font License 1.1）