----------------------------------------------------------------------
-- TITLE : DVI Transmitter (Pseudo-differential)
--
--     VERFASSER : Syun OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2005/10/12 -> 2005/10/13 (HERSTELLUNG)

--               : 2012/09/03 CycloneIII PLL対応 
--               : 2013/01/30 疑似差動出力化 
--               : 2013/02/02 解像度パラメータ化 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity dvi_tx_pdiff is
	generic(
		RESET_LEVEL		: std_logic := '1';	-- Positive logic reset
--		RESOLUTION		: string := "ERRORTEST"
		RESOLUTION		: string := "VGA"		-- 25.175MHz
--		RESOLUTION		: string := "SVGA"		-- 40.000MHz
--		RESOLUTION		: string := "XGA"		-- 65.000MHz
--		RESOLUTION		: string := "480p"		-- 27.000MHz
--		RESOLUTION		: string := "720p"		-- 74.250MHz
--		RESOLUTION		: string := "1080p/30"	-- 74.250MHz
	);
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;		-- Rise edge drive clock

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
end dvi_tx_pdiff;

architecture RTL of dvi_tx_pdiff is

	component tmds_encoder
	generic(
		RESET_LEVEL		: std_logic;
		CLOCK_EDGE		: std_logic := '1'
	);
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;
		de_in		: in  std_logic;
		c1_in		: in  std_logic;
		c0_in		: in  std_logic;
		d_in		: in  std_logic_vector(7 downto 0);
		q_out		: out std_logic_vector(9 downto 0)
	);
	end component;
	signal q_blu_sig	: std_logic_vector(9 downto 0);
	signal q_grn_sig	: std_logic_vector(9 downto 0);
	signal q_red_sig	: std_logic_vector(9 downto 0);


	component pdiff_transmitter
	generic(
		RESET_LEVEL		: std_logic := '1';
		RESOLUTION		: string
	);
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;
		pll_locked	: out std_logic;

		data0_in	: in  std_logic_vector(9 downto 0);
		data1_in	: in  std_logic_vector(9 downto 0);
		data2_in	: in  std_logic_vector(9 downto 0);

		tx0_out_p	: out std_logic;
		tx0_out_n	: out std_logic;
		tx1_out_p	: out std_logic;
		tx1_out_n	: out std_logic;
		tx2_out_p	: out std_logic;
		tx2_out_n	: out std_logic;
		txc_out_p	: out std_logic;
		txc_out_n	: out std_logic
	);
	end component;
	signal plllocked_sig	: std_logic;

begin

	test_data0 <= q_blu_sig;
	test_data1 <= q_grn_sig;
	test_data2 <= q_red_sig;

	test_locked <= plllocked_sig;


	-- T.M.D.S.データエンコード --

	TMDS_B : tmds_encoder
	generic map (
		RESET_LEVEL	=> RESET_LEVEL,
		CLOCK_EDGE	=> '1'
	)
	port map (
		reset	=> reset,
		clk		=> clk,
		de_in	=> dvi_de,
		c1_in	=> dvi_vsync,
		c0_in	=> dvi_hsync,
		d_in	=> dvi_blu,
		q_out	=> q_blu_sig
	);

	TMDS_G : tmds_encoder
	generic map (
		RESET_LEVEL	=> RESET_LEVEL,
		CLOCK_EDGE	=> '1'
	)
	port map (
		reset	=> reset,
		clk		=> clk,
		de_in	=> dvi_de,
		c1_in	=> dvi_ctl(1),
		c0_in	=> dvi_ctl(0),
		d_in	=> dvi_grn,
		q_out	=> q_grn_sig
	);

	TMDS_R : tmds_encoder
	generic map (
		RESET_LEVEL	=> RESET_LEVEL,
		CLOCK_EDGE	=> '1'
	)
	port map (
		reset	=> reset,
		clk		=> clk,
		de_in	=> dvi_de,
		c1_in	=> dvi_ctl(3),
		c0_in	=> dvi_ctl(2),
		d_in	=> dvi_red,
		q_out	=> q_red_sig
	);


	-- シリアライザ --

	SER : pdiff_transmitter
	generic map (
		RESET_LEVEL	=> RESET_LEVEL,
		RESOLUTION	=> RESOLUTION
	)
	port map (
		reset		=> reset,
		clk			=> clk,
		pll_locked	=> plllocked_sig,

		data0_in	=> q_blu_sig,
		data1_in	=> q_grn_sig,
		data2_in	=> q_red_sig,

		tx0_out_p	=> data0_p,
		tx0_out_n	=> data0_n,
		tx1_out_p	=> data1_p,
		tx1_out_n	=> data1_n,
		tx2_out_p	=> data2_p,
		tx2_out_n	=> data2_n,
		txc_out_p	=> clock_p,
		txc_out_n	=> clock_n
	);


end RTL;



----------------------------------------------------------------------
--   Copyright (C)2005-2013 J-7SYSTEM Works.  All rights Reserved.  --
----------------------------------------------------------------------
