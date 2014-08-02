-- Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus II License Agreement,
-- the Altera MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Altera and sold by Altera or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 14.0.0 Build 200 06/17/2014 SJ Web Edition"

-- DATE "08/03/2014 03:53:35"

-- 
-- Device: Altera 5M160ZE64C5 Package EQFP64
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE;
LIBRARY MAXV;
USE IEEE.STD_LOGIC_1164.ALL;
USE MAXV.MAXV_COMPONENTS.ALL;

ENTITY 	psconfig_top IS
    PORT (
	clk24mhz : IN std_logic;
	ud : BUFFER std_logic_vector(7 DOWNTO 0);
	rd_n : BUFFER std_logic;
	wr : BUFFER std_logic;
	rxf_n : IN std_logic;
	txe_n : IN std_logic;
	si_wu_n : BUFFER std_logic;
	dclk : BUFFER std_logic;
	data0 : BUFFER std_logic;
	nconfig : BUFFER std_logic;
	nstatus : IN std_logic;
	confdone : IN std_logic;
	msel1 : IN std_logic;
	conn_tck_in : IN std_logic;
	conn_tdi_in : IN std_logic;
	conn_tdo_out : BUFFER std_logic;
	conn_tms_in : IN std_logic;
	tck : BUFFER std_logic;
	tdi : BUFFER std_logic;
	tdo : IN std_logic;
	tms : BUFFER std_logic;
	reset_n_out : BUFFER std_logic;
	sci_sclk : BUFFER std_logic;
	sci_txr_n : IN std_logic;
	sci_txd : BUFFER std_logic;
	sci_rxr_n : BUFFER std_logic;
	sci_rxd : IN std_logic;
	i2c_scl : BUFFER std_logic;
	i2c_sda : BUFFER std_logic;
	mreset_n_in : IN std_logic;
	mreset_n_ext : BUFFER std_logic;
	led_n_out : BUFFER std_logic
	);
END psconfig_top;

-- Design Ports Information
-- rd_n	=>  Location: PIN_5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- wr	=>  Location: PIN_4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- si_wu_n	=>  Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- dclk	=>  Location: PIN_58,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- data0	=>  Location: PIN_59,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- nconfig	=>  Location: PIN_30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- conn_tdo_out	=>  Location: PIN_63,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- tck	=>  Location: PIN_55,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- tdi	=>  Location: PIN_56,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- tms	=>  Location: PIN_54,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- reset_n_out	=>  Location: PIN_50,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- sci_sclk	=>  Location: PIN_49,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- sci_txd	=>  Location: PIN_47,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- sci_rxr_n	=>  Location: PIN_52,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- led_n_out	=>  Location: PIN_61,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[0]	=>  Location: PIN_24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[1]	=>  Location: PIN_18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[2]	=>  Location: PIN_19,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[3]	=>  Location: PIN_10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[4]	=>  Location: PIN_20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[5]	=>  Location: PIN_12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[6]	=>  Location: PIN_11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- ud[7]	=>  Location: PIN_13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- i2c_scl	=>  Location: PIN_26,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
-- i2c_sda	=>  Location: PIN_25,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
-- mreset_n_ext	=>  Location: PIN_27,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
-- conn_tck_in	=>  Location: PIN_1,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: Default
-- conn_tdi_in	=>  Location: PIN_2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- conn_tms_in	=>  Location: PIN_64,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- confdone	=>  Location: PIN_31,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- clk24mhz	=>  Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- mreset_n_in	=>  Location: PIN_62,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: Default
-- msel1	=>  Location: PIN_32,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- tdo	=>  Location: PIN_53,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sci_txr_n	=>  Location: PIN_51,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- nstatus	=>  Location: PIN_29,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- rxf_n	=>  Location: PIN_22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- txe_n	=>  Location: PIN_21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sci_rxd	=>  Location: PIN_48,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF psconfig_top IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk24mhz : std_logic;
SIGNAL ww_ud : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_rd_n : std_logic;
SIGNAL ww_wr : std_logic;
SIGNAL ww_rxf_n : std_logic;
SIGNAL ww_txe_n : std_logic;
SIGNAL ww_si_wu_n : std_logic;
SIGNAL ww_dclk : std_logic;
SIGNAL ww_data0 : std_logic;
SIGNAL ww_nconfig : std_logic;
SIGNAL ww_nstatus : std_logic;
SIGNAL ww_confdone : std_logic;
SIGNAL ww_msel1 : std_logic;
SIGNAL ww_conn_tck_in : std_logic;
SIGNAL ww_conn_tdi_in : std_logic;
SIGNAL ww_conn_tdo_out : std_logic;
SIGNAL ww_conn_tms_in : std_logic;
SIGNAL ww_tck : std_logic;
SIGNAL ww_tdi : std_logic;
SIGNAL ww_tdo : std_logic;
SIGNAL ww_tms : std_logic;
SIGNAL ww_reset_n_out : std_logic;
SIGNAL ww_sci_sclk : std_logic;
SIGNAL ww_sci_txr_n : std_logic;
SIGNAL ww_sci_txd : std_logic;
SIGNAL ww_sci_rxr_n : std_logic;
SIGNAL ww_sci_rxd : std_logic;
SIGNAL ww_i2c_scl : std_logic;
SIGNAL ww_i2c_sda : std_logic;
SIGNAL ww_mreset_n_in : std_logic;
SIGNAL ww_mreset_n_ext : std_logic;
SIGNAL ww_led_n_out : std_logic;
SIGNAL \osc_inst|max2_internal_osc_altufm_osc_lv5_component|maxii_ufm_block1~drdout\ : std_logic;
SIGNAL \ud[0]~0\ : std_logic;
SIGNAL \ud[1]~1\ : std_logic;
SIGNAL \ud[2]~2\ : std_logic;
SIGNAL \ud[3]~3\ : std_logic;
SIGNAL \ud[4]~4\ : std_logic;
SIGNAL \ud[5]~5\ : std_logic;
SIGNAL \ud[6]~6\ : std_logic;
SIGNAL \ud[7]~7\ : std_logic;
SIGNAL \i2c_scl~0\ : std_logic;
SIGNAL \i2c_sda~0\ : std_logic;
SIGNAL \mreset_n_ext~0\ : std_logic;
SIGNAL \clk24mhz~combout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_3~0_combout\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\ : std_logic;
SIGNAL \intreset_count[1]~3\ : std_logic;
SIGNAL \intreset_count[1]~3COUT1_14\ : std_logic;
SIGNAL \intreset_count[2]~5\ : std_logic;
SIGNAL \intreset_count[2]~5COUT1_16\ : std_logic;
SIGNAL \intreset_count[3]~7\ : std_logic;
SIGNAL \intreset_count[3]~7COUT1_18\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL \Equal0~1_combout\ : std_logic;
SIGNAL \intreset_n_reg~regout\ : std_logic;
SIGNAL \inst_ftif|outdata_reg[7]~0_combout\ : std_logic;
SIGNAL \Equal1~0\ : std_logic;
SIGNAL \Equal1~1\ : std_logic;
SIGNAL \psstate.state_bit_1~1\ : std_logic;
SIGNAL \psstate.state_bit_2~regout\ : std_logic;
SIGNAL \psstate.state_bit_1~0_combout\ : std_logic;
SIGNAL \psstate.state_bit_1~regout\ : std_logic;
SIGNAL \psstate.state_bit_0~5_combout\ : std_logic;
SIGNAL \psstate.SETRESP~0_combout\ : std_logic;
SIGNAL \process_2~0_combout\ : std_logic;
SIGNAL \tocount_reg[0]~11\ : std_logic;
SIGNAL \tocount_reg[0]~11COUT1_74\ : std_logic;
SIGNAL \tocount_reg[1]~33\ : std_logic;
SIGNAL \tocount_reg[1]~33COUT1_76\ : std_logic;
SIGNAL \tocount_reg[2]~35\ : std_logic;
SIGNAL \tocount_reg[3]~41\ : std_logic;
SIGNAL \tocount_reg[3]~41COUT1_78\ : std_logic;
SIGNAL \tocount_reg[4]~43\ : std_logic;
SIGNAL \tocount_reg[4]~43COUT1_80\ : std_logic;
SIGNAL \tocount_reg[5]~37\ : std_logic;
SIGNAL \tocount_reg[5]~37COUT1_82\ : std_logic;
SIGNAL \tocount_reg[6]~39\ : std_logic;
SIGNAL \tocount_reg[6]~39COUT1_84\ : std_logic;
SIGNAL \tocount_reg[7]~17\ : std_logic;
SIGNAL \tocount_reg[8]~13\ : std_logic;
SIGNAL \tocount_reg[8]~13COUT1_86\ : std_logic;
SIGNAL \tocount_reg[9]~19\ : std_logic;
SIGNAL \tocount_reg[9]~19COUT1_88\ : std_logic;
SIGNAL \tocount_reg[10]~15\ : std_logic;
SIGNAL \tocount_reg[10]~15COUT1_90\ : std_logic;
SIGNAL \tocount_reg[11]~3\ : std_logic;
SIGNAL \tocount_reg[11]~3COUT1_92\ : std_logic;
SIGNAL \tocount_reg[12]~5\ : std_logic;
SIGNAL \tocount_reg[13]~9\ : std_logic;
SIGNAL \tocount_reg[13]~9COUT1_94\ : std_logic;
SIGNAL \timeout_reg~0_combout\ : std_logic;
SIGNAL \tocount_reg[14]~7\ : std_logic;
SIGNAL \tocount_reg[14]~7COUT1_96\ : std_logic;
SIGNAL \tocount_reg[15]~45\ : std_logic;
SIGNAL \tocount_reg[15]~45COUT1_98\ : std_logic;
SIGNAL \tocount_reg[16]~47\ : std_logic;
SIGNAL \tocount_reg[16]~47COUT1_100\ : std_logic;
SIGNAL \tocount_reg[17]~49\ : std_logic;
SIGNAL \tocount_reg[18]~51\ : std_logic;
SIGNAL \tocount_reg[18]~51COUT1_102\ : std_logic;
SIGNAL \tocount_reg[19]~21\ : std_logic;
SIGNAL \tocount_reg[19]~21COUT1_104\ : std_logic;
SIGNAL \tocount_reg[20]~23\ : std_logic;
SIGNAL \tocount_reg[20]~23COUT1_106\ : std_logic;
SIGNAL \tocount_reg[21]~25\ : std_logic;
SIGNAL \tocount_reg[21]~25COUT1_108\ : std_logic;
SIGNAL \tocount_reg[22]~1\ : std_logic;
SIGNAL \tocount_reg[23]~27\ : std_logic;
SIGNAL \tocount_reg[23]~27COUT1_110\ : std_logic;
SIGNAL \tocount_reg[24]~29\ : std_logic;
SIGNAL \tocount_reg[24]~29COUT1_112\ : std_logic;
SIGNAL \timeout_reg~2_combout\ : std_logic;
SIGNAL \timeout_reg~3_combout\ : std_logic;
SIGNAL \timeout_reg~4_combout\ : std_logic;
SIGNAL \timeout_reg~5_combout\ : std_logic;
SIGNAL \timeout_reg~6_combout\ : std_logic;
SIGNAL \timeout_reg~1_combout\ : std_logic;
SIGNAL \timeout_reg~7_combout\ : std_logic;
SIGNAL \sendimm_reg~0_combout\ : std_logic;
SIGNAL \usermode_reg~regout\ : std_logic;
SIGNAL \timeout_reg~regout\ : std_logic;
SIGNAL \inst_scif|in_ready~0_combout\ : std_logic;
SIGNAL \inst_scif|sclk_reg~regout\ : std_logic;
SIGNAL \sci_txr_n~combout\ : std_logic;
SIGNAL \inst_scif|txready_reg~regout\ : std_logic;
SIGNAL \inst_scif|process_0~0_combout\ : std_logic;
SIGNAL \inst_scif|outdata_reg[0]~1_combout\ : std_logic;
SIGNAL \inst_scif|Equal3~0_combout\ : std_logic;
SIGNAL \inst_scif|Add0~0_combout\ : std_logic;
SIGNAL \inst_scif|txcounter[1]~1_combout\ : std_logic;
SIGNAL \inst_scif|Add0~1_combout\ : std_logic;
SIGNAL \inst_scif|Equal1~0_combout\ : std_logic;
SIGNAL \psstate.state_bit_0~2_combout\ : std_logic;
SIGNAL \psstate.state_bit_0~3_combout\ : std_logic;
SIGNAL \escape_reg~0\ : std_logic;
SIGNAL \psstate.state_bit_0~regout\ : std_logic;
SIGNAL \txe_n~combout\ : std_logic;
SIGNAL \sci_rxd~combout\ : std_logic;
SIGNAL \inst_scif|rxd_reg~regout\ : std_logic;
SIGNAL \inst_scif|Add1~5_combout\ : std_logic;
SIGNAL \inst_scif|rxcounter[0]~3_combout\ : std_logic;
SIGNAL \inst_scif|indata_reg[0]~0_combout\ : std_logic;
SIGNAL \inst_scif|Add1~7\ : std_logic;
SIGNAL \inst_scif|Add1~7COUT1_25\ : std_logic;
SIGNAL \inst_scif|Add1~15_combout\ : std_logic;
SIGNAL \inst_scif|Equal4~0_combout\ : std_logic;
SIGNAL \inst_scif|rxcounter[2]~0_combout\ : std_logic;
SIGNAL \inst_scif|rxcounter[2]~1_combout\ : std_logic;
SIGNAL \inst_scif|Add1~17\ : std_logic;
SIGNAL \inst_scif|Add1~17COUT1_27\ : std_logic;
SIGNAL \inst_scif|Add1~10_combout\ : std_logic;
SIGNAL \inst_scif|Add1~12\ : std_logic;
SIGNAL \inst_scif|Add1~12COUT1_29\ : std_logic;
SIGNAL \inst_scif|Add1~0_combout\ : std_logic;
SIGNAL \inst_scif|Equal0~0_combout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_0~4\ : std_logic;
SIGNAL \rxf_n~combout\ : std_logic;
SIGNAL \inst_ftif|process_1~0\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_0~2_combout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_0~regout\ : std_logic;
SIGNAL \inst_ftif|ifstate.FT_WRWAIT2~0_combout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_3~regout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_2~regout\ : std_logic;
SIGNAL \Selector6~0_combout\ : std_logic;
SIGNAL \bytedlop_reg~regout\ : std_logic;
SIGNAL \inst_ftif|outvalid_reg~0_combout\ : std_logic;
SIGNAL \inst_ftif|outvalid_reg~regout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_1~0_combout\ : std_logic;
SIGNAL \inst_ftif|ifstate.state_bit_1~regout\ : std_logic;
SIGNAL \inst_ftif|ifstate.IDLE~0_combout\ : std_logic;
SIGNAL \inst_ftif|Selector9~0_combout\ : std_logic;
SIGNAL \inst_ftif|ft_rd_reg~regout\ : std_logic;
SIGNAL \inst_ftif|Selector10~0_combout\ : std_logic;
SIGNAL \inst_ftif|ft_wr_reg~regout\ : std_logic;
SIGNAL \sendimm_reg~regout\ : std_logic;
SIGNAL \inst_scif|confmode_reg~0_combout\ : std_logic;
SIGNAL \inst_scif|confmode_reg~regout\ : std_logic;
SIGNAL \inst_scif|dclk_reg~regout\ : std_logic;
SIGNAL \psstate.THROW~0_combout\ : std_logic;
SIGNAL \escape_reg~1_combout\ : std_logic;
SIGNAL \escape_reg~regout\ : std_logic;
SIGNAL \msel1~combout\ : std_logic;
SIGNAL \mreset_n_in~combout\ : std_logic;
SIGNAL \nconfig_reg~regout\ : std_logic;
SIGNAL \nconfig~1_combout\ : std_logic;
SIGNAL \conn_tck_in~combout\ : std_logic;
SIGNAL \tdo~combout\ : std_logic;
SIGNAL \tdoout_reg~regout\ : std_logic;
SIGNAL \sclout_reg~regout\ : std_logic;
SIGNAL \tck~0\ : std_logic;
SIGNAL \jtagena_reg~regout\ : std_logic;
SIGNAL \jtagtdi_reg~regout\ : std_logic;
SIGNAL \conn_tdi_in~combout\ : std_logic;
SIGNAL \tdi~0_combout\ : std_logic;
SIGNAL \sdaout_reg~regout\ : std_logic;
SIGNAL \conn_tms_in~combout\ : std_logic;
SIGNAL \tms~0_combout\ : std_logic;
SIGNAL \reset_n_out~0_combout\ : std_logic;
SIGNAL \inst_scif|sci_txd~0_combout\ : std_logic;
SIGNAL \inst_scif|rxready_reg~regout\ : std_logic;
SIGNAL \sci_rxr_n~0_combout\ : std_logic;
SIGNAL \confdone~combout\ : std_logic;
SIGNAL \led_n_out~0_combout\ : std_logic;
SIGNAL \nstatus~combout\ : std_logic;
SIGNAL \inst_scif|indata_reg[0]~1_combout\ : std_logic;
SIGNAL \usb_txdata_sig[0]~0\ : std_logic;
SIGNAL \inst_ftif|ft_doe_reg~regout\ : std_logic;
SIGNAL \usb_txdata_sig[1]~1\ : std_logic;
SIGNAL \usb_txdata_sig[2]~2\ : std_logic;
SIGNAL \usb_txdata_sig[3]~3\ : std_logic;
SIGNAL \usb_txdata_sig[4]~4\ : std_logic;
SIGNAL \usb_txdata_sig[5]~5\ : std_logic;
SIGNAL \usb_txdata_sig[6]~6\ : std_logic;
SIGNAL \usb_txdata_sig[7]~7\ : std_logic;
SIGNAL \i2c_scl~2_combout\ : std_logic;
SIGNAL \i2c_sda~2_combout\ : std_logic;
SIGNAL \mreset_n_ext~2_combout\ : std_logic;
SIGNAL tocount_reg : std_logic_vector(25 DOWNTO 0);
SIGNAL intreset_count : std_logic_vector(4 DOWNTO 0);
SIGNAL \inst_ftif|outdata_reg\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \inst_ftif|ft_txe_reg\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \inst_ftif|ft_rxf_reg\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \inst_scif|txcounter\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \inst_scif|rxcounter\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \inst_scif|outdata_reg\ : std_logic_vector(8 DOWNTO 0);
SIGNAL \inst_scif|indata_reg\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \ALT_INV_~GND~combout\ : std_logic;
SIGNAL \ALT_INV_intreset_n_reg~regout\ : std_logic;
SIGNAL \ALT_INV_led_n_out~0_combout\ : std_logic;
SIGNAL \inst_scif|ALT_INV_outdata_reg\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \ALT_INV_conn_tck_in~combout\ : std_logic;
SIGNAL \ALT_INV_sendimm_reg~regout\ : std_logic;
SIGNAL \inst_ftif|ALT_INV_ft_rd_reg~regout\ : std_logic;

