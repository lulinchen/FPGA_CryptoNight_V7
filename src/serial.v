// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"




module uart_receiver (
	input 				clk,
	input 				rstn,
	input 				rxd,
	output	reg			rx_error,
	output	reg	[7:0]	rx_byte,
	output	reg			rx_en
	); 
	
	parameter	S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15;


	//parameter 			BAUD_CNT_MAX = 340;   // 300/0.921600  = 325
	
	//parameter 	[8:0]	BAUD_CNT_MAX = `BAUD_CNT_MAX;
	//parameter 	[8:0]	BAUD_CNT_MAX_RCV = `BAUD_CNT_MAX_RCV;
	
	wire				rx;
	reg			[8:0]	baud_cnt;
	reg					baud_cnt_max_f;
	always @(`CLK_RST_EDGE)	
		if (`RST)	baud_cnt_max_f <= 0;
		else 		baud_cnt_max_f <= (baud_cnt == `BAUD_CNT_MAX_RCV-2);
	//	else 		baud_cnt_max_f <= (baud_cnt == `BAUD_CNT_MAX_RCV);
	debound debound( 
		.clk		(clk),		
		.rstn		(rstn),		
		.rxd		(rxd),
		.rx			(rx)
	);
	
	reg			rx_d1;
	reg	[3:0]	bit_cnt;
	reg	[1:0]	st;
	reg			byte_done;
	always @(`CLK_RST_EDGE)	
		if (`RST)	rx_d1 <= 1;
		else		rx_d1 <= rx;
	always @(`CLK_RST_EDGE)	
		if (`RST)								st <= S0;
		else if (!rx & rx_d1)					st <= S1;
		else if (baud_cnt_max_f && bit_cnt==8)	st <= S0;
		
	always @(`CLK_RST_EDGE)	
		if (`RST)			baud_cnt <= 0;
		else if (st!=S0)	baud_cnt <= baud_cnt_max_f? 0 : baud_cnt+1;
	
	always @(`CLK_RST_EDGE)	
		if (`RST)								bit_cnt <= 0;
		else if (st == S0)						bit_cnt <= 0;
		else if (st!=S0 && baud_cnt_max_f)		bit_cnt <= bit_cnt+1;
		
	reg		[8:0]	bits;
	// low bit first
	always @(`CLK_RST_EDGE)	
		if (`RST)				bits <= 0;
		else if (baud_cnt_max_f)
			case(bit_cnt)
			default:	bits[0] <= rx;
				1  :	bits[1] <= rx;
				2  :	bits[2] <= rx;
				3  :	bits[3] <= rx;
				4  :	bits[4] <= rx;
				5  :	bits[5] <= rx;
				6  :	bits[6] <= rx;
				7  :	bits[7] <= rx;
				8  :	bits[8] <= rx;
			
			endcase
	always @(`CLK_RST_EDGE)	
		if (`RST)	byte_done <= 0;
		else 		byte_done <= (bit_cnt==8 && baud_cnt_max_f);
	always @(`CLK_RST_EDGE)	
		if (`RST)				rx_byte <= 0;
		else if (byte_done)		rx_byte <= bits[7:0];
	
	always @(`CLK_RST_EDGE)	
		if (`RST)				rx_en <= 0;
		else 					rx_en <= byte_done;
		
	always @(`CLK_RST_EDGE)	
		if (`RST)				rx_error <= 0;
		else if (byte_done)		rx_error <= ~bits[8];
		
endmodule



