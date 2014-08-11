#=================================================
#  ACMデコード関数
#     Cineraria PIXELSIMD custom instruction ver.
#
#  2009/01/30 : mikiコア用作成(TOURMALINE)
#  2009/07/23 : kotoriコア用修正(GREENBERYL)
#  2010/12/17 : cinerariaコア用修正(DE0)
#  2014/04/28 : NiosII SBT 13.1対応修正
#=================================================

#====================================
#  コンフィグレーション
#====================================

	.equ ALT_CI_PIXELSIMD_N,			0	# PIXELSIMDカスタム命令がある場合に命令コードを設定する 

#	.equ ALT_CI_YUV_DECODE_INST_N,		0	# YUV_DECODEカスタム命令がある場合に命令コードを設定する 

#	.equ ALT_CI_CUSTOM_SATSAL_INST_N,	0	# CUSTOM_SATSALカスタム命令がある場合に命令コードを設定する 

#	.equ ALT_AVALON_ONCHIP_MEMORY,		0	# 作業変数をonchip_memoryセクションにマッピングする場合に設定する 

#	.equ SUBPIXEL_ALIGN_BGR,			0	# VRAMの色並びがBGRの場合に設定する(デフォルトはRGB)

#	.equ VRAM_LINE_PIXEL_LENGTH,		512	# VRAMの１ラインのピクセル数を設定する(デフォルトは1024)



#====================================
#  カスタム命令設定
#====================================

	.ifdef ALT_CI_PIXELSIMD_N
	.equ YUV_DECODE_INSTRUCTION_N,		(ALT_CI_PIXELSIMD_N + 0)
	.equ SUADD_INSTRUCTION_N,			(ALT_CI_PIXELSIMD_N + 6)
	.endif

	.ifdef ALT_CI_YUV_DECODE_INST_N
	.equ YUV_DECODE_INSTRUCTION_N,		(ALT_CI_YUV_DECODE_INST_N + 0)
	.equ SUADD_INSTRUCTION_N,			(ALT_CI_YUV_DECODE_INST_N + 2)
	.equ SLLOR_INSTRUCTION_N,			(ALT_CI_YUV_DECODE_INST_N + 3)
	.endif

	.ifdef ALT_CI_CUSTOM_SATSAL_INST_N
	.equ SATSAL_INSTRUCTION_N,			(ALT_CI_CUSTOM_SATSAL_INST_N + 0)
	.endif

	.ifndef YUV_DECODE_INSTRUCTION_N
	.equ DECODE_INSTRUCTION_EMULATE,	0
	.endif

	.ifndef ALT_AVALON_ONCHIP_MEMORY
	.equ WORKMEMORY_FOR_STACK,			0
	.endif



#====================================
#  変数
#====================================

	.ifndef VRAM_LINE_PIXEL_LENGTH
		linepixelsize = 1024		# フレームバッファのラインピクセル数 
	.else
		linepixelsize = VRAM_LINE_PIXEL_LENGTH
	.endif

	t_top		= (0)
	ta0			= (t_top + 0*1)
	ta1			= (t_top + 1*1)
	ta2			= (t_top + 2*1)
	ta3			= (t_top + 3*1)
	ta4			= (t_top + 4*1)
	ta5			= (t_top + 5*1)
	ta6			= (t_top + 6*1)
	ta7			= (t_top + 7*1)

	index_top	= (t_top     + (16))
	ty_top		= (index_top + (16*1))
	tvu_top		= (ty_top    + (16*1))

	val_size	= (tvu_top + (16*2))


	uvindex_0	= (  0*2 )			# 初期値データ(UVテーブルインデックス) 
	uvindex_1	= (  2*2 )
	uvindex_2	= (  8*2 )
	uvindex_3	= ( 10*2 )

	vramoffs_0	= ( (0*linepixelsize+0)*2 )	# 初期値データ(VRAMオフセット) 
	vramoffs_1	= ( (0*linepixelsize+4)*2 )
	vramoffs_2	= ( (4*linepixelsize+0)*2 )
	vramoffs_3	= ( (4*linepixelsize+4)*2 )


	.ifndef WORKMEMORY_FOR_STACK
		.section .onchip_memory
		.align 4
	 __nram_workmemory:
		.ds		val_size
	.endif



