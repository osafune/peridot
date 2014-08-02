-- ===================================================================
-- TITLE : Physicaloid FPGA コンパニオンCPLD (PERIDOT用) 
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2013/08/20 -> 2013/09/03
--     UPDATE : 2013/09/29 ASモード時にmresetでnconfigをアサートするよう修正 
--              2013/10/22 即時送出(SI/WU#)制御ビットを追加 
--
--              2014/08/02 JTAG用GPIOモードを追加 (V1.1)
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2013-2014, J-7SYSTEM Works.  All rights Reserved.
--
-- * This module is a free sourcecode and there is NO WARRANTY.
-- * No restriction on use. You can use, modify and redistribute it
--   for personal, non-profit or commercial products UNDER YOUR
--   RESPONSIBILITY.
-- * Redistributions of source code must retain the above copyright
--   notice.
-- *******************************************************************

-- メモ 
--	ASモード起動でホスト不在（USBを単なる電源ポートとして使う）の場合、FPGA側のSCIFに
--	タイムアウト処理が合った方が良い（AvalonMM Bridgeなら不要） 


-- ●コマンドバイト 
--
--		送信バイト列 : 0x3A nn (2バイト固定)
--
--			bit0 : nCONFIGの値('0'=Lレベル出力 / '1'=Hレベル出力)
--			bit1 : 応答モード設定('0'=通常 / '1'=即時応答)
--			bit2 : 予約(内部チェックサムリードリクエスト用、常に'0'を設定)
--			bit3 : モード設定('0'=コンフィグモード / '1'=ユーザーモード)
--			bit4 : bit7='0'の場合 - I2C SCL出力('0'=Lに駆動 / '1'=Hi-Z)
--				   bit7='1'の場合 - JTAG-TCK出力
--			bit5 : bit7='0'の場合 - I2C SDA出力('0'=Lに駆動 / '1'=Hi-Z)
--				   bit7='1'の場合 - JTAG-TMS出力
--			bit6 : JTAG-TDI出力
--			bit7 : JTAGイネーブル('0'=JTAGスルー / '1'=JTAGイネーブル※次の3Aコマンドまで状態保持)
--
--		返信バイト列 : nn (1バイト固定)
--
--			bit0 : MSEL1の値('0'=PSモード / '1'=ASモード)
--			bit1 : nSTATUSの値('0'=Lレベル / '1'=Hレベル)
--			bit2 : CONF_DONEの値(　〃　)
--			bit3 : FPGA応答のタイムアウト('0'=通常 / '1'=タイムアウト発生)
--			bit4 : I2C SCLの値('0'=Lレベル / '1'=Hレベル)
--			bit5 : I2C SDAの値(　〃　)
--			bit6 : JTAG-TDO入力
--			bit7 : 予約('0'を返す)
--
--
-- ●データバイトエスケーブ 
--
--		0x3Aおよび0x3DはCPLDの中でコマンドバイト、エスケープバイトとして処理されるため、 
--		データ(コンフィグ含む)にこの値が含まれる場合は、下記の手順でエスケープする。 
--
--		・送信 
--			0x3Aおよび0x3Dを送る場合は0x20でxorした値を、0x3Dの後に送る。 
--			エスケープの復元はCPLDで行われる。 
--
--			例）0x01 0x3a 0x7f 0x3d → 0x01 0x3d 0x1a 0x7f 0x3d 0x1d
--                   ^^^^      ^^^^         ~~~~ ^^^^      ~~~~ ^^^^
--		・受信 
--			受信にはエスケープ文字は無し 
--
--
-- ●FPGAのコンフィグレーション 
--
--		ホストからFPGAのコンフィグレーションを行う場合は下記の手順で行う。 
--
--		(1) 0x3A 0x39 を送信。返値のbit0が1の場合はRBFのダウンロードはできない。 
--		(2) 0x3A 0x30 を送信。返値のbit1、bit2が両方とも0になるまで繰り返す。 
--		(3) 0x3A 0x31 を送信。返値のbit1が1になるまで繰り返す。 
--		(4) RBFファイルを送信。0x3A,0x3Dが出現する場合はバイトエスケープをすること。 
--		(5) 0x3A 0x31 を送信。返値のbit1、bit2が両方とも1になっていない場合はエラー。 
--			リトライをする場合は(2)から繰り返す。 
--		(6) 0x3A 0x39 を送信。返値は読み捨てる。ユーザーモードに遷移。 
--
--
-- ●FPGAのホスト側からのリセット 
--
--		なんらかの不具合が発生してFPGAが応答しなくなった場合、2.7秒でタイムアウトする。 
--		タイムアウト後はFPGAの通信が切断され、内部リードのみの動作になる。 
--		タイムアウト状態はコンフィグモード遷移で解除される。 
--		再コンフィグせずにリセットだけ発行する場合は下記の手順で行う。 
--
--		(1) 0x3A 0x31 を送信。返値は読み捨てる。システムリセットがアサートされる。 
--		(2) 0x3A 0x39 を送信。返値は読み捨てる。ユーザーモードに遷移。 
--
--
-- ●FPGAとの通信 
--
--		・フレームフォーマット 
--			１フレーム10ビットの同期式の調歩通信でデータをやりとりする。 
--			ビットフォーマットは1スタート、1ストップ、データ8bit、LSBファースト。 
--			クロックは12MHz、データは双方ともクロックの立ち下がりでセット、立ち上がりでラッチする。 
--			内部ロジックは24MHzの動作とする。 
--
--		・送信側 
--				      0     1     2     3     4     5     6     7     8     9
--		SCLK  __|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|_‥‥ 
--
--		TXD   ~~~~~|_____/ TD0 X TD1 X TD2 X TD3 X TD4 X TD5 X TD6 X TD7 /~~~~~XXXXXXXX‥‥ 
--
--		/TXR  ~~~~~|_____XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX‥‥ 
--
--			nTXRは相手側の受け入れ可能信号。この信号がアサートの時に送信を行う。 
--			※送信状態のまま待機が続いた場合、2.7秒でCPLD側がタイムアウトする。 
--
--		・受信側 
--				      0     1     2     3     4     5     6     7     8     9
--		SCLK  __|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|__|~~|_‥‥ 
--
--		RXD   ~~~~~|_____/ RD0 X RD1 X RD2 X RD3 X RD4 X RD5 X RD6 X RD7 /~~~~~XXXXXXXX‥‥ 
--
--		/RXR  ~~~~~|_____XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX‥‥ 
--
--			nRXRはこちらのデータ受信が可能になったことを相手側に通知する。 
--
--		・通信プロトコル 
--			FPGAとの通信プロトコルはAvalonMM Packet Transactionを実装する。 
--
--
-- 2014/08/02 Syun OSAFUNE <s.osafune@gmail.com>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity psconfig_top is
	port(
		clk24mhz		: in  std_logic;

		ud				: inout std_logic_vector(7 downto 0);	-- FT240 Data
		rd_n			: out std_logic;	-- FT240 Data read signal(Active Low)
		wr				: out std_logic;	-- FT240 Data write signal(Active High)
		rxf_n			: in  std_logic;	-- FT240 Data read ready(Active Low)
		txe_n			: in  std_logic;	-- FT240 Data write ready(Active Low)
		si_wu_n			: out std_logic;	-- FT240 Send Immediate(Active Low)

		dclk			: out std_logic;
		data0			: out std_logic;
		nconfig			: out std_logic;
		nstatus			: in  std_logic;
		confdone		: in  std_logic;
		msel1			: in  std_logic;

		conn_tck_in		: in  std_logic;
		conn_tdi_in		: in  std_logic;
		conn_tdo_out	: out std_logic;
		conn_tms_in		: in  std_logic;
		tck				: out std_logic;
		tdi				: out std_logic;
		tdo				: in  std_logic;
		tms				: out std_logic;

		reset_n_out		: out std_logic;
		sci_sclk		: out std_logic;
		sci_txr_n		: in  std_logic;
		sci_txd			: out std_logic;
		sci_rxr_n		: out std_logic;
		sci_rxd			: in  std_logic;

		i2c_scl			: inout std_logic;
		i2c_sda			: inout std_logic;

		mreset_n_in		: in  std_logic;		-- Manual ResetSW in
		mreset_n_ext	: inout std_logic;		-- External Reset Control
		led_n_out		: out std_logic			-- User LED (Active Low)
	);
end psconfig_top;

architecture RTL of psconfig_top is
	constant WAITRESET_COUNTMAX	: integer := 31;			-- internal reset count(9.6us at 3.33MHz)
	constant TIMEOUT_COUNT		: integer := 67100000;		-- txr timeout count(2.79s at 24MHz)

	component max2_internal_osc
	PORT(
		oscena	: IN STD_LOGIC ;
		osc		: OUT STD_LOGIC 
	);
	end component;
	signal intosc_sig		: std_logic;					-- MAX II internal osc(3.33MHz typ)
	signal intreset_count	: integer range 0 to WAITRESET_COUNTMAX := 0;
	signal intreset_n_reg	: std_logic := '0';
	signal clkdiv_count_reg	: std_logic_vector(1 downto 0);
	signal reset_sig		: std_logic;
	signal clock_sig		: std_logic;
	signal extreset_n_sig	: std_logic;
	signal led_ready_sig	: std_logic;
	signal led_error_sig	: std_logic;
	signal msel1_sig		: std_logic;
	signal mreset_in_sig	: std_logic;
	signal tdoout_reg		: std_logic;


	type CONF_STATE is (IDLE,
						CONFIG_ACK, GETPARAM, SETRESP,
						ESCAPE_ACK, THROW);
	signal psstate : CONF_STATE;
	signal bytedlop_reg		: std_logic;
	signal escape_reg		: std_logic;
	signal usermode_reg		: std_logic;
	signal nconfig_reg		: std_logic;
--	signal nstatus_reg		: std_logic;
--	signal confdone_reg		: std_logic;
	signal timeout_reg		: std_logic;
	signal tocount_reg		: std_logic_vector(25 downto 0);
	signal respdata_sig		: std_logic_vector(7 downto 0);
	signal sclout_reg		: std_logic;
	signal sdaout_reg		: std_logic;
	signal sclin_sig		: std_logic;
	signal sdain_sig		: std_logic;
	signal sendimm_reg		: std_logic;
	signal jtagena_reg		: std_logic;
	signal jtagtdi_reg		: std_logic;
--	signal jtagtdo_reg		: std_logic;
	signal jtagtdo_sig		: std_logic;

	component avalonst_byte_to_usbfifo
	port(
		clock			: in  std_logic;
		reset			: in  std_logic;

		out_ready		: in  std_logic;
		out_valid		: out std_logic;
		out_data		: out std_logic_vector(7 downto 0);

		in_ready		: out std_logic;
		in_valid		: in  std_logic;
		in_data			: in  std_logic_vector(7 downto 0);

		ft_data			: inout std_logic_vector(7 downto 0);
		ft_rd_n			: out std_logic;
		ft_wr			: out std_logic;
		ft_rxf_n		: in  std_logic;
		ft_txe_n		: in  std_logic
	);
	end component;
	signal usb_rxready_sig	: std_logic;
	signal usb_rxdata_sig	: std_logic_vector(7 downto 0);
	signal usb_rxvalid_sig	: std_logic;
	signal usb_txready_sig	: std_logic;
	signal usb_txdata_sig	: std_logic_vector(7 downto 0);
	signal usb_txvalid_sig	: std_logic;

	component avalonst_byte_to_scif
	port(
		clock			: in  std_logic;
		reset			: in  std_logic;

		out_ready		: in  std_logic;
		out_valid		: out std_logic;
		out_data		: out std_logic_vector(7 downto 0);

		in_ready		: out std_logic;
		in_channel		: in  std_logic_vector(0 downto 0);	-- ch.0 : SCI / ch.1 : PSconf
		in_valid		: in  std_logic;
		in_data			: in  std_logic_vector(7 downto 0);

		sci_sclk		: out std_logic;
		sci_txr_n		: in  std_logic;
		sci_txd			: out std_logic;
		sci_rxr_n		: out std_logic;
		sci_rxd			: in  std_logic;

		conf_dclk		: out std_logic;
		conf_data0		: out std_logic
	);
	end component;
	signal sci_rxr_n_sig	: std_logic;
	signal sci_rxready_sig	: std_logic;
	signal sci_rxdata_sig	: std_logic_vector(7 downto 0);
	signal sci_rxvalid_sig	: std_logic;
	signal sci_txready_sig	: std_logic;
	signal sci_txchannel_sig: std_logic_vector(0 downto 0);
	signal sci_txdata_sig	: std_logic_vector(7 downto 0);
	signal sci_txvalid_sig	: std_logic;
	signal confdclk_sig		: std_logic;
	signal confdata0_sig	: std_logic;

begin

	----------------------------------------------
	-- クロック、リセット信号生成 
	----------------------------------------------

	clock_sig <= clk24mhz;

	osc_inst : max2_internal_osc
	port map (
		oscena	=> '1',
		osc		=> intosc_sig
	);

	process (intosc_sig) begin
		if (intosc_sig'event and intosc_sig = '1') then
			if (intreset_count = WAITRESET_COUNTMAX) then
				intreset_n_reg <= '1';
			else
				intreset_count <= intreset_count + 1;
			end if;
		end if;
	end process;

	reset_sig <= not intreset_n_reg;

	mreset_in_sig <= not mreset_n_in;

	mreset_n_ext <= '0' when(mreset_in_sig = '1' or reset_sig = '1' or usermode_reg = '0') else 'Z';
	extreset_n_sig <= mreset_n_ext;

	msel1_sig <= msel1;


	-- LED表示 

	led_ready_sig <= '1' when(usermode_reg = '1' and confdone = '1') else '0';
	led_error_sig <= tocount_reg(22) when(timeout_reg = '1') else '0';

	led_n_out <= '0' when(led_ready_sig = '1' and led_error_sig = '0') else '1';


	-- JTAGスルー接続 

	tck <= conn_tck_in when(jtagena_reg = '0') else sclout_reg;
	tms <= conn_tms_in when(jtagena_reg = '0') else sdaout_reg;
	tdi <= conn_tdi_in when(jtagena_reg = '0') else jtagtdi_reg;
	jtagtdo_sig <= tdo;

	process (conn_tck_in) begin
		if (conn_tck_in'event and conn_tck_in = '0') then
			tdoout_reg <= jtagtdo_sig;
		end if;
	end process;

	conn_tdo_out <= tdoout_reg;



	----------------------------------------------
	-- コンフィグレーションシーケンサ 
	----------------------------------------------

	reset_n_out <= '0' when(usermode_reg = '0') else extreset_n_sig;

	dclk  <= confdclk_sig when(usermode_reg = '0') else 'Z';
	data0 <= confdata0_sig when(usermode_reg = '0') else 'Z';

	nconfig <= '0' when((msel1_sig = '0' and nconfig_reg = '0')or(msel1_sig = '1' and mreset_in_sig = '1')) else 'Z';

	usb_rxready_sig <= usb_rxvalid_sig when(bytedlop_reg = '1' or timeout_reg = '1') else
						sci_txready_sig when(psstate = THROW) else
						'0';
	sci_txvalid_sig <= usb_rxvalid_sig when(psstate = THROW and timeout_reg = '0') else '0';
	sci_txdata_sig <= (usb_rxdata_sig xor X"20") when(escape_reg = '1') else usb_rxdata_sig;
	sci_txchannel_sig <= "0" when(usermode_reg = '1') else "1";

	sci_rxready_sig <= '0' when(psstate = SETRESP) else usb_txready_sig;
	usb_txvalid_sig <= '1' when(psstate = SETRESP) else sci_rxvalid_sig;
	usb_txdata_sig <= respdata_sig when(psstate = SETRESP) else sci_rxdata_sig;

	i2c_scl <= '0' when(sclout_reg = '0' and jtagena_reg = '0') else 'Z';
	sclin_sig <= i2c_scl;
	i2c_sda <= '0' when(sdaout_reg = '0' and jtagena_reg = '0') else 'Z';
	sdain_sig <= i2c_sda;

--	respdata_sig <= "00" & sdain_sig & sclin_sig & timeout_reg & confdone_reg & nstatus_reg & msel1_sig;
	respdata_sig <= '0' & jtagtdo_sig & sdain_sig & sclin_sig & timeout_reg & confdone & nstatus & msel1_sig;

	process (clock_sig, reset_sig) begin
		if (reset_sig = '1') then
			psstate <= IDLE;
			bytedlop_reg <= '0';
			escape_reg   <= '0';
			usermode_reg <= '1';
			nconfig_reg  <= '1';
			timeout_reg  <= '0';
			tocount_reg  <= (others=>'0');
			sclout_reg   <= '1';
			sdaout_reg   <= '1';
			sendimm_reg  <= '0';
			jtagena_reg  <= '0';

		elsif (clock_sig'event and clock_sig = '1') then

			-- メインステートマシン 

			case psstate is
			when IDLE =>
				if (usb_rxvalid_sig = '1') then
					if (usb_rxdata_sig = X"3A") then
						psstate <= CONFIG_ACK;
						bytedlop_reg <= '1';
					elsif (usb_rxdata_sig = X"3D") then
						psstate <= ESCAPE_ACK;
						bytedlop_reg <= '1';
						escape_reg   <= '1';
					else
						psstate <= THROW;
					end if;
				end if;

			when CONFIG_ACK =>
				psstate <= GETPARAM;

			when GETPARAM =>
				if (usb_rxvalid_sig = '1') then
					psstate <= SETRESP;
					bytedlop_reg <= '0';
					nconfig_reg  <= usb_rxdata_sig(0);
					sendimm_reg  <= usb_rxdata_sig(1);
					usermode_reg <= usb_rxdata_sig(3);
					sclout_reg   <= usb_rxdata_sig(4);
					sdaout_reg   <= usb_rxdata_sig(5);
					jtagtdi_reg  <= usb_rxdata_sig(6);
					jtagena_reg  <= usb_rxdata_sig(7);
--					nstatus_reg  <= nstatus;
--					confdone_reg <= confdone;
--					jtagtdo_reg  <= jtagtdo_sig;
				end if;

			when SETRESP =>
				if (usb_txready_sig = '1') then
					psstate <= IDLE;
				end if;

			when ESCAPE_ACK =>
				psstate <= THROW;
				bytedlop_reg <= '0';

			when THROW =>
				if (timeout_reg = '1') then
					psstate <= IDLE;
				elsif (sci_txready_sig = '1') then
					psstate <= IDLE;
					escape_reg <= '0';
				end if;

			end case;


			-- タイムアウトカウンタ処理 

			if (timeout_reg = '1' or(timeout_reg = '0' and psstate = THROW)) then
				tocount_reg <= tocount_reg + 1;
			else
				tocount_reg <= (others=>'0');
			end if;

			if (timeout_reg = '1') then
				if (usermode_reg = '0') then
					timeout_reg <= '0';			-- コンフィグモード遷移でクリア 
				end if;
			else
				if (tocount_reg = TIMEOUT_COUNT) then
					timeout_reg <= '1';
				end if;
			end if;

		end if;
	end process;



	----------------------------------------------
	-- FT245/FPGAインターフェース 
	----------------------------------------------

	-- FT245非同期FIFO 

	si_wu_n <= '0' when(sendimm_reg = '1') else '1';

	inst_ftif : avalonst_byte_to_usbfifo
	port map(
		clock		=> clock_sig,
		reset		=> reset_sig,
		out_ready	=> usb_rxready_sig,
		out_valid	=> usb_rxvalid_sig,
		out_data	=> usb_rxdata_sig,
		in_ready	=> usb_txready_sig,
		in_valid	=> usb_txvalid_sig,
		in_data		=> usb_txdata_sig,

		ft_data		=> ud,
		ft_rd_n		=> rd_n,
		ft_wr		=> wr,
		ft_rxf_n	=> rxf_n,
		ft_txe_n	=> txe_n
	);


	-- FPGA同期シリアル 

	sci_rxr_n <= sci_rxr_n_sig when(usermode_reg = '1') else '1';

	inst_scif : avalonst_byte_to_scif
	port map(
		clock		=> clock_sig,
		reset		=> reset_sig,
		out_ready	=> sci_rxready_sig,
		out_valid	=> sci_rxvalid_sig,
		out_data	=> sci_rxdata_sig,
		in_ready	=> sci_txready_sig,
		in_channel	=> sci_txchannel_sig,
		in_valid	=> sci_txvalid_sig,
		in_data		=> sci_txdata_sig,

		sci_sclk	=> sci_sclk,
		sci_txr_n	=> sci_txr_n,
		sci_txd		=> sci_txd,
		sci_rxr_n	=> sci_rxr_n_sig,
		sci_rxd		=> sci_rxd,

		conf_dclk	=> confdclk_sig,
		conf_data0	=> confdata0_sig
	);



end RTL;


