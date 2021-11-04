#!/bin/bash



# USE MODE 
# sh download.tachidesk.sh ID-MANGA START FINISH
# sh download.tachidesk.sh 2 1 300

ID=$1
START=$2
FINISH=$3


x=$START
i=1


while [ $x -le $FINISH ]
do

	downloaded=$(curl --silent http://192.168.0.10:4567/api/v1/manga/$ID/chapter/$x | jq '.downloaded')

	if [[ $downloaded == true ]]; then
		echo $(date +%Y-%m-%d_%H:%M:%S)"  curl --silent http://192.168.0.10:4567/api/v1/manga/$ID/chapter/$x	downloaded:  "$downloaded
		x=$(( $x + 1 ))
		continue
	fi


	#echo "downloading: curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x"
	status_code=$(curl --write-out %{http_code} --silent http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x)
	echo $(date +%Y-%m-%d_%H:%M:%S)"  curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x     status_code: ${status_code}"

	if [ $status_code == 404 ] ; then
		i=$(( $i + 1 ))
		if [ $i -ge 10 ]; then
			break
		fi
	fi

	x=$(( $x + 1 ))
done


