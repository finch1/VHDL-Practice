#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <io.h>
#include <sys/alt_alarm.h>
#include "gui.h"
#include "player_lib.h"
#include "alt_touchscreen.h"
#include "sd_controller.h"
#include "audio_ctrl.h"
#include "audio_codec_WM8731.h"
#include "altera_avalon_performance_counter.h"
#include "audio.h"



extern sd_card_info_struct* sd_card_global;
extern alt_audio_codec* audio_codec_global;
extern alt_touchscreen* touchscreen_global;
extern alt_video_display* display_global;

int UpdateGUI( player_state_struct* player_state );

playlist_struct* NiosIIMP3_InitPlaylist( void )
{
  playlist_struct* playlist;
  
  playlist = malloc( sizeof( playlist_struct ));
  playlist->num_files = 0;
  playlist->list_start = NULL;  
  playlist->now_playing = NULL;
  playlist->checksum = 0;
  
  return( playlist );
}

char* sd_getstring( char* str, int num, int file )
{
  int bytes, line_length;
  char* eol = NULL;
  char* next_line = NULL;
  char* ret_code = NULL;
  int temp_file_pos = 0;
  
  bytes = read( file, str, num );
  if( bytes > 0 )
  {
    // Find the \n char
    eol = strchr( str, '\n' );
    if( eol )
    {
      *eol = 0x0;
      next_line = eol+1;
    
      // Also strip the \r character
      eol = strchr( str, '\r' );
      if( eol )
        *eol = 0x0;
    
      temp_file_pos = lseek( file, ( next_line - str ) - bytes, SEEK_CUR );
      
      ret_code = str;
    }
    else
    {
      ret_code = NULL;
    }
  }
  else
  {
    ret_code = NULL;
  }
  
  return( ret_code );
}


void FreePlaylistNode( playlist_node_struct* node_to_delete )
{
  free( node_to_delete->filename );
  free( node_to_delete->title );      
  free( node_to_delete->artist );      
  free( node_to_delete->genre );      
  free( node_to_delete->length );
  free( node_to_delete->track );
  free( node_to_delete->album );      
  free( node_to_delete->year );  
  free( node_to_delete );
}


int NiosIIMP3_FreePlaylist( playlist_struct* playlist )
{
  int i;
  
  NiosIIMP3_ClearPlaylist( playlist );
  
  free( playlist->list_start );
  free( playlist );

  return( 0 );
}

int NiosIIMP3_ClearPlaylist( playlist_struct* playlist )
{
  int i;

  playlist_node_struct* file_list_next;
  playlist_node_struct* file_list_current;
  if( playlist->list_start != NULL )
  {
  
    file_list_current = playlist->list_start->next;
  	
    for( i = 0; i < playlist->num_files - 1; i++ )
    {
      file_list_next = file_list_current->next;
  
      free( file_list_current->filename );
      free( file_list_current->title );      
      free( file_list_current->artist );      
      free( file_list_current->genre );      
      free( file_list_current->length );
      free( file_list_current->track );
      free( file_list_current->album );      
      free( file_list_current->year );  
      free( file_list_current );
  
      file_list_current = file_list_next;
    }
  
    playlist->list_start->next = NULL;
    playlist->list_start->prev = NULL;
  	free( playlist->list_start->filename );
    free( playlist->list_start->title );
    free( playlist->list_start->artist );
    free( playlist->list_start->genre );
    free( playlist->list_start->length );
    free( playlist->list_start->track );
    free( playlist->list_start->album );
    free( playlist->list_start->year );
    playlist->num_files = 0;
  }

  return( 0 );
}

int NiosIIMP3_ResetPlaylist( playlist_struct* playlist )
{
  int i;
 	playlist_node_struct* current_node;
  char now_playing[128];
  
  current_node = playlist->list_start;

  for( i = 0; i < playlist->num_files; i++ )
  {
    current_node->file_position = 0;
    current_node = current_node->next;
  }

  playlist->now_playing = playlist->list_start;

  return( 0 );
}

void NiosIIMP3_PrintPlaylist( playlist_struct* playlist )
{ 
  int i;
  playlist_node_struct* current_node = playlist->list_start;
  
  printf( "\nArtist                   Album                    Title                                    Track   Genre   Year\n" );
  printf( "========================+========================+========================================+=======+=======+=======\n" );

  for( i = 0; i < playlist->num_files; i++ )
  {
    printf( "%-24s %-24s %-40s %-7s %-7s %-7s\n", current_node->artist, 
                                                  current_node->album, 
                                                  current_node->title, 
                                                  current_node->track, 
                                                  current_node->genre, 
                                                  current_node->year );
    current_node = current_node->next;
  }
  printf( "===========  END  ==============\n" );
} 

int NiosIIMP3_GetFileSize( char* filepath )
{
	int file_handle;
	int filesize;
  struct stat filestats;
	
	file_handle = open( filepath, O_RDONLY );
  if( !fstat( file_handle, &filestats ))
  {
    filesize = filestats.st_size;
  }
  else
  {
  	filesize = -1;
  }
  
  close( file_handle );
  
  return( filesize );
}

int GetUnalignedInt( char* ptr )
{
  int i;
  unsigned int value = 0;
  
  for( i = 0; i < 4; i++ )
  {
    value = ( value << 8 ) | ( *ptr & 0xFF );
    ptr++;
  }
  
  return( value );
}

int GetEncodedID3v2Size( char* ptr )
{
  int i;
  unsigned int value = 0;
  
  for( i = 0; i < 4; i++ )
  {
    value = ( value << 7 ) | ( *ptr & 0x7F );
    ptr++;
  }
  
  return( value + 10 );
}

char* CopyUnicodeString( unsigned char* dest, unsigned char* src, int bytes )
{
  int i;
  char* orig_dest;
  
  orig_dest = dest;
  
  // Little Endian
  if(( src[0] == 0xFF ) && ( src[1] == 0xFE ))
  {
    src += 2;
    for( i = 0; i < (( bytes - 2 ) / 2 ); i++ )
    {
      if( src[1] )
      {
        dest[i] = '.';
      }
      else
      {
        if( src[0] == 0x0 )
        {
          break;
        }
        else
        {
          dest[i] = src[0];
        }
      }
      
      src += 2;
    }
  }
  // Big Endian
  else if(( src[0] == 0xFE ) && ( src[1] == 0xFF ))
  {
    src += 2;
    for( i = 0; i < (( bytes - 2 ) / 2 ); i++ )
    {
      if( src[0] )
      {
        *(dest++) = '.';
      }
      else
      {
        if( src[1] == 0x0 )
        {
          break;
        }
        else
        {
          *(dest++) = src[1];
        }
      }
      
      src += 2;
    }
  }
  
  return( orig_dest );
}


char* GetID3v2TagStringFromBuffer( char* frame_type, char* buffer, int buffer_length )
{
  char* scan_ptr = buffer;
  int frame_type_length;
  int match;
  int found_frame = 0;
  int frame_length;
  char* return_string;
  int return_string_length;
  
  frame_type_length = strlen( frame_type );
  
  do
  {
    match = strncmp( frame_type, scan_ptr, frame_type_length );
    if( match == 0 )
    {
      found_frame = 1;
      break;
    }
    scan_ptr++;
    // Scan to end of buffer (minus length of frame ID
  } while( scan_ptr < ( buffer + ( buffer_length - frame_type_length )));
  
  if( found_frame == 1 )
  {
    frame_length = GetUnalignedInt( scan_ptr + 4 );
    if( *( scan_ptr + 10 ) ==  0x0 ) // ISO-8859-1
    {
      return_string = malloc( frame_length );
      strncpy( return_string, scan_ptr + 11, frame_length-1 );
      return_string[frame_length - 1] = 0;  // Just to make sure it's terminated
    }
    else if( *( scan_ptr + 10 ) ==  0x1 ) // Unicode
    {
      return_string_length = (( frame_length - 3 ) / 2 ) + 1;
      return_string = malloc( return_string_length );
      CopyUnicodeString( return_string, scan_ptr + 11, frame_length-1 );
      return_string[return_string_length - 1] = 0;  // Just to make sure it's terminated
    }
  }
  else
  {
    return_string = NULL;
  }
  
  return( return_string );  
}

int GetID3v2Length( int fd )
{
  char header[10];
  int id3v2len;
  int bytes_read;
  char* identifier;
  char* version;
  char* flags;
  char* size;
  int i = 0;

  lseek( fd, 0, SEEK_SET );
  bytes_read = read( fd, header, 10 );

  // No idea why this is neccessary, but it seems sometimes when loading from
  // the NEEK app selector, the SD Card gets in a weird state, that after some
  // SD card activity, it fails to read.  Re-initializing it at this point
  // seems to resolve the problem. (but strangely, re-initializing before this
  // point does nothing to fix the problem.)
  while(( bytes_read != 10 ) && ( i < 10000 ))
  {
    sd_controller_init( sd_card_global->base_addr, sd_card_global->mount_point );
		sd_set_clock_to_max( 80000000 );
	  lseek( fd, 0, SEEK_SET );
	  bytes_read = read( fd, header, 10 );
    i++;
  } 
  
  if( bytes_read == 10 )
  {
    identifier = header + 0;
    version =    header + 3;
    flags =      header + 5;
    size =       header + 6;
    
    // Make sure file has a ID3 tag
    if( strncmp( identifier, "ID3", strlen( "ID3" )) != 0 )
    {
      *size = 0;
    }
    else
    {
      id3v2len = GetEncodedID3v2Size( size );
    }
    return( id3v2len );
  }
  else
  {
    return( -1 );
  }    
}

void NiosIIMP3_TranslateTrackTag( playlist_node_struct* playlist_entry )
{
  char original_track[16];
  int track_int;
  char* slashptr;
  
  strcpy( original_track, playlist_entry->track );
  
  slashptr = strchr( original_track, '/' );
  
  if( slashptr )
  {
    *slashptr = 0x0;
  }
  
  track_int = atoi( original_track );
  
  free( playlist_entry->track );
  playlist_entry->track = malloc( 4 );
  sprintf( playlist_entry->track, "%2.2d", track_int );
}