module uart_sender (
	input 				clk,
	input 				rstn,
	input				tx_en,
	input	[7:0]		tx_byte,
	output	reg			busy,
	output 	reg			txd
	); 
	
	parameter	S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15;

	//parameter 			BAUD_CNT_MAX = 325;   // 300/0.921600  = 325
	//parameter 			BAUD_CNT_MAX = 310;
	reg			[8:0]	baud_cnt;
	reg					baud_cnt_max_f;
	always @(`CLK_RST_EDGE)	
		if (`RST)	baud_cnt_max_f <= 0;
		else 		baud_cnt_max_f <= (baud_cnt == `BAUD_CNT_MAX);

	wire		go = tx_en & !busy;
	
	reg		[3:0]	bit_cnt;
	reg		[1:0]	st;
	reg				byte_done;
	reg		[7:0]	byte_buf;

	always @(`CLK_RST_EDGE)	
		if (`RST)			byte_buf <= 0;
		else if (go)		byte_buf <= tx_byte;
	always @(`CLK_RST_EDGE)	
		if (`RST)								st <= S0;
		else if (go)							st <= S1;
		else if (baud_cnt_max_f && bit_cnt==9)	st <= S0;
	always @(`CLK_RST_EDGE)	
		if (`RST)		busy <= 0;
		else 			busy <= (st != S0) | tx_en;
	always @(`CLK_RST_EDGE)	
		if (`RST)							txd <= 1;
		else if (go)						txd <= 0;
		else if (st!=S0 && baud_cnt_max_f)
			case(bit_cnt)
			default:	txd <= byte_buf[0];
				1  :	txd <= byte_buf[1];
				2  :	txd <= byte_buf[2];
				3  :	txd <= byte_buf[3];
				4  :	txd <= byte_buf[4];
				5  :	txd <= byte_buf[5];
				6  :	txd <= byte_buf[6];
				7  :	txd <= byte_buf[7];
				8  :	txd <= 1;
				9  :	txd <= 1;
			endcase

	always @(`CLK_RST_EDGE)	
		if (`RST)			baud_cnt <= 0;
		else if (st!=S0)	baud_cnt <= baud_cnt_max_f? 0 : baud_cnt+1;
		else 				baud_cnt <= 0;
	
	always @(`CLK_RST_EDGE)	
		if (`RST)								bit_cnt <= 0;
		else if (st == S0)						bit_cnt <= 0;
		else if (st!=S0 && baud_cnt_max_f)		bit_cnt <= bit_cnt+1;

endmodule



module debound(
	input 			clk,
	input 			rstn,
	input 			rxd,
	output reg		rx
	);
	reg 	rxd_meta, rxd_reg, rxd_reg_d1, rxd_reg_d2;
	always @(`CLK_RST_EDGE)
		if (`RST)	{rxd_meta, rxd_reg, rxd_reg_d1, rxd_reg_d2} <= -1;
		else 		{rxd_meta, rxd_reg, rxd_reg_d1, rxd_reg_d2} <= {rxd, rxd_meta, rxd_reg, rxd_reg_d1};
		
	always @(`CLK_RST_EDGE)	
		if (`RST)	rx <= 1;
		else if (rxd_reg&rxd_reg_d1&rxd_reg_d2)
					rx <= 1;
		else if (!(rxd_reg|rxd_reg_d1|&rxd_reg_d2))
					rx <= 0;
	
endmodule



module receive_to_buf (
	input 			clk,
	input 			rstn,
	input		[7:0]		rx_byte,
	input					rx_en,
		
	output reg				cenb_hash_buf,
	output reg	[3:0]		ab_hash_buf,
	output reg	[127:0]		db_hash_buf,
	
	output reg				cenb_hash_buf2,
	output reg	[3:0]		ab_hash_buf2,
	output reg	[127:0]		db_hash_buf2,
		
	output reg				ready
	);
		
	reg		[7:0]			byte_cnt;
	reg						loading;
	reg						done;
	reg		[7:0]			rx_byte_pre;
	reg		[127:0]		rx_buf;
	always @(`CLK_RST_EDGE)	
		if (`RST)			rx_byte_pre <= 0;
		else if (rx_en)		rx_byte_pre <= rx_byte;
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	done <= 0;
		else 		done <= loading & rx_en & (byte_cnt==199);
	//	else 		done <= loading & rx_en & (byte_cnt==127);
	always @(`CLK_RST_EDGE)	
		if (`RST)				byte_cnt <= 0;
		else if (!loading)		byte_cnt <= 0;
		else if (rx_en)			byte_cnt <= byte_cnt + 1;
	always @(`CLK_RST_EDGE)	
		if (`RST)							loading <= 0;
		else if (rx_en & rx_byte==8'h55)	loading <= 1;
		else if (done)						loading <= 0;
		
	always @(`CLK_RST_EDGE)	
		if (`ZST)		rx_buf <= 0;
		else if (loading)
			if (rx_en)	rx_buf <= {rx_byte, rx_buf[127 : 8]};
	reg		bytes_16_ready;
	always @(`CLK_RST_EDGE)	
		if (`RST)	bytes_16_ready <= 0;
		else 		bytes_16_ready <= loading & rx_en & ( byte_cnt[3:0] == 15 || byte_cnt==199);
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	cenb_hash_buf <= 1;
		else 		cenb_hash_buf <= ~bytes_16_ready;
	reg		[7:0]			byte_cnt_d1;
	always @(`CLK_RST_EDGE)	
		if (`RST)	byte_cnt_d1 <= 0;
		else		byte_cnt_d1 <= byte_cnt;
	always @(`CLK_RST_EDGE)	
		if (`ZST)	ab_hash_buf <= 0;
		else 		ab_hash_buf <= byte_cnt_d1[7:4];
	always @(`CLK_RST_EDGE)	
		if (`ZST)	db_hash_buf <= 0;
		else 		db_hash_buf <= rx_buf;
		
//	always @(`CLK_RST_EDGE)	
//		if (`RST)	cenb_hash_buf2 <= 1;
//		else 		cenb_hash_buf2 <= ~( bytes_16_ready && (byte_cnt_d1[7:4]>=4 && byte_cnt_d1[7:4]<12)) ;
//		
//	always @(`CLK_RST_EDGE)	
//		if (`ZST)	ab_hash_buf2 <= 0;
//		else 		ab_hash_buf2 <= byte_cnt_d1[7:4] - 4 ;	
//	always @(`CLK_RST_EDGE)	
//		if (`ZST)	db_hash_buf2 <= 0;
//		else 		db_hash_buf2 <= rx_buf;

	always @(*)	begin
		cenb_hash_buf2 = cenb_hash_buf;
		ab_hash_buf2   = ab_hash_buf;
		db_hash_buf2   = db_hash_buf;  	
	end
		
	always @(`CLK_RST_EDGE)	
		if (`RST)	ready <= 0;
		else		ready <= done;
