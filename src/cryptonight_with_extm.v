// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION


//	  scratchpad_address = to_scratchpad_address(a)
//      scratchpad[scratchpad_address] = aes_round(scratchpad 
//        [scratchpad_address], a)
//      b, scratchpad[scratchpad_address] = scratchpad[scratchpad_address],
//        b xor scratchpad[scratchpad_address]
//      
//      scratchpad_address = to_scratchpad_address(b)
//      a = 8byte_add(a, 8byte_mul(b, scratchpad[scratchpad_address]))
//      a, scratchpad[scratchpad_address] = a xor 
//        scratchpad[scratchpad_address], a
		
		


//    enc_data = aes_round(scratchpad[a], a)
//    scratchpad[a] =  b xor enc_data   // and a tweak
//	  b  = enc_data,
//     
//    byte_mul_and_add = 8byte_add(a, 8byte_mul(b, scratchpad[b]))
//	  a = byte_mul_and_add ^ scratchpad[b]
// 	  scratchpad[b] = byte_mul_and_add //  and a tweak here

`include "global.v"



module cn_with_extm(

//`ifdef IDEAL_EXTMEM
	input 						clk,
	input 						rstn,

`ifdef WITH_TWO_MAIN	
	input 						clk_main0,
	input 						clk_main1,
`endif	
`ifdef WITH_FOUR_MAIN
	input 						clk_main2,
	input 						clk_main3,
`endif
`ifdef WITH_SIX_MAIN
	input 						clk_main4,
	input 						clk_main5,
`endif
	
//`else
//	input						ddrc_clk_ref,
//	input						global_reset_n,
//	
//	output						clk,
//	output						rstn,
//`endif

	input						go_cn,
	
	output 						ready_cn,
	
	output  					cena_hash_buf,
	output  	[3:0]			aa_hash_buf,
	input		[127:0]			qa_hash_buf,
	output 						ready_hash_buf,		
	input		[7:0]			hash_buf_item,
	
	output  					ready_hash_buf2,		
	output  					cena_hash_buf2,   // for implode
	output  	[3:0]			aa_hash_buf2,
	input		[127:0]			qa_hash_buf2,	
	
	output						ready_im0,
	output 		[127:0]	        xout0_im0,
	output 		[127:0]	        xout1_im0,	
	output 		[127:0]	        xout2_im0,	
	output 		[127:0]	        xout3_im0,	
	output 		[127:0]	        xout4_im0,	
	output 		[127:0]	        xout5_im0,	
	output 		[127:0]	        xout6_im0,	
	output 		[127:0]	        xout7_im0,	
	
	output						ready_im1,
	output	 	[127:0]	        xout0_im1,
	output	 	[127:0]	        xout1_im1,	
	output	 	[127:0]	        xout2_im1,	
	output	 	[127:0]	        xout3_im1,	
	output	 	[127:0]	        xout4_im1,	
	output	 	[127:0]	        xout5_im1,	
	output	 	[127:0]	        xout6_im1,	
	output	 	[127:0]	        xout7_im1,
`ifdef EX_IMPLODE_INSTANCE_4
	output						ready_im2,
	output 		[127:0]	        xout0_im2,
	output 		[127:0]	        xout1_im2,	
	output 		[127:0]	        xout2_im2,	
	output 		[127:0]	        xout3_im2,	
	output 		[127:0]	        xout4_im2,	
	output 		[127:0]	        xout5_im2,	
	output 		[127:0]	        xout6_im2,	
	output 		[127:0]	        xout7_im2,	
	
	output						ready_im3,
	output	 	[127:0]	        xout0_im3,
	output	 	[127:0]	        xout1_im3,	
	output	 	[127:0]	        xout2_im3,	
	output	 	[127:0]	        xout3_im3,	
	output	 	[127:0]	        xout4_im3,	
	output	 	[127:0]	        xout5_im3,	
	output	 	[127:0]	        xout6_im3,	
	output	 	[127:0]	        xout7_im3,
`endif	
	
	output 		[127:0]			db_xout_buf,
	output 		[ 3:0]			ab_xout_buf,
	output 						cenb_xout_buf,

	
	
`ifdef IDEAL_EXTMEM		
	output    	[`W_EXTMWADDR :0] 		extm_a,			// Word Address ExtMem
	output    	[`W_SDD       :0]		extm_d,			// writing data to ExtMem
	input		[`W_SDD       :0]		extm_q,	
	output    							extm_ren,		// read-enable to ExtMem, high enable
	output    							extm_wen,		// write-enable to ExtMem, high enable
	input								extm_af_afull,
	input								extm_qv,		// valid signal of extm_q			
	output								extm_brst,		// begin of a burst
	output			[ 5:0]				extm_brst_len,	// real burst length = extm_brst_len + 1
	output								extm_clk	


	`ifdef WITH_TWO_MAIN
		,
		output    	[`W_EXTMWADDR :0] 		extm1_a,			// Word Address ExtMem
		output    	[`W_SDD       :0]		extm1_d,			// writing data to ExtMem
		input		[`W_SDD       :0]		extm1_q,	
		output    							extm1_ren,		// read-enable to ExtMem, high enable
		output    							extm1_wen,		// write-enable to ExtMem, high enable
		input								extm1_af_afull,
		input								extm1_qv,		// valid signal of extm_q			
		output								extm1_brst,		// begin of a burst
		output			[ 5:0]				extm1_brst_len,	// real burst length = extm_brst_len + 1
		output								extm1_clk	
	`endif
	`ifdef WITH_FOUR_MAIN
		,
		output    	[`W_EXTMWADDR :0] 		extm2_a,			// Word Address ExtMem
		output    	[`W_SDD       :0]		extm2_d,			// writing data to ExtMem
		input		[`W_SDD       :0]		extm2_q,	
		output    							extm2_ren,		// read-enable to ExtMem, high enable
		output    							extm2_wen,		// write-enable to ExtMem, high enable
		input								extm2_af_afull,
		input								extm2_qv,		// valid signal of extm_q			
		output								extm2_brst,		// begin of a burst
		output			[ 5:0]				extm2_brst_len,	// real burst length = extm_brst_len + 1
		output								extm2_clk	
		,
		output    	[`W_EXTMWADDR :0] 		extm3_a,			// Word Address ExtMem
		output    	[`W_SDD       :0]		extm3_d,			// writing data to ExtMem
		input		[`W_SDD       :0]		extm3_q,	
		output    							extm3_ren,		// read-enable to ExtMem, high enable
		output    							extm3_wen,		// write-enable to ExtMem, high enable
		input								extm3_af_afull,
		input								extm3_qv,		// valid signal of extm_q			
		output								extm3_brst,		// begin of a burst
		output			[ 5:0]				extm3_brst_len,	// real burst length = extm_brst_len + 1
		output								extm3_clk	
	`endif
	`ifdef WITH_SIX_MAIN
		,
		output    	[`W_EXTMWADDR :0] 		extm4_a,			// Word Address ExtMem
		output    	[`W_SDD       :0]		extm4_d,			// writing data to ExtMem
		input		[`W_SDD       :0]		extm4_q,	
		output    							extm4_ren,		// read-enable to ExtMem, high enable
		output    							extm4_wen,		// write-enable to ExtMem, high enable
		input								extm4_af_afull,
		input								extm4_qv,		// valid signal of extm_q			
		output								extm4_brst,		// begin of a burst
		output			[ 5:0]				extm4_brst_len,	// real burst length = extm_brst_len + 1
		output								extm4_clk	
		,
		output    	[`W_EXTMWADDR :0] 		extm5_a,			// Word Address ExtMem
		output    	[`W_SDD       :0]		extm5_d,			// writing data to ExtMem
		input		[`W_SDD       :0]		extm5_q,	
		output    							extm5_ren,		// read-enable to ExtMem, high enable
		output    							extm5_wen,		// write-enable to ExtMem, high enable
		input								extm5_af_afull,
		input								extm5_qv,		// valid signal of extm_q			
		output								extm5_brst,		// begin of a burst
		output			[ 5:0]				extm5_brst_len,	// real burst length = extm_brst_len + 1
		output								extm5_clk	
	`endif
	
`else
	output  			       			amm_burstbegin,                   
	output  			       			amm_read,                   
	output  			       			amm_write,                  
	output  		[`W_EXTMWADDR :0] 	amm_address,                
	output  		[`W_SDD       :0]	amm_writedata,              
	output  		[6:0]  				amm_burstcount,             
	output  			       			ctrl_auto_precharge_req,
	
	input 			       				amm_ready,                  
	input 			[`W_SDD       :0]	amm_readdata,               
	input 			       				amm_readdatavalid   
	`ifdef WITH_TWO_MAIN
		,
		output  			       			amm1_burstbegin,                   
		output  			       			amm1_read,                   
		output  			       			amm1_write,                  
		output  		[`W_EXTMWADDR :0] 	amm1_address,                
		output  		[`W_SDD       :0]	amm1_writedata,              
		output  		[6:0]  				amm1_burstcount,             
		output  			       			ctrl1_auto_precharge_req,
		input 			       				amm1_ready,                  
		input 			[`W_SDD       :0]	amm1_readdata,               
		input 			       				amm1_readdatavalid   	
	`endif	
	`ifdef WITH_FOUR_MAIN
		,
		output  			       			amm2_burstbegin,                   
		output  			       			amm2_read,                   
		output  			       			amm2_write,                  
		output  		[`W_EXTMWADDR :0] 	amm2_address,                
		output  		[`W_SDD       :0]	amm2_writedata,              
		output  		[6:0]  				amm2_burstcount,             
		output  			       			ctrl2_auto_precharge_req,
		input 			       				amm2_ready,                  
		input 			[`W_SDD       :0]	amm2_readdata,               
		input 			       				amm2_readdatavalid   	
			,
		output  			       			amm3_burstbegin,                   
		output  			       			amm3_read,                   
		output  			       			amm3_write,                  
		output  		[`W_EXTMWADDR :0] 	amm3_address,                
		output  		[`W_SDD       :0]	amm3_writedata,              
		output  		[6:0]  				amm3_burstcount,             
		output  			       			ctrl3_auto_precharge_req,
		input 			       				amm3_ready,                  
		input 			[`W_SDD       :0]	amm3_readdata,               
		input 			       				amm3_readdatavalid   	
	`endif
	`ifdef WITH_SIX_MAIN
		,
		output  			       			amm4_burstbegin,                   
		output  			       			amm4_read,                   
		output  			       			amm4_write,                  
		output  		[`W_EXTMWADDR :0] 	amm4_address,                
		output  		[`W_SDD       :0]	amm4_writedata,              
		output  		[6:0]  				amm4_burstcount,             
		output  			       			ctrl4_auto_precharge_req,
		input 			       				amm4_ready,                  
		input 			[`W_SDD       :0]	amm4_readdata,               
		input 			       				amm4_readdatavalid   	
			,
		output  			       			amm5_burstbegin,                   
		output  			       			amm5_read,                   
		output  			       			amm5_write,                  
		output  		[`W_EXTMWADDR :0] 	amm5_address,                
		output  		[`W_SDD       :0]	amm5_writedata,              
		output  		[6:0]  				amm5_burstcount,             
		output  			       			ctrl5_auto_precharge_req,
		input 			       				amm5_ready,                  
		input 			[`W_SDD       :0]	amm5_readdata,               
		input 			       				amm5_readdatavalid   	
	`endif
`endif		
	
	);
`ifndef WITH_TWO_MAIN
	wire	clk_main0 = clk;
`endif

//========================================================================================	
	


	wire										w_loop1_buf_ready;
	wire										cenb_loop1_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop1_wbuf;
	wire		[`W_IDX:0]						ab_loop1_wbuf;
	
	wire										cena_loop1_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop1_wbuf;
	wire		[`W_IDX:0]						aa_loop1_wbuf;
	
	
	wire										cenb_loop1_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			db_loop1_rbuf;
	wire		[`W_IDX:0]						ab_loop1_rbuf;

	wire										cena_loop1_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_loop1_rbuf;
	wire		[`W_IDX:0]						aa_loop1_rbuf;
	
	
	wire										w_loop2_buf_ready;
	wire										cenb_loop2_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop2_wbuf;
	wire		[`W_IDX:0]						ab_loop2_wbuf;
	
	wire										cena_loop2_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop2_wbuf;
	wire		[`W_IDX:0]						aa_loop2_wbuf;
	
	
	wire										cenb_loop2_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			db_loop2_rbuf;
	wire		[`W_IDX:0]						ab_loop2_rbuf;

	wire										cena_loop2_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_loop2_rbuf;
	wire		[`W_IDX:0]						aa_loop2_rbuf;
	

	
	wire										cenb_loop1_buf;
	wire		[`W_MEM:0]						db_loop1_buf;
	wire		[`W_IDX:0]						ab_loop1_buf;
	wire										cena_loop1_buf;
	wire		[`W_MEM:0]						qa_loop1_buf;
	wire		[`W_IDX:0]						aa_loop1_buf;
	
	wire										cenb_loop2_buf;
	wire		[`W_MEM:0]						db_loop2_buf;
	wire		[`W_IDX:0]						ab_loop2_buf;
	wire										cena_loop2_buf;
	wire		[`W_MEM:0]						qa_loop2_buf;
	wire		[`W_IDX:0]						aa_loop2_buf;
	
	
	wire										cenb_im_buf;
	wire		[`W_MEM:0]						db_im_buf;
	wire		[`W_IDX+3:0]					ab_im_buf;
	wire										cena_im_buf;
	wire		[`W_MEM:0]						qa_im_buf;
	wire		[`W_IDX+3:0]					aa_im_buf;
	
//	wire										w_loop1_buf_ready;
//	wire										w_loop2_buf_ready;
	wire										w_im_buf_ready;
	
`ifdef WITH_TWO_MAIN	
	wire										cenb_im_buf_main1;
	wire		[`W_MEM:0]						db_im_buf_main1;
	wire		[`W_IDX+3:0]					ab_im_buf_main1;
	wire										cena_im_buf_main1;
	wire		[`W_MEM:0]						qa_im_buf_main1;
	wire		[`W_IDX+3:0]					aa_im_buf_main1;
	wire										w_im_buf_main1_ready;
`endif	
`ifdef WITH_FOUR_MAIN		
	wire										cenb_im_buf_main2;
	wire		[`W_MEM:0]						db_im_buf_main2;
	wire		[`W_IDX+3:0]					ab_im_buf_main2;
	wire										cena_im_buf_main2;
	wire		[`W_MEM:0]						qa_im_buf_main2;
	wire		[`W_IDX+3:0]					aa_im_buf_main2;
	wire										w_im_buf_main2_ready;
	
	wire										cenb_im_buf_main3;
	wire		[`W_MEM:0]						db_im_buf_main3;
	wire		[`W_IDX+3:0]					ab_im_buf_main3;
	wire										cena_im_buf_main3;
	wire		[`W_MEM:0]						qa_im_buf_main3;
	wire		[`W_IDX+3:0]					aa_im_buf_main3;
	wire										w_im_buf_main3_ready;
`endif
`ifdef WITH_SIX_MAIN		
	wire										cenb_im_buf_main4;
	wire		[`W_MEM:0]						db_im_buf_main4;
	wire		[`W_IDX+3:0]					ab_im_buf_main4;
	wire										cena_im_buf_main4;
	wire		[`W_MEM:0]						qa_im_buf_main4;
	wire		[`W_IDX+3:0]					aa_im_buf_main4;
	wire										w_im_buf_main4_ready;
	
	wire										cenb_im_buf_main5;
	wire		[`W_MEM:0]						db_im_buf_main5;
	wire		[`W_IDX+3:0]					ab_im_buf_main5;
	wire										cena_im_buf_main5;
	wire		[`W_MEM:0]						qa_im_buf_main5;
	wire		[`W_IDX+3:0]					aa_im_buf_main5;
	wire										w_im_buf_main5_ready;
`endif

	wire	[`W_AIKBUF:0]	ab_ik_buf;
	wire					cenb_ik_buf;
	wire	[ 127:0]		db_ik_buf;	
	
	wire	[`W_AIKBUF:0]	aa_ik_buf;
	wire					cena_ik_buf;
	wire	[ 127:0]		qa_ik_buf;
	
		
	wire	[`W_IDX+2:0]	ik_buf_wid;
	wire	[`W_IDX+2:0]	ik_buf_rid;
	// 这个buf 大小和 mainloop的数量 和 TASKN 有关系
	//  8*LOOP_N * TASK_N
	//  最极端  8*8*32 = 2048
	rfdp2048x128 ik_buf(
	//rfdp1024x128 ik_buf(
	//rfdp512x128 ik_buf(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_ik_buf),
		.DB		(db_ik_buf	),
		.AB		({ik_buf_wid, ab_ik_buf}	),
		.CENA	(cena_ik_buf),
		.QA		(qa_ik_buf	),
	    .AA		({ik_buf_rid, aa_ik_buf}	)
		);

		
	wire	 [`W_MEM	:0]		db_scratchpad_ex;
	wire						cenb_scratchpad_ex;
	wire	[`W_AEXBUF:0]		ab_scratchpad_ex;
	
	
	wire	[`W_MEM	:0]			qa_ex_buf;
	wire						cena_ex_buf;
	wire	[`W_AEXBUF:0]		aa_ex_buf;

	
	rfdp32x128 ex_buf(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main0),
		.CENA	(cena_ex_buf),
		.QA		(qa_ex_buf	),
	    .AA		(aa_ex_buf	)
	);

`ifdef WITH_TWO_MAIN
	wire	[`W_MEM	:0]			qa_ex_buf_main1;
	wire						cena_ex_buf_main1;
	wire	[`W_AEXBUF:0]		aa_ex_buf_main1;
	rfdp32x128 ex_buf_main1(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main1),
		.CENA	(cena_ex_buf_main1),
		.QA		(qa_ex_buf_main1	),
	    .AA		(aa_ex_buf_main1	)
	);

`endif		
`ifdef WITH_FOUR_MAIN	
	wire	[`W_MEM	:0]			qa_ex_buf_main2;
	wire						cena_ex_buf_main2;
	wire	[`W_AEXBUF:0]		aa_ex_buf_main2;
	rfdp32x128 ex_buf_main2(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main2),
		.CENA	(cena_ex_buf_main2),
		.QA		(qa_ex_buf_main2	),
	    .AA		(aa_ex_buf_main2	)
	);
	
	wire	[`W_MEM	:0]			qa_ex_buf_main3;
	wire						cena_ex_buf_main3;
	wire	[`W_AEXBUF:0]		aa_ex_buf_main3;
	rfdp32x128 ex_buf_main3(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main3),
		.CENA	(cena_ex_buf_main3),
		.QA		(qa_ex_buf_main3	),
	    .AA		(aa_ex_buf_main3	)
	);
`endif
`ifdef WITH_SIX_MAIN	
	wire	[`W_MEM	:0]			qa_ex_buf_main4;
	wire						cena_ex_buf_main4;
	wire	[`W_AEXBUF:0]		aa_ex_buf_main4;
	rfdp32x128 ex_buf_main4(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main4),
		.CENA	(cena_ex_buf_main4),
		.QA		(qa_ex_buf_main4	),
	    .AA		(aa_ex_buf_main4	)
	);
	
	wire	[`W_MEM	:0]			qa_ex_buf_main5;
	wire						cena_ex_buf_main5;
	wire	[`W_AEXBUF:0]		aa_ex_buf_main5;
	rfdp32x128 ex_buf_main5(
		.CLKB	(clk),
		.CENB	(cenb_scratchpad_ex),
		.DB		(db_scratchpad_ex	),
		.AB		(ab_scratchpad_ex	),
		
		.CLKA	(clk_main5),
		.CENA	(cena_ex_buf_main5),
		.QA		(qa_ex_buf_main5	),
	    .AA		(aa_ex_buf_main5	)
	);
`endif

	wire			[`W_MAIN:0]		ex_cur_main;
//	wire			[`W_MAIN:0]		im_cur_main;
	
	wire		[`W_IDX:0]		ex_wr_idx;
	
	wire						init_ab_f;
	wire		[127:0]			init_a, init_b;
	wire		[63:0]			init_tweak;
	wire		[`W_IDX:0]		init_ab_idx;
	
	
	wire							ready_cn0;
	wire							ready_cn1;
	wire							ready_cn2;
	wire							ready_cn3;
	wire							ready_cn4;
	wire							ready_cn5;
	
	genkeyExplode_2p genkeyExplode_2p(
		.clk 					(clk), 		
		.rstn					(rstn),
		
		
		.cena_hash_buf		(cena_hash_buf	),
		.aa_hash_buf		(aa_hash_buf	),
		.qa_hash_buf		(qa_hash_buf	),
		.hash_buf_item		(hash_buf_item),
		.ready_hash_buf		(ready_hash_buf),
	`ifdef WITH_SIX_MAIN	
		.ready_cn4				(ready_cn4),
		.ready_cn5				(ready_cn5),
	`endif
	`ifdef WITH_FOUR_MAIN	
		.ready_cn2				(ready_cn2),
		.ready_cn3				(ready_cn3),
	`endif
	`ifdef WITH_TWO_MAIN	
		.ready_cn				(ready_cn0),
		.ready_cn1				(ready_cn1),
		.ex_cur_main			(ex_cur_main),
	//	.scratchpad_in_use		(1'b0),	
	//	.scratchpad1_in_use		(1'b0),	
	`else
		.ready_cn				(ready_cn),	
	`endif
		.init_ab_f			(init_ab_f  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.go_write_ex		(go_write_ex		),
		.ex_wr_idx			(ex_wr_idx),
		.db_scratchpad_ex	(db_scratchpad_ex	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex	),
		.ab_scratchpad_ex	(ab_scratchpad_ex	),
		
		
		.ab_ik_buf			(ab_ik_buf	),
		.cenb_ik_buf		(cenb_ik_buf),
		.db_ik_buf			(db_ik_buf	),
		.ik_buf_wid			(ik_buf_wid	),
	
	
		
		.explode_ready			(explode_ready)
	
	);
	
	
	
	
	
		
	//========implode======================================================================
	

	wire			[`W_MAIN:0]		im_cur_main;
	wire		[`W_IDX:0]		im_rd_idx;
	
	
	reg		[1:0]	im_buf_cached;
	wire 			go_round_im0;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	im_buf_cached <= 0;
`ifdef WITH_SIX_MAIN
		else case({go_round_im0, w_im_buf_ready|w_im_buf_main1_ready|w_im_buf_main2_ready|w_im_buf_main3_ready|w_im_buf_main4_ready|w_im_buf_main5_ready})
`elsif WITH_FOUR_MAIN
		else case({go_round_im0, w_im_buf_ready|w_im_buf_main1_ready|w_im_buf_main2_ready|w_im_buf_main3_ready})
`elsif WITH_TWO_MAIN
		else case({go_round_im0, w_im_buf_ready|w_im_buf_main1_ready})
`else
		else case({go_round_im0, w_im_buf_ready})
`endif
			2'b10: im_buf_cached <= im_buf_cached - 1;
			2'b01: im_buf_cached <= im_buf_cached + 1;
			endcase
	
`ifdef WITH_TWO_MAIN
	assign  ready_cn0 = ready_cn & (im_cur_main==0);
	assign  ready_cn1 = ready_cn & (im_cur_main==1);
`endif	
`ifdef WITH_FOUR_MAIN
	assign  ready_cn2 = ready_cn & (im_cur_main==2);
	assign  ready_cn3 = ready_cn & (im_cur_main==3);
`endif
`ifdef WITH_SIX_MAIN
	assign  ready_cn4 = ready_cn & (im_cur_main==4);
	assign  ready_cn5 = ready_cn & (im_cur_main==5);
`endif

	implode_2p implode_2p(
		.clk 					(clk), 		
		.rstn					(rstn),
		
		.im_buf_cached			(im_buf_cached),
		.im_datahub_req			(im_datahub_req),
		.im_cur_main			(im_cur_main),
		.idx_im0				(im_rd_idx),
	
			
		.go_round_im0			(go_round_im0),
	
		.main_ready				(main_ready),
`ifdef WITH_TWO_MAIN	
		.main1_ready			(main1_ready),
`endif	
`ifdef WITH_FOUR_MAIN
		.main2_ready			(main2_ready),
		.main3_ready			(main3_ready),
`endif
`ifdef WITH_SIX_MAIN
		.main4_ready			(main4_ready),
		.main5_ready			(main5_ready),
`endif
		.ready_hash_buf2		(ready_hash_buf2),
		.cena_hash_buf2			(cena_hash_buf2	), 
		.aa_hash_buf2			(aa_hash_buf2	),
		.qa_hash_buf2			(qa_hash_buf2	),	
		
		.aa_ik_buf				(aa_ik_buf	),
		.cena_ik_buf			(cena_ik_buf),
		.qa_ik_buf				(qa_ik_buf	),
		.ik_buf_rid				(ik_buf_rid	),
		.cena_im_buf			(cena_im_buf),
`ifdef WITH_SIX_MAIN	
		.qa_im_buf				(im_cur_main==0? qa_im_buf : ( 
									im_cur_main==1? qa_im_buf_main1 : ( 
									im_cur_main==2? qa_im_buf_main2 : ( 
									im_cur_main==3? qa_im_buf_main3 :  (
									im_cur_main==4? qa_im_buf_main4 :  ( 
									qa_im_buf_main5 )
									))))),		
`elsif WITH_FOUR_MAIN			
		.qa_im_buf				(im_cur_main==0? qa_im_buf : ( 
									im_cur_main==1? qa_im_buf_main1 : ( 
									im_cur_main==2? qa_im_buf_main2 : ( 
									qa_im_buf_main3)))),
`elsif WITH_TWO_MAIN			
		.qa_im_buf				(im_cur_main==0? qa_im_buf : qa_im_buf_main1),
`else	
		.qa_im_buf				(qa_im_buf	),
`endif		
		
		.aa_im_buf				(aa_im_buf	),
	
		.ready_im0				(ready_im0),
		.xout0_im0			 	(xout0_im0),
		.xout1_im0           	(xout1_im0),
		.xout2_im0           	(xout2_im0),
		.xout3_im0           	(xout3_im0),
		.xout4_im0           	(xout4_im0),
		.xout5_im0           	(xout5_im0),
		.xout6_im0           	(xout6_im0),
		.xout7_im0           	(xout7_im0),
	
		.ready_im1				(ready_im1),
		.xout0_im1				(xout0_im1),
		.xout1_im1				(xout1_im1),
		.xout2_im1				(xout2_im1),
		.xout3_im1				(xout3_im1),
		.xout4_im1				(xout4_im1),
		.xout5_im1				(xout5_im1),
	    .xout6_im1				(xout6_im1),
	    .xout7_im1				(xout7_im1),
`ifdef EX_IMPLODE_INSTANCE_4
		.ready_im2				(ready_im2),
		.xout0_im2			 	(xout0_im2),
		.xout1_im2           	(xout1_im2),
		.xout2_im2           	(xout2_im2),
		.xout3_im2           	(xout3_im2),
		.xout4_im2           	(xout4_im2),
		.xout5_im2           	(xout5_im2),
		.xout6_im2           	(xout6_im2),
		.xout7_im2           	(xout7_im2),
	
		.ready_im3				(ready_im3),
		.xout0_im3				(xout0_im3),
		.xout1_im3				(xout1_im3),
		.xout2_im3				(xout2_im3),
		.xout3_im3				(xout3_im3),
		.xout4_im3				(xout4_im3),
		.xout5_im3				(xout5_im3),
	    .xout6_im3				(xout6_im3),
	    .xout7_im3				(xout7_im3),
`endif	
	
	
		.db_xout_buf			(db_xout_buf	),
		.ab_xout_buf			(ab_xout_buf	),
		.cenb_xout_buf			(cenb_xout_buf),	
	
	
	
		.ready_cn				(ready_cn)
	);
	
	
	
//=============================================================================	
	
	
	
	
	
	
	
	
	
	wire	mainloop_go = explode_ready;

	reg					mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14} <= 0;
		else			{mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14} <= {mainloop_go, mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13};
    
	
	wire	 init_datahub_req = mainloop_go | mainloop_go_d6;

		
	reg		[`W_IDX:0]	ex_wr_idx_reg;
	always @(`CLK_RST_EDGE)
		if (`RST)	  			  ex_wr_idx_reg <= 0;
		else if (go_write_ex)	  ex_wr_idx_reg <= ex_wr_idx;
	
	

	
	
	
//==============================================================================================
		

	wire		mainloop0_go;
	go_CDC_go go_CDC_go_main0(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==0)),	
		.clk_o		(clk_main0),
	    .rst_o		(rstn),
	    .go_o       (mainloop0_go)
		);
	reg					mainloop0_go_d1, mainloop0_go_d2, mainloop0_go_d3, mainloop0_go_d4, mainloop0_go_d5, mainloop0_go_d6, mainloop0_go_d7, mainloop0_go_d8, mainloop0_go_d9, mainloop0_go_d10, mainloop0_go_d11, mainloop0_go_d12, mainloop0_go_d13, mainloop0_go_d14;
	always @(posedge clk_main0)
		if (!rstn)		{mainloop0_go_d1, mainloop0_go_d2, mainloop0_go_d3, mainloop0_go_d4, mainloop0_go_d5, mainloop0_go_d6, mainloop0_go_d7, mainloop0_go_d8, mainloop0_go_d9, mainloop0_go_d10, mainloop0_go_d11, mainloop0_go_d12, mainloop0_go_d13, mainloop0_go_d14} <= 0;
		else			{mainloop0_go_d1, mainloop0_go_d2, mainloop0_go_d3, mainloop0_go_d4, mainloop0_go_d5, mainloop0_go_d6, mainloop0_go_d7, mainloop0_go_d8, mainloop0_go_d9, mainloop0_go_d10, mainloop0_go_d11, mainloop0_go_d12, mainloop0_go_d13, mainloop0_go_d14} <= {mainloop0_go, mainloop0_go_d1, mainloop0_go_d2, mainloop0_go_d3, mainloop0_go_d4, mainloop0_go_d5, mainloop0_go_d6, mainloop0_go_d7, mainloop0_go_d8, mainloop0_go_d9, mainloop0_go_d10, mainloop0_go_d11, mainloop0_go_d12, mainloop0_go_d13};

	wire	 init_datahub_req_main0 = mainloop0_go | mainloop0_go_d6;	

//	wire		init_ab_f_main0 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main0;
	go_CDC_go go_CDC_go_init_f0(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==0)),	
		.clk_o		(clk_main0),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main0)
		);
		
	wire		go_write_ex_main0;
	go_CDC_go go_CDC_go_write_ex0(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==0)),	
		.clk_o		(clk_main0),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main0)
		);
		
	wire		im_datahub_req_main0;
	go_CDC_go go_CDC_go_im_datahub_req0(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==0)),	
		.clk_o		(clk_main0),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main0)
		);
	
	
`ifdef WITH_TWO_MAIN
	wire	main_ready_m0domain; // main0 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready0(	
		.clk_i		(clk_main0),
		.rstn_i		(rstn),
		.go_i		(main_ready_m0domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main_ready)
		);
	wire	w_im_buf_ready_m0domain; // main0 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready0(	
		.clk_i		(clk_main0),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m0domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_ready)
		);
`endif		

		
	reg											cenb_init_rbuf;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf;
	reg			[`W_IDX:0]						ab_init_rbuf;

	wire										cena_init_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf;
	wire		[`W_IDX:0]						aa_init_rbuf;
	
	
	rfdp32x22 init_rbuf (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf),
		.DB		(db_init_rbuf	),
		.AB		(ab_init_rbuf	),
		.CLKA	(clk_main0),
		.CENA	(cena_init_rbuf),
		.QA		(qa_init_rbuf	),
	    .AA		(aa_init_rbuf	)
	);
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf <= 1;
		else 		cenb_init_rbuf <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf <= 1;
		else 		ab_init_rbuf <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf <= 1;
		else 		db_init_rbuf <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
		
	rfdp256x128 im_buf (
		.CLKB	(clk_main0),
		.CENB	(cenb_im_buf),
		.DB		(db_im_buf	),
		.AB		(ab_im_buf	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf	),
	    .AA		(aa_im_buf	)
	);

	mainNpad mainNpad_0(
	
	`ifdef WITH_TWO_MAIN
		.clk 					(clk_main0), 		
		.rstn					(rstn),
		.init_ab_f				(init_ab_f_main0),
	`else
		.clk 					(clk), 		
		.rstn					(rstn),
		.init_ab_f				(init_ab_f  ),
	`endif
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
	`ifdef WITH_TWO_MAIN	
		.ex_datahub_req			(go_write_ex_main0),
	`else
		.ex_datahub_req			(go_write_ex),
	`endif
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf	),
		.cena_ex_buf			(cena_ex_buf),
		.aa_ex_buf				(aa_ex_buf	),
		
		

	`ifdef WITH_TWO_MAIN	
		.init_datahub_req		(init_datahub_req_main0),
	`else
		.init_datahub_req		(init_datahub_req),
	`endif
		
		.cena_init_rbuf			(cena_init_rbuf	),
		.qa_init_rbuf			(qa_init_rbuf	),
		.aa_init_rbuf			(aa_init_rbuf	),

	`ifdef WITH_TWO_MAIN	
		.im_datahub_req			(im_datahub_req_main0),
	`else
		.im_datahub_req			(im_datahub_req),
	`endif
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf	),
		.db_im_buf			(db_im_buf	),
		.ab_im_buf			(ab_im_buf	),
	`ifdef WITH_TWO_MAIN
		.w_im_buf_ready		(w_im_buf_ready_m0domain),
		
		.main_ready			(main_ready_m0domain)
	`else
		.w_im_buf_ready		(w_im_buf_ready),
		.main_ready			(main_ready)
	`endif


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
		.amm_burstbegin			 (amm_burstbegin),
		.amm_read              	 (amm_read               ),   
		.amm_write               (amm_write              ),  
		.amm_address             (amm_address            ),  
		.amm_writedata           (amm_writedata          ),  
		.amm_burstcount          (amm_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl_auto_precharge_req),
		.amm_ready               (amm_ready              ),  
		.amm_readdata            (amm_readdata           ),  
		.amm_readdatavalid       (amm_readdatavalid      )
	`endif
	
	
	);
	
	
`ifdef SIMULATING
	reg		[31:0]	mainloop_clk_cnt; 
	always @(`CLK_RST_EDGE)
		if (`RST)				mainloop_clk_cnt <= 0;
	//	else if (mainloop_go)	mainloop_clk_cnt <= 0;
		else if (mainloop_go && ex_cur_main ==0)	mainloop_clk_cnt <= 0;
		else					mainloop_clk_cnt <= mainloop_clk_cnt + 1;

	always @(`CLK_RST_EDGE)
		if(main_ready)   begin
			$display("==main_ready: %d", mainloop_clk_cnt);
	//		$finish;
		end		