int NiosIIMP3_ReadID3V2Tag( playlist_node_struct* playlist_entry, char* filepath )
{
	volatile int file_handle;
  char* buffer;
  volatile int id3v2len = 0;
  volatile int ret_code = 0;
	
	file_handle = open( filepath, O_RDONLY );
  if( file_handle < 0 )
  {
    printf( "\nCould not open %s\n", filepath );
    ret_code = -1;
  }    
	else
  {
  	// Check if there is an id3v2 tag.
  	id3v2len = GetID3v2Length( file_handle );
  
    if ( id3v2len > 0 )
    {
      playlist_entry->length_of_id3v2_tag = id3v2len;  		
      // Get the ID3 info into a buffer
  		buffer = malloc( id3v2len );
  		lseek( file_handle, 0, SEEK_SET );
  		read( file_handle, buffer, id3v2len );

      // Get the tags from the id3v2 tag buffer.
      playlist_entry->artist = GetID3v2TagStringFromBuffer( "TPE1", buffer, id3v2len );
      playlist_entry->title = GetID3v2TagStringFromBuffer( "TIT2", buffer, id3v2len );  
      playlist_entry->album = GetID3v2TagStringFromBuffer( "TALB", buffer, id3v2len );  
      playlist_entry->genre = GetID3v2TagStringFromBuffer( "TCON", buffer, id3v2len );
      playlist_entry->length = GetID3v2TagStringFromBuffer( "TLEN", buffer, id3v2len );
      playlist_entry->year = GetID3v2TagStringFromBuffer( "TYER", buffer, id3v2len );  	
      playlist_entry->track = GetID3v2TagStringFromBuffer( "TRCK", buffer, id3v2len );
      NiosIIMP3_TranslateTrackTag( playlist_entry );

      GetSongSpecs( playlist_entry, file_handle );
    }
    else if( id3v2len < 0 )
    {
      printf( "\nError reading from %s\n", filepath );
      ret_code = -1;
    }      
  	
  	free( buffer );
  	close( file_handle );
  }
	
	return( ret_code );
}


int CountPlaylistElements( playlist_struct* playlist )
{
  int i = 0;
  playlist_node_struct* temp_playlist_entry = playlist->list_start;

	if( playlist != NULL )
	{
		i++;
  	while( temp_playlist_entry->next != playlist->list_start )
  	{
      temp_playlist_entry = temp_playlist_entry->next;
  		i++;
  	}
  }
	return( i );
}

int AddEntryToTopOfPlaylist( playlist_node_struct* playlist_entry, playlist_struct* playlist )
{
  // If the list is empty, make the new element point back to itself
 	if( playlist->num_files == 0 )
  {
  	playlist_entry->next = playlist_entry;
  	playlist_entry->prev = playlist_entry;
  }
  else
  {
		// Make new entry's next pointer point to existing first element
		playlist_entry->next = playlist->list_start;
		// Make new entry's prev pointer point to existing last element
		playlist_entry->prev = playlist->list_start->prev;
    // Make existing last element's next pointer point to new entry
    playlist->list_start->prev->next = playlist_entry;
		// Make existing first element's prev pointer point to new entry
		playlist->list_start->prev = playlist_entry;
	}

	// Now make the new entry the first element
	playlist->list_start = playlist_entry;
		
	playlist->num_files++;
	
}

int RemoveEntryFromPlaylist( playlist_node_struct* playlist_entry, playlist_struct* playlist )
{
	int i;
	int entry_exists_in_list = 0;
	int ret_code = 0;
	playlist_node_struct* temp_playlist_entry = playlist->list_start;
	
	// First make sure the entry exists in the playlist
	for( i = 0; i < playlist->num_files; i++ )
	{
		if( temp_playlist_entry == playlist_entry )
		{
			entry_exists_in_list = 1;
			break;
		}
		temp_playlist_entry = temp_playlist_entry->next;
	}
	
	if( entry_exists_in_list )
	{
		// Pretty sure this is safe even if there is only one element left in the list
		
		// Make the previous entry's next pointer point to the next entry
		playlist_entry->prev->next = playlist_entry->next;
	
		// Make the next entry's prev pointer point to the previous entry
		playlist_entry->next->prev = playlist_entry->prev;
		
		// If we're removing the first element of the list, change the start pointer to 
		// the next element
		if( playlist->list_start == playlist_entry )
		{
			playlist->list_start = playlist_entry->next;
		}
		
		// Decrement the number of elements in the list
		playlist->num_files--;
		ret_code = 0;
	}
	else
	{
		ret_code = -1;
	}
	
	return( ret_code );
	
}

// Use a file on the SD Card to reseed the randomizer.  This prevents the randomizer from
// picking the same sequence every time.
int SeedRandomizer( void )
{
	int file_handle;
	int bytes;
	int seed;
	char* filepath;
	char* rootpath;
	char* data_buffer;
	

	filepath = malloc( 256 );
	data_buffer = malloc( 16 );
  rootpath = sd_card_global->mount_point;
  
  // Create the config folder if it doesn't exist
  sd_mkdir( CONFIG_FOLDER, O_RDWR );

 	sprintf( filepath, "%s%s/%s", rootpath, CONFIG_FOLDER, "randomize_seed.txt" );

	file_handle = open( filepath, ( O_RDWR | O_CREAT ));
	bytes = read( file_handle, data_buffer, 16 );
	
	if( bytes > 0 )
	{
		data_buffer[bytes] = 0;
		sscanf( data_buffer, "%d", &seed );
	}
	else
	{
		// As good an initial value as any.
		seed = 1;
	}
	
	srand( seed );
	seed = rand() + 1;
	sprintf( data_buffer, "%15.15d\0", seed );
	
	// now write a new seed to the file.
	lseek( file_handle, 0, SEEK_SET );
	bytes = write( file_handle, data_buffer, 16 );

  close( file_handle );
  
	free( data_buffer );
	free( filepath );
	
	if( bytes > 0 )
	{
		return( 0 );
	}
	else
	{
		return( -1 );
	}		
}

void SwapPlaylistNodes( playlist_struct* playlist, playlist_node_struct* A, playlist_node_struct* B )
{
  playlist_node_struct* temp;
  
  if( A == playlist->list_start )
  {
    playlist->list_start = B;
  }
  else if( B == playlist->list_start )
  {
    playlist->list_start = A;
  }
  
  if( A->next == B )
  {
    A->prev->next = B;
    B->next->prev = A;
    A->next = B->next;
    B->next = A;
    B->prev = A->prev;
    A->prev = B;

  }
  else if( B->next == A )
  {
    A->next->prev = B;
    B->prev->next = A;
    B->next = A->next;
    A->next = B;
    A->prev = B->prev;
    B->prev = A;
  }
  else
  {
    A->next->prev = B;
    A->prev->next = B;
    B->prev->next = A;
    B->next->prev = A;

    temp = A->next;
    A->next = B->next;
    B->next = temp;

    temp = A->prev;
    A->prev = B->prev;
    B->prev = temp;
  }
  
}

int NodesAreOutOfOrder( playlist_node_struct* A, playlist_node_struct* B, int field, int order )
{
  int ret_code = 0;
  int diff;
  char* slashptr;
  char trackA[8];
  char trackB[8];
  
  if( field == FIELD_ARTIST )
  {
    diff = strcmp( A->artist, B->artist );
  }
  else if( field == FIELD_ALBUM )
  {
    diff = strcmp( A->album, B->album );
  }
  else if( field == FIELD_FILENAME )
  {
    diff = strcmp( A->filename, B->filename );
  }
  else if( field == FIELD_TRACK )
  {
    strncpy( trackA, A->track, 7 );
    strncpy( trackB, B->track, 7 );
    
    // Track fields are strings, and can be in the form x/x so we need to strip
    // everything after the slash.
    slashptr = strchr( trackA, '/' );
    if( slashptr )
    {
      slashptr = 0x0;
    }
    slashptr = strchr( trackB, '/' );
    if( slashptr )
    {
      slashptr = 0x0;
    }
    diff = (( atoi( trackA )) - ( atoi( trackB )));
  }
  
  if(( diff < 0 ) && ( order == SORT_DESC ))
  {
    ret_code = 1;
  }
  else if(( diff > 0 ) && ( order == SORT_ASC ))
  {
    ret_code = 1;
  }
  else
  {
    ret_code = 0;
  }
  
  return( ret_code ); 
}

int SortPlaylist( playlist_struct* playlist, int field, int order )
{
  // Bubble sorts suck, but they're quick to build, and we shouldn't have
  // to do this very often.
  
  int ret_code = 0;
  int i, j;
  int entry_to_move = 0;
  playlist_node_struct* current_node = playlist->list_start;
  
  for( i = 0; i < playlist->num_files; i++ )
  {
    current_node = playlist->list_start;
    for( j = 0; j < playlist->num_files - 1; j++ )
    {
      if( NodesAreOutOfOrder( current_node, current_node->next, field, order ))
      {
        SwapPlaylistNodes( playlist, current_node, current_node->next );
      }
      else
      {
        current_node = current_node->next;
      }
    }
  }

  return( ret_code );
}


int RandomizePlaylist( playlist_struct* playlist )
{
	int num_elements_in_list;
	int ret_code = 0;
	int i, j;
	int entry_to_move = 0;
  playlist_node_struct* temp_playlist_entry = NULL;
  
  SeedRandomizer();
	
	num_elements_in_list = CountPlaylistElements( playlist );
	if( num_elements_in_list == playlist->num_files )
	{
		// Pick random elements from the list, remove them, then place them at
		// the top of the list.
		for( i = 0; i < num_elements_in_list; i++ )
		{
			entry_to_move = rand() % num_elements_in_list;
			temp_playlist_entry = playlist->list_start;
			for( j = 0; j < entry_to_move; j++ )
			{
				temp_playlist_entry = temp_playlist_entry->next;
			}
			RemoveEntryFromPlaylist( temp_playlist_entry, playlist );
      AddEntryToTopOfPlaylist( temp_playlist_entry, playlist );
    }
	}
	else
	{
		ret_code = -1;
	}

	return( ret_code );
}


