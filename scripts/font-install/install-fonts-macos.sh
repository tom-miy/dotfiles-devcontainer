#!/bin/bash

# MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica フォント自動インストールスクリプト (macOS用)

set -e

echo "🔤 MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica フォントインストーラー (macOS)"
echo "=============================================="

# フォント定義（配列を使わない方式）
FONT_URLS="MesloLGS%20NF%20Regular.ttf:MesloLGS NF Regular.ttf
MesloLGS%20NF%20Bold.ttf:MesloLGS NF Bold.ttf
MesloLGS%20NF%20Italic.ttf:MesloLGS NF Italic.ttf
MesloLGS%20NF%20Bold%20Italic.ttf:MesloLGS NF Bold Italic.ttf"

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONT_DIR="$HOME/Library/Fonts"

# フォールバック用の固定URL（GitHub CLI認証が使えない場合）
HACKGEN_FALLBACK_URL="https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_v2.10.0.zip"
UDEV_FALLBACK_URL="https://github.com/yuru7/udev-gothic/releases/download/v2.0.0/UDEVGothic_v2.0.0.zip"
MORALERSPACE_FALLBACK_URL="https://github.com/yuru7/moralerspace/releases/download/v1.0.2/Moralerspace_v1.0.2.zip"
CICA_FALLBACK_URL="https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip"

# 必要なコマンドチェック
if ! command -v gh >/dev/null 2>&1; then
    echo "⚠️ gh (GitHub CLI) が見つかりません。固定URLを使用します。"
    USE_FALLBACK_URLS=true
else
    # GitHub CLI認証チェック
    if ! gh auth status >/dev/null 2>&1; then
        echo "⚠️ GitHub CLI認証が必要ですが、未認証です。固定URLを使用します。"
        echo "   認証したい場合: gh auth login"
        USE_FALLBACK_URLS=true
    else
        USE_FALLBACK_URLS=false
    fi
fi

# GitHub CLIでリリース情報を取得する関数
get_latest_release_url() {
    local repo="$1"
    local pattern="$2"
    
    # 最新リリースのアセットURLを取得
    local url=$(gh release view --repo "$repo" --json assets --jq ".assets[] | select(.name | test(\"$pattern\")) | .url" | head -1)
    
    if [ -z "$url" ]; then
        echo "❌ $repo の最新リリースから $pattern に一致するファイルが見つかりません。" >&2
        return 1
    fi
    
    echo "$url"
}

# フォントディレクトリが存在することを確認
mkdir -p "$FONT_DIR"

# ZIP ダウンロード・展開・インストール関数
install_zip_fonts() {
    local zip_url="$1"
    local font_name="$2"
    # Note: shift 2 and fonts=("$@") removed as we now install all TTF files automatically
    
    echo "📦 $font_name フォントをダウンロード中..."
    
    # 一時ディレクトリ作成
    local temp_dir=$(mktemp -d)
    local zip_file="$temp_dir/${font_name}.zip"
    
    # ダウンロード
    if curl -L -o "$zip_file" "$zip_url"; then
        echo "✅ $font_name のダウンロードが完了しました。"
    else
        echo "❌ $font_name のダウンロードに失敗しました。"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # ZIP展開
    echo "📂 $font_name を展開中..."
    if unzip -q "$zip_file" -d "$temp_dir"; then
        echo "✅ $font_name の展開が完了しました。"
    else
        echo "❌ $font_name の展開に失敗しました。"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # デバッグ: 展開されたファイル一覧を表示
    echo "📂 展開されたファイル:"
    find "$temp_dir" -name "*.ttf" -type f | sed 's/.*\//   - /'
    
    # すべてのTTFファイルをインストール
    local installed_count=0
    find "$temp_dir" -name "*.ttf" -type f | while read -r ttf_file; do
        local file_name=$(basename "$ttf_file")
        echo "🔄 $file_name をインストール中..."
        if cp "$ttf_file" "$FONT_DIR/"; then
            echo "✅ $file_name のインストールが完了しました。"
            installed_count=$((installed_count + 1))
            success_count=$((success_count + 1))
        else
            echo "❌ $file_name のインストールに失敗しました。"
        fi
    done
    
    # ファイル数を再カウント（パイプライン問題のため）
    installed_count=$(find "$FONT_DIR" -name "*$(echo "$font_name" | tr '[:upper:]' '[:lower:]')*" -type f 2>/dev/null | wc -l)
    
    if [ "$installed_count" -eq 0 ]; then
        echo "⚠️ $font_name パッケージ内にTTFファイルが見つかりませんでした。"
    fi
    
    # 一時ディレクトリ削除
    rm -rf "$temp_dir"
    
    echo "📊 $font_name: $installed_count ファイルをインストールしました。"
    echo ""
}

# 既存フォントチェック
existing_fonts=$(find "$FONT_DIR" -name "*MesloLGS*" 2>/dev/null | wc -l)
existing_hackgen=$(find "$FONT_DIR" -name "*HackGen*" 2>/dev/null | wc -l)
existing_udev=$(find "$FONT_DIR" -name "*UDEV*" 2>/dev/null | wc -l)
existing_moralerspace=$(find "$FONT_DIR" -name "*Moralerspace*" 2>/dev/null | wc -l)
existing_cica=$(find "$FONT_DIR" -name "*Cica*" 2>/dev/null | wc -l)

