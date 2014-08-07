----------------------------------------------------------------------
-- TITLE : Pseudo-differential transmitter
--
--     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2005/10/13 -> 2005/10/13 (HERSTELLUNG)
--
--               : 2013/01/30 疑似差動駆動に変更 
--               : 2013/02/02 シリアライザを修正 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pdiff_transmitter is
	generic(
		RESET_LEVEL		: std_logic := '1';		-- Positive logic reset
		RESOLUTION		: string := "VGA"		-- 25.175MHz
--		RESOLUTION		: string := "SVGA"		-- 40.000MHz
--		RESOLUTION		: string := "XGA"		-- 65.000MHz
--		RESOLUTION		: string := "480p"		-- 27.000MHz
--		RESOLUTION		: string := "720p"		-- 74.250MHz
--		RESOLUTION		: string := "1080p/30"	-- 74.250MHz
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
end pdiff_transmitter;

architecture RTL of pdiff_transmitter is
	signal areset_sig	: std_logic;

	signal data0_in_reg	: std_logic_vector(9 downto 0);
	signal data1_in_reg	: std_logic_vector(9 downto 0);
	signal data2_in_reg	: std_logic_vector(9 downto 0);

	signal start_reg	: std_logic_vector(4 downto 0);

	signal data0_ser_reg: std_logic_vector(9 downto 0);
	signal data0p_h_reg	: std_logic;
	signal data0p_l_reg	: std_logic;
	signal data0n_h_reg	: std_logic;
	signal data0n_l_reg	: std_logic;

	signal data1_ser_reg: std_logic_vector(9 downto 0);
	signal data1p_h_reg	: std_logic;
	signal data1p_l_reg	: std_logic;
	signal data1n_h_reg	: std_logic;
	signal data1n_l_reg	: std_logic;

	signal data2_ser_reg: std_logic_vector(9 downto 0);
	signal data2p_h_reg	: std_logic;
	signal data2p_l_reg	: std_logic;
	signal data2n_h_reg	: std_logic;
	signal data2n_l_reg	: std_logic;

	signal clock_ser_reg: std_logic_vector(9 downto 0);
	signal clockp_h_reg	: std_logic;
	signal clockp_l_reg	: std_logic;
	signal clockn_h_reg	: std_logic;
	signal clockn_l_reg	: std_logic;


	-- シリアライザPLL --
	signal clk_dot_sig	: std_logic;
	signal clk_ser_sig	: std_logic;
	signal reset_n_sig	: std_logic := '0';

	component pll_tx_cyclone3_vga
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC;			-- dot clock in (25.175MHz)
		c0			: OUT STD_LOGIC;		-- core clock out (25.175MHz,0deg)
		c1			: OUT STD_LOGIC;		-- SerClk out (125.875MHz,0deg)
		locked		: OUT STD_LOGIC 
	);
	end component;

	component pll_tx_cyclone3_svga
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC;			-- dot clock in (40MHz)
		c0			: OUT STD_LOGIC;		-- core clock out (40MHz,0deg)
		c1			: OUT STD_LOGIC;		-- SerClk out (200MHz,0deg)
		locked		: OUT STD_LOGIC 
	);
	end component;

	component pll_tx_cyclone3_xga
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC;			-- dot clock in (65MHz)
		c0			: OUT STD_LOGIC;		-- core clock out (65MHz,0deg)
		c1			: OUT STD_LOGIC;		-- SerClk out (325MHz,0deg)
		locked		: OUT STD_LOGIC 
	);
	end component;

	component pll_tx_cyclone3_sd
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC;			-- dot clock in (27MHz)
		c0			: OUT STD_LOGIC;		-- core clock out (27MHz,0deg)
		c1			: OUT STD_LOGIC;		-- SerClk out (135MHz,0deg)
		locked		: OUT STD_LOGIC 
	);
	end component;

	component pll_tx_cyclone3_hd
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC;			-- dot clock in (74.25MHz)
		c0			: OUT STD_LOGIC;		-- core clock out (74.25MHz,0deg)
		c1			: OUT STD_LOGIC;		-- SerClk out (371.25MHz,0deg)
		locked		: OUT STD_LOGIC 
	);
	end component;


	-- DDR I/O出力 --
	component ddio_out_cyclone3
	port
	(
		datain_h	: IN STD_LOGIC;
		datain_l	: IN STD_LOGIC;
		outclock	: IN STD_LOGIC;
		dataout		: OUT STD_LOGIC 
	);
	end component;

begin

	-- クロック＆リセット生成 --

	areset_sig <= '1' when(reset = RESET_LEVEL) else '0';
	pll_locked <= reset_n_sig;

VGAPLL : if (RESOLUTION = "VGA") generate
	TXPLL : pll_tx_cyclone3_vga
		port map (
			areset	=> areset_sig,
			inclk0	=> clk,
			c0		=> clk_dot_sig,
			c1		=> clk_ser_sig,
			locked	=> reset_n_sig
		);
	end generate;

