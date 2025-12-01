#!/bin/bash

# Check if input arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <image_file> <audio_file>"
    echo "Example: $0 \"image.png\" \"audio.m4a\""
    exit 1
fi

IMAGE_FILE="$1"
AUDIO_FILE="$2"

# Check if files exist
if [ ! -f "$IMAGE_FILE" ]; then
    echo "Error: Image file '$IMAGE_FILE' not found."
    exit 1
fi

if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: Audio file '$AUDIO_FILE' not found."
    exit 1
fi

# Extract filename without extension for output
BASENAME=$(basename "$AUDIO_FILE" | sed 's/\.[^.]*$//')
OUTPUT_FILE="${BASENAME}.mp4"

echo "Creating video from:"
echo "  Image: $IMAGE_FILE"
echo "  Audio: $AUDIO_FILE"
echo "  Output: $OUTPUT_FILE"

# Run ffmpeg
# -loop 1: Loop the image
# -i "$IMAGE_FILE": Input image
# -i "$AUDIO_FILE": Input audio
# -c:v libx264: Video codec H.264
# -tune stillimage: Optimize for still image
# -c:a aac: Audio codec AAC
# -b:a 192k: Audio bitrate
# -pix_fmt yuv420p: Pixel format for compatibility (essential for QuickTime/YouTube)
# -shortest: Finish encoding when the shortest input stream ends (the audio)
# -movflags +faststart: Move metadata to the beginning for better streaming
ffmpeg -y -loop 1 -i "$IMAGE_FILE" -i "$AUDIO_FILE" \
    -c:v libx264 -tune stillimage -c:a aac -b:a 192k \
    -pix_fmt yuv420p -shortest -movflags +faststart \
    "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Success! Video created: $OUTPUT_FILE"
else
    echo "Error: ffmpeg failed."
    exit 1
fi
