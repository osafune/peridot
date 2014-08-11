/**************************************************************************
	PROCYON コンソールライブラリ「nd_Lib」 (PERIDOT LCD Edition)

		ＡＣＭコーデックデコードエンジン

	2014/05/13	PERIDOT LCDユニット用修正

 **************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <system.h>
#include <sys/alt_cache.h>
#include <sys/alt_alarm.h>
#include <io.h>
#include "nd_egl.h"
#include "nd_acm.h"



/***** 定数・マクロ定義 ***************************************************/

#define nd_malloc		alt_uncached_malloc
#define nd_free			alt_uncached_free
//#define nd_malloc		malloc
//#define nd_free			free


/***** 構造体定義 *********************************************************/


/***** プロトタイプ宣言 ***************************************************/



/**************************************************************************
	ＣＫストリームを再生 （※暫定実装）
 **************************************************************************/
/*
  形式 
	nd_s32 nd_GsCkPlay(FIL *fckh, void *pVram_top)

  機能
	CK動画ファイルを再生
*/
#ifdef __ALTERA_AVALON_ONCHIP_MEMORY2
static nd_u32 ckbuff[512/4] __attribute__ ((section (".onchip_memory.rwdata")));
#else
static nd_u32 ckbuff[512/4];
#endif


// フレーム計測用コールバックタイマ 
static volatile int g_framebusy;
static alt_alarm g_framewait;
alt_u32 framewait_callback(void *context)
{
	g_framebusy = 0;
	return 0;
}

int framewait_start(alt_u32 nticks)
{
	g_framebusy = 1;

	if (alt_alarm_start(&g_framewait, nticks, framewait_callback, NULL) < 0) {
		printf("[!]No system clock available\n");
		g_framebusy = 0;
		return -1;
 	}

	return 0;
}


// 再生関数本体 
nd_s32 nd_GsCkPlay(
		FIL *fckh, void *pVram_top)
{
	nd_s32 x,y,n,s_mcu,pg,playerr;
	nd_s32 mcu_num,x_size,y_size,frame_num,acm_fps,start_x,start_y;
	nd_u16 *pBuff,*pVdrw,*pVref;
	nd_u32 VBoffs[2],*pVB_top;

	FRESULT res;
	UINT readsize;
	alt_u32 fps_ticks;


	res = f_lseek(fckh, 0);						// ファイル先頭へシーク 
	if (res != FR_OK) return (-1);

	pBuff = (nd_u16 *)&ckbuff[0];

	f_read(fckh, pBuff, 512, &readsize);		// ヘッダフィル 
	if (*pBuff != 0x4b43) return (-1);			// 'C''K'のヘッダでない 

	x_size    = *(pBuff + 2);
	y_size    = *(pBuff + 3);
	mcu_num   = *(pBuff + 4);
	acm_fps   = (60 * 256) / *(pBuff + 5);
	frame_num = *(pBuff + 6);					// frameの下位16bitのみ(手抜き) 

	start_x   = (window_xsize - x_size) / 2;
	start_y   = (window_ysize - y_size) / 2;

	printf("\n");
	printf("size : %d x %d (%d MCUs)\nframe: %d\nfps  : %d\n",
				x_size,y_size,mcu_num,
				frame_num,
				60/acm_fps);

	if (pVram_top == na_null) {
		pVB_top = (nd_u32 *)nd_malloc(na_VRAM_size *2);	// ２面分のフレームバッファを確保 
		if (pVB_top == na_null) return (-3);			// メモリが確保できない 
	} else {
		pVB_top = (nd_u32 *)pVram_top;
	}

	VBoffs[0] = (nd_u32)pVB_top;				// ダブルバッファを設定 
//	VBoffs[1] = VBoffs[0] + na_VRAM_size;
	VBoffs[1] = VBoffs[0] + na_VRAM_linesize/2;

	if (pVram_top == na_null) {
		nd_GsEglColor(nd_COLORBLACK, 0, 256);		// バッファの初期化 
		nd_GsEglDrawBuffer = VBoffs[0];
		nd_GsEglBoxfill(0, 0, window_xmax, window_ymax);
		nd_GsEglDrawBuffer = VBoffs[1];
		nd_GsEglBoxfill(0, 0, window_xmax, window_ymax);
	}

	nd_GsEglPage(VBoffs[1], VBoffs[0], 0);
	playerr = 0;
	pg = 0;

	fps_ticks = acm_fps * alt_ticks_per_second() / 60;

	while(frame_num > 0) {
		framewait_start(fps_ticks);

		n = 0;
		x = start_x;
		y = start_y;
		pVdrw = (nd_u16 *)(VBoffs[pg  ] + (y << na_VRAM_linewidth) + (x << 1));
		pVref = (nd_u16 *)(VBoffs[1-pg] + (y << na_VRAM_linewidth) + (x << 1));

		while(n < mcu_num) {
			// ストライプバッファフィル 
			pBuff = (nd_u16 *)&ckbuff[0];

			res = f_read(fckh, pBuff, 512, &readsize);
			if (res != FR_OK || readsize < 512) {		// 再生中にリードエラー 
				frame_num = 0;
				playerr   = -2;
				break;
			}

			s_mcu = *pBuff++;
			n += s_mcu;

			// ストライプのデコード 
			for( ; s_mcu > 0 ; s_mcu--) {
				pBuff += nd_acm_mcudecode(pBuff, pVdrw, pVref);

				pVdrw += 8;
				pVref += 8;
				x += 8;
				if (x >= (x_size + start_x)) {			// ラインの折り返し 
					x = start_x;
					y += 8;
					pVdrw = (nd_u16 *)(VBoffs[pg  ] + (y << na_VRAM_linewidth) + (x << 1));
					pVref = (nd_u16 *)(VBoffs[1-pg] + (y << na_VRAM_linewidth) + (x << 1));
				}
			}
		}

		frame_num--;

		while( g_framebusy ) {}							// 規定のフレーム時間待つ 
		nd_GsEglPage(VBoffs[pg], VBoffs[1-pg], 0);
		pg = 1 - pg;
	}


	if (pVram_top == na_null) nd_free(pVB_top);

	return playerr;
}