playlist_node_struct* AddEntryToBottomOfPlaylist( playlist_struct* playlist )
{
  int ret_code;
  playlist_node_struct* new_playlist_entry = NULL;
  playlist_node_struct* last_playlist_entry = NULL;

  // First create the new node
  new_playlist_entry = malloc( sizeof( playlist_node_struct ));

  // If the list is empty, make the new element the start of the list, and
  // make both the next and prev pointers point back at ourselves
  if( playlist->num_files == 0 )
  {
    new_playlist_entry->next = new_playlist_entry;
    new_playlist_entry->prev = new_playlist_entry;
    playlist->list_start = new_playlist_entry;
  }
  // Else if the list contains at least one element, add ourselves to the
  // end of the list.
  else
  {
    // Store the last element in the list.  The list is circular, so this will
    // be the prev pointer of the first element. 
    last_playlist_entry = playlist->list_start->prev;
    
    // Make the next pointer of the last list element point to the new entry
    last_playlist_entry->next = new_playlist_entry;
    // Make the prev pointer of the first list element point to the new entry
    playlist->list_start->prev = new_playlist_entry;
    // Make the next pointer of the new entry point to the first list element
    new_playlist_entry->next = playlist->list_start;
    // Make the prev pointer of the new entry point to the existing last list element
    new_playlist_entry->prev = last_playlist_entry;
  }

  playlist->num_files++;
  
  return( new_playlist_entry );
}


int AddFileToBottomOfPlaylist( char* filepath, playlist_struct* playlist )
{
  int ret_code;
  playlist_node_struct* new_playlist_entry = NULL;
  playlist_node_struct* last_playlist_entry = NULL;

	// First create the new node
  new_playlist_entry = malloc( sizeof( playlist_node_struct ));
  new_playlist_entry->filename = malloc( strlen( filepath ) + 1 );
  strcpy( new_playlist_entry->filename, filepath );
  new_playlist_entry->file_length = NiosIIMP3_GetFileSize( filepath );

  ret_code = NiosIIMP3_ReadID3V2Tag( new_playlist_entry, filepath );
  
  if( !ret_code )
  {
    // If the list is empty, make the new element the start of the list, and
    // make both the next and prev pointers point back at ourselves
   	if( playlist->num_files == 0 )
    {
    	new_playlist_entry->next = new_playlist_entry;
    	new_playlist_entry->prev = new_playlist_entry;
      playlist->list_start = new_playlist_entry;
    }
    // Else if the list contains at least one element, add ourselves to the
    // end of the list.
    else
    {
    	// Store the last element in the list.  The list is circular, so this will
    	// be the prev pointer of the first element. 
    	last_playlist_entry = playlist->list_start->prev;
    	
    	// Make the next pointer of the last list element point to the new entry
    	last_playlist_entry->next = new_playlist_entry;
    	// Make the prev pointer of the first list element point to the new entry
    	playlist->list_start->prev = new_playlist_entry;
    	// Make the next pointer of the new entry point to the first list element
    	new_playlist_entry->next = playlist->list_start;
    	// Make the prev pointer of the new entry point to the existing last list element
    	new_playlist_entry->prev = last_playlist_entry;
    }
    playlist->num_files++;
  }
  
	return( 0 );
}

int FileExistsInPlaylist( char* filepath, playlist_struct* playlist )
{
  int i;
  int ret_code = 0;
  playlist_node_struct* current_node = playlist->list_start;
  
  for( i = 0; i < playlist->num_files; i++ )
  {
    if( !strcmp( current_node->filename, filepath ))
    {
      ret_code = 1;
      break;
    }
    current_node = current_node->next;
  }
  return( ret_code );
}

int NiosIIMP3_AddAllRecursive( char* dir, playlist_struct* playlist, int recursive )
{
  char* filename;
  char* filepath;
  char* filelist_buffer;
  char* rootpath;

  int filelist_index = 0;
  int num_files, i, j;
	int mp3_files_found = 0;
  int num_files_added_to_database = 0;

//  int num_playlist_files = 0;

  filename = malloc( 256 );
  filepath = malloc( 256 );
  filelist_buffer = malloc( 32768 );

  rootpath = sd_card_global->mount_point;

  num_files = sd_list( dir, filelist_buffer );

  for( i = 0; i < num_files; i++ )
  {
  	j = 0;
  	// Gather filename.  It consists of every character (incl spaces) before
  	// we reach a null (0x0).
    while( filelist_buffer[filelist_index] != 0x0 )
    {
      filename[j++] = filelist_buffer[filelist_index];
      filelist_index++;
    }
    filename[j] = 0x0;
    
    sprintf( filepath, "%s/%s", dir, filename );
    if( sd_isdir( filepath ) && ( filename[0] != '.' ) && ( recursive == 1 ))
    {
      num_files_added_to_database += NiosIIMP3_AddAllRecursive( filepath, playlist, 1 );
    }
    else if(( strstr( filename, ".mp3" )) != NULL )
    {
    	mp3_files_found++;
    	sprintf( filepath, "%s%s/%s", rootpath, dir, filename );
      if( !FileExistsInPlaylist( filepath, playlist ))
      {
        num_files_added_to_database++;
			  AddFileToBottomOfPlaylist( filepath, playlist );
        printf(".");
      }
    }
		
    filelist_index++;
  } 
//	printf("\n%d total ", mp3_files_found );
    
 	free( filename );
 	free( filepath );
 	free( filelist_buffer );

  return( num_files_added_to_database );
}

int NiosIIMP3_AddAllFilesInDirToDatabase( char* dir, playlist_struct* playlist, int recursive )
{
  int num_added;
  printf( "Adding New Files to Database" );
  playlist->checksum = 0;
  num_added = NiosIIMP3_AddAllRecursive( dir, playlist, recursive );
  playlist->checksum = ComputeDirChecksum( MP3_FOLDER, 0 );
  printf( "\n" );
  
  return( num_added );
}

int NiosIIMP3_RemoveStaleEntriesFromDatabase( playlist_struct* playlist )
{
  int file_handle;
  int i;
  int num_removed = 0;
  playlist_node_struct* current_node = playlist->list_start;
  playlist_node_struct* node_to_delete;
  
  printf( "Removing Stale Entries from Database" );
    
  for( i = 0; i < playlist->num_files; i++ )
  {
    file_handle = open( current_node->filename, O_RDONLY );
    if( file_handle < 0 )
    {
      num_removed++;
      node_to_delete = current_node;
      current_node = current_node->next;
      RemoveEntryFromPlaylist( node_to_delete, playlist );
      FreePlaylistNode( node_to_delete );
      printf( "." );      
    }
    else
    {
      current_node = current_node->next;
      close( file_handle );
    }
  }
  printf( "\n" );
  return( num_removed );
}

/***********************************************************************
 * Function: NiosIIMP3_ReadTagStringFromString                               *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns: tag value if present, else NULL                            *
 **********************************************************************/

char* NiosIIMP3_ReadTagStringFromString( char* tag, char* src_string )
{
  char* dest_string = NULL;
  char start_tag[32];
  char end_tag[32];
  int start_tag_length, string_length;
  char* begin_string = NULL;
  char* end_string = NULL;

  
  sprintf( start_tag, "<%s>", tag );
  sprintf( end_tag, "</%s>", tag );
  start_tag_length = strlen( tag ) + 2;
//  end_tag_length = start_tag_length + 1;
  
  begin_string = strstr( src_string, start_tag );
  
  if( begin_string )
  {
    begin_string += start_tag_length;
    end_string = strstr( src_string, end_tag );
    string_length = end_string - begin_string;
    dest_string = malloc( string_length + 1 );
    if( dest_string )
    {
      strncpy( dest_string, begin_string, string_length );
      dest_string[string_length] = 0x0;
    }
  }
 
  return( dest_string );
}

/***********************************************************************
 * Function: NiosIIMP3_ReadTagIntFromString                               *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns: tag value if present, else NULL                            *
 **********************************************************************/

unsigned int NiosIIMP3_ReadTagIntFromString( char* tag, char* src_string )
{
  int ret_value = 0;
  char start_tag[32];
  char end_tag[32];
  int start_tag_length, string_length;
  char* begin_string = NULL;
  char* end_string = NULL;

  
  sprintf( start_tag, "<%s>", tag );
  sprintf( end_tag, "</%s>", tag );
  start_tag_length = strlen( tag ) + 2;
//  end_tag_length = start_tag_length + 1;
  
  begin_string = strstr( src_string, start_tag );
  
  if( begin_string )
  {
    begin_string += start_tag_length;
    ret_value = atoi( begin_string );
  }
 
  return( ret_value );
}


int ComputeDirChecksum( char* dir, int recursive )
{
  char* buffer;
  char* filename;
  char* filepath;
  int filelist_index = 0;
  int i, j;
  int num_entries;
  int checksum = 0;

  buffer = malloc( 32768 );  
  filename = malloc( 256 );
  filepath = malloc( 256 );
  
  if( buffer && filename )
  {
    num_entries = sd_list( dir, buffer );
    if( num_entries )
    {
      for( i = 0; i < num_entries; i++ )
      {
        j = 0;
        // Gather filename.  It consists of every character (incl spaces) before
        // we reach a null (0x0).
        while( buffer[filelist_index] != 0x0 )
        {
          filename[j++] = buffer[filelist_index];
          checksum += buffer[filelist_index];
          filelist_index++;
        }
        filename[j] = 0x0;
        
        sprintf( filepath, "%s/%s", dir, filename );
        if( sd_isdir( filepath ) && ( filename[0] != '.' ) && ( recursive == 1 ))
        {
          checksum += ComputeDirChecksum( filepath, recursive );
        }
        filelist_index++;
      }
    }
    free( filepath );     
    free( filename );     
    free( buffer );     
  }
  
  return( checksum );
}

int ReadExpectedDirChecksum( void )
{
  char* absolute_path;
  char* buffer;  
  int file_handle = -1;
  int expected_checksum = 0;
    
  absolute_path = malloc( 512 );  
  buffer = malloc( 1024 );  
  
  if( buffer && absolute_path )
  {    
    sprintf( absolute_path, "%s%s/%s", sd_card_global->mount_point, CONFIG_FOLDER, DATABASE_FILE );
  
    file_handle = open( absolute_path, O_RDONLY );
    
    if( file_handle > 0 )
    {
      while( sd_getstring( buffer, 1024, file_handle ))
      {
        expected_checksum = NiosIIMP3_ReadTagIntFromString( "dir_checksum", buffer );
        if( expected_checksum )
          break;
      }
      close( file_handle );
    }
    free( buffer );
    free( absolute_path );
  }

  return( expected_checksum );
}

