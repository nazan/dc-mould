#!/usr/bin/env bash

find ./bootstrap/cache ! -name .gitignore | xargs chmod 777

find ./storage ! -name .gitignore | xargs chmod 777