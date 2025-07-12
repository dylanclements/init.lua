#!/bin/sh
# Test Neovim startup for errors

NVIM_LOG=$(mktemp)
nvim --headless -c 'quit' 2> "$NVIM_LOG"
EXIT_CODE=$?

if grep -q "Error detected" "$NVIM_LOG"; then
    echo "❌ FAIL: Neovim startup error detected:"
    cat "$NVIM_LOG"
    rm "$NVIM_LOG"
    exit 1
elif [ $EXIT_CODE -ne 0 ]; then
    echo "❌ FAIL: Neovim exited with code $EXIT_CODE"
    cat "$NVIM_LOG"
    rm "$NVIM_LOG"
    exit $EXIT_CODE
else
    echo "✅ PASS: Neovim started with no errors."
    rm "$NVIM_LOG"
    exit 0
fi 