int VerifyDirChecksum( void ) 
{
  int expected_checksum = -1;
  int computed_checksum = 0;
  int ret_code = -1;
  
  expected_checksum = ReadExpectedDirChecksum( );
  computed_checksum = ComputeDirChecksum( MP3_FOLDER, 0 );
  
//  printf( "DEBUG: expected checksum: %d, computed_checksum: %d\n", expected_checksum, computed_checksum );

  if( computed_checksum == expected_checksum )
  {
    ret_code = 0;
  }
  
  return( ret_code );
}


void NiosIIMP3_IndexSDCard( playlist_struct* playlist )
{
  int num_removed, num_added;
  int reindex_needed = 0;
  
  DisplayStatusMessage( "Verifying Database...", display_global );

  if( !VerifyDirChecksum() )
  {
    printf("Searching for Database               ");
    if( !NiosIIMP3_ReadDatabaseFromSDCard( CONFIG_FOLDER, DATABASE_FILE, playlist ) != 0 )
    {
      printf(" - None Found\n");
      reindex_needed = 1;   
    }
    else
    {
      printf(" - OK\n");
    }
  }
  else
  {
    reindex_needed = 1;
  }
  
  if( reindex_needed )
  {
    DisplayStatusMessage( "Re-Indexing Database... Please Wait", display_global );
   
    // Clear the playlist
    NiosIIMP3_ClearPlaylist( playlist );
    
    // First add all files that dont already exist in database
    num_added = NiosIIMP3_AddAllFilesInDirToDatabase( MP3_FOLDER, playlist, 1 );
  
    printf( "Added %d entries to database\n", num_added );
    
    printf("Sorting Database                     ");  
    SortPlaylist( playlist, FIELD_TRACK, SORT_ASC );
    SortPlaylist( playlist, FIELD_ALBUM, SORT_ASC );
    SortPlaylist( playlist, FIELD_ARTIST, SORT_ASC );
    printf(" - OK\n");  
  
    printf("Saving Database                      ");
    NiosIIMP3_SaveDatabaseToSDCard( CONFIG_FOLDER, DATABASE_FILE, playlist );
    printf(" - OK\n");
  
    NiosIIMP3_ResetPlaylist( playlist );
  }
  
  ClearNowPlayingWindow( display_global );
}

		
int NiosIIMP3_PrintPlaylistToTerminal( playlist_struct* playlist )
{
  int i;
  playlist_node_struct* current_playlist_entry;
  
  current_playlist_entry = playlist->list_start;

	printf( "Playlist Contents:\n" );
  for( i = 0; i < playlist->num_files; i++ )
	{
		printf( " - %s - %s\n", current_playlist_entry->artist, current_playlist_entry->title );
		current_playlist_entry = current_playlist_entry->next;
	}
		
	return( 0 );
}

player_state_struct* NiosIIMP3_PlayerStateInit()
{
	player_state_struct* player_state;
	
	player_state = malloc( sizeof( player_state_struct ));
	
	player_state->file_buffer_size = FILE_BUFFER_SIZE;
	player_state->file_buffer = malloc( FILE_BUFFER_SIZE );
	player_state->file_handle = -1;
	player_state->total_samples_played = 0;
  player_state->samples_played_this_song = 0;
  player_state->sequence_mode = MP3_FORWARD;
  player_state->repeat_playlist = MP3_NO_REPEAT;
	player_state->volume = 0;
	player_state->balance = 50;
//	player->playlist = NULL;
  
  audio_codec_set_headphone_volume( audio_codec_global, player_state->volume );
  audio_codec_set_headphone_balance( audio_codec_global, player_state->balance );

	return( player_state );
}
	

/***********************************************************************
 * Function: NiosIIMP3_DecodeInit                                      *
 *                                                                     *
 * Purpose: Initializes the MP3 decoder structure and registers        *
 * the callback functions.                                             *
 *                                                                     *
 * Input:   None                                                       *
 * Output:  None, API uses callback functions for output               * 
 * Returns: Error Code, 0 = Success                                    *
 **********************************************************************/
   
mad_decoder_type* NiosIIMP3_DecoderInit( player_state_struct* player_state )
{
  int ret_code;
  mad_decoder_type* decoder;
  
  decoder = ( mad_decoder_type* )malloc( sizeof ( mad_decoder_type ) );
  
  /* 
   * Setup our callback functions with a MAD API call. 
   *  -Input function =  NiosIIMP3_Input
   *  -Output function = NiosIIMP3_Output
   *  -Error function =  NiosIIMP3_Error
   * Header, filter, and message functions aren't used
   * 
   * We also pass in a pointer to the mp3 file structure.  This in turn
   * will get passed to our callback functions, giving them access 
   * to the mp3 files.
   */
  mad_decoder_init( decoder,           // mad decoder instance
                    player_state,      // context data
                    NiosIIMP3_Input,   // input function ( mp3 data )
                    0,                 // header 
                    0,                 // filter function
                    NiosIIMP3_Output,  // output function ( audio )
                    NiosIIMP3_Error,   // error function
                    0 );               // message function
       
  return( decoder );
}       

int NiosIIMP3_DecoderStart( mad_decoder_type* decoder )
{
  int ret_code;
  
  /* Start the decoder with an API call */
  ret_code = mad_decoder_run( decoder, MAD_DECODER_MODE_SYNC );
  
  return( ret_code );	
}

/*****************************************************************************
 *  Function: ScrollPlaylistToNowPlaying
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void ScrollPlaylistToNowPlaying( gui_struct* gui, playlist_struct* playlist )
{
  gui_playlist_struct* playlist_gui = &gui->gui_main_playlist;
    
  int i;
  playlist_node_struct** playlist_array;
  playlist_node_struct* current_playlist_node = playlist->list_start;
  int now_playing_index, first_displayed_index, new_first_displayed_index;
  
  playlist_array = malloc( sizeof( playlist_node_struct* ) * playlist->num_files );
  
  // Index the playlist
  for( i = 0; i < playlist->num_files; i++ )
  {
    playlist_array[i] = current_playlist_node;
    if( current_playlist_node == playlist_gui->top_displayed_playlist_node )
    {
      first_displayed_index = i;
    }
    if( current_playlist_node == playlist->now_playing )
    {
      now_playing_index = i;
    }
    current_playlist_node = current_playlist_node->next;  
  }

  if( now_playing_index == 0  || playlist->num_files <= playlist_gui->num_displayed_at_once )
  {
    new_first_displayed_index = 0;
  }
  else if( now_playing_index == ( playlist->num_files - 1 ))
  {
    new_first_displayed_index = playlist->num_files - playlist_gui->num_displayed_at_once;
  }
  else if( now_playing_index < ( first_displayed_index + 1 ))
  {
    new_first_displayed_index = now_playing_index - 1;
  }  
  else if( now_playing_index > ( first_displayed_index + ( playlist_gui->num_displayed_at_once - 2 ) ))
  {
    new_first_displayed_index = now_playing_index - ( playlist_gui->num_displayed_at_once - 2 );
  }
  else
  {
    new_first_displayed_index = first_displayed_index;
  }
  
  playlist_gui->top_displayed_playlist_node = playlist_array[new_first_displayed_index];  
  free( playlist_array );
  
  SetTotalScrollItems( &playlist_gui->scroll, playlist->num_files );
  SetCurrentScrollIndex( &playlist_gui->scroll, new_first_displayed_index );
  SetReferenceScrollIndex( &playlist_gui->scroll, now_playing_index );

}


/***********************************************************************
 * Function: NiosIIMP3_PlayPlaylist                                    *
 **********************************************************************/
int NiosIIMP3_PlayPlaylist( player_struct* player )
{
  int num_to_advance;
  int i;
  int pause = 0;
  
  player->player_state = NiosIIMP3_PlayerStateInit();
  
	player_state_struct* player_state;
  gui_struct* gui = player->gui;
  playlist_struct* playlist = player->playlist;
//  playlist_struct* database = player->database;
  
	mad_decoder_type* decoder;

  player->player_state = NiosIIMP3_PlayerStateInit();
  player_state = player->player_state;
  
//	player->playlist = playlist;
//  player->player_state = player_state;
  player->gui = gui;

	decoder = NiosIIMP3_DecoderInit( player );
	
  player_state->command = COMMAND_PLAY;
  player_state->volume = 50;
  player_state->balance = 50;
  audio_codec_set_headphone_volume( audio_codec_global, player_state->volume );
  audio_codec_set_headphone_balance( audio_codec_global, player_state->balance );

  // Restore the previous state of the player from the SD Card
  NiosIIMP3_ResetPlaylist( playlist );
  NiosIIMP3_ReadSaveStateFromSDCard( player );

  // Initialize the playlist gui
  InitializePlaylistGUI( player );
  InitializeNowPlayingGUI( player );
	
  while( 1 )
  {
    ScrollPlaylistToNowPlaying( gui, playlist );  
    
    NiosIIMP3_DecoderStart( decoder );
    pause = 0;

    //debug
//    break;
    
    if(( player_state->command == COMMAND_PLAY || player_state->command == COMMAND_SKIP_FWD ))
    {
	    close( player_state->file_handle );
  	  player_state->file_handle = -1;
      if( player_state->sequence_mode == MP3_RANDOM )
      {
        SeedRandomizer();
        num_to_advance = rand() % player->playlist->num_files;
        for( i = 0; i < num_to_advance; i++ )
        {
          player->playlist->now_playing = player->playlist->now_playing->next;
        }
      }
      else if( player_state->sequence_mode == MP3_REVERSE )
      {
        player->playlist->now_playing = player->playlist->now_playing->prev;
      }
      else
      {
        player->playlist->now_playing = player->playlist->now_playing->next;
       if(( player_state->repeat_playlist == MP3_NO_REPEAT ) &&
           ( player->playlist->now_playing == player->playlist->list_start ))
        {
          pause = 1;
        }
      }
      player_state->samples_played_this_song = 0;
    }
    else if( player_state->command == COMMAND_SKIP_BACK )
    {
	    close( player_state->file_handle );
  	  player_state->file_handle = -1;
      if( player_state->samples_played_this_song < SKIP_BACK_THRESHOLD )
      {
        player->playlist->now_playing = player->playlist->now_playing->prev;
      }
      player_state->samples_played_this_song = 0;
    }
    else if( player_state->command == COMMAND_SKIP_SPECIFIC )
    {
      close( player_state->file_handle );
      player_state->file_handle = -1;
      player->playlist->now_playing = player_state->command_target;
      player_state->samples_played_this_song = 0;
    }    
    else
    {
      break;
    }

    NiosIIMP3_WriteSaveStateToSDCard( player );
    
    if( pause == 0 )
    {
      printf( "DEBUG: Setting command - PLAY\n" );
      player_state->command = COMMAND_PLAY;
    }
    else
    {
      printf( "DEBUG: Setting command - PAUSE\n" );
      player_state->command = COMMAND_PAUSE;
    }
  }
  
  printf( "DEBUG: Closing file\n" );
  close( 4 );
  
  // Give back what we've taken 
  free( decoder );
  free( player_state );
  
	return( 0 );	
}

