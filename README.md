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
  "dotfiles": {
    "repository": "git@github.com:tom-miy/dotfiles-devcontainer.git",
    "installCommand": "install.sh"
  },
  "mounts": [
    "source=${env:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached",
    "source=${env:HOME}/.gnupg,target=/home/vscode/.gnupg,type=bind,consistency=cached"
  ],
  "postCreateCommand": "chmod 700 ~/.gnupg && chmod 600 ~/.gnupg/*",
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

devcontainer環境では、VS Codeのターミナルフォントが重要です。Powerlevel10kのアイコンを正しく表示するには、VS Codeの設定で以下のようなNerd Fontを使用してください：

```json
{
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Cascadia Code PL', 'JetBrains Mono', monospace"
}
```

推奨フォント：
- MesloLGS NF（Powerlevel10k推奨）
- Cascadia Code PL
- JetBrains Mono
- Hack Nerd Font

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
