/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 *
 * Copyright (C) 2002 by Linus Nielsen Feltzing
 *
 * All files in this archive are subject to the GNU General Public License.
 * See the file COPYING in the source tree root for full license agreement.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/

#include <stdio.h>
#include <errno.h>
#include <string.h>

#include "fat_file.h"
#include "fat.h"

#define MAX_OPEN_FILES 10

#ifndef MIN
#define MIN(a, b) (((a)<(b))?(a):(b))
#endif

/*
  These functions provide a roughly POSIX-compatible file IO API.

  Since the fat32 driver only manages sectors, we maintain a one-sector
  cache for each open file. This way we can provide byte access without
  having to re-read the sector each time. 
  The penalty is the RAM used for the cache and slightly more complex code.
*/

#define BYTES2INT32(array,pos)          \
    ((long)array[pos] | ((long)array[pos+1] << 8 ) |    \
     ((long)array[pos+2] << 16 ) | ((long)array[pos+3] << 24 ))


struct filedesc {
    unsigned char cache[SECTOR_SIZE];
    int cacheoffset; /* invariant: 0 <= cacheoffset <= SECTOR_SIZE */
    long fileoffset;
    long size;
    int attr;
    struct fat_file fatfile;
    bool busy;
    bool write;
    bool dirty;
    bool trunc;
};

static struct filedesc openfiles[MAX_OPEN_FILES];

static struct partinfo part[8]; /* space for 4 partitions on 2 drives */
static int vol_drive[NUM_VOLUMES]; /* mounted to which drive (-1 if none) */


#define MAX_OPEN_DIRS 8
static DIR opendirs[MAX_OPEN_DIRS];


int rb_fat_fstat( int fd, struct stat *st )
{
	int ret_code;
  struct filedesc* file = &openfiles[fd];

  if ( !file->busy ) 
  {
  	errno = EBADF;
    return -1;
  }

	st->st_size = file->size;
//  st->st_mode = fd->fd_flags; 
  
  return( 0 );
	
}


