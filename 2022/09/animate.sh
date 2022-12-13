#!/usr/bin/env bash

echo "Checking for ffmpeg"
which ffmpeg || exit 1

for i in $(ls field* -1); do echo "file $i" >> list.txt; done;
ffmpeg -f concat -r 60 -i list.txt -c:v libx264 -crf 25 -pix_fmt yuv420p output.mp4
rm list.txt
rm field-*.png