SVGAPLL : if (RESOLUTION = "SVGA") generate
	TXPLL : pll_tx_cyclone3_svga
		port map (
			areset	=> areset_sig,
			inclk0	=> clk,
			c0		=> clk_dot_sig,
			c1		=> clk_ser_sig,
			locked	=> reset_n_sig
		);
	end generate;

XGAPLL : if (RESOLUTION = "XGA") generate
	TXPLL : pll_tx_cyclone3_xga
		port map (
			areset	=> areset_sig,
			inclk0	=> clk,
			c0		=> clk_dot_sig,
			c1		=> clk_ser_sig,
			locked	=> reset_n_sig
		);
	end generate;
SDPLL : if (RESOLUTION = "480p") generate
	TXPLL : pll_tx_cyclone3_sd
		port map (
			areset	=> areset_sig,
			inclk0	=> clk,
			c0		=> clk_dot_sig,
			c1		=> clk_ser_sig,
			locked	=> reset_n_sig
		);
	end generate;
HDPLL : if (RESOLUTION = "720p" or RESOLUTION = "1080p/30") generate
	TXPLL : pll_tx_cyclone3_hd
		port map (
			areset	=> areset_sig,
			inclk0	=> clk,
			c0		=> clk_dot_sig,
			c1		=> clk_ser_sig,
			locked	=> reset_n_sig
		);
	end generate;


	-- 内部クロックへの載せ替え --

	process (clk_dot_sig) begin
		if (clk_dot_sig'event and clk_dot_sig='1') then
			data0_in_reg <= data0_in;
			data1_in_reg <= data1_in;
			data2_in_reg <= data2_in;
		end if;
	end process;


	-- ラッチ信号の生成とシフトレジスタ --

	process (clk_ser_sig, reset_n_sig) begin
		if (reset_n_sig = '0') then
			start_reg <= "00001";

		elsif (clk_ser_sig'event and clk_ser_sig='1') then
			start_reg <= start_reg(0) & start_reg(4 downto 1);

			if (start_reg(0) = '1') then
				data0_ser_reg <= data0_in_reg;
				data1_ser_reg <= data1_in_reg;
				data2_ser_reg <= data2_in_reg;
				clock_ser_reg <= "0000011111";
			else
				data0_ser_reg <= "XX" & data0_ser_reg(9 downto 2);
				data1_ser_reg <= "XX" & data1_ser_reg(9 downto 2);
				data2_ser_reg <= "XX" & data2_ser_reg(9 downto 2);
				clock_ser_reg <= "XX" & clock_ser_reg(9 downto 2);
			end if;
		end if;
	end process;


	-- ビット出力 --

	process (clk_ser_sig) begin
		if (clk_ser_sig'event and clk_ser_sig='1') then
			data0p_h_reg <= data0_ser_reg(0);
			data0p_l_reg <= data0_ser_reg(1);
			data0n_h_reg <= not data0_ser_reg(0);
			data0n_l_reg <= not data0_ser_reg(1);

			data1p_h_reg <= data1_ser_reg(0);
			data1p_l_reg <= data1_ser_reg(1);
			data1n_h_reg <= not data1_ser_reg(0);
			data1n_l_reg <= not data1_ser_reg(1);

			data2p_h_reg <= data2_ser_reg(0);
			data2p_l_reg <= data2_ser_reg(1);
			data2n_h_reg <= not data2_ser_reg(0);
			data2n_l_reg <= not data2_ser_reg(1);

			clockp_h_reg <= clock_ser_reg(0);
			clockp_l_reg <= clock_ser_reg(1);
			clockn_h_reg <= not clock_ser_reg(0);
			clockn_l_reg <= not clock_ser_reg(1);
		end if;
	end process;

	TX0_P : ddio_out_cyclone3
		port map (
			datain_h	=> data0p_h_reg,
			datain_l	=> data0p_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx0_out_p
		);
	TX0_N : ddio_out_cyclone3
		port map (
			datain_h	=> data0n_h_reg,
			datain_l	=> data0n_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx0_out_n
		);

	TX1_P : ddio_out_cyclone3
		port map (
			datain_h	=> data1p_h_reg,
			datain_l	=> data1p_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx1_out_p
		);
	TX1_N : ddio_out_cyclone3
		port map (
			datain_h	=> data1n_h_reg,
			datain_l	=> data1n_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx1_out_n
		);

	TX2_P : ddio_out_cyclone3
		port map (
			datain_h	=> data2p_h_reg,
			datain_l	=> data2p_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx2_out_p
		);
	TX2_N : ddio_out_cyclone3
		port map (
			datain_h	=> data2n_h_reg,
			datain_l	=> data2n_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> tx2_out_n
		);

	TXC_P : ddio_out_cyclone3
		port map (
			datain_h	=> clockp_h_reg,
			datain_l	=> clockp_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> txc_out_p
		);
	TXC_N : ddio_out_cyclone3
		port map (
			datain_h	=> clockn_h_reg,
			datain_l	=> clockn_l_reg,
			outclock	=> clk_ser_sig,
			dataout		=> txc_out_n
		);


end RTL;



----------------------------------------------------------------------
--   Copyright (C)2010-2013 J-7SYSTEM Works.  All rights Reserved.  --
----------------------------------------------------------------------
