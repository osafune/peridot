/* ILI9325 Driver */

#include <stdio.h>
#include <unistd.h>
#include <system.h>
#include <io.h>

#define lcdc_wrreq		(1<<31)
#define lcdc_reset		(1<<30)
#define lcdc_select		(1<<19)
#define lcdc_regaddr	(0<<18)
#define lcdc_regdata	(1<<18)


/* レジスタへデータ書き込み */
void Trans_Dat(unsigned int index, unsigned int data)
{
	const alt_u32 dev_lcdc = LCDC_BASE;

	// レジスタアドレスを設定 

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regaddr |((index>>8) & 0xff));

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regaddr |((index>>0) & 0xff));

	// データを設定 

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regdata |((data>>8) & 0xff));

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regdata |((data>>0) & 0xff));

	// 終了 

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, 0);
}


/* LCDパネル初期化 */
void ILI9325_init(void)
{
	const alt_u32 dev_lcdc = LCDC_BASE;

	IOWR(dev_lcdc, 0, lcdc_reset);
	usleep(5000);
	IOWR(dev_lcdc, 0, 0);
	usleep(10000);

	Trans_Dat(0x00E3, 0x3008); // Set internal timing
	Trans_Dat(0x00E7, 0x0012); // Set internal timing
	Trans_Dat(0x00EF, 0x1231); // Set internal timing
	Trans_Dat(0x0001, 0x0100); // set Vertical Flip(SS=1,SM=0)
//	Trans_Dat(0x0001, 0x0000); //     Horizontal(SS=0,SM=0)
	Trans_Dat(0x0002, 0x0700); // set line inversion
	Trans_Dat(0x0003, 0x1030); // set Vertical(ID=11,AM=0), 64kColor(TRI=0,BGR=1)
//	Trans_Dat(0x0003, 0x1018); //     Horizontal(ID=01,AM=1), 64kColor(TRI=0,BGR=1)
	Trans_Dat(0x0004, 0x0000); // Resize register
	Trans_Dat(0x0008, 0x0207); // set the back porch and front porch
	Trans_Dat(0x0009, 0x0000); // set non-display area refresh cycle ISC[3:0]
	Trans_Dat(0x000A, 0x0000); // FMARK function
	Trans_Dat(0x000C, 0x0000); // RGB interface setting
	Trans_Dat(0x000D, 0x0000); // Frame marker Position
	Trans_Dat(0x000F, 0x0000); // RGB interface polarity
	//--------------Power On sequence --------------//
	Trans_Dat(0x0010, 0x0000); // SAP, BT[3:0], AP[2:0], DSTB, SLP, STB
	Trans_Dat(0x0011, 0x0007); // DC1[2:0], DC0[2:0], VC[2:0]
	Trans_Dat(0x0012, 0x0000); // VREG1OUT voltage
	Trans_Dat(0x0013, 0x0000); // VDV[4:0] for VCOM amplitude
	usleep(2000000);	// Dis-charge capacitor power voltage
	Trans_Dat(0x0010, 0x1490); // SAP, BT[3:0], AP[2:0], DSTB, SLP, STB
	Trans_Dat(0x0011, 0x0227); // R11h=0x0221 at VCI=3.3V ,DC1[2:0], DC0[2:0], VC[2:0]
	usleep(50000); // Delayms 50ms
	Trans_Dat(0x0012, 0x001c); // External reference voltage= Vci;
	usleep(50000); // Delayms 50ms
	Trans_Dat(0x0013, 0x0A00); // R13=0F00 when R12=009E;VDV[4:0] for VCOM amplitude
	Trans_Dat(0x0029, 0x000F); // R29=0019 when R12=009E;VCM[5:0] for VCOMH//0012//
	Trans_Dat(0x002B, 0x000D); // Frame Rate = 91Hz
	usleep(50000); // Delayms 50ms
	Trans_Dat(0x0020, 0x0000); // GRAM horizontal Address
	Trans_Dat(0x0021, 0x0000); // GRAM Vertical Address
	// ----------- Adjust the Gamma Curve ----------//
	Trans_Dat(0x0030, 0x0000);
	Trans_Dat(0x0031, 0x0203);
	Trans_Dat(0x0032, 0x0001);
	Trans_Dat(0x0035, 0x0205);
	Trans_Dat(0x0036, 0x030C);
	Trans_Dat(0x0037, 0x0607);
	Trans_Dat(0x0038, 0x0405);
	Trans_Dat(0x0039, 0x0707);
	Trans_Dat(0x003C, 0x0502);
	Trans_Dat(0x003D, 0x1008);
	//------------------ Set GRAM area ---------------//
	Trans_Dat(0x0050, 0x0000); // Horizontal GRAM Start Address
	Trans_Dat(0x0051, 0x00EF); // Horizontal GRAM End Address
	Trans_Dat(0x0052, 0x0000); // Vertical GRAM Start Address
	Trans_Dat(0x0053, 0x013F); // Vertical GRAM Start Address
	Trans_Dat(0x0060, 0xA700); // Gate Scan Line
	Trans_Dat(0x0061, 0x0001); // NDL,VLE, REV
	Trans_Dat(0x006A, 0x0000); // set scrolling line
	//-------------- Partial Display Control ---------//
	Trans_Dat(0x0080, 0x0000);
	Trans_Dat(0x0081, 0x0000);
	Trans_Dat(0x0082, 0x0000);
	Trans_Dat(0x0083, 0x0000);
	Trans_Dat(0x0084, 0x0000);
	Trans_Dat(0x0085, 0x0000);
	//-------------- Panel Control -------------------//
	Trans_Dat(0x0090, 0x0010);
	Trans_Dat(0x0092, 0x0600);
	Trans_Dat(0x0093, 0x0003);
	Trans_Dat(0x0095, 0x0110);
	Trans_Dat(0x0097, 0x0000);
	Trans_Dat(0x0098, 0x0000);
	Trans_Dat(0x0007, 0x0133); // 262K color and display ON
}


/* フレームバッファアップデート */
void ILI9325_updatefb(const alt_u16 *pFb_top)
{
	const alt_u32 dev_lcdc = LCDC_BASE;

	// 転送終了を待つ 

	while( (IORD(dev_lcdc, 2) & (1<<0)) ) {}

	// GRAMポインタ初期化 

	Trans_Dat(0x0020,0x0000);
	Trans_Dat(0x0021,0x0000);

	// GRAMへDMA開始 

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regaddr | 0x00);

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 0, lcdc_wrreq | lcdc_select | lcdc_regaddr | 0x22);

	while( (IORD(dev_lcdc, 0) & (1<<31)) ) {}
	IOWR(dev_lcdc, 3, (alt_u32)pFb_top);
	IOWR(dev_lcdc, 2, 1);
}


