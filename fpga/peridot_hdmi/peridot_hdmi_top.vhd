-- ===================================================================
-- TITLE : PERIDOT HDMI出力デモ 
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/08/03 -> 2014/08/03
--
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2010-2014, J-7SYSTEM Works.  All rights Reserved.
--
-- * This module is a free sourcecode and there is NO WARRANTY.
-- * No restriction on use. You can use, modify and redistribute it
--   for personal, non-profit or commercial products UNDER YOUR
--   RESPONSIBILITY.
-- * Redistributions of source code must retain the above copyright
--   notice.
-- *******************************************************************

-- USAGE:
--	PERIDOTにHDMIシールドを接続し、VGAのHDMI画面出力をする 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity peridot_hdmi_top is
	port(
		CLOCK_50		: in  std_logic;	-- 50MHz in
		RESET_N			: in  std_logic;
		START_LED		: out std_logic;

		TMDS_CLOCKp		: out std_logic;	-- D14
		TMDS_CLOCKn		: out std_logic;	-- D15
		TMDS_DATA0p		: out std_logic;	-- D12
		TMDS_DATA0n		: out std_logic;	-- D13
		TMDS_DATA1p		: out std_logic;	-- D10
		TMDS_DATA1n		: out std_logic;	-- D11
		TMDS_DATA2p		: out std_logic;	-- D8
		TMDS_DATA2n		: out std_logic		-- D9
	);
end peridot_hdmi_top;

architecture RTL of peridot_hdmi_top is

	signal pllreset_sig		: std_logic;
	signal vga_clk_sig		: std_logic;	-- 25.175MHz
	signal locked_sig		: std_logic;
	signal reset_sig		: std_logic;

	signal dvi_hsync_sig	: std_logic;
	signal dvi_vsync_sig	: std_logic;
	signal dvi_hblank_sig	: std_logic;
	signal dvi_vblank_sig	: std_logic;
	signal dvi_de_sig		: std_logic;
	signal dvi_r_sig		: std_logic_vector(7 downto 0);
	signal dvi_g_sig		: std_logic_vector(7 downto 0);
	signal dvi_b_sig		: std_logic_vector(7 downto 0);

	component videopll
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0			: OUT STD_LOGIC ;
		c1			: OUT STD_LOGIC ;
		c2			: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	end component;

	component vga_syncgen
	generic (
		H_TOTAL		: integer;
		H_SYNC		: integer;
		H_BACKP		: integer;
		H_ACTIVE	: integer;
		V_TOTAL		: integer;
		V_SYNC		: integer;
		V_BACKP		: integer;
		V_ACTIVE	: integer
	);
	port (
		reset		: in  std_logic;
		video_clk	: in  std_logic;

		scan_ena	: in  std_logic;
		dither_ena	: in  std_logic;

		framestart	: out std_logic;
		linestart	: out std_logic;
		dither		: out std_logic;
		pixelena	: out std_logic;

		hsync		: out std_logic;
		vsync		: out std_logic;
		hblank		: out std_logic;
		vblank		: out std_logic;
		cb_rout		: out std_logic_vector(7 downto 0);	
		cb_gout		: out std_logic_vector(7 downto 0);
		cb_bout		: out std_logic_vector(7 downto 0)
	);
	end component;

	component dvi_tx_pdiff
	generic(
		RESET_LEVEL		: std_logic := '1';
		RESOLUTION		: string
	);
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;

		test_data0	: out std_logic_vector(9 downto 0);
		test_data1	: out std_logic_vector(9 downto 0);
		test_data2	: out std_logic_vector(9 downto 0);
		test_locked	: out std_logic;

		dvi_de		: in  std_logic;
		dvi_blu		: in  std_logic_vector(7 downto 0);
		dvi_grn		: in  std_logic_vector(7 downto 0);
		dvi_red		: in  std_logic_vector(7 downto 0);
		dvi_hsync	: in  std_logic;
		dvi_vsync	: in  std_logic;
		dvi_ctl		: in  std_logic_vector(3 downto 0) :="0000";

		data0_p		: out std_logic;
		data0_n		: out std_logic;
		data1_p		: out std_logic;
		data1_n		: out std_logic;
		data2_p		: out std_logic;
		data2_n		: out std_logic;
		clock_p		: out std_logic;
		clock_n		: out std_logic
	);
	end component;

begin

	pllreset_sig <= not RESET_N;

	videopll_inst : videopll
	PORT MAP (
		areset	 => pllreset_sig,
		inclk0	 => CLOCK_50,
		c1		 => vga_clk_sig,	-- 25.175MHz (25.222MHz)
		locked	 => locked_sig
	);

	reset_sig <= not locked_sig;


	U_DVI : vga_syncgen
	generic map (
		H_TOTAL		=> 801,		-- VGA(801は25.222MHzの補正) 
		H_SYNC		=> 96,
		H_BACKP		=> 48,
		H_ACTIVE	=> 640,
		V_TOTAL		=> 525,
		V_SYNC		=> 2,
		V_BACKP		=> 33,
		V_ACTIVE	=> 480
	)
	port map (
		video_clk	=> vga_clk_sig,
		reset		=> reset_sig,
		scan_ena	=> '0',
		dither_ena	=> '0',
		hsync		=> dvi_hsync_sig,
		vsync		=> dvi_vsync_sig,
		hblank		=> dvi_hblank_sig,
		vblank		=> dvi_vblank_sig,
		cb_rout		=> dvi_r_sig,
		cb_gout		=> dvi_g_sig,
		cb_bout		=> dvi_b_sig
	);

	dvi_de_sig <= (not dvi_hblank_sig) and (not dvi_vblank_sig);


	U_TMDS : dvi_tx_pdiff
	generic map (
		RESOLUTION	=> "VGA"
	)
	port map (
		reset		=> reset_sig,
		clk			=> vga_clk_sig,
		test_locked	=> START_LED,

		dvi_de		=> dvi_de_sig,
		dvi_blu		=> dvi_b_sig,
		dvi_grn		=> dvi_g_sig,
		dvi_red		=> dvi_r_sig,
		dvi_hsync	=> dvi_hsync_sig,
		dvi_vsync	=> dvi_vsync_sig,
		dvi_ctl		=> "0000",

		data0_p		=> TMDS_DATA0p,
		data0_n		=> TMDS_DATA0n,
		data1_p		=> TMDS_DATA1p,
		data1_n		=> TMDS_DATA1n,
		data2_p		=> TMDS_DATA2p,
		data2_n		=> TMDS_DATA2n,
		clock_p		=> TMDS_CLOCKp,
		clock_n		=> TMDS_CLOCKn
	);


end RTL;