int rb_fat_open( const char* pathname, int flags )
{
    DIR* dir;
    struct dirent* entry;
    int fd;
    char pathnamecopy[MAX_PATH];
    char* name;
    struct filedesc* file = NULL;
    int rc;

    LDEBUGF("open(\"%s\",%d)\n",pathname,flags);
				
    if ( pathname[0] != '/' ) {
        DEBUGF("'%s' is not an absolute path.\n",pathname);
        DEBUGF("Only absolute pathnames supported at the moment\n");
        errno = EINVAL;
        return -1;
    }

    /* find a free file descriptor */
    for ( fd=0; fd<MAX_OPEN_FILES; fd++ )
        if ( !openfiles[fd].busy )
            break;

    if ( fd == MAX_OPEN_FILES ) {
        DEBUGF("Too many files open\n");
        errno = EMFILE;
        return -2;
    }

    file = &openfiles[fd];
    memset(file, 0, sizeof(struct filedesc));

    if (flags & (O_RDWR | O_WRONLY)) {
        file->write = true;

        if (flags & O_TRUNC)
            file->trunc = true;
    }
    file->busy = true;

    strncpy(pathnamecopy,pathname,sizeof(pathnamecopy));
    pathnamecopy[sizeof(pathnamecopy)-1] = 0;

    /* locate filename */
    name=strrchr(pathnamecopy+1,'/');
    if ( name ) {
        *name = 0; 
        dir = rb_fat_opendir(pathnamecopy);
        *name = '/';
        name++;
    }
    else {
        dir = rb_fat_opendir("/");
        name = pathnamecopy+1;
    }
    if (!dir) {
        DEBUGF("Failed opening dir\n");
        errno = EIO;
        file->busy = false;
        return -4;
    }

    if(name[0] == 0) {
        DEBUGF("Empty file name\n");
        errno = EINVAL;
        file->busy = false;
        rb_fat_closedir(dir);
        return -5;
    }
    
    /* scan dir for name */
    while ((entry = readdir(dir))) {
        if ( !strcasecmp(name, entry->d_name) ) {
            fat_open(IF_MV2(dir->fatdir.file.volume,)
                     entry->startcluster,
                     &(file->fatfile),
                     &(dir->fatdir));
            file->size = file->trunc ? 0 : entry->size;
            file->attr = entry->attribute;
            break;
        }
    }

    if ( !entry ) {
        LDEBUGF("Didn't find file %s\n",name);
        if ( file->write && (flags & O_CREAT) ) {
            rc = fat_create_file(name,
                                 &(file->fatfile),
                                 &(dir->fatdir));
            if (rc < 0) {
                DEBUGF("Couldn't create %s in %s\n",name,pathnamecopy);
                errno = EIO;
                file->busy = false;
                rb_fat_closedir(dir);
                return rc * 10 - 6;
            }
#ifdef HAVE_DIRCACHE
            dircache_add_file(pathname);
#endif
            file->size = 0;
            file->attr = 0;
        }
        else {
            DEBUGF("Couldn't find %s in %s\n",name,pathnamecopy);
            errno = ENOENT;
            file->busy = false;
            rb_fat_closedir(dir);
            return -7;
        }
    } else {
        if(file->write && (file->attr & FAT_ATTR_DIRECTORY)) {
            errno = EISDIR;
            file->busy = false;
            rb_fat_closedir(dir);
            return -8;
        }
    }
    rb_fat_closedir(dir);

    file->cacheoffset = -1;
    file->fileoffset = 0;

    if (file->write && (flags & O_APPEND)) {
        rc = rb_fat_lseek(fd,0,SEEK_END);
        if (rc < 0 )
            return rc * 10 - 9;
    }

#ifdef HAVE_DIRCACHE
    if (file->write)
        dircache_bind(fd, pathname);
#endif

    return fd;
}


int rb_fat_close(int fd)
{
    struct filedesc* file = &openfiles[fd];
    int rc = 0;

    LDEBUGF("close(%d)\n", fd);

    if (fd < 0 || fd > MAX_OPEN_FILES-1) {
        errno = EINVAL;
        return -1;
    }
    if (!file->busy) {
        errno = EBADF;
        return -2;
    }
    if (file->write) {
        rc = rb_fat_fsync(fd);
        if (rc < 0)
            return rc * 10 - 3;
    }

    file->busy = false;
    return 0;
}


struct dirent* readdir(DIR* dir)
{
    struct fat_direntry entry;
    struct dirent* theent = &(dir->theent);

    if (!dir->busy)
        return NULL;

#ifdef HAVE_MULTIVOLUME
    /* Volumes (secondary file systems) get inserted into the root directory
        of the first volume, since we have no separate top level. */
    if (dir->volumecounter >= 0 /* on a root dir */
     && dir->volumecounter < NUM_VOLUMES /* in range */
     && dir->fatdir.file.volume == 0) /* at volume 0 */
    {   /* fake special directories, which don't really exist, but
           will get redirected upon rb_fat_opendir() */
        while (++dir->volumecounter < NUM_VOLUMES)
        {
            if (fat_ismounted(dir->volumecounter))
            {
                memset(theent, 0, sizeof(*theent));
                theent->attribute = FAT_ATTR_DIRECTORY | FAT_ATTR_VOLUME;
                snprintf(theent->d_name, sizeof(theent->d_name), 
                         vol_names, dir->volumecounter);
                return theent;
            }
        }
    }
#endif
    /* normal directory entry fetching follows here */
    if (fat_getnext(&(dir->fatdir),&entry) < 0)
        return NULL;

    if ( !entry.name[0] )
        return NULL;  

