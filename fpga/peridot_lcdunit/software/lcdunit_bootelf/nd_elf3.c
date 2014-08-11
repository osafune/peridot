/**************************************************************************
	PROCYON IPL - Cineraria DE0/DE0-nano Edition

		アブソリュート実行elfファイルのロード＆実行 

	UPDATE	2011/12/28 : FatFS→PetitFatFSに変更 
	UPDATE  2013/04/03 : NiosII SBT用に変更、内蔵メモリマクロ化 
 **************************************************************************/

// ---------------------------------------------------------------------- //
//     Copyright (C) 2011-2013, J-7SYSTEM Works.  All rights Reserved.    //
//                                                                        //
//  * This module is a free sourcecode and there is NO WARRANTY.          //
//  * No restriction on use. You can use, modify and redistribute it for  //
//    personal, non-profit or commercial products UNDER YOUR              //
//    RESPONSIBILITY.                                                     //
//  * Redistributions of source code must retain the above copyright      //
//    notice.                                                             //
// ---------------------------------------------------------------------- //

/*
【　機能　】
	SDカードからelfファイルをメモリにロードして実行する

【必須リソース】
	・NiosIIのリセットベクタとして8kバイトの内蔵メモリマクロ
	・プログラムを外部RAMに展開して実行できるバス構成 
	・SD/MMCにアクセスできるSPIペリフェラル(MMC_SPIまたはMMCDMAペリフェラルを想定)
	・１灯以上のLED(PIOペリフェラルを想定)

【ペリフェラル名】
	・内蔵メモリマクロ : ipl_memory
	・SDカードI/F      : mmc_spi または mmcdma
	・LEDペリフェラル  : led
	・DE0の7セグLED    : led_7seg (オプション)

【BSP設定】
◆Mainタブ
　● Settings->Commmon->hal
	・□ enable_gprof
	・■ enable_reduced_device_drivers (チェック)
	・□ enable_sim_optimize
	・■ enable_small_c_library (チェック)
	・stderr/stdin/stdoutはJTAG-UART
	・sys_clk_timer/timestamp_timerはnone (※必ずnoneにすること)

　● Settings->Commmon->hal.make
	・bsp_cflags_debugは-gオプションのまま
	・bsp_cflags_optimizationを-Osにする

　● Settings->Advanced->hal
	・custom_newlib_flagsはnoneのまま
	・□ enable_c_plus_plus
	・□ enable_clean_exit
	・□ enable_exit
	・□ enable_instruction_related_exception_api
	・■ enable_lightweight_device_driver_api (チェック)
	・□ enable_mul_div_emulation (NiosII/eの場合は自動的にチェックが入る)
	・□ enable_runtime_stack_checking
	・■ enable_sopc_sysid_check (チェック)

　● Settings->Advanced->hal.linker
	・■ allow_code_at_reset (チェック)
	・□ enable_alt_load
	・□ enable_alt_load_copy_exceptions
	・□ enable_alt_load_copy_rodata
	・■ enable_alt_load_copy_rwdata (チェック)

◆Driversタブ
	・JTAG-UART(またはUART)、LED用のPIO、SYSID、NiosII FPU(使ってる場合のみ)以外のドライバを外す
		 (Enableのチェックを外す)

　● Settings->Advanced->altera_avalon_jtag_uart_driver
	・■ enable_small_driver (チェック)

　● Settings->Advanced->altera_avalon_uart_driver (UARTを使う場合)
	・□ enable_ioctl
	・■ enable_small_driver (チェック)

◆Linker Scriptタブ
	・全てのセクションのLinker Region Nameを内蔵メモリマクロ(ipl_memory)にする

【アプリケーション設定】
	・NiosII->Propertiesの"NiosII Application Properties"のOptimization levelを"Size"に設定

*/

#include <system.h>
#include <io.h>
#include <sys/alt_cache.h>
#include "pff.h"
#include "mmc_spi.h" // mmc_clock_freqの値は環境にあわせて修正すること(デフォルトでは40MHz) 


// elf_loaderが配置されるメモリアドレス 
#define ELFLOADER_SECTION			IPL_MEMORY_BASE
#define ELFLOADER_PROC_BEGIN        ((IPL_MEMORY_BASE+0) | (1<<31))
#define ELFLOADER_PROC_END          ((IPL_MEMORY_BASE+IPL_MEMORY_SPAN) | (1<<31))

// 表示用のLEDペリフェラル
#define ELFLOADER_LED				LED_BASE
#define ELFLOADER_LED_ON()			IOWR(ELFLOADER_LED, 0, ~0)		// LEDの点灯 
#define ELFLOADER_LED_OFF()			IOWR(ELFLOADER_LED, 0, 0)		// LEDの消灯 

