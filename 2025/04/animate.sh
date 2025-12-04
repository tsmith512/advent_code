#!/usr/bin/env bash

echo "Checking for ffmpeg"
which ffmpeg || exit 1

for i in $(ls step* -1); do echo "file $i" >> list.txt; done;
ffmpeg -f concat -r 10 -i list.txt -c:v libx264 -pix_fmt yuv420p output.mp4
rm list.txt
rm step-*.png