`endif
	
	
	
`ifdef WITH_TWO_MAIN

	

	wire		mainloop1_go;
	go_CDC_go go_CDC_go_main1(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==1)),	
		.clk_o		(clk_main1),
	    .rst_o		(rstn),
	    .go_o       (mainloop1_go)
		);
	reg					mainloop1_go_d1, mainloop1_go_d2, mainloop1_go_d3, mainloop1_go_d4, mainloop1_go_d5, mainloop1_go_d6, mainloop1_go_d7, mainloop1_go_d8, mainloop1_go_d9, mainloop1_go_d10, mainloop1_go_d11, mainloop1_go_d12, mainloop1_go_d13, mainloop1_go_d14;
	always @(posedge clk_main1)
		if (!rstn)		{mainloop1_go_d1, mainloop1_go_d2, mainloop1_go_d3, mainloop1_go_d4, mainloop1_go_d5, mainloop1_go_d6, mainloop1_go_d7, mainloop1_go_d8, mainloop1_go_d9, mainloop1_go_d10, mainloop1_go_d11, mainloop1_go_d12, mainloop1_go_d13, mainloop1_go_d14} <= 0;
		else			{mainloop1_go_d1, mainloop1_go_d2, mainloop1_go_d3, mainloop1_go_d4, mainloop1_go_d5, mainloop1_go_d6, mainloop1_go_d7, mainloop1_go_d8, mainloop1_go_d9, mainloop1_go_d10, mainloop1_go_d11, mainloop1_go_d12, mainloop1_go_d13, mainloop1_go_d14} <= {mainloop1_go, mainloop1_go_d1, mainloop1_go_d2, mainloop1_go_d3, mainloop1_go_d4, mainloop1_go_d5, mainloop1_go_d6, mainloop1_go_d7, mainloop1_go_d8, mainloop1_go_d9, mainloop1_go_d10, mainloop1_go_d11, mainloop1_go_d12, mainloop1_go_d13};

	wire	 init_datahub_req_main1 = mainloop1_go | mainloop1_go_d6;	

//	wire		init_ab_f_main1 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main1;
	go_CDC_go go_CDC_go_init_f1(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==1)),	
		.clk_o		(clk_main1),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main1)
		);
		
	wire		go_write_ex_main1;
	go_CDC_go go_CDC_go_write_ex1(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==1)),	
		.clk_o		(clk_main1),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main1)
		);
		
	wire		im_datahub_req_main1;
	go_CDC_go go_CDC_go_im_datahub_req1(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==1)),	
		.clk_o		(clk_main1),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main1)
		);
	
	
	
	wire	main_ready_m1domain; // main1 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready1(	
		.clk_i		(clk_main1),
		.rstn_i		(rstn),
		.go_i		(main_ready_m1domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main1_ready)
		);
	wire	w_im_buf_ready_m1domain; // main1 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready1(	
		.clk_i		(clk_main1),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m1domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_main1_ready)
		);
		

	reg											cenb_init_rbuf_main1;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf_main1;
	reg			[`W_IDX:0]						ab_init_rbuf_main1;

	wire										cena_init_rbuf_main1;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf_main1;
	wire		[`W_IDX:0]						aa_init_rbuf_main1;
	
	
	
	rfdp32x22 init_rbuf_main1 (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf_main1),
		.DB		(db_init_rbuf_main1	),
		.AB		(ab_init_rbuf_main1	),
		.CLKA	(clk_main1),
		.CENA	(cena_init_rbuf_main1),
		.QA		(qa_init_rbuf_main1	),
	    .AA		(aa_init_rbuf_main1	)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf_main1 <= 1;
	//	else 		cenb_init_rbuf_main1 <= ~init_ab_f_main1;
		else 		cenb_init_rbuf_main1 <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf_main1 <= 1;
		else 		ab_init_rbuf_main1 <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf_main1 <= 1;
		else 		db_init_rbuf_main1 <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
	

	

	rfdp256x128 im_buf_main1 (
		.CLKB	(clk_main1),
		.CENB	(cenb_im_buf_main1),
		.DB		(db_im_buf_main1	),
		.AB		(ab_im_buf_main1	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf_main1	),
	    .AA		(aa_im_buf	)
	);
	
	mainNpad mainNpad_1(
		.clk 					(clk_main1), 		
		.rstn					(rstn),
	
		.init_ab_f			(init_ab_f_main1  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.ex_datahub_req			(go_write_ex_main1),
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf_main1	),
		.cena_ex_buf			(cena_ex_buf_main1),
		.aa_ex_buf				(aa_ex_buf_main1	),
	
		.init_datahub_req		(init_datahub_req_main1),
		.cena_init_rbuf			(cena_init_rbuf_main1	),
		.qa_init_rbuf			(qa_init_rbuf_main1	),
		.aa_init_rbuf			(aa_init_rbuf_main1	),


		//.im_datahub_req			(im_datahub_req),
		.im_datahub_req			(im_datahub_req_main1),
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf_main1	),
		.db_im_buf			(db_im_buf_main1	),
		.ab_im_buf			(ab_im_buf_main1	),
		.w_im_buf_ready		(w_im_buf_ready_m1domain),
		
		.main_ready			(main_ready_m1domain)


	`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm1_a			),
		.extm_d			    (extm1_d			),
		.extm_q	            (extm1_q	),
		.extm_ren		    (extm1_ren		),
		.extm_wen		    (extm1_wen		),
		.extm_af_afull      (extm1_af_afull),
		.extm_qv		    (extm1_qv		),
		.extm_brst		    (extm1_brst		),
		.extm_brst_len      (extm1_brst_len),
		.extm_clk           (extm1_clk)
	`else
		,
		.amm_burstbegin			 (amm1_burstbegin),
		.amm_read              	 (amm1_read               ),   
		.amm_write               (amm1_write              ),  
		.amm_address             (amm1_address            ),  
		.amm_writedata           (amm1_writedata          ),  
		.amm_burstcount          (amm1_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl1_auto_precharge_req),
		.amm_ready               (amm1_ready              ),  
		.amm_readdata            (amm1_readdata           ),  
		.amm_readdatavalid       (amm1_readdatavalid      )
	`endif
	
	
	);
`endif	
	
`ifdef WITH_FOUR_MAIN

	wire		mainloop2_go;
	go_CDC_go go_CDC_go_main2(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==2)),	
		.clk_o		(clk_main2),
	    .rst_o		(rstn),
	    .go_o       (mainloop2_go)
		);
	reg					mainloop2_go_d1, mainloop2_go_d2, mainloop2_go_d3, mainloop2_go_d4, mainloop2_go_d5, mainloop2_go_d6, mainloop2_go_d7, mainloop2_go_d8, mainloop2_go_d9, mainloop2_go_d10, mainloop2_go_d11, mainloop2_go_d12, mainloop2_go_d13, mainloop2_go_d14;
	always @(posedge clk_main1)
		if (!rstn)		{mainloop2_go_d1, mainloop2_go_d2, mainloop2_go_d3, mainloop2_go_d4, mainloop2_go_d5, mainloop2_go_d6, mainloop2_go_d7, mainloop2_go_d8, mainloop2_go_d9, mainloop2_go_d10, mainloop2_go_d11, mainloop2_go_d12, mainloop2_go_d13, mainloop2_go_d14} <= 0;
		else			{mainloop2_go_d1, mainloop2_go_d2, mainloop2_go_d3, mainloop2_go_d4, mainloop2_go_d5, mainloop2_go_d6, mainloop2_go_d7, mainloop2_go_d8, mainloop2_go_d9, mainloop2_go_d10, mainloop2_go_d11, mainloop2_go_d12, mainloop2_go_d13, mainloop2_go_d14} <= {mainloop2_go, mainloop2_go_d1, mainloop2_go_d2, mainloop2_go_d3, mainloop2_go_d4, mainloop2_go_d5, mainloop2_go_d6, mainloop2_go_d7, mainloop2_go_d8, mainloop2_go_d9, mainloop2_go_d10, mainloop2_go_d11, mainloop2_go_d12, mainloop2_go_d13};

	wire	 init_datahub_req_main2 = mainloop2_go | mainloop2_go_d6;	

//	wire		init_ab_f_main2 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main2;
	go_CDC_go go_CDC_go_init_f2(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==2)),	
		.clk_o		(clk_main2),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main2)
		);
		
	wire		go_write_ex_main2;
	go_CDC_go go_CDC_go_write_ex2(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==2)),	
		.clk_o		(clk_main2),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main2)
		);
		
	wire		im_datahub_req_main2;
	go_CDC_go go_CDC_go_im_datahub_req2(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==2)),	
		.clk_o		(clk_main2),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main2)
		);
	
	
	
	wire	main_ready_m2domain; // main2 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready2(	
		.clk_i		(clk_main2),
		.rstn_i		(rstn),
		.go_i		(main_ready_m2domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main2_ready)
		);
	wire	w_im_buf_ready_m2domain; // main2 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready2(	
		.clk_i		(clk_main2),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m2domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_main2_ready)
		);
		

	reg											cenb_init_rbuf_main2;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf_main2;
	reg			[`W_IDX:0]						ab_init_rbuf_main2;

	wire										cena_init_rbuf_main2;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf_main2;
	wire		[`W_IDX:0]						aa_init_rbuf_main2;
	
	
	
	rfdp32x22 init_rbuf_main2 (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf_main2),
		.DB		(db_init_rbuf_main2	),
		.AB		(ab_init_rbuf_main2	),
		.CLKA	(clk_main2),
		.CENA	(cena_init_rbuf_main2),
		.QA		(qa_init_rbuf_main2	),
	    .AA		(aa_init_rbuf_main2	)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf_main2 <= 1;
	//	else 		cenb_init_rbuf_main2 <= ~init_ab_f_main2;
		else 		cenb_init_rbuf_main2 <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf_main2 <= 1;
		else 		ab_init_rbuf_main2 <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf_main2 <= 1;
		else 		db_init_rbuf_main2 <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
	

	

	rfdp256x128 im_buf_main2 (
		.CLKB	(clk_main2),
		.CENB	(cenb_im_buf_main2),
		.DB		(db_im_buf_main2	),
		.AB		(ab_im_buf_main2	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf_main2	),
	    .AA		(aa_im_buf	)
	);
	
	mainNpad mainNpad_2(
		.clk 					(clk_main2), 		
		.rstn					(rstn),
	
		.init_ab_f			(init_ab_f_main2  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.ex_datahub_req			(go_write_ex_main2),
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf_main2	),
		.cena_ex_buf			(cena_ex_buf_main2),
		.aa_ex_buf				(aa_ex_buf_main2	),
	
		.init_datahub_req		(init_datahub_req_main2),
		.cena_init_rbuf			(cena_init_rbuf_main2	),
		.qa_init_rbuf			(qa_init_rbuf_main2	),
		.aa_init_rbuf			(aa_init_rbuf_main2	),


		//.im_datahub_req			(im_datahub_req),
		.im_datahub_req			(im_datahub_req_main2),
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf_main2	),
		.db_im_buf			(db_im_buf_main2	),
		.ab_im_buf			(ab_im_buf_main2	),
		.w_im_buf_ready		(w_im_buf_ready_m2domain),
		
		.main_ready			(main_ready_m2domain)


	`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm2_a			),
		.extm_d			    (extm2_d			),
		.extm_q	            (extm2_q	),
		.extm_ren		    (extm2_ren		),
		.extm_wen		    (extm2_wen		),
		.extm_af_afull      (extm2_af_afull),
		.extm_qv		    (extm2_qv		),
		.extm_brst		    (extm2_brst		),
		.extm_brst_len      (extm2_brst_len),
		.extm_clk           (extm2_clk)
	`else
		,
		.amm_burstbegin			 (amm2_burstbegin),
		.amm_read              	 (amm2_read               ),   
		.amm_write               (amm2_write              ),  
		.amm_address             (amm2_address            ),  
		.amm_writedata           (amm2_writedata          ),  
		.amm_burstcount          (amm2_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl2_auto_precharge_req),
		.amm_ready               (amm2_ready              ),  
		.amm_readdata            (amm2_readdata           ),  
		.amm_readdatavalid       (amm2_readdatavalid      )
	`endif	
	); 	
	//===========================================================================
		wire		mainloop3_go;
	go_CDC_go go_CDC_go_main3(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==3)),	
		.clk_o		(clk_main3),
	    .rst_o		(rstn),
	    .go_o       (mainloop3_go)
		);
	reg					mainloop3_go_d1, mainloop3_go_d2, mainloop3_go_d3, mainloop3_go_d4, mainloop3_go_d5, mainloop3_go_d6, mainloop3_go_d7, mainloop3_go_d8, mainloop3_go_d9, mainloop3_go_d10, mainloop3_go_d11, mainloop3_go_d12, mainloop3_go_d13, mainloop3_go_d14;
	always @(posedge clk_main3)
		if (!rstn)		{mainloop3_go_d1, mainloop3_go_d2, mainloop3_go_d3, mainloop3_go_d4, mainloop3_go_d5, mainloop3_go_d6, mainloop3_go_d7, mainloop3_go_d8, mainloop3_go_d9, mainloop3_go_d10, mainloop3_go_d11, mainloop3_go_d12, mainloop3_go_d13, mainloop3_go_d14} <= 0;
		else			{mainloop3_go_d1, mainloop3_go_d2, mainloop3_go_d3, mainloop3_go_d4, mainloop3_go_d5, mainloop3_go_d6, mainloop3_go_d7, mainloop3_go_d8, mainloop3_go_d9, mainloop3_go_d10, mainloop3_go_d11, mainloop3_go_d12, mainloop3_go_d13, mainloop3_go_d14} <= {mainloop3_go, mainloop3_go_d1, mainloop3_go_d2, mainloop3_go_d3, mainloop3_go_d4, mainloop3_go_d5, mainloop3_go_d6, mainloop3_go_d7, mainloop3_go_d8, mainloop3_go_d9, mainloop3_go_d10, mainloop3_go_d11, mainloop3_go_d12, mainloop3_go_d13};

	wire	 init_datahub_req_main3 = mainloop3_go | mainloop3_go_d6;	

//	wire		init_ab_f_main3 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main3;
	go_CDC_go go_CDC_go_init_f3(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==3)),	
		.clk_o		(clk_main3),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main3)
		);
		
	wire		go_write_ex_main3;
	go_CDC_go go_CDC_go_write_ex3(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==3)),	
		.clk_o		(clk_main3),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main3)
		);
		
	wire		im_datahub_req_main3;
	go_CDC_go go_CDC_go_im_datahub_req3(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==3)),	
		.clk_o		(clk_main3),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main3)
		);
	
	
	
	wire	main_ready_m3domain; // main3 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready3(	
		.clk_i		(clk_main3),
		.rstn_i		(rstn),
		.go_i		(main_ready_m3domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main3_ready)
		);
	wire	w_im_buf_ready_m3domain; // main3 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready3(	
		.clk_i		(clk_main3),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m3domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_main3_ready)
		);
		

	reg											cenb_init_rbuf_main3;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf_main3;
	reg			[`W_IDX:0]						ab_init_rbuf_main3;

	wire										cena_init_rbuf_main3;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf_main3;
	wire		[`W_IDX:0]						aa_init_rbuf_main3;
	
	
	
	rfdp32x22 init_rbuf_main3 (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf_main3),
		.DB		(db_init_rbuf_main3	),
		.AB		(ab_init_rbuf_main3	),
		.CLKA	(clk_main3),
		.CENA	(cena_init_rbuf_main3),
		.QA		(qa_init_rbuf_main3	),
	    .AA		(aa_init_rbuf_main3	)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf_main3 <= 1;
	//	else 		cenb_init_rbuf_main3 <= ~init_ab_f_main3;
		else 		cenb_init_rbuf_main3 <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf_main3 <= 1;
		else 		ab_init_rbuf_main3 <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf_main3 <= 1;
		else 		db_init_rbuf_main3 <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
	

	

	rfdp256x128 im_buf_main3 (
		.CLKB	(clk_main3),
		.CENB	(cenb_im_buf_main3),
		.DB		(db_im_buf_main3	),
		.AB		(ab_im_buf_main3	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf_main3	),
	    .AA		(aa_im_buf	)
	);
	
	mainNpad mainNpad_3(
		.clk 					(clk_main3), 		
		.rstn					(rstn),
	
		.init_ab_f			(init_ab_f_main3  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.ex_datahub_req			(go_write_ex_main3),
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf_main3	),
		.cena_ex_buf			(cena_ex_buf_main3),
		.aa_ex_buf				(aa_ex_buf_main3	),
	
		.init_datahub_req		(init_datahub_req_main3),
		.cena_init_rbuf			(cena_init_rbuf_main3	),
		.qa_init_rbuf			(qa_init_rbuf_main3	),
		.aa_init_rbuf			(aa_init_rbuf_main3	),


		//.im_datahub_req			(im_datahub_req),
		.im_datahub_req			(im_datahub_req_main3),
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf_main3	),
		.db_im_buf			(db_im_buf_main3	),
		.ab_im_buf			(ab_im_buf_main3	),
		.w_im_buf_ready		(w_im_buf_ready_m3domain),
		
		.main_ready			(main_ready_m3domain)


	`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm3_a			),
		.extm_d			    (extm3_d			),
		.extm_q	            (extm3_q	),
		.extm_ren		    (extm3_ren		),
		.extm_wen		    (extm3_wen		),
		.extm_af_afull      (extm3_af_afull),
		.extm_qv		    (extm3_qv		),
		.extm_brst		    (extm3_brst		),
		.extm_brst_len      (extm3_brst_len),
		.extm_clk           (extm3_clk)
	`else
		,
		.amm_burstbegin			 (amm3_burstbegin),
		.amm_read              	 (amm3_read               ),   
		.amm_write               (amm3_write              ),  
		.amm_address             (amm3_address            ),  
		.amm_writedata           (amm3_writedata          ),  
		.amm_burstcount          (amm3_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl3_auto_precharge_req),
		.amm_ready               (amm3_ready              ),  
		.amm_readdata            (amm3_readdata           ),  
		.amm_readdatavalid       (amm3_readdatavalid      )
	`endif
	);

`endif


	
`ifdef WITH_SIX_MAIN

	wire		mainloop4_go;
	go_CDC_go go_CDC_go_main4(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==4)),	
		.clk_o		(clk_main4),
	    .rst_o		(rstn),
	    .go_o       (mainloop4_go)
		);
	reg					mainloop4_go_d1, mainloop4_go_d2, mainloop4_go_d3, mainloop4_go_d4, mainloop4_go_d5, mainloop4_go_d6, mainloop4_go_d7, mainloop4_go_d8, mainloop4_go_d9, mainloop4_go_d10, mainloop4_go_d11, mainloop4_go_d12, mainloop4_go_d13, mainloop4_go_d14;
	always @(posedge clk_main1)
		if (!rstn)		{mainloop4_go_d1, mainloop4_go_d2, mainloop4_go_d3, mainloop4_go_d4, mainloop4_go_d5, mainloop4_go_d6, mainloop4_go_d7, mainloop4_go_d8, mainloop4_go_d9, mainloop4_go_d10, mainloop4_go_d11, mainloop4_go_d12, mainloop4_go_d13, mainloop4_go_d14} <= 0;
		else			{mainloop4_go_d1, mainloop4_go_d2, mainloop4_go_d3, mainloop4_go_d4, mainloop4_go_d5, mainloop4_go_d6, mainloop4_go_d7, mainloop4_go_d8, mainloop4_go_d9, mainloop4_go_d10, mainloop4_go_d11, mainloop4_go_d12, mainloop4_go_d13, mainloop4_go_d14} <= {mainloop4_go, mainloop4_go_d1, mainloop4_go_d2, mainloop4_go_d3, mainloop4_go_d4, mainloop4_go_d5, mainloop4_go_d6, mainloop4_go_d7, mainloop4_go_d8, mainloop4_go_d9, mainloop4_go_d10, mainloop4_go_d11, mainloop4_go_d12, mainloop4_go_d13};

	wire	 init_datahub_req_main4 = mainloop4_go | mainloop4_go_d6;	

//	wire		init_ab_f_main4 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main4;
	go_CDC_go go_CDC_go_init_f4(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==4)),	
		.clk_o		(clk_main4),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main4)
		);
		
	wire		go_write_ex_main4;
	go_CDC_go go_CDC_go_write_ex4(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==4)),	
		.clk_o		(clk_main4),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main4)
		);
		
	wire		im_datahub_req_main4;
	go_CDC_go go_CDC_go_im_datahub_req4(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==4)),	
		.clk_o		(clk_main4),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main4)
		);
	
	
	
	wire	main_ready_m4domain; // main4 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready4(	
		.clk_i		(clk_main4),
		.rstn_i		(rstn),
		.go_i		(main_ready_m4domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main4_ready)
		);
	wire	w_im_buf_ready_m4domain; // main4 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready4(	
		.clk_i		(clk_main4),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m4domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_main4_ready)
		);
		

	reg											cenb_init_rbuf_main4;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf_main4;
	reg			[`W_IDX:0]						ab_init_rbuf_main4;

	wire										cena_init_rbuf_main4;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf_main4;
	wire		[`W_IDX:0]						aa_init_rbuf_main4;
	
	
	
	rfdp32x22 init_rbuf_main4 (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf_main4),
		.DB		(db_init_rbuf_main4	),
		.AB		(ab_init_rbuf_main4	),
		.CLKA	(clk_main4),
		.CENA	(cena_init_rbuf_main4),
		.QA		(qa_init_rbuf_main4	),
	    .AA		(aa_init_rbuf_main4	)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf_main4 <= 1;
	//	else 		cenb_init_rbuf_main4 <= ~init_ab_f_main4;
		else 		cenb_init_rbuf_main4 <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf_main4 <= 1;
		else 		ab_init_rbuf_main4 <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf_main4 <= 1;
		else 		db_init_rbuf_main4 <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
	

	

	rfdp256x128 im_buf_main4 (
		.CLKB	(clk_main4),
		.CENB	(cenb_im_buf_main4),
		.DB		(db_im_buf_main4	),
		.AB		(ab_im_buf_main4	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf_main4	),
	    .AA		(aa_im_buf	)
	);
	
	mainNpad mainNpad_4(
		.clk 					(clk_main4), 		
		.rstn					(rstn),
	
		.init_ab_f			(init_ab_f_main4  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.ex_datahub_req			(go_write_ex_main4),
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf_main4	),
		.cena_ex_buf			(cena_ex_buf_main4),
		.aa_ex_buf				(aa_ex_buf_main4	),
	
		.init_datahub_req		(init_datahub_req_main4),
		.cena_init_rbuf			(cena_init_rbuf_main4	),
		.qa_init_rbuf			(qa_init_rbuf_main4	),
		.aa_init_rbuf			(aa_init_rbuf_main4	),


		//.im_datahub_req			(im_datahub_req),
		.im_datahub_req			(im_datahub_req_main4),
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf_main4	),
		.db_im_buf			(db_im_buf_main4	),
		.ab_im_buf			(ab_im_buf_main4	),
		.w_im_buf_ready		(w_im_buf_ready_m4domain),
		
		.main_ready			(main_ready_m4domain)


	`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm4_a			),
		.extm_d			    (extm4_d			),
		.extm_q	            (extm4_q	),
		.extm_ren		    (extm4_ren		),
		.extm_wen		    (extm4_wen		),
		.extm_af_afull      (extm4_af_afull),
		.extm_qv		    (extm4_qv		),
		.extm_brst		    (extm4_brst		),
		.extm_brst_len      (extm4_brst_len),
		.extm_clk           (extm4_clk)
	`else
		,
		.amm_burstbegin			 (amm4_burstbegin),
		.amm_read              	 (amm4_read               ),   
		.amm_write               (amm4_write              ),  
		.amm_address             (amm4_address            ),  
		.amm_writedata           (amm4_writedata          ),  
		.amm_burstcount          (amm4_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl4_auto_precharge_req),
		.amm_ready               (amm4_ready              ),  
		.amm_readdata            (amm4_readdata           ),  
		.amm_readdatavalid       (amm4_readdatavalid      )
	`endif	
	); 	
	//===========================================================================
		wire		mainloop5_go;
	go_CDC_go go_CDC_go_main5(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(mainloop_go  & (ex_cur_main==5)),	
		.clk_o		(clk_main5),
	    .rst_o		(rstn),
	    .go_o       (mainloop5_go)
		);
	reg					mainloop5_go_d1, mainloop5_go_d2, mainloop5_go_d3, mainloop5_go_d4, mainloop5_go_d5, mainloop5_go_d6, mainloop5_go_d7, mainloop5_go_d8, mainloop5_go_d9, mainloop5_go_d10, mainloop5_go_d11, mainloop5_go_d12, mainloop5_go_d13, mainloop5_go_d14;
	always @(posedge clk_main5)
		if (!rstn)		{mainloop5_go_d1, mainloop5_go_d2, mainloop5_go_d3, mainloop5_go_d4, mainloop5_go_d5, mainloop5_go_d6, mainloop5_go_d7, mainloop5_go_d8, mainloop5_go_d9, mainloop5_go_d10, mainloop5_go_d11, mainloop5_go_d12, mainloop5_go_d13, mainloop5_go_d14} <= 0;
		else			{mainloop5_go_d1, mainloop5_go_d2, mainloop5_go_d3, mainloop5_go_d4, mainloop5_go_d5, mainloop5_go_d6, mainloop5_go_d7, mainloop5_go_d8, mainloop5_go_d9, mainloop5_go_d10, mainloop5_go_d11, mainloop5_go_d12, mainloop5_go_d13, mainloop5_go_d14} <= {mainloop5_go, mainloop5_go_d1, mainloop5_go_d2, mainloop5_go_d3, mainloop5_go_d4, mainloop5_go_d5, mainloop5_go_d6, mainloop5_go_d7, mainloop5_go_d8, mainloop5_go_d9, mainloop5_go_d10, mainloop5_go_d11, mainloop5_go_d12, mainloop5_go_d13};

	wire	 init_datahub_req_main5 = mainloop5_go | mainloop5_go_d6;	