    strncpy(theent->d_name, entry.name, sizeof( theent->d_name ) );
    theent->attribute = entry.attr;
    theent->size = entry.filesize;
    theent->startcluster = entry.firstcluster;
    theent->wrtdate = entry.wrtdate;
    theent->wrttime = entry.wrttime;

    return theent;
}

DIR* rb_fat_opendir(const char* name)
{
    char namecopy[MAX_PATH];
    char* part;
    char* end;
    struct fat_direntry entry;
    int dd;
    DIR* pdir = opendirs;
#ifdef HAVE_MULTIVOLUME
    int volume;
#endif

    if ( name[0] != '/' ) {
        DEBUGF("Only absolute paths supported right now\n");
        return NULL;
    }

    /* find a free dir descriptor */
    for ( dd=0; dd<MAX_OPEN_DIRS; dd++, pdir++)
        if ( !pdir->busy )
            break;

    if ( dd == MAX_OPEN_DIRS ) {
        DEBUGF("Too many dirs open\n");
        errno = EMFILE;
        return NULL;
    }

    pdir->busy = true;

#ifdef HAVE_MULTIVOLUME
    /* try to extract a heading volume name, if present */
    volume = strip_volume(name, namecopy);
    pdir->volumecounter = 0;
#else
    strncpy(namecopy,name,sizeof(namecopy)); /* just copy */
    namecopy[sizeof(namecopy)-1] = '\0';
#endif

    if ( fat_opendir(IF_MV2(volume,) &pdir->fatdir, 0, NULL) < 0 ) {
        DEBUGF("Failed opening root dir\n");
        pdir->busy = false;
        return NULL;
    }

    for ( part = strtok_r(namecopy, "/", &end); part;
          part = strtok_r(NULL, "/", &end)) {
        /* scan dir for name */
        while (1) {
            if ((fat_getnext(&pdir->fatdir,&entry) < 0) ||
                (!entry.name[0])) {
                pdir->busy = false;
                return NULL;
            }
            if ( (entry.attr & FAT_ATTR_DIRECTORY) &&
                 (!strcasecmp(part, entry.name)) ) {
                pdir->parent_dir = pdir->fatdir;
                if ( fat_opendir(IF_MV2(volume,)
                                 &pdir->fatdir,
                                 entry.firstcluster,
                                 &pdir->parent_dir) < 0 ) {
                    DEBUGF("Failed opening dir '%s' (%ld)\n",
                           part, entry.firstcluster);
                    pdir->busy = false;
                    return NULL;
                }
#ifdef HAVE_MULTIVOLUME
                pdir->volumecounter = -1; /* n.a. to subdirs */
#endif
                break;
            }
        }
    }

    return pdir;
}

int rb_fat_closedir(DIR* dir)
{
    dir->busy=false;
    return 0;
}

static int get_free_volume(void)
{
    int i;
    for (i=0; i<NUM_VOLUMES; i++)
    {
        if (vol_drive[i] == -1) /* unassigned? */
            return i;
    }

    return -1; /* none found */
}


int disk_mount(int drive)
{
    int i;
    int mounted = 0; /* reset partition-on-drive flag */
    int volume = get_free_volume();
    struct partinfo* pinfo = disk_init(IF_MV(drive));

    if (pinfo == NULL)
    {
        return 0;
    }
    for (i=0; volume != -1 && i<4; i++)
    {
        if (!fat_mount(IF_MV2(volume,) IF_MV2(drive,) pinfo[i].start))
        {
            mounted++;
            vol_drive[volume] = drive; /* remember the drive for this volume */
            volume = get_free_volume(); /* prepare next entry */
        }
    }

    if (mounted == 0 && volume != -1) /* none of the 4 entries worked? */
    {   /* try "superfloppy" mode */
        DEBUGF("No partition found, trying to mount sector 0.\n");
        if (!fat_mount(IF_MV2(volume,) IF_MV2(drive,) 0))
        {
            mounted = 1;
            vol_drive[volume] = drive; /* remember the drive for this volume */
        }
    }
    return mounted;
}

