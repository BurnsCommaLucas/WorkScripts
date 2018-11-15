#!/bin/ksh

# Takes makefile name and creates my normal testing directory structure with the checked out files

mkdir $1
chmod 777 $1
if [ -z "$(ls -A $1)" ]
then
	cd $1
	ckm $1
	
	if [ -e makefile ]
	then
		mkdir vs
		chmod 777 vs
		make view
		cp * vs 2>&1
	else
	       	cd ..
		rm -rf $1
	fi
fi
