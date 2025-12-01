#!/bin/bash

# Loop from 1 to 9
for i in {1..9}; do
    # Format the number with leading zero for audio files (e.g., 01, 02)
    EP_NUM=$(printf "%02d" $i)
    # Simple number for info files (e.g., 1, 2)
    INFO_NUM=$i

    # Find the audio file matching "ep${EP_NUM}_*.m4a"
    # We use find to handle potential multiple matches or no matches safely, 
    # but here we expect exactly one.
    AUDIO_FILE=$(find . -maxdepth 1 -name "ep${EP_NUM}_*.m4a" | head -n 1)

    # Find the image file matching "info ${INFO_NUM} *.png"
    IMAGE_FILE=$(find . -maxdepth 1 -name "info ${INFO_NUM} *.png" | head -n 1)

    # Check if both files were found
    if [[ -n "$AUDIO_FILE" && -n "$IMAGE_FILE" ]]; then
        # Remove leading ./ from find output for cleaner logs
        AUDIO_FILE=${AUDIO_FILE#./}
        IMAGE_FILE=${IMAGE_FILE#./}

        echo "Processing Episode $i..."
        echo "  Audio: $AUDIO_FILE"
        echo "  Image: $IMAGE_FILE"

        # Call the single video creation script
        ./create_youtube_video.sh "$IMAGE_FILE" "$AUDIO_FILE"
        
        echo "----------------------------------------"
    else
        echo "Warning: Could not find matching files for Episode $i"
        echo "  Looking for: ep${EP_NUM}_*.m4a AND info ${INFO_NUM} *.png"
    fi
done

echo "Batch processing complete."
