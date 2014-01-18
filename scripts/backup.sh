if [ -e "./backups" ]; then
  if [ -e "./backups/backup_$(date +%y_%m_%d_%H).tar.bz2" ]; then
    rm ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2
  fi
  echo Creating backup...
  tar --exclude=./backups -jcf ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2 ./
  echo "Saved as: backup_$(date +%y_%m_%d_%H).tar.bz2 ($(($(stat -c '%s' ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2)/1024)) KiB)"
else
  mkdir backups
  ./scripts/backup.sh
fi
