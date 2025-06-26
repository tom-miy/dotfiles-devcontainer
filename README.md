# dotfiles-devcontainer

devcontainer用のdotfiles構成です。chezmoi、zsh、sheldon、miseを使用した開発環境を提供します。

## 特徴

- 🐚 **zsh** - モダンなシェル環境
- 📦 **chezmoi** - dotfiles管理ツール
- 🔌 **sheldon** - 高速なzshプラグインマネージャー
- 🛠️ **mise** - 開発ツールバージョン管理
- 🐳 **devcontainer** - VS Code開発コンテナ対応

## フォルダ構成

```
.
├── .chezmoiroot              # chezmoiのルートディレクトリ指定
├── .devcontainer/
│   ├── devcontainer.json     # devcontainer設定
│   └── setup.sh             # devcontainer用セットアップスクリプト
├── home/                    # dotfilesのソースディレクトリ
│   ├── .chezmoi.toml        # chezmoi設定
│   ├── dot_zshrc            # zsh設定ファイル
│   ├── dot_mise.toml        # mise設定ファイル
│   └── dot_config/
│       └── sheldon/
│           └── plugins.toml  # sheldonプラグイン設定
├── install.sh               # 自動インストールスクリプト
└── README.md
```

## 使い方

### 1. 自動インストール（推奨）

```bash
curl -fsSL https://raw.githubusercontent.com/tom-miy/dotfiles-devcontainer/main/install.sh | bash
```

このスクリプトが以下を自動実行します：
- chezmoiのインストール
- dotfilesの初期化・適用
- mise、sheldonの自動インストール
- 開発ツールの自動インストール

### 2. devcontainer環境での使用

#### このリポジトリ自体を使う場合
1. VS Codeでこのリポジトリを開く
2. 「Reopen in Container」を選択
3. 自動的にセットアップが実行されます
4. `chezmoi apply`でdotfilesを適用

#### 他のプロジェクトでこのdotfilesを使う場合

**方法1: プロジェクトの`.devcontainer/devcontainer.json`にdotfiles設定を追加**

**📌 Public Repositoryの場合:**
```json
{
  "name": "Your Project",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "configureZshAsDefaultShell": true
    }
  },
  "dotfiles": {
    "repository": "tom-miy/dotfiles-devcontainer",
    "installCommand": "install.sh"
  },
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      }
    }
  },
  "remoteUser": "vscode"
}
```

**🔒 Private Repositoryの場合:**

**オプション1: SSH接続（推奨）**
```json
{
  "name": "Your Project",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "configureZshAsDefaultShell": true
    }
  },
  "postCreateCommand": "git clone https://github.com/tom-miy/dotfiles-devcontainer.git ~/dotfiles && cd ~/dotfiles && bash install.sh",
  "mounts": [
    "source=${env:HOME}/.ssh,target=${containerUserHome}/.ssh,type=bind,consistency=cached",
    "source=${env:HOME}/.gnupg,target=${containerUserHome}/.gnupg,type=bind,consistency=cached"
  ],
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      }
    }
  },
  "remoteUser": "vscode"
}
```

**オプション2: GitHub CLI認証**
```json
{
  "name": "Your Project",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "configureZshAsDefaultShell": true
    },
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "dotfiles": {
    "repository": "tom-miy/dotfiles-devcontainer",
    "installCommand": "install.sh"
  },
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh"
      }
    }
  },
  "remoteUser": "vscode"
}
```

**オプション3: Personal Access Token（非推奨）**
```json
{
  "dotfiles": {
    "repository": "https://${GITHUB_TOKEN}@github.com/tom-miy/dotfiles-devcontainer.git",
    "installCommand": "install.sh"
  }
}
```
※ 環境変数`GITHUB_TOKEN`にPersonal Access Tokenを設定する必要があります。

**🚨 Private Repository使用時の注意点:**

1. **SSH接続の場合**: 
   - ローカルの`~/.ssh`と`~/.gnupg`ディレクトリがマウントされます
   - GitHubにSSH公開鍵を登録済みである必要があります
   - GPG署名を使用する場合はGPG鍵の設定も必要です
   