#====================================
#  マクロ宣言
#====================================

	.macro	YUV_DECODE 					# デコード命令ブランチ 
	.ifdef YUV_DECODE_INSTRUCTION_N
		custom	YUV_DECODE_INSTRUCTION_N, r2, r8, r9
	.else
		call _yuv_decode_emulation
	.endif
	.endm

	.macro	SUADD reg1, reg2, reg3		# 8bit飽和加算命令ブランチ 
	.ifdef SUADD_INSTRUCTION_N
		custom	SUADD_INSTRUCTION_N, \reg1, \reg1, \reg2
	.else
		add		\reg1, \reg1, \reg2
		ble		\reg1, \reg3, __suadd_macro_br_\@
		mov		\reg1, \reg3
	  __suadd_macro_br_\@:
	.endif
	.endm

	.macro	SLLOR reg1, reg2, reg3		# 式評価ビット連結命令ブランチ 
	.ifdef SLLOR_INSTRUCTION_N
		custom	SLLOR_INSTRUCTION_N, \reg1, \reg2, \reg3
	.else
		cmpne	\reg3, \reg3, zero
		slli	\reg1, \reg2, 1
		or		\reg1, \reg1, \reg3
	.endif
	.endm


	.macro	SATZ reg1, reg3				# 指定上限値とゼロで飽和してAND(符号付)
		ble		\reg1, \reg3, __satz_macro_le_\@
		mov		\reg1, \reg3
		br		__satz_macro_end_\@
	  __satz_macro_le_\@:
		bge		\reg1, zero, __satz_macro_ge_\@
		mov		\reg1, zero
	  __satz_macro_ge_\@:
		and		\reg1, \reg1, \reg3
	  __satz_macro_end_\@:
	.endm



#====================================
#  ＭＣＵデコード
#====================================

# r4 *pMCU		: MCUの先頭ポインタ 
# r5 *pVRAM		: 展開先のVRAMポインタ 
# r6 *pREF		: フレーム参照先のVRAMポインタ 
# r2			: MCUのワード数 

# r4			: DCBポインタ(引数兼用)
# r5			: 引数格納、およびアドレスポインタ汎用 
# r6			: フレーム参照アドレスポインタ 
# r8			: tmp
# r9			: tmp
# r10			: tmp
# r11			: tmp
# r12			: tmp
# r13			: tmp
# r14			: tmp
# r15			: tmp

# r20			: Yブロックカウンタ 
# r21			: pVRAMポインタ(r5コピー)
# r22			: 変数ポインタ(内部メモリ参照)

	.section .text

	.global	nd_acm_mcudecode_asm
	.func	nd_acm_mcudecode_asm