struct partinfo* disk_init(IF_MV_NONVOID(int drive))
{
    int i;
    unsigned char sector[512];
    unsigned char* ptr;
#ifdef HAVE_MULTIVOLUME
    /* For each drive, start at a different position, in order not to destroy 
       the first entry of drive 0. 
       That one is needed to calculate config sector position. */
    struct partinfo* pinfo = &part[drive*4];
    if ((size_t)drive >= sizeof(part)/sizeof(*part)/4)
        return NULL; /* out of space in table */
#else
    struct partinfo* pinfo = part;
#endif

    rb_fat_read_sectors(IF_MV2(drive,) 0,1,(unsigned short*)(&sector));

    /* check that the boot sector is initialized */
    if ( (sector[510] != 0x55) ||
         (sector[511] != 0xaa)) {
        DEBUGF("Bad boot sector signature\n");
        return NULL;
    }

    /* parse partitions */
    for ( i=0; i<4; i++ ) {
//        unsigned char* ptr = sector + 0x1be + 16*i;
        ptr = sector + 0x1be + 16*i;
        pinfo[i].type  = ptr[4];
        pinfo[i].start = BYTES2INT32(ptr, 8);
        pinfo[i].size  = BYTES2INT32(ptr, 12);

        DEBUGF("Part%d: Type %02x, start: %08lx size: %08lx\n",
               i,pinfo[i].type,pinfo[i].start,pinfo[i].size);

        /* extended? */
        if ( pinfo[i].type == 5 ) {
            /* not handled yet */
        }
    }

    return pinfo;
}

int rb_fat_getc( int fp )
{
  char ch;
  
  rb_fat_read( fp, &ch, 1);
  
  return(ch);
}


int rb_fat_disk_mount_all(void)
{
    int mounted;
    int i;
    
#if defined(HAVE_MMC) && defined(HAVE_HOTSWAP)
    mmc_enable_monitoring(false);
#endif

    fat_init(); /* reset all mounted partitions */
    for (i=0; i<NUM_VOLUMES; i++)
        vol_drive[i] = -1; /* mark all as unassigned */

    mounted = disk_mount(0);
#ifdef HAVE_MMC
    if (mmc_detect()) /* for Ondio, only if card detected */
    {
        mounted += disk_mount(1); /* try 2nd "drive", too */
    }
#ifdef HAVE_HOTSWAP
    mmc_enable_monitoring(true);
#endif
#endif

    return mounted;
}


static int flush_cache(int fd)
{
    int rc;
    struct filedesc* file = &openfiles[fd];
    long sector = file->fileoffset / SECTOR_SIZE;
      
    DEBUGF("Flushing dirty sector cache\n");
        
    /* make sure we are on correct sector */
    rc = fat_seek(&(file->fatfile), sector);
    if ( rc < 0 )
        return rc * 10 - 3;

    rc = fat_readwrite(&(file->fatfile), 1,
                       file->cache, true );

    if ( rc < 0 ) {
        if(file->fatfile.eof)
            errno = ENOSPC;

        return rc * 10 - 2;
    }

    file->dirty = false;

    return 0;
}