2. **GitHub CLI認証の場合**:
   - 初回起動時に`gh auth login`で認証が必要です
   
3. **PAT認証の場合**:
   - セキュリティリスクがあるため推奨しません
   - 使用する場合は適切なスコープを設定してください

**方法2: VS Code/Cursorの個人設定で全体に適用**

**設定ファイルの場所:**
- **VS Code**: `~/.config/Code/User/` (Linux/macOS), `%APPDATA%\Code\User\` (Windows)
- **Cursor**: `~/.config/Cursor/User/` (Linux/macOS), `%APPDATA%\Cursor\User\` (Windows)

**📌 Public Repositoryの場合:**

```json
{
  "dotfiles.repository": "tom-miy/dotfiles-devcontainer",
  "dotfiles.installCommand": "install.sh"
}
```

**🔒 Private Repositoryの場合:**

```json
{
  "dotfiles.repository": "git@github.com:tom-miy/dotfiles-devcontainer.git",
  "dotfiles.installCommand": "install.sh"
}
```

**重要**: 
- dotfiles設定は`settings.json`にのみ記述可能です
- この設定により、すべてのdevcontainerで自動的にdotfilesが適用されます
- Private repositoryの場合、SSH鍵の設定が必要です

**方法3: ローカルにクローンして使用**

事前にローカルにクローンしておき、それを参照する方法：

```bash
# Public repositoryの場合
git clone https://github.com/tom-miy/dotfiles-devcontainer.git ~/.dotfiles