nd_acm_mcudecode_asm:
	addi	sp, sp, -28
	stw		ra, 0(sp)
	stw		r4, 4(sp)
	stw		r5, 8(sp)
	stw		r6, 12(sp)
	stw		r20, 16(sp)
	stw		r21, 20(sp)
	stw		r22, 24(sp)

	.ifdef WORKMEMORY_FOR_STACK
		addi	sp, sp, -val_size
		mov		r22, sp
	.else
		movhi	r22, %hi(__nram_workmemory)
		ori		r22, r22, %lo(__nram_workmemory)
	.endif
									# r22 = 変数領域ポインタ 

	ldhu	r2, 0(r4)				# MCUスキップコードのチェック 
	ori		r8, zero, 0xffff
	beq		r2, r8, __mcu_skip_block


	mov		r21, r5					# r21 = pVRAM_top

	movi	r6, 2					# r6 : 展開バイトアライメント 
	addi	r5, r22, tvu_top
	call _nd_acm_dcbdecode			# U成分のデコード 
	add		r4, r4, r2

	addi	r5, r22, tvu_top + 1
	call _nd_acm_dcbdecode			# V成分のデコード 
	add		r4, r4, r2


	ldbu	r2, 0(r4)				# 縮小Yブロックのチェック 
	movi	r8, 0x05
	andi	r2, r2, 0x07
	beq		r2, r8, __mcu_reduced_yblock

	movhi	r8, vramoffs_0			# indexテーブル初期化 
	ori		r8, r8, uvindex_0
	stw		r8, (index_top + 0)(r22)
	movhi	r8, vramoffs_1
	ori		r8, r8, uvindex_1
	stw		r8, (index_top + 4)(r22)
	movhi	r8, vramoffs_2
	ori		r8, r8, uvindex_2
	stw		r8, (index_top + 8)(r22)
	movhi	r8, vramoffs_3
	ori		r8, r8, uvindex_3
	stw		r8, (index_top + 12)(r22)


 __mcu_normal_yblock:				### Yブロックのデコード ###
	movi	r6, 1						# r6  : 展開バイトアライメント 
	mov		r20, zero					# r20 : ループカウンタ 

  __decode_y_loop:
	movi	r10, 16
	beq		r20, r10, __mcu_decode_exit

	addi	r5, r22, ty_top
	call _nd_acm_dcbdecode				# Y成分のデコード 
	add		r4, r4, r2

	add		r8, r20, r22
	ldhu	r11, (index_top + 0)(r8)	# UVインデックスオフセット 
	add		r11, r11, r22
	ldhu	r12, (index_top + 2)(r8)	# VRAMオフセット 
	add		r12, r12, r21

	ldhu	r8, (ty_top + 0)(r22)		#１ライン目 
	ldhu	r9, (tvu_top + 0*2)(r11)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+0)*2)(r12)
	ldhu	r8, (ty_top + 2)(r22)
	ldhu	r9, (tvu_top + 0*2+2)(r11)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+2)*2)(r12)

	ldhu	r8, (ty_top + 4)(r22)		#２ライン目 
	ldhu	r9, (tvu_top + 0*2)(r11)
	YUV_DECODE
	stw		r2, ((1*linepixelsize+0)*2)(r12)
	ldhu	r8, (ty_top + 6)(r22)
	ldhu	r9, (tvu_top + 0*2+2)(r11)
	YUV_DECODE
	stw		r2, ((1*linepixelsize+2)*2)(r12)

	ldhu	r8, (ty_top + 8)(r22)		#３ライン目 
	ldhu	r9, (tvu_top + 4*2)(r11)
	YUV_DECODE
	stw		r2, ((2*linepixelsize+0)*2)(r12)
	ldhu	r8, (ty_top + 10)(r22)
	ldhu	r9, (tvu_top + 4*2+2)(r11)
	YUV_DECODE
	stw		r2, ((2*linepixelsize+2)*2)(r12)

	ldhu	r8, (ty_top + 12)(r22)		#４ライン目 
	ldhu	r9, (tvu_top + 4*2)(r11)
	YUV_DECODE
	stw		r2, ((3*linepixelsize+0)*2)(r12)
	ldhu	r8, (ty_top + 14)(r22)
	ldhu	r9, (tvu_top + 4*2+2)(r11)
	YUV_DECODE
	stw		r2, ((3*linepixelsize+2)*2)(r12)

	addi	r20, r20, 4
	br		__decode_y_loop


 __mcu_reduced_yblock:				### 縮小Yブロックのデコード ###
	movi	r6, 1						# r6  : 展開バイトアライメント 
	addi	r5, r22, ty_top
	call _nd_acm_dcbdecode				# Y成分のデコード 
	add		r4, r4, r2

	mov		r11, r22
	addi	r12, r22, 16

  __decode_yr_loop:
	beq		r11, r12, __mcu_decode_exit

	ldbu	r2, (ty_top + 0)(r11)		#１ライン分の拡大処理 
	slli	r8, r2, 8
	or		r8, r8, r2
	ldhu	r9, (tvu_top + 0*2)(r22)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+0)*2)(r21)
	stw		r2, ((1*linepixelsize+0)*2)(r21)

	ldbu	r2, (ty_top + 1)(r11)
	slli	r8, r2, 8
	or		r8, r8, r2
	ldhu	r9, (tvu_top + 1*2)(r22)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+2)*2)(r21)
	stw		r2, ((1*linepixelsize+2)*2)(r21)

	ldbu	r2, (ty_top + 2)(r11)
	slli	r8, r2, 8
	or		r8, r8, r2
	ldhu	r9, (tvu_top + 2*2)(r22)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+4)*2)(r21)
	stw		r2, ((1*linepixelsize+4)*2)(r21)

	ldbu	r2, (ty_top + 3)(r11)
	slli	r8, r2, 8
	or		r8, r8, r2
	ldhu	r9, (tvu_top + 3*2)(r22)
	YUV_DECODE
	stw		r2, ((0*linepixelsize+6)*2)(r21)
	stw		r2, ((1*linepixelsize+6)*2)(r21)

	addi	r21, r21, ((2*linepixelsize+0)*2)
	addi	r11, r11, (4*1)
	addi	r22, r22, (4*2)
	br		__decode_yr_loop


 __mcu_skip_block:					### MCUスキップコードの処理 ###
	addi	r9, r5, ((8*linepixelsize+0)*2)

  __pixel_trans_loop:					# 1ライン(8ピクセル)をコピー 
	ldw		r15, (0*2)(r6)
	stw		r15, (0*2)(r5)
	ldw		r15, (2*2)(r6)
	stw		r15, (2*2)(r5)
	ldw		r15, (4*2)(r6)
	stw		r15, (4*2)(r5)
	ldw		r15, (6*2)(r6)
	stw		r15, (6*2)(r5)

	addi	r5, r5, ((1*linepixelsize+0)*2)
	addi	r6, r6, ((1*linepixelsize+0)*2)
	bne		r5, r9, __pixel_trans_loop

	addi	r4, r4, 2


 __mcu_decode_exit:

	.ifdef WORKMEMORY_FOR_STACK
		addi	sp, sp, val_size
	.endif
	mov		r2, r4

	ldw		ra, 0(sp)
	ldw		r4, 4(sp)
	ldw		r5, 8(sp)
	ldw		r6, 12(sp)
	ldw		r20, 16(sp)
	ldw		r21, 20(sp)
	ldw		r22, 24(sp)

	sub		r2, r2, r4
	srli	r2, r2, 1				# 返り値にmcu_nをセット
	addi	sp, sp, 28

	ret