static int rb_fat_readwrite(int fd, void* buf, long count, bool write)
{
    long sectors;
    long nread=0;
    struct filedesc* file = &openfiles[fd];
    int rc;

    if ( !file->busy ) {
        errno = EBADF;
        return -1;
    }

    LDEBUGF( "readwrite(%d,%lx,%ld,%s)\n",
             fd,(long)buf,count,write?"write":"read");

    /* attempt to read past EOF? */
    if (!write && count > file->size - file->fileoffset)
        count = file->size - file->fileoffset;

    /* any head bytes? */
    if ( file->cacheoffset != -1 ) {
        int offs = file->cacheoffset;
        int headbytes = MIN(count, SECTOR_SIZE - offs);

        if (write) {
            memcpy( file->cache + offs, buf, headbytes );
            file->dirty = true;
        }
        else {
            memcpy( buf, file->cache + offs, headbytes );
        }

        if (offs + headbytes == SECTOR_SIZE) {
            if (file->dirty) {
                int rc = flush_cache(fd);
                if ( rc < 0 ) {
                    errno = EIO;
                    return rc * 10 - 2;
                }
            }
            file->cacheoffset = -1;
        }
        else {
            file->cacheoffset += headbytes;
        }

        nread = headbytes;
        count -= headbytes;
    }
    
    /* If the buffer has been modified, either it has been flushed already
     * (if (offs+headbytes == SECTOR_SIZE)...) or does not need to be (no
     * more data to follow in this call). Do NOT flush here. */

    /* read/write whole sectors right into/from the supplied buffer */
    sectors = count / SECTOR_SIZE;
    if ( sectors ) {
        int rc = fat_readwrite(&(file->fatfile), sectors,
            (unsigned char*)buf+nread, write );
        if ( rc < 0 ) {
            DEBUGF("Failed read/writing %ld sectors\n",sectors);
            errno = EIO;
            if(write && file->fatfile.eof) {
                DEBUGF("No space left on device\n");
                errno = ENOSPC;
            } else {
                file->fileoffset += nread;
            }
            file->cacheoffset = -1;
            return nread ? nread : rc * 10 - 4;
        }
        else {
            if ( rc > 0 ) {
                nread += rc * SECTOR_SIZE;
                count -= sectors * SECTOR_SIZE;

                /* if eof, skip tail bytes */
                if ( rc < sectors )
                    count = 0;
            }
            else {
                /* eof */
                count=0;
            }

            file->cacheoffset = -1;
        }
    }

    /* any tail bytes? */
    if ( count ) {
        if (write) {
            if ( file->fileoffset + nread < file->size ) {
                /* sector is only partially filled. copy-back from disk */
                int rc;
                LDEBUGF("Copy-back tail cache\n");
                rc = fat_readwrite(&(file->fatfile), 1, file->cache, false );
                if ( rc < 0 ) {
                    DEBUGF("Failed writing\n");
                    errno = EIO;
                    file->fileoffset += nread;
                    file->cacheoffset = -1;
                    return nread ? nread : rc * 10 - 5;
                }
                /* seek back one sector to put file position right */
                rc = fat_seek(&(file->fatfile), 
                              (file->fileoffset + nread) / 
                              SECTOR_SIZE);
                if ( rc < 0 ) {
                    DEBUGF("fat_seek() failed\n");
                    errno = EIO;
                    file->fileoffset += nread;
                    file->cacheoffset = -1;
                    return nread ? nread : rc * 10 - 6;
                }
            }
            memcpy( file->cache, (unsigned char*)buf + nread, count );
            file->dirty = true;
        }
        else {
            rc = fat_readwrite(&(file->fatfile), 1, &(file->cache),false);
            if (rc < 1 ) {
                DEBUGF("Failed caching sector\n");
                errno = EIO;
                file->fileoffset += nread;
                file->cacheoffset = -1;
                return nread ? nread : rc * 10 - 7;
            }
            memcpy( (unsigned char*)buf + nread, file->cache, count );
        }
            
        nread += count;
        file->cacheoffset = count;
    }

    file->fileoffset += nread;
    LDEBUGF("fileoffset: %ld\n", file->fileoffset);

    /* adjust file size to length written */
    if ( write && file->fileoffset > file->size )
    {
        file->size = file->fileoffset;
#ifdef HAVE_DIRCACHE
        dircache_update_filesize(fd, file->size);
#endif
    }

    return nread;
}


ssize_t rb_fat_write(int fd, const void* buf, size_t count)
{
    if (!openfiles[fd].write) {
        errno = EACCES;
        return -1;
    }
    return rb_fat_readwrite(fd, (void *)buf, count, true);
}


