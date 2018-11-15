#!/bin/ksh
# find instance(s) of RCS file where string was added added/removed
# 
# DEFAULT:
#	Search upwards from revision 1.1 to current, append version number to list
#	and continue searching
# OPTS:
#	h: print help dialog and exit
#	n: list only files which do not contain the string

#set -x

USAGE() { echo "Usage: $0 <-h> <-n> [FILE] [PATTERN]"; exit 0; }

OPTS() 	{ echo -e "OPTS:\n\t-N\n\t\tReturn revisions where pattern does NOT appear\n\t\t(default is where pattern does appear)\n\t-h\n\t\tPrint this help dialog and exit\n\n\t\tSupports all default grep arguments except recursive."; }

#\n\t-f FILE\n\t\tREQUIRED, indicate to the program which RCS file\n\t\tto search, can be given absolute/relative path\n\t\twith or without *,v extension\n\t-s PATTERN\n\t\tREQUIRED, indicate to the program what to search for in the file"; }

NOT=false
REC_ERR=false
CMD="grep"
CMDOPTS="-q"

while getopts ":NhdrR" OPTION
do	
	case $OPTION in
		N)			# NOT IN FILE
       		NOT=true
		;;
		h)			# HELP
		OPTS
		;;
		d)			# DEBUG
		echo "This is the debug option, this script does not support processing files recursively."
		REC_ERR=true
		set -x
		;;
		R | r)
		if [ $REC_ERR = false ]
		then
			echo "This script does not support processing files recursively."
			REC_ERR=true
		fi
		;;
		*)			# DEFAULT (value stashed in OPTARG)
		CMDOPTS="$CMDOPTS -$OPTARG"
		;;
		#f)			# FILE
		#FILE=$OPTARG
		#;;
		#s)			# SEARCH STRING
		#SEARCH=$OPTARG
		#;;
	esac
done

# HEY DUMMY, YOU'RE GOING TO COME LOOKING FOR THIS LATER, THE QUOTES LET YOU PRESERVE QUOTED ARGS
for i in "$@"
do 
	if [ ! `echo ${i} | grep "\-\w*"` ]
	then
		if [ -e ${i} ]
		then	
			FILE=${i}
		else
			SEARCH=${i}
		fi
	fi
done

if [ -z "$FILE" ] || [ -z "$SEARCH" ]
then
	USAGE
fi

if [[ "${FILE}" = *",v" ]]
then
	FILE=`echo $FILE | rev | cut -c 3- | rev`
fi

REVS=`rlog $FILE | grep -o "\([0-9]\+\.[0-9]\+\$\)"`
REVS=`echo $REVS | awk '{$1=""; print $0}'`
LIST=""

FIRST=`echo $REVS | awk '{print $NF}'`
LAST=`echo $REVS | awk '{print $1}'`

echo "Searching file '${FILE}'"
echo -e "First revision:\t\t${FIRST}\nLatest revision:\t${LAST}"
BEG="'${SEARCH}'"
if [ "$NOT" = true ]
then
	MID="does not appear"
else 
	MID="appears"
fi
END="in version(s):"

echo "${BEG} ${MID} ${END}"

# iterate through and if a version contains the string, stop and echo something
for i in $REVS
do
	co -q -r${i} $FILE
	if cat $FILE | ${CMD} ${CMDOPTS} "$SEARCH"
	then
		if [ "$NOT" = false ]
		then
			LIST="$LIST $i"
		fi
	elif [ "$NOT" = true ]
	then
		LIST="$LIST $i"
	fi
done

if [ -z "$LIST" ]
then
	echo "None"
else
	echo $LIST
fi