/***********************************************************************
 * Function: WaitOnSDCardFailure                                       *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns: 0 = there was no sd card failure, 1= there was             *
 **********************************************************************/
int WaitOnSDCardFailure( void )
{
  int ret_code;
  
  if( sd_controller_init( sd_card_global->base_addr, sd_card_global->mount_point ))
  {
//    DisplayStatusMessage( "Error Reading SD Card.", display_global );
    printf( "ERROR: Cannot Read SD Card\n" );
    while( sd_controller_init( sd_card_global->base_addr, sd_card_global->mount_point ))
    {
      usleep( 1000000 );
    }
    ret_code = 1;
  }
  else
  {
    ret_code = 0;
  }

  return( 0 );
}

// 
/***********************************************************************
 * Function: FindStringInBuf                                           *
 *                                                                     *
 * Purpose:  This is essentally a binary-safe version of strstr.       *
 *           NULL characters and other ASCII control stuff is ignored. *                                                         *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns:                                                            *
 **********************************************************************/
char* FindStringInBuf( alt_u8* buf_start, alt_u8* string, int length )
{
  alt_u8* temp_buf_ptr = buf_start;
  alt_u8* temp_string_ptr = string;
  alt_u8* ret_ptr = NULL;
  int string_length = strlen( string );
  int i, j;
  
  length -= string_length;
  
  for( i = 0; i < length; i++ )
  {
    for( j = 0; j < string_length; j++ )
    {
      if( temp_buf_ptr[j] != temp_string_ptr[j] )
      {
        break;
      }
    }

    if( j == string_length )
    {
      ret_ptr = temp_buf_ptr;
      break;
    }

    temp_buf_ptr++;
  }
  
  return( ret_ptr );
}

unsigned int BigEnd32( unsigned char* ptr )
{
  return((unsigned int)(( ptr[3] ) | 
                       (  ptr[2] << 8 ) | 
                       (  ptr[1] << 16 ) | 
                       (  ptr[0] << 24 )));
}


/***********************************************************************
 * Function: GetSongSpecs                                              *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns:                                                            *
 **********************************************************************/
int GetSongSpecs( playlist_node_struct* playlist_entry, int file_handle )
{
  #define FRAMES_FLAG     0x0001
  #define BYTES_FLAG      0x0002
  #define TOC_FLAG        0x0004
  #define VBR_SCALE_FLAG  0x0008

  int i;
  unsigned char* buffer;
  int bytes_read;
  int ret_code;
  unsigned char* temp_ptr = NULL; 
  unsigned int id, sr_index, layer_index, br_index, mode, flags;
  int datasize, seconds, samples_per_frame, num_frames;
  
  static int sr_table[4] = { 44100, 48000, 32000, 99999 };
  
  static int br_table[5][15] = {
    /* MPEG-1 */
    { 0,  32000,  64000,  96000, 128000, 160000, 192000, 224000,  /* Layer I   */
         256000, 288000, 320000, 352000, 384000, 416000, 448000 },
    { 0,  32000,  48000,  56000,  64000,  80000,  96000, 112000,  /* Layer II  */
         128000, 160000, 192000, 224000, 256000, 320000, 384000 },
    { 0,  32000,  40000,  48000,  56000,  64000,  80000,  96000,  /* Layer III */
         112000, 128000, 160000, 192000, 224000, 256000, 320000 },
  
    /* MPEG-2 LSF */
    { 0,  32000,  48000,  56000,  64000,  80000,  96000, 112000,  /* Layer I   */
         128000, 144000, 160000, 176000, 192000, 224000, 256000 },
    { 0,   8000,  16000,  24000,  32000,  40000,  48000,  56000,  /* Layers    */
          64000,  80000,  96000, 112000, 128000, 144000, 160000 } /* II & III  */
    };

  datasize = playlist_entry->file_length - playlist_entry->length_of_id3v2_tag;
                 
  buffer = malloc( 512 );
  
  lseek( file_handle, 
         playlist_entry->length_of_id3v2_tag, 
         SEEK_SET );
  bytes_read = read( file_handle, buffer, 512 );
  
  // Make sure we're at the start of a frame
  if( !( buffer[0] == 0xff && (buffer[1] & 0xe0) == 0xe0))
  {
    printf( "ERROR: GetSongSpecs: Not at beginning of a frame.\n" );
    playlist_entry->total_samples = 0;
    playlist_entry->vbr = 0;
    ret_code = -1;
  }
  else
  {
    temp_ptr = buffer;
    
    id          = ( temp_ptr[1] >> 3) & 0x3;
    layer_index = ( temp_ptr[1] >> 1) & 0x3;
    sr_index    = ( temp_ptr[2] >> 2) & 0x3;
    br_index    = ( temp_ptr[2] >> 4) & 0xf;
    mode        = ( temp_ptr[3] >> 6) & 0x3;

    playlist_entry->sample_rate = sr_table[sr_index];

    // header offset
    if( id & 0x1 ) // mpeg1
      if( mode != 3 )
        temp_ptr += ( 32 + 4 );
      else
        temp_ptr += ( 17 + 4 );
    else  // mpeg2 
      if( mode != 3 )
        temp_ptr += ( 17 + 4 );
      else
        temp_ptr += ( 9 + 4 );
    
    // samples per frame calculation (constant across a file)
    if( layer_index == 2 )       // layer II
      samples_per_frame = 1152;
    else if( layer_index == 3 )  // layer I    
      samples_per_frame = 384;
    else if( id == 3 )           // layer III, mpeg1
      samples_per_frame = 1152;      
    else                         // layer III, mpeg2 or mpeg2.5
      samples_per_frame = 576;      
              
    if(( strncmp( temp_ptr, "Xing", 4 ) && strncmp( temp_ptr, "Info", 4 )))
    {
//      printf( "DEBUG: Did not find Xing header\n" );
      playlist_entry->vbr = 0;
      // bitrate
      if( id == 3 )                                        // mpeg1
        if( layer_index == 3 )                             // layer I
          playlist_entry->bit_rate = br_table[0][br_index];
        else if( layer_index == 2 )                        // layer II
          playlist_entry->bit_rate = br_table[1][br_index];
        else                                               // layer III
          playlist_entry->bit_rate = br_table[2][br_index];  
      else if( layer_index == 3 )                          // mpeg2.x, layerI
        playlist_entry->bit_rate = br_table[3][br_index];  
      else                                                 // mpeg2.x, layerII or III
        playlist_entry->bit_rate = br_table[4][br_index];          
      
      playlist_entry->total_samples = ( datasize / ( playlist_entry->bit_rate / 8 )) * playlist_entry->sample_rate;
      ret_code = 0;
    }
    else
    {
//      printf( "DEBUG: Found Xing header\n" );
      if( id == 0 ) 
        playlist_entry->sample_rate >>= 1;
      
      temp_ptr+=4;
      flags = BigEnd32( temp_ptr );
      temp_ptr+=4;
      if( flags & FRAMES_FLAG )
      {
        num_frames = BigEnd32( temp_ptr );
        playlist_entry->total_samples = samples_per_frame * num_frames;
        seconds = playlist_entry->total_samples / 
                  playlist_entry->sample_rate;
        playlist_entry->bit_rate = ( datasize / seconds ) * 8;
        temp_ptr+=4;
      }
      if( flags & BYTES_FLAG )
      {
        temp_ptr+=4;
      }
      
      if( flags & TOC_FLAG ) 
      {
        temp_ptr+=100;
      }
      
      playlist_entry->vbr_scale = -1;
      if( flags & VBR_SCALE_FLAG )
      {
        playlist_entry->vbr_scale = BigEnd32( temp_ptr );
        temp_ptr+=4;
      }
      
      playlist_entry->vbr = 1;
      ret_code = 0;     
    }
  }

  free( buffer );
 
  return( ret_code ); 
}


/***********************************************************************
 * Function: NiosIIMP3_Input                                           *
 *                                                                     *
 * Purpose: This is the callback function the MAD API calls when it's  *
 *          buffer has run out of frames to decode (or hasnt gotten    *
 *          any yet).  We simply refill the file buffer from the file  *
 *          and pass the buffer pointer back to the decoder.           *
 *                                                                     *
 * Input:   Pointer to the MP3 file structure. (passed in as a void*)  *
 *          Pointer to the decoder's input stream buffer structure     *
 * Output:  A refilled input stream buffer                             * 
 * Returns: Error Code, MAD_FLOW_CONTINUE = Success                    *
 **********************************************************************/

enum mad_flow NiosIIMP3_Input(void *data, struct mad_stream *stream)
{

  int file_pos_needed;
  player_struct* player;
  player_state_struct* player_state;
  playlist_node_struct* playlist_node_to_read;
  int ret_code;
  int bad_files = 0;
  
//  printf( "Entering NiosIIMP3_Input\n" );
  // Our player state info gets past in as "data" 
  player = ( player_struct * )data;
  player_state = player->player_state;
  playlist_node_to_read = player->playlist->now_playing;
  