# Private repositoryの場合（SSH）
git clone git@github.com:tom-miy/dotfiles-devcontainer.git ~/.dotfiles
```

VS Code/Cursorの設定：

```json
{
  "dotfiles.repository": "~/.dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

この方法の利点：
- ネットワークアクセスが不要
- ローカルで設定をカスタマイズ可能
- より高速な起動
- Private/Publicの区別なく使用可能

### 3. 手動セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/tom-miy/dotfiles-devcontainer.git
cd dotfiles-devcontainer

# chezmoiをインストール
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# dotfilesを適用
chezmoi init --apply .

# 開発ツールをインストール
~/.local/bin/mise install
```

## 含まれるツール

### 言語・ランタイム
- Node.js (LTS)
- Python (3.11)
- Go (latest)
- Rust (latest)

### CLIツール
- GitHub CLI (gh)
- fzf (fuzzy finder)
- bat (better cat)
- fd (better find)
- ripgrep (better grep)
- eza (better ls)
- zoxide (better cd)

### zshプラグイン
- powerlevel10k (カスタマイズ可能なプロンプトテーマ)
- zsh-syntax-highlighting
- zsh-autosuggestions
- zsh-history-substring-search

## カスタマイズ

### ユーザー情報の変更

`home/.chezmoi.toml`を編集してください：

```toml
[data]
name = "your-name"
email = "your-email@example.com"
```

### ツールの追加

`home/dot_mise.toml`に追加したいツールを記述：

```toml
[tools]
# 新しいツールを追加
"github.com/example/tool" = "latest"
```

### zshプラグインの追加

`home/dot_config/sheldon/plugins.toml`にプラグインを追加：

```toml
[plugins.new-plugin]
github = "user/repo"
```

### プロンプトのカスタマイズ

初回起動時に以下を実行してPowerlevel10kを設定：

```bash
p10k configure
```

**⚠️ フォントについて**

devcontainer環境では、**ホスト側**（Windows/macOS/Linux）のフォント設定が重要です。Powerlevel10kのアイコンを正しく表示するには、以下の手順に従ってください：

### フォントのインストール

**1. 自動インストールスクリプト（推奨）**

このリポジトリには各OS用の自動インストールスクリプトが含まれています：

```bash
# このリポジトリをクローン
git clone https://github.com/tom-miy/dotfiles-devcontainer.git
cd dotfiles-devcontainer
```

**Windows（PowerShellを管理者として実行）**:
```powershell
.\scripts\font-install\install-fonts-windows.ps1
```

**macOS**:
```bash
bash scripts/font-install/install-fonts-macos.sh
```

**Linux**:
```bash
bash scripts/font-install/install-fonts-linux.sh
```

**2. 手動ダウンロード**

以下のリンクから4つのフォントファイルをダウンロードし、ホストOSにインストールしてください：

- [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
- [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
- [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
- [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

**インストール方法**：
- **Windows**: ダウンロードしたフォントファイルを右クリック → 「インストール」
- **macOS**: ダウンロードしたフォントファイルをダブルクリック → 「フォントをインストール」
- **Linux**: フォントファイルを `~/.local/share/fonts/` にコピーし、`fc-cache -fv` を実行

**2. PowerShellでの自動ダウンロード・インストール（Windows）**

```powershell
# PowerShellを管理者として実行
$urls = @(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

# フォントをダウンロードしてインストール
foreach ($url in $urls) {
    $filename = Split-Path $url -Leaf
    $filepath = Join-Path $env:TEMP $filename
    
    Write-Host "ダウンロード中: $filename"
    Invoke-WebRequest -Uri $url -OutFile $filepath
    
    # フォントをインストール
    Write-Host "インストール中: $filename"
    $shell = New-Object -ComObject Shell.Application
    $fontsFolder = $shell.Namespace(0x14)
    $fontsFolder.CopyHere($filepath, 0x10)
    
    Remove-Item $filepath
}

Write-Host "MesloLGS NF フォントのインストールが完了しました。VS Code/Cursorを再起動してください。"
```

**3. 手動インストール手順**

**Windows**:
1. 上記のリンクからフォントファイルをダウンロード
2. ダウンロードしたフォントファイルを**右クリック**
3. **「すべてのユーザーに対してインストール」**を選択（推奨）
4. または、フォントファイルをダブルクリック → **「インストール」**ボタンをクリック

**macOS**:
1. フォントファイルをダウンロード
2. フォントファイルを**ダブルクリック**
3. Font Bookが開いたら**「フォントをインストール」**をクリック
4. または、`~/Library/Fonts/`フォルダにドラッグ&ドロップ

**Linux（Ubuntu/Debian）**:
```bash
# ディレクトリを作成
mkdir -p ~/.local/share/fonts

# フォントをダウンロード
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# フォントキャッシュを更新
fc-cache -fv

# インストールされたフォントを確認
fc-list | grep "MesloLGS NF"
```

### VS Code/Cursor設定

フォントインストール後、VS Code/Cursorの `settings.json` に以下を追加：

```json
{
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Cascadia Code PL', 'JetBrains Mono', monospace",
  "terminal.integrated.fontSize": 14
}
```

**設定ファイルの場所**：
- **VS Code**: 
  - Windows: `%APPDATA%\Code\User\settings.json`
  - macOS: `~/Library/Application Support/Code/User/settings.json`
  - Linux: `~/.config/Code/User/settings.json`
- **Cursor**: 
  - Windows: `%APPDATA%\Cursor\User\settings.json`
  - macOS: `~/Library/Application Support/Cursor/User/settings.json`
  - Linux: `~/.config/Cursor/User/settings.json`

### 代替フォント

MesloLGS NFで問題が発生する場合は、以下のフォントも試してください：

```json
{
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font', 'Hack Nerd Font', 'Cascadia Code PL', monospace"
}
```

**推奨フォント**：
- **MesloLGS NF**（Powerlevel10k推奨）
- **JetBrains Mono Nerd Font**
- **Hack Nerd Font**
- **Cascadia Code PL**
- **Fira Code Nerd Font**

### 文字化け解決方法

1. **フォントが正しくインストールされているか確認**
2. **VS Code/Cursorを再起動**
3. **devcontainerを再構築**
4. **コンテナ内でPowerlevel10kを再設定**：
   ```bash
   p10k configure
   ```

**重要**: devcontainer環境では、コンテナ内ではなく**ホスト側**のフォント設定が使用されます。

## トラブルシューティング

### プラグインが読み込まれない

```bash
sheldon lock
exec $SHELL
```

### mise管理ツールが使えない

```bash
mise install
exec $SHELL
```

### 設定を再適用したい

```bash
chezmoi apply
```
