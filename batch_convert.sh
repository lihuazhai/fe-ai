=#!/bin/bash

# 最简单有效的版本
export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: 目录 '$TARGET_DIR' 不存在!"
    exit 1
fi

echo "开始转换目录: $TARGET_DIR"
cd "$TARGET_DIR" || exit 1

# 直接使用通配符，让shell处理文件名
for file in *.mp4; do
    if [ -f "$file" ]; then
        output="${file%.*}.mp3"
        echo "转换: $file -> $output"
        
        # 直接使用变量，不进行任何额外解析
        ffmpeg -i "$file" -vn -acodec libmp3lame -q:a 2 "$output" && echo "✓ 成功" || echo "✗ 失败"
        echo "---"
    fi
done

echo "转换完成!"