/**************************************************************************
	MMC/SDカードSPIアクセスペリフェラル
		ファイルサブシステム・デバイスドライバ関数 (NiosII HAL version)

		UPDATE	2011/12/10 : デバッグ版
				2011/12/28 : 1stリリース 
 **************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stddef.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/alt_warning.h>
#include <sys/alt_dev.h>
#include <sys/alt_llist.h>

#include <system.h>
#include "fatfs/ff.h"
#include "mmcfs.h"


/* ファイルデスクリプタテーブル */

#ifndef MMCFS_FD_MAXNUM
  #define MMCFS_FD_MAXNUM	ALT_MAX_FD
#endif

static int dev_mmcfs_fd_num;					// ファイルデスクリプタスタック 
static int dev_mmcfs_fd[ MMCFS_FD_MAXNUM ];
static FIL dev_mmcfs_table[ MMCFS_FD_MAXNUM ];	// ファイルオブジェクトテーブル 



/* ファイルオープン */

int dev_mmcfs_open(
		alt_fd *fd,
		const char *name,
		int flags,			// ファイルオープンフラグ 
		int mode)			// 使用しない 
{
	FIL fsobj;
	FRESULT fatfs_res;
	BYTE fatfs_mode=0;
	int fd_num;
	int str_offset;

	str_offset = strlen(fd->dev->name);

	// ファイルデスクリプタの確認 
	if( dev_mmcfs_fd_num == 0 ) return -ENFILE;

	// オープンモードの変換 
	switch( flags & 3 ) {
	default:
		return -EINVAL;

	case O_RDONLY:
		fatfs_mode = FA_OPEN_EXISTING | FA_READ;
		break;

	case O_WRONLY:
		if(flags & O_APPEND) {
			fatfs_mode = FA_OPEN_ALWAYS | FA_WRITE;
		} else {
			fatfs_mode = FA_CREATE_ALWAYS | FA_WRITE;
		}
		break;

	case O_RDWR:
		if(flags & O_APPEND) {
			fatfs_mode = FA_OPEN_ALWAYS | FA_READ | FA_WRITE;
		} else if(flags & O_CREAT) {
			fatfs_mode = FA_CREATE_ALWAYS | FA_READ | FA_WRITE;
		} else {
			fatfs_mode = FA_OPEN_EXISTING | FA_READ | FA_WRITE;
		}
		break;
	}

	// ファイルオープン 
	fatfs_res = f_open(&fsobj, name+str_offset, fatfs_mode);
	if( fatfs_res != FR_OK ) return -ENOENT;

	// ファイルデスクリプタ取得 
	dev_mmcfs_fd_num--;
	fd_num = dev_mmcfs_fd[dev_mmcfs_fd_num];
	dev_mmcfs_table[fd_num] = fsobj;

	fd->priv = (void *)&dev_mmcfs_table[fd_num];
	fd->fd_flags = fd_num;


	return fd_num;
}



/* ファイルクローズ */

int dev_mmcfs_close(
		alt_fd *fd)
{
	FIL *fp;
	FRESULT fatfs_res;
	int fd_num;

	// ファイルクローズ 
	fp = (FIL *)fd->priv;
	fd_num = fd->fd_flags;

	fatfs_res = f_close(fp);
	if( fatfs_res != FR_OK ) return -EIO;

	// ファイルデスクリプタ返却 
	dev_mmcfs_fd[dev_mmcfs_fd_num] = fd_num;
	dev_mmcfs_fd_num++;

	fd->priv = NULL;
	fd->fd_flags = -1;

	return 0;
}



/* ファイルリード */

int dev_mmcfs_read(
		alt_fd *fd,
		char *ptr,
		int len)
{
	FIL *fp;
	FRESULT fatfs_res;
	UINT readsize;

	fp = (FIL *)fd->priv;

	fatfs_res = f_read(fp, ptr, len, &readsize);
	if( fatfs_res != FR_OK ) return -EIO;

	return (int)readsize;
}



/* ファイルライト */

int dev_mmcfs_write(
		alt_fd *fd,
		const char *ptr,
		int len)
{
	FIL *fp;
	FRESULT fatfs_res;
	UINT writesize;

	fp = (FIL *)fd->priv;

	fatfs_res = f_write(fp, ptr, len, &writesize);
	if( fatfs_res != FR_OK ) return -EIO;

	return (int)writesize;
}



/* ファイルシーク */

int dev_mmcfs_lseek(
		alt_fd *fd,
		int ptr,
		int dir)
{
	FIL *fp;
	FRESULT fatfs_res;
	int fpos;

	fp = (FIL *)fd->priv;

	switch( dir ) {
	default:
		return -EINVAL;

	case SEEK_SET:
		fpos = ptr;
		break;

	case SEEK_CUR:
		fpos = (int)fp->fptr + ptr;
		break;

	case SEEK_END:
		fpos = (int)fp->fsize + ptr;
		break;
	}

	// ファイルシーク実行 
	fatfs_res = f_lseek(fp, fpos);
	if( fatfs_res != FR_OK ) return -EINVAL;

	return (int)fp->fptr;
}



/* ファイルステータス */

int dev_mmcfs_fstat(
		alt_fd *fd,
		struct stat *buf)
{
	FIL *fp;

	fp = (FIL *)fd->priv;

	buf->st_mode = S_IFREG;
	buf->st_rdev = 0;

	if( fp != NULL) {
		buf->st_size = (off_t)fp->fsize;
	} else {
		buf->st_size = 0;
	}

	return 0;
}



/* デバイスインスタンス */

static FATFS dev_mmc_fatfsobj;					// FatFSシステムオブジェクト 

static alt_dev dev_mmcfs_inst = {
	ALT_LLIST_ENTRY,	// 内部使用 
	"mmcfs:",			// デバイス名 
	dev_mmcfs_open,		// ファイルオープン 
	dev_mmcfs_close,	// ファイルクローズ 
	dev_mmcfs_read,		// ファイルリード 
	dev_mmcfs_write,	// ファイルライト 
	dev_mmcfs_lseek,	// ファイルシーク 
	dev_mmcfs_fstat,	// ファイルデバイスステータス 
	NULL				// ファイルI/Oコントロール 
};

int mmcfs_setup(void)
{
	int ret_code;

	// FatFs初期化 
	memset(&dev_mmc_fatfsobj, 0, sizeof(FATFS));	/* Invalidate file system */
	f_mount(0, &dev_mmc_fatfsobj);					/* Assign object memory to the FatFs module */

	// ファイルデスクリプタ管理テーブル初期化 
	dev_mmcfs_fd_num = 0;
	do {
		dev_mmcfs_fd[dev_mmcfs_fd_num] = dev_mmcfs_fd_num;
		dev_mmcfs_fd_num++;
	} while( dev_mmcfs_fd_num < MMCFS_FD_MAXNUM );

	// ファイルシステムデバイス登録 
	ret_code = alt_fs_reg(&dev_mmcfs_inst);

	return ret_code;
}


