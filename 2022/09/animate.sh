#!/usr/bin/env bash

convert -delay 10 -loop 0 -dispose background field*.png -scale 800x600 -gravity Center -background white -extent 800x600 -loop 0  output.gif
