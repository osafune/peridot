/**************************************************************************
	MMC/SDカードSPIアクセスペリフェラル
		ファイルサブシステム・デバイスドライバ関数 (NiosII HAL version)
		タイムスタンプ取得 

		UPDATE 2011/12/28
 **************************************************************************/

#include <stdio.h>
#include <time.h>

#include "gettime.h"


/* RTC未実装のため時間はハードコード */

DWORD get_fattime (void)
{
	return
		 ( (2011UL - 1980) << 25 )	// Year = 2011
		|( 2UL << 21 )				// Month = Feb
		|( 25UL << 16 )				// Day = 25
		|( 0U << 11 )				// Hour = 0
		|( 0U << 5 )				// Min = 0
		|( 0U >> 1 )				// Sec = 0
		;
}

#if 0
DWORD get_fattime (void)
{
	time_t sec;
	struct tm *t_st;
	DWORD res;

	time(&sec);
	t_st = localtime(&sec);

	res = 
		 ( ((t_st->tm_year + 1900) - 1980) << 25 )	// 年フィールド 
		|( (t_st->tm_mon + 1) << 21 )				// 月フィールド 
		|( t_st->tm_mday << 16 )					// 日フィールド 
		|( t_st->tm_hour << 11 )					// 時フィールド 
		|( t_st->tm_min << 5 )						// 分フィールド 
		|( t_st->tm_sec >> 1 )						// 秒フィールド 
		;

	return res;
}
#endif


