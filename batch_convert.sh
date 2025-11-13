#!/bin/bash

# 专业级高品质MP3转换脚本
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: 目录 '$TARGET_DIR' 不存在!"
    exit 1
fi

echo "开始专业级高品质MP3转换"
echo "目录: $TARGET_DIR"
cd "$TARGET_DIR" || exit 1

# 专业级高品质参数
BITRATE="320k"           # 最高比特率
SAMPLE_RATE="48000"      # 专业音频采样率
CHANNELS=2               # 立体声
QUALITY=0                # 最高质量
VBR="0"                  # CBR模式，恒定比特率

echo "专业级高品质设置:"
echo "  - 比特率: $BITRATE (CBR)"
echo "  - 采样率: ${SAMPLE_RATE}Hz"
echo "  - 声道: 立体声"
echo "  - 质量级别: 最高 (0)"
echo "------------------------"

file_count=0
success_count=0

for file in *.mp4; do
    if [ -f "$file" ]; then
        ((file_count++))
        output="${file%.*}.mp3"
        echo "[$file_count] 转换: $file"
        echo "输出: $output"
        
        # 专业级高品质转换命令
        ffmpeg -i "$file" \
               -vn \
               -acodec libmp3lame \
               -b:a $BITRATE \
               -ar $SAMPLE_RATE \
               -ac $CHANNELS \
               -q:a $QUALITY \
               -compression_level 0 \
               -id3v2_version 3 \
               -write_xing 0 \
               "$output" 2>/dev/null
        
        if [ $? -eq 0 ] && [ -f "$output" ]; then
            # 获取文件大小信息
            original_size=$(du -h "$file" | cut -f1)
            mp3_size=$(du -h "$output" | cut -f1)
            echo "✓ 专业级转换成功"
            echo "  原始: $original_size → MP3: $mp3_size"
            ((success_count++))
        else
            echo "✗ 转换失败"
        fi
        echo "---"
    fi
done

if [ $file_count -eq 0 ]; then
    echo "未找到MP4文件"
else
    echo "========================================"
    echo "专业级高品质MP3转换完成!"
    echo "成功转换: $success_count/$file_count 个文件"
    echo "所有文件均使用320kbps CBR最高质量设置"
fi