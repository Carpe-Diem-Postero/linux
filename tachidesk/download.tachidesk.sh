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
  #echo "downloading: curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x"
  status_code=$(curl --write-out %{http_code} --silent http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x)
  echo "status_code: ${status_code}  == downloading: curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x"

	if [ $status_code == 404 ] ; then
		i=$(( $i + 1 ))
		if [ $i -ge 10 ]; then
			break
		fi
	fi

  x=$(( $x + 1 ))
done


