#!/bin/bash

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: $0 <input.mp4> [output.mp3]"
    exit 1
fi

INPUT="$1"
OUTPUT="${2:-${INPUT%.*}.mp3}"

# 执行转换
ffmpeg -i "$INPUT" -vn -acodec libmp3lame -q:a 2 "$OUTPUT"

echo "转换完成: $INPUT -> $OUTPUT"