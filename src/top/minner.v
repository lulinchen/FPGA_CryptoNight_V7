// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

module miner(
`ifdef SIMULATING
	input				clk,
	input				rstn,
`else
	input				clk_ref_i_p,
	input				clk_ref_i_n,
	input				rst_i,		// active high
`endif
	input				rxd,
	output				txd,
	output 		[7:0]	LED			 //  active high			
	);

`ifndef SIMULATING
	wire	clk; 
	wire	rstn = ~rst_i; 
	IBUFDS clkin1_ibufgds(	
		.O  (clk),
		.I  (clk_ref_i_p),
		.IB (clk_ref_i_n)
		);
	reg		[27:0] cnt;
	always @(`CLK_RST_EDGE)	
		if (`RST) 	cnt <= 0;
		else		cnt <= cnt + 1;
	assign LED[0] = cnt[26];
	assign LED[1] = cnt[27];
`endif	
	wire			rx_error;
	wire			rx_en;
	wire	[7:0]	rx_byte;
	
	wire			tx_en;
	wire	[7:0]	tx_byte;
	wire			tx_busy;
	
	
	uart_receiver uart_receiver(
		.clk			(clk),
		.rstn			(rstn),
		.rxd			(rxd),
		.rx_error		(),
		.rx_byte		(rx_byte),
		.rx_en          (rx_en)
	); 
	uart_sender uart_sender(
		.clk			(clk),
		.rstn			(rstn),
		.tx_en			(tx_en),
		.tx_byte		(tx_byte),
		.busy			(tx_busy),
		.txd			(txd)
	); 
	
	
	wire	[127:0]		hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11;	
	wire	[ 63:0] 	tweak;
	
	reg		[127:0]		hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0;	
	reg		[ 63:0] 	tweak_0;
	
	reg		[127:0]		hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1;	
	reg		[ 63:0] 	tweak_1;
	reg		[127:0]		hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2;	
	reg		[ 63:0] 	tweak_2;
	reg		[127:0]		hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3;	
	reg		[ 63:0] 	tweak_3;
	
	
	reg		[127:0]		hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i;	
	reg		[ 63:0] 	tweak_i;
	
	
`ifdef UART_BUF_4
	reg		[1:0]		rcv_buf_rid, rcv_buf_wid;
	reg		[2:0]		rcv_item_cnt;
`else	
	reg					rcv_buf_rid, rcv_buf_wid;
	reg		[1:0]		rcv_item_cnt;	
`endif	
	
	wire				hash_ready;	
	wire				go_cn_b1;
	reg					go_cn;
	wire				cn_ready;
	wire				cn_main_ready;
	reg					doing_cn;
	reg					send_go;
	wire				send_ready;
	wire 	[127:0]		xout0, xout1, xout2, xout3,	xout4, xout5, xout6, xout7;	
	reg 	[127:0]		xout0_send, xout1_send, xout2_send, xout3_send,	xout4_send, xout5_send, xout6_send, xout7_send;	
	
		
`ifdef CN_THREE_INSTANCE


	wire				go_cn_1_b1;
	reg					go_cn_1;
	wire				cn_main_ready_1;
	wire				cn_ready_1;
	reg		[127:0]		hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1;	
	reg		[ 63:0] 	tweak_i_1;
	wire 	[127:0]		xout0_1, xout1_1, xout2_1, xout3_1,	xout4_1, xout5_1, xout6_1, xout7_1;	
	reg					doing_cn_1;
	
	wire				go_cn_2_b1;
	reg					go_cn_2;
	wire				cn_main_ready_2;
	wire				cn_ready_2;
	reg		[127:0]		hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2;	
	reg		[ 63:0] 	tweak_i_2;
	wire 	[127:0]		xout0_2, xout1_2, xout2_2, xout3_2,	xout4_2, xout5_2, xout6_2, xout7_2;	
	reg					doing_cn_2;
	
	
	assign LED[2] = doing_cn;
	assign LED[3] = doing_cn_1;
	assign LED[4] = doing_cn_2;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	rcv_item_cnt <= 0;
		else case( {hash_ready, go_cn_b1|go_cn_1_b1|go_cn_2_b1} ) 
			2'b10: 	rcv_item_cnt <= rcv_item_cnt + 1;
			2'b01:	rcv_item_cnt <= rcv_item_cnt - 1;
		endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)				rcv_buf_wid <= 0;
		else if (hash_ready)	rcv_buf_wid <= rcv_buf_wid + 1;
		
		
	always @(`CLK_RST_EDGE)
		if (`RST)									rcv_buf_rid <= 0;
		else if (go_cn_b1|go_cn_1_b1|go_cn_2_b1)	rcv_buf_rid <= rcv_buf_rid + 1;	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)	begin
			{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= 0;
			{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= 0;
		`ifdef UART_BUF_4
			{hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2, tweak_2} <= 0;
			{hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3, tweak_3} <= 0;
		`endif
		end else if (hash_ready) 
			case(rcv_buf_wid)
			0:	{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			1:	{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
	`ifdef UART_BUF_4
			2:	{hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2, tweak_2} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			3:	{hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3, tweak_3} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
	`endif
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)			doing_cn <= 0;
		else if (go_cn_b1)	doing_cn <= 1;
	//	else if (cn_ready)	doing_cn <= 0;
		else if (cn_main_ready)	doing_cn <= 0;
		
	always @(`CLK_RST_EDGE)
		if (`RST)				doing_cn_1 <= 0;
		else if (go_cn_1_b1)	doing_cn_1 <= 1;
	//	else if (cn_ready_1)	doing_cn_1 <= 0;
		else if (cn_main_ready_1)	doing_cn_1 <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)				doing_cn_2 <= 0;
		else if (go_cn_2_b1)	doing_cn_2 <= 1;
	//	else if (cn_ready_2)	doing_cn_2 <= 0;
		else if (cn_main_ready_2)	doing_cn_2 <= 0;
		
	assign 	go_cn_b1  = (!doing_cn) & (rcv_item_cnt!=0);
	assign 	go_cn_1_b1  = (!doing_cn_1) & (doing_cn) & (rcv_item_cnt!=0);
	assign 	go_cn_2_b1  = (!doing_cn_2) & (doing_cn_1) & (doing_cn) & (rcv_item_cnt!=0);
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn <= 0;
		else		go_cn <= go_cn_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn_1 <= 0;
		else		go_cn_1 <= go_cn_1_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn_2 <= 0;
		else		go_cn_2 <= go_cn_2_b1;		
		
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= 0;
		else if (go_cn_b1)
			case(rcv_buf_rid)
			0:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
	`ifdef UART_BUF_4	
			2:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2, tweak_2};
			3:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3, tweak_3};
	`endif
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= 0;
		else if (go_cn_1_b1)
			case(rcv_buf_rid)
			0:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
	`ifdef UART_BUF_4	
			2:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2, tweak_2};
			3:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3, tweak_3};
	`endif
			endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2, tweak_i_2} <= 0;
		else if (go_cn_2_b1)
			case(rcv_buf_rid)
			0:		{hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2, tweak_i_2} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2, tweak_i_2} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
	`ifdef UART_BUF_4	
			2:		{hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2, tweak_i_2} <= {hash0_2, hash1_2, hash2_2, hash3_2, hash4_2, hash5_2, hash6_2, hash7_2, hash8_2, hash9_2, hash10_2, hash11_2, tweak_2};
			3:		{hash0_i_2, hash1_i_2, hash2_i_2, hash3_i_2, hash4_i_2, hash5_i_2, hash6_i_2, hash7_i_2, hash8_i_2, hash9_i_2, hash10_i_2, hash11_i_2, tweak_i_2} <= {hash0_3, hash1_3, hash2_3, hash3_3, hash4_3, hash5_3, hash6_3, hash7_3, hash8_3, hash9_3, hash10_3, hash11_3, tweak_3};
	`endif			
			endcase
			
			
	reg			sending;
	reg	[1:0]	send_item_cnt;
	reg			cn_done, cn_done_1, cn_done_2;
	wire		send_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				cn_done <= 0;
		else if (cn_ready)		cn_done <= 1;
		else if (send_go_b1)	cn_done <= 0;		
	always @(`CLK_RST_EDGE)
		if (`RST)						cn_done_1 <= 0;
		else if (cn_ready_1)			cn_done_1 <= 1;
	//	else if (cn_ready)			cn_done_1 <= 1;
		else if (send_go_b1&(!cn_done))	cn_done_1 <= 0;
	
	always @(`CLK_RST_EDGE)
		if (`RST)										cn_done_2 <= 0;
		else if (cn_ready_2)							cn_done_2 <= 1;
	//	else if (cn_ready)							cn_done_2 <= 1;
		else if (send_go_b1&(!cn_done) &(!cn_done_1))	cn_done_2 <= 0;
		
		
	assign send_go_b1 = (!sending) & (cn_done | cn_done_1 | cn_done_2);
	
	always @(`CLK_RST_EDGE)
		if (`RST)			send_go <= 0;
		else 				send_go <= send_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				sending <= 0;
		else if (send_go_b1)	sending <= 1;
		else if (send_ready)	sending <= 0;	
	always @(`CLK_RST_EDGE)
		if (`ZST)	{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= 0;
		else if (send_go_b1)
			if (cn_done)
				{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= {xout0, xout1, xout2, xout3,	xout4, xout5, xout6, xout7};	
			else if (cn_done_1)
				{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= {xout0_1, xout1_1, xout2_1, xout3_1,	xout4_1, xout5_1, xout6_1, xout7_1};	
			else
				{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= {xout0_2, xout1_2, xout2_2, xout3_2,	xout4_2, xout5_2, xout6_2, xout7_2};	
				

`elsif CN_TWO_INSTANCE

	wire				go_cn_1_b1;
	reg					go_cn_1;
	wire				cn_ready_1;
	wire				cn_main_ready_1;
	reg		[127:0]		hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1;	
	reg		[ 63:0] 	tweak_i_1;
	wire 	[127:0]		xout0_1, xout1_1, xout2_1, xout3_1,	xout4_1, xout5_1, xout6_1, xout7_1;	
	reg					doing_cn_1;
	
	assign LED[2] = doing_cn;
	assign LED[3] = doing_cn_1;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	rcv_item_cnt <= 0;
		else case( {hash_ready, go_cn_b1|go_cn_1_b1} ) 
			2'b10: 	rcv_item_cnt <= rcv_item_cnt + 1;
			2'b01:	rcv_item_cnt <= rcv_item_cnt - 1;
		endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)				rcv_buf_wid <= 0;
		else if (hash_ready)	rcv_buf_wid <= rcv_buf_wid + 1;
		
		
	always @(`CLK_RST_EDGE)
		if (`RST)						rcv_buf_rid <= 0;
		else if (go_cn_b1|go_cn_1_b1)	rcv_buf_rid <= rcv_buf_rid + 1;	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)	begin
			{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= 0;
			{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= 0;
		end else if (hash_ready) 
			case(rcv_buf_wid)
			0:	{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			1:	{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)			doing_cn <= 0;
		else if (go_cn_b1)	doing_cn <= 1;
	//	else if (cn_ready)	doing_cn <= 0;
		else if (cn_main_ready)	doing_cn <= 0;
		
	always @(`CLK_RST_EDGE)
		if (`RST)				doing_cn_1 <= 0;
		else if (go_cn_1_b1)	doing_cn_1 <= 1;
	//	else if (cn_ready_1)	doing_cn_1 <= 0;
		else if (cn_main_ready_1)	doing_cn_1 <= 0;
		
	assign 	go_cn_b1  = (!doing_cn) & (rcv_item_cnt!=0);
	assign 	go_cn_1_b1  = (!doing_cn_1) & (doing_cn) & (rcv_item_cnt!=0);
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn <= 0;
		else		go_cn <= go_cn_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn_1 <= 0;
		else		go_cn_1 <= go_cn_1_b1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= 0;
		else if (go_cn_b1)
			case(rcv_buf_rid)
			0:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= 0;
		else if (go_cn_1_b1)
			case(rcv_buf_rid)
			0:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i_1, hash1_i_1, hash2_i_1, hash3_i_1, hash4_i_1, hash5_i_1, hash6_i_1, hash7_i_1, hash8_i_1, hash9_i_1, hash10_i_1, hash11_i_1, tweak_i_1} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
			endcase
	
	
	reg			sending;
	
	reg	[1:0]	send_item_cnt;
	reg			cn_done, cn_done_1;
	wire		send_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				cn_done <= 0;
		else if (cn_ready)		cn_done <= 1;
		else if (send_go_b1)	cn_done <= 0;		
	always @(`CLK_RST_EDGE)
		if (`RST)						cn_done_1 <= 0;
	//	else if (cn_ready_1)			cn_done_1 <= 1;
		else if (cn_ready_1)			cn_done_1 <= 1;
		else if (send_go_b1&(!cn_done))	cn_done_1 <= 0;
		
	assign send_go_b1 = (!sending) & (cn_done | cn_done_1);
	
	always @(`CLK_RST_EDGE)
		if (`RST)			send_go <= 0;
		else 				send_go <= send_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				sending <= 0;
		else if (send_go_b1)	sending <= 1;
		else if (send_ready)	sending <= 0;	
	always @(`CLK_RST_EDGE)
		if (`ZST)	{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= 0;
		else if (send_go_b1)
			if (cn_done)
				{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= {xout0, xout1, xout2, xout3,	xout4, xout5, xout6, xout7};	
			else 
				{xout0_send, xout1_send, xout2_send, xout3_send, xout4_send, xout5_send, xout6_send, xout7_send} <= {xout0_1, xout1_1, xout2_1, xout3_1,	xout4_1, xout5_1, xout6_1, xout7_1};	
`else
	
	always @(`CLK_RST_EDGE)
		if (`RST)	rcv_item_cnt <= 0;
		else case( {hash_ready, go_cn_b1} ) 
			2'b10: 	rcv_item_cnt <= rcv_item_cnt + 1;
			2'b01:	rcv_item_cnt <= rcv_item_cnt - 1;
		endcase
	always @(`CLK_RST_EDGE)
		if (`RST)				rcv_buf_wid <= 0;
		else if (hash_ready)	rcv_buf_wid <= rcv_buf_wid + 1;
				
	always @(`CLK_RST_EDGE)
		if (`RST)				rcv_buf_rid <= 0;
		else if (cn_ready)		rcv_buf_rid <= rcv_buf_rid + 1;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)	begin
			{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= 0;
			{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= 0;
		end else if (hash_ready) 
			case(rcv_buf_wid)
			0:	{hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			1:	{hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1} <= {hash0, hash1, hash2, hash3, hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11, tweak};
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)			doing_cn <= 0;
		else if (go_cn)		doing_cn <= 1;
		else if (cn_ready)	doing_cn <= 0;
	
	assign 	go_cn_b1  = (!doing_cn) & (rcv_item_cnt!=0);
	always @(`CLK_RST_EDGE)
		if (`RST)	go_cn <= 0;
		else		go_cn <= go_cn_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)			{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= 0;
		else if (go_cn_b1)
			case(rcv_buf_rid)
			0:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_0, hash1_0, hash2_0, hash3_0, hash4_0, hash5_0, hash6_0, hash7_0, hash8_0, hash9_0, hash10_0, hash11_0, tweak_0};
			1:		{hash0_i, hash1_i, hash2_i, hash3_i, hash4_i, hash5_i, hash6_i, hash7_i, hash8_i, hash9_i, hash10_i, hash11_i, tweak_i} <= {hash0_1, hash1_1, hash2_1, hash3_1, hash4_1, hash5_1, hash6_1, hash7_1, hash8_1, hash9_1, hash10_1, hash11_1, tweak_1};
			endcase

	always @(*) {xout0_send, xout1_send, xout2_send, xout3_send,	xout4_send, xout5_send, xout6_send, xout7_send}	 = {xout0, xout1, xout2, xout3,	xout4, xout5, xout6, xout7};	
	always @(*) send_go = cn_ready;
`endif

	receive receive (
		.clk			(clk),
		.rstn			(rstn),
		.rx_byte		(rx_byte),
		.rx_en          (rx_en),
		.hash0 			(hash0 ), 	
		.hash1 			(hash1 ),		
		.hash2 			(hash2 ),		
		.hash3 			(hash3 ),		
		.hash4 			(hash4 ),		
		.hash5 			(hash5 ),		
		.hash6 			(hash6 ),		
		.hash7 			(hash7 ),		
		.hash8 			(hash8 ),		
		.hash9 			(hash9 ),		
		.hash10			(hash10),		
		.hash11			(hash11),		
		.tweak1_2_0		(tweak),	
		.ready			(hash_ready)
	
	);
	
	
	send send (
		.clk			(clk),
		.rstn			(rstn),
		.go				(send_go),
		.tx_en			(tx_en),
		.tx_byte		(tx_byte),
		.tx_busy		(tx_busy),
		.xout0			(xout0_send), 						
		.xout1			(xout1_send),						
		.xout2			(xout2_send),						
		.xout3			(xout3_send),						
		.xout4			(xout4_send),						
		.xout5			(xout5_send),						
		.xout6			(xout6_send),						
		.xout7			(xout7_send),						
		.ready			(send_ready)
	);
	
	cryptonight cryptonight(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_cn),
		.hash0              (hash0_i ),
		.hash1              (hash1_i ),
		.hash2              (hash2_i ),
		.hash3              (hash3_i ),
		.hash4              (hash4_i ),
		.hash5              (hash5_i ),
		.hash6              (hash6_i ),
		.hash7              (hash7_i ),
		.hash8              (hash8_i ),
		.hash9              (hash9_i ),
		.hash10             (hash10_i),
		.hash11             (hash11_i),
		.tweak1_2_0_i		(tweak_i),
		.ready_mainloop		(cn_main_ready),
		.ready				(cn_ready),
		.xout0				(xout0),
		.xout1				(xout1),
		.xout2				(xout2),
		.xout3				(xout3),
		.xout4				(xout4),
		.xout5				(xout5),
		.xout6				(xout6),
		.xout7              (xout7)
		
	);
	
	
`ifdef CN_TWO_INSTANCE

	cryptonight cryptonight_1(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_cn_1),
		.hash0              (hash0_i_1 ),
		.hash1              (hash1_i_1 ),
		.hash2              (hash2_i_1 ),
		.hash3              (hash3_i_1 ),
		.hash4              (hash4_i_1 ),
		.hash5              (hash5_i_1 ),
		.hash6              (hash6_i_1 ),
		.hash7              (hash7_i_1 ),
		.hash8              (hash8_i_1 ),
		.hash9              (hash9_i_1 ),
		.hash10             (hash10_i_1),
		.hash11             (hash11_i_1),
		.tweak1_2_0_i		(tweak_i_1),
		.ready_mainloop		(cn_main_ready_1),
		.ready				(cn_ready_1),
		.xout0				(xout0_1),
		.xout1				(xout1_1),
		.xout2				(xout2_1),
		.xout3				(xout3_1),
		.xout4				(xout4_1),
		.xout5				(xout5_1),
		.xout6				(xout6_1),
		.xout7              (xout7_1)
		
	);
	`ifdef CN_THREE_INSTANCE
		cryptonight cryptonight_2(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_cn_2),
		.hash0              (hash0_i_2 ),
		.hash1              (hash1_i_2 ),
		.hash2              (hash2_i_2 ),
		.hash3              (hash3_i_2 ),
		.hash4              (hash4_i_2 ),
		.hash5              (hash5_i_2 ),
		.hash6              (hash6_i_2 ),
		.hash7              (hash7_i_2 ),
		.hash8              (hash8_i_2 ),
		.hash9              (hash9_i_2 ),
		.hash10             (hash10_i_2),
		.hash11             (hash11_i_2),
		.tweak1_2_0_i		(tweak_i_2),
		.ready_mainloop		(cn_main_ready_2),
		.ready				(cn_ready_2),
		.xout0				(xout0_2),
		.xout1				(xout1_2),
		.xout2				(xout2_2),
		.xout3				(xout3_2),
		.xout4				(xout4_2),
		.xout5				(xout5_2),
		.xout6				(xout6_2),
		.xout7              (xout7_2)
		
	);
	
	`endif
`endif
	
endmodule