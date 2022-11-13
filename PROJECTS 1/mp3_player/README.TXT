
MP3 Player Example
=================================================================

To play mp3s:
 
1.)  Create a directory on the SD Card named /MP3/media.  
2.)  Dump all your mp3s in that directory (they can be in seperate 
     subdirectories).  
3.)  Copy the .flash files located in mp3_player/flash_files of this .zip 
     file to the SD Card directory /Altera_EEK_Applications/MP3 Player
4.)  Load the MP3 player with the App Selector.
 
The player will recursively scan the /MP3/media directory and build a 
database of all the MP3 files.  This will take a little time.  Then it 
will begin playing.  Any time you change the MP3 files on the card (or 
the player fails to open one it has in its database), it will re-scan 
the /MP3/media directory and rebuild the database.
 
Controls:
=================================================================
Skip, Play, Pause..
Touch the progress bar to skip to that place in the song
Touch Vol or Bal to change the volume or left-right balance
Touch and release a song in the playlist to begin playing that song.
Touch the scroll bar in the playlist to scroll through the playlist
Touch the scroll bar in the Now Playing window to see more information 
  about that song.
Touch Random or Repeat to enable those functions.
 
The player is not bug-free, but seems to be pretty stable.
 
Enjoy..




