#!/bin/ksh

# Safely move things 
# Now supports multiple input files and handles paths which end with a "/"

USAGE() { echo "Usage: $0 (-a|-d|-s|-r) [-c copy] [-h help]"; exit 0; }

# Default paths
RPATH='/comdsk/burnsl/'
APATH="${RPATH}active/"
IPATH="${RPATH}inactive/"
SPATH="${RPATH}scripts/"

DEST=""		# destination for the file we want to move
CMD="mv"	# default to move file, rather than copy
PCHK=false	# flag to update permissions

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

for i in "$@"
do
	# skip flags (-a, -r, etc.)
	if [ `echo ${i} | grep "\-\w*"` ]; then; continue; fi;
	
	# "safely" rip last parts of each path given.
	# if string corresponds to a file/directory:
	if [ -e "${i}" ] || [ -d "${i}" ]
	then
		# Grab last segment of path
		TMP=`echo $i | awk -F '/' '{print $NF}'`
		if [ -z "${TMP}" ]
		then
			# or "second to last" if path ends with a "/"
			TMP=`echo $i | awk -F '/' '{print $(NF-1)}'`
			if [ -z "${TMP}" ]; then; continue; fi;
		fi
		i="${TMP}"
	fi
		
	# Check if current source matches /comdsk/burnsl (this can probably be changed to a grep)
	if [[ "${PWD}/${i}" = *"${RPATH}"* ]]
	then
		; # There was some reason I wanted to know this but honestly I don't know why
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
done
