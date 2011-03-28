#!/bin/sh
# IMDB Dump Script.
VER="0.6-1"
# http://script.m-redd.com
# Smaller than Life Projects
# By: MreDD
# projects - at - 0tue0 (dot) com
# a tool for <a href="http://script.m-redd.com/dvdre.htm">DvDre x264 to MKV|MP4</a>
# for use with
# <a href="http://script.m-redd.com/mi-nfocreate.htm">MI nfoCreate Script</a>
# <a href="http://script.m-redd.com/imdb-thumbgrab.htm">iMDB-ThumbGrab Script</a>
#
###########################
#
# IMDB Dump Depends on
# elinks:        http://elinks.or.cz/
#
sleep 2
# check
if [[ -z $( type -p elinks ) ]]; then 
  echo -e "elinks -- NOT INSTALLED !";exit
fi
# IMDB Title
TTCODE=$1
if [ -z "$TTCODE" ]; then
  echo "Please provide a Title Number from IMDB.com (Ex: tt0083907)"
else
  unset response
# Path to Temp Folder
miNfo="$HOME/apps/miNfo/imdb"
# Cleanup first
if [ -e $miNfo/*.txt ]; then
  rm $miNfo/*.txt
fi
# IMDB link
IMDUMP="elinks -dump -dump-width 300 "http://www.imdb.com/title/${TTCODE}""
# Dump to text File
$IMDUMP >> $miNfo/$TTCODE.txt

IMDBCAT=$(cat $miNfo/$TTCODE.txt | grep -Eo 'IMDb\ >.*' | cut -f 2 -d ">" | awk -F\| '{print "Title:"$1}')
if [ "$IMDBCAT" == "" ];then
    echo "Title: None"
else
    echo -e "$IMDBCAT"
fi
echo "IMDB Page: http://www.imdb.com/title/$TTCODE "
RATING=$(cat $miNfo/$TTCODE.txt | grep 'votes' | sed 's/^[ \t]*//' | cut -f 1 -d "[" | awk -F\| '{print "Rating:",$1}')
# Rating Bar # edit to fix blank char error
RATEN=$(cat $miNfo/$TTCODE.txt | grep 'votes' | sed 's/^[ \t]*//' | cut -f 1 -d "[" | awk -F\| '{print $1}' | tr -d "(,)" | awk '{print $1}')

if [ "$RATEN" == "awaiting" ]; then
  RATEN='0'
else
  RATEN=$(cat $miNfo/$TTCODE.txt | grep 'votes' | sed 's/^[ \t]*//' | cut -f 1 -d ".")
fi

RBARS=$(expr $RATEN / 1)

case $RBARS in
#
        1)
#
                BAR='[*---------]'
#
                ;;
#
        2)
#
                BAR='[**--------]'
#
                ;;
#
        3)
#
                BAR='[***-------]'
#
                ;;
#
        4)
#
                BAR='[****------]'
#
                ;;
#
        5)
#
                BAR='[*****-----]'
#
                ;;
#
        6)
#
                BAR='[******----]'
#
                ;;
#
        7)
#
                BAR='[*******---]'
#
                ;;
#
        8)
#
                BAR='[********--]'
#
                ;;
#
        9)
#
                BAR='[*********-]'
#
                ;;
#
        10)
#
                BAR='[**********]'
#
                ;;
#
        *)
#
                BAR='[----------]'
#
esac
#
echo -e "$RATING $BAR"
RLSDTE=$(cat $miNfo/$TTCODE.txt | grep -A2 'Release Date:' | tail -1 | cut -f 1 -d "[" | awk '{print "Release Date:",$2,$1,$3}')
if [ "$RLSDTE" == "" ];then 
    echo "Release Date: None" 
else 
    echo -e "$RLSDTE" 
fi
RNTM=$(cat $miNfo/$TTCODE.txt | grep -A2 'Runtime:' | tail -1 | cut -c3-300 | awk -F \| '{print "Runtime:"$1}')
if [ "$RNTM" == "" ];then 
    echo "Runtime: None" 
else 
    echo -e "$RNTM" 
fi
CNTRY=$(cat $miNfo/$TTCODE.txt | grep -A2 'Country:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "[" | awk -F\| '{print "Country:",$1,$2,$3}')
if [ "$CNTRY" == "" ];then 
    echo "Country: None" 
else 
    echo -e "$CNTRY" 
fi
LNG=$(cat $miNfo/$TTCODE.txt | grep -A2 'Language:' | tail -1 | cut -f 2 -d "]" | awk '{print "Language:",$1}')
if [ "$LNG" == "" ];then 
    echo "Language: None" 
else 
    echo -e "$LNG" 
fi
DIR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Director:' | tail -1 | cut -f 2 -d "]" | awk -F\| '{print "Director:",$1}')
if [ "$DIR" == "" ];then 
    echo "Director: None" 
else 
    echo -e "$DIR" 
fi
WRTR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Writer.*:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "(" | awk -F\| '{print "Writer:",$1}')
if [ "$WRTR" == "" ];then 
    echo "Write: None" 
else 
    echo -e "$WRTR" 
fi
GNR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Genre:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "|" | awk -F\| '{print "Genre:",$1}')
echo -e "$GNR"
AWDS=$(cat $miNfo/$TTCODE.txt | grep -A2 'Awards:' | tail -1 | cut -f 1 -d "[" | cut -c3-700 | awk -F\| '{print "Awards:"$1}')
if [ "$AWDS" == "" ];then 
    echo "Awards: None" 
else 
    echo -e "$AWDS" 
fi
CMPY=$(cat $miNfo/$TTCODE.txt | grep -A2 'Company:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "[" | awk -F\| '{print "Company:",$1}')
if [ "$CMPY" == "" ];then 
    echo "Company: None" 
else 
    echo -e "$CMPY" 
fi
PLT=$(cat $miNfo/$TTCODE.txt | grep -A2 'Plot:' | tail -1 | cut -f 1 -d "[" | cut -c3-700 | awk -F\| '{print "Plot:"$1}')
if [ "$PLT" == "" ];then 
    echo "Plot: None" 
else 
    echo -e "$PLT" 
fi
#<font color="">#</font> <font color="red">Cast Dump is clean and I'm now working on a dump of the complete cast lineup</font>
# Start Search for end of Cast lines
##
DCAST=$(cat $miNfo/$TTCODE.txt | grep -A16 Cast | tail | sed 's/\[[^]\]*]//g' | tail -20 | sed '/^$/d' > $miNfo/$TTCODE-NEW.txt)
rm $miNfo/$TTCODE.txt
MORE=$(cat $miNfo/$TTCODE-NEW.txt | grep -n more | awk '{print $1}' | tr -d ":")
if [ "$MORE" != "" ]; then
      MORE=$(cat $miNfo/$TTCODE-NEW.txt | grep -n more | awk '{print $1}' | tr -d ":")
      SUBTRACT=$(expr $MORE - 1)
      MORECAST=$(cat $miNfo/$TTCODE-NEW.txt | head -$SUBTRACT)
      echo "Cast:"
      echo -e "$MORECAST"
      exit 0
  else
      CAST=$(cat $miNfo/$TTCODE-NEW.txt)
      echo "Cast:"
      echo -e "$CAST"
fi
fi
exit 0

