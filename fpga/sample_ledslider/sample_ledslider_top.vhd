-- ===================================================================
-- TITLE : Physicaloid FPGA sample project
--         LED Slider Control
--
--   DEGISN : S.OSAFUNE (J-7SYSTEM Works)
--   DATE   : 2013/11/07 -> 2013/11/07
--   UPDATE : 
--
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2013, J-7SYSTEM Works.  All rights Reserved.
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sample_ledslider_top is
	port(
		CLOCK_50	: in  std_logic;
		RESET_N		: in  std_logic;
		START_LED	: out std_logic;

		SCI_SCLK	: in  std_logic;
		SCI_TXD		: in  std_logic;
		SCI_RXD		: out std_logic;
		SCI_TXR_N	: out std_logic;
		SCI_RXR_N	: in  std_logic
	);
end sample_ledslider_top;

architecture RTL of sample_ledslider_top is

	component pwm_control_core is
        port (
            clk_clk         : in  std_logic                    := 'X'; -- clk
            reset_reset_n   : in  std_logic                    := 'X'; -- reset_n
            scif_sclk       : in  std_logic                    := 'X'; -- sclk
            scif_txd        : in  std_logic                    := 'X'; -- txd
            scif_txr_n      : out std_logic;                           -- txr_n
            scif_rxd        : out std_logic;                           -- rxd
            scif_rxr_n      : in  std_logic                    := 'X'; -- rxr_n
            pwm_data_export : out std_logic_vector(7 downto 0)         -- export
        );
    end component pwm_control_core;

	signal pwmdata_sig		: std_logic_vector(7 downto 0);
	signal pwmcounter_reg	: std_logic_vector(7 downto 0);
	signal pwmout_reg		: std_logic;

begin

	----------------------------------------------
	-- Physicaloid Interface 
	----------------------------------------------

    u0 : component pwm_control_core
        port map (
            clk_clk         => CLOCK_50,
            reset_reset_n   => RESET_N,
            scif_sclk       => SCI_SCLK,
            scif_txd        => SCI_TXD,
            scif_txr_n      => SCI_TXR_N,
            scif_rxd        => SCI_RXD,
            scif_rxr_n      => SCI_RXR_N,
            pwm_data_export => pwmdata_sig  -- pwm_data.export
        );


	----------------------------------------------
	-- LED PWM Driver
	----------------------------------------------

	process (CLOCK_50, RESET_N) begin
		if (RESET_N = '0') then
			pwmcounter_reg <= (others=>'0');
			pwmout_reg <= '0';

		elsif (CLOCK_50'event and CLOCK_50 = '1') then
			pwmcounter_reg <= pwmcounter_reg + 1;

			if (pwmcounter_reg = 255) then
				pwmout_reg <= '1';
			elsif (pwmcounter_reg = pwmdata_sig) then
				pwmout_reg <= '0';
			end if;

		end if;
	end process;

	START_LED <= pwmout_reg;


end RTL;