// DE0の場合は7セグLEDに表示する 
#ifdef LED_7SEG_BASE
 #define SET_7SEGLED(_x)			IOWR(LED_7SEG_BASE, 0, (_x))
#else
 #define SET_7SEGLED(_x)
#endif

// ブートプログラムファイル名 
#define ELFLOADER_BOOT_FILE			"/PERIDOT/boot.elf"


// デバッグ用表示 
//#define _DEBUG_


/***** ELFファイル型定義 **************************************************/

// ELFファイルの変数型宣言 

typedef void*			ELF32_Addr;
typedef unsigned short	ELF32_Half;
typedef unsigned long	ELF32_Off;
typedef long			ELF32_Sword;
typedef unsigned long	ELF32_Word;
typedef unsigned char	ELF32_Char;

// ELFファイルヘッダ構造体 
typedef struct {
	ELF32_Char		elf_id[16];		// ファイルID 
	ELF32_Half		elf_type;		// オブジェクトファイルタイプ 
	ELF32_Half		elf_machine;	// ターゲットアーキテクチャ 
	ELF32_Word		elf_version;	// ELFファイルバージョン(現在は1) 
	ELF32_Addr		elf_entry;		// エントリアドレス(エントリ無しなら0) 
	ELF32_Off		elf_phoff;		// Programヘッダテーブルのファイル先頭からのオフセット 
	ELF32_Off		elf_shoff;		// 実行時未使用
	ELF32_Word		elf_flags;		// プロセッサ固有のフラグ 
	ELF32_Half		elf_ehsize;		// ELFヘッダのサイズ 
	ELF32_Half		elf_phentsize;	// Programヘッダテーブルの1要素あたりのサイズ 
	ELF32_Half		elf_phnum;		// Programヘッダテーブルの要素数 
	ELF32_Half		elf_shentsize;	// 実行時未使用
	ELF32_Half		elf_shnum;		// 実行時未使用
	ELF32_Half		elf_shstrndx;	// 実行時未使用
} __attribute__ ((packed)) ELF32_HEADER;

// Programヘッダ構造体 
typedef struct {
	ELF32_Word		p_type;			// セグメントのエントリタイプ 
	ELF32_Off		p_offset;		// 対応するセグメントのファイル先頭からのオフセット 
	ELF32_Addr		p_vaddr;		// メモリ上でのセグメントの第一バイトの仮想アドレス 
	ELF32_Addr		p_paddr;		// 物理番地指定が適切なシステムの為に予約(p_vaddrと同値)
	ELF32_Word		p_filesz;		// 対応するセグメントのファイルでのサイズ(0も可)
	ELF32_Word		p_memsz;		// 対応するセグメントのメモリ上に展開された時のサイズ(0も可)
	ELF32_Word		p_flags;		// 対応するセグメントに適切なフラグ 
	ELF32_Word		p_align;		// アライメント(p_offsetとp_vaddrをこの値で割った余りは等しい)
} __attribute__ ((packed)) ELF32_PHEADER;

// ELFオブジェクトファイルタイプの定数宣言 
#define ELF_ET_EXEC		(2)			// 実行可能なオブジェクトファイル 
#define ELF_EM_NIOS2	(0x0071)	// Altera NiosII Processor
#define ELF_PT_LOAD		(1)			// 実行時にロードされるセグメント 


/**************************************************************************
	アブソリュートelfファイルのロード 
 **************************************************************************/

/* Petit-FatFs work area */
FATFS g_fatfs_work;

/* デバッグ用printf */
#ifdef _DEBUG_
 #include <stdio.h>
 #define dgb_printf printf
#else
 int dgb_printf(const char *format, ...) { return 0; }
#endif


/* elfファイルをメモリに展開 */
static ELF32_HEADER eh;		// elfファイルヘッダ	(※メモリ使用領域確認のためstackから外している) 
static ELF32_PHEADER ph;	// elfセクションヘッダ	(※メモリ使用領域確認のためstackから外している) 

