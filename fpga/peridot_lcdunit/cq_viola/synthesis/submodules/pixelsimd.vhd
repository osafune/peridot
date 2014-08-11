----------------------------------------------------------------------
-- TITLE : Pixel SIMD instruction set for NiosII
--
--     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2010/12/12 -> 2010/12/13 (HERSTELLUNG)
--               : 2010/12/14 (FESTSTELLUNG)
--
----------------------------------------------------------------------

-- 0 : pyuvdec     3clcok
-- 1 : ppack       1clock
-- 2 : punpackl    1clock
-- 3 : punpackh    1clock
-- 4 : pblend      3clock
-- 5 : (reserved)  1clock
-- 6 : psadd       1clock
-- 7 : pssub       1clock

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixelsimd is
	port(
		dataa		: in  std_logic_vector(31 downto 0);
		datab		: in  std_logic_vector(31 downto 0);
		result		: out std_logic_vector(31 downto 0);

		clk			: in  std_logic;
		clk_en		: in  std_logic;
		reset		: in  std_logic;
		start		: in  std_logic;
		done		: out std_logic;

		n			: in  std_logic_vector(2 downto 0)
	);
end pixelsimd;

architecture RTL of pixelsimd is
	signal done_reg			: std_logic_vector(3 downto 0);

	signal punpack_r_sig	: std_logic_vector(4 downto 0);
	signal punpack_g_sig	: std_logic_vector(4 downto 0);
	signal punpack_b_sig	: std_logic_vector(4 downto 0);
	signal punpack_sig		: std_logic_vector(31 downto 0);

	signal ppack_r0_sig		: std_logic_vector(7 downto 0);
	signal ppack_g0_sig		: std_logic_vector(7 downto 0);
	signal ppack_b0_sig		: std_logic_vector(7 downto 0);
	signal ppack_r1_sig		: std_logic_vector(7 downto 0);
	signal ppack_g1_sig		: std_logic_vector(7 downto 0);
	signal ppack_b1_sig		: std_logic_vector(7 downto 0);
	signal ppack_sig		: std_logic_vector(31 downto 0);

	signal paddb_sig		: std_logic_vector(31 downto 0);
	signal psubb_sig		: std_logic_vector(31 downto 0);

	signal resultpack_reg	: std_logic_vector(31 downto 0);
	signal resultsat_reg	: std_logic_vector(31 downto 0);
	signal resultblend_sig	: std_logic_vector(31 downto 0);
	signal resultyuv_sig	: std_logic_vector(31 downto 0);

	component pixelsimd_sat_u8
	port(
		dataa		: in  std_logic_vector(7 downto 0);
		datab		: in  std_logic_vector(7 downto 0);
		sadd_result	: out std_logic_vector(7 downto 0);
		ssub_result	: out std_logic_vector(7 downto 0)
	);
	end component;

	component pixelsimd_blend_u8
	port(
		clk			: in  std_logic;
		dataa		: in  std_logic_vector(7 downto 0);
		datab		: in  std_logic_vector(7 downto 0);
		bland		: in  std_logic_vector(7 downto 0);
		result		: out std_logic_vector(7 downto 0)
	);
	end component;

	component pixelsimd_yuvdec
	port(
		clk			: in  std_logic;
		data_y0		: in  std_logic_vector(7 downto 0);
		data_y1		: in  std_logic_vector(7 downto 0);
		data_u		: in  std_logic_vector(7 downto 0);
		data_v		: in  std_logic_vector(7 downto 0);
		result		: out std_logic_vector(31 downto 0)
	);
	end component;

begin