#====================================
#  ＤＣＢデコード
#====================================

# r4  *pDCB		: DCBの先頭ポインタ 
# r5  *pQ		: 展開先ポインタ 
# r6			: 展開バイトアライメント数 
# r2			: DCBのデータバイト数 

# r22			: 変数領域の先頭ポインタ 

# r8			: tmp, s
# r9			: tmp, loop
# r10			: tmp, *pQ
# r11			: 未使用
# r12			: c2
# r13			: c1
# r14			: c0
# r15			: mode, p

	d_size_0bit	= (1*2)
	d_size_1bit	= (2*2)
	d_size_2bit	= (3*2)
	d_size_3bit	= (4*2)
	d_size_raw  = (9*2)


_nd_acm_dcbdecode:
	ldhu	r15, 0(r4)				# r15 = mode

	ori		r2, zero, 0xfeff
	beq		r15, r2, __raw_data

	andi	r2, r15, 0xff
	beq		r2, zero, __0bit_coding

	ldhu	r14, 2(r4)				# r14 = c0
	andi	r2, r15, 0x01
	beq		r2, zero, __1bit_coding

	ldhu	r13, 4(r4)				# r13 = c1
	movi	r8, 0x06
	and		r2, r15, r8
	bne		r2, r8, __2bit_coding


