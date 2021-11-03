#!/bin/bash



# USE MODE 
# sh download.tachidesk.sh ID-MANGA START FINISH
# sh download.tachidesk.sh 2 1 300

ID=$1
START=$2
FINISH=$3


x=$START
while [ $x -le $FINISH ]
do
  echo "downloading: curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x"
  x=$(( $x + 1 ))
  curl http://192.168.0.10:4567/api/v1/download/$ID/chapter/$x
done


