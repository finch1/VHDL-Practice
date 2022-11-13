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


#ifndef _FAT_H_
#define _FAT_H_

#include <stdio.h>
#include <stdbool.h>

#define NUM_VOLUMES 1

#define YEAR 2007
#define MONTH 02
#define DAY 28
 
#define HAVE_FAT16SUPPORT

#define FIND_BOOTSECTOR -1

#define SECTOR_SIZE     512
#define MAX_BLOCK_SIZE  2048

#define MASK   0xC0 /* 11000000 */
#define COMP   0x80 /* 10x      */


#define TEST_FAT

#define letoh16(x) (x)
#define letoh32(x) (x)
#define htole16(x) (x)
#define htole32(x) (x)
#define betoh16(x) swap16(x)
#define betoh32(x) swap32(x)
#define htobe16(x) swap16(x)
#define htobe32(x) swap32(x)

#define FIND_BOOTSECTOR -1

// Defines required for FAT code
#define IF_MV(x)
#define IF_MV2(x,y)
#define IF_MV_NONVOID(x) void


#define DEBUG 0

#if DEBUG
#define DEBUGF(x,...) printf(x,##__VA_ARGS__)
#define LDEBUGF(x,...) printf(x,##__VA_ARGS__)
#else
#define DEBUGF(x,...) 
#define LDEBUGF(x,...) 
#endif

#define panicf printf


struct fat_direntry
{
    unsigned char name[256];        /* Name plus \0 */
    unsigned short attr;            /* Attributes */
    unsigned char crttimetenth;     /* Millisecond creation
                                       time stamp (0-199) */
    unsigned short crttime;         /* Creation time */
    unsigned short crtdate;         /* Creation date */
    unsigned short lstaccdate;      /* Last access date */
    unsigned short wrttime;         /* Last write time */
    unsigned short wrtdate;         /* Last write date */
    unsigned long filesize;          /* File size in bytes */
    long firstcluster;               /* fstclusterhi<<16 + fstcluslo */
};
#define FAT_ATTR_READ_ONLY   0x01
#define FAT_ATTR_HIDDEN      0x02
#define FAT_ATTR_SYSTEM      0x04
#define FAT_ATTR_VOLUME_ID   0x08
#define FAT_ATTR_DIRECTORY   0x10
#define FAT_ATTR_ARCHIVE     0x20
#define FAT_ATTR_VOLUME      0x40 /* this is a volume, not a real directory */

struct fat_file
{
    long firstcluster;    /* first cluster in file */
    long lastcluster;     /* cluster of last access */
    long lastsector;      /* sector of last access */
    long clusternum;      /* current clusternum */
    long sectornum;       /* sector number in this cluster */
    unsigned int direntry;   /* short dir entry index from start of dir */
    unsigned int direntries; /* number of dir entries used by this file */
    long dircluster;      /* first cluster of dir */
    bool eof;
#ifdef HAVE_MULTIVOLUME
    int volume;          /* file resides on which volume */
#endif
};

struct fat_dir
{
    unsigned int entry;
    unsigned int entrycount;
    long sector;
    struct fat_file file;
    unsigned char sectorcache[3][SECTOR_SIZE];
};



long fat_readwrite( struct fat_file *file, long sectorcount,
                   void* buf, bool write );
unsigned char* utf16LEdecode(const unsigned char *utf16, unsigned char *utf8,
        unsigned int count);
unsigned char* utf8encode(unsigned long ucs, unsigned char *utf8);
unsigned long utf8length(const unsigned char *utf8);
unsigned char char2dos(unsigned char c);
const unsigned char* utf8decode(const unsigned char *utf8, unsigned short *ucs);
int fat_seek(struct fat_file *file, unsigned long seeksector );
int fat_open(IF_MV2(int volume,)
             long startcluster,
             struct fat_file *file,
             const struct fat_dir* dir);
int fat_create_file(const char* name,
                    struct fat_file* file,
                    struct fat_dir* dir);
int fat_getnext(struct fat_dir *dir, struct fat_direntry *entry);
int fat_opendir(IF_MV2(int volume,) 
                struct fat_dir *dir, unsigned long startcluster,
                const struct fat_dir *parent_dir);
int fat_mount(IF_MV2(int volume,) IF_MV2(int drive,) long startsector);
void fat_init(void);
int fat_closewrite(struct fat_file *file, long size, int attr);
int fat_remove(struct fat_file* file);
int fat_rename(struct fat_file* file, 
                struct fat_dir* dir, 
                const unsigned char* newname,
                long size,
                int attr);
int fat_truncate(const struct fat_file *file);
int fat_create_dir(const char* name,
                   struct fat_dir* newdir,
                   struct fat_dir* dir);


#endif /* _FAT_H_ */
