#!/bin/bash
#Quick and dirty hack to find various filetypes we don't like in /home/ and tee them into a file
#Not exhaustive nor-accurate
find /home/ -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.mp4 -o -iname \*.mp3 -o -iname \*.exe \) | tee report
