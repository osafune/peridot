-- ===================================================================
-- TITLE : MMC/SD SPI - Read DMA I/F for Avalon Slave
--
--     Design : S.OSAFUNE (J-7SYSTEM Works)
--     Update : 2008/07/15 -> 2008/07/17 (Fixed)
--
--            : 2013/04/03 コメント修正 
--
-- ===================================================================
-- *******************************************************************
--     Copyright (C) 2013, J-7SYSTEM Works.  All rights Reserved.
--
-- * This module is a free sourcecode and there is NO WARRANTY.
-- * No restriction on use. You can use, modify and redistribute it
--   for personal, non-profit or commercial products UNDER YOUR
--   RESPONSIBILITY.
-- * Redistributions of source code must retain the above copyright
--   notice.
-- *******************************************************************

-- データトークンスタートバイト(0xFE)受信とタイムアウトが重なった場合 
-- タイムアウトエラーが優先される 

-- リードDMA起動でMMC I/Fレジスタは 
--		irq_ena='0',nCS='0',TxD=0xFF
-- にオーバーライトされる 


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity avalonif_mmcdma is
	generic(
		SYSTEMCLOCKINFO		: integer := 0		-- 駆動クロック情報(Hz) 
	);
	port(
		clk			: in  std_logic;
		reset		: in  std_logic;

		----- Avalonバス信号 -----------
		chipselect	: in  std_logic;
		address		: in  std_logic_vector(7 downto 0);
		read		: in  std_logic;
		readdata	: out std_logic_vector(31 downto 0);
		write		: in  std_logic;
		writedata	: in  std_logic_vector(31 downto 0);
		irq			: out std_logic;

		----- MMC SPI信号 -----------
			-- 各ピンの信号レベルはLVCMOSに設定すること
		MMC_nCS		: out std_logic;
		MMC_SCK		: out std_logic;
		MMC_SDO		: out std_logic;
		MMC_SDI		: in  std_logic := '1';
		MMC_CD		: in  std_logic := '1';	-- カード挿入検出 (カード挿入で'0') 
		MMC_WP		: in  std_logic := '1'	-- ライトプロテクト検出 (ライトプロテクト時に'0') 
	);
end avalonif_mmcdma;

architecture RTL of avalonif_mmcdma is
	type MMCDMA_STATE is (IDLE, RESSET,RESWAIT, READSET,READWAIT);
	signal state : MMCDMA_STATE;

	signal dmastart_reg		: std_logic;
	signal dmaread_count	: std_logic_vector(8 downto 0);
	signal dmarefcount_reg	: std_logic_vector(8 downto 0);
	signal dmamemwr_reg		: std_logic;
	signal dmamemwr_sig		: std_logic;
	signal dmadone_reg		: std_logic;
	signal dmadataerr_reg	: std_logic;
	signal dmatimout_reg	: std_logic;
	signal dmairqena_reg	: std_logic;
	signal dmairq_sig		: std_logic;
	signal mmcifwr_reg		: std_logic;
	signal mmcifexit_sig	: std_logic;
	signal mmcifzero_sig	: std_logic;
	signal mmcifrxd_sig		: std_logic_vector(7 downto 0);

	signal readdara_reg		: std_logic_vector(31 downto 0);
	signal read_0_sig		: std_logic_vector(31 downto 0);
	signal mmcregsel_sig	: std_logic;
	signal dmaregsel_sig	: std_logic;
	signal memsel_sig		: std_logic;


	component avalonif_mmc
	generic(
		SYSTEMCLOCKINFO		: integer
	);
	port(
		----- Avalonバス信号 -----------
		clk			: in  std_logic;
		reset		: in  std_logic;
		chipselect	: in  std_logic;
		address		: in  std_logic_vector(3 downto 2);
		read		: in  std_logic;
		readdata	: out std_logic_vector(31 downto 0);
		write		: in  std_logic;
		writedata	: in  std_logic_vector(31 downto 0);
		irq			: out std_logic;

		----- MMC SPI信号 -----------
			-- 各ピンの信号レベルはLVCMOSに設定すること
		MMC_nCS		: out std_logic;
		MMC_SCK		: out std_logic;
		MMC_SDO		: out std_logic;
		MMC_SDI		: in  std_logic := '1';
		MMC_CD		: in  std_logic := '1';	-- カード挿入検出 
		MMC_WP		: in  std_logic := '1'	-- ライトプロテクト検出 
	);
	end component;
	signal mmcifaddr_sig	: std_logic_vector(1 downto 0);
	signal mmcifrddata_sig	: std_logic_vector(31 downto 0);
	signal mmcifwrite_sig	: std_logic;
	signal mmcifwrdata_sig	: std_logic_vector(31 downto 0);
	signal mmcifirq_sig		: std_logic;


	component dmamem
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		wraddress	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		wren		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	signal memwraddr_sig	: std_logic_vector(8 downto 0);
	signal memwrdata_sig	: std_logic_vector(7 downto 0);
	signal memwen_sig		: std_logic;
	signal memrdaddr_sig	: std_logic_vector(6 downto 0);
	signal memrddata_sig	: std_logic_vector(31 downto 0);


