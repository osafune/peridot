-- ===================================================================
-- TITLE : VRAM DMA 
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/05/10 -> 2014/05/12
--            : 2014/05/12 (FIXED)
--
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2014, J-7SYSTEM Works.  All rights Reserved.
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
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity lcdc_dma is
	generic(
		VRAM_LINEBYTES		: integer := 1024*2;
		VRAM_VIEWWIDTH		: integer := 240;
		VRAM_VIEWHEIGHT		: integer := 320
--		VRAM_VIEWWIDTH		: integer := 24;	-- test
--		VRAM_VIEWHEIGHT		: integer := 3		-- test
	);
	port(
		clk				: in  std_logic;
		reset			: in  std_logic;
		test_usedw		: out std_logic_vector(8 downto 0);

		topaddr			: in  std_logic_vector(30 downto 0);
		start			: in  std_logic;
		ready			: out std_logic;
		wrreq			: out std_logic;
		wrack			: in  std_logic;
		wrdata			: out std_logic_vector(7 downto 0);

		address			: out std_logic_vector(30 downto 0);
		waitrequest		: in  std_logic;
		burstcount		: out std_logic_vector(3 downto 0);		-- 8 burst
		read			: out std_logic;
		readdata		: in  std_logic_vector(15 downto 0);
		readdatavalid	: in  std_logic
	);
end lcdc_dma;

architecture RTL of lcdc_dma is
	constant DMABURSTCOUNT	: integer := 8;
	constant DMAFIFODEPTH	: integer := 256;
--	constant DMAFIFODEPTH	: integer := 32;	-- test
	constant LINEBURSTCYCLE	: integer := (VRAM_VIEWWIDTH + (DMABURSTCOUNT-1))/DMABURSTCOUNT;
	constant LINEOFFSET		: integer := VRAM_LINEBYTES - (LINEBURSTCYCLE*DMABURSTCOUNT*2);

	signal start_in_reg		: std_logic_vector(2 downto 0);
	signal start_sig		: std_logic;
	signal ready_reg		: std_logic;
	signal memaddr_reg		: std_logic_vector(30 downto 0);
	signal linecyclecount	: integer range 0 to LINEBURSTCYCLE-1;
	signal linenumcount		: integer range 0 to VRAM_VIEWHEIGHT-1;

	type DEF_DMA_STATE is (IDLE, READISSUE, DATAWAIT, DONE);
	signal dma_state : DEF_DMA_STATE;
	signal datacount		: integer range 0 to DMABURSTCOUNT-1;
	signal address_sig		: std_logic_vector(30 downto 0);
	signal read_reg			: std_logic;
	signal dma_rdreq_sig	: std_logic;
	signal dma_rdack_sig	: std_logic;
	signal pixel_r_sig		: std_logic_vector(4 downto 0);
	signal pixel_g_sig		: std_logic_vector(5 downto 0);
	signal pixel_b_sig		: std_logic_vector(4 downto 0);
	signal pixelpack_sig	: std_logic_vector(15 downto 0);

	component lcdc_dmafifo
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
	end component;
	signal fifo_data_sig	: std_logic_vector(15 downto 0);
	signal fifo_usedw_sig	: std_logic_vector(8 downto 0);
	signal fifo_empty_sig	: std_logic;
	signal fifo_q_sig		: std_logic_vector(7 downto 0);
	signal fifo_rdack_sig	: std_logic;

begin

	test_usedw <= fifo_usedw_sig;


--==== フレームバッファの転送 ========================================

	-- スタート信号のエッジ検出＆同期化 

	process (clk, reset) begin
		if (reset = '1') then
			start_in_reg <= "000";
		elsif rising_edge(clk) then
			start_in_reg <= start_in_reg(1 downto 0) & start;
		end if;
	end process;

	start_sig <= '1' when(start_in_reg(2 downto 1) = "01") else '0';


	-- メモリの２次元スキャン 

	ready <= '1' when(ready_reg = '1' and fifo_empty_sig = '1') else '0';
	address_sig <= memaddr_reg;

	process (clk, reset) begin
		if (reset = '1') then
			ready_reg <= '1';

		elsif rising_edge(clk) then
			if (ready_reg = '1') then
				if (start_sig = '1') then
					ready_reg <= '0';
					memaddr_reg    <= topaddr;
					linecyclecount <= LINEBURSTCYCLE-1;
					linenumcount   <= VRAM_VIEWHEIGHT-1;
				end if;
			else
				if (dma_rdack_sig = '1') then
					if (linecyclecount = 0) then
						linecyclecount <= LINEBURSTCYCLE-1;
						memaddr_reg <= memaddr_reg + (DMABURSTCOUNT*2) + LINEOFFSET;

						if (linenumcount = 0) then
							ready_reg <= '1';
						else
							linenumcount <= linenumcount - 1;
						end if;

					else
						linecyclecount <= linecyclecount - 1;
						memaddr_reg <= memaddr_reg + (DMABURSTCOUNT*2);

					end if;
				end if;
			end if;

		end if;
	end process;


	-- LCDCアクセスコントローラへの信号 

	wrreq  <= '1' when(fifo_empty_sig = '0') else '0';
	wrdata <= fifo_q_sig;
	fifo_rdack_sig <= wrack;



--==== メモリからバーストリード ======================================

	-- メモリコントローラへのアクセス 

	address <= address_sig(30 downto 1) & '0';
	burstcount <= conv_std_logic_vector(DMABURSTCOUNT, burstcount'length);
	read <= read_reg;

	dma_rdreq_sig <= '1' when(ready_reg = '0' and fifo_usedw_sig<(DMAFIFODEPTH-DMABURSTCOUNT*2)) else '0';
	dma_rdack_sig <= '1' when(dma_state = DONE) else '0';

	process (clk, reset) begin
		if (reset = '1') then
			dma_state <= IDLE;
			read_reg <= '0';

		elsif rising_edge(clk) then
			case dma_state is
			when IDLE =>
				if (dma_rdreq_sig = '1') then
					dma_state <= READISSUE;
					read_reg  <= '1';
				end if;

			when READISSUE =>
				if (waitrequest = '0') then
					dma_state <= DATAWAIT;
					read_reg  <= '0';
					datacount <= DMABURSTCOUNT-1;
				end if;

			when DATAWAIT =>
				if (readdatavalid = '1') then
					if (datacount = 0) then
						dma_state <= DONE;
					else
						datacount <= datacount - 1;
					end if;
				end if;

			when DONE =>
				dma_state <= IDLE;

			end case;

		end if;
	end process;


	-- サブピクセル処理 

	pixel_r_sig <= readdata(14 downto 10);
	pixel_g_sig <= readdata(9 downto 5) & readdata(9);
	pixel_b_sig <= readdata(4 downto 0);

	pixelpack_sig <= pixel_r_sig & pixel_g_sig & pixel_b_sig;
	fifo_data_sig <= pixelpack_sig(7 downto 0) & pixelpack_sig(15 downto 8);


	-- DMAFIFOとバス幅変換 

	U0 : lcdc_dmafifo
	PORT MAP (
		aclr		=> reset,

		wrclk		=> clk,
		wrusedw		=> fifo_usedw_sig,
		wrreq		=> readdatavalid,
		data		=> fifo_data_sig,

		rdclk		=> clk,
		rdempty	 	=> fifo_empty_sig,
		rdreq		=> fifo_rdack_sig,
		q			=> fifo_q_sig
	);



end RTL;


