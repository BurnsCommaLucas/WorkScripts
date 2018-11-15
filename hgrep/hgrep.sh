#!/bin/ksh

# This could definitely be made more robust, check out old_ver.sh for some examples of modularity

FILE="/home/${USER}/.sh_history"
TEMP='/comdsk/burnsl/scripts/hgrep/temp.tmp'
TEMP2='/comdsk/burnsl/scripts/hgrep/temp2.tmp'

while getopts "u" OPTION
do 
	case $OPTION in
		u)
		FILE="/home/${2}/.sh_history"
		shift 2
		;;
	esac
done

############################################################
# Copy it and NEVER TOUCH THE ORIGINAL FOR THE LOVE OF GOD #
############################################################
cat $FILE > $TEMP 

for ARG in $*; do
	# The pipe to another grep here is just to ensure I don't get results 
	# which show my grep for the string and give a false positive
	grep -a $ARG $TEMP | grep -av hgrep > $TEMP2
	cat $TEMP2 > $TEMP
done

cat $TEMP

rm $TEMP
rm $TEMP2
