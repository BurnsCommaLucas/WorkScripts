#!/bin/ksh

# There is no reason for this to be a script, but maybe someday there will be????
# This exists more as a proof of concept than anthing else I guess.

ROOT='/comdsk/burnsl'
APATH="${ROOT}/active/"
IPATH="${ROOT}/inactive/"
SPATH="${ROOT}/scripts/"

case $1 in 
	r )
	CHOICE=${ROOT}
	;;
	a )
	CHOICE=${APATH}
	;;
	i )
	CHOICE=${IPATH}
	;;
	s )
	CHOICE=${SPATH}
	;;
esac

cd ${CHOICE}${2}
