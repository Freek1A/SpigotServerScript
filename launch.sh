#!/bin/bash
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ $DISPLAY ]; then
  if hash x-terminal-emulator 2>/dev/null; then
    x-terminal-emulator -e bash ./script/script.sh
  else
    bash ./script/script.sh
  fi
else
  bash ./script/script.sh
fi
