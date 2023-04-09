#!/bin/bash

IP='10.10.0.100:4567'


# USE MODE 
# bash download.tachidesk.all.sh

i=1
count_status_code=0


category=$(curl --silent http://$IP/api/v1/category/  | jq -r '.[].id' )
for cat in ${category}
do 
	echo "$(date +%Y-%m-%d_%H:%M:%S)   category:  " $cat


	LISTS=$(curl --silent http://$IP/api/v1/category/$cat  | jq -r '.[].id' )
	for LIST in ${LISTS}
	do 
		i=1
		LAST=$(curl --silent http://$IP/api/v1/manga/$LIST/chapter/1 | jq '.chapterCount')
		echo "$(date +%Y-%m-%d_%H:%M:%S)   MANGA ID: ${LIST} chapterCount ${LAST}" 

		while [ $i -le $LAST ]
		do

			downloaded=$(curl --silent http://$IP/api/v1/manga/$LIST/chapter/$i | jq '.downloaded')

			if [ $downloaded == true ]; then
				echo $(date +%Y-%m-%d_%H:%M:%S)"     curl http://$IP/api/v1/manga/$LIST/chapter/$i	downloaded:  "$downloaded
				i=$(( $i + 1 ))
				continue
			fi

			status_code=$(curl --write-out %{http_code} --silent http://$IP/api/v1/download/$LIST/chapter/$i)
			echo $(date +%Y-%m-%d_%H:%M:%S)"     curl http://$IP/api/v1/download/$LIST/chapter/$i     status_code: ${status_code}"

			if [ $status_code == 404 ] ; then
				count_status_code=$(( $count_status_code + 1 ))
				if [ $count_status_code -ge 10 ]; then
					break
				fi
			fi



			i=$(( $i + 1 ))

		done

	done

done



