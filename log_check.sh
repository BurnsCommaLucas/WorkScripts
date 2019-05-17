#!/bin/ksh
# AUTHOR:
#	Lucas Burns
# FUNCTION:
#	Locate and list instances of odbc.log where the file size in bytes meets or exceeds THRESHOLD
#
# DEFAULT:
#	Search recursively downward from ./ and list each file with name like "odbc.log"
#	if the size of that file is >= 100MB

USAGE() { echo "Usage: $0 [-t <threshold>]"; exit 1; }

OPTS()	{ echo -e "OPTS:\n\t-t <threshold>\n\t\tReturn log files where size >= threshold\n\t\tDefault minimum size is 100MB\n\t\tArgument input is in bytes (100000000 = 100 MB)\n\t-h\n\t\tPrint this help dialog and exit"; }

# File size lower limit to show. default is show 100MB and above
THRESHOLD=100000000
IFS=$'\n'

while getopts ":t:h" OPTION
do	
	case $OPTION in
		t)			# LISTING THRESHOLD
		if [[ "$OPTARG" =~ ^[0-9]+$ ]]
		then
			THRESHOLD=$OPTARG
		else
			echo "Error: '$OPTARG' is not a valid file size threshold"
		fi
		;;
		h)
		OPTS
		exit 0
		;;
	esac
done

# File size lower limit formatted to be user readable (100000000B => 100MB)
THRESHOLD_R=$(echo $THRESHOLD | numfmt --to=si)

########################################################
# The big cheese, get the files which match *odbc.log* #
########################################################
LINES=$(ls -l `find 2>&1 | grep -e 'odbc\.log'`)

# If the output matches the listing of ./ (the output of the above command if none are found)
# return a message indicating no logs were found
if [ "$LINES" = "$(ls -l)" ]
then 
	echo "No odbc.log files found"
	exit 0;
fi

# Place to put resulting files which meet or exceed the threshold
OUTPUT=""
for "LINE" in $LINES
do
	SIZE=$(echo $LINE | awk -F ' ' '{print $5}')
       	FILE=$(echo $LINE | grep -o '\.\/.*') # | sed -e 's/ /\\ /')
	if [ $SIZE -ge $THRESHOLD ]
       	then
		OUTPUT="${FILE}\n${OUTPUT}"
	fi
done

# if output is empty, no files matched exceeded the threshold
if [ "$OUTPUT" = "" ]
then
	echo "No odbc.log files found exceed ${THRESHOLD_R}"
	exit 0;
fi

echo "odbc.log files which exceed ${THRESHOLD_R}B:"
ls -lh `echo -e "$OUTPUT"`
