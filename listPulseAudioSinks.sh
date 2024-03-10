#!/bin/bash
pactl list sink-inputs | grep -E 'Sink Input|Sink:|application.name|media.name' | rofi -dmenu -i

