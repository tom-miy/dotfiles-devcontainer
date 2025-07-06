#!/bin/bash

# MesloLGS NF & HackGen & UDEV Gothic フォント自動インストールスクリプト (Linux用)

set -e

echo "🔤 MesloLGS NF & HackGen & UDEV Gothic フォントインストーラー (Linux)"
echo "============================================="

# フォント定義
declare -a FONTS=(
    "MesloLGS%20NF%20Regular.ttf:MesloLGS NF Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf:MesloLGS NF Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf:MesloLGS NF Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf:MesloLGS NF Bold Italic.ttf"
)

# HackGen フォント定義
declare -a HACKGEN_FONTS=(
    "HackGen-Regular.ttf:HackGen-Regular.ttf"
    "HackGen-Bold.ttf:HackGen-Bold.ttf"
    "HackGen35-Regular.ttf:HackGen35-Regular.ttf"
    "HackGen35-Bold.ttf:HackGen35-Bold.ttf"
    "HackGenNerd-Regular.ttf:HackGenNerd-Regular.ttf"
    "HackGenNerd-Bold.ttf:HackGenNerd-Bold.ttf"
    "HackGenNerd35-Regular.ttf:HackGenNerd35-Regular.ttf"
    "HackGenNerd35-Bold.ttf:HackGenNerd35-Bold.ttf"
)

# UDEV Gothic フォント定義
declare -a UDEV_FONTS=(
    "UDEVGothic-Regular.ttf:UDEVGothic-Regular.ttf"
    "UDEVGothic-Bold.ttf:UDEVGothic-Bold.ttf"
    "UDEVGothic-Italic.ttf:UDEVGothic-Italic.ttf"
    "UDEVGothic-BoldItalic.ttf:UDEVGothic-BoldItalic.ttf"
    "UDEVGothicNF-Regular.ttf:UDEVGothicNF-Regular.ttf"
    "UDEVGothicNF-Bold.ttf:UDEVGothicNF-Bold.ttf"
    "UDEVGothicNF-Italic.ttf:UDEVGothicNF-Italic.ttf"
    "UDEVGothicNF-BoldItalic.ttf:UDEVGothicNF-BoldItalic.ttf"
)

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
HACKGEN_BASE_URL="https://github.com/yuru7/HackGen/releases/latest/download"
UDEV_BASE_URL="https://github.com/yuru7/udev-gothic/releases/latest/download"
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
existing_hackgen=$(find "$FONT_DIR" -name "*HackGen*" 2>/dev/null | wc -l)
existing_udev=$(find "$FONT_DIR" -name "*UDEV*" 2>/dev/null | wc -l)

if [ "$existing_fonts" -gt 0 ] || [ "$existing_hackgen" -gt 0 ] || [ "$existing_udev" -gt 0 ]; then
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
        echo ""
        read -r -p "再インストールしますか? (y/N): " choice
        if [[ ! "$choice" =~ ^[yY]$ ]]; then
            echo "インストールをキャンセルしました。"
            exit 0
        fi
    fi
fi

echo "📥 フォントをダウンロード・インストール中..."
echo ""

success_count=0
total_count=$((${#FONTS[@]} + ${#HACKGEN_FONTS[@]} + ${#UDEV_FONTS[@]}))

# ダウンロードコマンド選択
if command -v curl >/dev/null 2>&1; then
    download_cmd="curl -L -o"
elif command -v wget >/dev/null 2>&1; then
    download_cmd="wget -O"
fi

# MesloLGS NF フォントダウンロード
echo "📦 MesloLGS NF フォントをダウンロード中..."
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

# HackGen フォントダウンロード
echo "📦 HackGen フォントをダウンロード中..."
for font_info in "${HACKGEN_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # ファイルパス
    font_file="$FONT_DIR/$file_name"
    
    # ダウンロード
    if $download_cmd "$font_file" "$HACKGEN_BASE_URL/$url_name"; then
        echo "✅ $file_name のインストールが完了しました。"
        ((success_count++))
    else
        echo "❌ $file_name のダウンロードに失敗しました。"
    fi
    
    echo ""
done

# UDEV Gothic フォントダウンロード
echo "📦 UDEV Gothic フォントをダウンロード中..."
for font_info in "${UDEV_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # ファイルパス
    font_file="$FONT_DIR/$file_name"
    
    # ダウンロード
    if $download_cmd "$font_file" "$UDEV_BASE_URL/$url_name"; then
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
    installed_hackgen=$(fc-list | grep -i "hackgen" | wc -l)
    installed_udev=$(fc-list | grep -i "udev" | wc -l)
    
    if [ "$installed_fonts" -gt 0 ]; then
        echo "✅ MesloLGS NF フォントが正常に認識されています ($installed_fonts個):"
        fc-list | grep -i "meslolgs" | sed 's/^/   - /'
    fi
    
    if [ "$installed_hackgen" -gt 0 ]; then
        echo "✅ HackGen フォントが正常に認識されています ($installed_hackgen個):"
        fc-list | grep -i "hackgen" | sed 's/^/   - /'
    fi
    
    if [ "$installed_udev" -gt 0 ]; then
        echo "✅ UDEV Gothic フォントが正常に認識されています ($installed_udev個):"
        fc-list | grep -i "udev" | sed 's/^/   - /'
    fi
    
    if [ "$installed_fonts" -eq 0 ] && [ "$installed_hackgen" -eq 0 ] && [ "$installed_udev" -eq 0 ]; then
        echo "⚠️  フォントが認識されていません。ログアウト/ログインするか、システムを再起動してください。"
    fi
else
    echo "⚠️  fc-list が見つかりません。フォントの確認をスキップします。"
fi

echo ""
echo "📝 次の手順:"
echo "  1. VS Code/Cursor を再起動してください"
echo "  2. settings.json に以下のいずれかを追加してください:"
echo '     "terminal.integrated.fontFamily": "'\''MesloLGS NF'\''"      # Powerlevel10k用'
echo '     "terminal.integrated.fontFamily": "'\''HackGenNerd'\''"      # 日本語対応'
echo '     "terminal.integrated.fontFamily": "'\''UDEVGothicNF'\''"    # モダンな日本語対応'
echo "  3. devcontainer を再構築してください"
echo ""
echo "インストール完了!"