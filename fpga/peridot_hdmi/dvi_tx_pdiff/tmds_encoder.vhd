----------------------------------------------------------------------
-- TITLE : T.M.D.S. encoder
--
--     VERFASSER : Syun OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2005/10/09 -> 2005/10/13 (HERSTELLUNG)

--               : 2012/09/03 CycloneIII PLL対応 
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity tmds_encoder is
	generic(
		RESET_LEVEL		: std_logic := '1';	-- Positive logic reset
		CLOCK_EDGE		: std_logic := '1'	-- Rise edge drive clock
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
end tmds_encoder;

architecture RTL of tmds_encoder is
	signal cnt		: integer range -8 to 8;

	signal qm_reg	: std_logic_vector(8 downto 0);
	signal de_reg	: std_logic;
	signal c_reg	: std_logic_vector(1 downto 0);
	signal qout_reg	: std_logic_vector(9 downto 0);

	-- バイト中のビット１の個数をカウント --
	function number1s(D:std_logic_vector(7 downto 0)) return integer is
		variable i,num	: integer;
	begin

		num := 0;
		for i in 0 to 7 loop
			if (D(i)='1') then
				num := num + 1;
			end if;
		end loop;

		return num;
	end;

	-- バイト中のビット０の個数をカウント --
	function number0s(D:std_logic_vector(7 downto 0)) return integer is
		variable i,num	: integer;
	begin

		num := 0;
		for i in 0 to 7 loop
			if (D(i)='0') then
				num := num + 1;
			end if;
		end loop;

		return num;
	end;

	-- XORエンコード --
	function encode1(D:std_logic_vector(7 downto 0)) return std_logic_vector is
		variable i		: integer;
		variable q_m	: std_logic_vector(8 downto 0);
	begin

		q_m(0) := D(0);
		for i in 1 to 7 loop
			q_m(i) := q_m(i-1) xor D(i);
		end loop;

		q_m(8) := '1';

		return q_m;

	end;

	-- XNORエンコード --
	function encode0(D:std_logic_vector(7 downto 0)) return std_logic_vector is
		variable i		: integer;
		variable q_m	: std_logic_vector(8 downto 0);
	begin

		q_m(0) := D(0);
		for i in 1 to 7 loop
			q_m(i) := not(q_m(i-1) xor D(i));
		end loop;

		q_m(8) := '0';

		return q_m;

	end;

begin

	-- 入力信号をラッチ --
	process(clk,reset)begin
		if (reset=RESET_LEVEL) then
			de_reg <= '0';
			c_reg  <= "00";

		elsif(clk'event and clk=CLOCK_EDGE)then
			de_reg <= de_in;
			c_reg  <= c1_in & c0_in;

			if (number1s(d_in)>4 or(number1s(d_in)=4 and d_in(0)='0')) then
				qm_reg <= encode0(d_in);
			else
				qm_reg <= encode1(d_in);
			end if;

		end if;
	end process;

	-- データをT.M.D.S.形式にエンコード --
	process(clk,reset)begin
		if (reset=RESET_LEVEL) then
			cnt <= 0;

		elsif (clk'event and clk=CLOCK_EDGE) then
			if (de_reg='1') then
				if (cnt=0 or(number1s(qm_reg(7 downto 0))=number0s(qm_reg(7 downto 0)))) then
					qout_reg(9) <= not qm_reg(8);
					qout_reg(8) <= qm_reg(8);
					if (qm_reg(8)='0') then
						qout_reg(7 downto 0) <= not qm_reg(7 downto 0);
					else
						qout_reg(7 downto 0) <= qm_reg(7 downto 0);
					end if;

					if (qm_reg(8)='0') then
						cnt <= cnt + (number0s(qm_reg(7 downto 0)) - number1s(qm_reg(7 downto 0)));
					else
						cnt <= cnt + (number1s(qm_reg(7 downto 0)) - number0s(qm_reg(7 downto 0)));
					end if;

				else
					if ((cnt>0 and number1s(qm_reg(7 downto 0)) > number0s(qm_reg(7 downto 0)))
							or(cnt<0 and number0s(qm_reg(7 downto 0)) > number1s(qm_reg(7 downto 0)))) then
						qout_reg(9) <= '1';
						qout_reg(8) <= qm_reg(8);
						qout_reg(7 downto 0) <= not qm_reg(7 downto 0);

						if (qm_reg(8)='0') then
							cnt <= cnt + (number0s(qm_reg(7 downto 0)) - number1s(qm_reg(7 downto 0)));
						else
							cnt <= cnt + (number0s(qm_reg(7 downto 0)) - number1s(qm_reg(7 downto 0))) + 2;
						end if;

					else
						qout_reg(9) <= '0';
						qout_reg(8) <= qm_reg(8);
						qout_reg(7 downto 0) <= qm_reg(7 downto 0);

						if (qm_reg(8)='1') then
							cnt <= cnt + (number1s(qm_reg(7 downto 0)) - number0s(qm_reg(7 downto 0)));
						else
							cnt <= cnt + (number1s(qm_reg(7 downto 0)) - number0s(qm_reg(7 downto 0))) - 2;
						end if;

					end if;
				end if;

			else
				cnt <= 0;
				case c_reg is
				when "01" =>
					qout_reg <= "0010101011";
				when "10" =>
					qout_reg <= "0101010100";
				when "11" =>
					qout_reg <= "1010101011";
				when others =>
					qout_reg <= "1101010100";
				end case;

			end if;

		end if;
	end process;

	q_out <= qout_reg;


end RTL;


----------------------------------------------------------------------
--   Copyright (C)2005-2012 J-7SYSTEM Works.  All rights Reserved.  --
----------------------------------------------------------------------