  // If we have no open file, let's open one.
  bad_files = 0;
  while( player_state->file_handle < 0 )
  {    
  	player_state->file_handle = open( player->playlist->now_playing->filename, O_RDONLY );

    // If this file cant be opened, get the next one
  	if( player_state->file_handle < 0 )
  	{
      if( !WaitOnSDCardFailure() )
      {     
        bad_files++;
        player->playlist->now_playing = player->playlist->now_playing->next;
      }
      
      if( bad_files > 2 )
      {
        NiosIIMP3_IndexSDCard( player->playlist );
        NiosIIMP3_ReadSaveStateFromSDCard( player_state );
      }      
  	}
  	else
  	{
  		player->playlist->now_playing->file_position = player->playlist->now_playing->length_of_id3v2_tag;
      printf("Playing: %s - %s\n", player->playlist->now_playing->artist, player->playlist->now_playing->title );
  	}
  }
  if( bad_files > 2 )
  {
    NiosIIMP3_IndexSDCard( player->playlist );
  }

  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, 1);

  if( player->playlist->now_playing->file_position < player->playlist->now_playing->file_length )
  {
    file_pos_needed = ( player->playlist->now_playing->file_position - ( stream->bufend - stream->next_frame ) );
    while( NiosIIMP3_FillFileBuffer( player, file_pos_needed ))
    {
      WaitOnSDCardFailure();
    }
    // Hand off the buffer to the MP3 input stream 
    mad_stream_buffer( stream, player_state->file_buffer, player_state->file_buffer_size );
    stream->sync = 0;
  
    ret_code = MAD_FLOW_CONTINUE;
  }
  else
  {
    // End of song.  Exit and let the caller decide what to do
//    printf("DEBUG: End of song. \n" );    
    ret_code = MAD_FLOW_STOP;
  }
   PERF_END(PERFORMANCE_COUNTER_BASE, 1);

//  printf( "Leaving NiosIIMP3_Input\n" );

  return( ret_code );

}


int AudioPlaySamples( int *left, 
                      int *right, 
                      alt_u32 num_samples, 
                      alt_u32 sample_rate )
{
  
  alt_audio_codec_write_samples( audio_codec_global, right, left, num_samples );

	return( 0 );
}

/***********************************************************************
 * Function: NiosIIMP3_PlayAudio                                       *
 *                                                                     *
 * Purpose: Sets the sampling rate for the PWM output, then takes a    *
 *          buffer of pcm samples and hands them to the PWM playback   *
 *          function.  Since the PWM buffer might be full, the PWM     *
 *          playback function is perpetually called until it returns 0 *
 *          meaning it accepted the samples.                           *
 *                                                                     *
 * Input:   Pointer to the MP3 file structure. (passed in as a void*)  *
 *          Pointer to the decoder's header structure (not used)       *
 *          Pointer to the decoder's PCM output sample buffers         *
 * Output:  Samples are sent to the play audio routine                 * 
 * Returns: Return code indicating whether to restart playback         *
 **********************************************************************/

int NiosIIMP3_PlayAudio( struct mad_pcm *pcm )
{  
  return( alt_audio_codec_write_samples( audio_codec_global,
                                         pcm->samples[0],
                                         pcm->samples[1],
                                         pcm->length ));

}

/***********************************************************************
 * Function: NiosIIMP3_Output                                          *
 *                                                                     *
 * Purpose: This is the callback function the MAD API calls after it's *
 *          synthesized a frame's worth of output samples and they're  *
 *          ready for playback.  We have two choices, we can measure   *
 *          the decode performance or play the samples. If we play the *
 *          samples, our performance measurement wont be accurate      *
 *          because the audio player throttles the decoder to prevent  *
 *          overflow.  When PLAY_AUDIO is 1, the highest the decode    *
 *          performance will ever be is the output sample rate         *
 *                                                                     *
 *          Second, we take this opportunity to check the buttons and  *
 *          see if they've been pressed.                               *
 *                                                                     *
 *          Lastly, we throw in a flashy LED spinner every time a      *
 *          frame is decoded                                           *
 *                                                                     *
 * Input:   Pointer to the MP3 file structure. (passed in as a void*)  *
 *          Pointer to the decoder's header structure (not used)       *
 *          Pointer to the decoder's PCM output sample buffers         *
 * Output:  Samples are sent to the play audio routine                 * 
 * Returns: Return code whether to restart playback                    *
 **********************************************************************/

enum mad_flow NiosIIMP3_Output( void *data,
                                struct mad_header const *header,
                                struct mad_pcm *pcm )         
{
  // Our file info gets past in as void* "data" 
  player_struct* player = (player_struct*)data;  
	player_state_struct* player_state = player->player_state;  
  gui_struct* gui = player->gui;  
  
	int ret_code = MAD_FLOW_CONTINUE;
  int gui_state;
  alt_u32 buttons;
	signed long temp_sample;
	short dithered_samples_r[1152];
	short dithered_samples_l[1152];
	int i;
	static struct audio_dither left_dither, right_dither;
	static int file_handle = -1;
	static int num_bytes_written_to_wave_file = 0;

	for( i = 0; i < pcm->length; i++ )
	{
#   if OUTPUT_MODE == MAD_DITHER
 		dithered_samples_r[i] = (short)audio_linear_dither( OUTPUT_BITS, 
		                                                    pcm->samples[0][i],
                                                        &right_dither );
		dithered_samples_l[i] = (short)audio_linear_dither( OUTPUT_BITS, 
		                                                    pcm->samples[1][i],
                                                        &left_dither );
#   endif

#   if OUTPUT_MODE == NATE_DITHER
    dithered_samples_r[i] = (short)audio_linear_dither_nate( OUTPUT_BITS, pcm->samples[0][i] );
    dithered_samples_l[i] = (short)audio_linear_dither_nate( OUTPUT_BITS, pcm->samples[1][i] );
#   endif


#   if OUTPUT_MODE == ROUND
    dithered_samples_r[i] = (short)audio_linear_round( OUTPUT_BITS, pcm->samples[0][i] );
    dithered_samples_l[i] = (short)audio_linear_round( OUTPUT_BITS, pcm->samples[1][i] );
#   endif

#   if OUTPUT_MODE == WAV_FILE_DIRECT
    dithered_samples_r[i] = (short)audio_linear_dither_nate( 27, pcm->samples[0][i] );
    dithered_samples_l[i] = (short)audio_linear_dither_nate( 27, pcm->samples[1][i] );
#   endif

	}
				
# if OUTPUT_DEST == AUDIO_CODEC
  while( alt_audio_codec_write_samples( audio_codec_global,
                                        dithered_samples_r,
                                        dithered_samples_l,
                                        pcm->length ))
  {
//  }{  // NATE DEBUG
	  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, 4);
    gui_state = UpdateGUIMain( player );
    if( gui_state == MAD_FLOW_STOP )
    {
      ret_code = MAD_FLOW_STOP;
    }
    
  	PERF_END (PERFORMANCE_COUNTER_BASE, 4);
  }
  
  // DEBUG
//  player->playlist->now_playing->file_position = 
//    player->playlist->now_playing->file_length / 2;
  
  player_state->total_samples_played += pcm->length;
  player_state->samples_played_this_song += pcm->length;

  
  // Implement the pause function
  while( player_state->command == COMMAND_PAUSE )
  {
    gui_state = UpdateGUIMain( player );
    if( gui_state == MAD_FLOW_STOP )
    {
      ret_code = MAD_FLOW_STOP;
    }
  }   

      
# endif

# if OUTPUT_DEST == WAV_FILE 
	
  if( file_handle < 0 )
  {
//		printf( "DEBUG: Opening file /dev/sd_card_controller/MP3/temp.wav\n" );
		file_handle = open( "/dev/sd_card_controller/MP3/temp.wav", ( O_RDWR | O_CREAT ));
//		printf( "DEBUG: filehandle = 0x%X\n", file_handle );
//		printf( "DEBUG: Writing file header\n" );
		write_wave_file_header( file_handle );
//		printf( "DEBUG: Finished writing file header\n" );
	}

//	printf( "DEBUG: Writing %d samples, of audio data to file\n", pcm->length );
	num_bytes_written_to_wave_file +=
	  write_samples_to_wave_file( file_handle,
	                              dithered_samples_r,
  	                            dithered_samples_l,
    	                          pcm->length );
//	printf( "DEBUG: Finished writing. Total bytes written = %d\n", num_bytes_written_to_wave_file );
	printf( "DEBUG: %d\n", num_bytes_written_to_wave_file );
  
//	printf( "DEBUG: Updating file header\n" );
	update_wave_file_header( file_handle, num_bytes_written_to_wave_file );
//	printf( "DEBUG: Finished updating file header\n" );
# endif


  return( ret_code );
}

/***********************************************************************
 * Function: NiosIIMP3_Error                                           *
 *                                                                     *
 * Purpose: This is the callback function the MAD API calls when it    *
 *          encounters a decode error.  The only error we really know  *
 *          how to deal with is when the decoder runs into an ID3 tag. *
 *          All we do is read the length of the tag, then refill the   *
 *          file buffer starting where the ID3 tag ends.  That should  *
 *          be the beginning of a valid frame.                         *
 *                                                                     *
 * Input:   Pointer to the MP3 file structure. (passed in as a void*)  *
 *          Pointer to the decoder's input stream buffer structure     *
 *          Pointer to the decoder's frame buffer structure (not used) *
 * Output:  A refilled file buffer that starts with a valid frame OR   *
 *          an error message if the error wasnt ID3 tag related        * 
 * Returns: MAD_FLOW_CONTINUE = success, MAD_FLOW_BREAK = error        *
 **********************************************************************/

enum mad_flow NiosIIMP3_Error( void *data, 
                               struct mad_stream *stream, 
                               struct mad_frame *frame )
{
  int ret_code;
//  int i;
  player_struct* player;
  player_state_struct* player_state;
  int file_pos_needed;
  char *string;
  
  string = mad_stream_errorstr(stream);
  printf( "Entering NiosIIMP3_Error: %s\n", string );

  /* Our file info gets past in as "data" */
  player = ( player_state_struct * )data;
  player_state = player->player_state;
   
//  if( stream->error == MAD_ERROR_LOSTSYNC )
  if( 1 )
  {
/*    if( mad_stream_sync( stream ) == 0 )
    {
      mad_stream_buffer( stream, stream->ptr.byte, player_state->file_buffer_size - ( stream->ptr.byte - player_state->file_buffer ) );
      stream->sync = 0;
    
      printf( "Successfully resynced\n" );
    }  
    else
*/
    {
//      file_pos_needed = ( player->playlist->now_playing->file_position );
      file_pos_needed = (( player->playlist->now_playing->file_position - ( stream->bufend - stream->next_frame )) + 1 );      
      NiosIIMP3_FillFileBuffer( player, file_pos_needed );
      mad_stream_buffer( stream, player_state->file_buffer, player_state->file_buffer_size );
      stream->sync = 0;
    }  
    ret_code = MAD_FLOW_CONTINUE;
  }
  // We could be hitting an ID3v1 tag, which is found at the end of 
  // the file.  If so, we just break since it means there are no more 
  // MP3 frames in this file.
  else if ( (stream->this_frame[0] == 0x54) &&          //"T"
            (stream->this_frame[1] == 0x41) &&          //"A"
            (stream->this_frame[2] == 0x47) )           //"G"
            
