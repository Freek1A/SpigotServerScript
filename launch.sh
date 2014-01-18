#!/bin/bash
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ $DISPLAY ]; then
  if hash x-terminal-emulator 2>/dev/null; then
    x-terminal-emulator -e './scripts/main.sh'
  else
    './scripts/main.sh'
  fi
else
  './scripts/main.sh'
fi