//	wire		init_ab_f_main5 = init_ab_f  & (ex_cur_main==0);
	wire		init_ab_f_main5;
	go_CDC_go go_CDC_go_init_f5(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(init_ab_f  & (ex_cur_main==5)),	
		.clk_o		(clk_main5),
	    .rst_o		(rstn),
	    .go_o       (init_ab_f_main5)
		);
		
	wire		go_write_ex_main5;
	go_CDC_go go_CDC_go_write_ex5(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(go_write_ex  & (ex_cur_main==5)),	
		.clk_o		(clk_main5),
	    .rst_o		(rstn),
	    .go_o       (go_write_ex_main5)
		);
		
	wire		im_datahub_req_main5;
	go_CDC_go go_CDC_go_im_datahub_req5(	
		.clk_i		(clk),
		.rstn_i		(rstn),
		.go_i		(im_datahub_req & (im_cur_main==5)),	
		.clk_o		(clk_main5),
	    .rst_o		(rstn),
	    .go_o       (im_datahub_req_main5)
		);
	
	
	
	wire	main_ready_m5domain; // main5 clk domain
	//wire	main_ready; // clk domain
	go_CDC_go go_CDC_main_ready5(	
		.clk_i		(clk_main5),
		.rstn_i		(rstn),
		.go_i		(main_ready_m5domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (main5_ready)
		);
	wire	w_im_buf_ready_m5domain; // main5 clk domain
	//wire	w_im_buf_ready; // clk domain
	go_CDC_go go_CDC_w_im_buf_ready5(	
		.clk_i		(clk_main5),
		.rstn_i		(rstn),
		.go_i		(w_im_buf_ready_m5domain),	
		.clk_o		(clk),
	    .rst_o		(rstn),
	    .go_o       (w_im_buf_main5_ready)
		);
		

	reg											cenb_init_rbuf_main5;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf_main5;
	reg			[`W_IDX:0]						ab_init_rbuf_main5;

	wire										cena_init_rbuf_main5;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf_main5;
	wire		[`W_IDX:0]						aa_init_rbuf_main5;
	
	
	
	rfdp32x22 init_rbuf_main5 (
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf_main5),
		.DB		(db_init_rbuf_main5	),
		.AB		(ab_init_rbuf_main5	),
		.CLKA	(clk_main5),
		.CENA	(cena_init_rbuf_main5),
		.QA		(qa_init_rbuf_main5	),
	    .AA		(aa_init_rbuf_main5	)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_init_rbuf_main5 <= 1;
	//	else 		cenb_init_rbuf_main5 <= ~init_ab_f_main5;
		else 		cenb_init_rbuf_main5 <= ~init_ab_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	ab_init_rbuf_main5 <= 1;
		else 		ab_init_rbuf_main5 <= init_ab_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)	db_init_rbuf_main5 <= 1;
		else 		db_init_rbuf_main5 <= {init_ab_idx,init_a[4+`W_AMEM:4]};
		
	

	

	rfdp256x128 im_buf_main5 (
		.CLKB	(clk_main5),
		.CENB	(cenb_im_buf_main5),
		.DB		(db_im_buf_main5	),
		.AB		(ab_im_buf_main5	),
		.CLKA	(clk),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf_main5	),
	    .AA		(aa_im_buf	)
	);
	
	mainNpad mainNpad_5(
		.clk 					(clk_main5), 		
		.rstn					(rstn),
	
		.init_ab_f			(init_ab_f_main5  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.ex_datahub_req			(go_write_ex_main5),
		.ex_wr_idx				(ex_wr_idx_reg),

		.qa_ex_buf				(qa_ex_buf_main5	),
		.cena_ex_buf			(cena_ex_buf_main5),
		.aa_ex_buf				(aa_ex_buf_main5	),
	
		.init_datahub_req		(init_datahub_req_main5),
		.cena_init_rbuf			(cena_init_rbuf_main5	),
		.qa_init_rbuf			(qa_init_rbuf_main5	),
		.aa_init_rbuf			(aa_init_rbuf_main5	),


		//.im_datahub_req			(im_datahub_req),
		.im_datahub_req			(im_datahub_req_main5),
		.im_rd_idx				(im_rd_idx),

		.cenb_im_buf		(cenb_im_buf_main5	),
		.db_im_buf			(db_im_buf_main5	),
		.ab_im_buf			(ab_im_buf_main5	),
		.w_im_buf_ready		(w_im_buf_ready_m5domain),
		
		.main_ready			(main_ready_m5domain)


	`ifdef IDEAL_EXTMEM			
		,
		.extm_a				(extm5_a			),
		.extm_d			    (extm5_d			),
		.extm_q	            (extm5_q	),
		.extm_ren		    (extm5_ren		),
		.extm_wen		    (extm5_wen		),
		.extm_af_afull      (extm5_af_afull),
		.extm_qv		    (extm5_qv		),
		.extm_brst		    (extm5_brst		),
		.extm_brst_len      (extm5_brst_len),
		.extm_clk           (extm5_clk)
	`else
		,
		.amm_burstbegin			 (amm5_burstbegin),
		.amm_read              	 (amm5_read               ),   
		.amm_write               (amm5_write              ),  
		.amm_address             (amm5_address            ),  
		.amm_writedata           (amm5_writedata          ),  
		.amm_burstcount          (amm5_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl5_auto_precharge_req),
		.amm_ready               (amm5_ready              ),  
		.amm_readdata            (amm5_readdata           ),  
		.amm_readdatavalid       (amm5_readdatavalid      )
	`endif
	);

`endif



endmodule




module mainNpad (
	input						clk,
	input						rstn,
	input						init_ab_f,
	input		[127:0]			init_a, init_b,
	input		[63:0]			init_tweak,
	input		[`W_IDX:0]		init_ab_idx,
	
	input						ex_datahub_req,	
	
	input						go_write_ex,
	input		[`W_IDX:0]		ex_wr_idx,
	input 		[`W_MEM	:0]		db_scratchpad_ex,
	input						cenb_scratchpad_ex,
	input		[`W_EXTMWADDR:0]ab_scratchpad_ex,
	
	input 		[`W_MEM	:0]		qa_scratchpad_ex,
	output						cena_scratchpad_ex,
	output		[4:0]			aa_scratchpad_ex,
	
	
	input 			[`W_MEM	:0]						qa_ex_buf,
	output											cena_ex_buf,
	output			[4:0]							aa_ex_buf,
		
		
	input								init_datahub_req,
	output								cena_init_rbuf,
	output		[`W_IDX+1+`W_AMEM:0]	qa_init_rbuf,
	output		[`W_IDX:0]				aa_init_rbuf,	

	input							im_datahub_req,
	input		[`W_IDX:0]			im_rd_idx,
	
	output						cenb_im_buf,
	output		[`W_MEM:0]		db_im_buf,
	output		[`W_IDX+3:0]	ab_im_buf,
	output						w_im_buf_ready,
	
	output						main_ready,
	

`ifdef IDEAL_EXTMEM		
	output    	[`W_EXTMWADDR :0] 		extm_a,			// Word Address ExtMem
	output    	[`W_SDD       :0]		extm_d,			// writing data to ExtMem
	input		[`W_SDD       :0]		extm_q,	
	output    							extm_ren,		// read-enable to ExtMem, high enable
	output    							extm_wen,		// write-enable to ExtMem, high enable
	input								extm_af_afull,
	input								extm_qv,		// valid signal of extm_q			
	output								extm_brst,		// begin of a burst
	output			[ 5:0]				extm_brst_len,	// real burst length = extm_brst_len + 1
	output								extm_clk	

`else
	output  			       			amm_burstbegin,                   
	output  			       			amm_read,                   
	output  			       			amm_write,                  
	output  		[`W_EXTMWADDR :0] 	amm_address,                
	output  		[`W_SDD       :0]	amm_writedata,              
	output  		[6:0]  				amm_burstcount,             
	output  			       			ctrl_auto_precharge_req,
	
	input 			       				amm_ready,                  
	input 			[`W_SDD       :0]	amm_readdata,               
	input 			       				amm_readdatavalid      
`endif	

);
	wire										w_loop1_buf_ready;
	wire										cenb_loop1_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop1_wbuf;
	wire		[`W_IDX:0]						ab_loop1_wbuf;
	
	wire										cena_loop1_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop1_wbuf;
	wire		[`W_IDX:0]						aa_loop1_wbuf;
	
	
	wire										cenb_loop1_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			db_loop1_rbuf;
	wire		[`W_IDX:0]						ab_loop1_rbuf;

	wire										cena_loop1_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_loop1_rbuf;
	wire		[`W_IDX:0]						aa_loop1_rbuf;
	
	
	wire										w_loop2_buf_ready;
	wire										cenb_loop2_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop2_wbuf;
	wire		[`W_IDX:0]						ab_loop2_wbuf;
	
	wire										cena_loop2_wbuf;
	wire		[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop2_wbuf;
	wire		[`W_IDX:0]						aa_loop2_wbuf;
	
	
	wire										cenb_loop2_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			db_loop2_rbuf;
	wire		[`W_IDX:0]						ab_loop2_rbuf;

	wire										cena_loop2_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_loop2_rbuf;
	wire		[`W_IDX:0]						aa_loop2_rbuf;
	
//	reg											cenb_init_rbuf;
//	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf;
//	reg			[`W_IDX:0]						ab_init_rbuf;
//
//	wire										cena_init_rbuf;
//	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf;
//	wire		[`W_IDX:0]						aa_init_rbuf;
	
	wire										cenb_loop1_buf;
	wire		[`W_MEM:0]						db_loop1_buf;
	wire		[`W_IDX:0]						ab_loop1_buf;
	wire										cena_loop1_buf;
	wire		[`W_MEM:0]						qa_loop1_buf;
	wire		[`W_IDX:0]						aa_loop1_buf;
	
	wire										cenb_loop2_buf;
	wire		[`W_MEM:0]						db_loop2_buf;
	wire		[`W_IDX:0]						ab_loop2_buf;
	wire										cena_loop2_buf;
	wire		[`W_MEM:0]						qa_loop2_buf;
	wire		[`W_IDX:0]						aa_loop2_buf;
	
	
//	wire										cenb_im_buf;
//	wire		[`W_MEM:0]						db_im_buf;
//	wire		[`W_IDX+3:0]					ab_im_buf;
//	reg											cena_im_buf;
//	wire		[`W_MEM:0]						qa_im_buf;
//	reg			[`W_IDX+3:0]					aa_im_buf;
	
//	wire										w_im_buf_ready;

	
	rfdp32x150 loop1_wbuf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop1_wbuf),
		.DB		(db_loop1_wbuf	),
		.AB		(ab_loop1_wbuf	),
		.CENA	(cena_loop1_wbuf),
		.QA		(qa_loop1_wbuf	),
	    .AA		(aa_loop1_wbuf	)
	);
	
	rfdp32x22 loop1_rbuf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop1_rbuf),
		.DB		(db_loop1_rbuf	),
		.AB		(ab_loop1_rbuf	),
		.CENA	(cena_loop1_rbuf),
		.QA		(qa_loop1_rbuf	),
	    .AA		(aa_loop1_rbuf	)
	);
	

	rfdp32x150 loop2_wbuf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop2_wbuf),
		.DB		(db_loop2_wbuf	),
		.AB		(ab_loop2_wbuf	),
		.CENA	(cena_loop2_wbuf),
		.QA		(qa_loop2_wbuf	),
	    .AA		(aa_loop2_wbuf	)
	);
	
	rfdp32x22 loop2_rbuf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop2_rbuf),
		.DB		(db_loop2_rbuf	),
		.AB		(ab_loop2_rbuf	),
		.CENA	(cena_loop2_rbuf),
		.QA		(qa_loop2_rbuf	),
	    .AA		(aa_loop2_rbuf	)
	);
	
	
	rfdp32x128 loop1_buf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop1_buf),
		.DB		(db_loop1_buf	),
		.AB		(ab_loop1_buf	),
		.CENA	(cena_loop1_buf),
		.QA		(qa_loop1_buf	),
	    .AA		(aa_loop1_buf	)
	);
	rfdp32x128 loop2_buf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_loop2_buf),
		.DB		(db_loop2_buf	),
		.AB		(ab_loop2_buf	),
		.CENA	(cena_loop2_buf),
		.QA		(qa_loop2_buf	),
	    .AA		(aa_loop2_buf	)
	);
	
	

	mainlooptest mainlooptest1(
		.clk 				(clk), 		
		.rstn				(rstn),
		
		.init_ab_f			(init_ab_f  ),
		.init_a				(init_a		), 
		.init_b				(init_b		),
		.init_tweak			(init_tweak	),
		.init_ab_idx		(init_ab_idx),
		
		.qa_loop1_buf		(qa_loop1_buf	),
		.aa_loop1_buf		(aa_loop1_buf	),
		.cena_loop1_buf		(cena_loop1_buf),
		
		.w_loop1_buf_ready 	(w_loop1_buf_ready),
		.loop1_datahub_req	(loop1_datahub_req),
		
		.cenb_loop1_wbuf	(cenb_loop1_wbuf),
		.db_loop1_wbuf		(db_loop1_wbuf	),
		.ab_loop1_wbuf		(ab_loop1_wbuf	),
		
		.cenb_loop1_rbuf	(cenb_loop1_rbuf),
		.db_loop1_rbuf		(db_loop1_rbuf	),
		.ab_loop1_rbuf      (ab_loop1_rbuf  ),
		
		
		
		.w_loop2_buf_ready 	(w_loop2_buf_ready),
		.loop2_datahub_req	(loop2_datahub_req),
		.loop2_datahub_req_last	(loop2_datahub_req_last),
		
		.qa_loop2_buf		(qa_loop2_buf	),
		.aa_loop2_buf		(aa_loop2_buf	),
		.cena_loop2_buf		(cena_loop2_buf),
		
		
		.cenb_loop2_wbuf	(cenb_loop2_wbuf),
		.db_loop2_wbuf		(db_loop2_wbuf	),
		.ab_loop2_wbuf		(ab_loop2_wbuf	),
		
		.cenb_loop2_rbuf	(cenb_loop2_rbuf),
		.db_loop2_rbuf		(db_loop2_rbuf	),
		.ab_loop2_rbuf      (ab_loop2_rbuf  ),
		.ready				(main_ready)
	
	);	

	wire							cmd_go;
	wire		[4:0]				cmd;
	wire		[`W_EXTMWADDR :0] 	addr_i_to_sd;
	wire		[`W_MEM:0]			data_i_to_sd;
	wire		[`W_MEM:0]			data_o_from_sd;
	wire							data_o_from_sd_f;	

	wire		[`W_AMEM:0]			imp_rd_addr;
	wire		[`W_AMEM:0]			ex_wr_addr;
	

	
	data_hub data_hub(
		.clk 					(clk), 		
		.rstn					(rstn),
		.init_datahub_req		(init_datahub_req), 
		.loop1_datahub_req		(loop1_datahub_req),
		.loop2_datahub_req		(loop2_datahub_req),
		.loop2_datahub_req_last	(loop2_datahub_req_last),
		
		.ex_datahub_req			(ex_datahub_req),
		.go_write_ex			(go_write_ex),
		.qa_scratchpad_ex		(qa_scratchpad_ex	),
		.cena_scratchpad_ex		(cena_scratchpad_ex	),
		.aa_scratchpad_ex		(aa_scratchpad_ex	),
		
		.qa_ex_buf				(qa_ex_buf	),
		.cena_ex_buf			(cena_ex_buf),
		.aa_ex_buf				(aa_ex_buf	),
		.ex_wr_addr				(ex_wr_addr),
				
		
		
		.im_datahub_req			(im_datahub_req),
		.idx_im0				(im_rd_idx),
		
		.cena_init_rbuf			(cena_init_rbuf	),
		.qa_init_rbuf			(qa_init_rbuf	),
		.aa_init_rbuf			(aa_init_rbuf	),
		
		.imp_rd_addr			(imp_rd_addr),

		
		.cmd_go					(cmd_go),
		.cmd					(cmd),
		
		.cena_loop1_wbuf	(cena_loop1_wbuf),
		.qa_loop1_wbuf		(qa_loop1_wbuf	),
	    .aa_loop1_wbuf		(aa_loop1_wbuf	),
		
		.cena_loop1_rbuf	(cena_loop1_rbuf),
		.qa_loop1_rbuf		(qa_loop1_rbuf	),
	    .aa_loop1_rbuf		(aa_loop1_rbuf	),
		
		.cena_loop2_wbuf	(cena_loop2_wbuf),
		.qa_loop2_wbuf		(qa_loop2_wbuf	),
	    .aa_loop2_wbuf		(aa_loop2_wbuf	),
		
		.cena_loop2_rbuf	(cena_loop2_rbuf),
		.qa_loop2_rbuf		(qa_loop2_rbuf	),
	    .aa_loop2_rbuf		(aa_loop2_rbuf	),
		
		.w_loop1_buf_ready	(w_loop1_buf_ready),
		.w_loop2_buf_ready	(w_loop2_buf_ready),
		
		.cenb_loop1_buf		(cenb_loop1_buf	),
		.db_loop1_buf		(db_loop1_buf	),
		.ab_loop1_buf		(ab_loop1_buf	),

		.cenb_loop2_buf		(cenb_loop2_buf	),
		.db_loop2_buf		(db_loop2_buf	),
		.ab_loop2_buf		(ab_loop2_buf	),
	
		.cenb_im_buf		(cenb_im_buf	),
		.db_im_buf			(db_im_buf	),
		.ab_im_buf			(ab_im_buf	),
		.w_im_buf_ready		(w_im_buf_ready),	
		
		.addr_i_to_sd		(addr_i_to_sd),
		.data_i_to_sd       (data_i_to_sd),
		
		.data_o_from_sd		(data_o_from_sd),
	    .data_o_from_sd_f	(data_o_from_sd_f)
	);
	
	
	extm_controller extm_controller(
		.clk 					(clk), 		
		.rstn					(rstn),
		.cmd_go					(cmd_go),
		.cmd					(cmd),
`ifdef 	SIMULATION_LESS_IMPLODE_CYCLES	
		.imp_rd_addr			({5'h0, imp_rd_addr[`W_AMEM-5:0]}),
`else
		.imp_rd_addr			(imp_rd_addr),
`endif		
	//	.imp_rd_addr			(imp_rd_addr),
		.im_rd_idx				(im_rd_idx),

`ifdef 	SIMULATION_LESS_EXPLODE_CYCLES	
		.ex_wr_addr				({5'h0, ex_wr_addr[`W_AMEM-5:0]}),
`else
		.ex_wr_addr				(ex_wr_addr),
`endif
		.ex_wr_idx				(ex_wr_idx),
		
		.db_scratchpad_ex		(db_scratchpad_ex	),
		.cenb_scratchpad_ex		(cenb_scratchpad_ex	),
		.ab_scratchpad_ex		(ab_scratchpad_ex	),
`ifdef 	SIMULATION_LESS_EXPLODE_CYCLES	

		.addr_i_to_sd		( {addr_i_to_sd[`W_EXTMWADDR: `W_AMEM+1],5'h0,addr_i_to_sd[`W_AMEM:5]}),
`else		
		.addr_i_to_sd		(addr_i_to_sd),
`endif
		.data_i_to_sd       (data_i_to_sd),
		.data_o_from_sd		(data_o_from_sd),
	    .data_o_from_sd_f	(data_o_from_sd_f)
		
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
		.amm_burstbegin			 (amm_burstbegin),
		.amm_read              	 (amm_read               ),   
		.amm_write               (amm_write              ),  
		.amm_address             (amm_address            ),  
		.amm_writedata           (amm_writedata          ),  
		.amm_burstcount          (amm_burstcount         ),  
		.ctrl_auto_precharge_req (ctrl_auto_precharge_req),
		.amm_ready               (amm_ready              ),  
		.amm_readdata            (amm_readdata           ),  
		.amm_readdatavalid       (amm_readdatavalid      )
`endif
	);

endmodule


module genkeyExplode_2p(
	input						clk , 		
	input						rstn,
			
	
	output reg					cena_hash_buf,
	output reg	[3:0]			aa_hash_buf,
	input		[127:0]			qa_hash_buf,
	
	output reg					ready_hash_buf,		
	input		[7:0]			hash_buf_item,
	input						ready_cn,
`ifdef WITH_TWO_MAIN	
	output reg	[`W_MAIN:0]		ex_cur_main,

	//input		scratchpad_in_use,	
	//input		scratchpad1_in_use,	
	input						ready_cn1,
	
`endif
`ifdef WITH_FOUR_MAIN	
	input						ready_cn2,
	input						ready_cn3,
`endif
`ifdef WITH_SIX_MAIN	
	input						ready_cn4,
	input						ready_cn5,
`endif

	output  					go_write_ex,
		
	output reg	 [`W_IDX:0]		ex_wr_idx,
	
	
	output	reg [`W_MEM	:0]		db_scratchpad_ex,
	output	reg					cenb_scratchpad_ex,
	output	reg	[`W_AEXBUF:0]	ab_scratchpad_ex,


	output reg	[`W_AIKBUF:0]	ab_ik_buf,
	output reg					cenb_ik_buf,
	output reg	[ 127:0]		db_ik_buf,
	output reg	[`W_IDX+2:0]	ik_buf_wid,
	
	
	output reg						init_ab_f,
	output reg		[127:0]			init_a, init_b,
	output reg		[63:0]			init_tweak,
	output reg		[`W_IDX:0]		init_ab_idx,

	
	
	output reg 					explode_ready
	
	);

	
	reg		[127:0]			hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11; 						
	reg		[ 63:0]			tweak1_2_0_i;	
	
	reg		[127:0]			hash0_ex0,hash1_ex0,hash2_ex0,hash3_ex0,hash4_ex0,hash5_ex0,hash6_ex0,hash7_ex0,hash8_ex0,hash9_ex0,hash10_ex0,hash11_ex0 ; 						
	reg		[ 63:0]			tweak_ex0;	

	reg		[127:0]			hash0_ex1,hash1_ex1,hash2_ex1,hash3_ex1,hash4_ex1,hash5_ex1,hash6_ex1,hash7_ex1,hash8_ex1,hash9_ex1,hash10_ex1,hash11_ex1 ; 						
	reg		[ 63:0]			tweak_ex1;		

	
	reg		[`W_IDX:0]	hash_buf_round; // 
	reg					cena_hash_buf_d1;
	reg					ready_hash_buf_b1;
	
	reg				doing_ex;
	reg				doing_hash_round;
	reg				doing_hash;
	reg				doing_cn;
	reg				read_hash_done;
//============== read hash buffer ==============
	
	reg				scratchpad_in_use;

`ifdef WITH_TWO_MAIN
//	reg			[`W_MAIN:0]		ex_cur_main;

//	reg							ready_cn1;
	reg							scratchpad1_in_use;
	
	always @(`CLK_RST_EDGE)
		if (`RST)												scratchpad_in_use <= 0;
		else if (ready_hash_buf & (ex_cur_main==0) & hash_buf_round==`TASKN-1)		scratchpad_in_use <= 1;		
		else if (ready_cn)										scratchpad_in_use <= 0;	
		
		
	always @(`CLK_RST_EDGE)
		if (`RST)												scratchpad1_in_use <= 0;
		else if (ready_hash_buf & (ex_cur_main==1) & hash_buf_round==`TASKN-1)		scratchpad1_in_use <= 1;		
		else if (ready_cn1)										scratchpad1_in_use <= 0;	


	`ifdef WITH_FOUR_MAIN
		reg							scratchpad2_in_use;
		always @(`CLK_RST_EDGE)
			if (`RST)																	scratchpad2_in_use <= 0;
			else if (ready_hash_buf & (ex_cur_main==2) & hash_buf_round==`TASKN-1)		scratchpad2_in_use <= 1;		
			else if (ready_cn2)															scratchpad2_in_use <= 0;	
		reg							scratchpad3_in_use;
		always @(`CLK_RST_EDGE)
			if (`RST)																	scratchpad3_in_use <= 0;
			else if (ready_hash_buf & (ex_cur_main==3) & hash_buf_round==`TASKN-1)		scratchpad3_in_use <= 1;		
			else if (ready_cn3)															scratchpad3_in_use <= 0;	
	
		`ifdef WITH_SIX_MAIN
			reg							scratchpad4_in_use;
			always @(`CLK_RST_EDGE)
				if (`RST)																	scratchpad4_in_use <= 0;
				else if (ready_hash_buf & (ex_cur_main==4) & hash_buf_round==`TASKN-1)		scratchpad4_in_use <= 1;		
				else if (ready_cn4)															scratchpad4_in_use <= 0;	
			reg							scratchpad5_in_use;
			always @(`CLK_RST_EDGE)
				if (`RST)																	scratchpad5_in_use <= 0;
				else if (ready_hash_buf & (ex_cur_main==5) & hash_buf_round==`TASKN-1)		scratchpad5_in_use <= 1;		
				else if (ready_cn5)															scratchpad5_in_use <= 0;	
			
			
			wire  go_hash_buf = (!scratchpad_in_use | !scratchpad1_in_use| !scratchpad2_in_use| !scratchpad3_in_use| !scratchpad4_in_use| !scratchpad5_in_use) & hash_buf_item >0 & !doing_ex & !doing_hash_round;
			always @(`CLK_RST_EDGE)
				if (`RST)		ex_cur_main <= 0;
				else if (go_hash_buf && hash_buf_round==0)
					if (!scratchpad_in_use)
						ex_cur_main <= 0;
					else if (!scratchpad1_in_use)
						ex_cur_main <= 1;
					else if (!scratchpad2_in_use)
						ex_cur_main <= 2;
					else if (!scratchpad3_in_use)
						ex_cur_main <= 3;	
					else if (!scratchpad4_in_use)
						ex_cur_main <= 4;
					else if (!scratchpad5_in_use)
						ex_cur_main <= 5;	
		`else
			wire  go_hash_buf = (!scratchpad_in_use | !scratchpad1_in_use| !scratchpad2_in_use| !scratchpad3_in_use) & hash_buf_item >0 & !doing_ex & !doing_hash_round;
			always @(`CLK_RST_EDGE)
				if (`RST)		ex_cur_main <= 0;
				else if (go_hash_buf && hash_buf_round==0)
					if (!scratchpad_in_use)
						ex_cur_main <= 0;
					else if (!scratchpad1_in_use)
						ex_cur_main <= 1;
					else if (!scratchpad2_in_use)
						ex_cur_main <= 2;
					else if (!scratchpad3_in_use)
						ex_cur_main <= 3;	
		`endif
	`else
		wire  go_hash_buf = (!scratchpad_in_use | !scratchpad1_in_use) & hash_buf_item >0 & !doing_ex & !doing_hash_round;
		always @(`CLK_RST_EDGE)
			if (`RST)		ex_cur_main <= 0;
			else if (go_hash_buf && hash_buf_round==0)
				if (!scratchpad_in_use)
					ex_cur_main <= 0;
				else if (!scratchpad1_in_use)
					ex_cur_main <= 1;
	`endif
`else
	always @(`CLK_RST_EDGE)
		if (`RST)												scratchpad_in_use <= 0;
		else if (ready_hash_buf & hash_buf_round==`TASKN-1)		scratchpad_in_use <= 1;		
		else if (ready_cn)										scratchpad_in_use <= 0;	
	
	wire  go_hash_buf = !scratchpad_in_use & hash_buf_item >0 & !doing_ex & !doing_hash_round;
`endif

	
	always @(`CLK_RST_EDGE)
		if (`RST)					doing_hash_round <= 0;
		else if (go_hash_buf)		doing_hash_round <= 1;
		else if (ready_hash_buf)	doing_hash_round <= 0;
		
	always @(`CLK_RST_EDGE)
		if (`RST)					hash_buf_round <= 0;
		else if (ready_hash_buf)	hash_buf_round <= hash_buf_round + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_hash_buf_d1 <= 1;
		else		cena_hash_buf_d1 <= cena_hash_buf;
	always @(`CLK_RST_EDGE)
		if (`RST) 					cena_hash_buf <= 1;
		else if (go_hash_buf)		cena_hash_buf <= 0;
		else if (aa_hash_buf==12)	cena_hash_buf <= 1;
	always @(`CLK_RST_EDGE)
		if (`RST) 					aa_hash_buf <= 0;
		else if (!cena_hash_buf)	aa_hash_buf <= aa_hash_buf + 1;
		else 						aa_hash_buf <= 0;
	reg		[13*128-1:0]		rx_buf;	
	always @(`CLK_RST_EDGE)
		if (`ZST)					rx_buf <= 0;
		else if (!cena_hash_buf_d1)	rx_buf <= {rx_buf, qa_hash_buf};
	always @(`CLK_RST_EDGE)
		if (`RST)									ready_hash_buf_b1 <= 0;
		else if (!cena_hash_buf && aa_hash_buf==12)	ready_hash_buf_b1 <= 1;
		else										ready_hash_buf_b1 <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf <= 0;
		else				ready_hash_buf <= ready_hash_buf_b1;
		
	always @(*) 
		{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11,tweak1_2_0_i}
				= rx_buf[ 13*128-1 :64];
		
`ifdef EX_IMPLODE_INSTANCE_4
	reg		[127:0]			hash0_ex2,hash1_ex2,hash2_ex2,hash3_ex2,hash4_ex2,hash5_ex2,hash6_ex2,hash7_ex2,hash8_ex2,hash9_ex2,hash10_ex2,hash11_ex2 ; 						
	reg		[ 63:0]			tweak_ex2;	
	reg		[127:0]			hash0_ex3,hash1_ex3,hash2_ex3,hash3_ex3,hash4_ex3,hash5_ex3,hash6_ex3,hash7_ex3,hash8_ex3,hash9_ex3,hash10_ex3,hash11_ex3 ; 						
	reg		[ 63:0]			tweak_ex3;		

	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex0,hash1_ex0,hash2_ex0,hash3_ex0,hash4_ex0,hash5_ex0,hash6_ex0,hash7_ex0,hash8_ex0,hash9_ex0,hash10_ex0,hash11_ex0} <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==0 )		{hash0_ex0,hash1_ex0,hash2_ex0,hash3_ex0,hash4_ex0,hash5_ex0,hash6_ex0,hash7_ex0,hash8_ex0,hash9_ex0,hash10_ex0,hash11_ex0} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};
	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex1,hash1_ex1,hash2_ex1,hash3_ex1,hash4_ex1,hash5_ex1,hash6_ex1,hash7_ex1,hash8_ex1,hash9_ex1,hash10_ex1,hash11_ex1} <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==1 )			{hash0_ex1,hash1_ex1,hash2_ex1,hash3_ex1,hash4_ex1,hash5_ex1,hash6_ex1,hash7_ex1,hash8_ex1,hash9_ex1,hash10_ex1,hash11_ex1} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};
	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex2,hash1_ex2,hash2_ex2,hash3_ex2,hash4_ex2,hash5_ex2,hash6_ex2,hash7_ex2,hash8_ex2,hash9_ex2,hash10_ex2,hash11_ex2} <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==2 )		{hash0_ex2,hash1_ex2,hash2_ex2,hash3_ex2,hash4_ex2,hash5_ex2,hash6_ex2,hash7_ex2,hash8_ex2,hash9_ex2,hash10_ex2,hash11_ex2} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};
	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex3,hash1_ex3,hash2_ex3,hash3_ex3,hash4_ex3,hash5_ex3,hash6_ex3,hash7_ex3,hash8_ex3,hash9_ex3,hash10_ex3,hash11_ex3} <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==3 )			{hash0_ex3,hash1_ex3,hash2_ex3,hash3_ex3,hash4_ex3,hash5_ex3,hash6_ex3,hash7_ex3,hash8_ex3,hash9_ex3,hash10_ex3,hash11_ex3} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};
	always @(`CLK_RST_EDGE)
		if (`ZST)											tweak_ex0 <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==0 )	tweak_ex0 <= tweak1_2_0_i;		
	always @(`CLK_RST_EDGE)
		if (`ZST)											tweak_ex1 <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==1 )	tweak_ex1 <= tweak1_2_0_i;	
	always @(`CLK_RST_EDGE)
		if (`ZST)											tweak_ex2 <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==2 )	tweak_ex2 <= tweak1_2_0_i;		
	always @(`CLK_RST_EDGE)
		if (`ZST)											tweak_ex3 <= 0;
		else if (ready_hash_buf && hash_buf_round[1:0]==3 )	tweak_ex3 <= tweak1_2_0_i;	
`else

	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex0,hash1_ex0,hash2_ex0,hash3_ex0,hash4_ex0,hash5_ex0,hash6_ex0,hash7_ex0,hash8_ex0,hash9_ex0,hash10_ex0,hash11_ex0} <= 0;
		else if (ready_hash_buf & !hash_buf_round[0] )		{hash0_ex0,hash1_ex0,hash2_ex0,hash3_ex0,hash4_ex0,hash5_ex0,hash6_ex0,hash7_ex0,hash8_ex0,hash9_ex0,hash10_ex0,hash11_ex0} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};
	always @(`CLK_RST_EDGE)
		if (`ZST)	{hash0_ex1,hash1_ex1,hash2_ex1,hash3_ex1,hash4_ex1,hash5_ex1,hash6_ex1,hash7_ex1,hash8_ex1,hash9_ex1,hash10_ex1,hash11_ex1} <= 0;
		else if (ready_hash_buf & hash_buf_round[0] )			{hash0_ex1,hash1_ex1,hash2_ex1,hash3_ex1,hash4_ex1,hash5_ex1,hash6_ex1,hash7_ex1,hash8_ex1,hash9_ex1,hash10_ex1,hash11_ex1} <= 
							{hash0,hash1,hash2,hash3,hash4,hash5,hash6,hash7,hash8,hash9,hash10,hash11};


	always @(`CLK_RST_EDGE)
		if (`ZST)										tweak_ex0 <= 0;
		else if (ready_hash_buf & !hash_buf_round[0] )	tweak_ex0 <= tweak1_2_0_i;		
	always @(`CLK_RST_EDGE)
		if (`ZST)										tweak_ex1 <= 0;
		else if (ready_hash_buf & hash_buf_round[0] )	tweak_ex1 <= tweak1_2_0_i;		
`endif		

	
	//==============================
	reg							go_ex0;
	wire						go_ex1, go_ex2, go_ex3;
	wire						ready_ex0, ready_ex1, ready_ex2, ready_ex3;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 			doing_ex <= 0;
		else if (go_ex0)	doing_ex <= 1;
		else if (ready_ex0)	doing_ex <= 0;
`ifdef EX_IMPLODE_INSTANCE_4	
	reg		[`W_IDX-2:0]		round_ex0, round_ex1, round_ex2, round_ex3; 
`else
	reg		[`W_IDX-1:0]		round_ex0, round_ex1, round_ex2, round_ex3; 