endmodule



module receive (
	input 			clk,
	input 			rstn,
	input		[7:0]		rx_byte,
	input					rx_en,
		
	output reg	[127:0]		hash0 , 						
	output reg	[127:0]		hash1 ,						
	output reg	[127:0]		hash2 ,						
	output reg	[127:0]		hash3 ,						
	output reg	[127:0]		hash4 ,						
	output reg	[127:0]		hash5 ,						
	output reg	[127:0]		hash6 ,						
	output reg	[127:0]		hash7 ,						
	output reg	[127:0]		hash8 ,						
	output reg	[127:0]		hash9 ,						
	output reg	[127:0]		hash10,						
	output reg	[127:0]		hash11,						
	output reg	[ 63:0]		tweak1_2_0,	
	
	output reg				ready
	);
	
		
	reg		[7:0]			byte_cnt;
	reg						loading;
	reg						done;
	reg		[7:0]			rx_byte_pre;
	reg		[8*200-1:0]		rx_buf;
	always @(`CLK_RST_EDGE)	
		if (`RST)			rx_byte_pre <= 0;
		else if (rx_en)		rx_byte_pre <= rx_byte;
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	done <= 0;
		else 		done <= loading & rx_en & (byte_cnt==199);
	//	else 		done <= loading & rx_en & (byte_cnt==127);
	always @(`CLK_RST_EDGE)	
		if (`RST)				byte_cnt <= 0;
		else if (!loading)		byte_cnt <= 0;
		else if (rx_en)			byte_cnt <= byte_cnt + 1;
	always @(`CLK_RST_EDGE)	
		if (`RST)							loading <= 0;
		else if (rx_en & rx_byte==8'h55)	loading <= 1;
		else if (done)						loading <= 0;
		
	always @(`CLK_RST_EDGE)	
		if (`ZST)		rx_buf <= 0;
		else if (loading)
			if (rx_en)	rx_buf <= {rx_byte, rx_buf[8*200-1 : 8]};
		//	if (rx_en)	rx_buf <= {rx_byte, rx_buf[8*128-1 : 8]};
	always @(`CLK_RST_EDGE)	
		if (`ZST)				{ tweak1_2_0, hash11, hash10, hash9, hash8, hash7, hash6, hash5, hash4, hash3, hash2, hash1, hash0 } <= 0;
		else if (done )			{ tweak1_2_0, hash11, hash10, hash9, hash8, hash7, hash6, hash5, hash4, hash3, hash2, hash1, hash0 } <= rx_buf;
	always @(`CLK_RST_EDGE)	
		if (`RST)	ready <= 0;
		else		ready <= done;
endmodule


module send (
	input 					clk,
	input 					rstn,
	input 					go,
	
	output	reg				tx_en,
	output	reg	[7:0]		tx_byte,
	input					tx_busy,
		
	input 		[127:0]		xout0, 						
	input 		[127:0]		xout1,						
	input 		[127:0]		xout2,						
	input 		[127:0]		xout3,						
	input 		[127:0]		xout4,						
	input 		[127:0]		xout5,						
	input 		[127:0]		xout6,						
	input 		[127:0]		xout7,						

	output reg				ready
	);
	
	
	reg		[128*8-1:0]		tx_buf;
	reg		[7:0]			byte_cnt;
	reg						sending;
	reg						done;
	reg						go_d1;
	
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	go_d1 <= 0;
		else		go_d1 <= go;
	always @(`CLK_RST_EDGE)	
		if (`RST)				tx_buf <= 0;
		else if (go)			tx_buf <= {xout7, xout6, xout5, xout4, xout3, xout2, xout1, xout0};
		else if (sending&tx_en)	tx_buf <= tx_buf[8*128-1 : 8];
		
		
	always @(`CLK_RST_EDGE)	
		if (`RST)								sending <= 0;
		else if (go_d1)							sending <= 1;	
		else if (tx_en && byte_cnt==127)		sending <= 0;		
	always @(`CLK_RST_EDGE)	
		if (`RST)					byte_cnt <= 0;
		else if (go_d1)				byte_cnt <= 0;	
		else if (sending&tx_en)		byte_cnt <= byte_cnt + 1;		
	always @(`CLK_RST_EDGE)	
		if (`RST)								tx_en <= 0;
	//	else if (go)							tx_en <= 1;
		else if (sending & !tx_en & !tx_busy)	tx_en <= 1;
		else									tx_en <= 0;
	always @(`CLK_RST_EDGE)	
		if (`RST)								tx_byte <= 0;
	//	else if (go)							tx_byte <= 8'h55;
		else if (sending)						tx_byte <= tx_buf[7:0];
	reg					tx_busy_d1;
	always @(`CLK_RST_EDGE)	
		if (`RST)	tx_busy_d1 <= 0;
		else		tx_busy_d1 <= tx_busy;
		
	always @(`CLK_RST_EDGE)	
		if (`RST)		ready <= 0;
		else			ready <= tx_busy_d1 & !tx_busy & !sending;
	
endmodule


module send_from_buf (
	input 					clk,
	input 					rstn,
	input 					go,
	
	output	reg				tx_en,
	output	reg	[7:0]		tx_byte,
	input					tx_busy,
		
	input			[127:0]	qa_xout_buf,
	output	reg		[ 2:0]	aa_xout_buf,
	output	reg				cena_xout_buf,			

	output reg				ready
	);
	
	
	reg		[128*8-1:0]		tx_buf;
	reg		[7:0]			byte_cnt;
	reg						sending;
	reg						done;
	reg						go_d1;
	
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	go_d1 <= 0;
		else		go_d1 <= go;
		
	
	always @(`CLK_RST_EDGE)	
		if (`RST)				cena_xout_buf <= 1;
		else if (go)			cena_xout_buf <= 0;
		else if (aa_xout_buf==7)cena_xout_buf <= 1;
	
	always @(`CLK_RST_EDGE)	
		if (`RST)	aa_xout_buf <= 0;
		else 		aa_xout_buf <= !cena_xout_buf? aa_xout_buf + 1 :0 ;
	reg		cena_xout_buf_d1;
	always @(`CLK_RST_EDGE)	
		if (`RST)				cena_xout_buf_d1 <= 1;
		else 					cena_xout_buf_d1 <= cena_xout_buf ;
	always @(`CLK_RST_EDGE)	
		if (`RST)					tx_buf <= 0;
		else if(!cena_xout_buf_d1)	tx_buf <= {qa_xout_buf, tx_buf[128*8-1:128]};
		else if (sending&tx_en)		tx_buf <= tx_buf[8*128-1 : 8];
	
	//wire 	tx_buf_ready =  !cena_xout_buf && aa_xout_buf==7;
	reg 	tx_buf_ready;
	always @(`CLK_RST_EDGE)	
		if (`RST)	tx_buf_ready <= 0;
		else 		tx_buf_ready <= !cena_xout_buf && aa_xout_buf==7;
	
		
	always @(`CLK_RST_EDGE)	
		if (`RST)								sending <= 0;
		else if (tx_buf_ready)					sending <= 1;	
		else if (tx_en && byte_cnt==127)		sending <= 0;		
	always @(`CLK_RST_EDGE)	
		if (`RST)					byte_cnt <= 0;
		else if (tx_buf_ready)				byte_cnt <= 0;	
		else if (sending&tx_en)		byte_cnt <= byte_cnt + 1;		
	always @(`CLK_RST_EDGE)	
		if (`RST)								tx_en <= 0;
	//	else if (go)							tx_en <= 1;
		else if (sending & !tx_en & !tx_busy)	tx_en <= 1;
		else									tx_en <= 0;
	always @(`CLK_RST_EDGE)	
		if (`RST)								tx_byte <= 0;
	//	else if (go)							tx_byte <= 8'h55;
		else if (sending)						tx_byte <= tx_buf[7:0];
	reg					tx_busy_d1;
	always @(`CLK_RST_EDGE)	
		if (`RST)	tx_busy_d1 <= 0;
		else		tx_busy_d1 <= tx_busy;
		
	always @(`CLK_RST_EDGE)	
		if (`RST)		ready <= 0;
		else			ready <= tx_busy_d1 & !tx_busy & !sending;
	
endmodule