BEGIN

ww_clk24mhz <= clk24mhz;
ud <= ww_ud;
rd_n <= ww_rd_n;
wr <= ww_wr;
ww_rxf_n <= rxf_n;
ww_txe_n <= txe_n;
si_wu_n <= ww_si_wu_n;
dclk <= ww_dclk;
data0 <= ww_data0;
nconfig <= ww_nconfig;
ww_nstatus <= nstatus;
ww_confdone <= confdone;
ww_msel1 <= msel1;
ww_conn_tck_in <= conn_tck_in;
ww_conn_tdi_in <= conn_tdi_in;
conn_tdo_out <= ww_conn_tdo_out;
ww_conn_tms_in <= conn_tms_in;
tck <= ww_tck;
tdi <= ww_tdi;
ww_tdo <= tdo;
tms <= ww_tms;
reset_n_out <= ww_reset_n_out;
sci_sclk <= ww_sci_sclk;
ww_sci_txr_n <= sci_txr_n;
sci_txd <= ww_sci_txd;
sci_rxr_n <= ww_sci_rxr_n;
ww_sci_rxd <= sci_rxd;
i2c_scl <= ww_i2c_scl;
i2c_sda <= ww_i2c_sda;
ww_mreset_n_in <= mreset_n_in;
mreset_n_ext <= ww_mreset_n_ext;
led_n_out <= ww_led_n_out;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_~GND~combout\ <= NOT \~GND~combout\;
\ALT_INV_intreset_n_reg~regout\ <= NOT \intreset_n_reg~regout\;
\ALT_INV_led_n_out~0_combout\ <= NOT \led_n_out~0_combout\;
\inst_scif|ALT_INV_outdata_reg\(0) <= NOT \inst_scif|outdata_reg\(0);
\ALT_INV_conn_tck_in~combout\ <= NOT \conn_tck_in~combout\;
\ALT_INV_sendimm_reg~regout\ <= NOT \sendimm_reg~regout\;
\inst_ftif|ALT_INV_ft_rd_reg~regout\ <= NOT \inst_ftif|ft_rd_reg~regout\;

-- Location: PIN_24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[0]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[0]~0\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(0),
	combout => \ud[0]~0\);

-- Location: PIN_18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[1]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[1]~1\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(1),
	combout => \ud[1]~1\);

-- Location: PIN_19,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[2]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[2]~2\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(2),
	combout => \ud[2]~2\);

-- Location: PIN_10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[3]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[3]~3\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(3),
	combout => \ud[3]~3\);

-- Location: PIN_20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[4]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[4]~4\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(4),
	combout => \ud[4]~4\);

-- Location: PIN_12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[5]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[5]~5\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(5),
	combout => \ud[5]~5\);

-- Location: PIN_11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[6]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[6]~6\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(6),
	combout => \ud[6]~6\);

-- Location: PIN_13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\ud[7]~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \usb_txdata_sig[7]~7\,
	oe => \inst_ftif|ft_doe_reg~regout\,
	padio => ww_ud(7),
	combout => \ud[7]~7\);

-- Location: PIN_26,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
\i2c_scl~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	open_drain_output => "true",
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \i2c_scl~2_combout\,
	oe => VCC,
	padio => ww_i2c_scl,
	combout => \i2c_scl~0\);

-- Location: PIN_25,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
\i2c_sda~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	open_drain_output => "true",
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \i2c_sda~2_combout\,
	oe => VCC,
	padio => ww_i2c_sda,
	combout => \i2c_sda~0\);

-- Location: PIN_27,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: 16mA
\mreset_n_ext~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	open_drain_output => "true",
	operation_mode => "bidir")
-- pragma translate_on
PORT MAP (
	datain => \mreset_n_ext~2_combout\,
	oe => VCC,
	padio => ww_mreset_n_ext,
	combout => \mreset_n_ext~0\);

-- Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clk24mhz~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_clk24mhz,
	combout => \clk24mhz~combout\);

