#!/bin/bash

wmctrl -s 0
pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo 0%
