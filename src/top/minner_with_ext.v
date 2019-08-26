// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"
`ifdef FPGA_0_ALTERA
    `define LED_INIT_VALUE          1'b1
    `define LED_POL                 ~
`else
    `define LED_INIT_VALUE          1'b0
    `define LED_POL         		
`endif
module miner(
`ifdef SIMULATING
	input				clk,
	input				rstn,
`elsif FPGA_0_ALTERA
	input				ddrc_ref_i,
	input				rstn_i,		// active high
	`ifdef WITH_FOUR_MAIN
		input				ddrc_ref_i_2,
	`endif
	`ifdef WITH_SIX_MAIN
		input				ddrc_ref_i_4,
	`endif
`else
	input				clk_ref_i_p,
	input				clk_ref_i_n,
	input				rst_i,		// active high
`endif
	
	input						oct_rzqin,
	
	output 		[`W_SDADDR:0] 	mem_a,                 
	output 		[`W_SDBA  :0]  	mem_ba,                
	output 		[`W_SDCLK:0]  	mem_ck,                
	output 		[`W_SDCLK:0]  	mem_ck_n,              
	output 		[`W_CKE   :0]  	mem_cke,               
	output 		[`W_SDNUM:0]  	mem_cs_n,              
	output 		[`W_DQM:0]	  	mem_dm,                
	output 					  	mem_ras_n,             
	output 					 	mem_cas_n,             
	output 					  	mem_we_n,              
	output 		       			mem_reset_n,           
	inout  		[`W_DQ:0]  		mem_dq,                
	inout  		[`W_DQS:0]  	mem_dqs,               
	inout  		[`W_DQS:0]  	mem_dqs_n,             
	output 		[`W_SDNUM:0]  	mem_odt,      
	
`ifdef DDRC_PINGPONG_PHY            
	output 		[`W_CKE   :0]  	mem1_cke,               
	output 		[`W_SDNUM:0]  	mem1_cs_n,              
	output 		[`W_DQM:0]	  	mem1_dm,                         
	inout  		[`W_DQ:0]  		mem1_dq,                
	inout  		[`W_DQS:0]  	mem1_dqs,               
	inout  		[`W_DQS:0]  	mem1_dqs_n,             
	output 		[`W_SDNUM:0]  	mem1_odt,      
