/**************************************************************************
	PROCYON コンソールライブラリ「nd_Lib」 (Cineraria LCD Edition)

		ＡＣＭコーデックデコードエンジン

 **************************************************************************/
#ifndef __nd_acm_lib_
#define __nd_acm_lib_

#include <stdio.h>
#include <system.h>
#include "nd_egl.h"
#include "../mmcfs/fatfs/ff.h"


/***** 定数・マクロ定義 ***************************************************/

#define nd_acm_mcudecode	nd_acm_mcudecode_asm
//#define nd_acm_mcudecode	nd_acm_mcudecode_c


/***** 構造体定義 *********************************************************/



/***** プロトタイプ宣言 ***************************************************/

//extern const unsigned char imas_l4u_b_acm[];

extern nd_s32 nd_GsCkPlay(FIL *, void *);

extern void nd_GsAcmDecode(nd_u16 *,nd_s32,nd_s32,nd_u16 *);

extern nd_s32 nd_acm_mcudecode_asm(nd_u16 *, nd_u16 *, nd_u16 *);
extern nd_s32 nd_acm_mcudecode_c(nd_u16 *, nd_u16 *, nd_u16 *);


#endif
/**************************************************************************/
