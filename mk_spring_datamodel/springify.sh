#!/bin/ksh
#
# Given an informix database name and an informix table, create a java spring datamodel class for that table

CLASS=""
TABLE="${2}"
TEMP="table.tmp"
F1="tmp1"
F2="tmp2"
MAPFILE="map.txt"
OUT=".txt"

while getopts ":c:" OPTION
do
	case $OPTION in

	# Override class name with OPTARG
	c)
	CLASS="${OPTARG}"
	;;
	esac
done

if [ "$CLASS" == "" ]
then
	CLASS=${TABLE}
fi

if [ "${CLASS}" == "" ] || [ "${1}" == "" ]
then
	echo "USAGE: $0 <DBName> <TableName> (-c override-class-name)"
	exit 0;
fi

OUT=${CLASS}${OUT}

# get table columns and get rid of everything that isnt a column definition
# These seds are a huge mess, but I couldn't get the "in place" operations to not wipe out my whole file for some reason
dbschema -q -d "${1}" -t "${TABLE}" > ${F1}
cat ${F1} | awk '{$1=$1};1' > ${F2}
sed '/^create table/d' ${F2} > ${F1}
sed '/^revoke all/d' ${F1} > ${F2}
sed '/^{ TABLE/d' ${F2} > ${F1}
sed '/^$/d' ${F1} > ${F2}
sed '/^(/d' ${F2} > ${F1}
sed '/^)/d' ${F1} > ${TEMP}

# Map column types to Java var types from mapfile
typeset -A REF
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
	KEY=`echo $LINE | awk '{print $1}'`
	VAL=`echo $LINE | awk '{print $2}'`
	REF[$KEY]=$VAL
done < $MAPFILE

# map column names to a Java type
typeset -A MAP
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
	KEY=`echo $LINE | awk '{print $1}'`
	VAL=`echo $LINE | awk '{print $2}' | tr -d ','`

	PUT="${REF[$VAL]}"
	if [[ "${VAL}" = *"char"* ]]
	then
		NUM=`echo $VAL | awk -F '(' '{print $2}' | tr -d ')'`
		if [ $NUM -eq 1 ]
		then 
			PUT="Character"
		else 
			PUT="String"
		fi
	elif [[ "${VAL}" = *"decimal"* ]]
	then	
		PUT="Float"
	fi

	MAP[$KEY]=$PUT
done < $TEMP

# Create file header with imports and class definition
PRE1="import java.io.Serializable;\n\nimport javax.persistence.Column;\nimport javax.persistence.Entity;\nimport javax.persistence.Id;\n\n@Entity\npublic class"
PRE2="implements Serializable {\n\tprivate static final long serialVersionUID = 1L;\n\t"
echo -en "${PRE1} ${CLASS} ${PRE2}"  > ${OUT}

# Create class member definitions
for VAR in "${!MAP[@]}"
do
	echo -en "private ${MAP[$VAR]} ${VAR};\n\t" >> ${OUT}
	LAST=$VAR
done

# Create constructor
echo -en "\n\tpublic ${CLASS}(" >> ${OUT}
for VAR in "${!MAP[@]}"
do
	echo -en "${MAP[${VAR}]} ${VAR}" >> ${OUT}
	if [ ${VAR} == ${LAST} ]
	then
		echo -en ") {\n" >> ${OUT}
	else 
		echo -en ",\n\t\t\t" >> ${OUT}
	fi
done
for VAR in "${!MAP[@]}"
do
	echo -en "\t\tthis.${VAR} = ${VAR};\n" >> ${OUT}
done
echo -en "\t}\n\n" >> ${OUT}

# Create Getters/Setters
GETHDR="\t@Id\n\t@Column(name = \""
for VAR in "${!MAP[@]}"
do
	CAMEL=$(echo ${VAR} | sed -e "s/\b\(.\)/\u\1/g")

	# GETTER
	echo -en "${GETHDR}${VAR}\")\n\tpublic ${MAP[$VAR]} get${CAMEL}() {\n\t\treturn ${VAR};\n\t}\n\n" >> ${OUT}

	# SETTER
	echo -en "\tpublic void set${CAMEL}(${MAP[$VAR]} ${VAR}) {\n\t\tthis.${VAR} = ${VAR};\n\t}\n\n" >> ${OUT}
done

# End file, cleanup
echo "}" >> ${OUT}
rm ${TEMP} ${F1} ${F2} ${MAPFILE}