/**************************************************************************
	ＡＣＭ圧縮画像を展開 （※暫定実装）
 **************************************************************************/
/*
  形式 
	void nd_GsAcmDecode(nd_u16 *pAcm, nd_s32 x, nd_s32 y)

  機能
	VRAMの(x,y)にACM圧縮画像を展開する
*/
void nd_GsAcmDecode(
		nd_u16 *pAcm,
		nd_s32 x, nd_s32 y,
		nd_u16 *pBase)
{
	nd_s32 mcu_num,x_size,y_size;
	nd_s32 i,j;
	nd_u16 *pVram;

	if (*pAcm++ != 0x4b43) return;	// 'C''K'のヘッダでない

	mcu_num = *pAcm++;
	x_size  = *pAcm++;
	y_size  = *pAcm++;

	pAcm += 4;		// 暫定実装ヘッダを読み飛ばす 

	if (x_size > window_xsize) x_size = window_xsize;
	if (y_size > window_ysize) y_size = window_ysize;

	for(j=0 ; j<y_size ; j+=8) {
		pVram = (nd_u16 *)((nd_u32)pBase + (j << na_VRAM_linewidth));

		for(i=0 ; i<x_size ; i+=8) {
			pAcm  += nd_acm_mcudecode(pAcm, pVram, pVram);
			pVram += 8;
		}
	}
}



/**************************************************************************
	ＭＣＵから８ｘ８のピクセルデータを復元(サブ関数群)
 **************************************************************************/
