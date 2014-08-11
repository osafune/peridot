/**************************************************************************
	MMC/SDカードSPIアクセスペリフェラル
		デバイスサポート関数 (Cineraria DE0 version)

	UPDATE	2010/12/11
			2011/12/24 100us待ち追加(Petit FatFs対応) 
			2011/12/28 1stリリース版 
 **************************************************************************/
#ifndef __mmc_spi_h_
#define __mmc_spi_h_

#include <system.h>
#include <alt_types.h>


// MMC_SPIペリフェラル駆動クロック(ユーザー定義) 
//#define mmc_clock_freq          (40000000)


/***** 定数・マクロ定義 ***************************************************/

#ifdef MMCDMA_BASE
 #define _USE_MMCDMA
 #define MMC_REGBASE		MMCDMA_BASE
#else
 #define MMC_REGBASE		MMC_SPI_BASE
#endif

#define mmcreg_status			(0)
#define mmcreg_clkdiv			(1)
#define mmcreg_timer			(2)

#define mmc_irq_enable			(1<<15)
#define mmc_zf_bitmask			(1<<12)
#define mmc_wp_bitmask			(1<<11)
#define mmc_cd_bitmask			(1<<10)
#define mmc_commstart			(0<<9)
#define mmc_commexit			(1<<9)
#define mmc_selassert			(0<<8)
#define mmc_selnegete			(1<<8)

#ifdef _USE_MMCDMA
#define mmcreg_dmastatus		(4)
#define mmcreg_readbuff			(128)
#define mmc_dmairq_enable		(1<<15)
#define mmc_dmadone_bitmask		(1<<14)
#define mmc_dmade_bitmask		(1<<13)
#define mmc_dmato_bitmask		(1<<12)
#define mmc_dmastart			(1<<10)
#endif

#ifndef mmc_clock_freq
#define mmc_clock_freq			ALT_CPU_FREQ
#endif
#define mmc_timecount_1ms		(mmc_clock_freq / 1000)
#define mmc_timecount_100us		(mmc_clock_freq / 10000)
#define mmc_ppmode_freq			(400 * 1000)		// PPmode = 400kHz 
#define mmc_ddmode_freq			(20 * 1000 * 1000)	// DDmode = 20MHz 


/***** 構造体定義 *********************************************************/



/***** プロトタイプ宣言 ***************************************************/

/* MMCソケットインターフェース初期化 */
void mmc_spi_InitSocket(void);

/* MMC SPIクロック設定 */
void mmc_spi_SetIdentClock(void);
void mmc_spi_SetTransClock(void);

/* MMC タイムアウトカウンタ設定 */
void mmc_spi_Wait100us(void);
void mmc_spi_SetTimer(const alt_u32);
int mmc_spi_CheckTimer(void);

/* カード挿入状態検出 */
int mmc_spi_CheckCardDetect(void);

/* カードライトプロテクトスイッチ状態検出 */
int mmc_spi_CheckWritePortect(void);

/* MMC CS制御 */
void mmc_spi_SetCardSelect(void);
void mmc_spi_SetCardDeselect(void);

/* MMCへ1バイト送信 */
void mmc_spi_Sendbyte(alt_u8);

/* MMCから1バイト受信 */
alt_u8 mmc_spi_Recvbyte(void);

/* MMCから指定バイト受信(2～512バイト) */
#ifdef _USE_MMCDMA
int mmc_spi_DmaRecv(alt_u8, alt_u8 *);
#endif


#endif
/**************************************************************************/
