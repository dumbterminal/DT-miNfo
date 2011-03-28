#!/bin/sh
# Dumb Terminal  -  http://dt.tehspork.com
# iMDB ThumbGrab
VER="0.1.4"
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
#  ELinks  -  http://elinks.or.cz/
#  WGet  -  http://www.gnu.org/software/wget/ 
##
#
ELINKS="/usr/bin/elinks"
WGET="/usr/bin/wget"
#
echo " iMBD ThumbGrab V. $VER"
sleep 2
# check's
# elinks & wget
if [[ -z $( type -p elinks ) ]]; then 
  echo -e "elinks -- NOT INSTALLED !";exit
elif [[ -z $( type -p wget ) ]]; then 
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
$ELINKS -dump -dump-width 300 "$LINKNAIL" > $miNfo/cover/txt/link.txt
cat $miNfo/cover/txt/link.txt | grep "http://ia.media-imdb.com/images/" | awk '{print $2}' > $miNfo/cover/txt/link2.txt
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