begin

--==== AvalonBUSインターフェース ====================================

	mmcregsel_sig <= '1' when(chipselect='1' and address(7 downto 2)="000000") else '0';
	dmaregsel_sig <= '1' when(chipselect='1' and address(7 downto 2)="000001") else '0';
	memsel_sig    <= '1' when(chipselect='1' and address(7)='1') else '0';

	irq <= mmcifirq_sig or dmairq_sig;

	readdata <= readdara_reg;

	process (clk) begin
		if (clk'event and clk='1') then
			if (memsel_sig='1') then
				readdara_reg <= memrddata_sig;

			elsif (mmcregsel_sig='1') then
				readdara_reg <= mmcifrddata_sig;

			elsif (dmaregsel_sig='1') then
				readdara_reg <= read_0_sig;

			else
				readdara_reg <= (others=>'0');
			end if;
		end if;
	end process;

	read_0_sig(31 downto 16) <= (others=>'0');
	read_0_sig(15) <= dmairqena_reg;
	read_0_sig(14) <= dmadone_reg;
	read_0_sig(13) <= dmadataerr_reg;
	read_0_sig(12) <= dmatimout_reg;
	read_0_sig(11) <= '0';
	read_0_sig(10) <= dmastart_reg;
	read_0_sig(9)  <= '0';
	read_0_sig(8 downto 0) <= dmarefcount_reg;


	process (clk,reset) begin
		if (reset='1') then
			dmastart_reg   <= '0';
			dmairqena_reg  <= '0';
			dmarefcount_reg<= (others=>'0');

		elsif (clk'event and clk='1') then
			if (dmaregsel_sig='1' and write='1') then
				case address(1 downto 0) is
				when "00" =>
					dmairqena_reg  <= writedata(15);
					dmarefcount_reg<= writedata(8 downto 0);

				when others =>
				end case;
			end if;

			if (dmastart_reg = '0') then
				if (dmaregsel_sig='1' and write='1' and address(1 downto 0)="00") then
					dmastart_reg <= writedata(10);
				end if;
			else
				if (dmadone_reg = '0') then
					dmastart_reg <= '0';
				end if;
			end if;

		end if;
	end process;


--==== リードDMAステートマシン ======================================

	dmairq_sig <= dmadone_reg when dmairqena_reg='1' else '0';

	mmcifexit_sig <= mmcifrddata_sig(9);			-- MMC I/F転送フラグ 
	mmcifzero_sig <= mmcifrddata_sig(12);			-- MMC I/F FRCゼロフラグ 
	mmcifrxd_sig  <= mmcifrddata_sig(7 downto 0);	-- MMC I/F受信データ 

	dmamemwr_sig  <= '1' when(state=READWAIT and mmcifexit_sig='1') else '0';

	process (clk,reset) begin
		if (reset='1') then
			state <= IDLE;
			mmcifwr_reg   <= '0';
			dmaread_count <= (others=>'0');
			dmadone_reg   <= '1';
			dmadataerr_reg<= '0';
			dmatimout_reg <= '0';

		elsif (clk'event and clk='1') then
			case state is
			when IDLE =>
				dmaread_count <= (others=>'0');

				if (dmastart_reg='1') then					-- データリードDMA開始 
					state <= RESSET;
					mmcifwr_reg   <= '1';
					dmadone_reg   <= '0';
					dmadataerr_reg<= '0';
					dmatimout_reg <= '0';
				end if;

			-- データリードレスポンスを待つ 
			when RESSET =>
				state <= RESWAIT;
				mmcifwr_reg <= '0';

			when RESWAIT =>
				if (mmcifexit_sig = '1') then
					if (mmcifzero_sig = '0') then
						if (mmcifrxd_sig = X"FE") then		-- スタートバイト受信 
							state <= READSET;
							mmcifwr_reg <= '1';

						elsif (mmcifrxd_sig = X"FF") then	-- ビジー 
							state <= RESSET;
							mmcifwr_reg <= '1';

						else								-- データエラー 
							state <= IDLE;
							dmadone_reg    <= '1';
							dmadataerr_reg <= '1';
						end if;
					else 									-- 受信タイムアウト 
						state <= IDLE;
						dmadone_reg   <= '1';
						dmatimout_reg <= '1';
					end if;
				end if;

			-- ブロックデータのバーストリード 
			when READSET =>
				state <= READWAIT;
				mmcifwr_reg  <= '0';

			when READWAIT =>
				if (mmcifexit_sig = '1') then
					if (dmaread_count = dmarefcount_reg) then	-- 転送終了 
						state <= IDLE;
						dmadone_reg <= '1';
					else
						state <= READSET;
						mmcifwr_reg  <= '1';
						dmaread_count<= dmaread_count + '1';
					end if;
				end if;


			when others =>
			end case;

		end if;
	end process;


--==== MMC I/Fインスタンス ==========================================

	mmcifaddr_sig  <= "00"        when dmadone_reg='0' else address(1 downto 0);
	mmcifwrdata_sig<= X"000000FF" when dmadone_reg='0' else writedata;
	mmcifwrite_sig <= mmcifwr_reg when dmadone_reg='0' else
						write when mmcregsel_sig='1' else '0';

	U_mmcif : avalonif_mmc
	generic map(
		SYSTEMCLOCKINFO => SYSTEMCLOCKINFO
	)
	port map (
		clk			=> clk,
		reset		=> reset,

		chipselect	=> '1',
		address		=> mmcifaddr_sig,
		read		=> '1',
		readdata	=> mmcifrddata_sig,
		write		=> mmcifwrite_sig,
		writedata	=> mmcifwrdata_sig,
		irq			=> mmcifirq_sig,

		MMC_nCS		=> MMC_nCS,
		MMC_SCK		=> MMC_SCK,
		MMC_SDO		=> MMC_SDO,
		MMC_SDI		=> MMC_SDI,
		MMC_CD		=> MMC_CD,
		MMC_WP		=> MMC_WP
	);


--==== リードバッファインスタンス ===================================

	memrdaddr_sig <= address(6 downto 0);

	memwraddr_sig <= dmaread_count;
	memwrdata_sig <= mmcifrxd_sig;
	memwen_sig    <= dmamemwr_sig;

	U_mem : dmamem
	port map (
		clock		=> clk,
		data		=> memwrdata_sig,
		rdaddress	=> memrdaddr_sig,
		wraddress	=> memwraddr_sig,
		wren		=> memwen_sig,
		q			=> memrddata_sig
	);


end RTL;
