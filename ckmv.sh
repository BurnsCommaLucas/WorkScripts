#!/bin/ksh

# Takes makefile name and creates my normal testing directory structure with the checked out files

# Make the directory for the file we want
mkdir $1

# Make it usable by all users
chmod 777 $1

# If the mkdir worked,
if [ -z "$(ls -A $1)" ]
then
	# Move in and check out the desired makefile
	cd $1
	ckm $1
	
	# If we got a makefile
	if [ -e makefile ]
	then
		# Create the vs directory, view all files, copy them to that directory
		mkdir vs
		chmod 777 vs
		make view
		cp * vs 2>&1
	else
		# Go back, dump the dir we made (ckm throws an error message for not found)
	       	cd ..
		rm -rf $1
	fi
fi