--==== カスタム命令ステート制御 =====================================

	with n select result <=
		resultyuv_sig   when "000",		-- 3clock latency
		resultpack_reg  when "001",		-- 1clock latency
		resultpack_reg  when "010",		-- 1clock latency
		resultpack_reg  when "011",		-- 1clock latency

		resultblend_sig when "100",		-- 3clock latency
		(others=>'X')	when "101",		-- 1clock latency
		resultsat_reg   when "110",		-- 1clock latency
		resultsat_reg   when "111",		-- 1clock latency

		(others=>'X')   when others;

	done <= done_reg(0);

	process (clk) begin
		if (clk'event and clk='1') then
			if (reset = '1') then
				done_reg <= (others=>'0');

			elsif (clk_en = '1') then

				if (done_reg = 0) then
					if (start = '1') then
						if (n(1 downto 0) = "00") then
							done_reg <= "0100";
						else
							done_reg <= "0001";
						end if;
					end if;
				else
					done_reg <= '0' & done_reg(3 downto 1);
				end if;

			end if;
		end if;
	end process;



--==== バイトレーン演算命令群 =======================================

	process (clk) begin
		if (clk'event and clk='1') then
			case n is
			when "110" =>
				resultsat_reg  <= paddb_sig;
			when "111" =>
				resultsat_reg  <= psubb_sig;
			when others=>
				resultpack_reg <= (others=>'X');
			end case;
		end if;
	end process;


	-- 飽和加算、飽和減算命令(paddb,psubb) 

	sat_u0 : pixelsimd_sat_u8
	port map (
		dataa		=> dataa(7 downto 0),
		datab		=> datab(7 downto 0),
		sadd_result	=> paddb_sig(7 downto 0),
		ssub_result	=> psubb_sig(7 downto 0)
	);

	sat_u1 : pixelsimd_sat_u8
	port map (
		dataa		=> dataa(15 downto 8),
		datab		=> datab(15 downto 8),
		sadd_result	=> paddb_sig(15 downto 8),
		ssub_result	=> psubb_sig(15 downto 8)
	);

	sat_u2 : pixelsimd_sat_u8
	port map (
		dataa		=> dataa(23 downto 16),
		datab		=> datab(23 downto 16),
		sadd_result	=> paddb_sig(23 downto 16),
		ssub_result	=> psubb_sig(23 downto 16)
	);

	sat_u3 : pixelsimd_sat_u8
	port map (
		dataa		=> dataa(31 downto 24),
		datab		=> datab(31 downto 24),
		sadd_result	=> paddb_sig(31 downto 24),
		ssub_result	=> psubb_sig(31 downto 24)
	);


--==== データパッキング命令群 =======================================

	process (clk) begin
		if (clk'event and clk='1') then
			case n is
			when "001" =>
				resultpack_reg <= ppack_sig;
			when "010" =>
				resultpack_reg <= punpack_sig;		-- 下位ワードをアンパック 
			when "011" =>
				resultpack_reg <= punpack_sig;		-- 上位ワードをアンパック 
			when others=>
				resultpack_reg <= (others=>'X');
			end case;
		end if;
	end process;


	-- ピクセルパック命令(ppack) 

	ppack_r0_sig <= dataa(23 downto 16);
	ppack_g0_sig <= dataa(15 downto  8);
	ppack_b0_sig <= dataa( 7 downto  0);
	ppack_r1_sig <= datab(23 downto 16);
	ppack_g1_sig <= datab(15 downto  8);
	ppack_b1_sig <= datab( 7 downto  0);

	ppack_sig(31) <= '0';
	ppack_sig(30 downto 26) <= ppack_r1_sig(7 downto 3);
	ppack_sig(25 downto 21) <= ppack_g1_sig(7 downto 3);
	ppack_sig(20 downto 16) <= ppack_b1_sig(7 downto 3);
	ppack_sig(15) <= '0';
	ppack_sig(14 downto 10) <= ppack_r0_sig(7 downto 3);
	ppack_sig( 9 downto  5) <= ppack_g0_sig(7 downto 3);
	ppack_sig( 4 downto  0) <= ppack_b0_sig(7 downto 3);


	-- ピクセルアンパック命令(punpackl,punpackh) 

	punpack_r_sig <= dataa(14 downto 10) when(n(0) = '0') else dataa(30 downto 26);
	punpack_g_sig <= dataa( 9 downto  5) when(n(0) = '0') else dataa(25 downto 21);
	punpack_b_sig <= dataa( 4 downto  0) when(n(0) = '0') else dataa(20 downto 16);

	punpack_sig(31 downto 24) <= (others=>'0');
	punpack_sig(23 downto 16) <= punpack_r_sig & punpack_r_sig(4 downto 2);
	punpack_sig(15 downto  8) <= punpack_g_sig & punpack_g_sig(4 downto 2);
	punpack_sig( 7 downto  0) <= punpack_b_sig & punpack_b_sig(4 downto 2);



--==== ピクセル変換命令群 ===========================================

	-- ピクセルYUVデコード命令(pyuvdec)

	yuvdec : pixelsimd_yuvdec
	port map(
		clk		=> clk,
		data_y0	=> dataa( 7 downto 0),
		data_y1	=> dataa(15 downto 8),
		data_u	=> datab( 7 downto 0),
		data_v	=> datab(15 downto 8),
		result	=> resultyuv_sig
	);


	-- ピクセルα合成命令(pblend) 

	resultblend_sig(31 downto 24) <= (others=>'0');

	blend_r : pixelsimd_blend_u8
	port map (
		clk		=> clk,
		dataa	=> dataa(23 downto 16),
		datab	=> datab(23 downto 16),
		bland	=> dataa(31 downto 24),
		result	=> resultblend_sig(23 downto 16)
	);

	blend_g : pixelsimd_blend_u8
	port map (
		clk		=> clk,
		dataa	=> dataa(15 downto 8),
		datab	=> datab(15 downto 8),
		bland	=> dataa(31 downto 24),
		result	=> resultblend_sig(15 downto 8)
	);

	blend_b : pixelsimd_blend_u8
	port map (
		clk		=> clk,
		dataa	=> dataa(7 downto 0),
		datab	=> datab(7 downto 0),
		bland	=> dataa(31 downto 24),
		result	=> resultblend_sig(7 downto 0)
	);


end RTL;



----------------------------------------------------------------------
--     (C)2010 Copyright J-7SYSTEM Works.  All rights Reserved.     --
----------------------------------------------------------------------