-- Location: LC_X3_Y2_N9
\inst_ftif|ifstate.state_bit_3~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_3~0_combout\ = (\inst_ftif|ifstate.state_bit_1~regout\ & ((\inst_ftif|ifstate.state_bit_2~regout\) # ((\inst_ftif|ifstate.state_bit_3~regout\ & \inst_ftif|ft_rxf_reg\(1))))) # (!\inst_ftif|ifstate.state_bit_1~regout\ & 
-- (\inst_ftif|ifstate.state_bit_3~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "eae2",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ifstate.state_bit_3~regout\,
	datab => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|ifstate.state_bit_2~regout\,
	datad => \inst_ftif|ft_rxf_reg\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.state_bit_3~0_combout\);

-- Location: LC_X2_Y4_N8
\~GND\ : maxv_lcell
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \~GND~combout\);

-- Location: UFM_X0_Y1_N4
\osc_inst|max2_internal_osc_altufm_osc_lv5_component|maxii_ufm_block1\ : maxv_ufm
-- pragma translate_off
GENERIC MAP (
	address_width => 9,
	erase_time => 500000000,
	init_file => "none",
	osc_sim_setting => 300000,
	program_time => 1600000)
-- pragma translate_on
PORT MAP (
	drdin => GND,
	drclk => GND,
	drshft => VCC,
	ardin => GND,
	arclk => GND,
	arshft => GND,
	oscena => \ALT_INV_~GND~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	drdout => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|maxii_ufm_block1~drdout\,
	osc => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\);

-- Location: LC_X5_Y1_N0
\intreset_count[0]\ : maxv_lcell
-- Equation(s):
-- intreset_count(0) = DFFEAS((((!\Equal0~1_combout\) # (!intreset_count(0)))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0fff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	datac => intreset_count(0),
	datad => \Equal0~1_combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => intreset_count(0));

-- Location: LC_X5_Y1_N1
\intreset_count[1]\ : maxv_lcell
-- Equation(s):
-- intreset_count(1) = DFFEAS(intreset_count(0) $ ((intreset_count(1))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , \Equal0~1_combout\, , , , )
-- \intreset_count[1]~3\ = CARRY((intreset_count(0) & (intreset_count(1))))
-- \intreset_count[1]~3COUT1_14\ = CARRY((intreset_count(0) & (intreset_count(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "6688",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	dataa => intreset_count(0),
	datab => intreset_count(1),
	aclr => GND,
	ena => \Equal0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => intreset_count(1),
	cout0 => \intreset_count[1]~3\,
	cout1 => \intreset_count[1]~3COUT1_14\);

-- Location: LC_X5_Y1_N2
\intreset_count[2]\ : maxv_lcell
-- Equation(s):
-- intreset_count(2) = DFFEAS((intreset_count(2) $ ((\intreset_count[1]~3\))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , \Equal0~1_combout\, , , , )
-- \intreset_count[2]~5\ = CARRY(((!\intreset_count[1]~3\) # (!intreset_count(2))))
-- \intreset_count[2]~5COUT1_16\ = CARRY(((!\intreset_count[1]~3COUT1_14\) # (!intreset_count(2))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	datab => intreset_count(2),
	aclr => GND,
	ena => \Equal0~1_combout\,
	cin0 => \intreset_count[1]~3\,
	cin1 => \intreset_count[1]~3COUT1_14\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => intreset_count(2),
	cout0 => \intreset_count[2]~5\,
	cout1 => \intreset_count[2]~5COUT1_16\);

-- Location: LC_X5_Y1_N3
\intreset_count[3]\ : maxv_lcell
-- Equation(s):
-- intreset_count(3) = DFFEAS(intreset_count(3) $ ((((!\intreset_count[2]~5\)))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , \Equal0~1_combout\, , , , )
-- \intreset_count[3]~7\ = CARRY((intreset_count(3) & ((!\intreset_count[2]~5\))))
-- \intreset_count[3]~7COUT1_18\ = CARRY((intreset_count(3) & ((!\intreset_count[2]~5COUT1_16\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	dataa => intreset_count(3),
	aclr => GND,
	ena => \Equal0~1_combout\,
	cin0 => \intreset_count[2]~5\,
	cin1 => \intreset_count[2]~5COUT1_16\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => intreset_count(3),
	cout0 => \intreset_count[3]~7\,
	cout1 => \intreset_count[3]~7COUT1_18\);

-- Location: LC_X5_Y1_N4
\intreset_count[4]\ : maxv_lcell
-- Equation(s):
-- intreset_count(4) = DFFEAS(intreset_count(4) $ ((((\intreset_count[3]~7\)))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , \Equal0~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "5a5a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	dataa => intreset_count(4),
	aclr => GND,
	ena => \Equal0~1_combout\,
	cin0 => \intreset_count[3]~7\,
	cin1 => \intreset_count[3]~7COUT1_18\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => intreset_count(4));

-- Location: LC_X5_Y1_N9
\Equal0~0\ : maxv_lcell
-- Equation(s):
-- \Equal0~0_combout\ = (((intreset_count(0) & intreset_count(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => intreset_count(0),
	datad => intreset_count(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal0~0_combout\);

-- Location: LC_X5_Y1_N8
\Equal0~1\ : maxv_lcell
-- Equation(s):
-- \Equal0~1_combout\ = (((!\Equal0~0_combout\) # (!intreset_count(4))) # (!intreset_count(2))) # (!intreset_count(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7fff",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => intreset_count(3),
	datab => intreset_count(2),
	datac => intreset_count(4),
	datad => \Equal0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal0~1_combout\);

-- Location: LC_X5_Y1_N6
intreset_n_reg : maxv_lcell
-- Equation(s):
-- \intreset_n_reg~regout\ = DFFEAS((((\intreset_n_reg~regout\) # (!\Equal0~1_combout\))), GLOBAL(\osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f0ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \osc_inst|max2_internal_osc_altufm_osc_lv5_component|wire_maxii_ufm_block1_osc\,
	datac => \intreset_n_reg~regout\,
	datad => \Equal0~1_combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \intreset_n_reg~regout\);

-- Location: LC_X3_Y2_N8
\inst_ftif|outdata_reg[7]~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outdata_reg[7]~0_combout\ = (\inst_ftif|ifstate.state_bit_2~regout\ & (\inst_ftif|ifstate.state_bit_1~regout\ & (!\inst_ftif|outvalid_reg~regout\ & \intreset_n_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0800",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ifstate.state_bit_2~regout\,
	datab => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|outvalid_reg~regout\,
	datad => \intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|outdata_reg[7]~0_combout\);

-- Location: LC_X4_Y4_N5
\inst_ftif|outdata_reg[1]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outdata_reg\(1) = DFFEAS(GND, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[1]~1\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datac => \ud[1]~1\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|outdata_reg\(1));

-- Location: LC_X2_Y4_N3
\inst_ftif|outdata_reg[5]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outdata_reg\(5) = DFFEAS(GND, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[5]~5\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datac => \ud[5]~5\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|outdata_reg\(5));

-- Location: LC_X2_Y4_N6
\inst_ftif|outdata_reg[6]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outdata_reg\(6) = DFFEAS((((\ud[6]~6\))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff00",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \ud[6]~6\,
	aclr => GND,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|outdata_reg\(6));

-- Location: LC_X2_Y4_N4
\inst_ftif|outdata_reg[7]\ : maxv_lcell
-- Equation(s):
-- \Equal1~0\ = (!\inst_ftif|outdata_reg\(6) & (((!B1_outdata_reg[7]))))
-- \inst_ftif|outdata_reg\(7) = DFFEAS(\Equal1~0\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[7]~7\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0505",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|outdata_reg\(6),
	datac => \ud[7]~7\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal1~0\,
	regout => \inst_ftif|outdata_reg\(7));

-- Location: LC_X4_Y4_N4
\inst_ftif|outdata_reg[3]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outdata_reg\(3) = DFFEAS(GND, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[3]~3\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datac => \ud[3]~3\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|outdata_reg\(3));

-- Location: LC_X4_Y4_N1
\inst_ftif|outdata_reg[4]\ : maxv_lcell
-- Equation(s):
-- \Equal1~1\ = (\inst_ftif|outdata_reg\(5) & (\Equal1~0\ & (B1_outdata_reg[4] & \inst_ftif|outdata_reg\(3))))
-- \inst_ftif|outdata_reg\(4) = DFFEAS(\Equal1~1\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[4]~4\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|outdata_reg\(5),
	datab => \Equal1~0\,
	datac => \ud[4]~4\,
	datad => \inst_ftif|outdata_reg\(3),
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal1~1\,
	regout => \inst_ftif|outdata_reg\(4));

-- Location: LC_X4_Y4_N9
\inst_ftif|outdata_reg[0]\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_1~1\ = (\Equal1~1\ & ((\inst_ftif|outdata_reg\(1) & (!\inst_ftif|outdata_reg\(2) & !B1_outdata_reg[0])) # (!\inst_ftif|outdata_reg\(1) & (\inst_ftif|outdata_reg\(2) & B1_outdata_reg[0]))))
-- \inst_ftif|outdata_reg\(0) = DFFEAS(\psstate.state_bit_1~1\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[0]~0\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4200",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|outdata_reg\(1),
	datab => \inst_ftif|outdata_reg\(2),
	datac => \ud[0]~0\,
	datad => \Equal1~1\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.state_bit_1~1\,
	regout => \inst_ftif|outdata_reg\(0));

-- Location: LC_X4_Y4_N8
\inst_ftif|outdata_reg[2]\ : maxv_lcell
-- Equation(s):
-- \escape_reg~0\ = (!\inst_ftif|outdata_reg\(1) & (\inst_ftif|outdata_reg\(0) & (B1_outdata_reg[2] & \Equal1~1\)))
-- \inst_ftif|outdata_reg\(2) = DFFEAS(\escape_reg~0\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_ftif|outdata_reg[7]~0_combout\, \ud[2]~2\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4000",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|outdata_reg\(1),
	datab => \inst_ftif|outdata_reg\(0),
	datac => \ud[2]~2\,
	datad => \Equal1~1\,
	aclr => GND,
	sload => VCC,
	ena => \inst_ftif|outdata_reg[7]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \escape_reg~0\,
	regout => \inst_ftif|outdata_reg\(2));

-- Location: LC_X7_Y2_N9
\psstate.state_bit_2\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_2~regout\ = DFFEAS((\psstate.state_bit_0~regout\ & ((\psstate.state_bit_1~regout\) # ((!\inst_ftif|ifstate.FT_WRWAIT2~0_combout\ & \psstate.state_bit_2~regout\)))) # (!\psstate.state_bit_0~regout\ & (((\psstate.state_bit_2~regout\)))), 
-- GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f7a0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \psstate.state_bit_2~regout\);

-- Location: LC_X7_Y2_N6
\psstate.state_bit_1~0\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_1~0_combout\ = (!\psstate.state_bit_0~regout\ & (\inst_ftif|outvalid_reg~regout\ & (!\psstate.state_bit_1~regout\ & !\psstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0004",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \inst_ftif|outvalid_reg~regout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.state_bit_1~0_combout\);

-- Location: LC_X7_Y2_N7
\psstate.state_bit_1\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_1~regout\ = DFFEAS(((\psstate.state_bit_1~1\ & (\psstate.state_bit_1~0_combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c0c0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \psstate.state_bit_1~1\,
	datac => \psstate.state_bit_1~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \psstate.state_bit_1~regout\);

-- Location: LC_X7_Y2_N8
\psstate.state_bit_0~5\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_0~5_combout\ = (!\psstate.state_bit_0~regout\ & ((\psstate.state_bit_1~regout\) # ((\inst_ftif|outvalid_reg~regout\ & \psstate.state_bit_2~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5450",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \inst_ftif|outvalid_reg~regout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.state_bit_0~5_combout\);

-- Location: LC_X7_Y4_N2
\psstate.SETRESP~0\ : maxv_lcell
-- Equation(s):
-- \psstate.SETRESP~0_combout\ = ((\psstate.state_bit_2~regout\ & (\psstate.state_bit_0~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c0c0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \psstate.state_bit_2~regout\,
	datac => \psstate.state_bit_0~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.SETRESP~0_combout\);

-- Location: LC_X7_Y2_N4
\process_2~0\ : maxv_lcell
-- Equation(s):
-- \process_2~0_combout\ = (!\timeout_reg~regout\ & (((\psstate.state_bit_1~regout\) # (\psstate.state_bit_2~regout\)) # (!\psstate.state_bit_0~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3331",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \timeout_reg~regout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \process_2~0_combout\);

-- Location: LC_X3_Y3_N2
\tocount_reg[0]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(0) = DFFEAS(((!tocount_reg(0))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[0]~11\ = CARRY(((tocount_reg(0))))
-- \tocount_reg[0]~11COUT1_74\ = CARRY(((tocount_reg(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "33cc",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(0),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(0),
	cout0 => \tocount_reg[0]~11\,
	cout1 => \tocount_reg[0]~11COUT1_74\);

-- Location: LC_X3_Y3_N3
\tocount_reg[1]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(1) = DFFEAS(tocount_reg(1) $ ((((\tocount_reg[0]~11\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[1]~33\ = CARRY(((!\tocount_reg[0]~11\)) # (!tocount_reg(1)))
-- \tocount_reg[1]~33COUT1_76\ = CARRY(((!\tocount_reg[0]~11COUT1_74\)) # (!tocount_reg(1)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(1),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin0 => \tocount_reg[0]~11\,
	cin1 => \tocount_reg[0]~11COUT1_74\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(1),
	cout0 => \tocount_reg[1]~33\,
	cout1 => \tocount_reg[1]~33COUT1_76\);

-- Location: LC_X3_Y3_N4
\tocount_reg[2]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(2) = DFFEAS(tocount_reg(2) $ ((((!\tocount_reg[1]~33\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[2]~35\ = CARRY((tocount_reg(2) & ((!\tocount_reg[1]~33COUT1_76\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(2),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin0 => \tocount_reg[1]~33\,
	cin1 => \tocount_reg[1]~33COUT1_76\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(2),
	cout => \tocount_reg[2]~35\);

-- Location: LC_X3_Y3_N5
\tocount_reg[3]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(3) = DFFEAS(tocount_reg(3) $ ((((\tocount_reg[2]~35\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[3]~41\ = CARRY(((!\tocount_reg[2]~35\)) # (!tocount_reg(3)))
-- \tocount_reg[3]~41COUT1_78\ = CARRY(((!\tocount_reg[2]~35\)) # (!tocount_reg(3)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(3),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[2]~35\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(3),
	cout0 => \tocount_reg[3]~41\,
	cout1 => \tocount_reg[3]~41COUT1_78\);

-- Location: LC_X3_Y3_N6
\tocount_reg[4]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(4) = DFFEAS(tocount_reg(4) $ ((((!(!\tocount_reg[2]~35\ & \tocount_reg[3]~41\) # (\tocount_reg[2]~35\ & \tocount_reg[3]~41COUT1_78\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[4]~43\ = CARRY((tocount_reg(4) & ((!\tocount_reg[3]~41\))))
-- \tocount_reg[4]~43COUT1_80\ = CARRY((tocount_reg(4) & ((!\tocount_reg[3]~41COUT1_78\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(4),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[2]~35\,
	cin0 => \tocount_reg[3]~41\,
	cin1 => \tocount_reg[3]~41COUT1_78\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(4),
	cout0 => \tocount_reg[4]~43\,
	cout1 => \tocount_reg[4]~43COUT1_80\);

-- Location: LC_X3_Y3_N7
\tocount_reg[5]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(5) = DFFEAS((tocount_reg(5) $ (((!\tocount_reg[2]~35\ & \tocount_reg[4]~43\) # (\tocount_reg[2]~35\ & \tocount_reg[4]~43COUT1_80\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[5]~37\ = CARRY(((!\tocount_reg[4]~43\) # (!tocount_reg(5))))
-- \tocount_reg[5]~37COUT1_82\ = CARRY(((!\tocount_reg[4]~43COUT1_80\) # (!tocount_reg(5))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(5),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[2]~35\,
	cin0 => \tocount_reg[4]~43\,
	cin1 => \tocount_reg[4]~43COUT1_80\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(5),
	cout0 => \tocount_reg[5]~37\,
	cout1 => \tocount_reg[5]~37COUT1_82\);

-- Location: LC_X3_Y3_N8
\tocount_reg[6]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(6) = DFFEAS(tocount_reg(6) $ ((((!(!\tocount_reg[2]~35\ & \tocount_reg[5]~37\) # (\tocount_reg[2]~35\ & \tocount_reg[5]~37COUT1_82\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[6]~39\ = CARRY((tocount_reg(6) & ((!\tocount_reg[5]~37\))))
-- \tocount_reg[6]~39COUT1_84\ = CARRY((tocount_reg(6) & ((!\tocount_reg[5]~37COUT1_82\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(6),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[2]~35\,
	cin0 => \tocount_reg[5]~37\,
	cin1 => \tocount_reg[5]~37COUT1_82\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(6),
	cout0 => \tocount_reg[6]~39\,
	cout1 => \tocount_reg[6]~39COUT1_84\);

-- Location: LC_X3_Y3_N9
\tocount_reg[7]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(7) = DFFEAS((tocount_reg(7) $ (((!\tocount_reg[2]~35\ & \tocount_reg[6]~39\) # (\tocount_reg[2]~35\ & \tocount_reg[6]~39COUT1_84\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[7]~17\ = CARRY(((!\tocount_reg[6]~39COUT1_84\) # (!tocount_reg(7))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(7),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[2]~35\,
	cin0 => \tocount_reg[6]~39\,
	cin1 => \tocount_reg[6]~39COUT1_84\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(7),
	cout => \tocount_reg[7]~17\);

-- Location: LC_X4_Y3_N0
\tocount_reg[8]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(8) = DFFEAS((tocount_reg(8) $ ((!\tocount_reg[7]~17\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[8]~13\ = CARRY(((tocount_reg(8) & !\tocount_reg[7]~17\)))
-- \tocount_reg[8]~13COUT1_86\ = CARRY(((tocount_reg(8) & !\tocount_reg[7]~17\)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(8),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[7]~17\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(8),
	cout0 => \tocount_reg[8]~13\,
	cout1 => \tocount_reg[8]~13COUT1_86\);

-- Location: LC_X4_Y3_N1
\tocount_reg[9]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(9) = DFFEAS((tocount_reg(9) $ (((!\tocount_reg[7]~17\ & \tocount_reg[8]~13\) # (\tocount_reg[7]~17\ & \tocount_reg[8]~13COUT1_86\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[9]~19\ = CARRY(((!\tocount_reg[8]~13\) # (!tocount_reg(9))))
-- \tocount_reg[9]~19COUT1_88\ = CARRY(((!\tocount_reg[8]~13COUT1_86\) # (!tocount_reg(9))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(9),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[7]~17\,
	cin0 => \tocount_reg[8]~13\,
	cin1 => \tocount_reg[8]~13COUT1_86\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(9),
	cout0 => \tocount_reg[9]~19\,
	cout1 => \tocount_reg[9]~19COUT1_88\);

-- Location: LC_X4_Y3_N2
\tocount_reg[10]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(10) = DFFEAS((tocount_reg(10) $ ((!(!\tocount_reg[7]~17\ & \tocount_reg[9]~19\) # (\tocount_reg[7]~17\ & \tocount_reg[9]~19COUT1_88\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[10]~15\ = CARRY(((tocount_reg(10) & !\tocount_reg[9]~19\)))
-- \tocount_reg[10]~15COUT1_90\ = CARRY(((tocount_reg(10) & !\tocount_reg[9]~19COUT1_88\)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(10),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[7]~17\,
	cin0 => \tocount_reg[9]~19\,
	cin1 => \tocount_reg[9]~19COUT1_88\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(10),
	cout0 => \tocount_reg[10]~15\,
	cout1 => \tocount_reg[10]~15COUT1_90\);

-- Location: LC_X4_Y3_N3
\tocount_reg[11]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(11) = DFFEAS(tocount_reg(11) $ (((((!\tocount_reg[7]~17\ & \tocount_reg[10]~15\) # (\tocount_reg[7]~17\ & \tocount_reg[10]~15COUT1_90\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[11]~3\ = CARRY(((!\tocount_reg[10]~15\)) # (!tocount_reg(11)))
-- \tocount_reg[11]~3COUT1_92\ = CARRY(((!\tocount_reg[10]~15COUT1_90\)) # (!tocount_reg(11)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(11),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[7]~17\,
	cin0 => \tocount_reg[10]~15\,
	cin1 => \tocount_reg[10]~15COUT1_90\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(11),
	cout0 => \tocount_reg[11]~3\,
	cout1 => \tocount_reg[11]~3COUT1_92\);

-- Location: LC_X4_Y3_N4
\tocount_reg[12]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(12) = DFFEAS(tocount_reg(12) $ ((((!(!\tocount_reg[7]~17\ & \tocount_reg[11]~3\) # (\tocount_reg[7]~17\ & \tocount_reg[11]~3COUT1_92\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[12]~5\ = CARRY((tocount_reg(12) & ((!\tocount_reg[11]~3COUT1_92\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(12),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[7]~17\,
	cin0 => \tocount_reg[11]~3\,
	cin1 => \tocount_reg[11]~3COUT1_92\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(12),
	cout => \tocount_reg[12]~5\);

-- Location: LC_X4_Y3_N5
\tocount_reg[13]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(13) = DFFEAS(tocount_reg(13) $ ((((\tocount_reg[12]~5\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[13]~9\ = CARRY(((!\tocount_reg[12]~5\)) # (!tocount_reg(13)))
-- \tocount_reg[13]~9COUT1_94\ = CARRY(((!\tocount_reg[12]~5\)) # (!tocount_reg(13)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(13),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[12]~5\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(13),
	cout0 => \tocount_reg[13]~9\,
	cout1 => \tocount_reg[13]~9COUT1_94\);

-- Location: LC_X4_Y3_N6
\tocount_reg[14]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(14) = DFFEAS(tocount_reg(14) $ ((((!(!\tocount_reg[12]~5\ & \tocount_reg[13]~9\) # (\tocount_reg[12]~5\ & \tocount_reg[13]~9COUT1_94\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[14]~7\ = CARRY((tocount_reg(14) & ((!\tocount_reg[13]~9\))))
-- \tocount_reg[14]~7COUT1_96\ = CARRY((tocount_reg(14) & ((!\tocount_reg[13]~9COUT1_94\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(14),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[12]~5\,
	cin0 => \tocount_reg[13]~9\,
	cin1 => \tocount_reg[13]~9COUT1_94\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(14),
	cout0 => \tocount_reg[14]~7\,
	cout1 => \tocount_reg[14]~7COUT1_96\);

-- Location: LC_X2_Y1_N9
\timeout_reg~0\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~0_combout\ = (tocount_reg(12) & (!tocount_reg(13) & (tocount_reg(14) & tocount_reg(11))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "2000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(12),
	datab => tocount_reg(13),
	datac => tocount_reg(14),
	datad => tocount_reg(11),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~0_combout\);

-- Location: LC_X4_Y3_N7
\tocount_reg[15]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(15) = DFFEAS((tocount_reg(15) $ (((!\tocount_reg[12]~5\ & \tocount_reg[14]~7\) # (\tocount_reg[12]~5\ & \tocount_reg[14]~7COUT1_96\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[15]~45\ = CARRY(((!\tocount_reg[14]~7\) # (!tocount_reg(15))))
-- \tocount_reg[15]~45COUT1_98\ = CARRY(((!\tocount_reg[14]~7COUT1_96\) # (!tocount_reg(15))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(15),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[12]~5\,
	cin0 => \tocount_reg[14]~7\,
	cin1 => \tocount_reg[14]~7COUT1_96\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(15),
	cout0 => \tocount_reg[15]~45\,
	cout1 => \tocount_reg[15]~45COUT1_98\);

-- Location: LC_X4_Y3_N8
\tocount_reg[16]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(16) = DFFEAS(tocount_reg(16) $ ((((!(!\tocount_reg[12]~5\ & \tocount_reg[15]~45\) # (\tocount_reg[12]~5\ & \tocount_reg[15]~45COUT1_98\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[16]~47\ = CARRY((tocount_reg(16) & ((!\tocount_reg[15]~45\))))
-- \tocount_reg[16]~47COUT1_100\ = CARRY((tocount_reg(16) & ((!\tocount_reg[15]~45COUT1_98\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(16),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[12]~5\,
	cin0 => \tocount_reg[15]~45\,
	cin1 => \tocount_reg[15]~45COUT1_98\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(16),
	cout0 => \tocount_reg[16]~47\,
	cout1 => \tocount_reg[16]~47COUT1_100\);

-- Location: LC_X4_Y3_N9
\tocount_reg[17]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(17) = DFFEAS((tocount_reg(17) $ (((!\tocount_reg[12]~5\ & \tocount_reg[16]~47\) # (\tocount_reg[12]~5\ & \tocount_reg[16]~47COUT1_100\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[17]~49\ = CARRY(((!\tocount_reg[16]~47COUT1_100\) # (!tocount_reg(17))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(17),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[12]~5\,
	cin0 => \tocount_reg[16]~47\,
	cin1 => \tocount_reg[16]~47COUT1_100\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(17),
	cout => \tocount_reg[17]~49\);

-- Location: LC_X5_Y3_N0
\tocount_reg[18]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(18) = DFFEAS((tocount_reg(18) $ ((!\tocount_reg[17]~49\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[18]~51\ = CARRY(((tocount_reg(18) & !\tocount_reg[17]~49\)))
-- \tocount_reg[18]~51COUT1_102\ = CARRY(((tocount_reg(18) & !\tocount_reg[17]~49\)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(18),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[17]~49\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(18),
	cout0 => \tocount_reg[18]~51\,
	cout1 => \tocount_reg[18]~51COUT1_102\);

-- Location: LC_X5_Y3_N1
\tocount_reg[19]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(19) = DFFEAS((tocount_reg(19) $ (((!\tocount_reg[17]~49\ & \tocount_reg[18]~51\) # (\tocount_reg[17]~49\ & \tocount_reg[18]~51COUT1_102\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[19]~21\ = CARRY(((!\tocount_reg[18]~51\) # (!tocount_reg(19))))
-- \tocount_reg[19]~21COUT1_104\ = CARRY(((!\tocount_reg[18]~51COUT1_102\) # (!tocount_reg(19))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(19),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[17]~49\,
	cin0 => \tocount_reg[18]~51\,
	cin1 => \tocount_reg[18]~51COUT1_102\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(19),
	cout0 => \tocount_reg[19]~21\,
	cout1 => \tocount_reg[19]~21COUT1_104\);

-- Location: LC_X5_Y3_N2
\tocount_reg[20]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(20) = DFFEAS((tocount_reg(20) $ ((!(!\tocount_reg[17]~49\ & \tocount_reg[19]~21\) # (\tocount_reg[17]~49\ & \tocount_reg[19]~21COUT1_104\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[20]~23\ = CARRY(((tocount_reg(20) & !\tocount_reg[19]~21\)))
-- \tocount_reg[20]~23COUT1_106\ = CARRY(((tocount_reg(20) & !\tocount_reg[19]~21COUT1_104\)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(20),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[17]~49\,
	cin0 => \tocount_reg[19]~21\,
	cin1 => \tocount_reg[19]~21COUT1_104\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(20),
	cout0 => \tocount_reg[20]~23\,
	cout1 => \tocount_reg[20]~23COUT1_106\);

-- Location: LC_X5_Y3_N3
\tocount_reg[21]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(21) = DFFEAS(tocount_reg(21) $ (((((!\tocount_reg[17]~49\ & \tocount_reg[20]~23\) # (\tocount_reg[17]~49\ & \tocount_reg[20]~23COUT1_106\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[21]~25\ = CARRY(((!\tocount_reg[20]~23\)) # (!tocount_reg(21)))
-- \tocount_reg[21]~25COUT1_108\ = CARRY(((!\tocount_reg[20]~23COUT1_106\)) # (!tocount_reg(21)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(21),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[17]~49\,
	cin0 => \tocount_reg[20]~23\,
	cin1 => \tocount_reg[20]~23COUT1_106\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(21),
	cout0 => \tocount_reg[21]~25\,
	cout1 => \tocount_reg[21]~25COUT1_108\);

-- Location: LC_X5_Y3_N4
\tocount_reg[22]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(22) = DFFEAS(tocount_reg(22) $ ((((!(!\tocount_reg[17]~49\ & \tocount_reg[21]~25\) # (\tocount_reg[17]~49\ & \tocount_reg[21]~25COUT1_108\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[22]~1\ = CARRY((tocount_reg(22) & ((!\tocount_reg[21]~25COUT1_108\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(22),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[17]~49\,
	cin0 => \tocount_reg[21]~25\,
	cin1 => \tocount_reg[21]~25COUT1_108\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(22),
	cout => \tocount_reg[22]~1\);

-- Location: LC_X5_Y3_N5
\tocount_reg[23]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(23) = DFFEAS(tocount_reg(23) $ ((((\tocount_reg[22]~1\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[23]~27\ = CARRY(((!\tocount_reg[22]~1\)) # (!tocount_reg(23)))
-- \tocount_reg[23]~27COUT1_110\ = CARRY(((!\tocount_reg[22]~1\)) # (!tocount_reg(23)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(23),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[22]~1\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(23),
	cout0 => \tocount_reg[23]~27\,
	cout1 => \tocount_reg[23]~27COUT1_110\);

-- Location: LC_X5_Y3_N6
\tocount_reg[24]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(24) = DFFEAS(tocount_reg(24) $ ((((!(!\tocount_reg[22]~1\ & \tocount_reg[23]~27\) # (\tocount_reg[22]~1\ & \tocount_reg[23]~27COUT1_110\))))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )
-- \tocount_reg[24]~29\ = CARRY((tocount_reg(24) & ((!\tocount_reg[23]~27\))))
-- \tocount_reg[24]~29COUT1_112\ = CARRY((tocount_reg(24) & ((!\tocount_reg[23]~27COUT1_110\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => tocount_reg(24),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[22]~1\,
	cin0 => \tocount_reg[23]~27\,
	cin1 => \tocount_reg[23]~27COUT1_110\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(24),
	cout0 => \tocount_reg[24]~29\,
	cout1 => \tocount_reg[24]~29COUT1_112\);

-- Location: LC_X5_Y3_N7
\tocount_reg[25]\ : maxv_lcell
-- Equation(s):
-- tocount_reg(25) = DFFEAS((tocount_reg(25) $ (((!\tocount_reg[22]~1\ & \tocount_reg[24]~29\) # (\tocount_reg[22]~1\ & \tocount_reg[24]~29COUT1_112\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , \process_2~0_combout\, )

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3c",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => tocount_reg(25),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sclr => \process_2~0_combout\,
	cin => \tocount_reg[22]~1\,
	cin0 => \tocount_reg[24]~29\,
	cin1 => \tocount_reg[24]~29COUT1_112\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => tocount_reg(25));

-- Location: LC_X5_Y3_N8
\timeout_reg~2\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~2_combout\ = (tocount_reg(21) & (tocount_reg(20) & (tocount_reg(22) & tocount_reg(19))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(21),
	datab => tocount_reg(20),
	datac => tocount_reg(22),
	datad => tocount_reg(19),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~2_combout\);

-- Location: LC_X5_Y3_N9
\timeout_reg~3\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~3_combout\ = (tocount_reg(24) & (tocount_reg(25) & (tocount_reg(23) & \timeout_reg~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(24),
	datab => tocount_reg(25),
	datac => tocount_reg(23),
	datad => \timeout_reg~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~3_combout\);

-- Location: LC_X3_Y3_N0
\timeout_reg~4\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~4_combout\ = (!tocount_reg(3) & (tocount_reg(5) & (!tocount_reg(4) & tocount_reg(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0400",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(3),
	datab => tocount_reg(5),
	datac => tocount_reg(4),
	datad => tocount_reg(6),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~4_combout\);

-- Location: LC_X3_Y2_N1
\timeout_reg~5\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~5_combout\ = (tocount_reg(15) & (tocount_reg(17) & (tocount_reg(16) & tocount_reg(18))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(15),
	datab => tocount_reg(17),
	datac => tocount_reg(16),
	datad => tocount_reg(18),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~5_combout\);

-- Location: LC_X3_Y3_N1
\timeout_reg~6\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~6_combout\ = (!tocount_reg(1) & (\timeout_reg~4_combout\ & (!tocount_reg(2) & \timeout_reg~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0400",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(1),
	datab => \timeout_reg~4_combout\,
	datac => tocount_reg(2),
	datad => \timeout_reg~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~6_combout\);

-- Location: LC_X2_Y1_N1
\timeout_reg~1\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~1_combout\ = (!tocount_reg(9) & (!tocount_reg(7) & (tocount_reg(8) & tocount_reg(10))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(9),
	datab => tocount_reg(7),
	datac => tocount_reg(8),
	datad => tocount_reg(10),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~1_combout\);

-- Location: LC_X2_Y1_N4
\timeout_reg~7\ : maxv_lcell
-- Equation(s):
-- \timeout_reg~7_combout\ = (!tocount_reg(0) & (\timeout_reg~3_combout\ & (\timeout_reg~6_combout\ & \timeout_reg~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => tocount_reg(0),
	datab => \timeout_reg~3_combout\,
	datac => \timeout_reg~6_combout\,
	datad => \timeout_reg~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \timeout_reg~7_combout\);

-- Location: LC_X7_Y3_N1
\sendimm_reg~0\ : maxv_lcell
-- Equation(s):
-- \sendimm_reg~0_combout\ = (!\psstate.state_bit_0~regout\ & (\inst_ftif|outvalid_reg~regout\ & (\psstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4040",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \inst_ftif|outvalid_reg~regout\,
	datac => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \sendimm_reg~0_combout\);

-- Location: LC_X7_Y3_N2
usermode_reg : maxv_lcell
-- Equation(s):
-- \usermode_reg~regout\ = DFFEAS((((!\inst_ftif|outdata_reg\(3)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \inst_ftif|outdata_reg\(3),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \usermode_reg~regout\);

-- Location: LC_X2_Y1_N3
timeout_reg : maxv_lcell
-- Equation(s):
-- \timeout_reg~regout\ = DFFEAS((\timeout_reg~regout\ & (((!\usermode_reg~regout\)))) # (!\timeout_reg~regout\ & (\timeout_reg~0_combout\ & (\timeout_reg~7_combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "40ea",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \timeout_reg~regout\,
	datab => \timeout_reg~0_combout\,
	datac => \timeout_reg~7_combout\,
	datad => \usermode_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \timeout_reg~regout\);

-- Location: LC_X7_Y2_N2
\inst_scif|in_ready~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|in_ready~0_combout\ = (\psstate.state_bit_0~regout\ & (!\timeout_reg~regout\ & (!\psstate.state_bit_1~regout\ & !\psstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0002",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \timeout_reg~regout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|in_ready~0_combout\);

-- Location: LC_X6_Y3_N2
\inst_scif|sclk_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|sclk_reg~regout\ = DFFEAS((((!\inst_scif|sclk_reg~regout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \inst_scif|sclk_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|sclk_reg~regout\);

-- Location: PIN_51,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sci_txr_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_sci_txr_n,
	combout => \sci_txr_n~combout\);

-- Location: LC_X6_Y3_N1
\inst_scif|txready_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txready_reg~regout\ = DFFEAS(((\inst_scif|sclk_reg~regout\ & (\inst_scif|txready_reg~regout\)) # (!\inst_scif|sclk_reg~regout\ & ((!\sci_txr_n~combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "cc0f",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \inst_scif|txready_reg~regout\,
	datac => \sci_txr_n~combout\,
	datad => \inst_scif|sclk_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|txready_reg~regout\);

-- Location: LC_X6_Y3_N0
\inst_scif|process_0~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|process_0~0_combout\ = ((\inst_ftif|outvalid_reg~regout\ & ((\inst_scif|txready_reg~regout\) # (\usermode_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fc00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_scif|txready_reg~regout\,
	datac => \usermode_reg~regout\,
	datad => \inst_ftif|outvalid_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|process_0~0_combout\);

-- Location: LC_X6_Y3_N4
\inst_scif|outdata_reg[0]~1\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg[0]~1_combout\ = (\inst_scif|sclk_reg~regout\ & (((\inst_scif|process_0~0_combout\ & \inst_scif|in_ready~0_combout\)) # (!\inst_scif|Equal1~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c444",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|Equal1~0_combout\,
	datab => \inst_scif|sclk_reg~regout\,
	datac => \inst_scif|process_0~0_combout\,
	datad => \inst_scif|in_ready~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|outdata_reg[0]~1_combout\);

-- Location: LC_X3_Y4_N2
\inst_scif|txcounter[0]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txcounter\(0) = DFFEAS((\inst_scif|txcounter\(0) $ (((\inst_scif|outdata_reg[0]~1_combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "33cc",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \inst_scif|txcounter\(0),
	datad => \inst_scif|outdata_reg[0]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|txcounter\(0));

-- Location: LC_X3_Y4_N3
\inst_scif|Equal3~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Equal3~0_combout\ = (((!\inst_scif|txcounter\(1) & !\inst_scif|txcounter\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "000f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \inst_scif|txcounter\(1),
	datad => \inst_scif|txcounter\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Equal3~0_combout\);

-- Location: LC_X3_Y4_N0
\inst_scif|Add0~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add0~0_combout\ = ((\inst_scif|txcounter\(0) & (\inst_scif|txcounter\(1) & \inst_scif|txcounter\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_scif|txcounter\(0),
	datac => \inst_scif|txcounter\(1),
	datad => \inst_scif|txcounter\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add0~0_combout\);

-- Location: LC_X3_Y4_N1
\inst_scif|txcounter[3]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txcounter\(3) = DFFEAS((\inst_scif|txcounter\(3) & (((!\inst_scif|Add0~0_combout\ & \inst_scif|txcounter[1]~1_combout\)) # (!\inst_scif|sclk_reg~regout\))) # (!\inst_scif|txcounter\(3) & (((\inst_scif|Add0~0_combout\ & 
-- \inst_scif|txcounter[1]~1_combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7c44",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|sclk_reg~regout\,
	datab => \inst_scif|txcounter\(3),
	datac => \inst_scif|Add0~0_combout\,
	datad => \inst_scif|txcounter[1]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|txcounter\(3));

-- Location: LC_X3_Y4_N9
\inst_scif|txcounter[1]~1\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txcounter[1]~1_combout\ = (\inst_scif|outdata_reg[0]~1_combout\ & ((\inst_scif|txcounter\(0) $ (\inst_scif|txcounter\(3))) # (!\inst_scif|Equal3~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7d00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|Equal3~0_combout\,
	datab => \inst_scif|txcounter\(0),
	datac => \inst_scif|txcounter\(3),
	datad => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|txcounter[1]~1_combout\);

-- Location: LC_X3_Y4_N6
\inst_scif|txcounter[1]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txcounter\(1) = DFFEAS((\inst_scif|txcounter\(1) & (((!\inst_scif|txcounter\(0) & \inst_scif|txcounter[1]~1_combout\)) # (!\inst_scif|sclk_reg~regout\))) # (!\inst_scif|txcounter\(1) & (\inst_scif|txcounter\(0) & 
-- ((\inst_scif|txcounter[1]~1_combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "6e0a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|txcounter\(1),
	datab => \inst_scif|txcounter\(0),
	datac => \inst_scif|sclk_reg~regout\,
	datad => \inst_scif|txcounter[1]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|txcounter\(1));

-- Location: LC_X3_Y4_N7
\inst_scif|Add0~1\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add0~1_combout\ = (((\inst_scif|txcounter\(1) & \inst_scif|txcounter\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \inst_scif|txcounter\(1),
	datad => \inst_scif|txcounter\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add0~1_combout\);

-- Location: LC_X3_Y4_N8
\inst_scif|txcounter[2]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|txcounter\(2) = DFFEAS((\inst_scif|txcounter\(2) & (((!\inst_scif|Add0~1_combout\ & \inst_scif|txcounter[1]~1_combout\)) # (!\inst_scif|sclk_reg~regout\))) # (!\inst_scif|txcounter\(2) & (((\inst_scif|Add0~1_combout\ & 
-- \inst_scif|txcounter[1]~1_combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7a22",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|txcounter\(2),
	datab => \inst_scif|sclk_reg~regout\,
	datac => \inst_scif|Add0~1_combout\,
	datad => \inst_scif|txcounter[1]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|txcounter\(2));

-- Location: LC_X3_Y4_N5
\inst_scif|Equal1~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Equal1~0_combout\ = (!\inst_scif|txcounter\(2) & (!\inst_scif|txcounter\(0) & (!\inst_scif|txcounter\(1) & !\inst_scif|txcounter\(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|txcounter\(2),
	datab => \inst_scif|txcounter\(0),
	datac => \inst_scif|txcounter\(1),
	datad => \inst_scif|txcounter\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Equal1~0_combout\);

-- Location: LC_X6_Y3_N7
\psstate.state_bit_0~2\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_0~2_combout\ = (\inst_scif|Equal1~0_combout\ & (((\inst_scif|process_0~0_combout\ & \inst_scif|sclk_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_scif|process_0~0_combout\,
	datad => \inst_scif|sclk_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.state_bit_0~2_combout\);

-- Location: LC_X6_Y3_N5
\psstate.state_bit_0~3\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_0~3_combout\ = (\psstate.SETRESP~0_combout\ & (((\inst_scif|in_ready~0_combout\ & !\psstate.state_bit_0~2_combout\)) # (!\inst_ftif|ifstate.FT_WRWAIT2~0_combout\))) # (!\psstate.SETRESP~0_combout\ & (\inst_scif|in_ready~0_combout\ & 
-- (!\psstate.state_bit_0~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0cae",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.SETRESP~0_combout\,
	datab => \inst_scif|in_ready~0_combout\,
	datac => \psstate.state_bit_0~2_combout\,
	datad => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.state_bit_0~3_combout\);

-- Location: LC_X7_Y2_N0
\psstate.state_bit_0\ : maxv_lcell
-- Equation(s):
-- \psstate.state_bit_0~regout\ = DFFEAS((\psstate.state_bit_0~5_combout\) # ((\psstate.state_bit_0~3_combout\) # ((\psstate.state_bit_1~0_combout\ & !\escape_reg~0\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "eefe",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~5_combout\,
	datab => \psstate.state_bit_0~3_combout\,
	datac => \psstate.state_bit_1~0_combout\,
	datad => \escape_reg~0\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \psstate.state_bit_0~regout\);

-- Location: PIN_21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\txe_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_txe_n,
	combout => \txe_n~combout\);

-- Location: LC_X7_Y4_N0
\inst_ftif|ft_txe_reg[0]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ft_txe_reg\(0) = DFFEAS((((!\txe_n~combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \txe_n~combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ft_txe_reg\(0));

-- Location: PIN_48,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sci_rxd~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_sci_rxd,
	combout => \sci_rxd~combout\);

-- Location: LC_X7_Y4_N8
\inst_scif|rxd_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxd_reg~regout\ = DFFEAS((\inst_scif|sclk_reg~regout\ & (\inst_scif|rxd_reg~regout\)) # (!\inst_scif|sclk_reg~regout\ & ((\intreset_n_reg~regout\ & ((\sci_rxd~combout\))) # (!\intreset_n_reg~regout\ & (\inst_scif|rxd_reg~regout\)))), 
-- GLOBAL(\clk24mhz~combout\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ba8a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|rxd_reg~regout\,
	datab => \inst_scif|sclk_reg~regout\,
	datac => \intreset_n_reg~regout\,
	datad => \sci_rxd~combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxd_reg~regout\);

-- Location: LC_X6_Y2_N1
\inst_scif|Add1~5\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add1~5_combout\ = \inst_scif|rxcounter\(0) $ ((\inst_scif|sclk_reg~regout\))
-- \inst_scif|Add1~7\ = CARRY((\inst_scif|rxcounter\(0) & (\inst_scif|sclk_reg~regout\)))
-- \inst_scif|Add1~7COUT1_25\ = CARRY((\inst_scif|rxcounter\(0) & (\inst_scif|sclk_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "6688",
	operation_mode => "arithmetic",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(0),
	datab => \inst_scif|sclk_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add1~5_combout\,
	cout0 => \inst_scif|Add1~7\,
	cout1 => \inst_scif|Add1~7COUT1_25\);

-- Location: LC_X2_Y4_N5
\inst_scif|rxcounter[0]~3\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter[0]~3_combout\ = (((!\inst_scif|Equal0~0_combout\ & \inst_scif|Add1~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \inst_scif|Equal0~0_combout\,
	datad => \inst_scif|Add1~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|rxcounter[0]~3_combout\);

-- Location: LC_X5_Y2_N1
\inst_scif|rxcounter[0]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter\(0) = DFFEAS((\inst_scif|rxcounter[2]~1_combout\ & (((\inst_scif|rxcounter\(0))))) # (!\inst_scif|rxcounter[2]~1_combout\ & ((\inst_scif|Equal4~0_combout\) # ((\inst_scif|rxcounter[0]~3_combout\)))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ccfa",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal4~0_combout\,
	datab => \inst_scif|rxcounter\(0),
	datac => \inst_scif|rxcounter[0]~3_combout\,
	datad => \inst_scif|rxcounter[2]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxcounter\(0));

-- Location: LC_X6_Y2_N5
\inst_scif|indata_reg[0]~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|indata_reg[0]~0_combout\ = (\inst_scif|rxcounter\(1)) # ((\inst_scif|rxcounter\(2)) # (\inst_scif|rxcounter\(3) $ (\inst_scif|rxcounter\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffde",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(3),
	datab => \inst_scif|rxcounter\(1),
	datac => \inst_scif|rxcounter\(0),
	datad => \inst_scif|rxcounter\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|indata_reg[0]~0_combout\);

-- Location: LC_X6_Y2_N2
\inst_scif|Add1~15\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add1~15_combout\ = (\inst_scif|rxcounter\(1) $ ((\inst_scif|Add1~7\)))
-- \inst_scif|Add1~17\ = CARRY(((!\inst_scif|Add1~7\) # (!\inst_scif|rxcounter\(1))))
-- \inst_scif|Add1~17COUT1_27\ = CARRY(((!\inst_scif|Add1~7COUT1_25\) # (!\inst_scif|rxcounter\(1))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_scif|rxcounter\(1),
	cin0 => \inst_scif|Add1~7\,
	cin1 => \inst_scif|Add1~7COUT1_25\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add1~15_combout\,
	cout0 => \inst_scif|Add1~17\,
	cout1 => \inst_scif|Add1~17COUT1_27\);

-- Location: LC_X6_Y2_N9
\inst_scif|rxcounter[1]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter\(1) = DFFEAS(((!\inst_scif|rxcounter[2]~1_combout\ & (\inst_scif|indata_reg[0]~0_combout\ & \inst_scif|Add1~15_combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \inst_scif|rxcounter[2]~1_combout\,
	datac => \inst_scif|indata_reg[0]~0_combout\,
	datad => \inst_scif|Add1~15_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxcounter\(1));

-- Location: LC_X6_Y2_N0
\inst_scif|Equal4~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Equal4~0_combout\ = (!\inst_scif|rxcounter\(3) & (!\inst_scif|rxcounter\(1) & (!\inst_scif|rxcounter\(0) & !\inst_scif|rxcounter\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(3),
	datab => \inst_scif|rxcounter\(1),
	datac => \inst_scif|rxcounter\(0),
	datad => \inst_scif|rxcounter\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Equal4~0_combout\);

-- Location: LC_X7_Y4_N1
\inst_scif|rxcounter[2]~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter[2]~0_combout\ = (\inst_scif|Equal0~0_combout\ & (!\inst_scif|Equal4~0_combout\ & ((\psstate.SETRESP~0_combout\) # (!\inst_ftif|ifstate.FT_WRWAIT2~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "2202",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|Equal0~0_combout\,
	datab => \inst_scif|Equal4~0_combout\,
	datac => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\,
	datad => \psstate.SETRESP~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|rxcounter[2]~0_combout\);

-- Location: LC_X7_Y4_N9
\inst_scif|rxcounter[2]~1\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter[2]~1_combout\ = (\inst_scif|rxcounter[2]~0_combout\) # ((\inst_scif|Equal4~0_combout\ & ((\inst_scif|rxd_reg~regout\) # (!\inst_scif|sclk_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffb0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxd_reg~regout\,
	datab => \inst_scif|sclk_reg~regout\,
	datac => \inst_scif|Equal4~0_combout\,
	datad => \inst_scif|rxcounter[2]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|rxcounter[2]~1_combout\);

-- Location: LC_X6_Y2_N3
\inst_scif|Add1~10\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add1~10_combout\ = \inst_scif|rxcounter\(2) $ ((((!\inst_scif|Add1~17\))))
-- \inst_scif|Add1~12\ = CARRY((\inst_scif|rxcounter\(2) & ((!\inst_scif|Add1~17\))))
-- \inst_scif|Add1~12COUT1_29\ = CARRY((\inst_scif|rxcounter\(2) & ((!\inst_scif|Add1~17COUT1_27\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(2),
	cin0 => \inst_scif|Add1~17\,
	cin1 => \inst_scif|Add1~17COUT1_27\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add1~10_combout\,
	cout0 => \inst_scif|Add1~12\,
	cout1 => \inst_scif|Add1~12COUT1_29\);

-- Location: LC_X6_Y2_N8
\inst_scif|rxcounter[2]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter\(2) = DFFEAS(((!\inst_scif|rxcounter[2]~1_combout\ & (\inst_scif|indata_reg[0]~0_combout\ & \inst_scif|Add1~10_combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \inst_scif|rxcounter[2]~1_combout\,
	datac => \inst_scif|indata_reg[0]~0_combout\,
	datad => \inst_scif|Add1~10_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxcounter\(2));

-- Location: LC_X6_Y2_N4
\inst_scif|Add1~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Add1~0_combout\ = \inst_scif|rxcounter\(3) $ ((((\inst_scif|Add1~12\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	lut_mask => "5a5a",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(3),
	cin0 => \inst_scif|Add1~12\,
	cin1 => \inst_scif|Add1~12COUT1_29\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Add1~0_combout\);

-- Location: LC_X6_Y2_N6
\inst_scif|rxcounter[3]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxcounter\(3) = DFFEAS((\inst_scif|rxcounter[2]~1_combout\ & (\inst_scif|rxcounter\(3))) # (!\inst_scif|rxcounter[2]~1_combout\ & (((\inst_scif|Add1~0_combout\ & \inst_scif|indata_reg[0]~0_combout\)))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "aac0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|rxcounter\(3),
	datab => \inst_scif|Add1~0_combout\,
	datac => \inst_scif|indata_reg[0]~0_combout\,
	datad => \inst_scif|rxcounter[2]~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxcounter\(3));

-- Location: LC_X6_Y2_N7
\inst_scif|Equal0~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|Equal0~0_combout\ = (\inst_scif|rxcounter\(3) & (!\inst_scif|rxcounter\(1) & (\inst_scif|rxcounter\(0) & !\inst_scif|rxcounter\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0020",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_scif|rxcounter\(3),
	datab => \inst_scif|rxcounter\(1),
	datac => \inst_scif|rxcounter\(0),
	datad => \inst_scif|rxcounter\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|Equal0~0_combout\);

-- Location: LC_X7_Y4_N7
\inst_ftif|ft_txe_reg[1]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_0~4\ = (B1_ft_txe_reg[1] & ((\inst_scif|Equal0~0_combout\) # ((\psstate.state_bit_0~regout\ & \psstate.state_bit_2~regout\))))
-- \inst_ftif|ft_txe_reg\(1) = DFFEAS(\inst_ftif|ifstate.state_bit_0~4\, GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , \inst_ftif|ft_txe_reg\(0), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f080",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \psstate.state_bit_2~regout\,
	datac => \inst_ftif|ft_txe_reg\(0),
	datad => \inst_scif|Equal0~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.state_bit_0~4\,
	regout => \inst_ftif|ft_txe_reg\(1));

-- Location: PIN_22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\rxf_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_rxf_n,
	combout => \rxf_n~combout\);

-- Location: LC_X3_Y2_N7
\inst_ftif|ft_rxf_reg[0]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ft_rxf_reg\(0) = DFFEAS((((!\rxf_n~combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \rxf_n~combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ft_rxf_reg\(0));

-- Location: LC_X3_Y2_N2
\inst_ftif|ft_rxf_reg[1]\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|process_1~0\ = ((!\inst_ftif|outvalid_reg~regout\ & (B1_ft_rxf_reg[1])))
-- \inst_ftif|ft_rxf_reg\(1) = DFFEAS(\inst_ftif|process_1~0\, GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , \inst_ftif|ft_rxf_reg\(0), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3030",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datab => \inst_ftif|outvalid_reg~regout\,
	datac => \inst_ftif|ft_rxf_reg\(0),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|process_1~0\,
	regout => \inst_ftif|ft_rxf_reg\(1));

-- Location: LC_X4_Y2_N3
\inst_ftif|ifstate.state_bit_0~2\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_0~2_combout\ = (!\inst_ftif|ifstate.state_bit_0~regout\ & ((\inst_ftif|ifstate.state_bit_2~regout\) # ((\inst_ftif|ifstate.state_bit_1~regout\ & !\inst_ftif|ifstate.state_bit_3~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f02",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ifstate.state_bit_1~regout\,
	datab => \inst_ftif|ifstate.state_bit_3~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|ifstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.state_bit_0~2_combout\);

-- Location: LC_X4_Y2_N7
\inst_ftif|ifstate.state_bit_0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_0~regout\ = DFFEAS((\inst_ftif|ifstate.state_bit_0~2_combout\) # ((\inst_ftif|ifstate.IDLE~0_combout\ & ((\inst_ftif|ifstate.state_bit_0~4\) # (\inst_ftif|process_1~0\)))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffe0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.state_bit_0~4\,
	datab => \inst_ftif|process_1~0\,
	datac => \inst_ftif|ifstate.IDLE~0_combout\,
	datad => \inst_ftif|ifstate.state_bit_0~2_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ifstate.state_bit_0~regout\);

-- Location: LC_X4_Y2_N6
\inst_ftif|ifstate.FT_WRWAIT2~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.FT_WRWAIT2~0_combout\ = (!\inst_ftif|ifstate.state_bit_1~regout\ & (((\inst_ftif|ifstate.state_bit_0~regout\ & \inst_ftif|ifstate.state_bit_2~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|ifstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\);

-- Location: LC_X3_Y2_N4
\inst_ftif|ifstate.state_bit_3\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_3~regout\ = DFFEAS((\inst_ftif|ifstate.FT_WRWAIT2~0_combout\) # ((\inst_ftif|ifstate.state_bit_3~0_combout\ & ((\inst_ftif|ifstate.state_bit_1~regout\) # (\inst_ftif|ft_txe_reg\(1))))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "faf8",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.state_bit_3~0_combout\,
	datab => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\,
	datad => \inst_ftif|ft_txe_reg\(1),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ifstate.state_bit_3~regout\);

-- Location: LC_X4_Y2_N1
\inst_ftif|ifstate.state_bit_2\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_2~regout\ = DFFEAS((\inst_ftif|ifstate.state_bit_1~regout\ & (!\inst_ftif|ifstate.state_bit_0~regout\ & ((\inst_ftif|ifstate.state_bit_2~regout\) # (!\inst_ftif|ifstate.state_bit_3~regout\)))) # 
-- (!\inst_ftif|ifstate.state_bit_1~regout\ & ((\inst_ftif|ifstate.state_bit_0~regout\ $ (\inst_ftif|ifstate.state_bit_2~regout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f52",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.state_bit_1~regout\,
	datab => \inst_ftif|ifstate.state_bit_3~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|ifstate.state_bit_2~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ifstate.state_bit_2~regout\);

-- Location: LC_X7_Y2_N5
\Selector6~0\ : maxv_lcell
-- Equation(s):
-- \Selector6~0_combout\ = (\psstate.state_bit_0~regout\) # ((\psstate.state_bit_2~regout\ & (!\inst_ftif|outvalid_reg~regout\)) # (!\psstate.state_bit_2~regout\ & ((!\psstate.state_bit_1~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "bbaf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~regout\,
	datab => \inst_ftif|outvalid_reg~regout\,
	datac => \psstate.state_bit_1~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector6~0_combout\);

-- Location: LC_X7_Y2_N3
bytedlop_reg : maxv_lcell
-- Equation(s):
-- \bytedlop_reg~regout\ = DFFEAS((\Selector6~0_combout\ & ((\bytedlop_reg~regout\) # ((\psstate.state_bit_1~1\ & \psstate.state_bit_1~0_combout\)))) # (!\Selector6~0_combout\ & (\psstate.state_bit_1~1\ & (\psstate.state_bit_1~0_combout\))), 
-- GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "eac0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \Selector6~0_combout\,
	datab => \psstate.state_bit_1~1\,
	datac => \psstate.state_bit_1~0_combout\,
	datad => \bytedlop_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \bytedlop_reg~regout\);

-- Location: LC_X6_Y3_N9
\inst_ftif|outvalid_reg~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outvalid_reg~0_combout\ = (\timeout_reg~regout\) # ((\bytedlop_reg~regout\) # ((\psstate.state_bit_0~2_combout\ & \inst_scif|in_ready~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fefc",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \psstate.state_bit_0~2_combout\,
	datab => \timeout_reg~regout\,
	datac => \bytedlop_reg~regout\,
	datad => \inst_scif|in_ready~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|outvalid_reg~0_combout\);

-- Location: LC_X3_Y2_N0
\inst_ftif|outvalid_reg\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|outvalid_reg~regout\ = DFFEAS((\inst_ftif|outvalid_reg~regout\ & (((!\inst_ftif|outvalid_reg~0_combout\)))) # (!\inst_ftif|outvalid_reg~regout\ & (\inst_ftif|ifstate.state_bit_2~regout\ & (\inst_ftif|ifstate.state_bit_1~regout\))), 
-- GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "08f8",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.state_bit_2~regout\,
	datab => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|outvalid_reg~regout\,
	datad => \inst_ftif|outvalid_reg~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|outvalid_reg~regout\);

-- Location: LC_X4_Y2_N0
\inst_ftif|ifstate.state_bit_1~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_1~0_combout\ = (\inst_ftif|ft_rxf_reg\(1)) # (((\inst_ftif|ifstate.state_bit_0~regout\) # (\inst_ftif|ifstate.state_bit_2~regout\)) # (!\inst_ftif|ifstate.state_bit_3~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fffb",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ft_rxf_reg\(1),
	datab => \inst_ftif|ifstate.state_bit_3~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|ifstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.state_bit_1~0_combout\);

-- Location: LC_X4_Y2_N4
\inst_ftif|ifstate.state_bit_1\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.state_bit_1~regout\ = DFFEAS((\inst_ftif|ifstate.state_bit_1~regout\ & ((\inst_ftif|ifstate.state_bit_1~0_combout\) # ((\inst_ftif|ifstate.IDLE~0_combout\ & \inst_ftif|process_1~0\)))) # (!\inst_ftif|ifstate.state_bit_1~regout\ & 
-- (((\inst_ftif|ifstate.IDLE~0_combout\ & \inst_ftif|process_1~0\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f888",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.state_bit_1~regout\,
	datab => \inst_ftif|ifstate.state_bit_1~0_combout\,
	datac => \inst_ftif|ifstate.IDLE~0_combout\,
	datad => \inst_ftif|process_1~0\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ifstate.state_bit_1~regout\);

-- Location: LC_X4_Y2_N5
\inst_ftif|ifstate.IDLE~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ifstate.IDLE~0_combout\ = (!\inst_ftif|ifstate.state_bit_1~regout\ & (!\inst_ftif|ifstate.state_bit_3~regout\ & (!\inst_ftif|ifstate.state_bit_0~regout\ & !\inst_ftif|ifstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ifstate.state_bit_1~regout\,
	datab => \inst_ftif|ifstate.state_bit_3~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|ifstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|ifstate.IDLE~0_combout\);

-- Location: LC_X3_Y2_N5
\inst_ftif|Selector9~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|Selector9~0_combout\ = ((\inst_ftif|ifstate.state_bit_1~regout\ & (\inst_ftif|ifstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c0c0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_ftif|ifstate.state_bit_1~regout\,
	datac => \inst_ftif|ifstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|Selector9~0_combout\);

-- Location: LC_X3_Y2_N3
\inst_ftif|ft_rd_reg\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ft_rd_reg~regout\ = DFFEAS((\inst_ftif|ft_rd_reg~regout\ & (((\inst_ftif|ifstate.IDLE~0_combout\ & \inst_ftif|process_1~0\)) # (!\inst_ftif|Selector9~0_combout\))) # (!\inst_ftif|ft_rd_reg~regout\ & (\inst_ftif|ifstate.IDLE~0_combout\ & 
-- ((\inst_ftif|process_1~0\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ce0a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ft_rd_reg~regout\,
	datab => \inst_ftif|ifstate.IDLE~0_combout\,
	datac => \inst_ftif|Selector9~0_combout\,
	datad => \inst_ftif|process_1~0\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ft_rd_reg~regout\);

-- Location: LC_X4_Y2_N8
\inst_ftif|Selector10~0\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|Selector10~0_combout\ = (\inst_ftif|ifstate.state_bit_0~4\ & (\inst_ftif|ifstate.IDLE~0_combout\ & ((\inst_ftif|outvalid_reg~regout\) # (!\inst_ftif|ft_rxf_reg\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c040",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \inst_ftif|ft_rxf_reg\(1),
	datab => \inst_ftif|ifstate.state_bit_0~4\,
	datac => \inst_ftif|ifstate.IDLE~0_combout\,
	datad => \inst_ftif|outvalid_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_ftif|Selector10~0_combout\);

-- Location: LC_X4_Y2_N9
\inst_ftif|ft_wr_reg\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ft_wr_reg~regout\ = DFFEAS((\inst_ftif|Selector10~0_combout\) # ((\inst_ftif|ft_wr_reg~regout\ & ((\inst_ftif|ifstate.state_bit_0~regout\) # (!\inst_ftif|ifstate.state_bit_2~regout\)))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffa2",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ft_wr_reg~regout\,
	datab => \inst_ftif|ifstate.state_bit_2~regout\,
	datac => \inst_ftif|ifstate.state_bit_0~regout\,
	datad => \inst_ftif|Selector10~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ft_wr_reg~regout\);

-- Location: LC_X7_Y3_N3
sendimm_reg : maxv_lcell
-- Equation(s):
-- \sendimm_reg~regout\ = DFFEAS(GND, GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, \inst_ftif|outdata_reg\(1), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datac => \inst_ftif|outdata_reg\(1),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sload => VCC,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \sendimm_reg~regout\);

-- Location: LC_X6_Y3_N6
\inst_scif|confmode_reg~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|confmode_reg~0_combout\ = ((\inst_scif|sclk_reg~regout\ & (\inst_scif|process_0~0_combout\ & \inst_scif|in_ready~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_scif|sclk_reg~regout\,
	datac => \inst_scif|process_0~0_combout\,
	datad => \inst_scif|in_ready~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|confmode_reg~0_combout\);

-- Location: LC_X5_Y2_N9
\inst_scif|confmode_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|confmode_reg~regout\ = DFFEAS((\inst_scif|Equal1~0_combout\ & ((\inst_scif|confmode_reg~0_combout\ & ((\usermode_reg~regout\))) # (!\inst_scif|confmode_reg~0_combout\ & (\inst_scif|confmode_reg~regout\)))) # (!\inst_scif|Equal1~0_combout\ & 
-- (\inst_scif|confmode_reg~regout\)), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ec4c",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datab => \inst_scif|confmode_reg~regout\,
	datac => \inst_scif|confmode_reg~0_combout\,
	datad => \usermode_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|confmode_reg~regout\);

-- Location: LC_X5_Y2_N4
\inst_scif|dclk_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|dclk_reg~regout\ = DFFEAS((!\inst_scif|sclk_reg~regout\ & (\inst_scif|confmode_reg~regout\ & ((\inst_scif|txcounter\(3)) # (!\inst_scif|Equal3~0_combout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4500",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|sclk_reg~regout\,
	datab => \inst_scif|txcounter\(3),
	datac => \inst_scif|Equal3~0_combout\,
	datad => \inst_scif|confmode_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|dclk_reg~regout\);

-- Location: LC_X5_Y2_N6
\inst_scif|outdata_reg[8]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(8) = DFFEAS(((\inst_scif|confmode_reg~0_combout\ & (\inst_ftif|outdata_reg\(7))) # (!\inst_scif|confmode_reg~0_combout\ & ((\inst_scif|outdata_reg\(8))))), GLOBAL(\clk24mhz~combout\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "aaf0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|outdata_reg\(7),
	datac => \inst_scif|outdata_reg\(8),
	datad => \inst_scif|confmode_reg~0_combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(8));

-- Location: LC_X5_Y2_N7
\inst_scif|outdata_reg[7]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(7) = DFFEAS((\inst_scif|Equal1~0_combout\ & (\inst_ftif|outdata_reg\(6))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(8))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8d8",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datab => \inst_ftif|outdata_reg\(6),
	datac => \inst_scif|outdata_reg\(8),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(7));

-- Location: LC_X7_Y2_N1
\psstate.THROW~0\ : maxv_lcell
-- Equation(s):
-- \psstate.THROW~0_combout\ = ((!\psstate.state_bit_1~regout\ & (\psstate.state_bit_0~regout\ & !\psstate.state_bit_2~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \psstate.state_bit_1~regout\,
	datac => \psstate.state_bit_0~regout\,
	datad => \psstate.state_bit_2~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \psstate.THROW~0_combout\);

-- Location: LC_X6_Y3_N3
\escape_reg~1\ : maxv_lcell
-- Equation(s):
-- \escape_reg~1_combout\ = (\escape_reg~regout\ & (((!\inst_scif|in_ready~0_combout\) # (!\psstate.state_bit_0~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0aaa",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \escape_reg~regout\,
	datac => \psstate.state_bit_0~2_combout\,
	datad => \inst_scif|in_ready~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \escape_reg~1_combout\);

-- Location: LC_X6_Y3_N8
escape_reg : maxv_lcell
-- Equation(s):
-- \escape_reg~regout\ = DFFEAS((\escape_reg~1_combout\) # ((\escape_reg~0\ & (\psstate.state_bit_1~0_combout\ & !\psstate.THROW~0_combout\))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff08",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \escape_reg~0\,
	datab => \psstate.state_bit_1~0_combout\,
	datac => \psstate.THROW~0_combout\,
	datad => \escape_reg~1_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \escape_reg~regout\);

-- Location: LC_X5_Y2_N8
\inst_scif|outdata_reg[6]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(6) = DFFEAS((\inst_scif|Equal1~0_combout\ & ((\inst_ftif|outdata_reg\(5) $ (\escape_reg~regout\)))) # (!\inst_scif|Equal1~0_combout\ & (\inst_scif|outdata_reg\(7))), GLOBAL(\clk24mhz~combout\), VCC, , 
-- \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4ee4",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datab => \inst_scif|outdata_reg\(7),
	datac => \inst_ftif|outdata_reg\(5),
	datad => \escape_reg~regout\,
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(6));

-- Location: LC_X4_Y4_N6
\inst_scif|outdata_reg[5]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(5) = DFFEAS((\inst_scif|Equal1~0_combout\ & (((\inst_ftif|outdata_reg\(4))))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(6))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f5a0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_ftif|outdata_reg\(4),
	datad => \inst_scif|outdata_reg\(6),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(5));

-- Location: LC_X4_Y4_N7
\inst_scif|outdata_reg[4]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(4) = DFFEAS((\inst_scif|Equal1~0_combout\ & (((\inst_ftif|outdata_reg\(3))))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(5))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fa50",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_scif|outdata_reg\(5),
	datad => \inst_ftif|outdata_reg\(3),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(4));

-- Location: LC_X4_Y4_N3
\inst_scif|outdata_reg[3]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(3) = DFFEAS((\inst_scif|Equal1~0_combout\ & (((\inst_ftif|outdata_reg\(2))))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(4))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fa50",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_scif|outdata_reg\(4),
	datad => \inst_ftif|outdata_reg\(2),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(3));

-- Location: LC_X4_Y4_N0
\inst_scif|outdata_reg[2]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(2) = DFFEAS((\inst_scif|Equal1~0_combout\ & (((\inst_ftif|outdata_reg\(1))))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(3))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f5a0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_ftif|outdata_reg\(1),
	datad => \inst_scif|outdata_reg\(3),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(2));

-- Location: LC_X4_Y4_N2
\inst_scif|outdata_reg[1]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(1) = DFFEAS((\inst_scif|Equal1~0_combout\ & (((\inst_ftif|outdata_reg\(0))))) # (!\inst_scif|Equal1~0_combout\ & (((\inst_scif|outdata_reg\(2))))), GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fa50",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal1~0_combout\,
	datac => \inst_scif|outdata_reg\(2),
	datad => \inst_ftif|outdata_reg\(0),
	aclr => GND,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(1));

-- Location: LC_X3_Y4_N4
\inst_scif|outdata_reg[0]\ : maxv_lcell
-- Equation(s):
-- \inst_scif|outdata_reg\(0) = DFFEAS((\inst_scif|outdata_reg\(1) & (!\inst_scif|txcounter\(0) & (!\inst_scif|txcounter\(3) & \inst_scif|Equal3~0_combout\))) # (!\inst_scif|outdata_reg\(1) & (((!\inst_scif|Equal3~0_combout\) # (!\inst_scif|txcounter\(3))) # 
-- (!\inst_scif|txcounter\(0)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \inst_scif|outdata_reg[0]~1_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1755",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|outdata_reg\(1),
	datab => \inst_scif|txcounter\(0),
	datac => \inst_scif|txcounter\(3),
	datad => \inst_scif|Equal3~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	ena => \inst_scif|outdata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|outdata_reg\(0));

-- Location: PIN_32,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\msel1~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_msel1,
	combout => \msel1~combout\);

-- Location: PIN_62,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: Default
\mreset_n_in~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_mreset_n_in,
	combout => \mreset_n_in~combout\);

-- Location: LC_X7_Y3_N9
nconfig_reg : maxv_lcell
-- Equation(s):
-- \nconfig_reg~regout\ = DFFEAS((((!\inst_ftif|outdata_reg\(0)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \inst_ftif|outdata_reg\(0),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \nconfig_reg~regout\);

-- Location: LC_X5_Y1_N7
\nconfig~1\ : maxv_lcell
-- Equation(s):
-- \nconfig~1_combout\ = ((\msel1~combout\ & (\mreset_n_in~combout\)) # (!\msel1~combout\ & ((!\nconfig_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c0f3",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \msel1~combout\,
	datac => \mreset_n_in~combout\,
	datad => \nconfig_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \nconfig~1_combout\);

-- Location: PIN_1,	 I/O Standard: 3.3V Schmitt Trigger Input,	 Current Strength: Default
\conn_tck_in~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_conn_tck_in,
	combout => \conn_tck_in~combout\);

-- Location: PIN_53,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\tdo~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_tdo,
	combout => \tdo~combout\);

-- Location: LC_X2_Y4_N1
tdoout_reg : maxv_lcell
-- Equation(s):
-- \tdoout_reg~regout\ = DFFEAS((((\tdo~combout\))), !\conn_tck_in~combout\, VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff00",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_conn_tck_in~combout\,
	datad => \tdo~combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tdoout_reg~regout\);

-- Location: LC_X7_Y3_N4
sclout_reg : maxv_lcell
-- Equation(s):
-- \sclout_reg~regout\ = DFFEAS((((!\inst_ftif|outdata_reg\(4)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f0f",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datac => \inst_ftif|outdata_reg\(4),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \sclout_reg~regout\);

-- Location: LC_X7_Y3_N5
jtagena_reg : maxv_lcell
-- Equation(s):
-- \tck~0\ = (jtagena_reg & (!\sclout_reg~regout\)) # (!jtagena_reg & (((\conn_tck_in~combout\))))
-- \jtagena_reg~regout\ = DFFEAS(\tck~0\, GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, \inst_ftif|outdata_reg\(7), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5c5c",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \sclout_reg~regout\,
	datab => \conn_tck_in~combout\,
	datac => \inst_ftif|outdata_reg\(7),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	sload => VCC,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tck~0\,
	regout => \jtagena_reg~regout\);

-- Location: LC_X7_Y3_N0
jtagtdi_reg : maxv_lcell
-- Equation(s):
-- \jtagtdi_reg~regout\ = DFFEAS((\intreset_n_reg~regout\ & ((\sendimm_reg~0_combout\ & ((\inst_ftif|outdata_reg\(6)))) # (!\sendimm_reg~0_combout\ & (\jtagtdi_reg~regout\)))) # (!\intreset_n_reg~regout\ & (\jtagtdi_reg~regout\)), GLOBAL(\clk24mhz~combout\), 
-- VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "e4cc",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \intreset_n_reg~regout\,
	datab => \jtagtdi_reg~regout\,
	datac => \inst_ftif|outdata_reg\(6),
	datad => \sendimm_reg~0_combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \jtagtdi_reg~regout\);

-- Location: PIN_2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\conn_tdi_in~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_conn_tdi_in,
	combout => \conn_tdi_in~combout\);

-- Location: LC_X7_Y3_N6
\tdi~0\ : maxv_lcell
-- Equation(s):
-- \tdi~0_combout\ = (\jtagena_reg~regout\ & (\jtagtdi_reg~regout\)) # (!\jtagena_reg~regout\ & (((\conn_tdi_in~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8d8",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \jtagena_reg~regout\,
	datab => \jtagtdi_reg~regout\,
	datac => \conn_tdi_in~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tdi~0_combout\);

-- Location: LC_X7_Y3_N8
sdaout_reg : maxv_lcell
-- Equation(s):
-- \sdaout_reg~regout\ = DFFEAS((((!\inst_ftif|outdata_reg\(5)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , \sendimm_reg~0_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	datad => \inst_ftif|outdata_reg\(5),
	aclr => \ALT_INV_intreset_n_reg~regout\,
	ena => \sendimm_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \sdaout_reg~regout\);

-- Location: PIN_64,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\conn_tms_in~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_conn_tms_in,
	combout => \conn_tms_in~combout\);

-- Location: LC_X2_Y4_N9
\tms~0\ : maxv_lcell
-- Equation(s):
-- \tms~0_combout\ = ((\jtagena_reg~regout\ & (!\sdaout_reg~regout\)) # (!\jtagena_reg~regout\ & ((\conn_tms_in~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5f50",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \sdaout_reg~regout\,
	datac => \jtagena_reg~regout\,
	datad => \conn_tms_in~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tms~0_combout\);

-- Location: LC_X5_Y2_N5
\reset_n_out~0\ : maxv_lcell
-- Equation(s):
-- \reset_n_out~0_combout\ = (((\mreset_n_ext~0\ & !\usermode_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \mreset_n_ext~0\,
	datad => \usermode_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \reset_n_out~0_combout\);

-- Location: LC_X5_Y2_N3
\inst_scif|sci_txd~0\ : maxv_lcell
-- Equation(s):
-- \inst_scif|sci_txd~0_combout\ = (((\inst_scif|confmode_reg~regout\) # (!\inst_scif|outdata_reg\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff0f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \inst_scif|outdata_reg\(0),
	datad => \inst_scif|confmode_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|sci_txd~0_combout\);

-- Location: LC_X5_Y2_N0
\inst_scif|rxready_reg\ : maxv_lcell
-- Equation(s):
-- \inst_scif|rxready_reg~regout\ = DFFEAS(((\inst_scif|sclk_reg~regout\ & (\inst_scif|Equal4~0_combout\)) # (!\inst_scif|sclk_reg~regout\ & ((\inst_scif|rxready_reg~regout\)))), GLOBAL(\clk24mhz~combout\), GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "aaf0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_scif|Equal4~0_combout\,
	datac => \inst_scif|rxready_reg~regout\,
	datad => \inst_scif|sclk_reg~regout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_scif|rxready_reg~regout\);

-- Location: LC_X5_Y2_N2
\sci_rxr_n~0\ : maxv_lcell
-- Equation(s):
-- \sci_rxr_n~0_combout\ = (((\usermode_reg~regout\) # (!\inst_scif|rxready_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff0f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \inst_scif|rxready_reg~regout\,
	datad => \usermode_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \sci_rxr_n~0_combout\);

-- Location: PIN_31,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\confdone~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_confdone,
	combout => \confdone~combout\);

-- Location: LC_X2_Y1_N2
\led_n_out~0\ : maxv_lcell
-- Equation(s):
-- \led_n_out~0_combout\ = (\confdone~combout\ & (!\usermode_reg~regout\ & ((!tocount_reg(22)) # (!\timeout_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "004c",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \timeout_reg~regout\,
	datab => \confdone~combout\,
	datac => tocount_reg(22),
	datad => \usermode_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \led_n_out~0_combout\);

-- Location: PIN_29,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\nstatus~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_nstatus,
	combout => \nstatus~combout\);

-- Location: LC_X7_Y4_N5
\inst_scif|indata_reg[0]~1\ : maxv_lcell
-- Equation(s):
-- \inst_scif|indata_reg[0]~1_combout\ = ((\inst_scif|indata_reg[0]~0_combout\ & (\intreset_n_reg~regout\ & \inst_scif|sclk_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \inst_scif|indata_reg[0]~0_combout\,
	datac => \intreset_n_reg~regout\,
	datad => \inst_scif|sclk_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \inst_scif|indata_reg[0]~1_combout\);

-- Location: LC_X7_Y4_N6
\inst_scif|indata_reg[7]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[7]~7\ = (C1_indata_reg[7] & (((!\psstate.state_bit_2~regout\)) # (!\psstate.state_bit_0~regout\)))
-- \inst_scif|indata_reg\(7) = DFFEAS(\usb_txdata_sig[7]~7\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|rxd_reg~regout\, , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7070",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \psstate.state_bit_2~regout\,
	datac => \inst_scif|rxd_reg~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[7]~7\,
	regout => \inst_scif|indata_reg\(7));

-- Location: LC_X7_Y4_N3
\inst_scif|indata_reg[6]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[6]~6\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & ((\tdo~combout\))) # (!\psstate.state_bit_2~regout\ & (C1_indata_reg[6])))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[6]))))
-- \inst_scif|indata_reg\(6) = DFFEAS(\usb_txdata_sig[6]~6\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(7), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f870",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \psstate.state_bit_2~regout\,
	datac => \inst_scif|indata_reg\(7),
	datad => \tdo~combout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[6]~6\,
	regout => \inst_scif|indata_reg\(6));

-- Location: LC_X7_Y4_N4
\inst_scif|indata_reg[5]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[5]~5\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & ((\i2c_sda~0\))) # (!\psstate.state_bit_2~regout\ & (C1_indata_reg[5])))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[5]))))
-- \inst_scif|indata_reg\(5) = DFFEAS(\usb_txdata_sig[5]~5\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(6), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f870",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \psstate.state_bit_2~regout\,
	datac => \inst_scif|indata_reg\(6),
	datad => \i2c_sda~0\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[5]~5\,
	regout => \inst_scif|indata_reg\(5));

-- Location: LC_X2_Y1_N6
\inst_scif|indata_reg[4]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[4]~4\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & (\i2c_scl~0\)) # (!\psstate.state_bit_2~regout\ & ((C1_indata_reg[4]))))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[4]))))
-- \inst_scif|indata_reg\(4) = DFFEAS(\usb_txdata_sig[4]~4\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(5), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8f0",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \i2c_scl~0\,
	datac => \inst_scif|indata_reg\(5),
	datad => \psstate.state_bit_2~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[4]~4\,
	regout => \inst_scif|indata_reg\(4));

-- Location: LC_X2_Y1_N5
\inst_scif|indata_reg[3]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[3]~3\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & ((\timeout_reg~regout\))) # (!\psstate.state_bit_2~regout\ & (C1_indata_reg[3])))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[3]))))
-- \inst_scif|indata_reg\(3) = DFFEAS(\usb_txdata_sig[3]~3\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(4), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f870",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \psstate.state_bit_2~regout\,
	datac => \inst_scif|indata_reg\(4),
	datad => \timeout_reg~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[3]~3\,
	regout => \inst_scif|indata_reg\(3));

-- Location: LC_X2_Y1_N7
\inst_scif|indata_reg[2]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[2]~2\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & (\confdone~combout\)) # (!\psstate.state_bit_2~regout\ & ((C1_indata_reg[2]))))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[2]))))
-- \inst_scif|indata_reg\(2) = DFFEAS(\usb_txdata_sig[2]~2\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(3), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8f0",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \confdone~combout\,
	datac => \inst_scif|indata_reg\(3),
	datad => \psstate.state_bit_2~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[2]~2\,
	regout => \inst_scif|indata_reg\(2));

-- Location: LC_X2_Y1_N8
\inst_scif|indata_reg[1]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[1]~1\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & (\nstatus~combout\)) # (!\psstate.state_bit_2~regout\ & ((C1_indata_reg[1]))))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[1]))))
-- \inst_scif|indata_reg\(1) = DFFEAS(\usb_txdata_sig[1]~1\, GLOBAL(\clk24mhz~combout\), VCC, , \inst_scif|indata_reg[0]~1_combout\, \inst_scif|indata_reg\(2), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8f0",
	operation_mode => "normal",
	output_mode => "reg_and_comb",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \nstatus~combout\,
	datac => \inst_scif|indata_reg\(2),
	datad => \psstate.state_bit_2~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[1]~1\,
	regout => \inst_scif|indata_reg\(1));

-- Location: LC_X2_Y1_N0
\inst_scif|indata_reg[0]\ : maxv_lcell
-- Equation(s):
-- \usb_txdata_sig[0]~0\ = (\psstate.state_bit_0~regout\ & ((\psstate.state_bit_2~regout\ & (\msel1~combout\)) # (!\psstate.state_bit_2~regout\ & ((C1_indata_reg[0]))))) # (!\psstate.state_bit_0~regout\ & (((C1_indata_reg[0]))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d8f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \psstate.state_bit_0~regout\,
	datab => \msel1~combout\,
	datac => \inst_scif|indata_reg\(1),
	datad => \psstate.state_bit_2~regout\,
	aclr => GND,
	sload => VCC,
	ena => \inst_scif|indata_reg[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \usb_txdata_sig[0]~0\,
	regout => \inst_scif|indata_reg\(0));

-- Location: LC_X4_Y2_N2
\inst_ftif|ft_doe_reg\ : maxv_lcell
-- Equation(s):
-- \inst_ftif|ft_doe_reg~regout\ = DFFEAS((\inst_ftif|Selector10~0_combout\) # ((\inst_ftif|ft_doe_reg~regout\ & ((\inst_ftif|ifstate.IDLE~0_combout\) # (!\inst_ftif|ifstate.FT_WRWAIT2~0_combout\)))), GLOBAL(\clk24mhz~combout\), 
-- GLOBAL(\intreset_n_reg~regout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff8c",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk24mhz~combout\,
	dataa => \inst_ftif|ifstate.IDLE~0_combout\,
	datab => \inst_ftif|ft_doe_reg~regout\,
	datac => \inst_ftif|ifstate.FT_WRWAIT2~0_combout\,
	datad => \inst_ftif|Selector10~0_combout\,
	aclr => \ALT_INV_intreset_n_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \inst_ftif|ft_doe_reg~regout\);

-- Location: LC_X7_Y3_N7
\i2c_scl~2\ : maxv_lcell
-- Equation(s):
-- \i2c_scl~2_combout\ = (\jtagena_reg~regout\) # (((!\sclout_reg~regout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "afaf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \jtagena_reg~regout\,
	datac => \sclout_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \i2c_scl~2_combout\);

-- Location: LC_X2_Y4_N7
\i2c_sda~2\ : maxv_lcell
-- Equation(s):
-- \i2c_sda~2_combout\ = (((\jtagena_reg~regout\))) # (!\sdaout_reg~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f5f5",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \sdaout_reg~regout\,
	datac => \jtagena_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \i2c_sda~2_combout\);

-- Location: LC_X5_Y1_N5
\mreset_n_ext~2\ : maxv_lcell
-- Equation(s):
-- \mreset_n_ext~2_combout\ = (\intreset_n_reg~regout\ & (((\mreset_n_in~combout\ & !\usermode_reg~regout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00a0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \intreset_n_reg~regout\,
	datac => \mreset_n_in~combout\,
	datad => \usermode_reg~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \mreset_n_ext~2_combout\);

-- Location: PIN_5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\rd_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_ftif|ALT_INV_ft_rd_reg~regout\,
	oe => VCC,
	padio => ww_rd_n);

-- Location: PIN_4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\wr~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_ftif|ft_wr_reg~regout\,
	oe => VCC,
	padio => ww_wr);

-- Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\si_wu_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_sendimm_reg~regout\,
	oe => VCC,
	padio => ww_si_wu_n);

-- Location: PIN_58,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\dclk~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_scif|dclk_reg~regout\,
	oe => \usermode_reg~regout\,
	padio => ww_dclk);

-- Location: PIN_59,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\data0~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_scif|ALT_INV_outdata_reg\(0),
	oe => \usermode_reg~regout\,
	padio => ww_data0);

-- Location: PIN_30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\nconfig~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	open_drain_output => "true",
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \nconfig~1_combout\,
	oe => VCC,
	padio => ww_nconfig);

-- Location: PIN_63,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\conn_tdo_out~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tdoout_reg~regout\,
	oe => VCC,
	padio => ww_conn_tdo_out);

-- Location: PIN_55,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\tck~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tck~0\,
	oe => VCC,
	padio => ww_tck);

-- Location: PIN_56,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\tdi~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tdi~0_combout\,
	oe => VCC,
	padio => ww_tdi);

-- Location: PIN_54,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\tms~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tms~0_combout\,
	oe => VCC,
	padio => ww_tms);

-- Location: PIN_50,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\reset_n_out~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \reset_n_out~0_combout\,
	oe => VCC,
	padio => ww_reset_n_out);

-- Location: PIN_49,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\sci_sclk~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_scif|sclk_reg~regout\,
	oe => VCC,
	padio => ww_sci_sclk);

-- Location: PIN_47,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\sci_txd~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \inst_scif|sci_txd~0_combout\,
	oe => VCC,
	padio => ww_sci_txd);

-- Location: PIN_52,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\sci_rxr_n~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \sci_rxr_n~0_combout\,
	oe => VCC,
	padio => ww_sci_rxr_n);

-- Location: PIN_61,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\led_n_out~I\ : maxv_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_led_n_out~0_combout\,
	oe => VCC,
	padio => ww_led_n_out);
END structure;


