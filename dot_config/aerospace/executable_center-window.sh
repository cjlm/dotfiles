#!/bin/bash

# Toggle between centered (with padding) and normal view
# For single windows on wide monitors

# Check if we currently have padding by looking at outer.left value
CURRENT_PADDING=$(grep "^outer\.left = " ~/.aerospace.toml | sed 's/outer\.left = //')

if [[ "$CURRENT_PADDING" == "10" ]]; then
    # Currently normal, add padding to center
    PADDING=300  # Adjust this value to control centering
    
    # Update all outer gaps
    sed -i '' "s/^outer\.left = .*/outer.left = $PADDING/" ~/.aerospace.toml
    sed -i '' "s/^outer\.right = .*/outer.right = $PADDING/" ~/.aerospace.toml
    sed -i '' "s/^outer\.top = .*/outer.top = 100/" ~/.aerospace.toml
    sed -i '' "s/^outer\.bottom = .*/outer.bottom = 100/" ~/.aerospace.toml
    
    # Ensure window is tiled so padding takes effect
    aerospace layout tiling
else
    # Currently padded, restore normal
    sed -i '' "s/^outer\.left = .*/outer.left = 10/" ~/.aerospace.toml
    sed -i '' "s/^outer\.right = .*/outer.right = 10/" ~/.aerospace.toml
    sed -i '' "s/^outer\.top = .*/outer.top = 10/" ~/.aerospace.toml
    sed -i '' "s/^outer\.bottom = .*/outer.bottom = 10/" ~/.aerospace.toml
fi

# Reload config to apply changes
aerospace reload-config