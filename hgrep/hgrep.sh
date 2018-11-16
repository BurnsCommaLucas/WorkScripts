#!/bin/ksh

# This could definitely be made more robust, check out old_ver.sh for some examples of modularity

# Get current username and use that to find our shell history file
FILE="/home/${USER}/.sh_history"
TEMP='/comdsk/burnsl/scripts/hgrep/temp.tmp'
TEMP2='/comdsk/burnsl/scripts/hgrep/temp2.tmp'

while getopts "u:" OPTION
do 
	case $OPTION in
		u)		# SPECIFY USER
		FILE="/home/${OPTARG}/.sh_history"
	     	shift 2
		;;
	esac
done

############################################################
# Copy it and NEVER TOUCH THE ORIGINAL FOR THE LOVE OF GOD #
############################################################
cat $FILE > $TEMP 

# search looking for lines containing all of our args
for ARG in "$@"
do
	# The pipe to another grep here is just to ensure I don't get results 
	# which show my grep for the string and give a false positive
	grep -a $ARG $TEMP | grep -av hgrep > $TEMP2
	cat $TEMP2 > $TEMP
done

cat $TEMP

rm $TEMP
rm $TEMP2
