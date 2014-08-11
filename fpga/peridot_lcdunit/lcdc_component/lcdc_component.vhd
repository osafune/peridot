-- ===================================================================
-- TITLE : ILI9325 LCDC Interface
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/05/10 -> 2014/05/12
--            : 2014/05/12 (FIXED)
--
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2014, J-7SYSTEM Works.  All rights Reserved.
--
-- * This module is a free sourcecode and there is NO WARRANTY.
-- * No restriction on use. You can use, modify and redistribute it
--   for personal, non-profit or commercial products UNDER YOUR
--   RESPONSIBILITY.
-- * Redistributions of source code must retain the above copyright
--   notice.
-- *******************************************************************


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity lcdc_component is
	port(
	--==== Avalonバス信号線 ==========================================
		csi_clk				: in  std_logic;
		csi_reset			: in  std_logic;

		----- AvalonMMスレーブ信号 -----------
		avs_s1_address		: in  std_logic_vector(3 downto 2);
		avs_s1_read			: in  std_logic;
		avs_s1_readdata		: out std_logic_vector(31 downto 0);
		avs_s1_write		: in  std_logic;
		avs_s1_writedata	: in  std_logic_vector(31 downto 0);
--		avs_s1_byteenable	: in  std_logic_vector(3 downto 0);

		ins_s1_irq			: out std_logic;

		----- AvalonMMマスタ信号 -----------
		avm_m1_address		: out std_logic_vector(30 downto 0);
		avm_m1_waitrequest	: in  std_logic;
		avm_m1_burstcount	: out std_logic_vector(3 downto 0);
		avm_m1_read			: out std_logic;
		avm_m1_readdata		: in  std_logic_vector(15 downto 0);
		avm_m1_readdatavalid: in  std_logic;

		----- PROCYON_GPU信号 -----------
--		coe_gpucrtc_send	: out std_logic_vector(24 downto 0);
--		coe_gpucrtc_recv	: in  std_logic_vector(16 downto 0);


	--==== ILI9325信号線(i80-8bit接続) ===============================
		coe_lcd_rst_n		: out std_logic;
		coe_lcd_cs_n		: out std_logic;
		coe_lcd_rs			: out std_logic;
		coe_lcd_wr_n		: out std_logic;
		coe_lcd_d			: inout std_logic_vector(7 downto 0)
	);
end lcdc_component;

architecture RTL of lcdc_component is
	signal dma_topaddr_sig	: std_logic_vector(30 downto 0);
	signal dma_start_sig	: std_logic;
	signal dma_ready_sig	: std_logic;
	signal lcd_reset_sig	: std_logic;
	signal lcd_select_sig	: std_logic;
	signal lcd_dout_sig		: std_logic_vector(7 downto 0);

	signal gpucrtcaddr_sig	: std_logic_vector(30 downto 0);
	signal avm_address_sig	: std_logic_vector(30 downto 0);
	signal avm_read_sig		: std_logic;
	signal avm_readdata_sig	: std_logic_vector(15 downto 0);
	signal avm_rdvalid_sig	: std_logic;
	signal gpucrtcreq_reg	: std_logic;

	signal dma_wrreq_sig	: std_logic;
	signal dma_wrack_sig	: std_logic;
	signal dma_regsel_sig	: std_logic;
	signal dma_data_sig		: std_logic_vector(7 downto 0);
	signal cpu_wrreq_sig	: std_logic;
	signal cpu_wrack_sig	: std_logic;
	signal cpu_regsel_sig	: std_logic;
	signal cpu_data_sig		: std_logic_vector(7 downto 0);
	signal lcdc_wrreq_sig	: std_logic;
	signal lcdc_wrack_sig	: std_logic;
	signal lcdc_regsel_sig	: std_logic;
	signal lcdc_data_sig	: std_logic_vector(7 downto 0);


	component lcdc_regs
	port(
		clk			: in  std_logic;
		reset		: in  std_logic;

		address		: in  std_logic_vector(3 downto 2);
		read		: in  std_logic;
		readdata	: out std_logic_vector(31 downto 0);
		write		: in  std_logic;
		writedata	: in  std_logic_vector(31 downto 0);
		irq			: out std_logic;

		topaddr		: out std_logic_vector(30 downto 0);
		start		: out std_logic;
		ready		: in  std_logic;

		wrreq		: out std_logic;
		wrack		: in  std_logic;
		regsel		: out std_logic;
		data		: out std_logic_vector(7 downto 0);

		lcd_reset	: out std_logic;
		lcd_select	: out std_logic
	);
	end component;

	component lcdc_dma
	generic(
		VRAM_LINEBYTES		: integer;
		VRAM_VIEWWIDTH		: integer;
		VRAM_VIEWHEIGHT		: integer
	);
	port(
		clk				: in  std_logic;
		reset			: in  std_logic;
		test_usedw		: out std_logic_vector(8 downto 0);

		topaddr			: in  std_logic_vector(30 downto 0);
		start			: in  std_logic;
		ready			: out std_logic;
		wrreq			: out std_logic;
		wrack			: in  std_logic;
		wrdata			: out std_logic_vector(7 downto 0);

		address			: out std_logic_vector(30 downto 0);
		waitrequest		: in  std_logic;
		burstcount		: out std_logic_vector(3 downto 0);
		read			: out std_logic;
		readdata		: in  std_logic_vector(15 downto 0);
		readdatavalid	: in  std_logic
	);
	end component;

	component lcdc_wrstate
	generic(
		LCDC_WAITCOUNT_MAX	: integer;
		LCDC_WRSETUP_COUNT	: integer;
		LCDC_WRWIDTH_COUNT	: integer;
		LCDC_WRHOLD_COUNT	: integer
	);
	port(
		clk			: in  std_logic;
		reset		: in  std_logic;

		wrreq		: in  std_logic;
		wrack		: out std_logic;
		regsel		: in  std_logic;
		data		: in  std_logic_vector(7 downto 0);

		lcd_rs		: out std_logic;
		lcd_wr_n	: out std_logic;
		lcd_d		: out std_logic_vector(7 downto 0)
	);
	end component;