__3bit_coding:
	ldhu	r12, 6(r4)				# r12 = c2

	andi	r8, r15, 0xf8			### 3bit-coding デコードテーブルの作成 ###
	srli	r8, r8, 3
	addi	r8, r8, 1				# r8 = ((mode & 0xf8) >> 3) + 1
	srli	r15, r15, 8				# r15 = p
	movi	r10, 255

	stb		r15, ta0(r22)			# a[0]
	SUADD	r15, r8, r10
	stb		r15, ta1(r22)			# a[1]
	SUADD	r15, r8, r10
	stb		r15, ta2(r22)			# a[2]
	SUADD	r15, r8, r10
	stb		r15, ta3(r22)			# a[3]
	SUADD	r15, r8, r10
	stb		r15, ta4(r22)			# a[4]
	SUADD	r15, r8, r10
	stb		r15, ta5(r22)			# a[5]
	SUADD	r15, r8, r10
	stb		r15, ta6(r22)			# a[6]
	SUADD	r15, r8, r10
	stb		r15, ta7(r22)			# a[7]


	mov		r10, r5					# r10 = pQ
	movi	r8, 1					# r8 : ビットマスク 
	movhi	r9, 1					# r9 : 終了ビット (1<<16 をセットしている)

  __3bit_coding_loop:				### 3bit-coding デコードループ ###
	and		r15, r12, r8
	cmpne	r2, r15, zero
	and		r15, r13, r8
	SLLOR	r2, r2, r15
	and		r15, r14, r8
	SLLOR	r2, r2, r15				# r2 = ( ((c2 & 1) << 2)|((c1 & 1) << 1)|(c0 & 1) )*1

	add		r2, r2, r22
	ldbu	r15, 0(r2)				# *pQ++ = a[s]
	stb		r15, 0(r10)
	add		r10, r10, r6
	slli	r8, r8, 1

	bne		r8, r9, __3bit_coding_loop

	movi	r2, d_size_3bit
	ret


__2bit_coding:
	andi	r2, r15, 0x80			### 2bit-coding デコードテーブルの作成 ###
	beq		r2, zero, __2bit_coding_table_1
	andi	r2, r15, 0x40
	beq		r2, zero, __2bit_coding_table_2

  __2bit_coding_table_3:
	andi	r8, r15, 0x38
	srli	r8, r8, 1
	addi	r8, r8, 35				# r8 = ((mode & 0x38) >> 1) + 35;
	br	__2bit_coding_table_exit

  __2bit_coding_table_2:
	andi	r8, r15, 0x38
	srli	r8, r8, 2
	addi	r8, r8, 18				# r8 = ((mode & 0x38) >> 2) + 18;
	br	__2bit_coding_table_exit

  __2bit_coding_table_1:
	andi	r8, r15, 0x78
	srli	r8, r8, 3
	addi	r8, r8, 1				# r8 = ((mode & 0x78) >> 3) + 1;

  __2bit_coding_table_exit:
	mov		r9, r8

	andi	r2, r15, 0x02			# i==1時のステップ値を決定 
	beq		r2, zero, __2bit_liner_coding:
	slli	r9, r8, 1
	add		r9, r9, r8				# r9 = s*3
  __2bit_liner_coding:
	srli	r15, r15, 8				# r15 = p
	movi	r10, 255

	stb		r15, ta0(r22)			# a[0]
	SUADD	r15, r8, r10
	stb		r15, ta1(r22)			# a[1]
	SUADD	r15, r9, r10
	stb		r15, ta2(r22)			# a[2]
	SUADD	r15, r8, r10
	stb		r15, ta3(r22)			# a[3]


	mov		r10, r5					# r10 = pQ
	movi	r8, 1					# r8 : ビットマスク 
	movhi	r9, 1					# r9 : 終了ビット (1<<16 をセットしている)

  __2bit_coding_loop:				### 2bit-coding デコードループ ###
	and		r15, r13, r8
	cmpne	r2, r15, zero
	and		r15, r14, r8
	SLLOR	r2, r2, r15				# r2 = ( ((c1 & 1) << 1)|(c0 & 1) )*1

	add		r2, r2, r22
	ldbu	r15, 0(r2)				# *pQ++ = a[s]
	stb		r15, 0(r10)
	add		r10, r10, r6
	slli	r8, r8, 1

	bne		r8, r9, __2bit_coding_loop

	movi	r2, d_size_2bit
	ret


