#!/bin/sh
cd $PWD
#creating songs folder
dir=songs
if [ ! -d $dir ]
then
    mkdir -p songs/give-any-url-testing-file && touch songs/give-any-url-testing-file/testing.txt
fi


cd songs/

MISSINGSONGS=()
URLS=()
SONGFOUND=0
#Making array of songs without mp3 and mp4 downloaded
for d in *; do
	cd "$d"
	SONGFOUND=0
	for f in *; do
		echo "$f"
		#check for mp3
		if [[ "${f: -4}" == ".mp3" ]]; then
			SONGFOUND=1
		fi
	done;

	if [[ "$SONGFOUND" == 0 ]]; then
		MISSINGSONGS+=("$d")
	fi
	echo "mp3 found: "$SONGFOUND
	cd ..

done;

#Getting urls for the songs
for value in "${MISSINGSONGS[@]}"
do
    	echo ""
	echo "Give youtube url for:"
	echo $value
	read INPUT
	URLS+=("$INPUT")
done


#Going one by one to folder and downloading needed songs
COUNT=0
for value in "${MISSINGSONGS[@]}"; do
	cd "$value"
	echo $PWD
	echo "${URLS[$COUNT]}"
	youtube-dl -o download.mp4 --format mp4 "${URLS[$COUNT]}"
	ffmpeg -i *.mp4 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 download.mp3

	#First remove then add the songs
	grep -v '^#VIDEO:' *".txt" > temp && mv temp *".txt"
	grep -v '^#MP3:' *".txt" > temp && mv temp *".txt"

	echo '#MP3:download.mp3' | cat - *".txt" > temp && mv temp *".txt"
	echo '#VIDEO:download.mp4' | cat - *".txt" > temp && mv temp *".txt"
	COUNT=$COUNT+1
	cd ..
done

cd ..
ls songs/ > songlist.txt