  {
    ret_code = MAD_FLOW_BREAK;
  }
  else
  {
//    DEBUGF( "ERROR ERROR!! \n" );
    ret_code = MAD_FLOW_BREAK;
  }
  
  
  printf( "Leaving NiosIIMP3_Error\n" );

  return( ret_code );
}

/***********************************************************************
 * Function: NiosIIMP3_FillFileBuffer                                  *
 *                                                                     *
 * Purpose: Refills the file buffer from the file starting at the file *
 *          position requested, calling on the FAT filesystem to read  *
 *          data out of the file into the file buffer.                 *
 *          Since there's usually some data leftovers in the file      *
 *          buffer that we havent yet processed and want to keep, we   *
 *          move that to the front before refilling                    *
 *                                                                     *
 * Input:   Pointer to the MP3 file structure.                         *
 *          Position in the file we want at the front of the buffer    *
 * Output:  A refilled file buffer that starts with a valid frame      * 
 * Returns: 0 for success, -1 for fail                                                       *
 **********************************************************************/

int NiosIIMP3_FillFileBuffer( player_struct* player, int file_pos_needed )
{
  player_state_struct* player_state = player->player_state;
  
  int file_handle = player_state->file_handle;
  int ret_code;
  int new_file_position;

//  static int now = 0;
//  static int times_function_called = 0;
//  times_function_called++;
//  now = alt_nticks();
//  printf( "i %3d - %5d - %5d \n", times_function_called, now, FILE_BUFFER_SIZE ); 
  
  
  new_file_position = lseek( file_handle, file_pos_needed, SEEK_SET );
  if( new_file_position < 0 )
  {
    ret_code = -1;
  }
  else
  {
    player->playlist->now_playing->file_position = new_file_position;
//    printf("DEBUG: file_position = %d\n", player->playlist->now_playing->file_position );    
    int bytes_read = read( file_handle, 
                           player_state->file_buffer,
                           FILE_BUFFER_SIZE );
//    printf("DEBUG: bytes_read = %d\n", bytes_read );    
    player_state->file_buffer_size = bytes_read;
    player->playlist->now_playing->file_position += bytes_read;
    ret_code = 0;
  }

  return( ret_code );
}

int TempAdjustVolBal( player_state_struct* player_state, alt_touchscreen* touchscreen )
{
  int pen_is_down = 0;
  static int last_pen_is_down = 0;
  int touchscreen_x, touchscreen_y;
  static int start_x = 0;
  static int start_y = 0;
  int relative_x, relative_y;
  static int start_vol;
  int vol_change, new_vol;
  static int start_bal;
  int bal_change, new_bal;
  int ret_code;

  // Gather the latest touchscreen coordinates
  alt_touchscreen_get_pen ( touchscreen, &pen_is_down, &touchscreen_x, &touchscreen_y );

  if( pen_is_down )
  {
    if( last_pen_is_down == 0 )
    {
      start_x = touchscreen_x;
      start_y = touchscreen_y;
      start_vol = player_state->volume;
      start_bal = player_state->balance;
    }
    relative_x = start_x - touchscreen_x;;
    relative_y = start_y - touchscreen_y;
    
    vol_change = ( relative_y * 100 ) / 480;
    bal_change = (( 0 - relative_x ) * 100 ) / 800;
    
    if( start_vol + vol_change > 100 )
    	new_vol = 100;
    else if( start_vol + vol_change < 0 )
    	new_vol = 0;
    else
    	new_vol = start_vol + vol_change;

    if( start_bal + bal_change > 100 )
    	new_bal = 100;
    else if( start_bal + bal_change < 0 )
    	new_bal = 0;
    else
    	new_bal = start_bal + bal_change;

    	
    player_state->volume = new_vol;
    player_state->balance = new_bal;
    
//    printf( "Old Bal: %d, New bal: %d\n", start_bal, new_bal );
    audio_codec_set_headphone_volume( audio_codec_global, player_state->volume );
    audio_codec_set_headphone_balance( audio_codec_global, player_state->balance );
      
    if(( touchscreen_x > 750 ) && ( touchscreen_y > 430 ))
    {
      player_state->command = COMMAND_SKIP_FWD;
    	ret_code = MAD_FLOW_STOP;
    }
    else if(( touchscreen_x < 50 ) && ( touchscreen_y > 430 ))
    {
      player_state->command = COMMAND_SKIP_BACK;
      ret_code = MAD_FLOW_STOP;
    }
    else if(( touchscreen_x > 750 ) && ( touchscreen_y < 50 ) && ( last_pen_is_down == 0 ))
    {
    	if( player_state->command == COMMAND_PAUSE )
    	{
      	player_state->command = COMMAND_PLAY;
	      ret_code = MAD_FLOW_CONTINUE;
    	}
    	else if ( player_state->command == COMMAND_PLAY )
    	{
      	player_state->command = COMMAND_PAUSE;
	      ret_code = MAD_FLOW_CONTINUE;
      }
    }
    else
    {
    	ret_code = MAD_FLOW_CONTINUE;
    }

    last_pen_is_down = 1;

  }
  else
  {
    last_pen_is_down = 0;
   	ret_code = MAD_FLOW_CONTINUE;
  }      
 	
 	return( ret_code );
}

static inline
unsigned long prng_nate(unsigned long state)
{
  return (state * 0x0019660dL + 0x3c6ef35fL) & 0xffffffffL;
}


signed long audio_linear_dither_nate( unsigned int bits, mad_fixed_t sample )
{
	unsigned int scalebits, noisebits;
  mad_fixed_t output, scalemask, noisemask;
  static mad_fixed_t random = 0;
  signed long return_val;

  /* bias */
  output = sample + (1L << (MAD_F_FRACBITS + 1 - bits - 1));

  scalebits = ( MAD_F_FRACBITS + 1 - bits );
  scalemask = (1L << scalebits) - 1;

  noisebits = scalebits + 0;
  noisemask = (1L << noisebits) - 1;

  /* dither */
  random  = prng_nate( random );
  output += ( random & noisemask );

  /* quantize */
  output &= ~scalemask;
  
  /* scale */
  return_val = output >> scalebits;
  return return_val;
}

int write_wave_file_header( int file_handle )
{
	// header
	char           chunkid[4] =     "RIFF";
	unsigned int   chunksize =      0;       // dummy.  We overwrite this later.
	unsigned int   format =         "WAVE";		
                                  
	// fmt                          
	char           subchunkid[4] =  "fmt ";
	unsigned int   subchunksize =   16;
	unsigned short audioformat =    1;
	unsigned short numchannels =    2;
	unsigned int   samplerate =     44100;
	unsigned int   byterate =       samplerate * numchannels * 16;
	unsigned short blockalign =     4;
	unsigned short bitspersample =  16;
	
	//data
	char           subchunk2id[4] = "data";
	unsigned int   subchunk2size =  0;      //dummy.  we overwrite this later
	
	write( file_handle, chunkid, 4 );
  write( file_handle, &chunksize, 4 );
  write( file_handle, format, 4 );
                                  
  write( file_handle, subchunkid, 4 );
  write( file_handle, &subchunksize, 4 );
  write( file_handle, &audioformat, 2 );
  write( file_handle, &numchannels, 2 );
  write( file_handle, &samplerate, 4 );
  write( file_handle, &byterate, 4 );
  write( file_handle, &blockalign, 2 );
  write( file_handle, &bitspersample, 2 );
	
  write( file_handle, subchunk2id, 4 );
  write( file_handle, &subchunk2size, 4 );
  
  return( 0 );

}


int write_samples_to_wave_file( int file_handle, short* right, short* left, int num_samples )
{
	int composite_samples[1152];
	unsigned short left_sample, right_sample;
	int i;
  int bytes_written;
	
	for( i = 0; i < num_samples; i++ )
  { 
    left_sample = *left & 0xFFFF;
    right_sample = *right & 0xFFFF;
    composite_samples[i] = ((( left_sample ) << 16 ) | right_sample );
    left++;
    right++;
  }

	bytes_written = write( file_handle, composite_samples, num_samples*4 );
	
	return( bytes_written );
}

int update_wave_file_header( int file_handle, int num_bytes )
{
	int file_pos;
	unsigned int chunksize = num_bytes + 36;
	unsigned int subchunk2size = num_bytes;
	
	file_pos = lseek( file_handle, 4, SEEK_SET );
  write( file_handle, &chunksize, 4 );
	
	file_pos = lseek( file_handle, 40, SEEK_SET );
  write( file_handle, &subchunk2size, 4 );
	
//	file_pos = lseek( file_handle, 0, SEEK_END );
  file_pos = lseek( file_handle, chunksize+8, SEEK_SET );
	
	return( 0 );
	
}




/***********************************************************************
 * Function: NiosIIMP3_ReadDatabaseFromSDCard                          *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns: Number of files found in playlist (or 0 if not found)      *
 **********************************************************************/
