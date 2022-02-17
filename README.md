# ultrastar-song-downloader
Download script for downloading mp4 and mp3 files for Ultrastar

You need latest youtube-dl and ffmpeg for the bash script to work.

You can run the script by putting ./ultrastar-song-downloader which will run an example and create needed folders (songs folder). It can give a little insight on how it works.

How to use?
1. download .txt files of songs from official websites to songs/ folder which is in the same folder as the script. example folder songs/a-ha - take on me/a-ha - take on me.txt
2. run the script by running ./ultrastar-song-downloader in the terminal
3. Give correct urls for the songs
4. Wait until script ends. It will download .mp4 and convert it to .mp3 and edit .txt file.




How does it work?
- Recursively checks if folder is missing mp3 and mp4
- Downloads mp4 with youtube-dl and converts it to mp3 with ffmpeg so you have both. (the url is given manually when prompted)
- Lastly removes old #VIDEO and #MP3 from the .txt and adds the correct .mp3 and .mp4 files to #VIDEO: and #MP3: lines
