-- ===================================================================
-- TITLE : Physicaloid FPGA SCIインターフェース
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2013/08/24 -> 2013/08/27
--     UPDATE :
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

-- Physicaloid FPGA SCIをAvalonSTにブリッジする 
-- AvalonST以外の信号としてPSコンフィグ用のシリアルモードを持つ 


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity avalonst_byte_to_scif is
	port(
		-- Interface: clock
		clock			: in  std_logic;		-- 24MHz typ.
		reset			: in  std_logic;

		-- Interface: ST out
		out_ready		: in  std_logic;
		out_valid		: out std_logic;
		out_data		: out std_logic_vector(7 downto 0);

		-- Interface: ST in
		in_ready		: out std_logic;
		in_channel		: in  std_logic_vector(0 downto 0);	-- ch.0 : SCI / ch.1 : PSconf
		in_valid		: in  std_logic;
		in_data			: in  std_logic_vector(7 downto 0);

		-- External: FPGA SCI
		sci_sclk		: out std_logic;
		sci_txr_n		: in  std_logic;		-- FPGA data transfer ready
		sci_txd			: out std_logic;
		sci_rxr_n		: out std_logic;		-- CPLD data transfer ready
		sci_rxd			: in  std_logic;

		conf_dclk		: out std_logic;
		conf_data0		: out std_logic
	);
end avalonst_byte_to_scif;

architecture RTL of avalonst_byte_to_scif is
	signal sclk_reg			: std_logic;
	signal confmode_reg		: std_logic;
	signal dclk_reg			: std_logic;

	signal txcounter		: integer range 0 to 9;
	signal txready_reg		: std_logic;
	signal outdata_reg		: std_logic_vector(8 downto 0);

	signal rxcounter		: integer range 0 to 9;
	signal rxd_reg			: std_logic;
	signal rxready_reg		: std_logic;
	signal indata_reg		: std_logic_vector(7 downto 0);

begin

	----------------------------------------------
	-- AvalonSTインターフェース 
	----------------------------------------------

	sci_sclk  <= sclk_reg;
	sci_txd   <= outdata_reg(0) when(confmode_reg = '0') else '1';
	sci_rxr_n <= not rxready_reg;

	conf_dclk  <= dclk_reg;
	conf_data0 <= outdata_reg(0);


	out_data  <= indata_reg;
	out_valid <= '1' when(rxcounter = 9) else '0';

	in_ready  <= '1' when(sclk_reg = '1' and txcounter = 0 and in_valid = '1' and(in_channel = 1 or(in_channel = 0 and txready_reg = '1'))) else '0';

	process (clock, reset) begin
		if (reset = '1') then
			sclk_reg <= '0';
			confmode_reg <= '0';
			dclk_reg <= '0';
			txcounter   <= 0;
			txready_reg <= '0';
			outdata_reg <= (0=>'1',others=>'X');
			rxcounter   <= 0;
			rxready_reg <= '0';

		elsif (clock'event and clock = '1') then
			sclk_reg <= not sclk_reg;


			-- コンフィグレーションクロック出力 

			if (sclk_reg = '1' or(txcounter = 0 or txcounter = 1)) then
				dclk_reg <= '0';
			else
				dclk_reg <= confmode_reg;
			end if;


			-- 送信制御 

			if (sclk_reg = '0') then
				txready_reg <= not sci_txr_n;
			end if;

			if (sclk_reg = '1') then
				if (txcounter = 0) then
					if (in_valid = '1' and(in_channel = 1 or(in_channel = 0 and txready_reg = '1'))) then
						txcounter <= 1;
						confmode_reg <= in_channel(0);
						outdata_reg <= in_data & '0';
					end if;
				elsif (txcounter = 9) then
					txcounter <= 0;
					outdata_reg <= (0=>'1',others=>'X');
				else
					txcounter <= txcounter + 1;
					outdata_reg <= 'X' & outdata_reg(8 downto 1);
				end if;
			end if;


			-- 受信制御 

			if (sclk_reg = '0') then
				rxd_reg <= sci_rxd;
			end if;

			if (sclk_reg = '1') then
				if (rxcounter = 0) then
					rxready_reg <= '1';
				else
					rxready_reg <= '0';
				end if;
			end if;

			if (rxcounter = 0) then
				if (sclk_reg = '1' and rxd_reg = '0') then
					rxcounter <= 1;
				end if;
			elsif (rxcounter = 9) then
				if (out_ready = '1') then
					rxcounter <= 0;
				end if;
			else
				if (sclk_reg = '1') then
					rxcounter <= rxcounter + 1;
					indata_reg <= rxd_reg & indata_reg(7 downto 1);
				end if;
			end if;

		end if;
	end process;


end RTL;