int NiosIIMP3_ReadDatabaseFromSDCard( char* folder, char* playlist_filename, playlist_struct* playlist )
{
  int file_handle = -1;
  int dir_checksum = 0;
  char* absolute_path;
  char* line_buffer;
  char* rootpath;
  int ret_code = 0;
  playlist_node_struct* current_node;  // NEED TO MALLOC STILL 
//  char* temp_string;
//  int i = 0;;
  
  absolute_path = malloc( 512 );  
  line_buffer = malloc( 2048 );
  
  rootpath = sd_card_global->mount_point;
  
  sprintf( absolute_path, "%s%s/%s", rootpath, folder, playlist_filename );
  
  file_handle = open( absolute_path, O_RDONLY );

  if( file_handle < 0 )
  {
    ret_code = 0;
  }
  else
  {
    while( sd_getstring( line_buffer, 2048, file_handle ))
    {
      dir_checksum =                NiosIIMP3_ReadTagIntFromString( "dir_checksum", line_buffer );
      if( dir_checksum )
      {
        playlist->checksum = dir_checksum;
      }
      else
      {
        current_node = AddEntryToBottomOfPlaylist( playlist );
        
        current_node->filename =      NiosIIMP3_ReadTagStringFromString( "filename", line_buffer );
        current_node->title =         NiosIIMP3_ReadTagStringFromString( "title", line_buffer );
        current_node->artist =        NiosIIMP3_ReadTagStringFromString( "artist", line_buffer );
        current_node->album =         NiosIIMP3_ReadTagStringFromString( "album", line_buffer );
        current_node->genre =         NiosIIMP3_ReadTagStringFromString( "genre", line_buffer );
        current_node->year =          NiosIIMP3_ReadTagStringFromString( "year", line_buffer );
        current_node->track =         NiosIIMP3_ReadTagStringFromString( "track", line_buffer );
        current_node->vbr =           NiosIIMP3_ReadTagIntFromString( "vbr", line_buffer );
        current_node->vbr_scale =     NiosIIMP3_ReadTagIntFromString( "vbr_scale", line_buffer );
        current_node->version_id =    NiosIIMP3_ReadTagIntFromString( "version_id", line_buffer );
        current_node->layer_index =   NiosIIMP3_ReadTagIntFromString( "layer_index", line_buffer );
        current_node->sample_rate =   NiosIIMP3_ReadTagIntFromString( "sample_rate", line_buffer );
        current_node->bit_rate =      NiosIIMP3_ReadTagIntFromString( "bit_rate", line_buffer );
        current_node->total_samples = NiosIIMP3_ReadTagIntFromString( "total_samples", line_buffer );
        current_node->file_length =   NiosIIMP3_ReadTagIntFromString( "file_length", line_buffer );
        current_node->length_of_id3v2_tag = NiosIIMP3_ReadTagIntFromString( "id3v2_length", line_buffer );
      }
    }
    ret_code = 1;
  }
  
  free( line_buffer );
  free( absolute_path );
  
  return( ret_code );
}

/***********************************************************************
 * Function: NiosIIMP3_SaveDatabaseToSDCard                            *
 *                                                                     *
 * Purpose:                                                            *
 *                                                                     *
 * Input:                                                              *
 * Output:                                                             * 
 * Returns: Number of files written to playlist file                   *
 **********************************************************************/
int NiosIIMP3_SaveDatabaseToSDCard( char* folder, char* playlist_filename, playlist_struct* playlist )
{
  char* absolute_path;
//  char* parent_dir;
  char* line_buffer;
  int file_handle = -1;
  int i = 0;
  int bytes;
  playlist_node_struct* current_node;
   
  absolute_path = malloc( 512 );  
//  parent_dir = malloc( 512 );
  line_buffer = malloc( 2048 );
      
  sprintf( absolute_path, "%s%s/%s", sd_card_global->mount_point, folder, playlist_filename );
//  sprintf( parent_dir, "%s%s", sd_card_global->mount_point, folder );
  
  // Create the config folder if it doesn't exist
  sd_mkdir( folder, O_RDWR );

  file_handle = open( absolute_path, ( O_WRONLY | O_CREAT ));
  
  if( file_handle > 0 )
  {
    if( playlist->checksum )
    {
      sprintf( line_buffer, "<dir_checksum>%d</dir_checksum>\n", playlist->checksum );
      bytes = write( file_handle, line_buffer, strlen( line_buffer ));
    }
      
    current_node = playlist->list_start;

    for( i = 0; i < playlist->num_files; i++ )
    {
      sprintf( line_buffer, "<filename>%s</filename><title>%s</title><artist>%s</artist><album>%s</album><genre>%s</genre><year>%s</year><track>%s</track><id3v2_length>%d</id3v2_length><file_length>%d</file_length><vbr>%d</vbr><vbr_scale>%d</vbr_scale><version_id>%d</version_id><layer_index>%d</layer_index><sample_rate>%d</sample_rate><bit_rate>%d</bit_rate><total_samples>%d</total_samples>\n",
                            current_node->filename,
                            current_node->title,
                            current_node->artist,
                            current_node->album,
                            current_node->genre,
                            current_node->year,
                            current_node->track,
                            current_node->length_of_id3v2_tag,
                            current_node->file_length,
                            current_node->vbr,
                            current_node->vbr_scale,
                            current_node->version_id,
                            current_node->layer_index,
                            current_node->sample_rate,
                            current_node->bit_rate,
                            current_node->total_samples );


      
      bytes = write( file_handle, line_buffer, strlen( line_buffer ));
      
      current_node = current_node->next;    
    }    
    close( file_handle );
  }
  
  free( line_buffer );
  free( absolute_path );
//  free( parent_dir );

  return( playlist->num_files );
  
}

/***********************************************************************
 * Function: NiosIIMP3_WriteSaveStateToSDCard 
 *     
 * Purpose: 
 *                                                                     
 * Input:                                                              
 * Output:                                                             
 * Returns:             
 **********************************************************************/
int NiosIIMP3_WriteSaveStateToSDCard( player_struct* player )
{
  player_state_struct* player_state = player->player_state;
  
  char* absolute_path;
  char* temp_string;
  int file_handle = -1;
  int bytes;
  char termination[8] = "\0\0\0\0\0\0\0\0";
  
  absolute_path = malloc( 512 );  
  temp_string = malloc( 1024 );
      
  sprintf( absolute_path, "%s%s/%s", sd_card_global->mount_point, CONFIG_FOLDER, SAVE_STATE_FILE );
  
  // Create the config folder if it doesn't exist
  sd_mkdir( CONFIG_FOLDER, O_RDWR );

  file_handle = open( absolute_path, ( O_WRONLY | O_CREAT ));
  
  if( file_handle > 0 )
  {
    sprintf( temp_string, "<now_playing>%s</now_playing>\n", player->playlist->now_playing->filename );
    bytes = write( file_handle, temp_string, strlen( temp_string ));
    sprintf( temp_string, "<volume>%d</volume>\n", player_state->volume );
    bytes = write( file_handle, temp_string, strlen( temp_string ));    
    sprintf( temp_string, "<balance>%d</balance>\n", player_state->balance );
    bytes = write( file_handle, temp_string, strlen( temp_string ));    
    sprintf( temp_string, "<sequence>%d</sequence>\n", player_state->sequence_mode );
    bytes = write( file_handle, temp_string, strlen( temp_string ));        
    sprintf( temp_string, "<repeat>%d</repeat>\n", player_state->repeat_playlist );
    bytes = write( file_handle, temp_string, strlen( temp_string ));        
    bytes = write( file_handle, &termination, 8 );
    close( file_handle );
  }
  
  free( temp_string );
  free( absolute_path );

  return( 0 );
}

/***********************************************************************
 * Function: NiosIIMP3_SetNowPlaying 
 *     
 * Purpose: 
 *                                                                     
 * Input:                                                              
 * Output:                                                             
 * Returns:             
 **********************************************************************/
int NiosIIMP3_SetNowPlaying( char* filename, playlist_struct* playlist )
{
  int i;
  int ret_code = 0;
  playlist_node_struct* current_node = playlist->list_start;

  for( i = 0; i < playlist->num_files; i++ )
  {
    if( !strcmp( filename, current_node->filename ))
    { 
      playlist->now_playing = current_node;
      break;
    }
    current_node = current_node->next;
  }
  
  if( i == playlist->num_files )
  {
    ret_code = -1;
  }
  else
  {
    ret_code = 0;
  }
  return( ret_code );
}

/***********************************************************************
 * Function: NiosIIMP3_ReadSaveStateFromSDCard 
 *     
 * Purpose: 
 *                                                                     
 * Input:                                                              
 * Output:                                                             
 * Returns:             
 **********************************************************************/
int NiosIIMP3_ReadSaveStateFromSDCard( player_struct* player )
{
  player_state_struct* player_state = player->player_state;
  
  playlist_node_struct* current_node = player->playlist->list_start;
  char* absolute_path;
  char* line_buffer;
  char* temp_string;
  int file_handle = -1;
  int ret_code = 0;
  int i;
  
  absolute_path = malloc( 512 );  
  line_buffer = malloc( 1024 );  
          
  sprintf( absolute_path, "%s%s/%s", sd_card_global->mount_point, CONFIG_FOLDER, SAVE_STATE_FILE );

  file_handle = open( absolute_path, O_RDONLY );
  
  if( file_handle > 0 )
  {
    while( sd_getstring( line_buffer, 1024, file_handle ))
    {
      temp_string = NiosIIMP3_ReadTagStringFromString( "now_playing", line_buffer );
      if( temp_string )
      {
        NiosIIMP3_SetNowPlaying( temp_string, player->playlist );
        free( temp_string );
      }
      temp_string = NiosIIMP3_ReadTagStringFromString( "volume", line_buffer );
      if( temp_string )
      {
        player_state->volume = atoi( temp_string );
        audio_codec_set_headphone_volume( audio_codec_global, player_state->volume );
        free( temp_string );
      }        
      temp_string = NiosIIMP3_ReadTagStringFromString( "balance", line_buffer );
      if( temp_string )
      {
        player_state->balance = atoi( temp_string );
        audio_codec_set_headphone_balance( audio_codec_global, player_state->balance );        
        free( temp_string );
      }
      temp_string = NiosIIMP3_ReadTagStringFromString( "sequence", line_buffer );
      if( temp_string )
      {
        player_state->sequence_mode = atoi( temp_string );
        audio_codec_set_headphone_balance( audio_codec_global, player_state->sequence_mode );        
        free( temp_string );
      }
      temp_string = NiosIIMP3_ReadTagStringFromString( "repeat", line_buffer );
      if( temp_string )
      {
        player_state->repeat_playlist = atoi( temp_string );
        audio_codec_set_headphone_balance( audio_codec_global, player_state->repeat_playlist );        
        free( temp_string );
      }
    }      

    close( file_handle );
//    NiosIIMP3_WriteSaveStateToSDCard( player_state );

    // Make sure the now playing file we read from the player state file
    // actually exists in the playlist.  If not, just set now playing to
    // the beginning of the playlist.
    for( i = 0; i < player->playlist->num_files; i++ )
    {
      if( current_node == player->playlist->now_playing )
      {
        break;
      }
      current_node = current_node->next;
    }
    
    if( i >= player->playlist->num_files )
    {
      player->playlist->now_playing = player->playlist->list_start;
    }   
    
    ret_code = 0;
  }
  // If we cant read the player state file, make sure we set now playing
  // to the beginning of the playlist.
  else
  {
    player->playlist->now_playing = player->playlist->list_start;
    ret_code = -1;
  }
  
  free( line_buffer );
  free( absolute_path );

  
  return( ret_code );
}
