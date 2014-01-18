wget http://ci.md-5.net/job/Spigot/lastSuccessfulBuild/artifact/Spigot-Server/target/spigot.jar -O ./spigotnew.jar
md5sumnew=`md5sum spigotnew.jar | cut -b-32`
md5sumold=`md5sum spigot.jar | cut -b-32`
if [ "$md5sumnew" = "$md5sumold" ]; then
  echo "Spigot is already up to date."
  rm spigotnew.jar
else
  echo "Spigot is not up to date, updating now..."
  ./scripts/backup.sh
  mv spigotnew.jar spigot.jar
  echo "Update finished!"
fi