__1bit_coding:
	andi	r2, r15, 0x80			### 1bit-coding デコードテーブルの作成 ###
	beq		r2, zero, __1bit_coding_table_1
	andi	r2, r15, 0x40
	beq		r2, zero, __1bit_coding_table_2

  __1bit_coding_table_3:
	andi	r8, r15, 0x3e
	slli	r8, r8, 1
	addi	r8, r8, 131				# r8 = ((mode & 0x3e) << 1) + 131;
	br	__1bit_coding_table_exit

  __1bit_coding_table_2:
	andi	r8, r15, 0x3e
	addi	r8, r8, 66				# r8 = (mode & 0x3e) + 66;
	br	__1bit_coding_table_exit

  __1bit_coding_table_1:
	andi	r8, r15, 0x7e
	srli	r8, r8, 1
	addi	r8, r8, 1				# r8 = ((mode & 0x7e) >> 1) + 1;

  __1bit_coding_table_exit:
	srli	r15, r15, 8				# r15 = p
	movi	r10, 255

	SUADD	r8, r15, r10			# r8  = s

	mov		r10, r5					# r10 = pQ
	movi	r12, 1					# r12 : ビットマスク 
	movhi	r9, 1					# r9  : 終了ビット (1<<16 をセットしている)

  __1bit_coding_loop:				### 1bit-coding デコードループ ###
	beq		r12, r9, __1bit_coding_loop_exit
	and		r2, r14, r12
	slli	r12, r12, 1

	bne		r2, zero, __1bit_code_br1
	stb		r15, 0(r10)				# cy == 0の時 r15(p)
	add		r10, r10, r6
	br		__1bit_coding_loop
  __1bit_code_br1:
	stb		r8, 0(r10)				# cy == 1の時 r8(s)
	add		r10, r10, r6
	br		__1bit_coding_loop

  __1bit_coding_loop_exit:
	movi	r2, d_size_1bit
	ret


__0bit_coding:
	srli	r15, r15, 8				# r15 = p

	mov		r10, r5					# r10 = pQ
	movi	r8, 16

  __0bit_coding_loop:				### 0bit-coding デコードループ(4回アンロール) ###
	stb		r15, 0(r10)
	add		r10, r10, r6
	stb		r15, 0(r10)
	add		r10, r10, r6
	stb		r15, 0(r10)
	add		r10, r10, r6
	stb		r15, 0(r10)
	add		r10, r10, r6

	addi	r8, r8, -1*4
	bne		r8, zero, __0bit_coding_loop

	movi	r2, d_size_0bit
	ret


__raw_data:
	mov		r10, r5					# r10 = pQ
	mov		r8, r4					# r8  = pDCM
	addi	r9, r4, 16				# r9  = pDCM + 16

  __raw_data_loop:					### 生データ転送ループ(4回アンロール) ###
	ldbu	r2, 2(r8)
	stb		r2, 0(r10)
	add		r10, r10, r6
	ldbu	r2, 2(r8)
	stb		r2, 0(r10)
	add		r10, r10, r6
	ldbu	r2, 2(r8)
	stb		r2, 0(r10)
	add		r10, r10, r6
	ldbu	r2, 2(r8)
	stb		r2, 0(r10)
	add		r10, r10, r6

	addi	r8, r8, 1*4
	bne		r8, r9, __raw_data_loop

	movi	r2, d_size_raw
	ret



#====================================
#  YUVデコード命令エミュレーション
#====================================

# r8  y0,y1		: 輝度成分 ( (Y1<<8) | Y0 ) 
# r9  u,v		: 色差成分 ( ((V+128)<<8) | (U+128) )
# r2			: ピクセルデータ返値 ( (PIX1<<16) | PIX0 )

# r5			: 上限マスク 
# r10			: tmp, V
# r13			: tmp, B-Y成分
# r14			: tmp, R-Y成分
# r15			: tmp, G-Y成分