if [ "$existing_fonts" -gt 0 ] || [ "$existing_hackgen" -gt 0 ] || [ "$existing_udev" -gt 0 ] || [ "$existing_moralerspace" -gt 0 ] || [ "$existing_cica" -gt 0 ]; then
    if [ "$1" != "--force" ]; then
        echo "✅ フォントは既にインストールされています:"
        if [ "$existing_fonts" -gt 0 ]; then
            echo "  MesloLGS NF フォント:"
            find "$FONT_DIR" -name "*MesloLGS*" 2>/dev/null | sed 's/.*\//     - /'
        fi
        if [ "$existing_hackgen" -gt 0 ]; then
            echo "  HackGen フォント:"
            find "$FONT_DIR" -name "*HackGen*" 2>/dev/null | sed 's/.*\//     - /'
        fi
        if [ "$existing_udev" -gt 0 ]; then
            echo "  UDEV Gothic フォント:"
            find "$FONT_DIR" -name "*UDEV*" 2>/dev/null | sed 's/.*\//     - /'
        fi
        if [ "$existing_moralerspace" -gt 0 ]; then
            echo "  Moralerspace フォント:"
            find "$FONT_DIR" -name "*Moralerspace*" 2>/dev/null | sed 's/.*\//     - /'
        fi
        if [ "$existing_cica" -gt 0 ]; then
            echo "  Cica フォント:"
            find "$FONT_DIR" -name "*Cica*" 2>/dev/null | sed 's/.*\//     - /'
        fi
        echo ""
        read -p "再インストールしますか? (y/N): " choice
        if [[ ! "$choice" =~ ^[yY]$ ]]; then
            echo "インストールをキャンセルしました。"
            exit 0
        fi
    fi
fi

echo "📥 フォントをダウンロード・インストール中..."
echo ""

success_count=0

# MesloLGS NF フォントダウンロード
echo "📦 MesloLGS NF フォントをダウンロード中..."
while IFS=':' read -r url_name file_name; do
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$BASE_URL/$url_name"; then
        echo "📦 $file_name をインストール中..."
        
        # フォントをインストール
        if cp "$temp_file" "$FONT_DIR/"; then
            echo "✅ $file_name のインストールが完了しました。"
            success_count=$((success_count + 1))
        else
            echo "❌ $file_name のインストールに失敗しました。"
        fi
        
        # 一時ファイル削除
        rm -f "$temp_file"
    else
        echo "❌ $file_name のダウンロードに失敗しました。"
    fi
    
    echo ""
done << EOF
$FONT_URLS
EOF

# 日本語フォントパッケージのインストール（ZIP形式）
if [ "$USE_FALLBACK_URLS" = "true" ]; then
    echo "📦 固定URLを使用してフォントをダウンロードします..."
    
    install_zip_fonts "$HACKGEN_FALLBACK_URL" "HackGen"
    install_zip_fonts "$UDEV_FALLBACK_URL" "UDEV Gothic"
    install_zip_fonts "$MORALERSPACE_FALLBACK_URL" "Moralerspace"
    install_zip_fonts "$CICA_FALLBACK_URL" "Cica"
else
    echo "🔄 GitHub CLI で最新リリースを取得中..."
    
    # 動的に最新リリースURLを取得
    HACKGEN_LATEST_URL=$(get_latest_release_url "yuru7/HackGen" "HackGen_v.*\\.zip")
    UDEV_LATEST_URL=$(get_latest_release_url "yuru7/udev-gothic" "UDEVGothic_v.*\\.zip")
    MORALERSPACE_LATEST_URL=$(get_latest_release_url "yuru7/moralerspace" "Moralerspace_v.*\\.zip")
    CICA_LATEST_URL=$(get_latest_release_url "miiton/Cica" "Cica_v.*\\.zip")
    
    if [ -n "$HACKGEN_LATEST_URL" ] && [ -n "$UDEV_LATEST_URL" ] && [ -n "$MORALERSPACE_LATEST_URL" ] && [ -n "$CICA_LATEST_URL" ]; then
        echo "✅ 最新リリースURL取得完了"
        
        install_zip_fonts "$HACKGEN_LATEST_URL" "HackGen"
        install_zip_fonts "$UDEV_LATEST_URL" "UDEV Gothic"
        install_zip_fonts "$MORALERSPACE_LATEST_URL" "Moralerspace"
        install_zip_fonts "$CICA_LATEST_URL" "Cica"
    else
        echo "⚠️ 最新リリースURL取得に失敗しました。固定URLを使用します。"
        
        install_zip_fonts "$HACKGEN_FALLBACK_URL" "HackGen"
        install_zip_fonts "$UDEV_FALLBACK_URL" "UDEV Gothic"
        install_zip_fonts "$MORALERSPACE_FALLBACK_URL" "Moralerspace"
        install_zip_fonts "$CICA_FALLBACK_URL" "Cica"
    fi
fi

echo "=============================================="

if [ "$success_count" -gt 0 ]; then
    echo "🎉 フォントのインストールが完了しました! ($success_count ファイル)"
    echo ""
    echo "📝 次の手順:"
    echo "  1. VS Code/Cursor を再起動してください"
    echo "  2. settings.json に以下のいずれかを追加してください:"
    echo '     "terminal.integrated.fontFamily": "'\''MesloLGS NF'\''"        # Powerlevel10k用'
    echo '     "terminal.integrated.fontFamily": "'\''HackGenNerd'\''"        # 日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''UDEVGothicNF'\''"      # モダンな日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''MoralerspaceNF'\''"    # スタイリッシュな日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''Cica'\''"              # シンプルな日本語対応'
    echo "  3. devcontainer を再構築してください"
else
    echo "⚠️  フォントのインストールに失敗しました。"
    echo "手動でインストールを試してください。"
fi

echo ""
echo "フォントキャッシュを更新中..."
# macOSではフォントキャッシュの手動更新は通常不要ですが、念のため
fc-cache -f 2>/dev/null || true

echo "インストール完了!"