`endif		
	reg						go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= 0;
		else			{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= {go_ex0, go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13};
	   
	
//	reg		[`W_IDX:0]			ex_wr_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)		ex_wr_idx <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
		else			ex_wr_idx <= {round_ex0,  2'b0 };
`else
		else			ex_wr_idx <= {round_ex0,  1'b0 };
`endif
		
		   
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex0 <= 0;
		else if (ready_ex0) round_ex0 <= round_ex0 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex1 <= 0;
		else if (ready_ex1) round_ex1 <= round_ex1 + 1;

`ifdef EX_IMPLODE_INSTANCE_4
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex2 <= 0;
	//	else if (go_cn)		round_ex2 <= 0;
		else if (ready_ex2) round_ex2 <= round_ex2 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex3 <= 0;
	//	else if (go_cn)		round_ex3 <= 0;
		else if (ready_ex3) round_ex3 <= round_ex3 + 1;
	
	reg						go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14;
	reg						go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14} <= 0;
		else			{go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14} <= {go_ex1, go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13};
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14} <= 0;
		else			{go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14} <= {go_ex2, go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13};

	assign go_ex2 = go_ex1_d8;	
	assign go_ex3 = go_ex2_d8;	
	always @(*) go_ex0 = ready_hash_buf && hash_buf_round[1:0] == 3;
	always @(*)	explode_ready = (ready_ex0 & (round_ex0 == {`W_IDX-1{1'b1}}) );	
`else
	always @(*) go_ex0 = ready_hash_buf & hash_buf_round[0];
	always @(*)	explode_ready = (ready_ex0 & (round_ex0 == {`W_IDX{1'b1}}) );
`endif
	
	assign go_ex1 = go_ex0_d8;	
	
	
	
	//=============================================================	
	
	wire 		[`W_MEM	:0]		db_scratchpad_ex0;
	wire						cenb_scratchpad_ex0;
	wire		[`W_AMEM:0]		ab_scratchpad_ex0;
	wire 		[`W_MEM	:0]		db_scratchpad_ex1;
	wire						cenb_scratchpad_ex1;
	wire		[`W_AMEM:0]		ab_scratchpad_ex1;
	
	wire					ik0_ready_sub;
	wire	[ 127:0]		ik0;
	wire	[2:0]			ik0_cnt;
	
	wire					ik1_ready_sub;
	wire	[ 127:0]		ik1;
	wire	[2:0]			ik1_cnt;
	
	
	genkeyExplode ex0(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex0),
		.hash0              (hash0_ex0 ),
		.hash1              (hash1_ex0 ),
		.hash2              (hash2_ex0 ),
		.hash3              (hash3_ex0 ),
		.hash4              (hash4_ex0 ),
		.hash5              (hash5_ex0 ),
		.hash6              (hash6_ex0 ),
		.hash7              (hash7_ex0 ),
		.hash8              (hash8_ex0 ),
		.hash9              (hash9_ex0 ),
		.hash10             (hash10_ex0),
		.hash11             (hash11_ex0),

		
		.ik_ready_sub	(ik0_ready_sub	),
		.ik				(ik0				),
		.ik_cnt			(ik0_cnt			),
		
		.ready				(ready_ex0),
		.db_scratchpad_ex	(db_scratchpad_ex0	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex0	),
		.ab_scratchpad_ex	(ab_scratchpad_ex0	)
	);
	
	genkeyExplode ex1(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex1),
		
		.hash0              (hash0_ex1 ),
		.hash1              (hash1_ex1 ),
		.hash2              (hash2_ex1 ),
		.hash3              (hash3_ex1 ),
		.hash4              (hash4_ex1 ),
		.hash5              (hash5_ex1 ),
		.hash6              (hash6_ex1 ),
		.hash7              (hash7_ex1 ),
		.hash8              (hash8_ex1 ),
		.hash9              (hash9_ex1 ),
		.hash10             (hash10_ex1),
		.hash11             (hash11_ex1),

		
		.ik_ready_sub	(ik1_ready_sub	),
		.ik				(ik1				),
		.ik_cnt			(ik1_cnt			),
		
		.ready				(ready_ex1),
		.db_scratchpad_ex	(db_scratchpad_ex1	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex1	),
		.ab_scratchpad_ex	(ab_scratchpad_ex1	)
	);
	
`ifdef 	EX_IMPLODE_INSTANCE_4

	wire 		[`W_MEM	:0]		db_scratchpad_ex2;
	wire						cenb_scratchpad_ex2;
	wire		[`W_AMEM:0]		ab_scratchpad_ex2;
	wire 		[`W_MEM	:0]		db_scratchpad_ex3;
	wire						cenb_scratchpad_ex3;
	wire		[`W_AMEM:0]		ab_scratchpad_ex3;
	
	wire					ik2_ready_sub;
	wire	[ 127:0]		ik2;
	wire	[2:0]			ik2_cnt;
	
	wire					ik3_ready_sub;
	wire	[ 127:0]		ik3;
	wire	[2:0]			ik3_cnt;
	
	
	genkeyExplode ex2(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex2),
		.hash0              (hash0_ex2 ),
		.hash1              (hash1_ex2 ),
		.hash2              (hash2_ex2 ),
		.hash3              (hash3_ex2 ),
		.hash4              (hash4_ex2 ),
		.hash5              (hash5_ex2 ),
		.hash6              (hash6_ex2 ),
		.hash7              (hash7_ex2 ),
		.hash8              (hash8_ex2 ),
		.hash9              (hash9_ex2 ),
		.hash10             (hash10_ex2),
		.hash11             (hash11_ex2),

		
		.ik_ready_sub	(ik2_ready_sub	),
		.ik				(ik2				),
		.ik_cnt			(ik2_cnt			),
		
		.ready				(ready_ex2),
		.db_scratchpad_ex	(db_scratchpad_ex2	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex2	),
		.ab_scratchpad_ex	(ab_scratchpad_ex2	)
	);
	
	genkeyExplode ex3(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex3),
		
		.hash0              (hash0_ex3 ),
		.hash1              (hash1_ex3 ),
		.hash2              (hash2_ex3 ),
		.hash3              (hash3_ex3 ),
		.hash4              (hash4_ex3 ),
		.hash5              (hash5_ex3 ),
		.hash6              (hash6_ex3 ),
		.hash7              (hash7_ex3 ),
		.hash8              (hash8_ex3 ),
		.hash9              (hash9_ex3 ),
		.hash10             (hash10_ex3),
		.hash11             (hash11_ex3),

		
		.ik_ready_sub	(ik3_ready_sub	),
		.ik				(ik3				),
		.ik_cnt			(ik3_cnt			),
		
		.ready				(ready_ex3),
		.db_scratchpad_ex	(db_scratchpad_ex3	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex3	),
		.ab_scratchpad_ex	(ab_scratchpad_ex3	)
	);

`endif

`ifdef 	EX_IMPLODE_INSTANCE_4
	always @(`CLK_RST_EDGE)
		if (`RST) 	cenb_scratchpad_ex <= 1;
		else 		cenb_scratchpad_ex <= cenb_scratchpad_ex0 & cenb_scratchpad_ex1 & cenb_scratchpad_ex2 & cenb_scratchpad_ex3;

	always @(`CLK_RST_EDGE)
		if (`RST) 					db_scratchpad_ex <= 0;
		else if (!cenb_scratchpad_ex0)		
			db_scratchpad_ex <= db_scratchpad_ex0;
		else if (!cenb_scratchpad_ex1)		
			db_scratchpad_ex <= db_scratchpad_ex1;
		else if (!cenb_scratchpad_ex2)		
			db_scratchpad_ex <= db_scratchpad_ex2;
		else if (!cenb_scratchpad_ex3)		
			db_scratchpad_ex <= db_scratchpad_ex3;		
			

	always @(`CLK_RST_EDGE)
		if (`RST) 					ab_scratchpad_ex <= 0;
		else if (!cenb_scratchpad_ex0)		
			//ab_scratchpad_ex <= {round_ex0, 1'h0, ab_scratchpad_ex0};
			ab_scratchpad_ex <= {1'h0, ab_scratchpad_ex0[2:0]};
		else if (!cenb_scratchpad_ex1)	
			//ab_scratchpad_ex <= {round_ex1, 1'h1, ab_scratchpad_ex1};
			ab_scratchpad_ex <= {1'h1, ab_scratchpad_ex1[2:0]};
		else if (!cenb_scratchpad_ex2)	
			ab_scratchpad_ex <= {2'h2, ab_scratchpad_ex2[2:0]};	
		else if (!cenb_scratchpad_ex3)	
			ab_scratchpad_ex <= {2'h3, ab_scratchpad_ex3[2:0]};
`else
	always @(`CLK_RST_EDGE)
		if (`RST) 	cenb_scratchpad_ex <= 1;
		else 		cenb_scratchpad_ex <= cenb_scratchpad_ex0 & cenb_scratchpad_ex1;
		
	always @(`CLK_RST_EDGE)
		if (`RST) 					db_scratchpad_ex <= 0;
		else if (!cenb_scratchpad_ex0)		
			db_scratchpad_ex <= db_scratchpad_ex0;
		else if (!cenb_scratchpad_ex1)		
			db_scratchpad_ex <= db_scratchpad_ex1;

	always @(`CLK_RST_EDGE)
		if (`RST) 					ab_scratchpad_ex <= 0;
		else if (!cenb_scratchpad_ex0)		
			//ab_scratchpad_ex <= {round_ex0, 1'h0, ab_scratchpad_ex0};
			ab_scratchpad_ex <= {1'h0, ab_scratchpad_ex0[2:0]};
		else if (!cenb_scratchpad_ex1)	
			//ab_scratchpad_ex <= {round_ex1, 1'h1, ab_scratchpad_ex1};
			ab_scratchpad_ex <= {1'h1, ab_scratchpad_ex1[2:0]};
`endif			
	reg		cenb_scratchpad_ex0_d1;
	always @(`CLK_RST_EDGE)
		if (`RST) 	cenb_scratchpad_ex0_d1 <= 1;
		else 		cenb_scratchpad_ex0_d1 <= cenb_scratchpad_ex0;
	
	assign	go_write_ex = !cenb_scratchpad_ex0& cenb_scratchpad_ex0_d1;

	//===============================================================
	
	reg						ik1_ready_sub_d1;
	reg		[ 127:0]		ik1_d1;
	reg		[2:0]			ik1_cnt_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ik1_ready_sub_d1, ik1_d1, ik1_cnt_d1} <= 0;
		else		{ik1_ready_sub_d1, ik1_d1, ik1_cnt_d1} <= {ik1_ready_sub, ik1, ik1_cnt};

`ifdef EX_IMPLODE_INSTANCE_4
	
	reg						ik2_ready_sub_d1, ik2_ready_sub_d2 ;
	reg		[ 127:0]		ik2_d1, ik2_d2;
	reg		[2:0]			ik2_cnt_d1, ik2_cnt_d2;
	
	reg						ik3_ready_sub_d1, ik3_ready_sub_d2, ik3_ready_sub_d3 ;
	reg		[ 127:0]		ik3_d1, ik3_d2, ik3_d3;
	reg		[2:0]			ik3_cnt_d1, ik3_cnt_d2, ik3_cnt_d3;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	{ik2_ready_sub_d1, ik2_d1, ik2_cnt_d1} <= 0;
		else		{ik2_ready_sub_d1, ik2_d1, ik2_cnt_d1} <= {ik2_ready_sub, ik2, ik2_cnt};
	always @(`CLK_RST_EDGE)
		if (`RST)	{ik3_ready_sub_d1, ik3_d1, ik3_cnt_d1} <= 0;
		else		{ik3_ready_sub_d1, ik3_d1, ik3_cnt_d1} <= {ik3_ready_sub, ik3, ik3_cnt};
	always @(`CLK_RST_EDGE)
		if (`RST)	{ik2_ready_sub_d2, ik2_d2, ik2_cnt_d2} <= 0;
		else		{ik2_ready_sub_d2, ik2_d2, ik2_cnt_d2} <= {ik2_ready_sub_d1, ik2_d1, ik2_cnt_d1};
	always @(`CLK_RST_EDGE)
		if (`RST)	{ik3_ready_sub_d2, ik3_d2, ik3_cnt_d2} <= 0;
		else		{ik3_ready_sub_d2, ik3_d2, ik3_cnt_d2} <= {ik3_ready_sub_d1, ik3_d1, ik3_cnt_d1};

	always @(`CLK_RST_EDGE)
		if (`RST)	{ik3_ready_sub_d3, ik3_d3, ik3_cnt_d3} <= 0;
		else		{ik3_ready_sub_d3, ik3_d3, ik3_cnt_d3} <= {ik3_ready_sub_d2, ik3_d2, ik3_cnt_d2};

	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_ik_buf <= 1;
		else 			cenb_ik_buf <= ~(ik0_ready_sub|ik1_ready_sub_d1|ik2_ready_sub_d2|ik3_ready_sub_d3);
	
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_ik_buf <= 0;
		else if (ik0_ready_sub) 	ab_ik_buf <= ik0_cnt;
		else if (ik1_ready_sub_d1) 	ab_ik_buf <= ik1_cnt_d1 + 8;
		else if (ik2_ready_sub_d2) 	ab_ik_buf <= ik2_cnt_d2 + 16;
		else if (ik3_ready_sub_d3) 	ab_ik_buf <= ik3_cnt_d3 + 24;
	always @(`CLK_RST_EDGE)
		if (`RST)					db_ik_buf <= 0;
		else if (ik0_ready_sub) 	db_ik_buf <= ik0;
		else if (ik1_ready_sub_d1) 	db_ik_buf <= ik1_d1;
		else if (ik2_ready_sub_d2) 	db_ik_buf <= ik2_d2;
		else if (ik3_ready_sub_d3) 	db_ik_buf <= ik3_d3;
		
	always @(`CLK_RST_EDGE)
		if (`RST)				ik_buf_wid <= 0;
		else if (ready_ex0)		ik_buf_wid <= ik_buf_wid + 1;

`else
	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_ik_buf <= 1;
		else 			cenb_ik_buf <= ~(ik0_ready_sub|ik1_ready_sub_d1);
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_ik_buf <= 0;
		else if (ik0_ready_sub) 	ab_ik_buf <= ik0_cnt;
		else if (ik1_ready_sub_d1) 	ab_ik_buf <= ik1_cnt_d1 + 8;
	always @(`CLK_RST_EDGE)
		if (`RST)					db_ik_buf <= 0;
		else if (ik0_ready_sub) 	db_ik_buf <= ik0;
		else if (ik1_ready_sub_d1) 	db_ik_buf <= ik1_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)				ik_buf_wid <= 0;
		else if (ready_ex0)		ik_buf_wid <= ik_buf_wid + 1;
`endif
	//===================================================================

	
	
	

`ifdef EX_IMPLODE_INSTANCE_4
	always @(`CLK_RST_EDGE)
		if (`RST)	init_ab_f <= 0;
		else		init_ab_f <= go_ex0 | go_ex1 | go_ex2 | go_ex3 ;
	always @(`CLK_RST_EDGE)
		if (`RST)			{init_a, init_b } <= 0;
		else if (go_ex0)	{init_a, init_b } <= {hash0_ex0^hash2_ex0, hash1_ex0^hash3_ex0};
		else if (go_ex1)	{init_a, init_b } <= {hash0_ex1^hash2_ex1, hash1_ex1^hash3_ex1};
		else if (go_ex2)	{init_a, init_b } <= {hash0_ex2^hash2_ex2, hash1_ex2^hash3_ex2};
		else if (go_ex3)	{init_a, init_b } <= {hash0_ex3^hash2_ex3, hash1_ex3^hash3_ex3};

	always @(`CLK_RST_EDGE)
		if (`RST)			init_ab_idx <= 0;
		else if (go_ex0)	init_ab_idx <= {round_ex0, 2'h0};
	    else if (go_ex1)    init_ab_idx <= {round_ex1, 2'h1};
		else if (go_ex2)	init_ab_idx <= {round_ex2, 2'h2};
	    else if (go_ex3)    init_ab_idx <= {round_ex3, 2'h3};
		
	always @(`CLK_RST_EDGE)
		if (`RST)			init_tweak <= 0;
		else if (go_ex0)	init_tweak <= tweak_ex0;				
		else if (go_ex1)	init_tweak <= tweak_ex1;
		else if (go_ex2)	init_tweak <= tweak_ex2;				
		else if (go_ex3)	init_tweak <= tweak_ex3;
		
`else
	always @(`CLK_RST_EDGE)
		if (`RST)	init_ab_f <= 0;
		else		init_ab_f <= go_ex0 | go_ex1;
	always @(`CLK_RST_EDGE)
		if (`RST)			{init_a, init_b } <= 0;
//		else if (go_ex0)	{init_a, init_b } <= {hash_idx[round_ex0*2 + 0][0]^hash_idx[round_ex0*2 + 0][2], hash_idx[round_ex0*2 + 0][1]^hash_idx[round_ex0*2 + 0][3]};
//		else if (go_ex1)	{init_a, init_b } <= {hash_idx[round_ex1*2 + 1][0]^hash_idx[round_ex1*2 + 1][2], hash_idx[round_ex1*2 + 1][1]^hash_idx[round_ex1*2 + 1][3]};
		else if (go_ex0)	{init_a, init_b } <= {hash0_ex0^hash2_ex0, hash1_ex0^hash3_ex0};
		else if (go_ex1)	{init_a, init_b } <= {hash0_ex1^hash2_ex1, hash1_ex1^hash3_ex1};

	always @(`CLK_RST_EDGE)
		if (`RST)			init_ab_idx <= 0;
		else if (go_ex0)	init_ab_idx <= {round_ex0, 1'h0};
	    else if (go_ex1)    init_ab_idx <= {round_ex1, 1'h1};
		
	always @(`CLK_RST_EDGE)
		if (`RST)			init_tweak <= 0;
		else if (go_ex0)	init_tweak <= tweak_ex0;				
		else if (go_ex1)	init_tweak <= tweak_ex1;	


`endif

endmodule



module implode_2p(
	input						clk , 		
	input						rstn,
	
	input		[1:0]		im_buf_cached,
	output					im_datahub_req,
		
	output	reg	[`W_MAIN:0]		im_cur_main,
	output  reg [`W_IDX:0] 		idx_im0,
	output					go_round_im0,
	
	
	input 					main_ready,
`ifdef WITH_TWO_MAIN	
	input 					main1_ready,
`endif
`ifdef WITH_FOUR_MAIN	
	input 					main2_ready,
	input 					main3_ready,
`endif
`ifdef WITH_SIX_MAIN	
	input 					main4_ready,
	input 					main5_ready,
`endif

	output reg					ready_hash_buf2,		
	output reg					cena_hash_buf2,   // for implode
	output reg	[3:0]			aa_hash_buf2,
	input		[127:0]			qa_hash_buf2,	

	
	output reg	[`W_AIKBUF:0]	aa_ik_buf,
	output reg					cena_ik_buf,
	input		[ 127:0]		qa_ik_buf,
	output reg	[`W_IDX+2:0]	ik_buf_rid,
	
	
	output reg					cena_im_buf,
	input		[`W_MEM:0]		qa_im_buf,
	output reg	[`W_IDX+3:0]	aa_im_buf,
	
	
	
	output	reg					ready_im0,
	output 		[127:0]	        xout0_im0,
	output 		[127:0]	        xout1_im0,	
	output 		[127:0]	        xout2_im0,	
	output 		[127:0]	        xout3_im0,	
	output 		[127:0]	        xout4_im0,	
	output 		[127:0]	        xout5_im0,	
	output 		[127:0]	        xout6_im0,	
	output 		[127:0]	        xout7_im0,	
	
	output						ready_im1,
	output	 	[127:0]	        xout0_im1,
	output	 	[127:0]	        xout1_im1,	
	output	 	[127:0]	        xout2_im1,	
	output	 	[127:0]	        xout3_im1,	
	output	 	[127:0]	        xout4_im1,	
	output	 	[127:0]	        xout5_im1,	
	output	 	[127:0]	        xout6_im1,	
	output	 	[127:0]	        xout7_im1,

`ifdef EX_IMPLODE_INSTANCE_4
	output						ready_im2,
	output 		[127:0]	        xout0_im2,
	output 		[127:0]	        xout1_im2,	
	output 		[127:0]	        xout2_im2,	
	output 		[127:0]	        xout3_im2,	
	output 		[127:0]	        xout4_im2,	
	output 		[127:0]	        xout5_im2,	
	output 		[127:0]	        xout6_im2,	
	output 		[127:0]	        xout7_im2,	
	
	output						ready_im3,
	output	 	[127:0]	        xout0_im3,
	output	 	[127:0]	        xout1_im3,	
	output	 	[127:0]	        xout2_im3,	
	output	 	[127:0]	        xout3_im3,	
	output	 	[127:0]	        xout4_im3,	
	output	 	[127:0]	        xout5_im3,	
	output	 	[127:0]	        xout6_im3,	
	output	 	[127:0]	        xout7_im3,
	
`endif
	output reg	[127:0]			db_xout_buf,
	output reg	[ 3:0]			ab_xout_buf,
	output reg					cenb_xout_buf,
	output reg					ready_cn


	);
	

		
		
	reg		[ 127:0] 	im0_k0, im0_k1, im0_k2, im0_k3, im0_k4, im0_k5, im0_k6, im0_k7, im0_k8, im0_k9;
	reg		[ 127:0] 	im1_k0, im1_k1, im1_k2, im1_k3, im1_k4, im1_k5, im1_k6, im1_k7, im1_k8, im1_k9;

	
	reg 	[127:0]	        blk0_im0,blk1_im0,blk2_im0,blk3_im0,blk4_im0,blk5_im0,blk6_im0,blk7_im0;
	reg 	[127:0]	        blk0_im1,blk1_im1,blk2_im1,blk3_im1,blk4_im1,blk5_im1,blk6_im1,blk7_im1;
`ifdef EX_IMPLODE_INSTANCE_4

	reg		[ 127:0] 	im2_k0, im2_k1, im2_k2, im2_k3, im2_k4, im2_k5, im2_k6, im2_k7, im2_k8, im2_k9;
	reg		[ 127:0] 	im3_k0, im3_k1, im3_k2, im3_k3, im3_k4, im3_k5, im3_k6, im3_k7, im3_k8, im3_k9;
	
	reg 	[127:0]	        blk0_im2,blk1_im2,blk2_im2,blk3_im2,blk4_im2,blk5_im2,blk6_im2,blk7_im2;
	reg 	[127:0]	        blk0_im3,blk1_im3,blk2_im3,blk3_im3,blk4_im3,blk5_im3,blk6_im3,blk7_im3;

`endif

	//wire		main_ready;
	reg			go_im0;
	wire		ready_for_next_im0;
	reg			doing_im_round; 
	reg			doing_im;
//	reg		[`W_IDX:0] 			idx_im0;	
//	reg							ready_im0;	
	wire						ready_round_im0;
`ifdef 	SIMULATION_LESS_IMPLODE_CYCLES
	parameter IM_ROUND_MAX = (`MEM/16)/8/32 -1;
`else
	parameter IM_ROUND_MAX = (`MEM/16)/8 -1;
`endif

	reg		[15:0]	im_round;
	wire 	im_round_maxminus1_f = im_round == IM_ROUND_MAX-1;  // = 2^(21-4) = 128K*10 = 1M多
	wire 	im_round_max_f = im_round == IM_ROUND_MAX;  // = 2^(21-4) = 128K*10 = 1M多
	reg					im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14} <= 0;
		else			{im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14} <= {im_round_max_f, im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13};

//	reg		[1:0]	im_buf_cached;
	
	reg		go_im;
	reg		doing_im_all;
	always @(`CLK_RST_EDGE)
		if (`RST)			doing_im_all <= 0;
		else if (go_im)		doing_im_all <= 1;
		else if (ready_cn)	doing_im_all <= 0;

		
`ifdef WITH_TWO_MAIN	
//	wire	main1_ready;
	reg		main_done, main1_done; 
	reg		go_im_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_im_d1 <= 0;
		else 		go_im_d1 <= go_im;
	always @(`CLK_RST_EDGE)
		if (`RST)							main_done <= 0;
		else if (main_ready)				main_done <= 1;
		else if (go_im_d1&(im_cur_main==0))	main_done <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)							main1_done <= 0;
		else if (main1_ready)				main1_done <= 1;
		else if (go_im_d1&(im_cur_main==1))	main1_done <= 0;
	
	`ifdef WITH_FOUR_MAIN
		reg	main2_done;
		always @(`CLK_RST_EDGE)
			if (`RST)							main2_done <= 0;
			else if (main2_ready)				main2_done <= 1;
			else if (go_im_d1&(im_cur_main==2))	main2_done <= 0;
		reg	main3_done;
		always @(`CLK_RST_EDGE)
			if (`RST)							main3_done <= 0;
			else if (main3_ready)				main3_done <= 1;
			else if (go_im_d1&(im_cur_main==3))	main3_done <= 0;
		
		`ifdef WITH_SIX_MAIN
			reg	main4_done;
			always @(`CLK_RST_EDGE)
				if (`RST)							main4_done <= 0;
				else if (main4_ready)				main4_done <= 1;
				else if (go_im_d1&(im_cur_main==4))	main4_done <= 0;
			reg	main5_done;
			always @(`CLK_RST_EDGE)
				if (`RST)							main5_done <= 0;
				else if (main5_ready)				main5_done <= 1;
				else if (go_im_d1&(im_cur_main==5))	main5_done <= 0;
		
			always @(*)	go_im = ( main_done | main1_done | main2_done | main3_done| main4_done | main5_done ) & !doing_im_all;
			always @(`CLK_RST_EDGE)
				if (`RST)	im_cur_main <= 0;
				else if (go_im)
					if (main_done)
						im_cur_main <= 0;
					else if (main1_done)
						im_cur_main <= 1;
					else if (main2_done)
						im_cur_main <= 2;				
					else if (main3_done)
						im_cur_main <= 3;		
					else if (main4_done)
						im_cur_main <= 4;				
					else if (main5_done)
						im_cur_main <= 5;		
		`else
			always @(*)	go_im = ( main_done | main1_done | main2_done | main3_done ) & !doing_im_all;
			always @(`CLK_RST_EDGE)
				if (`RST)	im_cur_main <= 0;
				else if (go_im)
					if (main_done)
						im_cur_main <= 0;
					else if (main1_done)
						im_cur_main <= 1;
					else if (main2_done)
						im_cur_main <= 2;				
					else if (main3_done)
						im_cur_main <= 3;
		`endif
	`else
	always @(*)	go_im = ( main_done | main1_done ) & !doing_im_all;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	im_cur_main <= 0;
		else if (go_im)
			if (main_done)
				im_cur_main <= 0;
			else if (main1_done)
				im_cur_main <= 1;
	`endif
`else
	always @(*)	go_im = main_ready;
`endif	
	
	assign go_round_im0 = !doing_im_round & doing_im & (im_buf_cached!=0);
	
//	always @(`CLK_RST_EDGE)
//		if (`RST)	im_buf_cached <= 0;
//`ifdef WITH_TWO_MAIN
//		else case({go_round_im0, w_im_buf_ready|w_im_buf_main1_ready})
//`else
//		else case({go_round_im0, w_im_buf_ready})
//`endif
//			2'b10: im_buf_cached <= im_buf_cached - 1;
//			2'b01: im_buf_cached <= im_buf_cached + 1;
//			endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)	go_im0 <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
	//	else		go_im0 <= go_im | ( ready_im0 & (idx_im0==0) ) ;
		else		go_im0 <= go_im | ( ready_im0 & (idx_im0!={{`W_IDX-1{1'b1}}, 2'b0}) ) ;
`else
		else		go_im0 <= go_im | ( ready_im0 & (idx_im0!={{`W_IDX{1'b1}}, 1'b0}) ) ;
`endif
	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready_im0 <= 0;
		else		ready_im0 <= im_round_max_f_d14 &  ready_round_im0 ;
	
	always @(`CLK_RST_EDGE)
		if (`RST)						doing_im_round <= 0;
		else if (go_round_im0)			doing_im_round <= 1;
		else if (ready_for_next_im0)	doing_im_round <= 0;
	

	always @(`CLK_RST_EDGE)
		if (`RST)						im_round <= 0;
		else if (go_im0)				im_round <= 0;
		else if (ready_for_next_im0)	im_round <= im_round_max_f? 0 : im_round + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)										doing_im <= 0;
		else if (go_im0)								doing_im <= 1;
		else if (ready_for_next_im0 & im_round_max_f)	doing_im <= 0;
	
	reg					go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14} <= 0;
		else			{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14} <= {go_im0, go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13};
	assign	 im_datahub_req = go_im0 | go_im0_d6 | (go_round_im0 & !im_round_max_f & !im_round_maxminus1_f);
		
	always @(`CLK_RST_EDGE)
		if (`RST)					 	 idx_im0 <= 0;
`ifdef 	EX_IMPLODE_INSTANCE_4
		else if (ready_im0) 			idx_im0 <= idx_im0 + 4;
`else
		else if (ready_im0) 			idx_im0 <= idx_im0 + 2;
`endif	

	always @(`CLK_RST_EDGE)
		if (`RST)	ready_cn <= 0;
`ifdef 	EX_IMPLODE_INSTANCE_4
		else 		ready_cn <= ready_im0 && (idx_im0==`TASKN - 4);		
`else
		else 		ready_cn <= ready_im0 && (idx_im0==`TASKN - 2);	
`endif

`ifdef WITH_TWO_MAIN
	assign		ready_cn0 = ready_cn & (im_cur_main==0);
	assign		ready_cn1 = ready_cn & (im_cur_main==1);
	`ifdef WITH_FOUR_MAIN
	assign		ready_cn2 = ready_cn & (im_cur_main==2);
	assign		ready_cn3 = ready_cn & (im_cur_main==3);	
	`endif
	`ifdef WITH_SIX_MAIN
	assign		ready_cn4 = ready_cn & (im_cur_main==4);
	assign		ready_cn5 = ready_cn & (im_cur_main==5);	
	`endif
`else
	wire		ready_cn0 = ready_cn;
	
`endif

	always @(`CLK_RST_EDGE)
		if (`RST)						cena_im_buf <= 1;
		else if (go_round_im0)			cena_im_buf <= 0;
`ifdef 	EX_IMPLODE_INSTANCE_4
		else if (aa_im_buf[4:0]==5'h1F)	cena_im_buf <= 1;
`else
		else if (aa_im_buf[3:0]==4'hF)	cena_im_buf <= 1;
`endif
	always @(`CLK_RST_EDGE)
		if (`RST)				aa_im_buf <= 0;
		else if (!cena_im_buf)	aa_im_buf <= aa_im_buf + 1;	

		
	//==============
	
//	reg		ready_hash_buf2_b1, ready_hash_buf2;
	reg		ready_hash_buf2_im0_b1, ready_hash_buf2_im0;
	reg		ready_hash_buf2_im1_b1, ready_hash_buf2_im1;
	reg		cena_hash_buf2_d1;
`ifdef EX_IMPLODE_INSTANCE_4	
	reg		[1:0]	hash_buf2_round; 
`else
	reg		hash_buf2_round; 
`endif
	always @(`CLK_RST_EDGE)
		if (`RST) 							hash_buf2_round <= 0;
		else if (go_im0)					hash_buf2_round <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
		else if (aa_hash_buf2==12)			hash_buf2_round <= hash_buf2_round + 1;
`else
		else if (ready_hash_buf2_im0_b1)	hash_buf2_round <= 1;
`endif
	
	always @(`CLK_RST_EDGE)
		if (`RST) 						cena_hash_buf2 <= 1;
		else if (go_im0)				cena_hash_buf2 <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
		else if (aa_hash_buf2==12 &&  hash_buf2_round==3)		cena_hash_buf2 <= 1;
`else
		else if (aa_hash_buf2==12 &&  hash_buf2_round)		cena_hash_buf2 <= 1;
`endif
		
	always @(`CLK_RST_EDGE)
		if (`RST) 					aa_hash_buf2 <= 0;
		else if (!cena_hash_buf2)	aa_hash_buf2 <=  aa_hash_buf2==12? 0 : aa_hash_buf2 + 1;
		else 						aa_hash_buf2 <= 0;
	always @(*)	ready_hash_buf2 = !cena_hash_buf2 && aa_hash_buf2==12;
		
		
		
	always @(`CLK_RST_EDGE)
		if (`RST)		ready_hash_buf2_im0_b1 <= 0;
		else			ready_hash_buf2_im0_b1 <= !cena_hash_buf2 && aa_hash_buf2==12 && hash_buf2_round==0;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im0 <= 0;
		else				ready_hash_buf2_im0 <= ready_hash_buf2_im0_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)		ready_hash_buf2_im1_b1 <= 0;
		else			ready_hash_buf2_im1_b1 <= !cena_hash_buf2 && aa_hash_buf2==12 && hash_buf2_round==1;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im1 <= 0;
		else				ready_hash_buf2_im1 <= ready_hash_buf2_im1_b1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_hash_buf2_d1 <= 1;
		else		cena_hash_buf2_d1 <= cena_hash_buf2;
		
	reg		[13*128-1:0]		rx_buf2;	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)						rx_buf2 <= 0;
		else if (!cena_hash_buf2_d1)	rx_buf2 <= {rx_buf2, qa_hash_buf2};	
		
	reg		[127:0]			hash0_buf2,hash1_buf2,hash2_buf2,hash3_buf2,hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2 ; 						
	reg		[ 63:0]			tweak_buf2;	
	
	always @(*) 
		{hash0_buf2,hash1_buf2,hash2_buf2,hash3_buf2,hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2,tweak_buf2}
				= rx_buf2[ 13*128-1 :64];

	always @(`CLK_RST_EDGE)
		if (`ZST)						{ blk0_im0,blk1_im0,blk2_im0,blk3_im0,blk4_im0,blk5_im0,blk6_im0,blk7_im0} <= 0;
		else if (ready_hash_buf2_im0)	{ blk0_im0,blk1_im0,blk2_im0,blk3_im0,blk4_im0,blk5_im0,blk6_im0,blk7_im0} <= {hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2};
	always @(`CLK_RST_EDGE)
		if (`ZST)						{ blk0_im1,blk1_im1,blk2_im1,blk3_im1,blk4_im1,blk5_im1,blk6_im1,blk7_im1} <= 0;
		else if (ready_hash_buf2_im1)	{ blk0_im1,blk1_im1,blk2_im1,blk3_im1,blk4_im1,blk5_im1,blk6_im1,blk7_im1} <= {hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2};

	always @(`CLK_RST_EDGE)
		if (`ZST)						{ im0_k0,im0_k1} <= 0;
		else if (ready_hash_buf2_im0)	{ im0_k0,im0_k1} <= {hash2_buf2,hash3_buf2};
	always @(`CLK_RST_EDGE)
		if (`ZST)						{ im1_k0,im1_k1} <= 0;
		else if (ready_hash_buf2_im1)	{ im1_k0,im1_k1} <= {hash2_buf2,hash3_buf2};
		
		
`ifdef EX_IMPLODE_INSTANCE_4
	reg		ready_hash_buf2_im2_b1, ready_hash_buf2_im2;
	reg		ready_hash_buf2_im3_b1, ready_hash_buf2_im3;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im2_b1 <= 0;
		else				ready_hash_buf2_im2_b1 <= !cena_hash_buf2 && aa_hash_buf2==12 && hash_buf2_round==2;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im2 <= 0;
		else				ready_hash_buf2_im2 <= ready_hash_buf2_im2_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im3_b1 <= 0;
		else				ready_hash_buf2_im3_b1 <= !cena_hash_buf2 && aa_hash_buf2==12 && hash_buf2_round==3;
	always @(`CLK_RST_EDGE)
		if (`RST)			ready_hash_buf2_im3 <= 0;
		else				ready_hash_buf2_im3 <= ready_hash_buf2_im3_b1;
	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)						{ blk0_im2,blk1_im2,blk2_im2,blk3_im2,blk4_im2,blk5_im2,blk6_im2,blk7_im2} <= 0;
		else if (ready_hash_buf2_im2)	{ blk0_im2,blk1_im2,blk2_im2,blk3_im2,blk4_im2,blk5_im2,blk6_im2,blk7_im2} <= {hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2};
	always @(`CLK_RST_EDGE)
		if (`ZST)						{ blk0_im3,blk1_im3,blk2_im3,blk3_im3,blk4_im3,blk5_im3,blk6_im3,blk7_im3} <= 0;
		else if (ready_hash_buf2_im3)	{ blk0_im3,blk1_im3,blk2_im3,blk3_im3,blk4_im3,blk5_im3,blk6_im3,blk7_im3} <= {hash4_buf2,hash5_buf2,hash6_buf2,hash7_buf2,hash8_buf2,hash9_buf2,hash10_buf2,hash11_buf2};

	always @(`CLK_RST_EDGE)
		if (`ZST)						{ im2_k0,im2_k1} <= 0;
		else if (ready_hash_buf2_im2)	{ im2_k0,im2_k1} <= {hash2_buf2,hash3_buf2};
	always @(`CLK_RST_EDGE)
		if (`ZST)						{ im3_k0,im3_k1} <= 0;
		else if (ready_hash_buf2_im3)	{ im3_k0,im3_k1} <= {hash2_buf2,hash3_buf2};
`endif
		
	
	//==============	
	
	reg			ready_ik_buf_im0_b1, ready_ik_buf_im0;
	reg			ready_ik_buf_im1_b1, ready_ik_buf_im1;
	reg			cena_ik_buf_d1;
	reg			ready_ik_buf;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 						cena_ik_buf <= 1;
		else if (go_im0)				cena_ik_buf <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
		else if (aa_ik_buf==31)			cena_ik_buf <= 1;
`else
		else if (aa_ik_buf==15)			cena_ik_buf <= 1;
`endif
	always @(`CLK_RST_EDGE)
		if (`RST) 						aa_ik_buf <= 0;
		else if (!cena_ik_buf)			aa_ik_buf <=  aa_ik_buf + 1;
		else 							aa_ik_buf <= 0;	
`ifdef EX_IMPLODE_INSTANCE_4		
	always @(*)	ready_ik_buf = !cena_ik_buf && aa_ik_buf==31;
`else
	always @(*)	ready_ik_buf = !cena_ik_buf && aa_ik_buf==15;
`endif
	always @(`CLK_RST_EDGE)
		if (`RST)				ik_buf_rid <= 0;
		else if (ready_ik_buf)  ik_buf_rid <= ik_buf_rid + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im0_b1 <= 0;
		else					ready_ik_buf_im0_b1 <= !cena_ik_buf && aa_ik_buf==7;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im0 <= 0;
		else					ready_ik_buf_im0 <= ready_ik_buf_im0_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im1_b1 <= 0;
		else					ready_ik_buf_im1_b1 <= !cena_ik_buf && aa_ik_buf==15;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im1 <= 0;
		else					ready_ik_buf_im1 <= ready_ik_buf_im1_b1;
			
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_ik_buf_d1 <= 1;
		else		cena_ik_buf_d1 <= cena_ik_buf;		
	
	reg		[8*128-1:0]		rx_ik;	
	always @(`CLK_RST_EDGE)
		if (`ZST)					rx_ik <= 0;
		else if (!cena_ik_buf_d1)	rx_ik <= {rx_ik, qa_ik_buf};	
	always @(`CLK_RST_EDGE)
		if (`ZST)						{im0_k2, im0_k3, im0_k4, im0_k5, im0_k6, im0_k7, im0_k8, im0_k9} <= 0;
		else if (ready_ik_buf_im0)		{im0_k2, im0_k3, im0_k4, im0_k5, im0_k6, im0_k7, im0_k8, im0_k9} <= rx_ik;	
	always @(`CLK_RST_EDGE)
		if (`ZST)						{im1_k2, im1_k3, im1_k4, im1_k5, im1_k6, im1_k7, im1_k8, im1_k9} <= 0;
		else if (ready_ik_buf_im1)		{im1_k2, im1_k3, im1_k4, im1_k5, im1_k6, im1_k7, im1_k8, im1_k9} <= rx_ik;

`ifdef EX_IMPLODE_INSTANCE_4
	reg			ready_ik_buf_im2_b1, ready_ik_buf_im2;
	reg			ready_ik_buf_im3_b1, ready_ik_buf_im3;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im2_b1 <= 0;
		else					ready_ik_buf_im2_b1 <= !cena_ik_buf && aa_ik_buf==23;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im2 <= 0;
		else					ready_ik_buf_im2 <= ready_ik_buf_im2_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im3_b1 <= 0;
		else					ready_ik_buf_im3_b1 <= !cena_ik_buf && aa_ik_buf==31;
	always @(`CLK_RST_EDGE)
		if (`RST)				ready_ik_buf_im3 <= 0;
		else					ready_ik_buf_im3 <= ready_ik_buf_im3_b1;
			
	always @(`CLK_RST_EDGE)
		if (`ZST)						{im2_k2, im2_k3, im2_k4, im2_k5, im2_k6, im2_k7, im2_k8, im2_k9} <= 0;
		else if (ready_ik_buf_im2)		{im2_k2, im2_k3, im2_k4, im2_k5, im2_k6, im2_k7, im2_k8, im2_k9} <= rx_ik;	
	always @(`CLK_RST_EDGE)
		if (`ZST)						{im3_k2, im3_k3, im3_k4, im3_k5, im3_k6, im3_k7, im3_k8, im3_k9} <= 0;
		else if (ready_ik_buf_im3)		{im3_k2, im3_k3, im3_k4, im3_k5, im3_k6, im3_k7, im3_k8, im3_k9} <= rx_ik;

`endif		
		
//=============================================================================================================		
	
	wire	[127:0]			db_xout_buf_im0;
	wire	[ 2:0]			ab_xout_buf_im0;
	wire					cenb_xout_buf_im0;
	wire	[127:0]			db_xout_buf_im1;
	wire	[ 2:0]			ab_xout_buf_im1;
	wire					cenb_xout_buf_im1;

`ifdef EX_IMPLODE_INSTANCE_4
	wire	[127:0]			db_xout_buf_im2;
	wire	[ 2:0]			ab_xout_buf_im2;
	wire					cenb_xout_buf_im2;
	wire	[127:0]			db_xout_buf_im3;
	wire	[ 2:0]			ab_xout_buf_im3;
	wire					cenb_xout_buf_im3;
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_xout_buf <= 1;
		else		cenb_xout_buf <= cenb_xout_buf_im0 & cenb_xout_buf_im1 & cenb_xout_buf_im2 & cenb_xout_buf_im3;
	always @(`CLK_RST_EDGE)
		if (`RST)						ab_xout_buf <= 0;
		else if (!cenb_xout_buf_im0) 	ab_xout_buf <= ab_xout_buf_im0;
		else if (!cenb_xout_buf_im1) 	ab_xout_buf <= ab_xout_buf_im1 + 8;
		else if (!cenb_xout_buf_im2) 	ab_xout_buf <= ab_xout_buf_im2 + 16;
		else if (!cenb_xout_buf_im3) 	ab_xout_buf <= ab_xout_buf_im3 + 24;
		
	always @(`CLK_RST_EDGE)
		if (`RST)						db_xout_buf <= 0;
		else if (!cenb_xout_buf_im0) 	db_xout_buf <= db_xout_buf_im0;
		else if (!cenb_xout_buf_im1) 	db_xout_buf <= db_xout_buf_im1;	
		else if (!cenb_xout_buf_im2) 	db_xout_buf <= db_xout_buf_im2;
		else if (!cenb_xout_buf_im3) 	db_xout_buf <= db_xout_buf_im3;
`else
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_xout_buf <= 1;
		else		cenb_xout_buf <= cenb_xout_buf_im0 & cenb_xout_buf_im1;
	always @(`CLK_RST_EDGE)
		if (`RST)						ab_xout_buf <= 0;
		else if (!cenb_xout_buf_im0) 	ab_xout_buf <= ab_xout_buf_im0;
		else if (!cenb_xout_buf_im1) 	ab_xout_buf <= ab_xout_buf_im1 + 8;
	always @(`CLK_RST_EDGE)
		if (`RST)						db_xout_buf <= 0;
		else if (!cenb_xout_buf_im0) 	db_xout_buf <= db_xout_buf_im0;
		else if (!cenb_xout_buf_im1) 	db_xout_buf <= db_xout_buf_im1;
`endif
		
	cn_implode im0(
		.clk 			(clk), 		
		.rstn			(rstn),
		//.init_f			(go_im0),
		.init_f			(ready_hash_buf2_im0),
		.go				(go_round_im0),
		
		.k0             (im0_k0),
		.k1             (im0_k1),
		.k2             (im0_k2),
		.k3             (im0_k3),
		.k4             (im0_k4),
		.k5             (im0_k5),
		.k6             (im0_k6),
		.k7             (im0_k7),
		.k8             (im0_k8),
		.k9             (im0_k9),
	
		.blk0			(hash4_buf2),
		.blk1           (hash5_buf2),
		.blk2           (hash6_buf2),
		.blk3           (hash7_buf2),
		.blk4           (hash8_buf2),
		.blk5           (hash9_buf2),
		.blk6           (hash10_buf2),
		.blk7           (hash11_buf2),
		        
		.xout0			 (xout0_im0),
		.xout1           (xout1_im0),
		.xout2           (xout2_im0),
		.xout3           (xout3_im0),
		.xout4           (xout4_im0),
		.xout5           (xout5_im0),
		.xout6           (xout6_im0),
		.xout7           (xout7_im0),
		
		.db_xout_buf	(db_xout_buf_im0),
		.ab_xout_buf	(ab_xout_buf_im0),
		.cenb_xout_buf	(cenb_xout_buf_im0),
		
		.ready_for_next	(ready_for_next_im0),
		.ready			(ready_round_im0),
//`ifdef 	WITH_TWO_MAIN
//		.qa_scratchpad	(im_cur_main==0? qa_im_buf : qa_im_buf_main1)
//`else
		.qa_scratchpad	(qa_im_buf)
//`endif
	);
	
	reg		go_round_im0_d1, go_round_im0_d2, go_round_im0_d3, go_round_im0_d4, go_round_im0_d5, go_round_im0_d6, go_round_im0_d7, go_round_im0_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_round_im0_d1, go_round_im0_d2, go_round_im0_d3, go_round_im0_d4, go_round_im0_d5, go_round_im0_d6, go_round_im0_d7, go_round_im0_d8} <= 0;
		else		{go_round_im0_d1, go_round_im0_d2, go_round_im0_d3, go_round_im0_d4, go_round_im0_d5, go_round_im0_d6, go_round_im0_d7, go_round_im0_d8} <= 
						{go_round_im0, go_round_im0_d1, go_round_im0_d2, go_round_im0_d3, go_round_im0_d4, go_round_im0_d5, go_round_im0_d6, go_round_im0_d7};
	
	wire		go_im1 = go_im0_d8;
	wire		go_round_im1 = go_round_im0_d8;
	

	reg		[`W_IDX:0]   idx_im0_d1, idx_im0_d2, idx_im0_d3, idx_im0_d4, idx_im0_d5, idx_im0_d6, idx_im0_d7, idx_im0_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{idx_im0_d1, idx_im0_d2, idx_im0_d3, idx_im0_d4, idx_im0_d5, idx_im0_d6, idx_im0_d7, idx_im0_d8} <= 0;
		else		{idx_im0_d1, idx_im0_d2, idx_im0_d3, idx_im0_d4, idx_im0_d5, idx_im0_d6, idx_im0_d7, idx_im0_d8} <= 
						{idx_im0, idx_im0_d1, idx_im0_d2, idx_im0_d3, idx_im0_d4, idx_im0_d5, idx_im0_d6, idx_im0_d7};
	
	wire		[`W_IDX:0] 	idx_im1 = idx_im0_d8+1;
	
	cn_implode im1(
		.clk 			(clk), 		
		.rstn			(rstn),
		//.init_f			(go_im1),
		.init_f			(ready_hash_buf2_im1),
		.go				(go_round_im1),
	
		.k0             (im1_k0),
		.k1             (im1_k1),
		.k2             (im1_k2),
		.k3             (im1_k3),
		.k4             (im1_k4),
		.k5             (im1_k5),
		.k6             (im1_k6),
		.k7             (im1_k7),
		.k8             (im1_k8),
		.k9             (im1_k9),
		
		.blk0			(hash4_buf2),
		.blk1           (hash5_buf2),
		.blk2           (hash6_buf2),
		.blk3           (hash7_buf2),
		.blk4           (hash8_buf2),
		.blk5           (hash9_buf2),
		.blk6           (hash10_buf2),
		.blk7           (hash11_buf2),
		        
		.xout0			 (xout0_im1),
		.xout1           (xout1_im1),
		.xout2           (xout2_im1),
		.xout3           (xout3_im1),
		.xout4           (xout4_im1),
		.xout5           (xout5_im1),
		.xout6           (xout6_im1),
		.xout7           (xout7_im1),
		
		.db_xout_buf	(db_xout_buf_im1),
		.ab_xout_buf	(ab_xout_buf_im1),
		.cenb_xout_buf	(cenb_xout_buf_im1),
		
		.ready_for_next	(ready_for_next_im1),
		.ready			(ready_round_im1),
//`ifdef 	WITH_TWO_MAIN
//		.qa_scratchpad	(im_cur_main==0? qa_im_buf : qa_im_buf_main1)
//`else
		.qa_scratchpad	(qa_im_buf)
//`endif
	);
	
`ifdef EX_IMPLODE_INSTANCE_4
	
	
	reg		go_im1_d1, go_im1_d2, go_im1_d3, go_im1_d4, go_im1_d5, go_im1_d6, go_im1_d7, go_im1_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_im1_d1, go_im1_d2, go_im1_d3, go_im1_d4, go_im1_d5, go_im1_d6, go_im1_d7, go_im1_d8} <= 0;
		else		{go_im1_d1, go_im1_d2, go_im1_d3, go_im1_d4, go_im1_d5, go_im1_d6, go_im1_d7, go_im1_d8} <= 
						{go_im1, go_im1_d1, go_im1_d2, go_im1_d3, go_im1_d4, go_im1_d5, go_im1_d6, go_im1_d7};
	reg		go_round_im1_d1, go_round_im1_d2, go_round_im1_d3, go_round_im1_d4, go_round_im1_d5, go_round_im1_d6, go_round_im1_d7, go_round_im1_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_round_im1_d1, go_round_im1_d2, go_round_im1_d3, go_round_im1_d4, go_round_im1_d5, go_round_im1_d6, go_round_im1_d7, go_round_im1_d8} <= 0;
		else		{go_round_im1_d1, go_round_im1_d2, go_round_im1_d3, go_round_im1_d4, go_round_im1_d5, go_round_im1_d6, go_round_im1_d7, go_round_im1_d8} <= 
						{go_round_im1, go_round_im1_d1, go_round_im1_d2, go_round_im1_d3, go_round_im1_d4, go_round_im1_d5, go_round_im1_d6, go_round_im1_d7};
	
	wire		go_im2 = go_im1_d8;
	wire		go_round_im2 = go_round_im1_d8;
	

	reg		[`W_IDX:0]   idx_im1_d1, idx_im1_d2, idx_im1_d3, idx_im1_d4, idx_im1_d5, idx_im1_d6, idx_im1_d7, idx_im1_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{idx_im1_d1, idx_im1_d2, idx_im1_d3, idx_im1_d4, idx_im1_d5, idx_im1_d6, idx_im1_d7, idx_im1_d8} <= 0;
		else		{idx_im1_d1, idx_im1_d2, idx_im1_d3, idx_im1_d4, idx_im1_d5, idx_im1_d6, idx_im1_d7, idx_im1_d8} <= 
						{idx_im1, idx_im1_d1, idx_im1_d2, idx_im1_d3, idx_im1_d4, idx_im1_d5, idx_im1_d6, idx_im1_d7};
	
	wire		[`W_IDX:0] 	idx_im2 = idx_im1_d8+1;
	
	cn_implode im2(
		.clk 			(clk), 		
		.rstn			(rstn),
		.init_f			(ready_hash_buf2_im2),
		.go				(go_round_im2),
		
		.k0             (im2_k0),
		.k1             (im2_k1),
		.k2             (im2_k2),
		.k3             (im2_k3),
		.k4             (im2_k4),
		.k5             (im2_k5),
		.k6             (im2_k6),
		.k7             (im2_k7),
		.k8             (im2_k8),
		.k9             (im2_k9),
		
		
		.blk0			(hash4_buf2),
		.blk1           (hash5_buf2),
		.blk2           (hash6_buf2),
		.blk3           (hash7_buf2),
		.blk4           (hash8_buf2),
		.blk5           (hash9_buf2),
		.blk6           (hash10_buf2),
		.blk7           (hash11_buf2),
		        
		.xout0			 (xout0_im2),
		.xout1           (xout1_im2),
		.xout2           (xout2_im2),
		.xout3           (xout3_im2),
		.xout4           (xout4_im2),
		.xout5           (xout5_im2),
		.xout6           (xout6_im2),
		.xout7           (xout7_im2),
		
		.db_xout_buf	(db_xout_buf_im2),
		.ab_xout_buf	(ab_xout_buf_im2),
		.cenb_xout_buf	(cenb_xout_buf_im2),
		
		
		.ready_for_next	(ready_for_next_im2),
		.ready			(ready_round_im2),
		.qa_scratchpad	(qa_im_buf)
	);
	
	
	
	reg		go_im2_d1, go_im2_d2, go_im2_d3, go_im2_d4, go_im2_d5, go_im2_d6, go_im2_d7, go_im2_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_im2_d1, go_im2_d2, go_im2_d3, go_im2_d4, go_im2_d5, go_im2_d6, go_im2_d7, go_im2_d8} <= 0;
		else		{go_im2_d1, go_im2_d2, go_im2_d3, go_im2_d4, go_im2_d5, go_im2_d6, go_im2_d7, go_im2_d8} <= 
						{go_im2, go_im2_d1, go_im2_d2, go_im2_d3, go_im2_d4, go_im2_d5, go_im2_d6, go_im2_d7};
	reg		go_round_im2_d1, go_round_im2_d2, go_round_im2_d3, go_round_im2_d4, go_round_im2_d5, go_round_im2_d6, go_round_im2_d7, go_round_im2_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_round_im2_d1, go_round_im2_d2, go_round_im2_d3, go_round_im2_d4, go_round_im2_d5, go_round_im2_d6, go_round_im2_d7, go_round_im2_d8} <= 0;
		else		{go_round_im2_d1, go_round_im2_d2, go_round_im2_d3, go_round_im2_d4, go_round_im2_d5, go_round_im2_d6, go_round_im2_d7, go_round_im2_d8} <= 
						{go_round_im2, go_round_im2_d1, go_round_im2_d2, go_round_im2_d3, go_round_im2_d4, go_round_im2_d5, go_round_im2_d6, go_round_im2_d7};
	
	wire		go_im3 = go_im2_d8;
	wire		go_round_im3 = go_round_im2_d8;
	

	reg		[`W_IDX:0]   idx_im2_d1, idx_im2_d2, idx_im2_d3, idx_im2_d4, idx_im2_d5, idx_im2_d6, idx_im2_d7, idx_im2_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{idx_im2_d1, idx_im2_d2, idx_im2_d3, idx_im2_d4, idx_im2_d5, idx_im2_d6, idx_im2_d7, idx_im2_d8} <= 0;
		else		{idx_im2_d1, idx_im2_d2, idx_im2_d3, idx_im2_d4, idx_im2_d5, idx_im2_d6, idx_im2_d7, idx_im2_d8} <= 
						{idx_im2, idx_im2_d1, idx_im2_d2, idx_im2_d3, idx_im2_d4, idx_im2_d5, idx_im2_d6, idx_im2_d7};
	
	wire		[`W_IDX:0] 	idx_im3 = idx_im2_d8+1;
	
	cn_implode im3(
		.clk 			(clk), 		
		.rstn			(rstn),
	//	.init_f			(go_im3),
		.init_f			(ready_hash_buf2_im3),
		.go				(go_round_im3),
		
		.k0             (im3_k0),
		.k1             (im3_k1),
		.k2             (im3_k2),
		.k3             (im3_k3),
		.k4             (im3_k4),
		.k5             (im3_k5),
		.k6             (im3_k6),
		.k7             (im3_k7),
		.k8             (im3_k8),
		.k9             (im3_k9),
		
		.blk0			(hash4_buf2),
		.blk1           (hash5_buf2),
		.blk2           (hash6_buf2),
		.blk3           (hash7_buf2),
		.blk4           (hash8_buf2),
		.blk5           (hash9_buf2),
		.blk6           (hash10_buf2),
		.blk7           (hash11_buf2),
		        
		.xout0			 (xout0_im3),
		.xout1           (xout1_im3),
		.xout2           (xout2_im3),
		.xout3           (xout3_im3),
		.xout4           (xout4_im3),
		.xout5           (xout5_im3),
		.xout6           (xout6_im3),
		.xout7           (xout7_im3),
		
		.db_xout_buf	(db_xout_buf_im3),
		.ab_xout_buf	(ab_xout_buf_im3),
		.cenb_xout_buf	(cenb_xout_buf_im3),
		
		.ready_for_next	(ready_for_next_im3),
		.ready			(ready_round_im3),
		.qa_scratchpad	(qa_im_buf)
	);	
	
`else



`endif

	reg		ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8} <= 0;
		else		{ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8} <= 
						{ready_im0, ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7};	
						
	assign 	ready_im1= ready_im0_d8;	
`ifdef EX_IMPLODE_INSTANCE_4
	reg		ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8} <= 0;
		else		{ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8} <= 
						{ready_im1, ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7};	
						
	assign 	ready_im2= ready_im1_d8;	
	
	reg		ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8} <= 0;
		else		{ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8} <= 
						{ready_im2, ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7};	
						
	assign 	ready_im3= ready_im2_d8;	

`endif	
	
endmodule 







module genkeyExplode(
	input						clk , 		
	input						rstn,
	input						go,	
	input		[127:0]			hash0 , 						
	input		[127:0]			hash1 ,						
	input		[127:0]			hash2 ,						
	input		[127:0]			hash3 ,						
	input		[127:0]			hash4 ,						
	input		[127:0]			hash5 ,						
	input		[127:0]			hash6 ,						
	input		[127:0]			hash7 ,						
	input		[127:0]			hash8 ,						
	input		[127:0]			hash9 ,						
	input		[127:0]			hash10,						
	input		[127:0]			hash11,	
	
	output		[ 127:0] 	imp_k0, imp_k1, imp_k2, imp_k3, imp_k4, imp_k5, imp_k6, imp_k7, imp_k8, imp_k9,

	output 						ik_ready_sub,
	output 		[ 127:0]		ik,
	output 		[2:0]			ik_cnt,
	
	output						ready,
	output 		[`W_MEM	:0]		db_scratchpad_ex,
	output						cenb_scratchpad_ex,
	output		[`W_AMEM:0]		ab_scratchpad_ex
	);
	
	wire	[ 127:0] 	k0, k1, k2, k3, k4, k5, k6, k7, k8, k9;
//	wire	[ 127:0] 	imp_k0, imp_k1, imp_k2, imp_k3, imp_k4, imp_k5, imp_k6, imp_k7, imp_k8, imp_k9;
	
	wire	[127:0]	blk0 = hash4 ;
	wire	[127:0]	blk1 = hash5 ;
	wire	[127:0]	blk2 = hash6 ;
	wire	[127:0]	blk3 = hash7 ;
	wire	[127:0]	blk4 = hash8 ;
	wire	[127:0]	blk5 = hash9 ;
	wire	[127:0]	blk6 = hash10;
	wire	[127:0]	blk7 = hash11;
	
	ase_genkey ase_genkey(
		.clk 			(clk), 		
		.rstn			(rstn),
		.go				(go),
		.hash0			(hash0),
		.hash1			(hash1), 
		.hash2 	        (hash2),
		.hash3	        (hash3),
		.k0				(k0),
		.k1             (k1),
		.k2             (k2),
		.k3             (k3),
		.k4             (k4),
		.k5             (k5),
		.k6             (k6),
		.k7             (k7),
		.k8             (k8),
		.k9             (k9),
		
		.ik0			(imp_k0),
		.ik1            (imp_k1),
		.ik2            (imp_k2),
		.ik3            (imp_k3),
		.ik4            (imp_k4),
		.ik5            (imp_k5),
		.ik6            (imp_k6),
		.ik7            (imp_k7),
		.ik8            (imp_k8),
		.ik9            (imp_k9),
		
		.ik_ready_sub	(ik_ready_sub	),
		.ik				(ik				),
		.ik_cnt			(ik_cnt			)
		
	);
	
	cn_explode_scratchpad_3clk cn_explode_scratchpad(
		.clk 			(clk), 		
		.rstn			(rstn),
		.go				(go),
		.k0             (k0),
		.k1             (k1),
		.k2             (k2),
		.k3             (k3),
		.k4             (k4),
		.k5             (k5),
		.k6             (k6),
		.k7             (k7),
		.k8             (k8),
		.k9             (k9),
		
		.blk0			(blk0),
		.blk1           (blk1),
		.blk2           (blk2),
		.blk3           (blk3),
		.blk4           (blk4),
		.blk5           (blk5),
		.blk6           (blk6),
		.blk7           (blk7),
		.ready			(ready),
		.db_scratchpad	(db_scratchpad_ex),
		.cenb_scratchpad(cenb_scratchpad_ex),
		.ab_scratchpad	(ab_scratchpad_ex)
	);
endmodule



// 8clks
module mainloopaes(
		input							clk , 		
		input							rstn,
		input 		[127:0]				a,
		input		[127:0]				qa_scratchpad,
		input		[127:0]				b,
		output reg	[127:0]				b_update,
		output reg	[127:0]				db_scratchpad,
		output reg	[`W_AMEM:0]			ab_scratchpad
	);
	
	reg		[127:0]			a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14} <= 0;
		else			{a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14} <= {a, a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13};
	reg		[127:0]			b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14} <= 0;
		else			{b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14} <= {b, b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13};
	//== 1 clk
	reg		[127:0]				qa_scratchpad_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)		qa_scratchpad_d1 <= 0;
		else			qa_scratchpad_d1 <= qa_scratchpad;
	// 6clk
	wire		[127:0]				enc_data;
	aes_lowclk aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(a_d1					),	
		.data_en				(1'b1				), 
		.data_in				(qa_scratchpad_d1		),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	reg		[127:0]	block_new;
	reg		[127:0]	block_new_tweak;
	always @(*)
		block_new = enc_data ^ b_d7;
	
	always @(*)
		block_new_tweak = {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};

	// == 1 clk
	always @(`CLK_RST_EDGE)
		if (`ZST) 	b_update <= 0;
		else		b_update <= enc_data;
		
	always @(`CLK_RST_EDGE)
		if (`ZST) 	db_scratchpad <= 0;
		else		db_scratchpad <= block_new_tweak;	
	always @(`CLK_RST_EDGE)
		if (`ZST) 	ab_scratchpad <= 0;
		else		ab_scratchpad <= a_d7>>4;	

	function [7:0] tweak( input [7:0] a);
		//wire a4 = a[4] ^ ((a[5] nor a[0]) xor a[5]);
		//wire a5 = a[5] ^ ((a[4] xor a[0]) and a[4]);
		//wire a4 = 1;
		//wire a5 = 0;
		//reg a4, a5;
		begin
			//a4 = a[4] ^ ((a[5] ^~ a[0]) ^ a[5]);
			//a4 = a[4] ^ (a[5] ^~ a[0])^ a[5] ^(a[5]&a[0]);
			//a5 = a[5] ^ ((a[4] ^ a[0]) & a[4]);
			case ({a[5:4],a[0]})	
			3'b000: tweak = {a[7:6], 2'b01, a[3:0]};
			3'b001: tweak = {a[7:6], 2'b00, a[3:0]};
			3'b010: tweak = {a[7:6], 2'b10, a[3:0]};
			3'b011: tweak = {a[7:6], 2'b01, a[3:0]};
			3'b100: tweak = {a[7:6], 2'b11, a[3:0]};
			3'b101: tweak = {a[7:6], 2'b11, a[3:0]};
			3'b110: tweak = {a[7:6], 2'b00, a[3:0]};
			3'b111: tweak = {a[7:6], 2'b10, a[3:0]};
			endcase

		end
	endfunction