.ifdef DECODE_INSTRUCTION_EMULATE
_yuv_decode_emulation:

	srli	r10, r9, 8
	andi	r10, r10, 0xff
	addi	r10, r10, -128			# r10 = V成分 
	andi	r9, r9, 0xff
	addi	r9, r9, -128			# r9  = U成分 

	mov		r14, r10
	slli	r10, r10, 1
	add		r14, r14, r10
	slli	r10, r10, 1
	add		r14, r14, r10
	mov		r15, r14				# r15 = 0111 * V
	slli	r10, r10, 2

	add		r15, r15, r10
	slli	r10, r10, 1
	add		r14, r14, r10
	add		r15, r15, r10
	slli	r10, r10, 1
	add		r14, r14, r10
	slli	r10, r10, 1
	add		r15, r15, r10			# r15 = 0_1011_0111(183) * V
	slli	r10, r10, 1

	add		r14, r14, r10			# r14 = 1_0110_0111(359) * V : R-Y成分 


	slli	r9, r9, 1
	mov		r13, r9
	slli	r9, r9, 1
	add		r13, r13, r9
	slli	r9, r9, 1
	mov		r10, r9
	slli	r9, r9, 1

	add		r10, r10, r9
	slli	r9, r9, 2
	add		r13, r13, r9
	add		r10, r10, r9			# r10 = 0_0101_1000(88) * U
	slli	r9, r9, 1
	add		r13, r13, r9
	slli	r9, r9, 1

	add		r13, r13, r9			# r13 = 1_1100_0110(454) * U : B-Y成分 


	sub		r15, zero, r15
	sub		r15, r15, r10			# r15 = -183 * V - 88 * U    : G-Y成分 


	andi	r9, r8, 0xff
	slli	r9, r9, 8				# r9 = Y0 << 8
	andi	r8, r8, 0xff00			# r8 = Y1 << 8

  .ifdef SATSAL_INSTRUCTION_N
	_satsal_custom:
	mov		r2, zero

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r13, r8		# B1
	.else
		add		r10, r14, r8		# R1
	.endif
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10

	add		r10, r15, r8			# G1
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r14, r8		# R1
	.else
		add		r10, r13, r8		# B1
	.endif
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10
	slli	r2, r2, 1

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r13, r9		# B0
	.else
		add		r10, r14, r9		# R0
	.endif
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10

	add		r10, r15, r9			# G0
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r14, r9		# R0
	.else
		add		r10, r13, r9		# B0
	.endif
	custom	SATSAL_INSTRUCTION_N, r2, r2, r10

  .else
	_satsal_emulation:
	ori		r5, zero, 0xf800		# 上限およびビットマスク 

	add		r2, r15, r9				# G0
	SATZ	r2, r5
	roli	r2, r2, 5

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r14, r9		# R0
	.else
		add		r10, r13, r9		# B0
	.endif
	SATZ	r10, r5
	or		r2, r2, r10
	roli	r2, r2, 6

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r13, r8		# B1
	.else
		add		r10, r14, r8		# R1
	.endif
	SATZ	r10, r5
	or		r2, r2, r10
	roli	r2, r2, 5

	add		r10, r15, r8			# G1
	SATZ	r10, r5
	or		r2, r2, r10
	roli	r2, r2, 5

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r14, r8		# R1
	.else
		add		r10, r13, r8		# B1
	.endif
	SATZ	r10, r5
	or		r2, r2, r10
	roli	r2, r2, 6

	.ifdef SUBPIXEL_ALIGN_BGR
		add		r10, r13, r9		# B0
	.else
		add		r10, r14, r9		# R0
	.endif
	SATZ	r10, r5
	or		r2, r2, r10

	srli	r2, r2, 1
  .endif

	ret
.endif

	.endfunc

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


 ●画素変換

  YUV→RGBの変換式は下記の通り
  DCBのデコードデータは0～255の範囲となるため、UとVには-128のオフセットをつける

	Y =    0～255
	U = -128～127
	V = -128～127

	R = 1.000Y          + 1.402V
	G = 1.000Y - 0.344U - 0.714V
	B = 1.000Y + 1.772U


  ピクセルのエンコードはRGB555で、ビットフォーマットは下記の通り

  bit15                                            0
	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
	| 0|b7 b6 b5 b4 b3|g7 g6 g5 g4 g3|r7 r6 r5 r4 r3|
	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+


 ●ＤＣＢフォーマット

 ・MCU skipcode
	+---------------+---------------+
	|      0xff     |      0xff     |
	+---------------+---------------+

	MCU先頭(U成分)のみ使用可能。U成分のDCBにこのコードが設定されていた場合、
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
			 DCB3でのみ有効、それ以外はノーマルDCBとみなされる

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


/* end of file */
