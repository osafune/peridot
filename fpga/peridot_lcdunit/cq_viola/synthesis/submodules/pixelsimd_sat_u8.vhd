----------------------------------------------------------------------
-- TITLE : 8bit saturation add & sub / Pixel SIMD instruction set for NiosII
--
--     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
--     DATUM     : 2010/12/12 -> 2010/12/12 (HERSTELLUNG)
--
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixelsimd_sat_u8 is
	port(
		dataa		: in  std_logic_vector(7 downto 0);
		datab		: in  std_logic_vector(7 downto 0);
		sadd_result	: out std_logic_vector(7 downto 0);
		ssub_result	: out std_logic_vector(7 downto 0)
	);
end pixelsimd_sat_u8;

architecture RTL of pixelsimd_sat_u8 is
	signal adda_sig		: std_logic_vector(7 downto 0);
	signal addb_sig		: std_logic_vector(7 downto 0);
	signal addq_sig		: std_logic_vector(8 downto 0);

	signal suba_sig		: std_logic_vector(7 downto 0);
	signal subb_sig		: std_logic_vector(7 downto 0);
	signal subq_sig		: std_logic_vector(8 downto 0);

begin

	-- –O˜a‰ÁŽZ–½—ß 

	adda_sig <= dataa;
	addb_sig <= datab;
	addq_sig <= ('0' & adda_sig) + ('0' & addb_sig);

	sadd_result <= addq_sig(7 downto 0) when(addq_sig(8)='0') else (others=>'1');

	-- –O˜aŒ¸ŽZ–½—ß 

	suba_sig <= dataa;
	subb_sig <= datab;
	subq_sig <= ('1' & suba_sig) - ('0' & subb_sig);

	ssub_result <= subq_sig(7 downto 0) when(subq_sig(8)='1') else (others=>'0');


end RTL;



----------------------------------------------------------------------
--     (C)2010 Copyright J-7SYSTEM Works.  All rights Reserved.     --
----------------------------------------------------------------------