endmodule 



//    byte_mul_and_add = 8byte_add(a, 8byte_mul(b, scratchpad[b]))
//	  a = byte_mul_and_add ^ scratchpad[b]
// 	  scratchpad[b] = byte_mul_and_add //  and a tweak here

`ifdef SIMULATING
module mul5clk (
		input  	 	[63:0]  dataa,  //  mult_input.dataa
		input  	 	[63:0]  datab,  //            .datab
		input  	         	clock,  //            .clock
		output	    [127:0] result  // mult_output.result
	);
	
	wire	clk = clock;
	
	reg		[127:0]		byte_mul_b4, byte_mul_b3, byte_mul_b2, byte_mul_b1, byte_mul;	
	always @(`CLK_EDGE)
			byte_mul_b4 <= dataa * datab;
	always @(`CLK_EDGE)
			byte_mul_b3 <= byte_mul_b4;
	always @(`CLK_EDGE)
			byte_mul_b2 <= byte_mul_b3;
	always @(`CLK_EDGE)
			byte_mul_b1 <= byte_mul_b2;
	always @(`CLK_EDGE)
			byte_mul <= byte_mul_b1;
	assign result = byte_mul;

endmodule
`endif

module mainloopmul(
		input							clk , 		
		input							rstn,
		input 		[127:0]				a,
		input		[127:0]				b,
		input		[127:0]				qa_scratchpad,
		input		[ 63:0]				tweak1_2_0,
		output	reg	[127:0]				a_update,
		output	reg	[127:0]				db_scratchpad,
		output	reg	[`W_AMEM:0]			ab_scratchpad
	);
	reg		[127:0]			b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14} <= 0;
		else			{b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13, b_d14} <= {b, b_d1, b_d2, b_d3, b_d4, b_d5, b_d6, b_d7, b_d8, b_d9, b_d10, b_d11, b_d12, b_d13};
	reg		[127:0]			a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14} <= 0;
		else			{a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13, a_d14} <= {a, a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7, a_d8, a_d9, a_d10, a_d11, a_d12, a_d13};

	reg		[127:0]			qa_scratchpad_d1, qa_scratchpad_d2, qa_scratchpad_d3, qa_scratchpad_d4, qa_scratchpad_d5, qa_scratchpad_d6, qa_scratchpad_d7, qa_scratchpad_d8, qa_scratchpad_d9, qa_scratchpad_d10, qa_scratchpad_d11, qa_scratchpad_d12, qa_scratchpad_d13, qa_scratchpad_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{qa_scratchpad_d1, qa_scratchpad_d2, qa_scratchpad_d3, qa_scratchpad_d4, qa_scratchpad_d5, qa_scratchpad_d6, qa_scratchpad_d7, qa_scratchpad_d8, qa_scratchpad_d9, qa_scratchpad_d10, qa_scratchpad_d11, qa_scratchpad_d12, qa_scratchpad_d13, qa_scratchpad_d14} <= 0;
		else			{qa_scratchpad_d1, qa_scratchpad_d2, qa_scratchpad_d3, qa_scratchpad_d4, qa_scratchpad_d5, qa_scratchpad_d6, qa_scratchpad_d7, qa_scratchpad_d8, qa_scratchpad_d9, qa_scratchpad_d10, qa_scratchpad_d11, qa_scratchpad_d12, qa_scratchpad_d13, qa_scratchpad_d14} <= {qa_scratchpad, qa_scratchpad_d1, qa_scratchpad_d2, qa_scratchpad_d3, qa_scratchpad_d4, qa_scratchpad_d5, qa_scratchpad_d6, qa_scratchpad_d7, qa_scratchpad_d8, qa_scratchpad_d9, qa_scratchpad_d10, qa_scratchpad_d11, qa_scratchpad_d12, qa_scratchpad_d13};
	reg		[ 63:0]			tweak1_2_0_d1, tweak1_2_0_d2, tweak1_2_0_d3, tweak1_2_0_d4, tweak1_2_0_d5, tweak1_2_0_d6, tweak1_2_0_d7, tweak1_2_0_d8, tweak1_2_0_d9, tweak1_2_0_d10, tweak1_2_0_d11, tweak1_2_0_d12, tweak1_2_0_d13, tweak1_2_0_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{tweak1_2_0_d1, tweak1_2_0_d2, tweak1_2_0_d3, tweak1_2_0_d4, tweak1_2_0_d5, tweak1_2_0_d6, tweak1_2_0_d7, tweak1_2_0_d8, tweak1_2_0_d9, tweak1_2_0_d10, tweak1_2_0_d11, tweak1_2_0_d12, tweak1_2_0_d13, tweak1_2_0_d14} <= 0;
		else			{tweak1_2_0_d1, tweak1_2_0_d2, tweak1_2_0_d3, tweak1_2_0_d4, tweak1_2_0_d5, tweak1_2_0_d6, tweak1_2_0_d7, tweak1_2_0_d8, tweak1_2_0_d9, tweak1_2_0_d10, tweak1_2_0_d11, tweak1_2_0_d12, tweak1_2_0_d13, tweak1_2_0_d14} <= {tweak1_2_0, tweak1_2_0_d1, tweak1_2_0_d2, tweak1_2_0_d3, tweak1_2_0_d4, tweak1_2_0_d5, tweak1_2_0_d6, tweak1_2_0_d7, tweak1_2_0_d8, tweak1_2_0_d9, tweak1_2_0_d10, tweak1_2_0_d11, tweak1_2_0_d12, tweak1_2_0_d13};
	// 1 clk
	
`ifdef XXX
	// 5 clks to do multiply
	reg		[127:0]		byte_mul_b4, byte_mul_b3, byte_mul_b2, byte_mul_b1, byte_mul;	
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b4 <= 0;
		else			byte_mul_b4 <= b_d1[63:0] * qa_scratchpad_d1[63:0];
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b3 <= 0;
		else			byte_mul_b3 <= byte_mul_b4;
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b2 <= 0;
		else			byte_mul_b2 <= byte_mul_b3;
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b1 <= 0;
		else			byte_mul_b1 <= byte_mul_b2;
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= byte_mul_b1;
`else
	wire	[127:0]	byte_mul;
	mul5clk mul(
		.dataa  (b_d1[63:0]),  //   input,   width = 64,  mult_input.dataa
		.datab  (qa_scratchpad_d1[63:0]),  //   input,   width = 64,            .datab
		.clock  (clk),  //   input,    width = 1,            .clock
		.result (byte_mul)  //  output,  width = 128, mult_output.result
	);

`endif
	// 1 clk	
	reg		[127:0]		byte_mul_and_add; 
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_and_add <= 0;
		else			byte_mul_and_add <= { (a_d6[127:64] + byte_mul[63:0] ), (a_d6[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
	//	else			byte_mul_and_add <= byte_mul_and_add_b1;   
	// 1 clk
	always @(`CLK_RST_EDGE)
		if (`ZST)		a_update <= 0;
		else			a_update <= byte_mul_and_add ^ qa_scratchpad_d7;
	always @(`CLK_RST_EDGE)
		if (`ZST)		db_scratchpad <= 0;
		else			db_scratchpad <= {tweak1_2_0_d7 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
	always @(`CLK_RST_EDGE)
		if (`ZST)		ab_scratchpad <= 0;
		else			ab_scratchpad <= b_d7>>4; 
endmodule 

module mainlooptest(
		input						clk , 		
		input						rstn,
		input						go,
		
		input						init_ab_f,
		input		[127:0]			init_a, 
		input		[127:0]			init_b,
		input		[ 63:0]			init_tweak,
		input		[`W_IDX:0]		init_ab_idx,
		
		input						w_loop1_buf_ready,
		input	[127:0]				qa_loop1_buf,
		output	[4:0]				aa_loop1_buf,
		output						cena_loop1_buf,
		output reg					loop1_datahub_req,
		
		output reg										cenb_loop1_wbuf,
		output reg		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop1_wbuf,
		output reg		[`W_IDX:0]						ab_loop1_wbuf,
		output reg										cenb_loop1_rbuf,
		output reg		[`W_IDX+1+`W_AMEM:0]			db_loop1_rbuf,
		output reg		[`W_IDX:0]						ab_loop1_rbuf,
		
		
		input						w_loop2_buf_ready,
		input	[127:0]				qa_loop2_buf,
		output	[4:0]				aa_loop2_buf,
		output						cena_loop2_buf,
		output reg					loop2_datahub_req,
		output reg					loop2_datahub_req_last,
		
		output reg										cenb_loop2_wbuf,
		output reg		[`W_IDX+1+`W_AMEM+1+127:0]		db_loop2_wbuf,
		output reg		[`W_IDX:0]						ab_loop2_wbuf,
		output reg										cenb_loop2_rbuf,
		output reg		[`W_IDX+1+`W_AMEM:0]			db_loop2_rbuf,
		output reg		[`W_IDX:0]						ab_loop2_rbuf,
		
		output reg										ready
		
	
		
	);
	
	parameter	IDX_MAX = (1<<`W_IDX) - 1;  
`ifdef SIMULATION_LESS_MAINLOOP_CYCLES
	parameter	CNT_MAX_LOOP = 'h800 - 1; 
`else	
	parameter	CNT_MAX_LOOP = 'h80000 - 1; 
`endif	
		

	reg		[127:0]			a_idx0, a_idx1, a_idx2, a_idx3, a_idx4, a_idx5, a_idx6, a_idx7, a_idx8, a_idx9; 
	reg		[127:0]			a_idx10, a_idx11, a_idx12, a_idx13, a_idx14, a_idx15, a_idx16, a_idx17, a_idx18, a_idx19; 
	reg		[127:0]			a_idx20, a_idx21, a_idx22, a_idx23, a_idx24, a_idx25, a_idx26, a_idx27, a_idx28, a_idx29; 
	
	reg		[127:0]			b_idx0, b_idx1, b_idx2, b_idx3, b_idx4, b_idx5, b_idx6, b_idx7, b_idx8, b_idx9; 
	reg		[ 63:0]			tweak_idx0, tweak_idx1, tweak_idx2, tweak_idx3, tweak_idx4, tweak_idx5, tweak_idx6, tweak_idx7, tweak_idx8, tweak_idx9; 
	
	reg		[127:0]			a_idx[`TASKN-1:0];
	reg		[127:0]			b_idx[`TASKN-1:0];
	reg		[ 63:0]			tweak_idx[`TASKN-1:0];
	
	reg		[127:0]			a_loop1;
	reg		[127:0]			b_loop1;
	reg						go_loop1;
	reg		loop1_en_b1, loop1_en;		
	reg		loop1_en_d1, loop1_en_d2, loop1_en_d3, loop1_en_d4, loop1_en_d5, loop1_en_d6, loop1_en_d7, loop1_en_d8, loop1_en_d9, loop1_en_d10, loop1_en_d11, loop1_en_d12, loop1_en_d13, loop1_en_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{loop1_en, loop1_en_d1, loop1_en_d2, loop1_en_d3, loop1_en_d4, loop1_en_d5, loop1_en_d6, loop1_en_d7, loop1_en_d8, loop1_en_d9, loop1_en_d10, loop1_en_d11, loop1_en_d12, loop1_en_d13, loop1_en_d14} <= 0;
		else			{loop1_en, loop1_en_d1, loop1_en_d2, loop1_en_d3, loop1_en_d4, loop1_en_d5, loop1_en_d6, loop1_en_d7, loop1_en_d8, loop1_en_d9, loop1_en_d10, loop1_en_d11, loop1_en_d12, loop1_en_d13, loop1_en_d14} <= {loop1_en_b1, loop1_en, loop1_en_d1, loop1_en_d2, loop1_en_d3, loop1_en_d4, loop1_en_d5, loop1_en_d6, loop1_en_d7, loop1_en_d8, loop1_en_d9, loop1_en_d10, loop1_en_d11, loop1_en_d12, loop1_en_d13};
	
	reg		[`W_IDX:0]		idx_loop1_b1, idx_loop1;		
	reg		[`W_IDX:0]		idx_loop1_d1, idx_loop1_d2, idx_loop1_d3, idx_loop1_d4, idx_loop1_d5, idx_loop1_d6, idx_loop1_d7, idx_loop1_d8, idx_loop1_d9, idx_loop1_d10, idx_loop1_d11, idx_loop1_d12, idx_loop1_d13, idx_loop1_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{idx_loop1, idx_loop1_d1, idx_loop1_d2, idx_loop1_d3, idx_loop1_d4, idx_loop1_d5, idx_loop1_d6, idx_loop1_d7, idx_loop1_d8, idx_loop1_d9, idx_loop1_d10, idx_loop1_d11, idx_loop1_d12, idx_loop1_d13, idx_loop1_d14} <= 0;
		else			{idx_loop1, idx_loop1_d1, idx_loop1_d2, idx_loop1_d3, idx_loop1_d4, idx_loop1_d5, idx_loop1_d6, idx_loop1_d7, idx_loop1_d8, idx_loop1_d9, idx_loop1_d10, idx_loop1_d11, idx_loop1_d12, idx_loop1_d13, idx_loop1_d14} <= {idx_loop1_b1, idx_loop1, idx_loop1_d1, idx_loop1_d2, idx_loop1_d3, idx_loop1_d4, idx_loop1_d5, idx_loop1_d6, idx_loop1_d7, idx_loop1_d8, idx_loop1_d9, idx_loop1_d10, idx_loop1_d11, idx_loop1_d12, idx_loop1_d13};

	reg					go_loop1_d1, go_loop1_d2, go_loop1_d3, go_loop1_d4, go_loop1_d5, go_loop1_d6, go_loop1_d7, go_loop1_d8, go_loop1_d9, go_loop1_d10, go_loop1_d11, go_loop1_d12, go_loop1_d13, go_loop1_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_loop1_d1, go_loop1_d2, go_loop1_d3, go_loop1_d4, go_loop1_d5, go_loop1_d6, go_loop1_d7, go_loop1_d8, go_loop1_d9, go_loop1_d10, go_loop1_d11, go_loop1_d12, go_loop1_d13, go_loop1_d14} <= 0;
		else			{go_loop1_d1, go_loop1_d2, go_loop1_d3, go_loop1_d4, go_loop1_d5, go_loop1_d6, go_loop1_d7, go_loop1_d8, go_loop1_d9, go_loop1_d10, go_loop1_d11, go_loop1_d12, go_loop1_d13, go_loop1_d14} <= {go_loop1, go_loop1_d1, go_loop1_d2, go_loop1_d3, go_loop1_d4, go_loop1_d5, go_loop1_d6, go_loop1_d7, go_loop1_d8, go_loop1_d9, go_loop1_d10, go_loop1_d11, go_loop1_d12, go_loop1_d13};

		
	//always@(*)		go_loop1 = go | w_loop1_buf_ready;
	always@(*)		go_loop1 = w_loop1_buf_ready;
	
	reg		[9:0]	cnt_sim;
	always @(`CLK_RST_EDGE)
		if (`RST)			cnt_sim <= 0;
		else if (go_loop1)	cnt_sim <= 0;
		else 				cnt_sim <= cnt_sim + 1;

		
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	a_loop1 <= 0;
//		else case(idx_loop1_b1)
//			0:		a_loop1 <= a_idx0;
//			1:		a_loop1 <= a_idx1;
//			2:		a_loop1 <= a_idx2;
//			3:		a_loop1 <= a_idx3;
//			4:		a_loop1 <= a_idx4;
//			5:		a_loop1 <= a_idx5;
//			6:		a_loop1 <= a_idx6;
//			7:		a_loop1 <= a_idx7;
//			endcase
//			
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	b_loop1 <= 0;
//		else case(idx_loop1_b1)
//			0:		b_loop1 <= b_idx0;
//			1:		b_loop1 <= b_idx1;
//			2:		b_loop1 <= b_idx2;
//			3:		b_loop1 <= b_idx3;
//			4:		b_loop1 <= b_idx4;
//			5:		b_loop1 <= b_idx5;
//			6:		b_loop1 <= b_idx6;
//			7:		b_loop1 <= b_idx7;
//			endcase
		
	always @(`CLK_RST_EDGE)
		if (`ZST)	a_loop1 <= 0;
		else		a_loop1 <= a_idx[idx_loop1_b1];
	
	always @(`CLK_RST_EDGE)
		if (`ZST)	b_loop1 <= 0;
		else		b_loop1 <= b_idx[idx_loop1_b1];
		
		
		
		
	wire 	idx1_max_f_b1 = idx_loop1_b1[`W_IDX-1:0] == IDX_MAX;  // = 2^(21-4) = 128K*10 = 1M多
	always @(`CLK_RST_EDGE)
		if (`RST)				loop1_en_b1 <= 0;
		else if (go_loop1)  	loop1_en_b1 <= 1;
		else if (idx1_max_f_b1) loop1_en_b1 <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 			idx_loop1_b1 <= 0;
		else if (loop1_en_b1) 	idx_loop1_b1 <= idx_loop1_b1 + 1;
		
	assign		aa_loop1_buf = idx_loop1_b1;
	assign 		cena_loop1_buf = 1'b0;
	
	// update b 
	// send use a buff to store db_scratchpad and ab_scratchpad
	// and do the send a signal to datahub
	
	wire		[127:0]				b_update;
	wire		[127:0]				db_scratchpad_loop1;
	wire		[`W_AMEM:0]			ab_scratchpad_loop1;
	
	mainloopaes loop1(
		.clk 				(clk), 		
		.rstn				(rstn),
		.a					(a_loop1),
		.qa_scratchpad		(qa_loop1_buf),
		.b					(b_loop1),
		.b_update			(b_update),
		.db_scratchpad		(db_scratchpad_loop1),
		.ab_scratchpad      (ab_scratchpad_loop1)
	);
	

	
	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_loop1_wbuf <= 1;
		else 			cenb_loop1_wbuf <= ~loop1_en_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop1_wbuf <= 1;
		else 			db_loop1_wbuf <= {idx_loop1_d8, ab_scratchpad_loop1, db_scratchpad_loop1};  //add idx
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop1_wbuf <= 0;
		else if(~cenb_loop1_wbuf)	ab_loop1_wbuf <= ab_loop1_wbuf + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_loop1_rbuf <= 1;
		else 			cenb_loop1_rbuf <= ~loop1_en_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop1_rbuf <= 1;
		else 			db_loop1_rbuf <= {idx_loop1_d8, b_update[4+`W_AMEM:4]};
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop1_rbuf <= 0;
		else if(~cenb_loop1_rbuf)	ab_loop1_rbuf <= ab_loop1_rbuf + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)	loop1_datahub_req	 <= 0;
		else 		loop1_datahub_req	 <= go_loop1_d7;   // 6 clks ahead
	//	else 		loop1_datahub_req	 <= go_loop1_d8;   // 5 clks ahead
	//	else 		loop1_datahub_req	 <= go_loop1_d9;   // 4 clks ahead
	//	else 		loop1_datahub_req	 <= go_loop1_d13;
		