`endif
`ifdef WITH_FOUR_MAIN
	input						oct_rzqin_2,
	
	output 		[`W_SDADDR:0] 	mem2_a,                 
	output 		[`W_SDBA  :0]  	mem2_ba,                
	output 		[`W_SDCLK:0]  	mem2_ck,                
	output 		[`W_SDCLK:0]  	mem2_ck_n,              
	output 		[`W_CKE   :0]  	mem2_cke,               
	output 		[`W_SDNUM:0]  	mem2_cs_n,              
	output 		[`W_DQM:0]	  	mem2_dm,                
	output 					  	mem2_ras_n,             
	output 					 	mem2_cas_n,             
	output 					  	mem2_we_n,              
	output 		       			mem2_reset_n,           
	inout  		[`W_DQ:0]  		mem2_dq,                
	inout  		[`W_DQS:0]  	mem2_dqs,               
	inout  		[`W_DQS:0]  	mem2_dqs_n,             
	output 		[`W_SDNUM:0]  	mem2_odt,      
	
`ifdef DDRC_PINGPONG_PHY            
	output 		[`W_CKE   :0]  	mem3_cke,               
	output 		[`W_SDNUM:0]  	mem3_cs_n,              
	output 		[`W_DQM:0]	  	mem3_dm,                         
	inout  		[`W_DQ:0]  		mem3_dq,                
	inout  		[`W_DQS:0]  	mem3_dqs,               
	inout  		[`W_DQS:0]  	mem3_dqs_n,             
	output 		[`W_SDNUM:0]  	mem3_odt,      
`endif
`endif
`ifdef WITH_SIX_MAIN
	input						oct_rzqin_4,
	
	output 		[`W_SDADDR:0] 	mem4_a,                 
	output 		[`W_SDBA  :0]  	mem4_ba,                
	output 		[`W_SDCLK:0]  	mem4_ck,                
	output 		[`W_SDCLK:0]  	mem4_ck_n,              
	output 		[`W_CKE   :0]  	mem4_cke,               
	output 		[`W_SDNUM:0]  	mem4_cs_n,              
	output 		[`W_DQM:0]	  	mem4_dm,                
	output 					  	mem4_ras_n,             
	output 					 	mem4_cas_n,             
	output 					  	mem4_we_n,              
	output 		       			mem4_reset_n,           
	inout  		[`W_DQ:0]  		mem4_dq,                
	inout  		[`W_DQS:0]  	mem4_dqs,               
	inout  		[`W_DQS:0]  	mem4_dqs_n,             
	output 		[`W_SDNUM:0]  	mem4_odt,      
	
`ifdef DDRC_PINGPONG_PHY            
	output 		[`W_CKE   :0]  	mem5_cke,               
	output 		[`W_SDNUM:0]  	mem5_cs_n,              
	output 		[`W_DQM:0]	  	mem5_dm,                         
	inout  		[`W_DQ:0]  		mem5_dq,                
	inout  		[`W_DQS:0]  	mem5_dqs,               
	inout  		[`W_DQS:0]  	mem5_dqs_n,             
	output 		[`W_SDNUM:0]  	mem5_odt,      
`endif
`endif

	input				rxd,
	output				txd,
	output 		[7:0]	LED			 //  active high			
	);

`ifndef SIMULATING

	`ifdef  FPGA_0_ALTERA
		wire	clk; 
		wire	rstn; 
		
		wire 	global_reset_n = rstn_i;
		wire	emif_usr_clk;
		wire	emif_usr_reset_n;
		
		
		wire		local_cal_success;
		wire		local_cal_fail;
		wire		local_init_done;
		
		`ifdef WITH_SIX_MAIN
			wire  clk_main0 = emif_usr_clk;
			wire	mem1_emif_usr_clk;
			wire	mem1_emif_usr_reset_n;
			wire  	clk_main1 = mem1_emif_usr_clk;
			
			wire	mem2_emif_usr_clk;
			wire	mem2_emif_usr_reset_n;
			wire  	clk_main2 = mem2_emif_usr_clk;
			
			wire	mem3_emif_usr_clk;
			wire	mem3_emif_usr_reset_n;
			wire  	clk_main3 = mem3_emif_usr_clk;
			wire	mem4_emif_usr_clk;
			wire	mem4_emif_usr_reset_n;
			wire  	clk_main4 = mem4_emif_usr_clk;
			wire	mem5_emif_usr_clk;
			wire	mem5_emif_usr_reset_n;
			wire  	clk_main5 = mem5_emif_usr_clk;
			
			assign clk = ddrc_ref_i;
			
			assign	rstn = rstn_i & emif_usr_reset_n 
								  & mem1_emif_usr_reset_n 
								  & mem2_emif_usr_reset_n 
								  & mem3_emif_usr_reset_n 
								  & mem4_emif_usr_reset_n 
								  & mem5_emif_usr_reset_n 
									& local_init_done ;  
		`elsif WITH_FOUR_MAIN
			wire  clk_main0 = emif_usr_clk;
			wire	mem1_emif_usr_clk;
			wire	mem1_emif_usr_reset_n;
			wire  	clk_main1 = mem1_emif_usr_clk;
			
			wire	mem2_emif_usr_clk;
			wire	mem2_emif_usr_reset_n;
			wire  	clk_main2 = mem2_emif_usr_clk;
			
			wire	mem3_emif_usr_clk;
			wire	mem3_emif_usr_reset_n;
			wire  	clk_main3 = mem3_emif_usr_clk;
			
			assign clk = ddrc_ref_i;
			assign	rstn = rstn_i & emif_usr_reset_n 
								  & mem1_emif_usr_reset_n 
								  & mem2_emif_usr_reset_n 
								  & mem3_emif_usr_reset_n 
									& local_init_done ;  
			
		`elsif WITH_TWO_MAIN
			wire	mem1_emif_usr_clk;
			wire	mem1_emif_usr_reset_n;
			
			wire  clk_main0 = emif_usr_clk;
			wire  clk_main1 = mem1_emif_usr_clk;
			
			assign clk = ddrc_ref_i;
			
			assign	rstn = rstn_i & emif_usr_reset_n & mem1_emif_usr_reset_n & local_init_done ;  

		`else
			assign  clk = emif_usr_clk;
			assign	rstn = rstn_i & emif_usr_reset_n & local_init_done;  
		`endif
		
		assign LED[2] = `LED_POL local_init_done;
		assign LED[3] = `LED_POL emif_usr_reset_n;
		assign LED[4] = `LED_POL local_cal_success;
		assign LED[5] = `LED_POL local_cal_fail;
	`else
	
		
		IBUFDS clkin1_ibufgds(	
			.O  (clk),
			.I  (clk_ref_i_p),
			.IB (clk_ref_i_n)
			);
	
	`endif
	reg		[27:0] cnt;
	always @(`CLK_EDGE)	
			cnt <= cnt + 1;
	assign LED[0] = cnt[26];
	assign LED[1] = cnt[27];
`endif	
	wire			rx_error;
	wire			rx_en;
	wire	[7:0]	rx_byte;
	
	wire			tx_en;
	wire	[7:0]	tx_byte;
	wire			tx_busy;
	
	
	wire						ready_im0;
	wire						ready_im1;	
	
	wire					cenb_hash_buf;
	wire	[3:0]			ab_hash_buf;
	wire	[127:0]			db_hash_buf;
	wire					cena_hash_buf;
	wire		[3:0]		aa_hash_buf;
	wire	[127:0]			qa_hash_buf;
	
	reg		[`W_IDX+1:0]	hash_buf_wid;
	reg		[`W_IDX+1:0]	hash_buf_rid;
	
	
	wire					cenb_hash_buf2;
	wire	[3:0]			ab_hash_buf2;
	wire	[127:0]			db_hash_buf2;
	wire					cena_hash_buf2;
	wire	[3:0]			aa_hash_buf2;
	wire	[127:0]			qa_hash_buf2;
	
	reg		[`W_IDX+1:0]	hash_buf2_wid;
	reg		[`W_IDX+1:0]	hash_buf2_rid;
	
	
	
	reg		[4:0]			hash_buf_item;
	wire					ready_hash_buf;		
	wire					ready_hash_buf2;		
	

	
	
	uart_receiver uart_receiver(
		.clk			(clk),
		.rstn			(rstn),
		.rxd			(rxd),
		.rx_error		(),
		.rx_byte		(rx_byte),
		.rx_en          (rx_en)
	); 
	
	receive_to_buf receive_to_buf(
		.clk			(clk),
		.rstn			(rstn),
		.rx_byte		(rx_byte),
		.rx_en          (rx_en),
		.cenb_hash_buf	(cenb_hash_buf),
		.ab_hash_buf	(ab_hash_buf),
		.db_hash_buf	(db_hash_buf),
		
		.cenb_hash_buf2	(cenb_hash_buf2),
		.ab_hash_buf2	(ab_hash_buf2),
		.db_hash_buf2	(db_hash_buf2),

		.ready          (ready_wr_hash_buf)

	);
	
	
	rfdp512x128 hash_buf(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_hash_buf),
		.DB		(db_hash_buf	),
		.AB		({hash_buf_wid, ab_hash_buf}	),
		.CENA	(cena_hash_buf),
		.QA		(qa_hash_buf	),
	    .AA		({hash_buf_rid, aa_hash_buf}	)
		);
	
	rfdp512x128 hash_buf2(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_hash_buf2),
		.DB		(db_hash_buf2	),
		.AB		({hash_buf_wid, ab_hash_buf2}	),
		.CENA	(cena_hash_buf2),
		.QA		(qa_hash_buf2	),
	    .AA		({hash_buf2_rid, aa_hash_buf2}	)
		);
	
	//always @(`CLK_RST_EDGE)
	//	if (`RST) 										hash_buf2_rid <= 0;
	//	else if (!cena_hash_buf2 && aa_hash_buf2==15)	hash_buf2_rid <=  hash_buf2_rid + 1;
	always @(`CLK_RST_EDGE)
		if (`RST) 					hash_buf2_rid <= 0;
		else if (ready_hash_buf2)	hash_buf2_rid <=  hash_buf2_rid + 1;

	
		
	always @(`CLK_RST_EDGE)
		if (`RST) 	hash_buf_item <= 0;
		else case({ready_wr_hash_buf, ready_hash_buf})
			2'b10: hash_buf_item <= hash_buf_item + 1;
			2'b01: hash_buf_item <= hash_buf_item - 1;
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST) 						hash_buf_wid <= 0;
		else if (ready_wr_hash_buf)		hash_buf_wid <= hash_buf_wid + 1;
	always @(`CLK_RST_EDGE)
		if (`RST) 						hash_buf_rid <= 0;
		else if (ready_hash_buf)		hash_buf_rid <= hash_buf_rid + 1;	
		

//=================================================
		
	wire	[127:0]			db_xout_buf;
	wire	[ 3:0]			ab_xout_buf;
	wire					cenb_xout_buf;
	
	wire	[127:0]			qa_xout_buf;
	wire	[ 2:0]			aa_xout_buf;
	wire					cena_xout_buf;
	
	reg		[`W_IDX:0]		xout_buf_wid;
	reg		[`W_IDX:0]		xout_buf_rid;
	
	
	
	rfdp128x128 xout_buf(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_xout_buf),
		.DB		(db_xout_buf	),
		.AB		({xout_buf_wid, ab_xout_buf}),
		.CENA	(cena_xout_buf),
		.QA		(qa_xout_buf	),
	    .AA		({xout_buf_rid,aa_xout_buf}	)
	);
	
	always @(`CLK_RST_EDGE)
		if (`RST)				xout_buf_wid <= 0;
		else if (ready_im1)		xout_buf_wid <= xout_buf_wid + 1;
	
		
	
	
	
	
	reg					send_go;
	wire				send_ready;
		
	reg						sending;
	reg		[`W_IDX+1:0]	cn_done, cn_done_1;
	wire					send_go_b1;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)				xout_buf_rid <= 0;
		else if (send_ready)	xout_buf_rid <= xout_buf_rid + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)				cn_done <= 0;
		else case({ready_im0, send_go_b1})
			2'b10:		cn_done <= cn_done + 2;
			2'b01:		cn_done <= cn_done - 1;
			2'b11:		cn_done <= cn_done + 1;
			endcase
	
	assign send_go_b1 = (!sending) & (cn_done !=0);
	
	always @(`CLK_RST_EDGE)
		if (`RST)			send_go <= 0;
		else 				send_go <= send_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				sending <= 0;
		else if (send_go_b1)	sending <= 1;
		else if (send_ready)	sending <= 0;	
		
	send_from_buf send (
		.clk			(clk),
		.rstn			(rstn),
		.go				(send_go),
		.tx_en			(tx_en),
		.tx_byte		(tx_byte),
		.tx_busy		(tx_busy),
		.qa_xout_buf	(qa_xout_buf),
		.aa_xout_buf	(aa_xout_buf),
		.cena_xout_buf	(cena_xout_buf),	
		.ready			(send_ready)
	);	
		
		
	uart_sender uart_sender(
		.clk			(clk),
		.rstn			(rstn),
		.tx_en			(tx_en),
		.tx_byte		(tx_byte),
		.busy			(tx_busy),
		.txd			(txd)
	); 	
	
	

`ifdef IDEAL_EXTMEM			
	wire	  	[`W_EXTMWADDR :0] 		extm_a;			
	wire	  	[`W_SDD       :0]		extm_d;			
	wire		[`W_SDD       :0]		extm_q;	
	wire	  							extm_ren;		
	wire	  							extm_wen;		
	wire								extm_af_afull;
	wire								extm_qv;		
	wire								extm_brst;		
	wire			[ 5:0]				extm_brst_len;
	wire								extm_clk;
`else
	wire		       				amm_burstbegin				;
	wire		       				amm_ready					;
	wire		       				amm_read						;
	wire		       				amm_write					;
	wire		[23:0] 				amm_address					;
	wire		[`W_SDD:0] 				amm_readdata					;
	wire		[`W_SDD:0] 				amm_writedata				;
	wire		[6:0]  				amm_burstcount				;
	wire		[7:0]  				amm_byteenable				;
	wire		       				amm_readdatavalid			;
	wire		       				ctrl_auto_precharge_req		;
	`ifdef WITH_TWO_MAIN
		wire		       				amm1_burstbegin				;
		wire		       				amm1_ready					;
		wire		       				amm1_read						;
		wire		       				amm1_write					;
		wire		[23:0] 				amm1_address					;
		wire		[`W_SDD:0] 			amm1_readdata					;
		wire		[`W_SDD:0] 			amm1_writedata				;
		wire		[6:0]  				amm1_burstcount				;
		wire		[7:0]  				amm1_byteenable				;
		wire		       				amm1_readdatavalid			;
		wire		       				ctrl1_auto_precharge_req		;
	`endif
	`ifdef WITH_FOUR_MAIN
		wire		       				amm2_burstbegin				;
		wire		       				amm2_ready					;
		wire		       				amm2_read						;
		wire		       				amm2_write					;
		wire		[23:0] 				amm2_address					;
		wire		[`W_SDD:0] 			amm2_readdata					;
		wire		[`W_SDD:0] 			amm2_writedata				;
		wire		[6:0]  				amm2_burstcount				;
		wire		[7:0]  				amm2_byteenable				;
		wire		       				amm2_readdatavalid			;
		wire		       				ctrl2_auto_precharge_req		;
		
		wire		       				amm3_burstbegin				;
		wire		       				amm3_ready					;
		wire		       				amm3_read						;
		wire		       				amm3_write					;
		wire		[23:0] 				amm3_address					;
		wire		[`W_SDD:0] 			amm3_readdata					;
		wire		[`W_SDD:0] 			amm3_writedata				;
		wire		[6:0]  				amm3_burstcount				;
		wire		[7:0]  				amm3_byteenable				;
		wire		       				amm3_readdatavalid			;
		wire		       				ctrl3_auto_precharge_req		;

	`endif
	`ifdef WITH_SIX_MAIN
		wire		       				amm4_burstbegin				;
		wire		       				amm4_ready					;
		wire		       				amm4_read						;
		wire		       				amm4_write					;
		wire		[23:0] 				amm4_address					;
		wire		[`W_SDD:0] 			amm4_readdata					;
		wire		[`W_SDD:0] 			amm4_writedata				;
		wire		[6:0]  				amm4_burstcount				;
		wire		[7:0]  				amm4_byteenable				;
		wire		       				amm4_readdatavalid			;
		wire		       				ctrl4_auto_precharge_req		;
		
		wire		       				amm5_burstbegin				;
		wire		       				amm5_ready					;
		wire		       				amm5_read						;
		wire		       				amm5_write					;
		wire		[23:0] 				amm5_address					;
		wire		[`W_SDD:0] 			amm5_readdata					;
		wire		[`W_SDD:0] 			amm5_writedata				;
		wire		[6:0]  				amm5_burstcount				;
		wire		[7:0]  				amm5_byteenable				;
		wire		       				amm5_readdatavalid			;
		wire		       				ctrl5_auto_precharge_req		;	
	
	`endif
	
`endif
		
	cn_with_extm cn_with_extm (
		.clk				(clk),
	`ifdef WITH_TWO_MAIN
		.clk_main0			(clk_main0),
		.clk_main1			(clk_main1),
	`endif
	`ifdef WITH_FOUR_MAIN
		.clk_main2			(clk_main2),
		.clk_main3			(clk_main3),
	`endif
	`ifdef WITH_SIX_MAIN
		.clk_main4			(clk_main4),
		.clk_main5			(clk_main5),
	`endif
	
	
		.rstn				(rstn),
		.go_cn				(go_cn),
	
		.cena_hash_buf		(cena_hash_buf	),
		.aa_hash_buf		(aa_hash_buf	),
		.qa_hash_buf		(qa_hash_buf	),
		.ready_hash_buf		(ready_hash_buf	),		
		.hash_buf_item		(hash_buf_item	),
		
		
		.ready_hash_buf2	(ready_hash_buf2	),  
		.cena_hash_buf2		(cena_hash_buf2	),  
		.aa_hash_buf2		(aa_hash_buf2	),
		.qa_hash_buf2		(qa_hash_buf2	),
				
		.ready_im0			(ready_im0),
	
		.ready_im1		    (ready_im1),
		
		.db_xout_buf		(db_xout_buf),
		.ab_xout_buf		(ab_xout_buf),
		.cenb_xout_buf		(cenb_xout_buf)
			
`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm_a			),
		.extm_d			    (extm_d			),
		.extm_q	            (extm_q	),
		.extm_ren		    (extm_ren		),
		.extm_wen		    (extm_wen		),
		.extm_af_afull      (extm_af_afull),
		.extm_qv		    (extm_qv		),
		.extm_brst		    (extm_brst		),
		.extm_brst_len      (extm_brst_len),
		.extm_clk           (extm_clk)
`else
		,
		.amm_burstbegin          (amm_burstbegin               ),   
		.amm_read              	 (amm_read               ),   
		.amm_write               (amm_write              ),  
		.amm_address             (amm_address            ),  
		.amm_writedata           (amm_writedata          ),  
		.amm_burstcount          (amm_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl_auto_precharge_req),
		.amm_ready               (amm_ready              ),  
		.amm_readdata            (amm_readdata           ),  
		.amm_readdatavalid       (amm_readdatavalid      )
	`ifdef WITH_TWO_MAIN
		,
		.amm1_burstbegin          (amm1_burstbegin               ),   
		.amm1_read                (amm1_read               ),   
		.amm1_write               (amm1_write              ),  
		.amm1_address             (amm1_address            ),  
		.amm1_writedata           (amm1_writedata          ),  
		.amm1_burstcount          (amm1_burstcount         ),  
		.ctrl1_auto_precharge_req (ctrl1_auto_precharge_req),
		.amm1_ready               (amm1_ready              ),  
		.amm1_readdata            (amm1_readdata           ),  
		.amm1_readdatavalid       (amm1_readdatavalid      )

	`endif
	
	`ifdef WITH_FOUR_MAIN
		,
		.amm2_burstbegin          (amm2_burstbegin               ),   
		.amm2_read                (amm2_read               ),   
		.amm2_write               (amm2_write              ),  
		.amm2_address             (amm2_address            ),  
		.amm2_writedata           (amm2_writedata          ),  
		.amm2_burstcount          (amm2_burstcount         ),  
		.ctrl2_auto_precharge_req (ctrl2_auto_precharge_req),
		.amm2_ready               (amm2_ready              ),  
		.amm2_readdata            (amm2_readdata           ),  
		.amm2_readdatavalid       (amm2_readdatavalid      ),
		
		.amm3_burstbegin          (amm3_burstbegin         ),   
		.amm3_read                (amm3_read               ),   
		.amm3_write               (amm3_write              ),  
		.amm3_address             (amm3_address            ),  
		.amm3_writedata           (amm3_writedata          ),  
		.amm3_burstcount          (amm3_burstcount         ),  
		.ctrl3_auto_precharge_req (ctrl3_auto_precharge_req),
		.amm3_ready               (amm3_ready              ),  
		.amm3_readdata            (amm3_readdata           ),  
		.amm3_readdatavalid       (amm3_readdatavalid      )
	`endif
	`ifdef WITH_SIX_MAIN
		,
		.amm4_burstbegin          (amm4_burstbegin               ),   
		.amm4_read                (amm4_read               ),   
		.amm4_write               (amm4_write              ),  
		.amm4_address             (amm4_address            ),  
		.amm4_writedata           (amm4_writedata          ),  
		.amm4_burstcount          (amm4_burstcount         ),  
		.ctrl4_auto_precharge_req (ctrl4_auto_precharge_req),
		.amm4_ready               (amm4_ready              ),  
		.amm4_readdata            (amm4_readdata           ),  
		.amm4_readdatavalid       (amm4_readdatavalid      ),
		
		.amm5_burstbegin          (amm5_burstbegin         ),   
		.amm5_read                (amm5_read               ),   
		.amm5_write               (amm5_write              ),  
		.amm5_address             (amm5_address            ),  
		.amm5_writedata           (amm5_writedata          ),  
		.amm5_burstcount          (amm5_burstcount         ),  
		.ctrl5_auto_precharge_req (ctrl5_auto_precharge_req),
		.amm5_ready               (amm5_ready              ),  
		.amm5_readdata            (amm5_readdata           ),  
		.amm5_readdatavalid       (amm5_readdatavalid      )
	`endif

`endif
	
	);
		
	
	
	
	
	
`ifdef IDEAL_EXTMEM	
	extm_sram  extm_sram (
		.clk			(clk),
		.ren	        (extm_ren),
		.wen	        (extm_wen),
		.a				(extm_a),
	    .d				(extm_d),
	    .q				(extm_q),
		.qv             (extm_qv),
		.af_afull       (extm_af_afull)
	);
`else
	`ifdef DDRC_PINGPONG_PHY
			ddrc3pp controller(
				.amm_ready_0						(amm_ready					),	                   
				.amm_read_0							(amm_read					),                    
				.amm_write_0						(amm_write					),                   
				.amm_address_0						(amm_address					),                 
				.amm_readdata_0						(amm_readdata				),                
				.amm_writedata_0					(amm_writedata				),               
				.amm_burstcount_0					(amm_burstcount				),              
				.amm_byteenable_0					(16'hFFFF					),              
				.amm_readdatavalid_0				(amm_readdatavalid			),       
	
				.ctrl_auto_precharge_req_0			(ctrl_auto_precharge_req		),  
			`ifdef DDRC_PINGPONG_PHY
				.emif_usr_clk_sec					(mem1_emif_usr_clk),
				.emif_usr_reset_n_sec				(mem1_emif_usr_reset_n),
				.amm_ready_1						(amm1_ready					),	                   
				.amm_read_1							(amm1_read					),                    
				.amm_write_1						(amm1_write					),                   
				.amm_address_1						(amm1_address				),                 
				.amm_readdata_1						(amm1_readdata				),                
				.amm_writedata_1					(amm1_writedata				),               
				.amm_burstcount_1					(amm1_burstcount				),              
				.amm_byteenable_1					(16'hFFFF				),              
				.amm_readdatavalid_1				(amm1_readdatavalid			),           
				.ctrl_auto_precharge_req_1			(ctrl1_auto_precharge_req		),  
			`endif
			`ifdef DDR3_USER_REFRESH	
				.mmr_slave_read_0					(1'b0				),              
				.mmr_slave_write_0					(1'b0				),          
			`endif	
				.emif_usr_clk			(emif_usr_clk),
				.emif_usr_reset_n		(emif_usr_reset_n),
				.global_reset_n			(global_reset_n),
				.mem_ck					(mem_ck),           
				.mem_ck_n				(mem_ck_n),         
				.mem_a					(mem_a),            
				.mem_ba					(mem_ba),         
				
				.mem_cke				({mem1_cke, mem_cke}),          
				.mem_cs_n				({mem1_cs_n, mem_cs_n}),         
				.mem_odt				({mem1_odt, mem_odt}),  
				
				.mem_reset_n			(mem_reset_n),      
				.mem_we_n				(mem_we_n),         
				.mem_ras_n				(mem_ras_n),        
				.mem_cas_n				(mem_cas_n),  
				
				.mem_dqs				({mem1_dqs, mem_dqs}),          
				.mem_dqs_n				({mem1_dqs_n,mem_dqs_n}),        
				.mem_dq					({mem1_dq, mem_dq}),        
				.mem_dm					({mem1_dm, mem_dm}),   
				
				.oct_rzqin				(oct_rzqin),        	
				.pll_ref_clk			(ddrc_ref_i),      
				.local_cal_success		(local_cal_success),
				.local_cal_fail			(local_cal_fail) 
			);
		`ifdef WITH_FOUR_MAIN	
			ddrc3pp controller2(
				.amm_ready_0						(amm2_ready					),	                   
				.amm_read_0							(amm2_read					),                    
				.amm_write_0						(amm2_write					),                   
				.amm_address_0						(amm2_address					),                 
				.amm_readdata_0						(amm2_readdata				),                
				.amm_writedata_0					(amm2_writedata				),               
				.amm_burstcount_0					(amm2_burstcount				),              
				.amm_byteenable_0					(16'hFFFF					),              
				.amm_readdatavalid_0				(amm2_readdatavalid			),       
	
				.ctrl_auto_precharge_req_0			(ctrl2_auto_precharge_req		),  
			`ifdef DDRC_PINGPONG_PHY
				.emif_usr_clk_sec					(mem3_emif_usr_clk),
				.emif_usr_reset_n_sec				(mem3_emif_usr_reset_n),
				.amm_ready_1						(amm3_ready					),	                   
				.amm_read_1							(amm3_read					),                    
				.amm_write_1						(amm3_write					),                   
				.amm_address_1						(amm3_address				),                 
				.amm_readdata_1						(amm3_readdata				),                
				.amm_writedata_1					(amm3_writedata				),               
				.amm_burstcount_1					(amm3_burstcount				),              
				.amm_byteenable_1					(16'hFFFF				),              
				.amm_readdatavalid_1				(amm3_readdatavalid			),           
				.ctrl_auto_precharge_req_1			(ctrl3_auto_precharge_req		),  
			`endif
			`ifdef DDR3_USER_REFRESH	
				.mmr_slave_read_0					(1'b0				),              
				.mmr_slave_write_0					(1'b0				),          
			`endif	
				.emif_usr_clk			(mem2_emif_usr_clk),
				.emif_usr_reset_n		(mem2_emif_usr_reset_n),
				.global_reset_n			(global_reset_n),
				
				.mem_ck					(mem2_ck),           
				.mem_ck_n				(mem2_ck_n),         
				.mem_a					(mem2_a),            
				.mem_ba					(mem2_ba),         
				
				.mem_cke				({mem3_cke, mem2_cke}),          
				.mem_cs_n				({mem3_cs_n, mem2_cs_n}),         
				.mem_odt				({mem3_odt, mem2_odt}),  
				
				.mem_reset_n			(mem2_reset_n),      
				.mem_we_n				(mem2_we_n),         
				.mem_ras_n				(mem2_ras_n),        
				.mem_cas_n				(mem2_cas_n),  
				
				.mem_dqs				({mem3_dqs, mem2_dqs}),          
				.mem_dqs_n				({mem3_dqs_n,mem2_dqs_n}),        
				.mem_dq					({mem3_dq, mem2_dq}),        
				.mem_dm					({mem3_dm, mem2_dm}),   
				
				.oct_rzqin				(oct_rzqin_2),        	
				.pll_ref_clk			(ddrc_ref_i_2),      
				.local_cal_success		(local_cal_success_2),
				.local_cal_fail			(local_cal_fail_2) 
			);
		`endif	
		`ifdef WITH_SIX_MAIN	
			ddrc3pp controller4(
				.amm_ready_0						(amm4_ready					),	                   
				.amm_read_0							(amm4_read					),                    
				.amm_write_0						(amm4_write					),                   
				.amm_address_0						(amm4_address					),                 
				.amm_readdata_0						(amm4_readdata				),                
				.amm_writedata_0					(amm4_writedata				),               
				.amm_burstcount_0					(amm4_burstcount				),              
				.amm_byteenable_0					(16'hFFFF					),              
				.amm_readdatavalid_0				(amm4_readdatavalid			),       
	
				.ctrl_auto_precharge_req_0			(ctrl4_auto_precharge_req		),  
			`ifdef DDRC_PINGPONG_PHY
				.emif_usr_clk_sec					(mem5_emif_usr_clk),
				.emif_usr_reset_n_sec				(mem5_emif_usr_reset_n),
				.amm_ready_1						(amm5_ready					),	                   
				.amm_read_1							(amm5_read					),                    
				.amm_write_1						(amm5_write					),                   
				.amm_address_1						(amm5_address				),                 
				.amm_readdata_1						(amm5_readdata				),                
				.amm_writedata_1					(amm5_writedata				),               
				.amm_burstcount_1					(amm5_burstcount				),              
				.amm_byteenable_1					(16'hFFFF				),              
				.amm_readdatavalid_1				(amm5_readdatavalid			),           
				.ctrl_auto_precharge_req_1			(ctrl5_auto_precharge_req		),  
			`endif
			`ifdef DDR3_USER_REFRESH	
				.mmr_slave_read_0					(1'b0				),              
				.mmr_slave_write_0					(1'b0				),          
			`endif	
				.emif_usr_clk			(mem4_emif_usr_clk),
				.emif_usr_reset_n		(mem4_emif_usr_reset_n),
				.global_reset_n			(global_reset_n),
				
				.mem_ck					(mem4_ck),           
				.mem_ck_n				(mem4_ck_n),         
				.mem_a					(mem4_a),            
				.mem_ba					(mem4_ba),         
				
				.mem_cke				({mem5_cke, mem4_cke}),          
				.mem_cs_n				({mem5_cs_n, mem4_cs_n}),         
				.mem_odt				({mem5_odt, mem4_odt}),  
				
				.mem_reset_n			(mem4_reset_n),      
				.mem_we_n				(mem4_we_n),         
				.mem_ras_n				(mem4_ras_n),        
				.mem_cas_n				(mem4_cas_n),  
				
				.mem_dqs				({mem5_dqs, mem4_dqs}),          
				.mem_dqs_n				({mem5_dqs_n,mem4_dqs_n}),        
				.mem_dq					({mem5_dq, mem4_dq}),        
				.mem_dm					({mem5_dm, mem4_dm}),   
				
				.oct_rzqin				(oct_rzqin_4),        	
				.pll_ref_clk			(ddrc_ref_i_4),      
				.local_cal_success		(local_cal_success_4),
				.local_cal_fail			(local_cal_fail_4) 
			);
		`endif	
		
		`ifdef WITH_SIX_MAIN
			assign local_init_done = local_cal_success & local_cal_success_2 & local_cal_success_4;
		`elsif WITH_FOUR_MAIN
			assign local_init_done = local_cal_success & local_cal_success_2;
		`else
			assign local_init_done = local_cal_success;
		`endif	
	`else
		`ifdef FPGA_0_STRATIX5
			ddrc3 controller(
				.pll_ref_clk		(ddrc_ref_i),    
				.global_reset_n		(global_reset_n),
				.soft_reset_n		(global_reset_n),
				.afi_clk			(emif_usr_clk),
				.afi_reset_n		(emif_usr_reset_n), 
				
				
				.avl_ready					(amm_ready					),	  
			//	.avl_burstbegin	    		(amm_burstbegin				),
				.avl_read_req				(amm_read					),                    
				.avl_write_req				(amm_write					),                   
				.avl_addr					(amm_address					),                 
				.avl_rdata					(amm_readdata				),                
				.avl_wdata					(amm_writedata				),               
				.avl_size					(amm_burstcount				),              
				.avl_be						(16'hFFFF					),              
				.avl_rdata_valid			(amm_readdatavalid			),           
				.local_autopch_req			(ctrl_auto_precharge_req		),  

				
				.mem_ck				(mem_ck),           
				.mem_ck_n			(mem_ck_n),         
				.mem_a				(mem_a),            
				.mem_ba				(mem_ba),           
				.mem_cke			(mem_cke),          
				.mem_cs_n			(mem_cs_n),         
				.mem_odt			(mem_odt),          
				.mem_reset_n		(mem_reset_n),      
				.mem_we_n			(mem_we_n),         
				.mem_ras_n			(mem_ras_n),        
				.mem_cas_n			(mem_cas_n),        
				.mem_dqs			(mem_dqs),          
				.mem_dqs_n			(mem_dqs_n),        
				.mem_dq				(mem_dq),           
				.mem_dm				(mem_dm),           
				.oct_rzqin			(oct_rzqin),        	

				.local_cal_success	(local_cal_success),
				.local_cal_fail		(local_cal_fail),
				.local_init_done	(local_init_done) 
				);
				
		`else
			ddrc3 controller(	
				.amm_ready_0						(amm_ready					),	                   
				.amm_read_0							(amm_read					),                    
				.amm_write_0						(amm_write					),                   
				.amm_address_0						(amm_address					),                 
				.amm_readdata_0						(amm_readdata				),                
				.amm_writedata_0					(amm_writedata				),               
				.amm_burstcount_0					(amm_burstcount				),              
				.amm_byteenable_0					(16'hFFFF				),              
				.amm_readdatavalid_0				(amm_readdatavalid			),           
				.ctrl_auto_precharge_req_0			(ctrl_auto_precharge_req		),  

			`ifdef DDR3_USER_REFRESH	
				.mmr_slave_read_0					(1'b0				),              
				.mmr_slave_write_0					(1'b0				),     

			`endif
				.emif_usr_clk		(emif_usr_clk),
				.emif_usr_reset_n	(emif_usr_reset_n),
				.global_reset_n		(global_reset_n),
				.mem_ck				(mem_ck),           
				.mem_ck_n			(mem_ck_n),         
				.mem_a				(mem_a),            
				.mem_ba				(mem_ba),           
				.mem_cke			(mem_cke),          
				.mem_cs_n			(mem_cs_n),         
				.mem_odt			(mem_odt),          
				.mem_reset_n		(mem_reset_n),      
				.mem_we_n			(mem_we_n),         
				.mem_ras_n			(mem_ras_n),        
				.mem_cas_n			(mem_cas_n),        
				.mem_dqs			(mem_dqs),          
				.mem_dqs_n			(mem_dqs_n),        
				.mem_dq				(mem_dq),           
				.mem_dm				(mem_dm),           
				.oct_rzqin			(oct_rzqin),        	
				.pll_ref_clk		(ddrc_ref_i),      
				.local_cal_success	(local_cal_success),
				.local_cal_fail		(local_cal_fail) 
			);
			assign local_init_done = local_cal_success;
		`endif	
	`endif
`endif
		

endmodule
