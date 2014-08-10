
module cq_viola (
	core_clk,
	reset_reset_n,
	peri_clk,
	sysled_export,
	sdr_addr,
	sdr_ba,
	sdr_cas_n,
	sdr_cke,
	sdr_cs_n,
	sdr_dq,
	sdr_dqm,
	sdr_ras_n,
	sdr_we_n,
	gpio_export,
	epcs_MISO,
	epcs_MOSI,
	epcs_SCLK,
	epcs_SS_n,
	scif_sclk,
	scif_txd,
	scif_txr_n,
	scif_rxd,
	scif_rxr_n,
	nios2_reset_resetrequest,
	nios2_reset_resettaken,
	reset_control_in_port,
	reset_control_out_port);	

	input		core_clk;
	input		reset_reset_n;
	input		peri_clk;
	output		sysled_export;
	output	[11:0]	sdr_addr;
	output	[1:0]	sdr_ba;
	output		sdr_cas_n;
	output		sdr_cke;
	output		sdr_cs_n;
	inout	[15:0]	sdr_dq;
	output	[1:0]	sdr_dqm;
	output		sdr_ras_n;
	output		sdr_we_n;
	inout	[27:0]	gpio_export;
	input		epcs_MISO;
	output		epcs_MOSI;
	output		epcs_SCLK;
	output		epcs_SS_n;
	input		scif_sclk;
	input		scif_txd;
	output		scif_txr_n;
	output		scif_rxd;
	input		scif_rxr_n;
	input		nios2_reset_resetrequest;
	output		nios2_reset_resettaken;
	input		reset_control_in_port;
	output		reset_control_out_port;
endmodule
