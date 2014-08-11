----------------------------------------------------------------------
-- TITLE : YUV422 -> RGB555 decode / Pixel SIMD instruction set for NiosII
--
--     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2008/10/31 -> 2008/10/31 (HERSTELLUNG)
--               : 2008/12/28 (FESTSTELLUNG)
--
--               : 2010/12/12 CycloneIIIŒü‚¯‰ü‘¢ (NEUBEARBEITUNG)
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixelsimd_yuvdec is
	port(
		clk			: in  std_logic;

		data_y0		: in  std_logic_vector(7 downto 0);
		data_y1		: in  std_logic_vector(7 downto 0);
		data_u		: in  std_logic_vector(7 downto 0);
		data_v		: in  std_logic_vector(7 downto 0);

		result		: out std_logic_vector(31 downto 0)
	);
end pixelsimd_yuvdec;

architecture RTL of pixelsimd_yuvdec is
	signal data_y0_reg	: std_logic_vector(7 downto 0);
	signal data_y1_reg	: std_logic_vector(7 downto 0);
	signal data_u_reg	: std_logic_vector(7 downto 0);
	signal data_v_reg	: std_logic_vector(7 downto 0);

	signal mult_u0_sig	: std_logic_vector(17 downto 0);
	signal mult_v0_sig	: std_logic_vector(17 downto 0);
	signal mult_u1_sig	: std_logic_vector(17 downto 0);
	signal mult_v1_sig	: std_logic_vector(17 downto 0);

	signal add_y0_reg	: std_logic_vector(7 downto 0);
	signal add_y1_reg	: std_logic_vector(7 downto 0);
	signal mult_u0_reg	: std_logic_vector(17 downto 0);
	signal mult_v0_reg	: std_logic_vector(17 downto 0);
	signal mult_u1_reg	: std_logic_vector(17 downto 0);
	signal mult_v1_reg	: std_logic_vector(17 downto 0);

	signal add_r0_sig	: std_logic_vector(17 downto 0);
	signal add_g0_sig	: std_logic_vector(17 downto 0);
	signal add_b0_sig	: std_logic_vector(17 downto 0);
	signal sat_r0_sig	: std_logic_vector(4 downto 0);
	signal sat_g0_sig	: std_logic_vector(4 downto 0);
	signal sat_b0_sig	: std_logic_vector(4 downto 0);
	signal add_r1_sig	: std_logic_vector(17 downto 0);
	signal add_g1_sig	: std_logic_vector(17 downto 0);
	signal add_b1_sig	: std_logic_vector(17 downto 0);
	signal sat_r1_sig	: std_logic_vector(4 downto 0);
	signal sat_g1_sig	: std_logic_vector(4 downto 0);
	signal sat_b1_sig	: std_logic_vector(4 downto 0);

	signal rgb0_reg		: std_logic_vector(14 downto 0);
	signal rgb1_reg		: std_logic_vector(14 downto 0);

	component pixelsimd_mult_s8xs10
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
	);
	end component;

begin

	u0 : pixelsimd_mult_s8xs10
	PORT MAP (
		dataa	=> data_u_reg,
		datab	=> CONV_STD_LOGIC_VECTOR(454, 10),
		result	=> mult_u0_sig
	);

	v0 : pixelsimd_mult_s8xs10
	PORT MAP (
		dataa	=> data_v_reg,
		datab	=> CONV_STD_LOGIC_VECTOR(359, 10),
		result	=> mult_v0_sig
	);

	u1 : pixelsimd_mult_s8xs10
	PORT MAP (
		dataa	=> data_u_reg,
		datab	=> CONV_STD_LOGIC_VECTOR(-88, 10),
		result	=> mult_u1_sig
	);

	v1 : pixelsimd_mult_s8xs10
	PORT MAP (
		dataa	=> data_v_reg,
		datab	=> CONV_STD_LOGIC_VECTOR(-183, 10),
		result	=> mult_v1_sig
	);


	add_r0_sig <= ("00" & add_y0_reg & "00000000") + mult_v0_reg;
	sat_r0_sig <= (others=>'0') when(add_r0_sig(17) = '1') else
				 (others=>'1') when(add_r0_sig(16) = '1') else
				 add_r0_sig(15 downto 11);

	add_g0_sig <= ("00" & add_y0_reg & "00000000") + mult_u1_reg + mult_v1_reg;
	sat_g0_sig <= (others=>'0') when(add_g0_sig(17) = '1') else
				 (others=>'1') when(add_g0_sig(16) = '1') else
				 add_g0_sig(15 downto 11);

	add_b0_sig <= ("00" & add_y0_reg & "00000000") + mult_u0_reg;
	sat_b0_sig <= (others=>'0') when(add_b0_sig(17) = '1') else
				 (others=>'1') when(add_b0_sig(16) = '1') else
				 add_b0_sig(15 downto 11);


	add_r1_sig <= ("00" & add_y1_reg & "00000000") + mult_v0_reg;
	sat_r1_sig <= (others=>'0') when(add_r1_sig(17) = '1') else
				 (others=>'1') when(add_r1_sig(16) = '1') else
				 add_r1_sig(15 downto 11);

	add_g1_sig <= ("00" & add_y1_reg & "00000000") + mult_u1_reg + mult_v1_reg;
	sat_g1_sig <= (others=>'0') when(add_g1_sig(17) = '1') else
				 (others=>'1') when(add_g1_sig(16) = '1') else
				 add_g1_sig(15 downto 11);

	add_b1_sig <= ("00" & add_y1_reg & "00000000") + mult_u0_reg;
	sat_b1_sig <= (others=>'0') when(add_b1_sig(17) = '1') else
				 (others=>'1') when(add_b1_sig(16) = '1') else
				 add_b1_sig(15 downto 11);


	result <= '0' & rgb1_reg & '0' & rgb0_reg;

	process (clk) begin
		if (clk'event and clk='1') then

			-- 1st cycle 
			data_y0_reg <= data_y0;
			data_y1_reg <= data_y1;
			data_u_reg  <= data_u - 128;
			data_v_reg  <= data_v - 128;

			-- 2nd cycle 
			add_y0_reg  <= data_y0_reg;
			add_y1_reg  <= data_y1_reg;
			mult_u0_reg <= mult_u0_sig;
			mult_v0_reg <= mult_v0_sig;
			mult_u1_reg <= mult_u1_sig;
			mult_v1_reg <= mult_v1_sig;

			-- 3rd cycle 
			rgb0_reg <= sat_r0_sig & sat_g0_sig & sat_b0_sig;
			rgb1_reg <= sat_r1_sig & sat_g1_sig & sat_b1_sig;

		end if;
	end process;


end RTL;



----------------------------------------------------------------------
--   (C)2008,2010 Copyright J-7SYSTEM Works.  All rights Reserved.  --
----------------------------------------------------------------------
