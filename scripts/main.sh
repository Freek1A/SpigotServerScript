#!/bin/bash
if ! [ -e "spigot.jar" ]; then
  echo "Spigot.jar not found, downloading now..."
  wget http://ci.md-5.net/job/Spigot/lastSuccessfulBuild/artifact/Spigot-Server/target/spigot.jar -O ./spigot.jar
  sleep 0.5
fi
clear
echo "Welcome!"
echo "Please select one of the following options:"
PS3='Enter the number of the service you want to start: '
options=("Start Server" "Update Spigot" "Backup" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "Start Server")
      echo "Starting the server..."
      ./scripts/server.sh;;
    "Update Spigot")
      echo "Updating Spigot..."
      ./scripts/update.sh;;
    "Backup")
      ./scripts/backup.sh
      echo "Backup done!";;
    "Quit")
      break
      ;;
    *) echo "invalid option :(";;
  esac
done