//	// update b 
//	always @(`CLK_RST_EDGE)
//		if (`RST)		{b_idx1, b_idx2, b_idx3, b_idx4, b_idx5, b_idx6, b_idx7} <= 0;
//	//	else if (go) begin
//	//		b_idx0 <= 'hb0;
//	//		b_idx1 <= 'hb1;
//	//		b_idx2 <= 'hb2;
//	//		b_idx3 <= 'hb3;
//	//		b_idx4 <= 'hb4;
//	//		b_idx5 <= 'hb5;
//	//		b_idx6 <= 'hb6;
//	//		b_idx7 <= 'hb7;
//	//	
//	//	end
//		else if (init_ab_f)
//			case (init_ab_idx)
//			0:	b_idx0 <= init_b;
//			1:	b_idx1 <= init_b;
//			2:	b_idx2 <= init_b;
//			3:	b_idx3 <= init_b;
//			4:	b_idx4 <= init_b;
//			5:	b_idx5 <= init_b;
//			6:	b_idx6 <= init_b;
//			7:	b_idx7 <= init_b;
//			endcase
//		else if (loop1_en_d8)
//			case(idx_loop1_d8)
//			0:	b_idx0 <= b_update;
//			1:	b_idx1 <= b_update;
//			2:	b_idx2 <= b_update;
//			3:	b_idx3 <= b_update;
//			4:	b_idx4 <= b_update;
//			5:	b_idx5 <= b_update;
//			6:	b_idx6 <= b_update;
//			7:	b_idx7 <= b_update;
//			endcase

	always @(`CLK_EDGE)
		if (init_ab_f)
			b_idx[init_ab_idx] <= init_b;
		else if (loop1_en_d8)
			b_idx[idx_loop1_d8] <= b_update;
	
	
//=========================================================================================
	
	
	
	reg		[18+1:0]			loop2_cnt;
	
	reg		[127:0]			a_loop2;
	reg		[127:0]			b_loop2;
	reg		[ 63:0]			tweak_loop2;
	reg						go_loop2;
	reg		loop2_en_b1, loop2_en;		
	reg		loop2_en_d1, loop2_en_d2, loop2_en_d3, loop2_en_d4, loop2_en_d5, loop2_en_d6, loop2_en_d7, loop2_en_d8, loop2_en_d9, loop2_en_d10, loop2_en_d11, loop2_en_d12, loop2_en_d13, loop2_en_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{loop2_en, loop2_en_d1, loop2_en_d2, loop2_en_d3, loop2_en_d4, loop2_en_d5, loop2_en_d6, loop2_en_d7, loop2_en_d8, loop2_en_d9, loop2_en_d10, loop2_en_d11, loop2_en_d12, loop2_en_d13, loop2_en_d14} <= 0;
		else			{loop2_en, loop2_en_d1, loop2_en_d2, loop2_en_d3, loop2_en_d4, loop2_en_d5, loop2_en_d6, loop2_en_d7, loop2_en_d8, loop2_en_d9, loop2_en_d10, loop2_en_d11, loop2_en_d12, loop2_en_d13, loop2_en_d14} <= {loop2_en_b1, loop2_en, loop2_en_d1, loop2_en_d2, loop2_en_d3, loop2_en_d4, loop2_en_d5, loop2_en_d6, loop2_en_d7, loop2_en_d8, loop2_en_d9, loop2_en_d10, loop2_en_d11, loop2_en_d12, loop2_en_d13};
	
	reg		[`W_IDX:0]		idx_loop2_b1, idx_loop2;		
	reg		[`W_IDX:0]		idx_loop2_d1, idx_loop2_d2, idx_loop2_d3, idx_loop2_d4, idx_loop2_d5, idx_loop2_d6, idx_loop2_d7, idx_loop2_d8, idx_loop2_d9, idx_loop2_d10, idx_loop2_d11, idx_loop2_d12, idx_loop2_d13, idx_loop2_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{idx_loop2, idx_loop2_d1, idx_loop2_d2, idx_loop2_d3, idx_loop2_d4, idx_loop2_d5, idx_loop2_d6, idx_loop2_d7, idx_loop2_d8, idx_loop2_d9, idx_loop2_d10, idx_loop2_d11, idx_loop2_d12, idx_loop2_d13, idx_loop2_d14} <= 0;
		else			{idx_loop2, idx_loop2_d1, idx_loop2_d2, idx_loop2_d3, idx_loop2_d4, idx_loop2_d5, idx_loop2_d6, idx_loop2_d7, idx_loop2_d8, idx_loop2_d9, idx_loop2_d10, idx_loop2_d11, idx_loop2_d12, idx_loop2_d13, idx_loop2_d14} <= {idx_loop2_b1, idx_loop2, idx_loop2_d1, idx_loop2_d2, idx_loop2_d3, idx_loop2_d4, idx_loop2_d5, idx_loop2_d6, idx_loop2_d7, idx_loop2_d8, idx_loop2_d9, idx_loop2_d10, idx_loop2_d11, idx_loop2_d12, idx_loop2_d13};

	reg					go_loop2_d1, go_loop2_d2, go_loop2_d3, go_loop2_d4, go_loop2_d5, go_loop2_d6, go_loop2_d7, go_loop2_d8, go_loop2_d9, go_loop2_d10, go_loop2_d11, go_loop2_d12, go_loop2_d13, go_loop2_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_loop2_d1, go_loop2_d2, go_loop2_d3, go_loop2_d4, go_loop2_d5, go_loop2_d6, go_loop2_d7, go_loop2_d8, go_loop2_d9, go_loop2_d10, go_loop2_d11, go_loop2_d12, go_loop2_d13, go_loop2_d14} <= 0;
		else			{go_loop2_d1, go_loop2_d2, go_loop2_d3, go_loop2_d4, go_loop2_d5, go_loop2_d6, go_loop2_d7, go_loop2_d8, go_loop2_d9, go_loop2_d10, go_loop2_d11, go_loop2_d12, go_loop2_d13, go_loop2_d14} <= {go_loop2, go_loop2_d1, go_loop2_d2, go_loop2_d3, go_loop2_d4, go_loop2_d5, go_loop2_d6, go_loop2_d7, go_loop2_d8, go_loop2_d9, go_loop2_d10, go_loop2_d11, go_loop2_d12, go_loop2_d13};

		
	always@(*)		go_loop2 = w_loop2_buf_ready;
	
	reg		[7:0]	cnt_sim2;
	always @(`CLK_RST_EDGE)
		if (`RST)			cnt_sim2 <= 0;
		else if (go_loop2)	cnt_sim2 <= 0;
		else 				cnt_sim2 <= cnt_sim2 + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)					loop2_cnt <= 0;
	//	else if (go)				loop2_cnt <= 0;
		else if (init_ab_f)			loop2_cnt <= 0;
	//	else if (go_loop2)			loop2_cnt <= loop2_cnt + 1;
		else if (loop2_datahub_req)	loop2_cnt <= loop2_cnt + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)						loop2_datahub_req_last <= 0;
	//	else if (go)					loop2_datahub_req_last <= 0;
		else if (init_ab_f)				loop2_datahub_req_last <= 0;
		else if (loop2_datahub_req )	loop2_datahub_req_last <= (loop2_cnt>>1==CNT_MAX_LOOP);	
		
	always @(`CLK_RST_EDGE)
		if (`RST)		ready <= 0;
		else 			ready <= loop2_datahub_req &loop2_datahub_req_last;
	
	
	
		
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	a_loop2 <= 0;
//		else case(idx_loop2_b1)
//			0:		a_loop2 <= a_idx0;
//			1:		a_loop2 <= a_idx1;
//			2:		a_loop2 <= a_idx2;
//			3:		a_loop2 <= a_idx3;
//			4:		a_loop2 <= a_idx4;
//			5:		a_loop2 <= a_idx5;
//			6:		a_loop2 <= a_idx6;
//			7:		a_loop2 <= a_idx7;
//			endcase
//			
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	b_loop2 <= 0;
//		else case(idx_loop2_b1)
//			0:		b_loop2 <= b_idx0;
//			1:		b_loop2 <= b_idx1;
//			2:		b_loop2 <= b_idx2;
//			3:		b_loop2 <= b_idx3;
//			4:		b_loop2 <= b_idx4;
//			5:		b_loop2 <= b_idx5;
//			6:		b_loop2 <= b_idx6;
//			7:		b_loop2 <= b_idx7;
//			endcase
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	tweak_loop2 <= 0;
//		else case(idx_loop2_b1)
//			0:		tweak_loop2 <= tweak_idx0;
//			1:		tweak_loop2 <= tweak_idx1;
//			2:		tweak_loop2 <= tweak_idx2;
//			3:		tweak_loop2 <= tweak_idx3;
//			4:		tweak_loop2 <= tweak_idx4;
//			5:		tweak_loop2 <= tweak_idx5;
//			6:		tweak_loop2 <= tweak_idx6;
//			7:		tweak_loop2 <= tweak_idx7;
//			endcase
//	always @(`CLK_RST_EDGE)
//		if (`RST)		{tweak_idx0, tweak_idx1, tweak_idx2, tweak_idx3, tweak_idx4, tweak_idx5, tweak_idx6, tweak_idx7} <= 0;
//		else if (init_ab_f)
//			case (init_ab_idx)
//			0:	tweak_idx0 <= init_tweak;
//			1:	tweak_idx1 <= init_tweak;
//			2:	tweak_idx2 <= init_tweak;
//			3:	tweak_idx3 <= init_tweak;
//			4:	tweak_idx4 <= init_tweak;
//			5:	tweak_idx5 <= init_tweak;
//			6:	tweak_idx6 <= init_tweak;
//			7:	tweak_idx7 <= init_tweak;
//			endcase
			
			
	always @(`CLK_RST_EDGE)
		if (`ZST)	a_loop2 <= 0;
		else		a_loop2 <= a_idx[idx_loop2_b1];
	
	always @(`CLK_RST_EDGE)
		if (`ZST)	b_loop2 <= 0;
		else		b_loop2 <= b_idx[idx_loop2_b1];
	always @(`CLK_RST_EDGE)
		if (`ZST)	tweak_loop2 <= 0;
		else		tweak_loop2 <= tweak_idx[idx_loop2_b1];
	always @(`CLK_EDGE)
		if (init_ab_f)
			tweak_idx[init_ab_idx] <= init_tweak;
	
			
	wire 	idx2_max_f_b1 = idx_loop2_b1[`W_IDX-1:0] == IDX_MAX;  // = 2^(21-4) = 128K*10 = 1M多
	always @(`CLK_RST_EDGE)
		if (`RST)				loop2_en_b1 <= 0;
		else if (go_loop2)  	loop2_en_b1 <= 1;
		else if (idx2_max_f_b1) loop2_en_b1 <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 			idx_loop2_b1 <= 0;
		else if (loop2_en_b1) 	idx_loop2_b1 <= idx_loop2_b1 + 1;
		
	assign		aa_loop2_buf = idx_loop2_b1;
	assign 		cena_loop2_buf = 1'b0;
	
	// update b 
	// send use a buff to store db_scratchpad and ab_scratchpad
	// and do the send a signal to datahub
	
	wire		[127:0]				a_update;
	wire		[127:0]				db_scratchpad_loop2;
	wire		[`W_AMEM:0]			ab_scratchpad_loop2;
	
	mainloopmul loop2(
		.clk 				(clk), 		
		.rstn				(rstn),
		.a					(a_loop2),
		.qa_scratchpad		(qa_loop2_buf),
		.b					(b_loop2),
		.tweak1_2_0			(tweak_loop2),
		.a_update			(a_update),
		.db_scratchpad		(db_scratchpad_loop2),
		.ab_scratchpad      (ab_scratchpad_loop2)
	);
	

	
	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_loop2_wbuf <= 1;
		else 			cenb_loop2_wbuf <= ~loop2_en_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop2_wbuf <= 1;
		else 			db_loop2_wbuf <= {idx_loop2_d8, ab_scratchpad_loop2, db_scratchpad_loop2};  //add idx
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop2_wbuf <= 0;
		else if(~cenb_loop2_wbuf)	ab_loop2_wbuf <= ab_loop2_wbuf + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)		cenb_loop2_rbuf <= 1;
		else 			cenb_loop2_rbuf <= ~loop2_en_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop2_rbuf <= 1;
		else 			db_loop2_rbuf <= {idx_loop2_d8, a_update[4+`W_AMEM:4]};
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop2_rbuf <= 0;
		else if(~cenb_loop2_rbuf)	ab_loop2_rbuf <= ab_loop2_rbuf + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)	loop2_datahub_req	 <= 0;
		else 		loop2_datahub_req	 <= go_loop2_d7;   // 6clks ahead
	//	else 		loop2_datahub_req	 <= go_loop2_d8;   // 5clks ahead
	//	else 		loop2_datahub_req	 <= go_loop2_d9;   // 4clks ahead
	//	else 		loop2_datahub_req	 <= go_loop2_d13;
		
//	// update b 
//	always @(`CLK_RST_EDGE)
//		if (`RST)		{a_idx0, a_idx1, a_idx2, a_idx3, a_idx4, a_idx5, a_idx6, a_idx7} <= 0;
//		//else if (go) begin
//		//	a_idx0 <= 'ha0;
//		//	a_idx1 <= 'ha1;
//		//	a_idx2 <= 'ha2;
//		//	a_idx3 <= 'ha3;
//		//	a_idx4 <= 'ha4;
//		//	a_idx5 <= 'ha5;
//		//	a_idx6 <= 'ha6;
//		//	a_idx7 <= 'ha7;
//		//
//		//end
//		else if (init_ab_f)
//			case (init_ab_idx)
//			0:	a_idx0 <= init_a;
//			1:	a_idx1 <= init_a;
//			2:	a_idx2 <= init_a;
//			3:	a_idx3 <= init_a;
//			4:	a_idx4 <= init_a;
//			5:	a_idx5 <= init_a;
//			6:	a_idx6 <= init_a;
//			7:	a_idx7 <= init_a;
//			endcase
//		else if (loop2_en_d8)
//			case(idx_loop2_d8)
//			0:	a_idx0 <= a_update;
//			1:	a_idx1 <= a_update;
//			2:	a_idx2 <= a_update;
//			3:	a_idx3 <= a_update;
//			4:	a_idx4 <= a_update;
//			5:	a_idx5 <= a_update;
//			6:	a_idx6 <= a_update;
//			7:	a_idx7 <= a_update;
//			endcase
	

	always @(`CLK_EDGE)
		if (init_ab_f)
			a_idx[init_ab_idx] <= init_a;
		else if (loop2_en_d8)
			a_idx[idx_loop2_d8] <= a_update;
			
endmodule




module cn_implode(
	input						clk , 		
	input						rstn,
	input						init_f,
	input						go,
	
	input		[127:0]			k0,
	input		[127:0]			k1,						
	input		[127:0]			k2,						
	input		[127:0]			k3,						
	input		[127:0]			k4,						
	input		[127:0]			k5,						
	input		[127:0]			k6,						
	input		[127:0]			k7,						
	input		[127:0]			k8,						
	input		[127:0]			k9,	
	
	input		[127:0]	        blk0,							
	input		[127:0]	        blk1,							
	input		[127:0]	        blk2,							
	input		[127:0]	        blk3,
	input		[127:0]	        blk4,
	input		[127:0]	        blk5,
	input		[127:0]	        blk6,
	input		[127:0]	        blk7,
	
	output reg	[127:0]	        xout0,							
	output reg	[127:0]	        xout1,							
	output reg	[127:0]	        xout2,							
	output reg	[127:0]	        xout3,
	output reg	[127:0]	        xout4,
	output reg	[127:0]	        xout5,
	output reg	[127:0]	        xout6,
	output reg	[127:0]	        xout7,				
	
	output reg	[127:0]			db_xout_buf,
	output reg	[ 2:0]			ab_xout_buf,
	output reg					cenb_xout_buf,
	
	output reg					ready_for_next,
	output reg					ready,
	input	 	[`W_MEM:0]		qa_scratchpad,
	output reg					cena_scratchpad,
	output reg	[3:0]			aa_scratchpad
	);
	
	
	// 2M / 16 = 128K 循环
	// 先循环数据  后循环key
	// 不能先循环key 因为前后有数据依赖关系
	parameter 	W_CNT = 5;
	parameter	CNT_MAX = 10/2* 8 - 1;
	reg		[127:0]		blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg;
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	reg		[127:0]		data_in;
	reg		[127:0]		key_in;
	wire	[127:0]		enc_data;
	reg		[3:0]		cnt_key;  // 0~9
	
	reg		[127:0]		data_in_1;
	reg		[127:0]		key_in_1;
	wire	[127:0]		enc_data_1;
	
	
	reg		[3:0]		cnt_rem10;  // cnt[W_CNT:3] % 10
	reg		[3:0]		cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14;

	
	wire 	cnt_max_f_b3 = cnt == (CNT_MAX-3);  
	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M多
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready_for_next <= 0;
		else 		ready_for_next <= cnt_max_f_b3;
		
	reg		first_round;
	reg					first_round_d1, first_round_d2, first_round_d3, first_round_d4;
	always @(`CLK_RST_EDGE)
		if (`RST)				first_round <= 1;
		else if (init_f)		first_round <= 1;
		else if (cnt[1:0]==3)	first_round <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	{first_round_d1, first_round_d2, first_round_d3, first_round_d4} <= 0;
		else 		{first_round_d1, first_round_d2, first_round_d3, first_round_d4} <= {first_round,first_round_d1, first_round_d2, first_round_d3};
		