ssize_t rb_fat_read(int fd, void* buf, size_t count)
{
    return rb_fat_readwrite(fd, buf, count, false);
}


int rb_fat_list( char* pathname, char* buf )
{
    DIR* dir;
    struct dirent* entry;
    int files = 0;
    char* buf_wr_ptr = buf;
    char temp_pathname[512];

    LDEBUGF("ls(\"%s\")\n",pathname);

    strcpy( temp_pathname, pathname );
    
    // Check that path starts with a /
    if ( temp_pathname[0] != '/' ) {
        DEBUGF("'%s' is not an absolute path.\n",pathname);
        DEBUGF("Only absolute paths supported at the moment\n");
        errno = EINVAL;
        return -1;
    }
    
    // Ensure that path ends with a /
    int pathlen = strlen(temp_pathname);
    if( temp_pathname[pathlen -1] != '/' )
    {
      temp_pathname[pathlen] = '/';
      temp_pathname[pathlen+1] = 0x0;
    }
      
    dir = rb_fat_opendir(temp_pathname);
    if (!dir) {
        DEBUGF("Failed opening dir\n");
        errno = EIO;
        return -4;
    }
    /* scan dir for name */
    while ((entry = readdir(dir))) {
      files++;
      strcpy( buf_wr_ptr , entry->d_name );
      buf_wr_ptr += strlen( entry->d_name ) + 1;
    }
    
    rb_fat_closedir(dir);

    return files;
}

int rb_isdir( char* pathname )
{
  DIR* dir;
  char temp_pathname[512];
  int ret_code = 0;

  LDEBUGF("ls(\"%s\")\n",pathname);

  strcpy( temp_pathname, pathname );
  
  // Check that path starts with a /
  if ( temp_pathname[0] != '/' ) {
      DEBUGF("'%s' is not an absolute path.\n",pathname);
      DEBUGF("Only absolute paths supported at the moment\n");
      errno = EINVAL;
      return -1;
  }
  
  // Ensure that path ends with a /
  int pathlen = strlen(temp_pathname);
  if( temp_pathname[pathlen -1] != '/' )
  {
    temp_pathname[pathlen] = '/';
    temp_pathname[pathlen+1] = 0x0;
  }
    
  dir = rb_fat_opendir(temp_pathname);
  if (!dir) 
  {
    ret_code = 0;
  }
  else
  {
    ret_code = 1;
   }
  
  rb_fat_closedir(dir);

  return ret_code;
}


off_t rb_fat_lseek(int fd, off_t offset, int whence)
{
    off_t pos;
    long newsector;
    long oldsector;
    int sectoroffset;
    int rc;
    struct filedesc* file = &openfiles[fd];

    LDEBUGF("lseek(%d,%ld,%d)\n",fd,offset,whence);

    if ( !file->busy ) {
        errno = EBADF;
        return -1;
    }

    switch ( whence ) {
        case SEEK_SET:
            pos = offset;
            break;

        case SEEK_CUR:
            pos = file->fileoffset + offset;
            break;

        case SEEK_END:
            pos = file->size + offset;
            break;

        default:
            errno = EINVAL;
            return -2;
    }
    if ((pos < 0) || (pos > file->size)) {
        errno = EINVAL;
        return -3;
    }

    /* new sector? */
    newsector = pos / SECTOR_SIZE;
    oldsector = file->fileoffset / SECTOR_SIZE;
    sectoroffset = pos % SECTOR_SIZE;

    if ( (newsector != oldsector) ||
         ((file->cacheoffset==-1) && sectoroffset) ) {

        if ( newsector != oldsector ) {
            if (file->dirty) {
                rc = flush_cache(fd);
                if (rc < 0)
                    return rc * 10 - 5;
            }
            
            rc = fat_seek(&(file->fatfile), newsector);
            if ( rc < 0 ) {
                errno = EIO;
                return rc * 10 - 4;
            }
        }
        if ( sectoroffset ) {
            rc = fat_readwrite(&(file->fatfile), 1,
                               &(file->cache),false);
            if ( rc < 0 ) {
                errno = EIO;
                return rc * 10 - 6;
            }
            file->cacheoffset = sectoroffset;
        }
        else
            file->cacheoffset = -1;
    }
    else
        if ( file->cacheoffset != -1 )
            file->cacheoffset = sectoroffset;

    file->fileoffset = pos;

    return pos;
}

