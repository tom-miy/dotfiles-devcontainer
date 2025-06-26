#!/bin/bash

# MesloLGS NF フォント自動インストールスクリプト (macOS用)

set -e

echo "🔤 MesloLGS NF フォントインストーラー (macOS)"
echo "=============================================="

# フォント定義
declare -a FONTS=(
    "MesloLGS%20NF%20Regular.ttf:MesloLGS NF Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf:MesloLGS NF Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf:MesloLGS NF Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf:MesloLGS NF Bold Italic.ttf"
)

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONT_DIR="$HOME/Library/Fonts"

# フォントディレクトリが存在することを確認
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

for font_info in "${FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$BASE_URL/$url_name"; then
        echo "📦 $file_name をインストール中..."
        
        # フォントをインストール
        if cp "$temp_file" "$FONT_DIR/"; then
            echo "✅ $file_name のインストールが完了しました。"
            ((success_count++))
        else
            echo "❌ $file_name のインストールに失敗しました。"
        fi
        
        # 一時ファイル削除
        rm -f "$temp_file"
    else
        echo "❌ $file_name のダウンロードに失敗しました。"
    fi
    
    echo ""
done

echo "=============================================="

if [ "$success_count" -eq "$total_count" ]; then
    echo "🎉 すべてのフォント ($success_count/$total_count) のインストールが完了しました!"
    echo ""
    echo "📝 次の手順:"
    echo "  1. VS Code/Cursor を再起動してください"
    echo "  2. settings.json に以下を追加してください:"
    echo '     "terminal.integrated.fontFamily": "'\''MesloLGS NF'\''"'
    echo "  3. devcontainer を再構築してください"
else
    echo "⚠️  一部のフォントのインストールに失敗しました ($success_count/$total_count)"
    echo "手動でインストールを試してください。"
fi

echo ""
echo "フォントキャッシュを更新中..."
# macOSではフォントキャッシュの手動更新は通常不要ですが、念のため
fc-cache -f 2>/dev/null || true

echo "インストール完了!"