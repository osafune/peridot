/**************************************************************************
	MMC/SDカードSPIアクセスペリフェラル
		デバイスサポート関数 (Cineraria DE0 version)

	UPDATE	2010/12/11
			2011/12/24 100us待ち追加(Petit FatFs対応) 
			2011/12/28 1stリリース版 
 **************************************************************************/

#include <system.h>
#include <io.h>
#include "mmc_spi.h"

static alt_u32 mmc_spi_reg;		// MMC_SPIペリフェラルレジスタアドレス 
static alt_u32 mmc_spi_ncs;		// nCSコントロール 


/* MMC CSアサート */
void mmc_spi_SetCardSelect(void)
{
	mmc_spi_ncs = mmc_selassert;
	IOWR(mmc_spi_reg, mmcreg_status, (mmc_commexit | mmc_spi_ncs | 0xff));
}


/* MMC CSネゲート */
void mmc_spi_SetCardDeselect(void)
{
	mmc_spi_ncs = mmc_selnegete;
	IOWR(mmc_spi_reg, mmcreg_status, (mmc_commexit | mmc_spi_ncs | 0xff));
}


/* MMCへ1バイト送信 */
void mmc_spi_Sendbyte(alt_u8 data)
{
	while( !(IORD(mmc_spi_reg, mmcreg_status) & mmc_commexit) ) {}
	IOWR(mmc_spi_reg, mmcreg_status, (mmc_commstart | mmc_spi_ncs | data));
}


/* MMCから1バイト受信 */
alt_u8 mmc_spi_Recvbyte(void)
{
	alt_u32 res;

	while( !(IORD(mmc_spi_reg, mmcreg_status) & mmc_commexit) ) {}
	IOWR(mmc_spi_reg, mmcreg_status, (mmc_commstart | mmc_spi_ncs | 0xff));

	do {
		res = IORD(mmc_spi_reg, mmcreg_status);
	} while( !(res & mmc_commexit) );

	return (alt_u8)(res & 0xff);
}


/* MMCから指定バイト受信(2～512バイト) */
#ifdef _USE_MMCDMA
int mmc_spi_DmaRecv(alt_u8 wc, alt_u8 *buff)
{
	alt_u32 cycle,*pdst32,data32;
	int dnum;

	if (wc != 0) {
		cycle = wc << 1;
	} else {
		cycle = 256 << 1;
	}

	while( !(IORD(mmc_spi_reg, mmcreg_status) & mmc_commexit) ) {}
    mmc_spi_SetTimer(100);
	IOWR(mmc_spi_reg, mmcreg_dmastatus, (mmc_dmastart |(cycle - 1)));

	while( !(IORD(mmc_spi_reg, mmcreg_dmastatus) & mmc_dmadone_bitmask) ) {}

	if ( (IORD(mmc_spi_reg, mmcreg_dmastatus) & (mmc_dmade_bitmask|mmc_dmato_bitmask))!= 0 ) {
		return 1;
	}


	dnum = 0;

	if ( ((alt_u32)buff & 3) == 0) {		// ４バイトアラインの転送 
		pdst32 = (alt_u32 *)buff;

		while(cycle > 3) {
			*pdst32 = IORD(mmc_spi_reg, mmcreg_readbuff+dnum);
			pdst32++;
			dnum++;
			cycle-=4;
			buff+=4;
		}
	}

	while(cycle > 0) {						// 残りあるいは非アラインの場合の転送 
		if ( (cycle & 3)== 0 ) {
			data32 = IORD(mmc_spi_reg, mmcreg_readbuff+dnum);
			dnum++;
		}

		*buff++ = (alt_u8)(data32 & 0xff);
		data32 >>= 8;
		cycle--;
	}

	return 0;
}
#endif


/* カード挿入状態検出 */
/* ※カード挿入状態を検出できないハードウェアの場合は、常時 return 1 とする */
int mmc_spi_CheckCardDetect(void)
{
	if ( !(IORD(mmc_spi_reg, mmcreg_status) & mmc_cd_bitmask) ) {
		return 1;	/* カード挿入状態 */
	} else {
		return 0;	/* カードなし */
	}
}


/* カードライトプロテクトスイッチ状態検出 */
/* ※カード挿入状態を検出できないハードウェアの場合は、常時 return 0 とする */
int mmc_spi_CheckWritePortect(void)
{
	if( mmc_spi_CheckCardDetect() && !(IORD(mmc_spi_reg, mmcreg_status) & mmc_wp_bitmask) ) {
		return 0;	/* 書き込み可 */
	} else {
		return 1;	/* カードが入ってないか、ライトプロテクトスイッチがON */
	}
}


/* MMC SPIクロックをＰＰ（カード認証モード）に設定 */
void mmc_spi_SetIdentClock(void)
{
	IOWR(mmc_spi_reg, mmcreg_clkdiv, (mmc_clock_freq /(mmc_ppmode_freq * 2)));	/* 400kHzにする */
}


/* MMC SPIクロックをＤＤ（データ転送モード）に設定 */
void mmc_spi_SetTransClock(void)
{
	IOWR(mmc_spi_reg, mmcreg_clkdiv, (mmc_clock_freq /(mmc_ddmode_freq * 2)));	/* 最大速度は20MHz */
}


/* タイムアウトタイマ設定（1ms単位）*/
void mmc_spi_SetTimer(const alt_u32 timeout)
{
	IOWR(mmc_spi_reg, mmcreg_timer, mmc_timecount_1ms * timeout);
}


/* タイムアウトチェック */
int mmc_spi_CheckTimer(void)
{
	if( IORD(mmc_spi_reg, mmcreg_timer) ) {
		return 1;		/* タイマ動作中 */
	} else {
		return 0;		/* タイムアウト */
	}
}


/* 100usタイマ */
void mmc_spi_Wait100us(void)
{
	IOWR(mmc_spi_reg, mmcreg_timer, mmc_timecount_100us);

	while( IORD(mmc_spi_reg, mmcreg_timer) ) {}
}


/* MMCソケットインターフェース初期化 */
void mmc_spi_InitSocket(void)
{
	mmc_spi_reg = (alt_u32)MMC_REGBASE;
	while( !(IORD(mmc_spi_reg, mmcreg_status) & mmc_commexit) ) {}

	mmc_spi_SetCardDeselect();
	mmc_spi_SetIdentClock();
}



/**************************************************************************/
