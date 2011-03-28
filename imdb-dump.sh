#!/bin/sh
# Dumb Terminal  -  http://dt.tehspork.com
# IMDB Dump Script.
VER="0.7"
# Dumps select info from IMBD.com
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
#
# IMDB Dump Depends on
# elinks:  http://elinks.or.cz/
# wget:  http://www.gnu.org/software/wget/
#
sleep 2
# check
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
miNfo="$HOME/apps/miNfo/imdb"
# Cleanup first
if [ -e $miNfo/*.txt ]; then
  rm $miNfo/*.txt
fi
# IMDB link
IMDBLINK="http://www.imdb.com/title"
# ELinks
IMDUMPCAST="elinks -dump -dump-width 300 "$IMDBLINK/${TTCODE}""
# Wget
IMDUMP='wget -q -U "Mozilla/5.0 (compatible;)" -O -'
# Dump to text File
FETCHINFO=`$IMDUMP $IMDBLINK/${TTCODE} > $miNfo/${TTCODE}.txt`
$FETCHINFO
$IMDUMPCAST > $miNfo/${TTCODE}-cast.txt

IMDBCAT=$(cat $miNfo/$TTCODE.txt | grep -E '<title>|</title>' | sed -e 's/<[^>]*>//g' | sed 's|       ||g' | awk -F\| '{print "Title:"$1}')
if [ "$IMDBCAT" == "" ];then
    echo "Title: Not Found"
else
    echo -e "$IMDBCAT"
fi
echo "IMDB Page: http://www.imdb.com/title/$TTCODE "
RATING=$(cat $miNfo/$TTCODE-cast.txt | grep -E 'votes' | grep 'Users:' | sed 's/^[ \t]*//' | cut -f 1 -d "(" | cut -f2 -d " " | awk '{print $1}')
# Rating Bar # edit to fix blank char error
RATEN=$(cat $miNfo/$TTCODE-cast.txt | grep -E 'votes' | grep 'Users:' | sed 's/^[ \t]*//' | cut -f 1 -d "(" | cut -f2 -d " " | cut -f1 -d "/" | awk '{print $1}')

if [ "$RATEN" == " " ]; then
  RATEN='0'
else
  RATEN=$(cat $miNfo/$TTCODE-cast.txt | grep -E 'votes' | grep 'Users:' | sed 's/^[ \t]*//' | cut -f 1 -d "(" | cut -f2 -d " " | cut -f1 -d "/"  | cut -f 1 -d ".")
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
#RLSDTE=$(cat $miNfo/$TTCODE.txt | grep -A2 'Release Date:' | tail -1 | cut -f 1 -d "[" | awk '{print "Release Date:",$2,$1,$3}')
RLSDTEONE=$(cat -n $miNfo/$TTCODE.txt | grep -E "Release Date" | awk '{print $1}')
RLSDTETWO=$(echo $[1 + $RLSDTEONE])
RLSDTE=$(cat $miNfo/$TTCODE.txt | head -$RLSDTETWO | tail -1 | awk '{print "Release Date:" ,$0}')
if [ "$RLSDTE" == "" ];then 
    echo "Release Date: None" 
else 
    echo -e "$RLSDTE" 
fi
#RNTM=$(cat $miNfo/$TTCODE.txt | grep -A2 'Runtime:' | tail -1 | cut -c3-300 | awk -F \| '{print "Runtime:"$1}')
RNTMONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Runtime:' | awk '{print $1}')
RNTMTWO=$(echo $[2 + $RNTMONE])
RNTM=$(cat $miNfo/$TTCODE.txt | head -$RNTMTWO | tail -1 | awk '{print "Runtime:",$0}')
if [ "$RNTM" == "" ];then 
    echo "Runtime: None" 
else 
    echo -e "$RNTM" 
fi
#CNTRY=$(cat $miNfo/$TTCODE.txt | grep -A2 'Country:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "[" | awk -F\| '{print "Country:",$1,$2,$3}')
CNTRYONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Country:' | awk '{print $1}')
CNTRYTWO=$(echo $[2 + $CNTRYONE])
CNTRY=$(cat $miNfo/$TTCODE.txt | head -$CNTRYTWO | tail -1 | sed 's/<[^>]*>//g' | cut -f1 -d "&" | awk '{print "Country:",$0}')
if [ "$CNTRY" == "" ];then 
    echo "Country: None" 
else 
    echo -e "$CNTRY" 
fi
#LNG=$(cat $miNfo/$TTCODE.txt | grep -A2 'Language:' | tail -1 | cut -f 2 -d "]" | awk '{print "Language:",$1}')
LNGONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Language:' | awk '{print $1}')
LNGTWO=$(echo $[2 + $LNGONE])
LNG=$(cat $miNfo/$TTCODE.txt | head -$LNGTWO | tail -1 | sed 's/<[^>]*>//g' | cut -f1 -d "&" | awk '{print "Language:",$0}')
if [ "$LNG" == "" ];then 
    echo "Language: None" 
else 
    echo -e "$LNG" 
fi
#DIR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Director:' | tail -1 | cut -f 2 -d "]" | awk -F\| '{print "Director:",$1}')
DIRONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Director:' | awk '{print $1}')
DIRTWO=$(echo $[2 + $DIRONE])
DIR=$(cat $miNfo/$TTCODE.txt | head -$DIRTWO | tail -1 | sed 's/<[^>]*>//g' | cut -f1 -d "&" | awk '{print "Director:",$0}')
if [ "$DIR" == "" ];then 
    echo "Director: None" 
else 
    echo -e "$DIR" 
fi
#WRTR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Writer.*:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "(" | awk -F\| '{print "Writer:",$1}')
WRTRONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Writer' | awk '{print $1}')
WRTRTWO=$(echo $[4 + $WRTRONE])
WRTR=$(cat $miNfo/$TTCODE.txt | head -$WRTRTWO | tail -2 | sed 's/<[^>]*>//g' | tr -d "," | awk '{print "Writer:",$0}')
if [ "$WRTR" == "" ];then 
    echo "Write: None" 
else 
    echo -e "$WRTR" 
fi
#GNR=$(cat $miNfo/$TTCODE.txt | grep -A2 'Genres:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "|" | awk -F\| '{print "Genres:",$1}')
GNRONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Genres:' | awk '{print $1}')
GNRTWO=$(echo $[1 + $GNRONE])
GNR=$(cat $miNfo/$TTCODE.txt | head -$GNRTWO | tail -1 | sed 's/<[^>]*>//g' | sed 's/&nbsp;|//g' | sed 's| |, |g' | awk '{print "Genres:",$0}')
if [ "$GNR" == "" ];then 
    echo "Awards: None" 
else 
    echo -e "$GNR" 
fi
#CMPY=$(cat $miNfo/$TTCODE.txt | grep -A2 'Company:' | tail -1 | cut -f 2 -d "]" | cut -f 1 -d "[" | awk -F\| '{print "Company:",$1}')
CMPYONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Production Co:' | awk '{print $1}')
CMPYTWO=$(echo $[3 + $CMPYONE])
CMPY=$(cat $miNfo/$TTCODE.txt | head -$CMPYTWO | tail -1 | sed 's/<[^>]*>//g' | awk '{print "Production Co:",$0}')
if [ "$CMPY" == "" ];then 
    echo "Company: None" 
else 
    echo -e "$CMPY" 
fi
#PLT=$(cat $miNfo/$TTCODE.txt | grep -A2 'Plot:' | tail -1 | cut -f 1 -d "[" | cut -c3-700 | awk -F\| '{print "Plot:"$1}')
STYLNONE=$(cat -n $miNfo/$TTCODE.txt | grep -E 'Storyline' | awk '{print $1}')
STYLNTWO=$(echo $[2 + $STYLNONE])
STYLN=$(cat $miNfo/$TTCODE.txt | head -$STYLNTWO | tail -1 | sed 's/<[^>]*>//g' | awk '{print "Storyline:",$0}')
if [ "$STYLN" == "" ];then 
    echo "Storyline None" 
else 
    echo -e "$STYLN" 
fi
#<font color="">#</font> <font color="red">Cast Dump is clean and I'm now working on a dump of the complete cast lineup</font>
# Start Search for end of Cast lines
##
DCAST=$(cat $miNfo/$TTCODE-cast.txt | grep -A16 Cast | tail | sed 's/\[[^]\]*]//g' | tail -20 | sed '/^$/d' > $miNfo/$TTCODE-NEW-cast.txt)
rm $miNfo/$TTCODE-cast.txt
MORE=$(cat $miNfo/$TTCODE-NEW-cast.txt | grep -n more | awk '{print $1}' | tr -d ":")
if [ "$MORE" != "" ]; then
      MORE=$(cat $miNfo/$TTCODE-NEW-cast.txt | grep -n more | awk '{print $1}' | tr -d ":")
      SUBTRACT=$(expr $MORE - 1)
      MORECAST=$(cat $miNfo/$TTCODE-NEW-cast.txt | head -$SUBTRACT)
      echo "Cast:"
      echo -e "$MORECAST"
      exit 0
  else
      CAST=$(cat $miNfo/$TTCODE-NEW-cast.txt)
      echo "Cast:"
      echo -e "$CAST"
fi
fi
exit 0

