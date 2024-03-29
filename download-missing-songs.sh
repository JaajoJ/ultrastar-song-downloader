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
IMAGEFOUND=0
#Making array of songs without mp3 and mp4 downloaded
for d in *; do
	cd "$d"
	SONGFOUND=0
	IMAGEFOUND=0
	for f in *; do
		echo "$f"
		#check for mp3
		if [[ "${f: -4}" == ".mp3" ]]; then
			SONGFOUND=1
		fi
		
		if [[ "${f: -4}" == ".jpg" ]]; then
			IMAGEFOUND=1
		fi
	done;
	
	#Adds the missing song to list
	if [[ "$SONGFOUND" == 0 ]]; then
		MISSINGSONGS+=("$d")
	fi
	#Downloads cover image if missing by asking for url
	if [[ "$IMAGEFOUND" == 0 ]]; then
		firefox "https://www.google.com/search?q=$d+album+cover+hd"
		sed -i '/#COVER:/d' *.txt
		echo "Cover IMAGE missing"
		read -p 'URL: ' IMAGEURL
		curl $IMAGEURL > "[CO].jpg" 
	fi
	
	echo "mp3 found: "$SONGFOUND
	cd ..

done;

#Getting urls for the songs
for value in "${MISSINGSONGS[@]}"
do
    	echo ""
	firefox "https://www.youtube.com/results?search_query=$value"
	echo "Give youtube url for:"
	echo $value
	read INPUT
	URLS+=("$INPUT")
done


#Going one by one to folder and downloading needed songs in parallel 
getMP3andMP4(){
	youtube-dl -o download.mp4 --format mp4 "${URLS[$COUNT]}"
	ffmpeg -i *.mp4 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 download.mp3

	#First remove then add the songs
	
	sed -i '/#VIDEO:/d' *.txt && sed -i '1 i\#VIDEO:download.mp4' *.txt
	sed -i '/#MP3:/d' *.txt && sed -i '1 i\#MP3:download.mp3' *.txt

}

COUNT=0
PARALLELDOWNLOADS=40
for value in "${MISSINGSONGS[@]}"; do
	cd "$value"
	echo $PWD
	echo "${URLS[$COUNT]}"
	((i=i%PARALLELDOWNLOADS)); ((i++==0)) && wait
	getMP3andMP4 &
	COUNT=$COUNT+1
	cd ..
done

cd ..
ls songs/ > songlist.txt
