----------------------------------------------------------------------
-- TITLE : 8bit alpha blending / Pixel SIMD instruction set for NiosII
--
--     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2010/12/12 -> 2010/12/12 (HERSTELLUNG)
--
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixelsimd_blend_u8 is
	port(
		clk			: in  std_logic;

		dataa		: in  std_logic_vector(7 downto 0);
		datab		: in  std_logic_vector(7 downto 0);
		bland		: in  std_logic_vector(7 downto 0);

		result		: out std_logic_vector(7 downto 0)
	);
end pixelsimd_blend_u8;

architecture RTL of pixelsimd_blend_u8 is
	signal blendb_sig	: std_logic_vector(8 downto 0);

	signal throw_0_reg	: std_logic;
	signal throw_1_reg	: std_logic;
	signal throw_2_reg	: std_logic;
	signal dataa_reg	: std_logic_vector(7 downto 0);
	signal datab_reg	: std_logic_vector(7 downto 0);
	signal blenda_reg	: std_logic_vector(7 downto 0);
	signal blendb_reg	: std_logic_vector(7 downto 0);

	signal multa_sig	: std_logic_vector(15 downto 0);
	signal multb_sig	: std_logic_vector(15 downto 0);
	signal multa_reg	: std_logic_vector(15 downto 0);
	signal multb_reg	: std_logic_vector(15 downto 0);
	signal datab_0_reg	: std_logic_vector(7 downto 0);

	signal multadd_sig	: std_logic_vector(15 downto 0);
	signal result_reg	: std_logic_vector(7 downto 0);

	component pixelsimd_mult_u8xu8
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	end component;

begin

	blendb_sig <= CONV_STD_LOGIC_VECTOR(256, 9) - ('0' & bland);

	u0 : pixelsimd_mult_u8xu8 PORT MAP (
		dataa	=> dataa_reg,
		datab	=> blenda_reg,
		result	=> multa_sig
	);

	u1 : pixelsimd_mult_u8xu8 PORT MAP (
		dataa	=> datab_reg,
		datab	=> blendb_reg,
		result	=> multb_sig
	);

	multadd_sig <= multa_reg + multb_reg;

	result <= result_reg;

	process (clk) begin
		if (clk'event and clk='1') then

			-- 1st cycle 
			if (bland = 0) then
				throw_0_reg <= '1';
			else
				throw_0_reg <= '0';
			end if;

			dataa_reg  <= dataa;
			datab_reg  <= datab;
			blenda_reg <= bland;
			blendb_reg <= blendb_sig(7 downto 0);

			-- 2nd cycle 
			throw_1_reg <= throw_0_reg;
			multa_reg   <= multa_sig;
			multb_reg   <= multb_sig;
			datab_0_reg <= datab_reg;

			-- 3rd cycle 
			if (throw_1_reg = '1') then
				result_reg <= datab_0_reg;
			else
				result_reg <= multadd_sig(15 downto 8);
			end if;

		end if;
	end process;


end RTL;



----------------------------------------------------------------------
--     (C)2010 Copyright J-7SYSTEM Works.  All rights Reserved.     --
----------------------------------------------------------------------