static int nd_elfload(alt_u32 *entry_addr)
{
	int phnum;
	alt_u32 phy_addr,sec_size;
	WORD res_byte,load_byte;
	DWORD f_pos;


	/* elfヘッダファイルのチェック */

	if (pf_lseek(0) != FR_OK) return (-1);
	if (pf_read(&eh, sizeof(ELF32_HEADER), &res_byte) != FR_OK) return (-1);

	if (eh.elf_id[0] != 0x7f ||				// ELFヘッダのチェック 
			eh.elf_id[1] != 'E' ||
			eh.elf_id[2] != 'L' ||
			eh.elf_id[3] != 'F') {
		return(-2);
	}
	if (eh.elf_type != ELF_ET_EXEC) {		// オブジェクトタイプのチェック 
		return(-2);
	}
	if (eh.elf_machine != ELF_EM_NIOS2) {	// ターゲットCPUのチェック 
		return(-2);
	}

	*entry_addr = (alt_u32)eh.elf_entry;	// エントリアドレスの取得 


	/* セクションデータをロード */

	f_pos = (DWORD)eh.elf_ehsize;
	for (phnum=1 ; phnum<=eh.elf_phnum ; phnum++) {

		// Programヘッダを読み込む 
		if (pf_lseek(f_pos) != FR_OK) return (-1);
		if (pf_read(&ph, eh.elf_phentsize, &res_byte) != FR_OK) return (-1);
		f_pos += eh.elf_phentsize;

		// セクションデータをメモリに展開 
		if(ph.p_type == ELF_PT_LOAD && ph.p_filesz > 0) {
			dgb_printf("- Section %d -----\n",phnum);
			dgb_printf("  Mem address : 0x%08x\n",(unsigned int)ph.p_vaddr);
			dgb_printf("  Image size  : %d bytes(0x%08x)\n",(int)ph.p_filesz, (unsigned int)ph.p_filesz);
			dgb_printf("  File offset : 0x%08x\n",(unsigned int)ph.p_offset);

			if (ELFLOADER_SECTION == (unsigned int)ph.p_vaddr) return (-2);

			if (pf_lseek(ph.p_offset) != FR_OK) return (-1);
			phy_addr = (alt_u32)ph.p_vaddr | (1<<31);
			sec_size = ph.p_filesz;

			while(sec_size > 0) {
				if (sec_size >= 32768) {		// 32kバイト単位で読み込む 
					load_byte = 32768;
					sec_size -= 32768;
				} else {
					load_byte = sec_size;
					sec_size = 0;
				}

//				if ( (ELFLOADER_PROC_BEGIN <= phy_addr+load_byte) &&
//						(ELFLOADER_PROC_END >= phy_addr+load_byte) ) return (-2);

				if (pf_read((void*)phy_addr, load_byte, &res_byte) != FR_OK) return (-1);
				phy_addr += load_byte;
			}
		}
	}

	return(0);
}


/* elfファイルのロードと実行 */

int main(void)
{
	FRESULT res;
	void (*pProc)();
	alt_u32 ledcode=0, entry_addr=0;
	char *elf_fname;

	SET_7SEGLED(~0x7c5c5c78);					// boot表示 
	ELFLOADER_LED_OFF();


	/* ELFファイル名の取得 */

	elf_fname = ELFLOADER_BOOT_FILE;


	/* FatFsモジュール初期化 */

	dgb_printf("\n*** ELF LOADING ***\n");
	dgb_printf("Disk initialize... ");

	res = pf_mount(&g_fatfs_work);				// Initialize file system 
	if (res != FR_OK) {
		dgb_printf("fail(%d)",(int)res);

		ledcode = ~0x7950d006;					// ディスク初期化エラー Err.1 
		goto BOOT_FAILED;
	}
	dgb_printf("done.\n");


	/* ファイルを開く */

	dgb_printf("Open \"%s\"\n",elf_fname);

	res = pf_open( elf_fname );
	if (res != FR_OK) {
		dgb_printf("[!] f_open fail(%d)\n", (int)res);

		ledcode = ~0x7950d05b;					// ファイルオープンエラー Err.2 
		goto BOOT_FAILED;
	}


	/* ELFファイルの読み込み */

	if (nd_elfload(&entry_addr) != 0) {
		dgb_printf("[!] elf-file read error.\n");

		ledcode = ~0x7950d04f;					// ファイルリードエラー Err.3 
		goto BOOT_FAILED;
	}


	/* elfファイル実行 */

	dgb_printf("Entry address : 0x%08x\n",entry_addr);
	dgb_printf("elf file execute.\n\n");

	SET_7SEGLED(~0x501c5400);					// run表示 

	pProc = (void (*)())entry_addr;

	alt_dcache_flush_all();
	alt_icache_flush_all();
	(*pProc)();


	/* ブート失敗 */

  BOOT_FAILED:
	while(1) {
		SET_7SEGLED(~0);						// エラーコードを点滅表示 
		ELFLOADER_LED_OFF();
		mmc_spi_SetTimer(200);
		while( mmc_spi_CheckTimer() ) {}

		SET_7SEGLED(ledcode);
		ELFLOADER_LED_ON();
		mmc_spi_SetTimer(300);
		while( mmc_spi_CheckTimer() ) {}
	}

	return 0;
}


