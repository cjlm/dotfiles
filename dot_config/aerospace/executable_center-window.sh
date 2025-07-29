#!/bin/zsh

# Center current window as floating with specific dimensions

# Configuration
WIDTH_PERCENT=60  # Window width as percentage of screen
HEIGHT_PERCENT=90 # Window height as percentage of screen

# Make window floating
aerospace layout floating

# Get screen dimensions (requires displayplacer or system_profiler)
# Using system_profiler method:
SCREEN_INFO=$(system_profiler SPDisplaysDataType | grep Resolution)
SCREEN_WIDTH=$(echo $SCREEN_INFO | grep -o '[0-9]\+ x' | head -1 | grep -o '[0-9]\+')
SCREEN_HEIGHT=$(echo $SCREEN_INFO | grep -o 'x [0-9]\+' | head -1 | grep -o '[0-9]\+')

# Calculate window dimensions
WINDOW_WIDTH=$((SCREEN_WIDTH * WIDTH_PERCENT / 100))
WINDOW_HEIGHT=$((SCREEN_HEIGHT * HEIGHT_PERCENT / 100))

# Calculate position to center window
POS_X=$(((SCREEN_WIDTH - WINDOW_WIDTH) / 2))
POS_Y=$(((SCREEN_HEIGHT - WINDOW_HEIGHT) / 2))

# Use AppleScript to resize and position window
osascript -e "
tell application \"System Events\"
    set frontApp to name of first application process whose frontmost is true
    tell process frontApp
        tell window 1
            set position to {$POS_X, $POS_Y}
            set size to {$WINDOW_WIDTH, $WINDOW_HEIGHT}
        end tell
    end tell
end tell"