off_t rb_fat_filesize(int fd)
{
    struct filedesc* file = &openfiles[fd];

    if ( !file->busy ) {
        errno = EBADF;
        return -1;
    }
    
    return file->size;
}

int rb_fat_creat(const char *pathname, mode_t mode)
{
    (void)mode;
    return rb_fat_open(pathname, O_WRONLY|O_CREAT|O_TRUNC);
}

int rb_fat_fsync(int fd)
{
    struct filedesc* file = &openfiles[fd];
    int rc = 0;

    LDEBUGF("fsync(%d)\n", fd);

    if (fd < 0 || fd > MAX_OPEN_FILES-1) {
        errno = EINVAL;
        return -1;
    }
    if (!file->busy) {
        errno = EBADF;
        return -2;
    }
    if (file->write) {
        /* flush sector cache */
        if ( file->dirty ) {
            rc = flush_cache(fd);
            if (rc < 0)
                return rc * 10 - 3;
        }

        /* truncate? */
        if (file->trunc) {
            rc = rb_fat_ftruncate(fd, file->size);
            if (rc < 0)
                return rc * 10 - 4;
        }

        /* tie up all loose ends */
        rc = fat_closewrite(&(file->fatfile), file->size, file->attr);
        if (rc < 0)
            return rc * 10 - 5;
    }
    return 0;
}

int rb_fat_remove(const char* name)
{
    int rc;
    struct filedesc* file;
    int fd = rb_fat_open(name, O_WRONLY);
    if ( fd < 0 )
        return fd * 10 - 1;

    file = &openfiles[fd];
    rc = fat_remove(&(file->fatfile));
    if ( rc < 0 ) {
        DEBUGF("Failed removing file: %d\n", rc);
        errno = EIO;
        return rc * 10 - 3;
    }

    file->size = 0;
#ifdef HAVE_DIRCACHE
    dircache_remove(name);
#endif

    rc = rb_fat_close(fd);
    if (rc<0)
        return rc * 10 - 4;

    return 0;
}

int rb_fat_rename(const char* path, const char* newpath)
{
    int rc, fd;
    DIR* dir;
    char* nameptr;
    char* dirptr;
    struct filedesc* file;
    char newpath2[MAX_PATH];

    /* verify new path does not already exist */
    /* If it is a directory, errno == EISDIR if the name exists */
    fd = rb_fat_open(newpath, O_RDONLY);
    if ( fd >= 0 || errno == EISDIR) {
        rb_fat_close(fd);
        errno = EBUSY;
        return -1;
    }
    rb_fat_close(fd);

    fd = rb_fat_open(path, O_RDONLY);
    if ( fd < 0 ) {
        errno = EIO;
        return fd * 10 - 2;
    }

    /* extract new file name */
    nameptr = strrchr(newpath,'/');
    if (nameptr)
        nameptr++;
    else
        return - 3;

    /* Extract new path */
    strcpy(newpath2, newpath);
    
    dirptr = strrchr(newpath2,'/');
    if(dirptr)
        *dirptr = 0;
    else
        return - 4;

    dirptr = newpath2;
    
    if(strlen(dirptr) == 0) {
        dirptr = "/";
    }
    
    dir = rb_fat_opendir(dirptr);
    if(!dir)
        return - 5;
    
    file = &openfiles[fd];
    rc = fat_rename(&file->fatfile, &dir->fatdir, nameptr,
                    file->size, file->attr);
    if ( rc < 0 ) {
        DEBUGF("Failed renaming file: %d\n", rc);
        errno = EIO;
        return rc * 10 - 6;
    }

#ifdef HAVE_DIRCACHE
    dircache_rename(path, newpath);
#endif
    
    rc = rb_fat_close(fd);
    if (rc<0) {
        errno = EIO;
        return rc * 10 - 7;
    }

    rc = rb_fat_closedir(dir);
    if (rc<0) {
        errno = EIO;
        return rc * 10 - 8;
    }

    return 0;
}

