import os
import ffmpeg
import whisper
from tqdm import tqdm

# 输入音频文件路径
AUDIO_PATH = "output/client.mp3"  # 你要分割的音频文件
OUTPUT_DIR = "output/output_segments"

# 创建输出目录
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 加载 Whisper 模型（可选: tiny, base, small, medium, large）
print("Loading Whisper model...")
model = whisper.load_model("base")

print(f"Transcribing {AUDIO_PATH} ...")
result = model.transcribe(AUDIO_PATH)

segments = result["segments"]

# 输出字幕文本
with open(os.path.join(OUTPUT_DIR, "transcript.txt"), "w", encoding="utf-8") as f:
    for i, seg in enumerate(segments):
        text = seg["text"].strip()
        start = seg["start"]
        end = seg["end"]
        f.write(f"[{i+1}] {start:.2f} - {end:.2f}: {text}\n")

print(f"✅ Transcription complete. Found {len(segments)} sentences.")

# 分割音频（精确分割，不包含静音）
print("Splitting audio into sentences (without silence)...")
for i, seg in enumerate(tqdm(segments)):
    start = seg["start"]
    end = seg["end"]
    output_file = os.path.join(OUTPUT_DIR, f"sentence_{i+1}.mp3")

    (
        ffmpeg
        .input(AUDIO_PATH, ss=start, t=end - start)  # 精确的时间长度，不额外添加静音
        .output(output_file, codec="copy", loglevel="error")
        .run()
    )

print(f"✅ Done! Clean segments saved in folder: {OUTPUT_DIR}")

# 可选：生成一个包含所有句子的完整文件（无额外间隔）
print("Generating complete version without intervals...")
concat_list_file = os.path.join(OUTPUT_DIR, "concat_list.txt")

with open(concat_list_file, "w", encoding="utf-8") as f:
    for i in range(len(segments)):
        f.write(f"file 'sentence_{i+1}.mp3'\n")

final_output = os.path.join(OUTPUT_DIR, "complete_no_intervals.mp3")

(
    ffmpeg
    .input(concat_list_file, format='concat', safe=0)
    .output(final_output, codec="copy", loglevel="error")
    .run()
)

print(f"✅ Complete version without intervals saved as: {final_output}")