(* keep = "true", max_fanout = 64 *)	reg					ready_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)	ready_b1 <= 0;
		else 		ready_b1 <= cnt_max_f_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= ready_b1;	
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go_d1)		en <= 1;
		else if (cnt_max_f)	en <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt_max_f? 0 : cnt + 1;
		else		 cnt <= 0;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	 			cnt_rem10 <= 0;
	//	else if (go) 			cnt_rem10 <= 0;
		else if(cnt[1:0]==3)	cnt_rem10 <= cnt_rem10==9? 0 : cnt_rem10+1;
	always @(`CLK_RST_EDGE)
		if (`RST)		{cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14} <= 0;
		else			{cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14} <= {cnt_rem10, cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13};

	
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= 0;
		else			{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= {go, go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13};
	always @(`CLK_RST_EDGE)
		if (`RST)		{en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14} <= 0;
		else			{en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14} <= {en, en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13};
	
	always @(`CLK_RST_EDGE)
		if (`RST)		{cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14} <= 0;
		else			{cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14} <= {cnt, cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13};
	always @(`CLK_RST_EDGE)
		if (`RST)		{cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14} <= 0;
		else			{cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14} <= {cnt_max_f, cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13};

		
	always @(`CLK_RST_EDGE)
		if (`ZST) {blk0_reg, blk1_reg, blk2_reg, blk3_reg} <= 0;
		else if (init_f)
			{blk0_reg, blk1_reg, blk2_reg, blk3_reg} <= {blk0, blk1, blk2, blk3};
		else if (en_d4) case (cnt_d4[1:0])
			0: 	blk0_reg <= enc_data;
			1:  blk1_reg <= enc_data;
			2:  blk2_reg <= enc_data;
			3:  blk3_reg <= enc_data;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in <= 0;
		//else if (cnt[W_CNT:2]==0)
		else if (first_round)
			case(cnt[1:0])
			0: 	data_in <= blk0_reg;
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			endcase
		else if (en)
			//if (en_d4) 
			if (en_d4 && cnt[1:0]==cnt_d4[1:0]) 
				data_in <= enc_data;
			else case(cnt[1:0])
			0: 	data_in <= blk0_reg;			// 加了这个之后可能就不需要前面的 first_round 了
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			endcase

//		else if (en)				
//			data_in <= enc_data;    // 这个地方可能有点问题， 如果中间不连续了 这个地方就不对了  这个地方可能不能省这个clk了， 或者用 6clk 版本来做， 8个并行
	always @(`CLK_RST_EDGE)
		if (`ZST) {blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= 0;
		else if (init_f)
			{blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= {blk4, blk5, blk6, blk7};
		else if (en_d8) case (cnt_d8[1:0])
			0:  blk4_reg <= enc_data_1;
			1:  blk5_reg <= enc_data_1;
		    2:  blk6_reg <= enc_data_1;
		    3:  blk7_reg <= enc_data_1;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in_1 <= 0;
	//	else if (cnt_d4[W_CNT:2]==0)
		else if (first_round_d4)
			case(cnt_d4[1:0])
			0:  data_in_1 <= blk4_reg;
			1:  data_in_1 <= blk5_reg;
			2:  data_in_1 <= blk6_reg;
		    3:  data_in_1 <= blk7_reg;
			endcase
		else if (en_d4)
			//if (en_d8) 
			if (en_d8 && cnt_d4[1:0]==cnt_d8[1:0]) 
				data_in_1 <= enc_data_1;
			else  case(cnt_d4[1:0])
			0:  data_in_1 <= blk4_reg;
			1:  data_in_1 <= blk5_reg;
			2:  data_in_1 <= blk6_reg;
		    3:  data_in_1 <= blk7_reg;
			endcase
			
			
			
			
//			data_in_1 <= enc_data_1;
	
	reg		[127:0] qa_scratchpad_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST) 	qa_scratchpad_d1 <= 0;
		else	  	qa_scratchpad_d1 <= qa_scratchpad;
	//wire xor_newdata = (cnt_d1[W_CNT:3] % 10==0) ;
	wire xor_newdata = (cnt_rem10_d1==0) ;
	//reg		xor_newdata;
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	xor_newdata <= 0;
	//	else 		xor_newdata <= (cnt_rem10_d1==0) ;
	wire 	[127:0]	aes_data_in	=  xor_newdata? 	data_in ^ qa_scratchpad_d1 
									: data_in;

	wire xor_newdata_1 = (cnt_rem10_d5==0) ;
	//reg		xor_newdata;
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	xor_newdata <= 0;
	//	else 		xor_newdata <= (cnt_rem10_d1==0) ;
	wire 	[127:0]	aes_data_in_1	=  xor_newdata_1? 	data_in_1 ^ qa_scratchpad_d1 
									: data_in_1;
									
	always @(`CLK_RST_EDGE)
		if (`ZST) key_in <= 0;
	//	else case(cnt[W_CNT:3] % 10)
		else case(cnt_rem10)
			default: 	key_in <= k0;
			1:  key_in <= k1;
			2:  key_in <= k2;
			3:  key_in <= k3;
			4:  key_in <= k4;
			5:  key_in <= k5;
			6:  key_in <= k6;
		    7:  key_in <= k7;
		    8:  key_in <= k8;
		    9:  key_in <= k9;
		endcase	

	always @(`CLK_RST_EDGE)
		if (`ZST) key_in_1 <= 0;
	//	else case(cnt[W_CNT:3] % 10)
		else case(cnt_rem10_d4)
			default: 	key_in_1 <= k0;
			1:  key_in_1 <= k1;
			2:  key_in_1 <= k2;
			3:  key_in_1 <= k3;
			4:  key_in_1 <= k4;
			5:  key_in_1 <= k5;
			6:  key_in_1 <= k6;
		    7:  key_in_1 <= k7;
		    8:  key_in_1 <= k8;
		    9:  key_in_1 <= k9;
		endcase	
	
	
	aes_3clk aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(1'b1    				), 
		.data_in				(aes_data_in				),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	
	aes_3clk aes_ecb_enc1(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in_1					),	
		.data_en				(1'b1    				), 
		.data_in				(aes_data_in_1				),
		.enc_data_en			(enc_data_en_1			), 
		.enc_data				(enc_data_1				)
	);
	
	
	wire   go_sum = go | go_d1 |go_d2 |go_d3 |go_d4 |go_d5 | go_d6 | go_d7;
	always @(`CLK_RST_EDGE)
		if (`RST)   						cena_scratchpad <= 1;
		else if (go_sum) 					cena_scratchpad <= 0;
	//	else if (cnt_d6[W_CNT:3]%10 ==9) 	cena_scratchpad <= 0;
	//	else if (cnt_rem10_d2 ==9 || cnt_rem10_d6 ==9) 			cena_scratchpad <= 0;
		else 								cena_scratchpad <= 1;
	always @(`CLK_RST_EDGE)
		if (`RST)   				aa_scratchpad <= 0;
	//	else if (go)				aa_scratchpad <= 0;
		else if (~cena_scratchpad)	aa_scratchpad <= aa_scratchpad + 1;

	always @(`CLK_RST_EDGE)
		if (`RST) {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= 0;
		else if (ready_b1)
				 {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= {blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg};
	
	always @(`CLK_RST_EDGE)
		if (`RST) 				cenb_xout_buf <= 1;
		else if (cnt_max_f_d1)	cenb_xout_buf <= 0;
		else if (ab_xout_buf==7)cenb_xout_buf <= 1;
	always @(`CLK_RST_EDGE)
		if (`RST) 		ab_xout_buf <= 0;
		else 			ab_xout_buf <= !cenb_xout_buf? ab_xout_buf+1:0;
	always @(`CLK_RST_EDGE)
		if (`RST) 		db_xout_buf <= 0;
		else if (en_d4) db_xout_buf <= enc_data;
		else 			db_xout_buf <= enc_data_1;
		
	
				 
				 
endmodule




module data_hub(
		input											clk, 		
		input											rstn,

		input											init_datahub_req,   // just read
		input											loop1_datahub_req,	// write and read
		input											loop2_datahub_req,  // write and read maybe the last one dont read
		input											loop2_datahub_req_last,  // write and read maybe the last one dont read
		
		input											ex_datahub_req,	
		
		input											go_write_ex,	
		output reg		[`W_AMEM:0]						ex_wr_addr,
		
		input 			[`W_MEM	:0]						qa_scratchpad_ex,
		output	reg										cena_scratchpad_ex,
		output	reg		[4:0]							aa_scratchpad_ex,

		input 			[`W_MEM	:0]						qa_ex_buf,
		output	reg										cena_ex_buf,
		output	reg		[`W_AEXBUF:0]					aa_ex_buf,
		
		
		input											im_datahub_req,
		input			[`W_IDX:0] 						idx_im0,
		
		
		output reg										cena_init_rbuf,
		input			[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf,
		output reg		[`W_IDX:0]						aa_init_rbuf,
		
		
		output reg										cena_loop1_wbuf,
		input			[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop1_wbuf,
		output reg		[`W_IDX:0]						aa_loop1_wbuf,
		
		output reg										cena_loop1_rbuf,
		input			[`W_IDX+1+`W_AMEM:0]			qa_loop1_rbuf,
		output reg		[`W_IDX:0]						aa_loop1_rbuf,
		
		
		output reg										cenb_loop1_buf,
		output reg		[127:0]							db_loop1_buf,
		output reg		[`W_IDX:0]						ab_loop1_buf,

		
		output reg										cena_loop2_wbuf,
		input			[`W_IDX+1+`W_AMEM+1+127:0]		qa_loop2_wbuf,
		output reg		[`W_IDX:0]						aa_loop2_wbuf,
		
		output reg										cena_loop2_rbuf,
		input			[`W_IDX+1+`W_AMEM:0]			qa_loop2_rbuf,
		output reg		[`W_IDX:0]						aa_loop2_rbuf,
		
		output reg										cenb_loop2_buf,
		output reg		[127:0]							db_loop2_buf,
		output reg		[`W_IDX:0]						ab_loop2_buf,
		
		output reg										w_loop1_buf_ready,
		output reg										w_loop2_buf_ready,
		
		output reg										cenb_im_buf,
		output reg		[127:0]							db_im_buf,
		output reg		[`W_IDX+3:0]					ab_im_buf,
		output reg										w_im_buf_ready,
		

		output reg		[`W_AMEM:0]						imp_rd_addr,
		output reg		[`W_IDX:0]						im_rd_idx,
		output reg										cmd_go,
		output reg		[4:0]							cmd,
		output reg		[`W_EXTMWADDR :0] 				addr_i_to_sd,
		output reg		[`W_MEM:0]						data_i_to_sd,
		input			[`W_MEM:0]						data_o_from_sd,
		input											data_o_from_sd_f
		
	);
	
	parameter		S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15,S16=16,S17=17,S18=18,S19=19,S20=20,S21=21,S22=22,S23=23,S24=24,S25=25,S26=26,S27=27,S28=28,S29=29,S30=30,S31=31;
	reg		[3:0]	st_data_hub;
	
	reg		grant_init_req, grant_loop1_req,  grant_loop2_req, grant_im_req, grant_ex_req;
	reg		st_init_req_rdy, st_loop1_req_rdy, st_loop2_req_rdy, st_im_req_rdy, st_ex_req_rdy;
	
	reg		[ `W_IDX:0]	 st_init_req;
	reg		[ `W_IDX+1:0]	 st_loop1_req, st_loop2_req;
	reg		[ 5:0]	 st_imp_req;
	reg		[ 5:0]	 st_ex_req;
	reg				 go_loop1_req, go_loop2_req;
	reg		[1:0]	 go_init_req;
	reg		[1:0]	 go_imp_req;
	reg		[1:0]	 go_ex_req;
	always @(`CLK_RST_EDGE)
		if (`RST)					go_init_req <= 0;
		else case ({init_datahub_req, grant_init_req})
			2'b10: go_init_req <= go_init_req + 1;
			2'b01: go_init_req <= go_init_req - 1;
			endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)					go_loop1_req <= 0;
		else if (loop1_datahub_req)	go_loop1_req <= 1;
		else if (grant_loop1_req)	go_loop1_req <= 0;

	always @(`CLK_RST_EDGE)
		if (`RST)					go_loop2_req <= 0;
		else if (loop2_datahub_req)	go_loop2_req <= 1;
		else if (grant_loop2_req)	go_loop2_req <= 0;
				
	always @(`CLK_RST_EDGE)
		if (`RST)					go_imp_req <= 0;
		else case ({im_datahub_req, grant_im_req})
			2'b10: go_imp_req <= go_imp_req + 1;
			2'b01: go_imp_req <= go_imp_req - 1;
			endcase
	//	else if (im_datahub_req)	go_imp_req <= 1;
	//	else if (grant_im_req)		go_imp_req <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)					go_ex_req <= 0;
		else case ({ex_datahub_req, grant_ex_req})
			2'b10: go_ex_req <= go_ex_req + 1;
			2'b01: go_ex_req <= go_ex_req - 1;
			endcase
		

	always @(`CLK_RST_EDGE)
		if (`RST)  {st_data_hub, grant_init_req, grant_loop1_req,  grant_loop2_req, grant_im_req, grant_ex_req} <= 0;
		else case (st_data_hub)
			S0:  casex({go_ex_req !=0, go_init_req!=0, go_loop1_req, go_loop2_req, go_imp_req!=0})
				5'b1???? : begin grant_ex_req	   <= 1;  st_data_hub <= S1; end
				5'b01??? : begin grant_init_req    <= 1;  st_data_hub <= S2; end
				5'b001?? : begin grant_loop1_req   <= 1;  st_data_hub <= S3; end
				5'b0001? : begin grant_loop2_req   <= 1;  st_data_hub <= S4; end
				5'b00001 : begin grant_im_req	   <= 1;  st_data_hub <= S5; end
				endcase
			S1 : begin grant_ex_req      <= 0;  if (st_ex_req_rdy)	  st_data_hub <= S0; end		
			S2 : begin grant_init_req    <= 0;  if (st_init_req_rdy ) st_data_hub <= S0; end
			S3 : begin grant_loop1_req   <= 0;  if (st_loop1_req_rdy) st_data_hub <= S0; end
			S4 : begin grant_loop2_req   <= 0;  if (st_loop2_req_rdy) st_data_hub <= S0; end			
			S5 : begin grant_im_req      <= 0;  if (st_im_req_rdy)	  st_data_hub <= S0; end			
			endcase


			
	//always @(`CLK_RST_EDGE)
	//	if (`RST)  {st_data_hub, grant_init_req, grant_loop1_req,  grant_loop2_req, grant_im_req, grant_ex_req} <= 0;
	//	else case (st_data_hub)
	//		S0:  casex({go_init_req!=0, go_loop1_req, go_loop2_req, go_imp_req!=0, go_ex_req !=0})
	//			5'b1???? : begin grant_init_req    <= 1;  st_data_hub <= S1; end
	//			5'b01??? : begin grant_loop1_req   <= 1;  st_data_hub <= S2; end
	//			5'b001?? : begin grant_loop2_req   <= 1;  st_data_hub <= S3; end
	//			5'b0001? : begin grant_im_req	   <= 1;  st_data_hub <= S4; end
	//			5'b00001 : begin grant_ex_req	   <= 1;  st_data_hub <= S5; end
	//			endcase
	//		S1 : begin grant_init_req    <= 0;  if (st_init_req_rdy ) st_data_hub <= S0; end
	//		S2 : begin grant_loop1_req   <= 0;  if (st_loop1_req_rdy) st_data_hub <= S0; end
	//		S3 : begin grant_loop2_req   <= 0;  if (st_loop2_req_rdy) st_data_hub <= S0; end			
	//		S4 : begin grant_im_req      <= 0;  if (st_im_req_rdy)	  st_data_hub <= S0; end			
	//		S5 : begin grant_ex_req      <= 0;  if (st_ex_req_rdy)	  st_data_hub <= S0; end			
	//		endcase


			
//=============================================================================================	
	
`ifdef EX_IMPLODE_INSTANCE_4
	always @(*)		st_ex_req_rdy  = st_ex_req==32;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_ex_req <= 0;
		else if (grant_ex_req)		st_ex_req <= st_ex_req+1;
		else if (st_ex_req!=0)		st_ex_req <= st_ex_req==32? 0 : st_ex_req+1;	
	// 这个地方代码要优化
	always @(`CLK_RST_EDGE)
		if (`RST) 										cena_ex_buf <= 1;
		else if (st_ex_req>0&& st_ex_req<=32)			cena_ex_buf <= 0;
		else											cena_ex_buf <= 1;

`else
	always @(*)		st_ex_req_rdy  = st_ex_req==16;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_ex_req <= 0;
		else if (grant_ex_req)		st_ex_req <= st_ex_req+1;
		else if (st_ex_req!=0)		st_ex_req <= st_ex_req==16? 0 : st_ex_req+1;	
	always @(`CLK_RST_EDGE)
		if (`RST) 										cena_ex_buf <= 1;
		else if (st_ex_req>0&& st_ex_req<=16)			cena_ex_buf <= 0;
		else											cena_ex_buf <= 1;
`endif	
	
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_ex_buf <= 0;
		else if (!cena_ex_buf)						aa_ex_buf <= aa_ex_buf + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST) 					ex_wr_addr <= 0;
		else if (st_ex_req_rdy)	 	ex_wr_addr <= ex_wr_addr + 8;		
	
	reg			cena_ex_buf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST) 	cena_ex_buf_d1 <= 1;
		else 		cena_ex_buf_d1 <= cena_ex_buf;
	
	//wire		go_write_ex
	
//=============================================================================================	
	
	reg		cena_imp_rbuf;
`ifdef EX_IMPLODE_INSTANCE_4
	always @(*)		st_im_req_rdy  = st_imp_req==32;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_imp_req <= 0;
		else if (grant_im_req)		st_imp_req <= st_imp_req+1;
		else if (st_imp_req!=0)		st_imp_req <= st_imp_req==32? 0 : st_imp_req+1;	
	
	always @(`CLK_RST_EDGE)
		if (`RST) 									cena_imp_rbuf <= 1;
		else if (st_imp_req>0&& st_imp_req<=32)	cena_imp_rbuf <= 0;
		else										cena_imp_rbuf <= 1;	
`else
	always @(*)		st_im_req_rdy  = st_imp_req==16;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_imp_req <= 0;
		else if (grant_im_req)		st_imp_req <= st_imp_req+1;
		else if (st_imp_req!=0)		st_imp_req <= st_imp_req==16? 0 : st_imp_req+1;	
	
	always @(`CLK_RST_EDGE)
		if (`RST) 									cena_imp_rbuf <= 1;
		else if (st_imp_req>0&& st_imp_req<=16)		cena_imp_rbuf <= 0;
		else										cena_imp_rbuf <= 1;	
`endif		
	always @(`CLK_RST_EDGE)
		if (`RST) 					imp_rd_addr <= 0;
		else if (st_im_req_rdy)	 	imp_rd_addr <= imp_rd_addr + 8;			
	
	
	
		
	

//=============================================================================================	
	always @(*)		st_init_req_rdy  = st_init_req== `TASKN/2;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_init_req <= 0;
		else if (grant_init_req)	st_init_req <= st_init_req+1;
		else if (st_init_req!=0)	st_init_req <= st_init_req==`TASKN/2? 0 : st_init_req+1;	
	
	always @(`CLK_RST_EDGE)
		if (`RST) 										cena_init_rbuf <= 1;
		else if (st_init_req>0&& st_init_req<=`TASKN/2)	cena_init_rbuf <= 0;
		else											cena_init_rbuf <= 1;
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_init_rbuf <= 0;
		else if (!cena_init_rbuf)					aa_init_rbuf <= aa_init_rbuf + 1;
	//	else if (st_init_req>0&& st_init_req<=4)	aa_init_rbuf <= st_init_req-1;
	//	else										aa_init_rbuf <= 0;	
		
	reg		cena_init_rbuf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)		cena_init_rbuf_d1 <= 1;
		else			cena_init_rbuf_d1 <= cena_init_rbuf;
	
		
		
	//always @(`CLK_RST_EDGE)
	//	if (`RST) 		
	//	
	//	output reg										cena_int_rbuf,
	//	input			[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf,
	//	output reg		[`W_IDX:0]						aa_init_rbuf,		
//========================================================================================		
	always @(*)		st_loop1_req_rdy  = st_loop1_req==`TASKN;
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_loop1_req <= 0;
		else if (grant_loop1_req)	st_loop1_req <= st_loop1_req+1;
		else if (st_loop1_req!=0)	st_loop1_req <= st_loop1_req==`TASKN? 0 : st_loop1_req+1;			
	
	always @(`CLK_RST_EDGE)
		if (`RST) 											cena_loop1_wbuf <= 1;
		else if (st_loop1_req>0&& st_loop1_req<=`TASKN/2)	cena_loop1_wbuf <= 0;
		else												cena_loop1_wbuf <= 1;
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_loop1_wbuf <= 0;
		else if (!cena_loop1_wbuf)					aa_loop1_wbuf <= aa_loop1_wbuf + 1;
	//	else if (st_loop1_req>0&& st_loop1_req<=4)	aa_loop1_wbuf <= st_loop1_req-1;
	//	else										aa_loop1_wbuf <= 0;	
	always @(`CLK_RST_EDGE)
		if (`RST) 												cena_loop1_rbuf <= 1;
		else if (st_loop1_req>`TASKN/2&& st_loop1_req<=`TASKN)	cena_loop1_rbuf <= 0;
		else													cena_loop1_rbuf <= 1;
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_loop1_rbuf <= 0;
		else if (!cena_loop1_rbuf)					aa_loop1_rbuf <= aa_loop1_rbuf + 1;
	//	else if (st_loop1_req>4&& st_loop1_req<=8)	aa_loop1_rbuf <= st_loop1_req-5;
	//	else										aa_loop1_rbuf <= 0;	
		
	reg		cena_loop1_wbuf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)		cena_loop1_wbuf_d1 <= 1;
		else			cena_loop1_wbuf_d1 <= cena_loop1_wbuf;
	reg		cena_loop1_rbuf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)		cena_loop1_rbuf_d1 <= 1;
		else			cena_loop1_rbuf_d1 <= cena_loop1_rbuf;

//=============================================================	
	reg		[ 3:0]	 max_st_loop2_req;
	always @(`CLK_RST_EDGE)
		if (`RST)		max_st_loop2_req <= `TASKN;
		else			max_st_loop2_req <= loop2_datahub_req_last? `TASKN/2 : `TASKN;  
	
	
	//always @(*)		st_loop2_req_rdy  = st_loop2_req==max_st_loop2_req;
	always @(*)		st_loop2_req_rdy  = st_loop2_req==`TASKN;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 					st_loop2_req <= 0;
		else if (grant_loop2_req)	st_loop2_req <= st_loop2_req+1;
	//	else if (st_loop2_req!=0)	st_loop2_req <= st_loop2_req==max_st_loop2_req? 0 : st_loop2_req+1;			
		else if (st_loop2_req!=0)	st_loop2_req <= st_loop2_req==`TASKN? 0 : st_loop2_req+1;			
	
	always @(`CLK_RST_EDGE)
		if (`RST) 									cena_loop2_wbuf <= 1;
		else if (st_loop2_req>0&& st_loop2_req<=`TASKN/2)	cena_loop2_wbuf <= 0;
		else										cena_loop2_wbuf <= 1;
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_loop2_wbuf <= 0;
		else if (!cena_loop2_wbuf)					aa_loop2_wbuf <= aa_loop2_wbuf + 1;
	//	else if (st_loop2_req>0&& st_loop2_req<=4)	aa_loop2_wbuf <= st_loop2_req-1;
	//	else										aa_loop2_wbuf <= 0;	
	always @(`CLK_RST_EDGE)
		if (`RST) 									cena_loop2_rbuf <= 1;
		else if (st_loop2_req>`TASKN/2&& st_loop2_req<=`TASKN)	cena_loop2_rbuf <= 0;
		else										cena_loop2_rbuf <= 1;
	always @(`CLK_RST_EDGE)	
		if (`RST) 									aa_loop2_rbuf <= 0;
		else if (!cena_loop2_rbuf)					aa_loop2_rbuf <= aa_loop2_rbuf + 1;
	//	else if (st_loop2_req>4&& st_loop2_req<=8)	aa_loop2_rbuf <= st_loop2_req-5;
	//	else										aa_loop2_rbuf <= 0;	
		
	reg		cena_loop2_wbuf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)		cena_loop2_wbuf_d1 <= 1;
		else			cena_loop2_wbuf_d1 <= cena_loop2_wbuf;
	reg		cena_loop2_rbuf_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)		cena_loop2_rbuf_d1 <= 1;
		else			cena_loop2_rbuf_d1 <= cena_loop2_rbuf;		
		
		
		
		
	always @(`CLK_RST_EDGE)	
		if (`RST) 							data_i_to_sd <= 0;
		else if (!cena_loop1_wbuf_d1)		data_i_to_sd <= qa_loop1_wbuf;
		else if (!cena_loop2_wbuf_d1)		data_i_to_sd <= qa_loop2_wbuf;
		else if (!cena_ex_buf_d1)			data_i_to_sd <= qa_ex_buf;
		
		
	always @(`CLK_RST_EDGE)	
		if (`RST) 	addr_i_to_sd <= 0;
		else if (!cena_init_rbuf_d1)
				addr_i_to_sd <=  qa_init_rbuf[`W_IDX+1+`W_AMEM:0];
		else if (!cena_loop1_wbuf_d1)
					addr_i_to_sd <=  qa_loop1_wbuf[`W_IDX+1+`W_AMEM+1+127:128];
		else if (!cena_loop1_rbuf_d1)
					addr_i_to_sd <=  qa_loop1_rbuf[`W_IDX+1+`W_AMEM:0];
		
		else if (!cena_loop2_wbuf_d1)
					addr_i_to_sd <=  qa_loop2_wbuf[`W_IDX+1+`W_AMEM+1+127:128];
		else if (!cena_loop2_rbuf_d1)
					addr_i_to_sd <=  qa_loop2_rbuf[`W_IDX+1+`W_AMEM:0];
					
		

	reg										cmd_go_b2, cmd_go_b1;
	reg		[4:0]							cmd_b2, cmd_b1;
	
	//reg					go_write_ex_d1;
	//always @(`CLK_RST_EDGE)
	//	if (`RST)		go_write_ex_d1 <= 0;
	//	else			go_write_ex_d1 <= go_write_ex;
	//always @(`CLK_RST_EDGE)
	//	if (`RST) 						ex_wr_addr <= 0;
	//	else if (go_write_ex_d1)	 	ex_wr_addr <= ex_wr_addr + 8;			
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cmd_go_b1 <= 0;
		else		cmd_go_b1 <= cmd_go_b2;
	always @(`CLK_RST_EDGE)
		if (`RST)	cmd_b1 <= 0;
		else		cmd_b1 <= cmd_b2;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cmd_go <= 0;
	//	else		cmd_go <= cmd_go_b1 | go_write_ex;
		else		cmd_go <= cmd_go_b1;
	always @(`CLK_RST_EDGE)
		if (`RST)				cmd  <= 0;
	//	else if (go_write_ex)	cmd  <= 6;
		else					cmd  <= cmd_b1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cmd_go_b2 <= 0;
		else		cmd_go_b2 <= grant_init_req | grant_loop1_req | grant_loop2_req | grant_im_req | grant_ex_req;
//	always @(`CLK_RST_EDGE)
//		if (`RST) 		cmd_b2 <= 0;
//		else case (st_data_hub)
//			S0: cmd_b2 <= 0;
//			S1: cmd_b2 <= 1;
//			S2: cmd_b2 <= 2;
//			S3: cmd_b2 <= (loop2_datahub_req_last)? 4:3;
//			S4: cmd_b2 <= 5;
//			S5: cmd_b2 <= 6;
//			endcase
	always @(`CLK_RST_EDGE)
		if (`RST) 		cmd_b2 <= 0;
		else case (st_data_hub)
			S0: cmd_b2 <= 0;
			S1: cmd_b2 <= 6;
			S2: cmd_b2 <= 1;
			S3: cmd_b2 <= 2;
			S4: cmd_b2 <= (loop2_datahub_req_last)? 4:3;
			S5: cmd_b2 <= 5;
			endcase

			
	parameter W_QLIDX = `W_IDX+1;
	
	reg				[  1:0]	cur_due;
	reg		  				cur_refrow;
	reg						cur_lrr_f;
	reg			[W_QLIDX:0]	cur_lenidx;
	reg				[  7:0]	cur_rdlen;
	reg				[  7:0]	rdata_len;
	reg						rdata_ready;
	reg				[  1:0]	qu_rddue_newitem;
	reg			[W_QLIDX:0]	qu_rddue_lenidx;
	reg						qu_rddue_inc_f;
	reg						qu_rddue_dec_f_p1;
	reg						rdata_ready_p1;
	reg						rdata_ready_p2;

	reg			[W_QLIDX:0]		cnt_r_data;
	reg			[W_QLIDX:0]		cnt_r_data_d1;
	
	reg				[1:0]	qu_rddue0 , qu_rddue1 , qu_rddue2 , qu_rddue3 , qu_rddue4 , qu_rddue5 , qu_rddue6;
	reg		  [W_QLIDX:0]	qu_lenidx0, qu_lenidx1, qu_lenidx2, qu_lenidx3, qu_lenidx4, qu_lenidx5, qu_lenidx6;
	reg						qu_refrow0,qu_refrow1,qu_refrow2,qu_refrow3,qu_refrow4,qu_refrow5,qu_refrow6;
	//--------------------- lrf = last_refrow ----------------
	reg						qu_lrr_f0, qu_lrr_f1, qu_lrr_f2, qu_lrr_f3, qu_lrr_f4, qu_lrr_f5, qu_lrr_f6;
	reg				[2:0]	qu_rddue_nb;			// 0~7
	


	
	
	wire  qu_rddue_dec_f = (data_o_from_sd_f && cnt_r_data == 0);
		always @(`CLK_RST_EDGE)
		if (`ZST) 	qu_rddue_dec_f_p1 <= 0;
		else      	qu_rddue_dec_f_p1 <= qu_rddue_dec_f;
`ifdef SIMULATING
	    always @(*) begin
			if (0 == qu_rddue_nb && !qu_rddue_inc_f && qu_rddue_dec_f_p1) begin
				$display("[ERROR] qu_rddue_nb will be -1, downflow");
				#10 $finish;
			end
			if (8 == qu_rddue_nb && qu_rddue_inc_f && !qu_rddue_dec_f_p1) begin
				$display("[ERROR] qu_rddue_nb will be 9, overflow");
				#10 $finish;
			end
		end
`endif	
	always @(`CLK_RST_EDGE)
		if (`RST) 	qu_rddue_nb <= 0;
		else
			case({qu_rddue_inc_f, qu_rddue_dec_f_p1})
			2'b10: 	qu_rddue_nb <= qu_rddue_nb + 1;
			2'b01: 	qu_rddue_nb <= qu_rddue_nb - 1;
			endcase
		always @(*)
	case(qu_rddue_nb)
		default: {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue0, qu_lenidx0, qu_refrow0, qu_lrr_f0};
		2      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue1, qu_lenidx1, qu_refrow1, qu_lrr_f1};
		3      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue2, qu_lenidx2, qu_refrow2, qu_lrr_f2};
		4      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue3, qu_lenidx3, qu_refrow3, qu_lrr_f3};
		5      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue4, qu_lenidx4, qu_refrow4, qu_lrr_f4};
		6      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue5, qu_lenidx5, qu_refrow5, qu_lrr_f5};
		7      : {cur_due, cur_lenidx, cur_refrow, cur_lrr_f} = {qu_rddue6, qu_lenidx6, qu_refrow6, qu_lrr_f6};
		endcase		
	
	always @(`CLK_RST_EDGE)
		if (`RST) begin
			{qu_rddue0, qu_rddue1, qu_rddue2, qu_rddue3, qu_rddue4, qu_rddue5, qu_rddue6} <= 0;
			{qu_lenidx0, qu_lenidx1, qu_lenidx2, qu_lenidx3, qu_lenidx4, qu_lenidx5, qu_lenidx6} <= 0;
	//		{qu_refrow0,qu_refrow1,qu_refrow2,qu_refrow3,qu_refrow4,qu_refrow5,qu_refrow6} <= 0;
	//		{qu_lrr_f0, qu_lrr_f1, qu_lrr_f2, qu_lrr_f3, qu_lrr_f4, qu_lrr_f5, qu_lrr_f6} <= 0;
		end else if (qu_rddue_inc_f) begin
			{qu_rddue0 , qu_rddue1 , qu_rddue2 , qu_rddue3 , qu_rddue4 , qu_rddue5 , qu_rddue6 } <= {qu_rddue_newitem, qu_rddue0 , qu_rddue1 , qu_rddue2 , qu_rddue3 , qu_rddue4 , qu_rddue5 };
			{qu_lenidx0, qu_lenidx1, qu_lenidx2, qu_lenidx3, qu_lenidx4, qu_lenidx5, qu_lenidx6} <= {qu_rddue_lenidx , qu_lenidx0, qu_lenidx1, qu_lenidx2, qu_lenidx3, qu_lenidx4, qu_lenidx5};
	//		{qu_refrow0, qu_refrow1, qu_refrow2, qu_refrow3, qu_refrow4, qu_refrow5, qu_refrow6} <= {ref_row_idx_s0  , qu_refrow0, qu_refrow1, qu_refrow2, qu_refrow3, qu_refrow4, qu_refrow5};
	//		{qu_lrr_f0 , qu_lrr_f1 , qu_lrr_f2 , qu_lrr_f3 , qu_lrr_f4 , qu_lrr_f5 , qu_lrr_f6 } <= {last_refrow_f_s0, qu_lrr_f0 , qu_lrr_f1 , qu_lrr_f2 , qu_lrr_f3 , qu_lrr_f4 , qu_lrr_f5 };
		end		
		
		
	always @(`CLK_RST_EDGE)
		if (`ZST) 	qu_rddue_inc_f <= 0;
		else		qu_rddue_inc_f <= grant_init_req | grant_loop1_req | ( grant_loop2_req & !loop2_datahub_req_last) |grant_im_req ;
		
	always @(`CLK_RST_EDGE)
		if (`RST) 					qu_rddue_newitem <= 0;
		else case({grant_init_req, grant_loop1_req, grant_loop2_req, grant_im_req})
			4'b1000 : begin qu_rddue_newitem = 0; qu_rddue_lenidx <= `TASKN/2-1; end
			4'b0100 : begin qu_rddue_newitem = 1; qu_rddue_lenidx <= `TASKN/2-1; end
			4'b0010 : begin qu_rddue_newitem = 2; qu_rddue_lenidx <= `TASKN/2-1; end
`ifdef EX_IMPLODE_INSTANCE_4
			4'b0001 : begin qu_rddue_newitem = 3; qu_rddue_lenidx <= 32-1; end
`else
			4'b0001 : begin qu_rddue_newitem = 3; qu_rddue_lenidx <= 16-1; end
`endif
			endcase
	always @(`CLK_RST_EDGE)
		if (`RST)					 rdata_len <= -1;
		else if (qu_rddue_dec_f_p1)  rdata_len <= cur_lenidx;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 					cnt_r_data <= 0;
		else if (data_o_from_sd_f)	cnt_r_data <= (cnt_r_data == rdata_len) ? 0 : (cnt_r_data + 1);
		
	always @(*) 	rdata_ready = (cnt_r_data == rdata_len) && data_o_from_sd_f;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)		cnt_r_data_d1 <= 0;
		else			cnt_r_data_d1 <= cnt_r_data;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 	{rdata_ready_p1, rdata_ready_p2} <= 0;
		else      	{rdata_ready_p1, rdata_ready_p2} <= {rdata_ready, rdata_ready_p1};
	
	
	
	reg		w_loop1_buf_go, w_loop2_buf_go, w_im_buf_go;
	always @(`CLK_RST_EDGE)
		if (`RST) { w_loop1_buf_go, w_loop2_buf_go, w_im_buf_go } <= 0;
		else begin 
			w_loop1_buf_go <= qu_rddue_dec_f & ( cur_due==0 || cur_due==2 );
			w_loop2_buf_go <= qu_rddue_dec_f & ( cur_due==1 );
			w_im_buf_go <= qu_rddue_dec_f & ( cur_due==3 );
		end
	reg			unset_w_cache_f;
	always @(`CLK_RST_EDGE)
		if (`ZST) 	unset_w_cache_f <= 0;
		else      	unset_w_cache_f <= rdata_ready_p1;
	
	reg			[`W_MEM:0]		data_o_from_sd_p1;
	reg							data_o_from_sd_f_p1;

	always @(`CLK_RST_EDGE)
		if (`RST)		{data_o_from_sd_p1, data_o_from_sd_f_p1} <= 0;
		else			{data_o_from_sd_p1, data_o_from_sd_f_p1} <= {data_o_from_sd, data_o_from_sd_f};
			
	always @(`CLK_RST_EDGE)
		if (`RST)                 cenb_loop1_buf <= 1;
		else if (w_loop1_buf_go ) cenb_loop1_buf <= 0;
		else if (unset_w_cache_f) cenb_loop1_buf <= 1;

	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop1_buf <= 0;
		else			db_loop1_buf <= data_o_from_sd_p1;

	reg		loop1_buf_wid;
	always @(`CLK_RST_EDGE)
		if (`RST)											loop1_buf_wid <= 0;
		else if ((!cenb_loop1_buf) & unset_w_cache_f)		loop1_buf_wid <= loop1_buf_wid + 1;
	reg			[`W_IDX-1:0]	ab_loop1_buf_tmp;
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop1_buf_tmp <= 0;
		else 						ab_loop1_buf_tmp <= cnt_r_data_d1;
	always @(*)	ab_loop1_buf = {loop1_buf_wid, ab_loop1_buf_tmp};

	
//	always @(`CLK_RST_EDGE)
//		if (`RST)					ab_loop1_buf <= 0;
//		else if (!cenb_loop1_buf)	ab_loop1_buf <= ab_loop1_buf + 1;
	
//	always @(*)
//			w_loop1_buf_ready = (!cenb_loop1_buf) & unset_w_cache_f;
//	always @(`CLK_RST_EDGE)
//		if (`RST)					w_loop1_buf_ready <= 0;
//		else 						w_loop1_buf_ready <= (!cenb_loop1_buf) & unset_w_cache_f;
	always @(*)
			w_loop1_buf_ready = (!cenb_loop1_buf) & rdata_ready;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)                 cenb_loop2_buf <= 1;
		else if (w_loop2_buf_go ) cenb_loop2_buf <= 0;
		else if (unset_w_cache_f) cenb_loop2_buf <= 1;

	always @(`CLK_RST_EDGE)
		if (`RST)		db_loop2_buf <= 0;
		else			db_loop2_buf <= data_o_from_sd_p1;
	
	reg		loop2_buf_wid;
	always @(`CLK_RST_EDGE)
		if (`RST)											loop2_buf_wid <= 0;
		else if ((!cenb_loop2_buf) & unset_w_cache_f)		loop2_buf_wid <= loop2_buf_wid + 1;
	reg			[`W_IDX-1:0]	ab_loop2_buf_tmp;
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_loop2_buf_tmp <= 0;
		else 						ab_loop2_buf_tmp <= cnt_r_data_d1;
	always @(*)	ab_loop2_buf = {loop2_buf_wid, ab_loop2_buf_tmp};
	
//	always @(`CLK_RST_EDGE)
//		if (`RST)					ab_loop2_buf <= 0;
//	//	else if (!cenb_loop2_buf)	ab_loop2_buf <= ab_loop2_buf + 1;
//		else 						ab_loop2_buf <= cnt_r_data_d1;

	always @(*)
			w_loop2_buf_ready = (!cenb_loop2_buf) & rdata_ready;	
			
//	always @(*)
//			w_loop2_buf_ready = (!cenb_loop2_buf) & unset_w_cache_f;
//	always @(`CLK_RST_EDGE)
//		if (`RST)					w_loop2_buf_ready <= 0;
//		else 						w_loop2_buf_ready <= (!cenb_loop2_buf) & unset_w_cache_f;


		
	always @(`CLK_RST_EDGE)
		if (`RST)                 cenb_im_buf <= 1;
		else if (w_im_buf_go ) 	  cenb_im_buf <= 0;
		else if (unset_w_cache_f) cenb_im_buf <= 1;

	always @(`CLK_RST_EDGE)
		if (`RST)		db_im_buf <= 0;
		else			db_im_buf <= data_o_from_sd_p1;

`ifdef EX_IMPLODE_INSTANCE_4
	reg		[`W_IDX+3-2-3:0]				im_buf_wid;
	//reg			[`W_IDX+3-1:0]	ab_im_buf_tmp;		
	reg		[2+2:0]			ab_im_buf_tmp;		
`else
	//reg		[1:0]			im_buf_wid;
	reg		[`W_IDX+3-2-2:0]			im_buf_wid;
	reg		[2+1:0]			ab_im_buf_tmp;		
`endif	
	always @(`CLK_RST_EDGE)
		if (`RST)											im_buf_wid <= 0;
		else if ((!cenb_im_buf) & unset_w_cache_f)		im_buf_wid <= im_buf_wid + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)					ab_im_buf_tmp <= 0;
		else 						ab_im_buf_tmp <= cnt_r_data_d1;
	always @(*)	ab_im_buf = {im_buf_wid, ab_im_buf_tmp};
	
		
	// always @(`CLK_RST_EDGE)
		// if (`RST)					ab_im_buf <= 0;
		// else if (!cenb_im_buf)		ab_im_buf <= ab_im_buf + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)					w_im_buf_ready <= 0;
		else 						w_im_buf_ready <= (!cenb_im_buf) & unset_w_cache_f;

			
endmodule


`ifdef IDEAL_EXTMEM

module extm_controller (
	input								clk, 
	input								rstn,
	input								cmd_go,
	input			[4:0]				cmd,
	
	input			[`W_AMEM:0]			imp_rd_addr,
	input			[`W_IDX:0]			im_rd_idx,
	
	input			[`W_AMEM:0]			ex_wr_addr,
	input			[`W_IDX:0]			ex_wr_idx,
	
	input								go_write_ex,
	
	input 			[`W_MEM	:0]			db_scratchpad_ex,
	input								cenb_scratchpad_ex,
	input			[`W_EXTMWADDR:0]	ab_scratchpad_ex,
	
	
	input			[`W_EXTMWADDR :0] 	addr_i_to_sd,
	input			[`W_MEM:0]			data_i_to_sd,
	output reg		[`W_MEM:0]			data_o_from_sd,
	output reg							data_o_from_sd_f,
	
	output    	[`W_EXTMWADDR :0] 		extm_a,			// Word Address ExtMem
	output    	[`W_SDD       :0]		extm_d,			// writing data to ExtMem
	input		[`W_SDD       :0]		extm_q,	
	output    							extm_ren,		// read-enable to ExtMem, high enable
	output    							extm_wen,		// write-enable to ExtMem, high enable
	input								extm_af_afull,
	input								extm_qv,		// valid signal of extm_q			
	output								extm_brst,		// begin of a burst
	output			[ 5:0]				extm_brst_len,	// real burst length = extm_brst_len + 1
	output								extm_clk		
	);
	
	
	assign extm_clk = clk;
	
	reg				cnt_en;
	reg		[5:0]	cnt;
	//reg				doing_init_req, doing_loop1_req, doing_loop2_req;
	reg				doing_init_req, doing_loop1_req, doing_loop2_req, doing_loop2_req_last, doing_im_req,  doing_ex_req;
	reg				cnt_ma_f;
	
	always @(`CLK_RST_EDGE)
        if (`RST) 		 	{doing_init_req, doing_loop1_req, doing_loop2_req} <= 0;
		else if (cmd_go) begin
			if (cmd == 1)  			begin	doing_init_req <= 1; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 4) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 1;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 2) 		begin	doing_init_req <= 0; doing_loop1_req <= 1; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 5) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 1; doing_ex_req<= 0;  end
			else if (cmd == 6) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 1;  end
			else 					begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 1;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
		end
	always @(*)
	
        if (doing_init_req) 			cnt_ma_f = cnt== (`TASKN/2 - 1);
        else if (doing_loop1_req) 		cnt_ma_f = cnt== (`TASKN - 1);
        else if (doing_loop2_req) 		cnt_ma_f = cnt== (`TASKN - 1);
		else if (doing_loop2_req_last)	cnt_ma_f = cnt== (`TASKN/2 - 1);
`ifdef EX_IMPLODE_INSTANCE_4
		else if (doing_im_req)			cnt_ma_f = cnt==31;
		else if (doing_ex_req)			cnt_ma_f = cnt==31;
`else
		else if (doing_im_req)			cnt_ma_f = cnt==15;
		else if (doing_ex_req)			cnt_ma_f = cnt==15;
`endif
		else 							cnt_ma_f = cnt== (`TASKN/2 - 1);
	
	always @(`CLK_RST_EDGE)
        if (`RST) 		 	cnt_en <= 0;
		else if (cmd_go)	cnt_en <= 1;
		else if (cnt_ma_f)  cnt_en <= 0;
	always @(`CLK_RST_EDGE)
        if (`RST) 			cnt <= 0;
		else if (cnt_en)	cnt <= cnt + 1;
		else 				cnt <= 0;
		
	reg				[`W_AMEM:0]			imp_rd_addr_reg;
	reg				[`W_IDX:0]			im_rd_idx_reg;
	always @(`CLK_RST_EDGE)
        if (`RST)			{imp_rd_addr_reg, im_rd_idx_reg } <= 0;
		else if (cmd_go)	{imp_rd_addr_reg, im_rd_idx_reg } <= {imp_rd_addr, im_rd_idx };
	
	reg			[`W_AMEM:0]			ex_wr_addr_reg;
	reg			[`W_IDX:0]			ex_wr_idx_reg;
	reg			[127:0]				db_scratchpad_ex_d1;
	always @(`CLK_RST_EDGE)
        if (`RST)			{ex_wr_addr_reg, ex_wr_idx_reg } <= 0;
		else if (cmd_go)	{ex_wr_addr_reg, ex_wr_idx_reg } <= {ex_wr_addr, ex_wr_idx};
	always @(`CLK_RST_EDGE)
        if (`RST)			db_scratchpad_ex_d1 <= 0;
		else 				db_scratchpad_ex_d1 <= db_scratchpad_ex;
		
		
		
	
	reg				[`W_EXTMWADDR:0] 	extm_1x_a;
	reg				[`W_MEM      :0]	extm_1x_d;
	reg									extm_1x_ren;
	reg									extm_1x_wen;

	
	always @(`CLK_RST_EDGE)
        if (`RST)				extm_1x_a <= 0;
`ifdef EX_IMPLODE_INSTANCE_4
		else if (doing_im_req)	extm_1x_a <= {im_rd_idx_reg[`W_IDX:2], cnt[4:3], imp_rd_addr_reg[`W_AMEM:3], cnt[2:0] };
		else if (doing_ex_req)	extm_1x_a <= {ex_wr_idx_reg[`W_IDX:2], cnt[4:3], ex_wr_addr_reg[`W_AMEM:3], cnt[2:0] };
`else
		else if (doing_im_req)	extm_1x_a <= {im_rd_idx_reg[`W_IDX:1], cnt[3], imp_rd_addr_reg[`W_AMEM:3], cnt[2:0] };
		else if (doing_ex_req)	extm_1x_a <= {ex_wr_idx_reg[`W_IDX:1], cnt[3], ex_wr_addr_reg[`W_AMEM:3], cnt[2:0] };
`endif
		else 					extm_1x_a <= addr_i_to_sd;
	//	else 					extm_1x_a <= !cenb_scratchpad_ex? ab_scratchpad_ex : addr_i_to_sd;
		
	always @(`CLK_RST_EDGE)
        if (`RST)				extm_1x_wen <= 0;
		else if (doing_ex_req)	extm_1x_wen <= cnt_en;
		else 					extm_1x_wen <= cnt_en & (doing_loop1_req | doing_loop2_req | doing_loop2_req_last) & (cnt<`TASKN/2);		
	//	else 					extm_1x_wen <= !cenb_scratchpad_ex || cnt_en & (doing_loop1_req | doing_loop2_req | doing_loop2_req_last) & (cnt<4);		
	
	always @(`CLK_RST_EDGE)
        if (`RST)				extm_1x_ren <= 0;
		else if (doing_im_req)	extm_1x_ren <= cnt_en;
		else 					extm_1x_ren <= cnt_en & ( (doing_loop1_req | doing_loop2_req) & (cnt>=`TASKN/2) || doing_init_req) ;		
	
	always @(`CLK_RST_EDGE)
        if (`RST)				extm_1x_d <= 0;
	//	else if (doing_ex_req)	extm_1x_d <= db_scratchpad_ex_d1;
		else 					extm_1x_d <= data_i_to_sd;
	//	else 					extm_1x_d <= !cenb_scratchpad_ex?  db_scratchpad_ex : data_i_to_sd;
	


`ifdef EXTMEM_W64
	// use a fifo to convert
	// 128 --> 64 
	// 64 --> 128  
	
	wire		wr_en = extm_1x_ren | extm_1x_wen;
	ideal_write_FIFO ideal_write_FIFO (
		.clk				(clk		),
		.rstn               (rstn       ),
		.wr_en              (wr_en      ),
		.extm_1x_ren        (extm_1x_ren),          
		.extm_1x_wen        (extm_1x_wen),           
		.extm_1x_a          (extm_1x_a  ),      
		.extm_1x_d          (extm_1x_d  ),    
		.extm_ren           (extm_ren   ),       
		.extm_wen           (extm_wen   ),        
		.extm_a             (extm_a     ),   
		.extm_d             (extm_d     )
	);
	
	reg		[`W_MEM :0]			extm_1x_q;
	reg							extm_1x_qv;
	reg							extm_qv_toggle;
	reg		[`W_SDD :0]			extm_q_d1;
	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_qv_toggle <= 0;
		else if (extm_qv)	extm_qv_toggle <= extm_qv_toggle + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_q_d1 <= 0;
		else if (extm_qv)	extm_q_d1 <= extm_q;

	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_1x_qv <= 0;
		else 				extm_1x_qv <= extm_qv & extm_qv_toggle;

	always @(`CLK_RST_EDGE)
		if (`RST) 					extm_1x_q <= 0;
		else if (extm_qv & extm_qv_toggle)
									extm_1x_q <= {extm_q, extm_q_d1};
		
`else		
	wire			[`W_MEM      :0]	extm_1x_q;
	wire								extm_1x_qv;
	
	assign  extm_1x_q   = extm_q;
	assign  extm_1x_qv  = extm_qv;
	assign  extm_a      = extm_1x_a;
	assign  extm_d      = extm_1x_d;
	assign  extm_ren    = extm_1x_ren;
	assign  extm_wen    = extm_1x_wen;
	assign  extm_brst   = 1'b0;
	assign  extm_brst_len = 6'b0;	
`endif

	always @(`CLK_RST_EDGE)
		if (`ZST) 	{data_o_from_sd, data_o_from_sd_f} <= 0;
		else      	{data_o_from_sd, data_o_from_sd_f} <= {extm_1x_q, extm_1x_qv};	
		
endmodule



`ifdef EXTMEM_W64

module ideal_write_FIFO (
	input								clk,
	input								rstn,
	input								wr_en,
	input	  			       			extm_1x_ren,                  
	input	  			       			extm_1x_wen,                   
	input	  		[`W_EXTMWADDR :0] 	extm_1x_a,                
	input	  		[`W_MEM       :0]	extm_1x_d,              

	output reg 			       			extm_ren,                  
	output reg 			       			extm_wen,                   
	output reg 		[`W_EXTMWADDR :0] 	extm_a,                
	output reg 		[`W_SDD       :0]	extm_d             
	);
	parameter MAX_ADDR_DDRCFIFO = 128;
	`define APP_CMD_COMBAIN {extm_ren, extm_wen, extm_a, extm_d}
	wire	[255:0]		db_cmd_fifo = {extm_1x_ren, extm_1x_wen, extm_1x_a, extm_1x_d};
	reg		[  7:0]		ab_cmd_fifo;
	reg		[  7:0]		aa_cmd_fifo;
	reg		[255:0]		qa_cmd_fifo, qa_cmd_fifo_d1;
	reg					wr_en_d1;
	
	always @(`CLK_RST_EDGE)
        if (`RST)			            ab_cmd_fifo <= 0;
        else if (wr_en) 				ab_cmd_fifo <= ab_cmd_fifo + 1;
		
	always @(`CLK_RST_EDGE)
        if (`RST)				qa_cmd_fifo_d1 <= 0;
		else					qa_cmd_fifo_d1 <= qa_cmd_fifo;

	always @(`CLK_RST_EDGE)
        if (`RST)			    wr_en_d1 <= 0;
        else 					wr_en_d1 <= wr_en;
			
	
	reg                     [ 8:0]  	fifo0_semaphore;
	wire                            	fifo0_rdreq = (fifo0_semaphore != 0);
	reg									fifo0_rdreq_p1;
	always @(`CLK_RST_EDGE)
        if (`RST)	fifo0_semaphore <= 0;
		else case({wr_en_d1, fifo0_rdreq})
`ifdef EXTMEM_W64
			2'b10: fifo0_semaphore <= fifo0_semaphore + 2;
            2'b01: fifo0_semaphore <= fifo0_semaphore - 1;		
            2'b11: fifo0_semaphore <= fifo0_semaphore + 1;	
`else
			2'b10: fifo0_semaphore <= fifo0_semaphore + 1;
            2'b01: fifo0_semaphore <= fifo0_semaphore - 1;			
`endif			
			endcase
`ifdef SIMULATING
    always @(*) if (fifo0_semaphore == MAX_ADDR_DDRCFIFO*2) begin
        $display("[ERROR] fifo_ddrc for Altera ddr3 controller is FULL !");
        #20 $finish;
    end    
`endif			
	reg		fifo_read_toggle, fifo_read_toggle_d1;
	
	always @(`CLK_RST_EDGE)
        if (`RST)  				fifo_read_toggle <= 0;
        else if (fifo0_rdreq)	fifo_read_toggle <= fifo_read_toggle+1;
	always @(`CLK_RST_EDGE)
        if (`RST) 	fifo_read_toggle_d1 <= 0;
		else 		fifo_read_toggle_d1 <= fifo_read_toggle;
	always @(`CLK_RST_EDGE)
        if (`RST)  				fifo0_rdreq_p1 <= 0;
        else      				fifo0_rdreq_p1 <= fifo0_rdreq;
	always @(`CLK_RST_EDGE)
        if (`RST) 									aa_cmd_fifo <= 0;
		else if (fifo0_rdreq & fifo_read_toggle)	aa_cmd_fifo <= aa_cmd_fifo + 1;
		
	rfdp128x256 cmd_fifo(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(~wr_en),
		.DB		(db_cmd_fifo	),
		.AB		(ab_cmd_fifo	),
		.CENA	(1'b0),
		.QA		(qa_cmd_fifo	),
	    .AA		(aa_cmd_fifo	)
	);
	
	wire	  			       			extm_1x_ren_rd;                 
	wire	  			       			extm_1x_wen_rd;                
	wire	  		[`W_EXTMWADDR :0] 	extm_1x_a_rd;           
	wire	  		[`W_MEM       :0]	extm_1x_d_rd;   
	
	
	assign 	{extm_1x_ren_rd, extm_1x_wen_rd, extm_1x_a_rd, extm_1x_d_rd} = qa_cmd_fifo;
	always @(*)
       if (`RST)             
			`APP_CMD_COMBAIN = 0;
        else if (fifo0_rdreq_p1)
			if (!fifo_read_toggle_d1) begin
				extm_ren = extm_1x_ren_rd;
				extm_wen = extm_1x_wen_rd;
				extm_a = extm_1x_a_rd *2;
				extm_d = extm_1x_d_rd[`W_SDD :0];
			end else begin
				extm_ren = extm_1x_ren_rd;
				extm_wen = extm_1x_wen_rd;
				extm_a = extm_1x_a_rd *2 + 1;
				extm_d = extm_1x_d_rd[`W_MEM : `W_SDD+1];	
			end
		else
			`APP_CMD_COMBAIN = 0;
endmodule

`endif


