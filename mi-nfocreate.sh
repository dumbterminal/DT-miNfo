#!/bin/sh
# MI-NFOcreate (Mediainfo|IMDB-dump to .nfo .htm)
VER="0.4.3"
# Create NFO|HTM File
# http://script.m-redd.com
# Smaller than Life Projects
# By: MreDD
# projects - at - 0tue0 (dot) com
# a tool for <a href="http://script.m-redd.com/dvdre.htm">DvDre x264 to MKV|MP4</a>
#
###########################
# Example of finished nfo|htm files here
#
# <a href="http://script.m-redd.com/Lucky.Number.Slevin%5b2006%5ddvdrip(reDD).nfo">Click for Example NFO File</a>
#
# <a href="http://script.m-redd.com/Lucky.Number.Slevin%5b2006%5ddvdrip(reDD).htm">Click for Example HTM(L) File</a>
#
###########################
#
# MI NFOcreate Depends on
# <a href="http://script.m-redd.com/imdb-dump.htm">iMDB-Dump Script</a>
# <a href="http://script.m-redd.com/imdb-thumbgrab.htm">iMDB-ThumbGrab Script</a>
# <a href="http://mediainfo.sourceforge.net/en">Mediainfo</a>
# <a href="http://elinks.or.cz">eLinks</a>
# <a href="http://curl.haxx.se">Curl</a>
#
############################
#
############################
############################
#####    DIR   PATH    #####
############################
############################
#
# Path to Working Directory
VIDEODIR="$HOME/Rip/done"
# Path to miNfo Directory
miNfo="$HOME/apps/miNfo"
# Path to SAVE nfo folder
SAVE="$miNfo/nfo"
# Path inside Temp Directory Script works in
TMPWRK="$miNfo/wrk"
# Cleanup first
if [ -e $TMPWRK ]; then
  rm $TMPWRK/*
fi
#
############################
############################
#####  END DIR   PATH  #####
############################
############################

############################
############################
#####  SCRIPTS  PATH   #####
############################
############################
#
# Path to imdb-dump.sh
IMDUMP="$miNfo/imdb-dump.sh"
# Path to minfohelp directory containing tag.txt, pre1.txt and pre2.txt Files - files w/get packed w/finished script.
MINFOHELP="$miNfo/minfohelp"
# Path to imdb-thumbgrab.sh
IMDTHUM="$miNfo/imdb-thumbgrab.sh"
THUMBNAIL="$TTCODE.jpg"
#
############################
############################
####  END SCRIPTS PATH  ####
############################
############################

############################
############################
#####   APPS  PATH     #####
############################
############################
#
# Path to Mediainfo
MINFO="/usr/bin/mediainfo"
#
############################
############################
#####  END APPS PATH   #####
############################
############################

############################
############################
#### START   QUESTIONS  ####
############################
############################
#
# Title
cd $VIDEODIR
TITLE=$(ls | sed '$s/....$//')
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%% Name your .nfo and .htm files here"
echo "%%  Default Title: $TITLE"
echo "%% Would you like to Name the Title?"
echo "%% Press: (y|n) "
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
read TITLE
case $TITLE in
	y|yes)
	  echo "Enter Title Name: "
          echo "------------------"
	   	read TITLE ;;
	n|no)
		TITLE=$(ls | sed '$s/....$//') ;;
	*)
	echo "Error Valid Choices are y|n"
	exit 1 ;;
    esac
echo ""
echo ""
# ttcode
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%% iMBD Dump needs the ttcode "
echo "%%   from http://imdb.com"
echo "%% Example:  http://www.imdb.com/title/tt0083907"
echo "%% ttcode would be tt0083907"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""
echo " Type in the ttcode hit Enter"
read TTCODE
echo ""
echo "Your ttcode: $TTCODE"
echo ""
#
############################
############################
###  END START QUESTIONS ###
############################
############################

############################
############################
#####      START       #####
############################
############################
#

echo " MI nfoCreate V. $VER"
sleep 3
# start
cd $VIDEODIR
echo " -- MI - NFOcreate -- "
echo " "
sleep 2
mkdir -p $SAVE/$TITLE
sleep 2
# Create the NFO TEXT File
echo " -- Creating $TITLE.nfo -- "
echo " "
sleep 2
$MINFO * >> $TMPWRK/$TITLE.nfo
$IMDUMP $TTCODE > $TMPWRK/$TTCODE.temp
cat $MINFOHELP/tag.txt $TMPWRK/$TTCODE.temp $TMPWRK/$TITLE.nfo >> $SAVE/$TITLE/$TITLE.nfo
echo " -- Done Creating $TITLE.nfo File -- "
echo " "
sleep 1
echo " -- Creating $TITLE.htm File -- "
sleep 2
# Create the NFO in HTML File
$MINFO --Output=HTML * >> $TMPWRK/$TITLE.htm
lines=$(wc -l $TMPWRK/$TITLE.htm | awk '{print $1}')
x="$lines"
y="8"
sub=$(($x - $y))
tail -$sub $TMPWRK/$TITLE.htm | awk -F\| '{print $1}' >> $TMPWRK/prt2.htm
cat $TMPWRK/$TITLE.htm | grep "General" -B5 -A0 | awk -F\| '{print $1}' >> $TMPWRK/prt1.htm
cat $TMPWRK/prt1.htm $MINFOHELP/pre1.txt >>  $TMPWRK/prt3.htm
cat $MINFOHELP/pre2.txt $TMPWRK/prt2.htm >> $TMPWRK/prt4.htm
echo ""
cat $TMPWRK/prt3.htm $MINFOHELP/tag.txt $TMPWRK/$TTCODE.temp $TMPWRK/prt4.htm >> $SAVE/$TITLE/$TITLE.htm
echo " "
sleep 1
echo " -- Done Creating $TITLE.htm File -- "
echo " "
sleep 1
echo " -- Starting iMDB ThumbGrab -- "
sleep 1
$IMDTHUM $TTCODE
sleep 1
echo " -- Done with iMDB ThumbGrab -- "
echo " -- Renaming and Moving Thumbnail -- "
mv $miNfo/cover/thumb/$TTCODE.jpg $SAVE/$TITLE/$TITLE.jpg
echo " -- Done Renaming and Moving Thumbnail --"
echo " "
sleep 1
echo " -- Thank You for Using MI-nfoCreate -- "
echo " -- a script by: MreDD -- "
sleep 1
echo " fin "

#
############################
############################
#####        END       #####
############################
############################

exit 0
