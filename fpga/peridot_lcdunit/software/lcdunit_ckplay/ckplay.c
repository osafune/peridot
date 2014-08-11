/* GREENBERYL ckplay */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <system.h>
#include <io.h>

#include "nd_lib/nd_egl.h"
#include "nd_lib/nd_acm.h"
#include "nd_lib/ILI9325.h"
#include "mmcfs/fatfs/ff.h"


// 再生ファイルが格納されているディレクトリパス 

#define CKFILE_DIR		"/peridot"



// ディレクトリを開いてCKファイルを取得する 
static FATFS fatfs_obj;					// FatFSシステムオブジェクト 
static DIR fatfs_dir;					// FatFsディレクトリオブジェクト 
static FILINFO fatfs_fno;				// FatFsファイル情報オブジェクト 

int open_ckdir(const char *path)
{
	FRESULT res;

	res = f_opendir(&fatfs_dir, path);
	if (res != FR_OK) {
		printf("[!] f_opendir fail.\n\n");
		return (-1);
	}

	return 0;
}

int check_extck(const char *fn)			// 拡張子が".CK"かどうか調べる 
{
	int i;

	i = strlen(fn);
	if (i == 0) return 0;

	fn += i-1;		// 一番最後の文字へ移動 

	if ( *fn != 'k' && *fn != 'K') return 0;
	fn--;

	if ( *fn != 'c' && *fn != 'C') return 0;
	fn--;

	if ( *fn != '.') return 0;

	return 1;
}

char *get_ckfilename(void)
{
	FRESULT res;
	char *fn = NULL;

	for(;;) {
		res = f_readdir(&fatfs_dir, &fatfs_fno);
		if (res != FR_OK || fatfs_fno.fname[0] == 0) {	// エラーまたはもうファイルがない 
			fn = NULL;
			break;
		}

		if (fatfs_fno.fname[0] == '.') continue;		// ドットエントリの場合はリトライ 

		if (fatfs_fno.fattrib & AM_DIR) continue;		// ディレクトリの場合もリトライ 

		fn = *fatfs_fno.lfname ? fatfs_fno.lfname : fatfs_fno.fname;
		if ( !check_extck(fn) )	continue;				// .ckファイルでなければリトライ 

		break;
	}
//	if (fn == NULL) f_closedir(&fatfs_dir);

	return fn;
}



// CK-codecファイルの連続再生 

int main(void)
{
	FRESULT res;
	FIL fsobj;							// FatFSファイルオブジェクト 
	char fslfn[_MAX_LFN + 1];			// ロングファイルネーム格納用 
	char *fn;
	char playfile[_MAX_LFN + sizeof(CKFILE_DIR) + 1];	// 再生ファイル名のフルパス 
	alt_u16 *pFrameBuffer;
	int i;


	// ファイルシステム初期化 
	memset(&fatfs_obj, 0, sizeof(FATFS));
	f_mount(0, &fatfs_obj);

	fatfs_fno.lfname = fslfn;
	fatfs_fno.lfsize = sizeof(fslfn);


	// グラフィック初期化 
//	nd_GsVgaInit();
	ILI9325_init();

	pFrameBuffer = (alt_u16 *)malloc(na_VRAM_size);
	if (pFrameBuffer == NULL) {
		printf("[!] Framebuffer allocation fault.\n");
		return 0;
	}
	memset(pFrameBuffer, 0, na_VRAM_size);		// 全域を黒で塗りつぶす 

	nd_GsEglPage((nd_u32)pFrameBuffer, (nd_u32)pFrameBuffer, 0);
//	nd_GsVgaScanOn();


	// ck-codec 再生開始 
	while(1) {
		fn = get_ckfilename();
		if (fn == NULL) {
			if ( open_ckdir(CKFILE_DIR) ) {
				printf("[!] Directory open fail.\n");
				break;
			}
			continue;
		}
		strcpy(playfile, CKFILE_DIR "/");
		strcat(playfile, fn);

		res = f_open(&fsobj, playfile, FA_READ);
		if( res != FR_OK ) {
			printf("[!] file open fail.\n");
			break;
		}

		printf("play start : %s\n", playfile);

		i = nd_GsCkPlay(&fsobj, pFrameBuffer);
		if (i) {
			f_close(&fsobj);
			switch(i) {
			default : 
				printf("[!] Unkown error.\n");
				break;

			case -1 :
				printf("[!] Not CK-codec file.\n");
				break;

			case -2 :
				printf("[!] f_read fail(xx).\n");
				break;

			case -3 :
				printf("[!] Memory allocation fail.\n");
				break;
			}
			break;
		}

		printf("play stop.\n");

		f_close(&fsobj);
	}


	while(1) {}
}