/*
 ●ＤＣＢフォーマット

 ・MCU skipcode
	+---------------+---------------+
	|      0xff     |      0xff     |
	+---------------+---------------+

	DCB1(U成分)のみ使用可能。U成分のDCBにこのコードが設定されていた場合、
	MCUはこのコードのみで終了し画像データはフレーム参照先から転送する。


 ・0bit encoding
	+---------------+---------------+
	|       p       |        0      |
	+---------------+---------------+


 ・1bit encoding
	+---------------+-------------+-+
	|       p       |      n      |0|
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c0               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

	n =	0x01 ～ 0x3f : s =  +2 ～  +64 (n+1)
		0x40 ～ 0x5f :     +66 ～ +128 (n*2+66)
		0x60 ～ 0x7f :    +131 ～ +255 (n*4+131)


 ・2bit encoding
	+---------------+---------+---+-+
	|       p       |    n    | r |1|
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c0               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c1               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

	n =	0x00 ～ 0x0f : s =  +1 ～ +16 (n+1)
		0x10 ～ 0x17 :     +18 ～ +32 (n*2+18)
		0x18 ～ 0x1f :     +35 ～ +63 (n*4+35)

	r = 00 : ノーマルDCB / リニアステッピング 
			p0 <s> p1 <s> p2 <s> p3

		01 : ノーマルDCB / ノンリニアステッピング 
			p0 <s> p1 <s*3> p2 <s> p3

		10 : 縮小Y成分DCB / リニアステッピング 
			 DCB3でのみ有効、それ以外は無視される

		11 : 3bit encoding指定 / リニアステッピング 


 ・3bit encoding
	+---------------+---------+---+-+
	|       p       |    n    |1 1|1|
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c0               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c1               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	|              c2               |
	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

	n = 0x00 ～ 0x1f : s = +1 ～ +32 (n+1)

		リニアステッピング
			p0 <s> p1 <s> p2 <s> p3 <s> p4 <s> p5 <s> p6 <s> p7


 ・raw data
	+---------------+---------------+
	|      0xfe     |      0xff     |
	+---------------+---------------+
	|     data 1    |     data 0    |
	+---------------+---------------+
	|     data 3    |     data 2    |
	+---------------+---------------+
	|               :               |
	|               :               |
	+---------------+---------------+
	|     data 15   |     data 14   |
	+---------------+---------------+

*/
static nd_s32 dcb_decode (
		nd_u16 *pDCB,			// ＤＣＢ先頭ポインタ (引数) 
		nd_u8 *pQ,				// 展開先ポインタ (引数) 
		int bstep)				// 展開先のバイト増分値 
{
	nd_s32 i,s,a[8];
	nd_s32 mode,p,c0,c1,c2;


	mode = *pDCB++;
	p    = mode >> 8;				// 基準点 

	if (mode == 0xfeff) {

	// raw dataの展開 
		for(i=0 ; i<8 ; i++) {
			*pQ = *pDCB & 0xff;
			pQ += bstep;
			*pQ = (*pDCB >> 8) & 0xff;
			pQ += bstep;
			pDCB++;
		}
		return(9);

	} else if ((mode & 0xff)== 0) {

	// 0bit encodingの展開 
		for(i=0 ; i<16 ; i++) {
			*pQ = p;
			pQ += bstep;
		}
		return (1);

	} else {

		c0 = *pDCB++;
		if (mode & 0x01) {
			c1 = *pDCB++;
			if ((mode & 0x06)== 0x06) {
				c2 = *pDCB;

	// 3bit encodingの展開 
				s = ((mode & 0xf8) >> 3) + 1;	// 参照テーブルの作成 

				for(i=0 ; i<8 ; i++) {
					if (p > 255) p = 255;
					a[i] = p;
					p += s;
				}

				for(i=0 ; i<16 ; i++) {			// 3bit-CODEの展開 
					s = 0;
					if(c0 & 1) s |= (1<<0);
					if(c1 & 1) s |= (1<<1);
					if(c2 & 1) s |= (1<<2);
					c0 >>= 1;
					c1 >>= 1;
					c2 >>= 1;

					*pQ = a[s];
					pQ += bstep;
				}
				return (4);

			} else {

	// 2bit encodingの展開 
				if (mode & 0x80) {				// 参照テーブルの作成 
					if (mode & 0x40) {
						s = ((mode & 0x38) >> 1) + 35;
					} else {
						s = ((mode & 0x38) >> 2) + 18;
					}
				} else {
					s = ((mode & 0x78) >> 3) + 1;
				}

				for(i=0 ; i<4 ; i++) {			// ノンリニアステッピング 
					if (p > 255) p = 255;
					a[i] = p;
					p += s;
					if ((mode & 0x02)&& i==1) p += (s << 1); // ノンリニアステッピング 
				}

				for(i=0 ; i<16 ; i++) {			// 2bit-CODEの展開 
					s = 0;
					if(c0 & 1) s |= (1<<0);
					if(c1 & 1) s |= (1<<1);
					c0 >>= 1;
					c1 >>= 1;

					*pQ = a[s];
					pQ += bstep;
				}
				return (3);
			}
		} else {

	// 1bit encodingの展開 
			if (mode & 0x80) {					// 参照テーブルの作成 
				if (mode & 0x40) {
					s = ((mode & 0x3e) << 1) + 131;
				} else {
					s =  (mode & 0x3e) + 66;
				}
			} else {
				s = ((mode & 0x7e) >> 1) + 1;
			}

			s += p;
			if (s > 255) s = 255;

			for(i=0 ; i<16 ; i++) {				// 1bit-CODEの展開 
				if(c0 & 1) {
					*pQ = s;
				} else { 
					*pQ = p;
				}

				c0 >>= 1;
				pQ += bstep;
			}
			return (2);
		}
	}

	return (0);
}


