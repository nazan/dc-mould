#!/usr/bin/env bash

pyinstaller -y --clean --name dc_mould cli.py
cp -R dc_mould/templates dist/dc_mould/