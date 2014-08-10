	component cq_viola is
		port (
			core_clk                 : in    std_logic                     := 'X';             -- clk
			reset_reset_n            : in    std_logic                     := 'X';             -- reset_n
			peri_clk                 : in    std_logic                     := 'X';             -- clk
			sysled_export            : out   std_logic;                                        -- export
			sdr_addr                 : out   std_logic_vector(11 downto 0);                    -- addr
			sdr_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdr_cas_n                : out   std_logic;                                        -- cas_n
			sdr_cke                  : out   std_logic;                                        -- cke
			sdr_cs_n                 : out   std_logic;                                        -- cs_n
			sdr_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdr_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
			sdr_ras_n                : out   std_logic;                                        -- ras_n
			sdr_we_n                 : out   std_logic;                                        -- we_n
			gpio_export              : inout std_logic_vector(27 downto 0) := (others => 'X'); -- export
			epcs_MISO                : in    std_logic                     := 'X';             -- MISO
			epcs_MOSI                : out   std_logic;                                        -- MOSI
			epcs_SCLK                : out   std_logic;                                        -- SCLK
			epcs_SS_n                : out   std_logic;                                        -- SS_n
			scif_sclk                : in    std_logic                     := 'X';             -- sclk
			scif_txd                 : in    std_logic                     := 'X';             -- txd
			scif_txr_n               : out   std_logic;                                        -- txr_n
			scif_rxd                 : out   std_logic;                                        -- rxd
			scif_rxr_n               : in    std_logic                     := 'X';             -- rxr_n
			nios2_reset_resetrequest : in    std_logic                     := 'X';             -- resetrequest
			nios2_reset_resettaken   : out   std_logic;                                        -- resettaken
			reset_control_in_port    : in    std_logic                     := 'X';             -- in_port
			reset_control_out_port   : out   std_logic                                         -- out_port
		);
	end component cq_viola;

	u0 : component cq_viola
		port map (
			core_clk                 => CONNECTED_TO_core_clk,                 --          core.clk
			reset_reset_n            => CONNECTED_TO_reset_reset_n,            --         reset.reset_n
			peri_clk                 => CONNECTED_TO_peri_clk,                 --          peri.clk
			sysled_export            => CONNECTED_TO_sysled_export,            --        sysled.export
			sdr_addr                 => CONNECTED_TO_sdr_addr,                 --           sdr.addr
			sdr_ba                   => CONNECTED_TO_sdr_ba,                   --              .ba
			sdr_cas_n                => CONNECTED_TO_sdr_cas_n,                --              .cas_n
			sdr_cke                  => CONNECTED_TO_sdr_cke,                  --              .cke
			sdr_cs_n                 => CONNECTED_TO_sdr_cs_n,                 --              .cs_n
			sdr_dq                   => CONNECTED_TO_sdr_dq,                   --              .dq
			sdr_dqm                  => CONNECTED_TO_sdr_dqm,                  --              .dqm
			sdr_ras_n                => CONNECTED_TO_sdr_ras_n,                --              .ras_n
			sdr_we_n                 => CONNECTED_TO_sdr_we_n,                 --              .we_n
			gpio_export              => CONNECTED_TO_gpio_export,              --          gpio.export
			epcs_MISO                => CONNECTED_TO_epcs_MISO,                --          epcs.MISO
			epcs_MOSI                => CONNECTED_TO_epcs_MOSI,                --              .MOSI
			epcs_SCLK                => CONNECTED_TO_epcs_SCLK,                --              .SCLK
			epcs_SS_n                => CONNECTED_TO_epcs_SS_n,                --              .SS_n
			scif_sclk                => CONNECTED_TO_scif_sclk,                --          scif.sclk
			scif_txd                 => CONNECTED_TO_scif_txd,                 --              .txd
			scif_txr_n               => CONNECTED_TO_scif_txr_n,               --              .txr_n
			scif_rxd                 => CONNECTED_TO_scif_rxd,                 --              .rxd
			scif_rxr_n               => CONNECTED_TO_scif_rxr_n,               --              .rxr_n
			nios2_reset_resetrequest => CONNECTED_TO_nios2_reset_resetrequest, --   nios2_reset.resetrequest
			nios2_reset_resettaken   => CONNECTED_TO_nios2_reset_resettaken,   --              .resettaken
			reset_control_in_port    => CONNECTED_TO_reset_control_in_port,    -- reset_control.in_port
			reset_control_out_port   => CONNECTED_TO_reset_control_out_port    --              .out_port
		);

