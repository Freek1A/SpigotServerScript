function SetMemory {
  read -p "Enter the Maximum memory usage for the server (in MBs): " MaxMemory
}
function Server {
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
function CheckMemory {
  until [ $MaxMemory -gt 383 ]; do
    echo "Amount of memory is too small (less than 384MB), please adjust it"
    SetMemory
  done
  TotalMem=$(($(free|awk '/^Mem:/{print $2}')/1024))
  WarningMem=$(($TotalMem-$TotalMem/8))
  if [ $MaxMemory -gt $TotalMem ]; then
    until [ $MaxMemory -lt $TotalMem ]; do
      echo "You don't have that much memory available!"
      SetMemory
      CheckMemory
    done
  elif [ $MaxMemory -gt $WarningMem ]; then
    echo "You've assigned most of your memory to the server."
    echo "Doing so could cause problems with other programs."
    read -n 1 -p "Would you like to adjust the amount of memory for the server? y/n " warnvar
    echo " "
    if [ $warnvar = y ]; then
      SetMemory
      CheckMemory
    fi
  fi
  echo MaxMemory=$MaxMemory > ./scripts/vars
}
until [ -e "./scripts/vars" ]; do
  SetMemory
  CheckMemory
done
source ./scripts/vars
Server

