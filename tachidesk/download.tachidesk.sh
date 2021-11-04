#!/bin/bash

IP='localhost:4567'

START=1
# USE MODE 
# bash download.tachidesk.sh -i 514
# bash download.tachidesk.sh -i 514 --start 1 --finish 10 -ip 192.168.0.10:4567
# 


POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -ip|--ip)
      IP="$2"
      shift # past argument
      shift # past value
      ;;
    -i|--id)
      ID="$2"
      shift # past argument
      shift # past value
      ;;
    -s|--start)
      START="$2"
      shift # past argument
      shift # past value
      ;;
    -f|--finish)
      FINISH="$2"
      shift # past argument
      shift # past value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -z $FINISH ]]; then
	FINISH=$(curl --silent http://$IP/api/v1/manga/$ID/chapter/1 | jq '.chapterCount')
fi

echo "IP        -ip|--ip      = ${IP}"
echo "MANGA ID   -i|--id      = ${ID}"
echo "START      -s|--start   = ${START}"
echo "FINISH     -f|--finish  = ${FINISH}"

echo ""



x=$START
i=1


while [ $x -le $FINISH ]
do

	downloaded=$(curl --silent http://$IP/api/v1/manga/$ID/chapter/$x | jq '.downloaded')

	if [[ $downloaded == true ]]; then
		echo $(date +%Y-%m-%d_%H:%M:%S)"  curl http://$IP/api/v1/manga/$ID/chapter/$x	downloaded:  ${downloaded}"
		x=$(( $x + 1 ))
		continue
	fi


	#echo "downloading: curl http://$IP/api/v1/download/$ID/chapter/$x"
	status_code=$(curl --write-out %{http_code} --silent http://$IP/api/v1/download/$ID/chapter/$x)
	echo $(date +%Y-%m-%d_%H:%M:%S)"  curl http://$IP/api/v1/download/$ID/chapter/$x     status_code: ${status_code}"

	if [ $status_code == 404 ] ; then
		i=$(( $i + 1 ))
		if [ $i -ge 10 ]; then
			break
		fi
	fi

	x=$(( $x + 1 ))
done


