#!/usr/bin/env bash
# ------------------------------------------------------------------------
# OW-DETR: Open-world Detection Transformer
# Akshita Gupta^, Sanath Narayan^, K J Joseph, Salman Khan, Fahad Shahbaz Khan, Mubarak Shah
# https://arxiv.org/pdf/2112.01513.pdf
# ------------------------------------------------------------------------
# Modified from Deformable DETR (https://github.com/fundamentalvision/Deformable-DETR)
# Copyright (c) 2020 SenseTime. All Rights Reserved.
# ------------------------------------------------------------------------
# Try to use python3 by default
if command -v python3 &>/dev/null; then
    PYTHON_CMD=python3
elif command -v python &>/dev/null; then
    # Fallback to python if python3 is not available
    PYTHON_CMD=python
else
    echo "Python is not installed."
    exit 1
fi

# Use $PYTHON_CMD for your Python command
echo "Using $PYTHON_CMD"
$PYTHON_CMD -c "print('Hello, World!')"

$PYTHON_CMD setup.py build install
