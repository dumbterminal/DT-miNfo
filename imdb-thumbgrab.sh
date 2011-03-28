#!/bin/sh
# Dumb Terminal  -  http://dt.tehspork.com
# iMDB ThumbGrab
VER="0.1.3"
# Grab image thumbnails from IMDB.com
##
# Smaller than Life Projects
# By: MreDD
# projects - at - Git Hub for use with
# miNfo - Mediainfo .nfo Creator
# https://github.com/dumbterminal/DT-miNfo
# MI nfoCreate  -  https://github.com/dumbterminal/DT-miNfo/blob/master/mi-nfocreate.sh
# iMDB-Dump  -  https://github.com/dumbterminal/DT-miNfo/blob/master/imdb-dump.sh
# iMDB-ThumbGrab  -  https://github.com/dumbterminal/DT-miNfo/blob/master/imdb-thumbgrab.sh
###########################
# iMDB-ThumbGrab Depends on
#  Curl  -  http://curl.haxx.se
#  WGet  -  http://www.gnu.org/software/wget/ 
##
#
CURL="/usr/bin/curl"
WGET="/usr/bin/wget"
#
echo " iMBD ThumbGrab V. $VER"
sleep 2
# check's
# curl
if [[ -z $( type -p curl ) ]]; then 
  echo -e "curl -- NOT INSTALLED !";exit
fi
# wget
if [[ -z $( type -p wget ) ]]; then 
  echo -e "wget -- NOT INSTALLED !";exit
fi
# IMDB Title
TTCODE=$1
if [ -z "$TTCODE" ]; then
  echo "Please provide a Title Number from IMDB.com (Ex: tt0083907)"
else
  unset response
# Path to Temp Folder
miNfo="$HOME/apps/miNfo"

# Path to cover
COVER="$miNfo/cover"

# Cleanup first
if [ -e $miNfo/cover/txt ]; then
  rm $miNfo/cover/txt/*.txt
fi
if [ -e $miNfo/cover/thumb ]; then
  rm $miNfo/cover/thumb/*
fi
#
cd $COVER
LINKNAIL="http://www.imdb.com/title/${TTCODE}/"
$CURL -dump $LINKNAIL > $miNfo/cover/txt/link.txt
cat $miNfo/cover/txt/link.txt | grep -A1 -i '<div class="photo">' | sed -e 1d -e 's|.*src="||' | cut -f 1 -d '"' > $miNfo/cover/txt/link2.txt
GRABNAIL=$(cat $miNfo/cover/txt/link2.txt)
if [ $GRABNAIL == ]; then
echo "Sorry No Thumbnail..."
exit
   else
cd $miNfo/cover/thumb/;$WGET $GRABNAIL
fi
LSTHUMB=$(ls $miNfo/cover/thumb/*)
if [ $LSTHUMB != *.jpg ]; then
  mv $LSTHUMB $TTCODE.jpg
else 
  convert $LSTHUMB $TTCODE.jpg
fi
fi

exit 0

