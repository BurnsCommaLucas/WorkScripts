#!/bin/ksh

# Safely move things 

USAGE() { echo "Usage: $0 (-a|-d|-s|-r) [-c copy] [-h help]"; exit 0; }

#set -x

RPATH='/comdsk/burnsl/'
APATH="${RPATH}active/"
IPATH="${RPATH}inactive/"
SPATH="${RPATH}scripts/"

DEST=""		# destination for the file we want to move
CMD="mv"	# default to move file, rather than copy
PCHK=false	# flag to update permissions

# get last part of path in last argument
for i in $@; do ; done
i=`echo $i | grep -o -e "[^\/]\+\/\?$"`

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

if [ ! ${DEST} = "" ]
then
	if [ -e ${DEST}${i} ]
	then
		echo -n "$i already exists in ${DEST} Overwrite? [y]/n: "
		read LINE
		if [ "${LINE}" = 'n' -o "${LINE}" = 'N' ]
		then
			exit 0
		fi
	fi	
	
	if $CMD $i $DEST && [ $PCHK = true ]
	then
		chmod -R 777 ${DEST}${i} 
	fi
else 
	USAGE	
fi
