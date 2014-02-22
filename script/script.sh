UpdateServer() {
  wget http://ci.md-5.net/job/Spigot/lastSuccessfulBuild/artifact/Spigot-Server/target/spigot.jar -O ./spigotnew.jar
  CheckDownload spigotnew.jar
  if [ $CheckDL -eq 0 ]; then
    md5sumnew=`md5sum spigotnew.jar | cut -b-32`
    md5sumold=`md5sum spigot.jar | cut -b-32`
    if [ "$md5sumnew" = "$md5sumold" ]; then
      echo "Spigot is already up to date."
      rm spigotnew.jar
    else
      echo "Spigot is not up to date, updating now..."
      Backup
      mv spigotnew.jar spigot.jar
      echo "Update finished!"
    fi
  fi
}
CheckDownload() {
  if ! [ -s $1 ]; then
    echo "Download failed!"
    echo "Please check your internet connection."
    rm $1
    CheckDL=1
  else
    CheckDL=0
  fi
}
SetMemory() {
  read -p "Enter the Maximum memory usage for the server (in MBs): " MaxMemory
}
Server() {
  java -Xmx"$MaxMemory"M -Xms384M -XX:MaxPermSize=128M -jar spigot.jar nogui
  COUNTER=15
  echo "Press any key to stop"
  until [ $COUNTER -eq 0 ]; do
    echo "Restarting in $COUNTER"
    COUNTER=$[COUNTER - 1]
    read -t 1.1 -n 1 value
    if [ -n "$value" ]; then
      COUNTER=0
    fi
  done
  if [ -z "$value" ]; then
    notify-send "Server restarting!"
    Server
  fi
}
CheckMemory() {
  until [ "$MaxMemory" -eq "$MaxMemory" ] 2>/dev/null; do
    echo "Invalid amount. (Numbers only)"
    SetMemory
  done
  if [ $MaxMemory -lt 383 ]; then
    echo "Amount of memory is too small (less than 384MB), please adjust it"
    SetMemory
    CheckMemory
  fi
  TotalMem=$(($(free|awk '/^Mem:/{print $2}')/1024))
  WarningMem=$(($TotalMem-$TotalMem/8))
  if [ $MaxMemory -gt $TotalMem ]; then
    until [ $MaxMemory -lt $TotalMem ]; do
      echo "You don't have that much memory available!"
      SetMemory
      CheckMemory
    done
  elif [ $MaxMemory -gt $WarningMem ]; then
    echo "You've allocated most of your memory to the server."
    echo "Doing so could cause problems with other programs."
    read -n 1 -p "Would you like to adjust the amount of memory for the server? y/n " warnvar
    echo " "
    if [ $warnvar = y ]; then
      SetMemory
      CheckMemory
    fi
  fi
  echo MaxMemory=$MaxMemory > ./script/vars
}
StartServer() {
  until [ -e "./script/vars" ]; do
    SetMemory
    CheckMemory
  done
  source ./script/vars
  Server
}
Backup() {
  if ! [ -e "./backups" ]; then
    mkdir backups
  elif [ -e "./backups/backup_$(date +%y_%m_%d_%H).tar.bz2" ]; then
    rm ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2
  fi
  echo "Creating backup..."
  tar --exclude=./backups -jcf ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2 ./
  echo "Saved as: backup_$(date +%y_%m_%d_%H).tar.bz2 ($(($(stat -c '%s' ./backups/backup_$(date +%y_%m_%d_%H).tar.bz2)/1024)) KiB)"
}
if ! [ -e "spigot.jar" ]; then
  echo "Spigot.jar not found, downloading now..."
  wget http://ci.md-5.net/job/Spigot/lastSuccessfulBuild/artifact/Spigot-Server/target/spigot.jar -O ./spigot.jar
  clear
  CheckDownload spigot.jar
  if [ $CheckDL -eq 1 ]; then
    echo "Try downloading it manually from http://ci.md-5.net/job/Spigot/"
    sleep 2
    echo "Stopping script"
    sleep 3
    exit
  fi
fi
echo "Welcome!"
until [[ $MenuNum -eq 4 ]]; do
  echo "Please select one of the following options:"
  echo "1) Start Server"
  echo "2) Update Spigot"
  echo "3) Backup"
  echo "4) Quit"
  read -n 1 -p "Enter the number of the service you want to start: " MenuNum
  echo " "
  if [[ $MenuNum -eq 1 ]]; then
    echo "Starting the server..."
    StartServer
  elif [[ $MenuNum -eq 2 ]]; then
    echo "Updating Spigot..."
    UpdateServer
  elif [[ $MenuNum -eq 3 ]]; then
    Backup
    echo "Backup done!"
  elif ! [[ $MenuNum -eq 4 ]]; then
    echo "Invalid option"
    sleep 0.4
  fi
done
