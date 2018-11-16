#!/bin/ksh

# Safely move things 

USAGE() { echo "Usage: $0 (-a|-d|-s|-r) [-c copy] [-h help]"; exit 0; }

# Default paths
RPATH='/comdsk/burnsl/'
APATH="${RPATH}active/"
IPATH="${RPATH}inactive/"
SPATH="${RPATH}scripts/"

DEST=""		# destination for the file we want to move
CMD="mv"	# default to move file, rather than copy
PCHK=false	# flag to update permissions

# get last part of path in last argument
for i in $@; do ; done
i=`echo $i | grep -oe "[^\/]\+\/\?$"`

# I uh, don't remember what this is supposed to do...
if [ "$i" = "" ]
then
	i=`echo $i | awk -F '/' '{print $0}'`
	echo $i
fi

# Check if current directory matches /comdsk/burnsl
if [[ "${PWD}/${i}" = *"${RPATH}"* ]]
then
	; # There was some reason I wanted to know this but honestly I don't know why
fi

while getopts "cadsrh" OPTION
do	
	case $OPTION in
		c)			# COPY
       		CMD="cp -r"
		;;
		a)			# ACTIVATE
	      	DEST="${APATH}"
		PCHK=true
		;;
		d)			# DEACTIVATE
	      	DEST="${IPATH}"
		;;
		s)			# SCRIPTS
	      	DEST="${SPATH}"
		PCHK=true
		;;
		r)			# ROOT
	      	DEST="${RPATH}"
		;;
		h)
		USAGE			# HELP
		;;
	esac
done

# If destination string is empty, error out
if [ -z ${DEST} ]
then
	USAGE	
fi

# If file already exists at destination, ask about overwriting (default to not overwriting)
if [ -e ${DEST}${i} ]
then
	echo -n "$i already exists in ${DEST} Overwrite? y/[n]: "
	read LINE
	if [ "${LINE}" = 'y' -o "${LINE}" = 'Y' ]
	then
		;
	else
		exit 0
	fi
fi	

# copy, and if we need to check permission, just smash them into place 
if $CMD $i $DEST && [ $PCHK = true ]
then
	chmod -R 777 ${DEST}${i} 
fi