`else

module extm_controller (
	input								clk, 
	input								rstn,
	input								cmd_go,
	input			[4:0]				cmd,
	
	input			[`W_AMEM:0]			imp_rd_addr,
	input			[`W_IDX:0]			im_rd_idx,
	
	input			[`W_AMEM:0]			ex_wr_addr,
	input			[`W_IDX:0]			ex_wr_idx,
	
	input								go_write_ex,
	
	input 			[`W_MEM	:0]			db_scratchpad_ex,
	input								cenb_scratchpad_ex,
	input			[`W_EXTMWADDR:0]	ab_scratchpad_ex,
	
	
	input			[`W_EXTMWADDR :0] 	addr_i_to_sd,
	input			[`W_MEM:0]			data_i_to_sd,
	output reg		[`W_MEM:0]			data_o_from_sd,
	output reg							data_o_from_sd_f,
	
	
	
	output  			       			amm_burstbegin,                   
	output  			       			amm_read,                   
	output  			       			amm_write,                  
	output  		[`W_EXTMWADDR :0] 	amm_address,                
	output  		[`W_SDD       :0]	amm_writedata,              
	output  		[6:0]  				amm_burstcount,             
	output  			       			ctrl_auto_precharge_req,
	
	input 			       				amm_ready,                  
	input 			[`W_SDD       :0]	amm_readdata,               
	input 			       				amm_readdatavalid      

	);
	
	
	reg				cnt_en;
	reg		[5:0]	cnt;
	//reg				doing_init_req, doing_loop1_req, doing_loop2_req;
	reg				doing_init_req, doing_loop1_req, doing_loop2_req, doing_loop2_req_last, doing_im_req,  doing_ex_req;
	reg				cnt_ma_f;
	
	always @(`CLK_RST_EDGE)
        if (`RST) 		 	{doing_init_req, doing_loop1_req, doing_loop2_req} <= 0;
		else if (cmd_go) begin
			if (cmd == 1)  			begin	doing_init_req <= 1; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 4) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 1;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 2) 		begin	doing_init_req <= 0; doing_loop1_req <= 1; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
			else if (cmd == 5) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 1; doing_ex_req<= 0;  end
			else if (cmd == 6) 		begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 0;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 1;  end
			else 					begin	doing_init_req <= 0; doing_loop1_req <= 0; doing_loop2_req<= 1;  doing_loop2_req_last<= 0;  doing_im_req<= 0; doing_ex_req<= 0;  end
		end
	always @(*)
        if (doing_init_req) 			cnt_ma_f = cnt==(`TASKN/2 - 1);
        else if (doing_loop1_req) 		cnt_ma_f = cnt==(`TASKN - 1);
        else if (doing_loop2_req) 		cnt_ma_f = cnt==(`TASKN - 1);
		else if (doing_loop2_req_last)	cnt_ma_f = cnt==(`TASKN/2 - 1);
`ifdef EX_IMPLODE_INSTANCE_4
		else if (doing_im_req)			cnt_ma_f = cnt==3;
		else if (doing_ex_req)			cnt_ma_f = cnt==31;
`else
		else if (doing_im_req)			cnt_ma_f = cnt==1;
		else if (doing_ex_req)			cnt_ma_f = cnt==15;
`endif
		else 							cnt_ma_f = cnt== (`TASKN/2 - 1);
	
	always @(`CLK_RST_EDGE)
        if (`RST) 		 	cnt_en <= 0;
		else if (cmd_go)	cnt_en <= 1;
		else if (cnt_ma_f)  cnt_en <= 0;
	always @(`CLK_RST_EDGE)
        if (`RST) 			cnt <= 0;
		else if (cnt_en)	cnt <= cnt + 1;
		else 				cnt <= 0;
		
	reg				[`W_AMEM:0]			imp_rd_addr_reg;
	reg				[`W_IDX:0]			im_rd_idx_reg;
	always @(`CLK_RST_EDGE)
        if (`RST)			{imp_rd_addr_reg, im_rd_idx_reg } <= 0;
		else if (cmd_go)	{imp_rd_addr_reg, im_rd_idx_reg } <= {imp_rd_addr, im_rd_idx };
	
	reg			[`W_AMEM:0]			ex_wr_addr_reg;
	reg			[`W_IDX:0]			ex_wr_idx_reg;
	reg			[127:0]				db_scratchpad_ex_d1;
	always @(`CLK_RST_EDGE)
        if (`RST)			{ex_wr_addr_reg, ex_wr_idx_reg } <= 0;
		else if (cmd_go)	{ex_wr_addr_reg, ex_wr_idx_reg } <= {ex_wr_addr, ex_wr_idx};
	always @(`CLK_RST_EDGE)
        if (`RST)			db_scratchpad_ex_d1 <= 0;
		else 				db_scratchpad_ex_d1 <= db_scratchpad_ex;
		
		
	reg								wr_en;
	reg	  			       			amm_read_wr;                   
	reg	  			       			amm_write_wr;                  
	reg	  		[`W_EXTMWADDR :0] 	amm_address_wr;                
	reg	  		[`W_MEM       :0]	amm_writedata_wr;              
	reg	  		[6:0]  				amm_burstcount_wr;             
	reg	  			       			ctrl_auto_precharge_req_wr;
	
	reg	  			       			amm_burstbegin_wr;
	
	always @(`CLK_RST_EDGE)
        if (`RST)								ctrl_auto_precharge_req_wr <= 0;
		else if (doing_ex_req|doing_im_req)		ctrl_auto_precharge_req_wr <= 0;
		else 									ctrl_auto_precharge_req_wr <= 1;
	


	always @(`CLK_RST_EDGE)
        if (`RST)						wr_en <= 0;
		else if (doing_init_req)		wr_en <= cnt_en;
		else if (doing_loop1_req)		wr_en <= cnt_en;
		else if (doing_loop2_req)		wr_en <= cnt_en;
		else if (doing_loop2_req_last)	wr_en <= cnt_en;
		else if (doing_im_req)			wr_en <= cnt_en;
		else if (doing_ex_req)			wr_en <= cnt_en;
		else							wr_en <= 0;

	always @(`CLK_RST_EDGE)
        if (`RST)						amm_address_wr <= 0;
`ifdef EXTMEM_W64
	// ROW BANK COLUMN     15  3   10
	// for 8x              15  3   6 // -3 for 8burst -1 for 128bit/64bit
	//              W_AMEM    idx  W_AMEM
	else if (doing_ex_req)			amm_address_wr <= { ex_wr_addr_reg[`W_AMEM:6], ex_wr_idx_reg[`W_IDX:1], cnt[3],  ex_wr_addr_reg[3+2:3], 3'h0 };
	else if (doing_im_req)			amm_address_wr <= { imp_rd_addr_reg[`W_AMEM:6], im_rd_idx_reg[`W_IDX:1], cnt[0], imp_rd_addr_reg[3+2:3], 3'h0  };
	else 							amm_address_wr <= {addr_i_to_sd[`W_AMEM:6], addr_i_to_sd[ `W_AMEM+1 + `W_IDX: `W_AMEM+1], addr_i_to_sd[5:0]};
	
`else
	`ifdef EX_IMPLODE_INSTANCE_4
			// ROW BANK COLUMN     15  3   10
		// for 8x              15  3   7 // -3 for 8burst 
		//              W_AMEM    idx  W_AMEM
		
		else if (doing_ex_req)			amm_address_wr <= { ex_wr_addr_reg[`W_AMEM:7], ex_wr_idx_reg[`W_IDX:2], cnt[4:3],  ex_wr_addr_reg[3+3:3], 3'h0 };
		else if (doing_im_req)			amm_address_wr <= { imp_rd_addr_reg[`W_AMEM:7], im_rd_idx_reg[`W_IDX:2], cnt[1:0], imp_rd_addr_reg[3+3:3], 3'h0  };
		else 							amm_address_wr <= {addr_i_to_sd[`W_AMEM:7], addr_i_to_sd[ `W_AMEM+1 + `W_IDX: `W_AMEM+1], addr_i_to_sd[6:0]};
		
		//else if (doing_im_req)			amm_address_wr <= {im_rd_idx_reg[`W_IDX:2],  imp_rd_addr_reg[`W_AMEM:3],  cnt[1:0], 3'h0  };
		//else if (doing_ex_req)			amm_address_wr <= {ex_wr_idx_reg[`W_IDX:2],  ex_wr_addr_reg[`W_AMEM:3],2'h0, 3'h0 };
		//else 							amm_address_wr <= {addr_i_to_sd[`W_EXTMWADDR:`W_AMEM+3], addr_i_to_sd[`W_AMEM:3], addr_i_to_sd[`W_AMEM+2:`W_AMEM+1], addr_i_to_sd[2:0]};
	
	`else
		
		else if (doing_im_req)			amm_address_wr <= {im_rd_idx_reg[`W_IDX:1],  imp_rd_addr_reg[`W_AMEM:3],  cnt[0], 3'h0  };
		else if (doing_ex_req)			amm_address_wr <= {ex_wr_idx_reg[`W_IDX:1],  ex_wr_addr_reg[`W_AMEM:3],1'h0, 3'h0 };
	//	else 							amm_address_wr <= addr_i_to_sd;
		else 							amm_address_wr <= {addr_i_to_sd[`W_EXTMWADDR:`W_AMEM+2], addr_i_to_sd[`W_AMEM:3], addr_i_to_sd[`W_AMEM+1], addr_i_to_sd[2:0]};
	`endif
`endif
//		else if (doing_im_req)	extm_1x_a <= {im_rd_idx_reg[`W_IDX:1], cnt[3], imp_rd_addr_reg[`W_AMEM:3], cnt[2:0] };
//		else if (doing_ex_req)	extm_1x_a <= {ex_wr_idx_reg[`W_IDX:1], cnt[3], ex_wr_addr_reg[`W_AMEM:3], cnt[2:0] };	

	
	always @(`CLK_RST_EDGE)
        if (`RST)						amm_burstbegin_wr <= 0;
`ifdef EX_IMPLODE_INSTANCE_4

`else
		else if (doing_ex_req)			amm_burstbegin_wr <= cnt_en & (cnt ==0 || cnt ==8 );
		else if (doing_im_req)			amm_burstbegin_wr <= cnt_en;
		else 							amm_burstbegin_wr <= cnt_en;
`endif	
		
	always @(`CLK_RST_EDGE)
        if (`RST)						amm_write_wr <= 0;
		else if (doing_loop1_req)		amm_write_wr <= cnt_en & (cnt<`TASKN/2);
		else if (doing_loop2_req)		amm_write_wr <= cnt_en & (cnt<`TASKN/2);
		else if (doing_loop2_req_last)	amm_write_wr <= cnt_en & (cnt<`TASKN/2);
		else if (doing_ex_req)			amm_write_wr <= cnt_en;
		else							amm_write_wr <= 0;
	
	always @(`CLK_RST_EDGE)
        if (`RST)						amm_read_wr <= 0;
		else if (doing_init_req)		amm_read_wr <= cnt_en;
		else if (doing_loop1_req)		amm_read_wr <= cnt_en & (cnt>=`TASKN/2);
		else if (doing_loop2_req)		amm_read_wr <= cnt_en & (cnt>=`TASKN/2);
		else if (doing_im_req)			amm_read_wr <= cnt_en; // & (cnt[2:0] ==0);
		else							amm_read_wr <= 0;
		
	always @(`CLK_RST_EDGE)
        if (`RST)						amm_burstcount_wr <= 0;
		else if (doing_init_req)		amm_burstcount_wr <= 1;
		else if (doing_loop1_req)		amm_burstcount_wr <= 1;
		else if (doing_loop2_req)		amm_burstcount_wr <= 1;
		else if (doing_loop2_req_last)	amm_burstcount_wr <= 1;
		else if (doing_im_req)			amm_burstcount_wr <= 8;  // 可以用 16  或者 32 
`ifdef EX_IMPLODE_INSTANCE_4
		else if (doing_ex_req)			amm_burstcount_wr <= 8;
`else
	//`ifdef EXTMEM_W64
		else if (doing_ex_req)			amm_burstcount_wr <= 8;
	//`else
	//	else if (doing_ex_req)			amm_burstcount_wr <= 16;
	//`endif
`endif
	
	always @(`CLK_RST_EDGE)
        if (`RST)						amm_writedata_wr <= 0;
	//	else if (doing_ex_req)			amm_writedata_wr <= db_scratchpad_ex_d1;
		else 							amm_writedata_wr <= data_i_to_sd;
		


`ifdef EXTMEM_W64		
	reg		[`W_MEM :0]			extm_1x_q;
	reg							extm_1x_qv;
	reg							extm_qv_toggle;
	reg		[`W_SDD :0]			extm_q_d1;
	wire						extm_qv;
	wire	[`W_SDD :0]			extm_q;
	assign 		{extm_qv, extm_q} =  {amm_readdatavalid, amm_readdata};

	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_qv_toggle <= 0;
		else if (extm_qv)	extm_qv_toggle <= extm_qv_toggle + 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_q_d1 <= 0;
		else if (extm_qv)	extm_q_d1 <= amm_readdata;

	always @(`CLK_RST_EDGE)
		if (`RST) 			extm_1x_qv <= 0;
		else 				extm_1x_qv <= extm_qv & extm_qv_toggle;

	always @(`CLK_RST_EDGE)
		if (`RST) 					extm_1x_q <= 0;
		else if (extm_qv & extm_qv_toggle)
									extm_1x_q <= {extm_q, extm_q_d1};
									
	always @(`CLK_RST_EDGE)
		if (`ZST) 	{data_o_from_sd, data_o_from_sd_f} <= 0;
		else      	{data_o_from_sd, data_o_from_sd_f} <= {extm_1x_q, extm_1x_qv};	
								
	// always @(*)	{data_o_from_sd, data_o_from_sd_f} = {extm_1x_q, extm_1x_qv};	
		
									
`else
//	always @(`CLK_RST_EDGE)
//		if (`ZST) 	{data_o_from_sd, data_o_from_sd_f} <= 0;
//		else      	{data_o_from_sd, data_o_from_sd_f} <= {amm_readdata, amm_readdatavalid};	
	always @(*)
		{data_o_from_sd, data_o_from_sd_f} = {amm_readdata, amm_readdatavalid};	
`endif									
									


	ddrc_write_FIFO ddrc_write_FIFO(
		.clk							(clk						),
		.rstn                           (rstn                      ),
		.wr_en                          (wr_en                     ),
		.amm_burstbegin_wr              (amm_burstbegin_wr                     ),
		.amm_read_wr                    (amm_read_wr               ),
		.amm_write_wr                   (amm_write_wr              ),
		.amm_address_wr                 (amm_address_wr            ),
		.amm_writedata_wr               (amm_writedata_wr          ),
		.amm_burstcount_wr              (amm_burstcount_wr         ),
		.ctrl_auto_precharge_req_wr     (ctrl_auto_precharge_req_wr),
		.amm_ready                      (amm_ready                 ),
		
		.amm_burstbegin		          	(amm_burstbegin                 ),
		.amm_read                       (amm_read                  ),
		.amm_write                      (amm_write                 ),
		.amm_address                    (amm_address               ),
		.amm_writedata                  (amm_writedata             ),
		.amm_burstcount                 (amm_burstcount            ),
		.ctrl_auto_precharge_req        (ctrl_auto_precharge_req   )
	);
		
		
		
endmodule





module ddrc_write_FIFO (
	input								clk,
	input								rstn,
	input								wr_en,
	input	  			       			amm_burstbegin_wr,                   
	input	  			       			amm_read_wr,                   
	input	  			       			amm_write_wr,                  
	input	  		[`W_EXTMWADDR :0] 	amm_address_wr,                
	input	  		[`W_MEM       :0]	amm_writedata_wr,              
	input	  		[6:0]  				amm_burstcount_wr,             
	input	  			       			ctrl_auto_precharge_req_wr,
	
	input								amm_ready,
	
	
	output reg 			       			amm_burstbegin,                   
	output reg 			       			amm_read,                   
	output reg 			       			amm_write,                  
	output reg 		[`W_EXTMWADDR :0] 	amm_address,                
	output reg 		[`W_SDD       :0]	amm_writedata,              
	output reg 		[6:0]  				amm_burstcount,             
	output reg 			       			ctrl_auto_precharge_req

	);
	parameter MAX_ADDR_DDRCFIFO = 128;
	`define APP_CMD_COMBAIN {amm_burstbegin, amm_read, amm_write, amm_address, amm_writedata, amm_burstcount, ctrl_auto_precharge_req}
	wire	[255:0]		db_cmd_fifo = {amm_burstbegin_wr, amm_read_wr, amm_write_wr, amm_address_wr, amm_writedata_wr, amm_burstcount_wr, ctrl_auto_precharge_req_wr};
	reg		[  7:0]		ab_cmd_fifo;
	reg		[  7:0]		aa_cmd_fifo;
	wire	[255:0]		qa_cmd_fifo;
	reg		[255:0]		qa_cmd_fifo_d1;
	reg					wr_en_d1;
	
	always @(`CLK_RST_EDGE)
        if (`RST)			            ab_cmd_fifo <= 0;
        else if (wr_en) 				ab_cmd_fifo <= ab_cmd_fifo + 1;
		
	always @(`CLK_RST_EDGE)
        if (`RST)				qa_cmd_fifo_d1 <= 0;
		else					qa_cmd_fifo_d1 <= qa_cmd_fifo;

	always @(`CLK_RST_EDGE)
        if (`RST)			    wr_en_d1 <= 0;
        else 					wr_en_d1 <= wr_en;
			
	
	reg                     [ 7:0]  	fifo0_semaphore;
	wire                            	fifo0_rdreq = (fifo0_semaphore != 0 && amm_ready);
	reg									fifo0_rdreq_p1;
	always @(`CLK_RST_EDGE)
        if (`RST)	fifo0_semaphore <= 0;
		else case({wr_en_d1, fifo0_rdreq})
`ifdef EXTMEM_W64
			2'b10: fifo0_semaphore <= fifo0_semaphore + 2;
            2'b01: fifo0_semaphore <= fifo0_semaphore - 1;		
            2'b11: fifo0_semaphore <= fifo0_semaphore + 1;	
`else
			2'b10: fifo0_semaphore <= fifo0_semaphore + 1;
            2'b01: fifo0_semaphore <= fifo0_semaphore - 1;			
`endif		
			endcase
`ifdef SIMULATING
    always @(*) if (fifo0_semaphore == MAX_ADDR_DDRCFIFO) begin
        $display("[ERROR] fifo_ddrc for Altera ddr3 controller is FULL !");
        #20 $finish;
    end    
`endif			
	always @(`CLK_RST_EDGE)
        if (`RST)  		fifo0_rdreq_p1 <= 0;
        else      		fifo0_rdreq_p1 <= fifo0_rdreq;
		
	rfdp128x256 cmd_fifo(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(~wr_en),
		.DB		(db_cmd_fifo	),
		.AB		(ab_cmd_fifo	),
		.CENA	(1'b0),
		.QA		(qa_cmd_fifo	),
	    .AA		(aa_cmd_fifo	)
	);
	
`ifdef EXTMEM_W64
	wire	  			       			amm_burstbegin_tmp;                   
	wire	  			       			amm_read_tmp;                   
	wire	  			       			amm_write_tmp;                  
	wire	  		[`W_EXTMWADDR :0] 	amm_address_tmp;                
	wire	  		[`W_MEM       :0]	amm_writedata_tmp;              
	wire	  		[6:0]  				amm_burstcount_tmp;             
	wire	  			       			ctrl_auto_precharge_req_tmp;
	
	assign {amm_burstbegin_tmp, amm_read_tmp, amm_write_tmp, amm_address_tmp, amm_writedata_tmp, amm_burstcount_tmp, ctrl_auto_precharge_req_tmp} 
				= qa_cmd_fifo;
				
	reg			fifo0_rdreq_toggle, fifo0_rdreq_toggle_d1;
	always @(`CLK_RST_EDGE)
        if (`RST) 				fifo0_rdreq_toggle <= 0;
		else if (fifo0_rdreq)	fifo0_rdreq_toggle <= fifo0_rdreq_toggle + 1;
	
	always @(`CLK_RST_EDGE)
        if (`RST) 	fifo0_rdreq_toggle_d1 <= 0;
		else 		fifo0_rdreq_toggle_d1 <= fifo0_rdreq_toggle;
		
	always @(`CLK_RST_EDGE)
        if (`RST) 									aa_cmd_fifo <= 0;
		else if (fifo0_rdreq & fifo0_rdreq_toggle)	aa_cmd_fifo <= aa_cmd_fifo + 1;
		
		
	reg				last_cmd_rejected;
	reg		[255:0]	last_cmd;
	always @(`CLK_RST_EDGE)
        if (`RST)   	last_cmd_rejected <= 0;
		else			last_cmd_rejected <= (amm_read | amm_write)& (!amm_ready);
	always @(`CLK_RST_EDGE)
        if (`RST)  								last_cmd <= 0;
		else if (fifo0_rdreq_p1&(!amm_ready))	last_cmd <= `APP_CMD_COMBAIN;
	
	
	// 这个怎么转比较麻烦， write x2 read x1
	always @(*)
       if (`RST)             
			`APP_CMD_COMBAIN = 0;
		else if (last_cmd_rejected)
			`APP_CMD_COMBAIN = last_cmd;
        else if (fifo0_rdreq_p1) begin
			if (!fifo0_rdreq_toggle_d1) begin
				amm_burstbegin				=  amm_burstbegin_tmp;
				amm_read					= 	amm_read_tmp;	                 
				amm_write					=  amm_write_tmp;				              
				amm_address			        =  { amm_address_tmp, 1'b0};			        
				amm_writedata			    =  amm_writedata_tmp[`W_SDD :0];		        
				amm_burstcount			    =  amm_burstcount_tmp*2;			       
				ctrl_auto_precharge_req     =  ctrl_auto_precharge_req_tmp;
			end else begin
				amm_burstbegin				=  0;	                 
				//amm_read					=  amm_read_tmp;	                 
				amm_read					=  0;	                 
				amm_write					=  amm_write_tmp;				              
				amm_address			        =  { amm_address_tmp, 1'b0};			        
				amm_writedata			    =  amm_writedata_tmp[`W_MEM : `W_SDD+1];		        
				amm_burstcount			    =  amm_burstcount_tmp*2;			       
				ctrl_auto_precharge_req     =  ctrl_auto_precharge_req_tmp;		
			end
		end else
			`APP_CMD_COMBAIN = 0;
	
`else

	always @(`CLK_RST_EDGE)
        if (`RST) 				aa_cmd_fifo <= 0;
		else if (fifo0_rdreq)	aa_cmd_fifo <= aa_cmd_fifo + 1;

		
	reg				last_cmd_rejected;
	reg		[255:0]	last_cmd;
	always @(`CLK_RST_EDGE)
        if (`RST)   	last_cmd_rejected <= 0;
		else			last_cmd_rejected <= (amm_read | amm_write)& (!amm_ready);
	always @(`CLK_RST_EDGE)
        if (`RST)  								last_cmd <= 0;
		else if (fifo0_rdreq_p1&(!amm_ready))	last_cmd <= qa_cmd_fifo;
		
	always @(*)
       if (`RST)             
			`APP_CMD_COMBAIN = 0;
		else if (last_cmd_rejected)
			`APP_CMD_COMBAIN = last_cmd;
        else if (fifo0_rdreq_p1)
			`APP_CMD_COMBAIN = qa_cmd_fifo;
		else
			`APP_CMD_COMBAIN = 0;

`endif	




endmodule




`endif



module go_CDC_go(
	input					clk_i,
	input					rstn_i,
	input					go_i,	
	input					clk_o,
	input					rst_o,
	output					go_o
	);

	//##################### clk_i domain ################################33

	reg						flip_i;
	
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)    flip_i <= 0;
		else if (go_i) flip_i <= ~flip_i;
		
	reg						flip_o_meta;
	reg						flip_o     ;
	reg						flip_o_p1  ;

	//##################### clk_o domain ################################33
	
	assign  go_o = (flip_o_p1 != flip_o);	

	always @(posedge clk_o or negedge rst_o)
		if (!rst_o) begin
			flip_o_meta <= 0;
			flip_o <= 0;
			flip_o_p1 <= 0;
		end else begin
			flip_o_meta <= flip_i ;
			flip_o <= flip_o_meta;
			flip_o_p1 <= flip_o;
		end
	
endmodule	