/*
● デコードアクセラレータ命令

  YUV→RGBの変換式は下記の通り
  DCBをデコードする時は、UとVには-128のオフセットをつける

	Y =    0～255
	U = -128～127
	V = -128～127

	R = 1.000Y          + 1.402V
	G = 1.000Y - 0.344U - 0.714V
	B = 1.000Y + 1.772U

*/
#ifdef __YUV_DECODE
#define yuv422_decode(_a,_b)	ALT_CI_YUV_DECODE_INST(0,(_a),(_b))
#else
#ifdef __PIXELSIMD
#define yuv422_decode(_a,_b)	ALT_CI_PIXELSIMD(0,(_a),(_b))
#endif
#endif

#ifndef yuv422_decode
// 命令が未実装の場合のエミュレーション 
static nd_u32 yuv422_decode(nd_u32 ra, nd_u32 rb)
{
	int y0,y1,u,v,by,gy,ry,r,g,b;
	int rc;

	y0 = (ra & 0xff) << 8;
	y1 = ra & 0xff00;
	u  = (rb & 0xff) - 128;
	v  = ((rb >> 8) & 0xff) - 128;

	ry = 359 * v;
	gy = -88 * u - 183 * v;
	by = 454 * u;

	r = (y1 + ry) >> 8;
	g = (y1 + gy) >> 8;
	b = (y1 + by) >> 8;
	if (r < 0) r = 0; else if (r > 255) r = 255;
	if (g < 0) g = 0; else if (g > 255) g = 255;
	if (b < 0) b = 0; else if (b > 255) b = 255;

	rc = set_pixel(r,g,b);
	rc <<= 16;

	r = (y0 + ry) >> 8;
	g = (y0 + gy) >> 8;
	b = (y0 + by) >> 8;
	if (r < 0) r = 0; else if (r > 255) r = 255;
	if (g < 0) g = 0; else if (g > 255) g = 255;
	if (b < 0) b = 0; else if (b > 255) b = 255;

	rc |= set_pixel(r,g,b);

	return rc;
}
#endif


/*
 ●ＭＣＵフォーマット

  １個のＭＣＵで８ｘ８ピクセルのRGB888データを表現する
  データはYUV420または1/4縮小のYUV444形式で格納される


 ・ＭＣＵスキップ

	+---------------+
	|    0xffff     |  -- DCB1がスキップコードの場合はＭＣＵ展開なし
	+---------------+

    このコードがMCU先頭(DCB1)にあった場合は、参照フレームの該当画素データを
	そのまま使用する。


 ・縮小ＭＣＵ

  1/4サイズのRGB888データをYUV444に変換し、16個のデータごとに３個のDCBに格納する
  DCB3のヘッダが2bit reduced encodingの場合のみ有効

	+---------------+
	|   DCB1 (U)    |   --+ 8x8ピクセルを1/4縮小したYUV444が入っている 
	+---------------+     |
	|   DCB2 (V)    |     |      +----+  +----+  +----+
	+---------------+     |      | Yr |  | U  |  | V  |
	|   DCB3 (Yr)   |   --+      +----+  +----+  +----+
	+---------------+

    DCB3が縮小Ｙ成分コードの場合（2bit reduced encodingの場合）
	DCB3を縦横２倍に引き延ばして8x8ピクセルを復元する。
	復元時に補間をかけることが望ましいが、処理能力が足りない場合は単純拡大でもよい。


 ・ノーマルＭＣＵ

  RGB888データはYUV420間引きを行い、16個のデータごとに６個のDCBに格納する

	+---------------+
	|   DCB1 (U)    |   --+
	+---------------+     |
	|   DCB2 (V)    |     | 8x8ピクセルをYUV420間引きしたものが入っている 
	+---------------+     |
	|   DCB3 (Y0)   |     |      +----+----+  +----+  +----+
	+---------------+     |      | Y0 | Y1 |  | U  |  | V  |
	|   DCB4 (Y1)   |     |      +----+----+  +----+  +----+
	+---------------+     |      | Y2 | Y3 |
	|   DCB5 (Y2)   |     |      +----+----+
	+---------------+     |
	|   DCB6 (Y3)   |   --+
	+---------------+


 ・ＲＧＢの展開データはeglのset_pixelマクロで行う

*/
#define linepixewidth	(1<<(na_VRAM_linewidth-1))