int rb_fat_ftruncate(int fd, off_t size)
{
    int rc, sector;
    struct filedesc* file = &openfiles[fd];

    sector = size / SECTOR_SIZE;
    if (size % SECTOR_SIZE)
        sector++;

    rc = fat_seek(&(file->fatfile), sector);
    if (rc < 0) {
        errno = EIO;
        return rc * 10 - 1;
    }

    rc = fat_truncate(&(file->fatfile));
    if (rc < 0) {
        errno = EIO;
        return rc * 10 - 2;
    }

    file->size = size;

    return 0;
}

int rb_fat_mkdir(const char *name, int mode)
{
    DIR *dir;
    char namecopy[MAX_PATH];
    char* end;
    char *basename;
    char *parent;
    struct dirent *entry;
    struct fat_dir newdir;
    int rc;

    (void)mode;

    if ( name[0] != '/' ) {
        DEBUGF("mkdir: Only absolute paths supported right now\n");
        return -1;
    }

    strncpy(namecopy,name,sizeof(namecopy));
    namecopy[sizeof(namecopy)-1] = 0;

    /* Split the base name and the path */
    end = strrchr(namecopy, '/');
    *end = 0;
    basename = end+1;

    if(namecopy == end) /* Root dir? */
        parent = "/";
    else
        parent = namecopy;
        
    DEBUGF("mkdir: parent: %s, name: %s\n", parent, basename);

    dir = rb_fat_opendir(parent);
    
    if(!dir) {
        DEBUGF("mkdir: can't open parent dir\n");
        return -2;
    }    

    if(basename[0] == 0) {
        DEBUGF("mkdir: Empty dir name\n");
        errno = EINVAL;
        return -3;
    }
    
    /* Now check if the name already exists */
    while ((entry = readdir(dir))) {
        if ( !strcasecmp(basename, entry->d_name) ) {
            DEBUGF("mkdir error: file exists\n");
            errno = EEXIST;
            rb_fat_closedir(dir);
            return - 4;
        }
    }

    memset(&newdir, sizeof(struct fat_dir), 0);
    
    rc = fat_create_dir(basename, &newdir, &(dir->fatdir));
#ifdef HAVE_DIRCACHE
    if (rc >= 0)
        dircache_mkdir(name);
#endif

    rb_fat_closedir(dir);
    
    return rc;
}

int rb_fat_rmdir(const char* name)
{
    int rc;
    DIR* dir;
    struct dirent* entry;
    
    dir = rb_fat_opendir(name);
    if (!dir)
    {
        errno = ENOENT; /* open error */
        return -1;
    }

    /* check if the directory is empty */
    while ((entry = readdir(dir)))
    {
        if (strcmp(entry->d_name, ".") &&
            strcmp(entry->d_name, ".."))
        {
            DEBUGF("rmdir error: not empty\n");
            errno = ENOTEMPTY;
            rb_fat_closedir(dir);
            return -2;
        }
    }

    rc = fat_remove(&(dir->fatdir.file));
    if ( rc < 0 ) {
        DEBUGF("Failed removing dir: %d\n", rc);
        errno = EIO;
        rc = rc * 10 - 3;
    }
#ifdef HAVE_DIRCACHE
    else
    {
        dircache_rmdir(name);
    }
#endif

    rb_fat_closedir(dir);
    
    return rc;
}


