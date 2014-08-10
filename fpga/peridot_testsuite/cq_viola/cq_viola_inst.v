	cq_viola u0 (
		.core_clk                 (<connected-to-core_clk>),                 //          core.clk
		.reset_reset_n            (<connected-to-reset_reset_n>),            //         reset.reset_n
		.peri_clk                 (<connected-to-peri_clk>),                 //          peri.clk
		.sysled_export            (<connected-to-sysled_export>),            //        sysled.export
		.sdr_addr                 (<connected-to-sdr_addr>),                 //           sdr.addr
		.sdr_ba                   (<connected-to-sdr_ba>),                   //              .ba
		.sdr_cas_n                (<connected-to-sdr_cas_n>),                //              .cas_n
		.sdr_cke                  (<connected-to-sdr_cke>),                  //              .cke
		.sdr_cs_n                 (<connected-to-sdr_cs_n>),                 //              .cs_n
		.sdr_dq                   (<connected-to-sdr_dq>),                   //              .dq
		.sdr_dqm                  (<connected-to-sdr_dqm>),                  //              .dqm
		.sdr_ras_n                (<connected-to-sdr_ras_n>),                //              .ras_n
		.sdr_we_n                 (<connected-to-sdr_we_n>),                 //              .we_n
		.gpio_export              (<connected-to-gpio_export>),              //          gpio.export
		.epcs_MISO                (<connected-to-epcs_MISO>),                //          epcs.MISO
		.epcs_MOSI                (<connected-to-epcs_MOSI>),                //              .MOSI
		.epcs_SCLK                (<connected-to-epcs_SCLK>),                //              .SCLK
		.epcs_SS_n                (<connected-to-epcs_SS_n>),                //              .SS_n
		.scif_sclk                (<connected-to-scif_sclk>),                //          scif.sclk
		.scif_txd                 (<connected-to-scif_txd>),                 //              .txd
		.scif_txr_n               (<connected-to-scif_txr_n>),               //              .txr_n
		.scif_rxd                 (<connected-to-scif_rxd>),                 //              .rxd
		.scif_rxr_n               (<connected-to-scif_rxr_n>),               //              .rxr_n
		.nios2_reset_resetrequest (<connected-to-nios2_reset_resetrequest>), //   nios2_reset.resetrequest
		.nios2_reset_resettaken   (<connected-to-nios2_reset_resettaken>),   //              .resettaken
		.reset_control_in_port    (<connected-to-reset_control_in_port>),    // reset_control.in_port
		.reset_control_out_port   (<connected-to-reset_control_out_port>)    //              .out_port
	);

