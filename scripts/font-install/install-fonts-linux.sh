#!/bin/bash

# MesloLGS NF フォント自動インストールスクリプト (Linux用)

set -e

echo "🔤 MesloLGS NF フォントインストーラー (Linux)"
echo "============================================="

# フォント定義
declare -a FONTS=(
    "MesloLGS%20NF%20Regular.ttf:MesloLGS NF Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf:MesloLGS NF Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf:MesloLGS NF Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf:MesloLGS NF Bold Italic.ttf"
)

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONT_DIR="$HOME/.local/share/fonts"

# 必要なコマンドチェック
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    echo "❌ curl または wget が必要です。インストールしてください:"
    echo "   Ubuntu/Debian: sudo apt install curl"
    echo "   CentOS/RHEL:   sudo yum install curl"
    echo "   Fedora:        sudo dnf install curl"
    exit 1
fi

# フォントディレクトリ作成
mkdir -p "$FONT_DIR"

# 既存フォントチェック
existing_fonts=$(find "$FONT_DIR" -name "*MesloLGS*" 2>/dev/null | wc -l)

if [ "$existing_fonts" -gt 0 ] && [ "$1" != "--force" ]; then
    echo "✅ MesloLGS NF フォントは既にインストールされています:"
    find "$FONT_DIR" -name "*MesloLGS*" 2>/dev/null | sed 's/.*\//   - /'
    echo ""
    read -p "再インストールしますか? (y/N): " choice
    if [[ ! "$choice" =~ ^[yY]$ ]]; then
        echo "インストールをキャンセルしました。"
        exit 0
    fi
fi

echo "📥 フォントをダウンロード・インストール中..."
echo ""

success_count=0
total_count=${#FONTS[@]}

# ダウンロードコマンド選択
if command -v curl >/dev/null 2>&1; then
    download_cmd="curl -L -o"
elif command -v wget >/dev/null 2>&1; then
    download_cmd="wget -O"
fi

for font_info in "${FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # ファイルパス
    font_file="$FONT_DIR/$file_name"
    
    # ダウンロード
    if $download_cmd "$font_file" "$BASE_URL/$url_name"; then
        echo "✅ $file_name のインストールが完了しました。"
        ((success_count++))
    else
        echo "❌ $file_name のダウンロードに失敗しました。"
    fi
    
    echo ""
done

echo "============================================="

if [ "$success_count" -eq "$total_count" ]; then
    echo "🎉 すべてのフォント ($success_count/$total_count) のインストールが完了しました!"
else
    echo "⚠️  一部のフォントのインストールに失敗しました ($success_count/$total_count)"
fi

echo ""
echo "📦 フォントキャッシュを更新中..."
if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -fv
    echo "✅ フォントキャッシュの更新が完了しました。"
else
    echo "⚠️  fc-cache が見つかりません。手動でフォントキャッシュを更新してください。"
fi

echo ""
echo "🔍 インストールされたフォントを確認中..."
if command -v fc-list >/dev/null 2>&1; then
    installed_fonts=$(fc-list | grep -i "meslolgs" | wc -l)
    if [ "$installed_fonts" -gt 0 ]; then
        echo "✅ MesloLGS NF フォントが正常に認識されています ($installed_fonts個):"
        fc-list | grep -i "meslolgs" | sed 's/^/   - /'
    else
        echo "⚠️  フォントが認識されていません。ログアウト/ログインするか、システムを再起動してください。"
    fi
else
    echo "⚠️  fc-list が見つかりません。フォントの確認をスキップします。"
fi

echo ""
echo "📝 次の手順:"
echo "  1. VS Code/Cursor を再起動してください"
echo "  2. settings.json に以下を追加してください:"
echo '     "terminal.integrated.fontFamily": "'\''MesloLGS NF'\''"'
echo "  3. devcontainer を再構築してください"
echo ""
echo "インストール完了!"