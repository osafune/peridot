// ===================================================================
// TITLE : Physicaloid / AvalonST bytes to SCIF
//
//   DEGISN : S.OSAFUNE (J-7SYSTEM Works)
//   DATE   : 2013/10/10 -> 2013/10/11
//   UPDATE : 
//
// ===================================================================
// *******************************************************************
//   Copyright (C) 2013, J-7SYSTEM Works.  All rights Reserved.
//
// * This module is a free sourcecode and there is NO WARRANTY.
// * No restriction on use. You can use, modify and redistribute it
//   for personal, non-profit or commercial products UNDER YOUR
//   RESPONSIBILITY.
// * Redistributions of source code must retain the above copyright
//   notice.
// *******************************************************************

module physicaloid_bytes_to_scif(
	output [1:0]	test_infifo_usedw_sig,


	// Interface: clk
	input			clk,
	input			reset,

	// Interface: ST out 
	input			out_ready,
	output			out_valid,
	output [7:0]	out_data,

	// Interface: ST in 
	output			in_ready,
	input			in_valid,
	input  [7:0]	in_data,

	// External Physicaloid Serial Interface 
	input			scif_sclk,
	input			scif_txd,
	output			scif_txr_n,
	output			scif_rxd,
	input			scif_rxr_n
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = reset;				// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = clk;				// モジュール内部駆動クロック 
	wire			scif_clock_sig = scif_sclk;		// SCIFシリアルクロック 

	reg				sciftxr_reg;
	reg  [3:0]		sciftxcounter_reg;
	reg  [9:0]		sciftxdin_reg;
	reg				sciftxbusy_reg;
	wire			sciftxd_sig;
	wire [7:0]		infifo_data_sig;
	wire			infifo_wrreq_sig;
	wire [1:0]		infifo_usedw_sig;
	wire [7:0]		infifo_q_sig;
	wire			infifo_rdack_sig;
	wire			infifo_empty_sig;
	wire			outready_sig;

	reg				scifrxr_reg;
	reg				scifrxready_reg;
	reg  [3:0]		scifrxcounter_reg;
	reg  [8:0]		scifrxdout_reg;
	reg  [2:0]		scifrxreq_in_reg;
	reg  [7:0]		scifrxdata_reg;
	reg				scifrxstart_reg;
	reg				scifrxdone_reg;
	wire			scifrxr_sig;
	wire			scifrxreq_sig;
	wire [7:0]		scifrxdata_in_sig;
	wire			scifrxdata_latch_sig;
	reg  [1:0]		rxdatadone_in_reg;
	reg				rxdatareq_reg;
	reg  [7:0]		rxdata_reg;
	wire			rxdatadone_sig;
	wire			inready_sig;
	wire			invalid_sig;
	wire [7:0]		indata_sig;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */

	assign test_infifo_usedw_sig = infifo_usedw_sig;


/* ===== モジュール構造記述 ============== */

	assign outready_sig = out_ready;
	assign out_valid = ~infifo_empty_sig;
	assign out_data = infifo_q_sig;

	assign in_ready = inready_sig;
	assign invalid_sig = in_valid;
	assign indata_sig = in_data;

	assign sciftxd_sig = scif_txd;
	assign scif_txr_n = ~sciftxr_reg;

	assign scif_rxd = scifrxdout_reg[0];
	assign scifrxr_sig = ~scif_rxr_n;


	///// SCIF_TXD → AvalonSTバイトストリーム /////

	// TXR信号送信 

	always @(negedge scif_clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			sciftxr_reg <= 1'b0;
		end
		else begin
			sciftxr_reg <= ~sciftxbusy_reg;
		end
	end


	// TXDデシリアライザ 

	always @(posedge scif_clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			sciftxcounter_reg <= 4'd0;
			sciftxdin_reg <= {10{1'b1}};
			sciftxbusy_reg <= 1'b0;
		end
		else begin
			sciftxdin_reg <= {sciftxd_sig, sciftxdin_reg[9:1]};

			if (sciftxcounter_reg == 4'd0) begin			// 受信カウンタ 
				if (sciftxdin_reg[9] == 1'b0) begin
					sciftxcounter_reg <= 4'd1;
				end
			end
			else begin
				if (sciftxcounter_reg == 4'd9) begin
					sciftxcounter_reg <= 4'd0;
				end
				else begin
					sciftxcounter_reg <= sciftxcounter_reg + 1'd1;
				end
			end

			if (infifo_usedw_sig >= 2'd2) begin
				sciftxbusy_reg <= 1'b1;
			end
			else begin
				sciftxbusy_reg <= 1'b0;
			end
		end
	end


	// クロックドメインブリッジFIFO 

	assign infifo_data_sig = sciftxdin_reg[8:1];
	assign infifo_wrreq_sig = (sciftxcounter_reg == 4'd9);
	assign infifo_rdack_sig = (!infifo_empty_sig && outready_sig)? 1'b1 : 1'b0;

	physicaloid_scif_infifo
	inst_infifo (
		.aclr		(reset_sig),

		.wrclk		(scif_clock_sig),
		.wrreq		(infifo_wrreq_sig),
		.data		(infifo_data_sig),
		.wrusedw	(infifo_usedw_sig),

		.rdclk		(clock_sig),
		.rdempty	(infifo_empty_sig),
		.q			(infifo_q_sig),
		.rdreq		(infifo_rdack_sig)
	);



	///// AvalonSTバイトストリーム → SCIF_RXD /////

	// AvalonST-Sink処理 

	assign inready_sig = (!rxdatadone_in_reg[1] && !rxdatareq_reg && invalid_sig)? 1'b1 : 1'b0;
	assign rxdatadone_sig = scifrxdone_reg;

	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			rxdatareq_reg <= 1'b0;
			rxdatadone_in_reg <= 2'b00;
		end
		else begin
			rxdatadone_in_reg <= {rxdatadone_in_reg[0], rxdatadone_sig};

			if (!rxdatadone_in_reg[1] && !rxdatareq_reg && invalid_sig) begin
				rxdatareq_reg <= 1'b1;
				rxdata_reg <= indata_sig;
			end
			else if (rxdatareq_reg && rxdatadone_in_reg[1]) begin
				rxdatareq_reg <= 1'b0;
			end

		end
	end


	// RXR信号受信 

	always @(posedge scif_clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			scifrxr_reg <= 1'b0;
		end
		else begin
			scifrxr_reg <= scifrxr_sig;
		end
	end


	// RXDシリアライザ 

	assign scifrxreq_sig = rxdatareq_reg;
	assign scifrxdata_in_sig = rxdata_reg;
	assign scifrxdata_latch_sig = (!scifrxreq_in_reg[2] && scifrxreq_in_reg[1]);

	always @(negedge scif_clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			scifrxreq_in_reg <= 3'b000;
			scifrxstart_reg <= 1'b0;
			scifrxdone_reg <= 1'b0;
			scifrxready_reg <= 1'b0;
			scifrxcounter_reg <= 4'd0;
			scifrxdout_reg <= {9{1'b1}};
		end
		else begin
			scifrxready_reg <= scifrxr_reg;
			scifrxreq_in_reg <= {scifrxreq_in_reg[1:0], scifrxreq_sig};

			if (scifrxdata_latch_sig) begin					// RXDデータのラッチ 
				scifrxdata_reg <= scifrxdata_in_sig;
			end

			if (scifrxdata_latch_sig) begin
				scifrxstart_reg <= 1'b1;
			end
			else if (scifrxcounter_reg == 4'd1) begin
				scifrxstart_reg <= 1'b0;
			end

			if (scifrxcounter_reg == 4'd1) begin			// RXDデータ送信開始 
				scifrxdone_reg <= 1'b1;
			end
			else if (scifrxdone_reg && !scifrxreq_in_reg[1]) begin
				scifrxdone_reg <= 1'b0;
			end

			if (scifrxcounter_reg == 4'd0) begin			// RXDデータを送信 
				if (scifrxstart_reg && scifrxready_reg) begin
					scifrxcounter_reg <= 4'd1;
					scifrxdout_reg <= {scifrxdata_reg, 1'b0};
				end
			end
			else if (scifrxcounter_reg == 4'd9) begin
				scifrxcounter_reg <= 4'd0;
				scifrxdout_reg <= {9{1'b1}};
			end
			else begin
				scifrxcounter_reg <= scifrxcounter_reg + 1'd1;
				scifrxdout_reg <= {1'b1, scifrxdout_reg[8:1]};
			end
		end
	end


endmodule
