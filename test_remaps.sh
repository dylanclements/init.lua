#!/bin/bash

# Test script to check for duplicate keybindings in Neovim config
echo "🔍 Checking for duplicate keybindings in Neovim config..."

# Find all Lua files in the config
LUA_FILES=$(find lua/ -name "*.lua" -type f)

# Temporary file to store all keybindings
TEMP_FILE=$(mktemp)

# Extract all keybindings from Lua files
for file in $LUA_FILES; do
    echo "📁 Scanning $file..."
    
    # Extract keybindings using grep and sed
    # Look for patterns like: vim.keymap.set("n", "<leader>something", ...)
    grep -n "vim\.keymap\.set" "$file" | while read -r line; do
        # Extract the keybinding from the line
        keybinding=$(echo "$line" | sed -n "s/.*vim\.keymap\.set([^,]*,[^,]*,\s*['\"]\?\([^'\"]*\)['\"]\?.*/\1/p")
        
        if [ -n "$keybinding" ]; then
            # Clean up the keybinding (remove quotes and extra spaces)
            clean_keybinding=$(echo "$keybinding" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/^["'\'']//;s/["'\'']$//')
            echo "$clean_keybinding|$file:$line" >> "$TEMP_FILE"
        fi
    done
done

# Check for duplicates
echo ""
echo "🔍 Checking for duplicates..."

# Sort and find duplicates
DUPLICATES=$(sort "$TEMP_FILE" | cut -d'|' -f1 | uniq -d)

if [ -z "$DUPLICATES" ]; then
    echo "✅ No duplicate keybindings found!"
else
    echo "❌ Found duplicate keybindings:"
    echo ""
    
    for duplicate in $DUPLICATES; do
        echo "🔴 Duplicate: $duplicate"
        grep "^$duplicate|" "$TEMP_FILE" | while read -r line; do
            location=$(echo "$line" | cut -d'|' -f2)
            echo "   📍 $location"
        done
        echo ""
    done
    
    echo "💡 Fix these duplicates to avoid conflicts!"
fi

# Clean up
rm "$TEMP_FILE"

echo ""
echo "🎯 Keybinding test complete!" 