begin

--==== モジュールインスタンス ========================================

	-- AvalonMM→PROCYON_GPUの信号変換 

--	gpucrtcaddr_sig(30 downto 24) <= (others=>'0');
--	gpucrtcaddr_sig(23 downto 10) <= dma_topaddr_sig(23 downto 10);
--	gpucrtcaddr_sig( 9 downto  0) <= (others=>'0');
--
--	coe_gpucrtc_send <= '1' & avm_address_sig(23 downto 4) & "000" & gpucrtcreq_reg;
--	avm_readdata_sig <= coe_gpucrtc_recv(15 downto 0);
--	avm_rdvalid_sig  <= coe_gpucrtc_recv(16);
--
--	process (csi_clk, csi_reset) begin
--		if (csi_reset='1') then
--			gpucrtcreq_reg <= '0';
--
--		elsif rising_edge(csi_clk) then
--			if (avm_read_sig = '1') then
--				gpucrtcreq_reg <= '1';
--			elsif (avm_rdvalid_sig = '1') then
--				gpucrtcreq_reg <= '0';
--			end if;
--
--		end if;
--	end process;


	-- レジスタモジュール 

	U0 : lcdc_regs
	port map(
		clk			=> csi_clk,
		reset		=> csi_reset,

		address		=> avs_s1_address,
		read		=> avs_s1_read,
		readdata	=> avs_s1_readdata,
		write		=> avs_s1_write,
		writedata	=> avs_s1_writedata,
		irq			=> ins_s1_irq,

		topaddr		=> dma_topaddr_sig,
		start		=> dma_start_sig,
		ready		=> dma_ready_sig,

		wrreq		=> cpu_wrreq_sig,
		wrack		=> cpu_wrack_sig,
		regsel		=> cpu_regsel_sig,
		data		=> cpu_data_sig,

		lcd_reset	=> lcd_reset_sig,
		lcd_select	=> lcd_select_sig
	);


	-- VRAM DMAモジュール 

	U1 : lcdc_dma
	generic map(
		VRAM_LINEBYTES		=> 1024*2,	-- line bytes : 1024*2
		VRAM_VIEWWIDTH		=> 240,		-- LCD width size : 240pixel
		VRAM_VIEWHEIGHT		=> 320		-- LCD height szie : 320pixel
	)
	port map(
		clk				=> csi_clk,
		reset			=> csi_reset,

		topaddr			=> dma_topaddr_sig,
--		topaddr			=> gpucrtcaddr_sig,		-- PROCYON_GPU用 
		start			=> dma_start_sig,
		ready			=> dma_ready_sig,
		wrreq			=> dma_wrreq_sig,
		wrack			=> dma_wrack_sig,
		wrdata			=> dma_data_sig,

		address			=> avm_m1_address,
		waitrequest		=> avm_m1_waitrequest,
		burstcount		=> avm_m1_burstcount,
		read			=> avm_m1_read,
		readdata		=> avm_m1_readdata,
		readdatavalid	=> avm_m1_readdatavalid

--		address			=> avm_address_sig,		-- PROCYON_GPU用 
--		waitrequest		=> '0',
--		burstcount		=> open,
--		read			=> avm_read_sig,
--		readdata		=> avm_readdata_sig,
--		readdatavalid	=> avm_rdvalid_sig
	);

	dma_regsel_sig <= '1';	-- DMA時はRS=1で固定 


	-- 書き込み元セレクタ 

	lcdc_wrreq_sig <= dma_wrreq_sig when(dma_ready_sig = '0') else cpu_wrreq_sig;
	dma_wrack_sig <= lcdc_wrack_sig when(dma_ready_sig = '0') else '0';
	cpu_wrack_sig <= lcdc_wrack_sig when(dma_ready_sig = '1') else '0';

	lcdc_regsel_sig <= dma_regsel_sig when(dma_ready_sig = '0') else cpu_regsel_sig;
	lcdc_data_sig <= dma_data_sig when(dma_ready_sig = '0') else cpu_data_sig;


	-- LCDCアクセスモジュール 

	coe_lcd_rst_n <= not lcd_reset_sig;
	coe_lcd_cs_n  <= not lcd_select_sig;
	coe_lcd_d <= lcd_dout_sig when(lcd_select_sig = '1') else (others=>'Z');

	U2 : lcdc_wrstate
	generic map(
		LCDC_WAITCOUNT_MAX	=> 8,
		LCDC_WRSETUP_COUNT	=> 4,	-- set RS and D -> assert nWR : 40ns
		LCDC_WRWIDTH_COUNT	=> 8,	-- assert nWR width : 80ns
		LCDC_WRHOLD_COUNT	=> 4	-- negate nWR -> next state : 40ns
	)
	port map(
		clk			=> csi_clk,
		reset		=> csi_reset,
		wrreq		=> lcdc_wrreq_sig,
		wrack		=> lcdc_wrack_sig,
		regsel		=> lcdc_regsel_sig,
		data		=> lcdc_data_sig,

		lcd_rs		=> coe_lcd_rs,
		lcd_wr_n	=> coe_lcd_wr_n,
		lcd_d		=> lcd_dout_sig
	);



end RTL;


