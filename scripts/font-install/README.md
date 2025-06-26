# MesloLGS NF フォントインストールスクリプト

Powerlevel10k で使用する MesloLGS NF フォントを自動インストールするスクリプト集です。

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

フォントインストール後、VS Code/Cursor の `settings.json` に以下を追加：

```json
{
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Cascadia Code PL', monospace",
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

以下の4つのフォントファイルがインストールされます：

- MesloLGS NF Regular.ttf
- MesloLGS NF Bold.ttf
- MesloLGS NF Italic.ttf
- MesloLGS NF Bold Italic.ttf

## ライセンス

フォントファイルは [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) プロジェクトで配布されているものを使用しています。