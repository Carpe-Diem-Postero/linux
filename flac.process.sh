#!/bin/bash

#sudo cp flac.process.sh /usr/local/bin/flac.process && sudo chmod o+x /usr/local/bin/flac.process
#apt-get install cuetools shntool


while getopts c:f:p: option 
do 
 case "${option}" 
 in 
 c|--cue) OPTARG_CUE=${OPTARG};; 
 f|--flac) OPTARG_FLAC=${OPTARG};; 
 p|--path) OPTARG_PATH=${OPTARG};; 
 ?|--help)
      echo "script usage: $(basename $0) [-p PATH] [ -c CUE_FILE ] [ -f FLAC_FILE ]" >&2
      echo "example: $(basename $0) [-p|--path PATH]" >&2
      echo "example: $(basename $0) [-c|--cue CUE_FILE]" >&2
      echo "example: $(basename $0) [-f|--flac FLAC_FILE]" >&2
      echo "example: $(basename $0) [-c|--cue CUE_FILE] [-f|--flac FLAC_FILE]" >&2
      exit 1
      ;;
 esac 
done 
 

DIR_CUE=$(dirname "$OPTARG_CUE") 

#DIR_PATH=${OPTARG_PATH:-$DIR_CUE}

if [ ! -z "$OPTARG_PATH" ]; then
	cd "$OPTARG_PATH"
	#echo "DIR:::::::::::"$OPTARG_PATH

elif [ ! -z "$OPTARG_CUE" ]; then
	DIR_PATH=$(dirname "$OPTARG_CUE") 
	cd "$DIR_PATH"
	#echo "DIR:::::::::::"$OPTARG_CUE
		
elif [ ! -z "$OPTARG_FLAC" ]; then
	DIR_PATH=$(dirname "$OPTARG_FLAC") 
	cd "$DIR_PATH"
	#echo "DIR:::::::::::"$OPTARG_FLAC

fi



FILENAME_CUE=`(ls -tr *.cue | head -1)`
FILENAME_FLAC=`(ls -tr *.flac | head -1)`


if [ -z "$OPTARG_CUE" ]; then
	CUE=$FILENAME_CUE
else 
	CUE=$(basename "$OPTARG_CUE")
fi
if [ -z "$OPTARG_FLAC" ]; then
	FLAC=$FILENAME_FLAC
else
	FLAC=$(basename "$OPTARG_FLAC")
fi


#CUE=$(cd "$(dirname "$CUE")"; pwd -P)/$(basename "$CUE") 
#FLAC=$(cd "$(dirname "$FLAC")"; pwd -P)/$(basename "$FLAC")


echo "CUE	:"$CUE
echo "FLAC	:"$FLAC 
echo "PWD	:"$PWD

#exit 0
if [ -n "$CUE" ]; then 
	cat "$CUE" | ionice -c3 shnsplit -o flac -t %n-%t "$FLAC" && mv	 "$FLAC" "$FLAC-bak" && cuetag "$CUE" *.flac && mv	 "$CUE" "$CUE-bak"
fi