nd_s32 nd_acm_mcudecode_c (			// MCUのワードサイズを返す 
		nd_u16 *pMCU,				// MCUデータポインタ 
		nd_u16 *pVRAM,				// 展開先の先頭ポインタ 
		nd_u16 *pREF)				// フレーム参照先の先頭ポインタ 
{
	nd_s32 i,n,y;
	nd_u8  ty[16],*ptvu;
	nd_s32 tvu[16];
	nd_s32 c,mcu_n;
	nd_u32 dpix,*pPix,*pSrc;
	nd_u16 *pY;

	const nd_s32 uv_index[4][4] = {
			{ 0, 0, 4, 4},		// MCU0
			{ 2, 2, 6, 6},		// MCU1
			{ 8, 8,12,12},		// MCU2
			{10,10,14,14} };	// MCU3

	const nd_s32 vram_offset[4] = {
			(0*linepixewidth+0)*2, (0*linepixewidth+4)*2,
			(4*linepixewidth+0)*2, (4*linepixewidth+4)*2 };


	// MCUスキップの処理 
	if (*pMCU == 0xffff) {
		pPix = (nd_u32 *)pVRAM;
		pSrc = (nd_u32 *)pREF;
		for(y=0 ; y<8 ; y++) {
			*(pPix + 0) = *(pSrc + 0);
			*(pPix + 1) = *(pSrc + 1);
			*(pPix + 2) = *(pSrc + 2);
			*(pPix + 3) = *(pSrc + 3);
			pPix += (linepixewidth*2/4);
			pSrc += (linepixewidth*2/4);
		}

		return (1);
	}


	// U成分とV成分の展開 
	ptvu = (nd_u8 *)&tvu;

	c = dcb_decode(pMCU, ptvu, 4);		// U成分 
	pMCU  += c;
	mcu_n  = c;

	c = dcb_decode(pMCU, ptvu+1, 4);	// V成分 
	pMCU  += c;
	mcu_n += c;


	// Y成分の展開とRGB変換 
	if ( (*pMCU & 0x07)== 0x05) {		// 縮小Ｙ成分 
		c = dcb_decode(pMCU, ty, 1);

		if (c != 3) {
			printf("[!] dcb data error!\n");
			printf("mode : 0x%04x\n",*(pMCU+0));
			printf("c0   : 0x%04x\n",*(pMCU+1));
			printf("c1   : 0x%04x\n",*(pMCU+2));

			while(1) {}
		}

		pMCU  += c;
		mcu_n += c;

		pPix = (nd_u32 *)pVRAM;

		for(y=0 ; y<4 ; y++) {			// YUV444をRGBに変換 
			dpix = yuv422_decode( (ty[y*4+0]<<8) | ty[y*4+0], tvu[y*4+0]);
			*(pPix + 0        ) = dpix;
			*(pPix + 0 + linepixewidth/2) = dpix;

			dpix = yuv422_decode( (ty[y*4+1]<<8) | ty[y*4+1], tvu[y*4+1]);
			*(pPix + 1        ) = dpix;
			*(pPix + 1 + linepixewidth/2) = dpix;

			dpix = yuv422_decode( (ty[y*4+2]<<8) | ty[y*4+2], tvu[y*4+2]);
			*(pPix + 2        ) = dpix;
			*(pPix + 2 + linepixewidth/2) = dpix;

			dpix = yuv422_decode( (ty[y*4+3]<<8) | ty[y*4+3], tvu[y*4+3]);
			*(pPix + 3        ) = dpix;
			*(pPix + 3 + linepixewidth/2) = dpix;

			pPix += (2*linepixewidth)/2;
		}

	} else {
		for(n=0 ; n<4 ; n++) {
			c = dcb_decode(pMCU, ty, 1);
			pMCU  += c;
			mcu_n += c;

			pPix = (nd_u32 *)( (nd_u32)pVRAM + vram_offset[n] );
			pY   = (nd_u16 *)&ty[0];

			for(y=0 ; y<4 ; y++) {		// YUV420をRGBに変換 
				i = uv_index[n][y];
				*(pPix + 0) = yuv422_decode(*pY++, tvu[i]);

				i++;
				*(pPix + 1) = yuv422_decode(*pY++, tvu[i]);

				pPix += linepixewidth/2;
			}
		}
	}

	return (mcu_n);
}



/**************************************************************************/
