#!/bin/bash

# 批量转换当前目录下所有MP4文件
echo "开始批量转换MP4到MP3..."

for file in *.mp4; do
    if [ -f "$file" ]; then
        output="${file%.*}.mp3"
        echo "正在转换: $file -> $output"
        ffmpeg -i "$file" -vn -acodec libmp3lame -q:a 2 "$output"
    fi
done

echo "批量转换完成!"
