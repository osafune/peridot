-- ===================================================================
-- TITLE : Physicaloid FPGA test project
--
--   DEGISN : S.OSAFUNE (J-7SYSTEM Works)
--   DATE   : 2013/11/02 -> 2013/11/02
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

entity sample_ledlampy is
	port(
		CLOCK_50		: in  std_logic;
		RESET_N			: in  std_logic;
		START_LED		: out std_logic
	);
end sample_ledlampy;

architecture RTL of sample_ledlampy is
	signal clkdiv_count_reg	: std_logic_vector(26 downto 0);
	signal pwmtiming_sig	: std_logic;
	signal pwmwidth_sig		: std_logic_vector(7 downto 0);
	signal pwmcompare_sig	: std_logic_vector(7 downto 0);
	signal pwmcount_sig		: std_logic_vector(7 downto 0);
	signal pwmupdown_sig	: std_logic;
	signal pwmout_reg		: std_logic;
begin

	----------------------------------------------
	-- LED‚ð‚¶‚í‚Á‚Æ“_–Å 
	----------------------------------------------

	pwmupdown_sig <= clkdiv_count_reg(clkdiv_count_reg'left);
	pwmwidth_sig  <= clkdiv_count_reg(clkdiv_count_reg'left-1 downto clkdiv_count_reg'left-8);
	pwmcompare_sig<= not pwmwidth_sig when(pwmupdown_sig = '1') else pwmwidth_sig;
	pwmcount_sig  <= clkdiv_count_reg(7 downto 0);

	process (CLOCK_50, RESET_N) begin
		if (RESET_N = '0') then
			clkdiv_count_reg <= (others=>'0');
			pwmout_reg <= '0';

		elsif (CLOCK_50'event and CLOCK_50 = '1') then
			clkdiv_count_reg <= clkdiv_count_reg + 1;

			if (pwmcount_sig = pwmcompare_sig) then
				pwmout_reg <= '1';
			elsif (pwmcount_sig = 0) then
				pwmout_reg <= '0';
			end if;

		end if;
	end process;


	START_LED <= pwmout_reg;
--	START_LED <= clkdiv_count_reg(clkdiv_count_reg'left);



end RTL;
