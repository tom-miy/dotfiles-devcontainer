#!/bin/bash

# MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica フォント自動インストールスクリプト (macOS用)

set -e

echo "🔤 MesloLGS NF & HackGen & UDEV Gothic & Moralerspace & Cica フォントインストーラー (macOS)"
echo "=============================================="

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

# Moralerspace フォント定義
declare -a MORALERSPACE_FONTS=(
    "Moralerspace-Regular.ttf:Moralerspace-Regular.ttf"
    "Moralerspace-Bold.ttf:Moralerspace-Bold.ttf"
    "Moralerspace-Italic.ttf:Moralerspace-Italic.ttf"
    "Moralerspace-BoldItalic.ttf:Moralerspace-BoldItalic.ttf"
    "MoralerspaceNF-Regular.ttf:MoralerspaceNF-Regular.ttf"
    "MoralerspaceNF-Bold.ttf:MoralerspaceNF-Bold.ttf"
    "MoralerspaceNF-Italic.ttf:MoralerspaceNF-Italic.ttf"
    "MoralerspaceNF-BoldItalic.ttf:MoralerspaceNF-BoldItalic.ttf"
)

# Cica フォント定義
declare -a CICA_FONTS=(
    "Cica-Regular.ttf:Cica-Regular.ttf"
    "Cica-Bold.ttf:Cica-Bold.ttf"
    "Cica-RegularItalic.ttf:Cica-RegularItalic.ttf"
    "Cica-BoldItalic.ttf:Cica-BoldItalic.ttf"
)

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
HACKGEN_BASE_URL="https://github.com/yuru7/HackGen/releases/latest/download"
UDEV_BASE_URL="https://github.com/yuru7/udev-gothic/releases/latest/download"
MORALERSPACE_BASE_URL="https://github.com/yuru7/moralerspace/releases/latest/download"
CICA_BASE_URL="https://github.com/miiton/Cica/releases/latest/download"
FONT_DIR="$HOME/Library/Fonts"

# フォントディレクトリが存在することを確認
mkdir -p "$FONT_DIR"

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
total_count=$((${#FONTS[@]} + ${#HACKGEN_FONTS[@]} + ${#UDEV_FONTS[@]} + ${#MORALERSPACE_FONTS[@]} + ${#CICA_FONTS[@]}))

# MesloLGS NF フォントダウンロード
echo "📦 MesloLGS NF フォントをダウンロード中..."
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

# HackGen フォントダウンロード
echo "📦 HackGen フォントをダウンロード中..."
for font_info in "${HACKGEN_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$HACKGEN_BASE_URL/$url_name"; then
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

# UDEV Gothic フォントダウンロード
echo "📦 UDEV Gothic フォントをダウンロード中..."
for font_info in "${UDEV_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$UDEV_BASE_URL/$url_name"; then
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

# Moralerspace フォントダウンロード
echo "📦 Moralerspace フォントをダウンロード中..."
for font_info in "${MORALERSPACE_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$MORALERSPACE_BASE_URL/$url_name"; then
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

# Cica フォントダウンロード
echo "📦 Cica フォントをダウンロード中..."
for font_info in "${CICA_FONTS[@]}"; do
    IFS=':' read -r url_name file_name <<< "$font_info"
    
    echo "🔄 $file_name をダウンロード中..."
    
    # 一時ファイルパス
    temp_file="/tmp/$file_name"
    
    # ダウンロード
    if curl -L -o "$temp_file" "$CICA_BASE_URL/$url_name"; then
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
    echo "  2. settings.json に以下のいずれかを追加してください:"
    echo '     "terminal.integrated.fontFamily": "'\''MesloLGS NF'\''"        # Powerlevel10k用'
    echo '     "terminal.integrated.fontFamily": "'\''HackGenNerd'\''"        # 日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''UDEVGothicNF'\''"      # モダンな日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''MoralerspaceNF'\''"    # スタイリッシュな日本語対応'
    echo '     "terminal.integrated.fontFamily": "'\''Cica'\''"              # シンプルな日本語対応'
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