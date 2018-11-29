#!/bin/ksh
# find instance(s) of RCS file where string was added added/removed
# 
# DEFAULT:
#	Search upwards from revision earliest to current, append version number to list
#	and continue searching
# OPTS:
#	h: print help dialog and exit
#	n: list only files which do not contain the string
# NOTES:
#	If both input strings are file names, the first will be interpreted as the 
#	file to search in, and the second will be the string being searched for.


USAGE() { echo "Usage: $0 <-h> <-n> [FILE] [PATTERN]"; exit 0; }

OPTS()	{ echo -e "OPTS:\n\t-N\n\t\tReturn revisions where pattern does NOT appear\n\t\t(default is where pattern does appear)\n\t-h\n\t\tPrint this help dialog and exit\n\n\t\tSupports all default grep arguments except recursive."; }

NOT=false
REC_ERR=false
CMDOPTS="-q"

# Process command line args (leading ":" means don't process errors)
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
		R | r)			# RECURSIVE (ignore, return error, but continue)
		if [ $REC_ERR = false ]
		then
			echo "This script does not support processing files recursively."
			REC_ERR=true
		fi
		;;
		*)			# DEFAULT (flag stashed in OPTARG)
		CMDOPTS="${CMDOPTS}${OPTARG}"
		;;
	esac
done

# HEY DUMMY, YOU'RE GOING TO COME LOOKING FOR THIS LATER, THE QUOTES LET YOU PRESERVE QUOTED ARGS
for i in "$@"
do 
	# If $i is a flag (dash followed by one or more word characters) ignore it
	if [ ! `echo ${i} | grep "\-\w*"` ]
	then
		# if $i is a file which exists and we do not already have a file
		if [ -e ${i} ] && [ -z ${FILE} ]
		then	
			FILE=${i}
		else
			SEARCH=${i}
		fi
	fi
done

# If file name or search string are length 0, stop
if [ -z "$FILE" ] || [ -z "$SEARCH" ]
then
	USAGE
fi

# If our file is the RCS version, cut the ",v" off for processing
if [[ "${FILE}" = *",v" ]]
then
	FILE=`echo $FILE | rev | cut -c 3- | rev`
fi

# Read the logfile, grep lines like "revision #.#", tear out the "revision" parts
REVS=`rlog $FILE | grep -o "^revision\s[0-9]\+\.[0-9]\+" | sed 's/revision//g'`

# Result bucket
LIST=""

# Be clear and helpful
FIRST=`echo $REVS | awk '{print $NF}'`
LAST=`echo $REVS | awk '{print $1}'`

echo "Searching file '${FILE}'"
echo -e "First revision:\t\t${FIRST}\nLatest revision:\t${LAST}"

if [ "$NOT" = true ]
then
	COND="does not appear"
else 
	COND="appears"
fi

echo "'${SEARCH}' ${COND} in version(s):"

# iterate through and if a version contains (or doesnt contain) the string, add it to the list
for i in $REVS
do
	# quietly check out revision {i} of {FILE}
	co -q -r${i} $FILE
	if cat $FILE | grep ${CMDOPTS} "$SEARCH"
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

# If the list is empty, don't just give an empty list
if [ -z "$LIST" ]
then
	echo "None"
else
	echo $LIST
fi
