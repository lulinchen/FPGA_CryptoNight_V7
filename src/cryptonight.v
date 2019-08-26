// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

module cryptonight (
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
	input		[ 63:0]			tweak1_2_0_i,						
	
	output						ready_mainloop,
	output						ready,
	output 		[127:0]	        xout0,							
	output 		[127:0]	        xout1,							
	output 		[127:0]	        xout2,							
	output 		[127:0]	        xout3,
	output 		[127:0]	        xout4,
	output 		[127:0]	        xout5,
	output 		[127:0]	        xout6,
	output 		[127:0]	        xout7
	
	);


	wire	[ 127:0] 	k0, k1, k2, k3, k4, k5, k6, k7, k8, k9;
	wire	[ 127:0] 	imp_k0, imp_k1, imp_k2, imp_k3, imp_k4, imp_k5, imp_k6, imp_k7, imp_k8, imp_k9;
	
	wire	[127:0]	blk0 = hash4 ;
	wire	[127:0]	blk1 = hash5 ;
	wire	[127:0]	blk2 = hash6 ;
	wire	[127:0]	blk3 = hash7 ;
	wire	[127:0]	blk4 = hash8 ;
	wire	[127:0]	blk5 = hash9 ;
	wire	[127:0]	blk6 = hash10;
	wire	[127:0]	blk7 = hash11;
//	wire	[127:0]	imp_blk0 = hash4 ;
//	wire	[127:0]	imp_blk1 = hash5 ;
//	wire	[127:0]	imp_blk2 = hash6 ;
//	wire	[127:0]	imp_blk3 = hash7 ;
//	wire	[127:0]	imp_blk4 = hash8 ;
//	wire	[127:0]	imp_blk5 = hash9 ;
//	wire	[127:0]	imp_blk6 = hash10;
//	wire	[127:0]	imp_blk7 = hash11;	

	
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
		.ik9            (imp_k9)
	);

	wire 	[`W_MEM	:0]		db_scratchpad_ex;
	wire					cenb_scratchpad_ex;
	wire	[`W_AMEM:0]		ab_scratchpad_ex;
	
	wire 	[`W_MEM	:0]		qa_scratchpad_im;
	wire					cena_scratchpad_im;
	wire	[`W_AMEM:0]		aa_scratchpad_im;
	
	
	
	wire 	[`W_MEM	:0]		db_scratchpad;
	wire					cenb_scratchpad;
	wire	[`W_AMEM:0]		ab_scratchpad;
	
	wire	[`W_MEM:0]		qa_scratchpad;
	wire					cena_scratchpad;
	wire	[`W_AMEM:0]		aa_scratchpad;

	
	//cn_explode_scratchpad cn_explode_scratchpad(
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
		.ready			(explode_ready),
		.db_scratchpad	(db_scratchpad_ex),
		.cenb_scratchpad(cenb_scratchpad_ex),
		.ab_scratchpad	(ab_scratchpad_ex)
	);

	wire	go_mainloop = explode_ready;
	//wire	ready_mainloop;
	//mainLoop mainLoop(
	mainLoop2 mainLoop(
		.clk 			 (clk),
	    .rstn			 (rstn),
	    .go				 (go_mainloop),
	//    .go				 (1'b0),
		.hash0			 (hash0),
		.hash1			 (hash1), 
		.hash2 	         (hash2),
		.hash3	         (hash3),
		.tweak1_2_0_i	 (tweak1_2_0_i),
		
		.ready			 (ready_mainloop),
		.db_scratchpad	 (db_scratchpad	),
		.ab_scratchpad	 (ab_scratchpad	),
		.cenb_scratchpad (cenb_scratchpad),
		.qa_scratchpad	 (qa_scratchpad	),
		.cena_scratchpad (cena_scratchpad),
		.aa_scratchpad   (aa_scratchpad  )
	);
	
	
	rfdp131072x128 scratchpad (
		.QA			(qa_scratchpad),
		.AA			(!cena_scratchpad_im? aa_scratchpad_im : aa_scratchpad ),
		.CLKA		(clk),
		
		
		.CENA		(1'b0),
		
		
		.AB			(!cenb_scratchpad_ex? ab_scratchpad_ex : ab_scratchpad),
		.DB			(!cenb_scratchpad_ex? db_scratchpad_ex : db_scratchpad),
	    .CLKB		(clk),
	    .CENB       (cenb_scratchpad_ex & cenb_scratchpad)
	
	);
	
	
	
	
	
	//wire go_implode = ready_mainloop;
	wire	 go_implode_b1 = ready_mainloop;
	reg		 go_implode;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_implode <= 0;
		else 		go_implode <= go_implode_b1;
	
	
	reg		[ 127:0] 	imp_k0_i, imp_k1_i, imp_k2_i, imp_k3_i, imp_k4_i, imp_k5_i, imp_k6_i, imp_k7_i, imp_k8_i, imp_k9_i;
	reg		[ 127:0] 	imp_blk0, imp_blk1, imp_blk2, imp_blk3, imp_blk4, imp_blk5, imp_blk6, imp_blk7, imp_blk8, imp_blk9;
	
	
	
	always @(`CLK_RST_EDGE)
		if (`ZST) 					{ imp_k0_i, imp_k1_i, imp_k2_i, imp_k3_i, imp_k4_i, imp_k5_i, imp_k6_i, imp_k7_i, imp_k8_i, imp_k9_i } <= 0;
		else if (go_implode_b1)    { imp_k0_i, imp_k1_i, imp_k2_i, imp_k3_i, imp_k4_i, imp_k5_i, imp_k6_i, imp_k7_i, imp_k8_i, imp_k9_i } <= 
											{imp_k0, imp_k1, imp_k2, imp_k3, imp_k4, imp_k5, imp_k6, imp_k7, imp_k8, imp_k9};
	always @(`CLK_RST_EDGE)
		if (`ZST) 					{imp_blk0, imp_blk1, imp_blk2, imp_blk3, imp_blk4, imp_blk5, imp_blk6, imp_blk7} <= 0;
		else if (go_implode_b1) 	{imp_blk0, imp_blk1, imp_blk2, imp_blk3, imp_blk4, imp_blk5, imp_blk6, imp_blk7} <= 
											{hash4, hash5, hash6, hash7, hash8, hash9, hash10, hash11};
		
		
		
	//cn_implode_scratchpad cn_implode_scratchpad(
	cn_implode_scratchpad_3clk cn_implode_scratchpad(
		.clk 			(clk), 		
		.rstn			(rstn),
		.go				(go_implode),
		.k0             (imp_k0_i),
		.k1             (imp_k1_i),
		.k2             (imp_k2_i),
		.k3             (imp_k3_i),
		.k4             (imp_k4_i),
		.k5             (imp_k5_i),
		.k6             (imp_k6_i),
		.k7             (imp_k7_i),
		.k8             (imp_k8_i),
		.k9             (imp_k9_i),
		
		.blk0			(imp_blk0),
		.blk1           (imp_blk1),
		.blk2           (imp_blk2),
		.blk3           (imp_blk3),
		.blk4           (imp_blk4),
		.blk5           (imp_blk5),
		.blk6           (imp_blk6),
		.blk7           (imp_blk7),
		        
		.xout0			 (xout0),
		.xout1           (xout1),
		.xout2           (xout2),
		.xout3           (xout3),
		.xout4           (xout4),
		.xout5           (xout5),
		.xout6           (xout6),
		.xout7           (xout7),
		
		.ready			(ready),
		.qa_scratchpad	(qa_scratchpad),
		.cena_scratchpad(cena_scratchpad_im),
		.aa_scratchpad	(aa_scratchpad_im)
	);
	
endmodule

//=============== reduce the clks for aes with more clk fot multiply  
// 6clk aes  3clk multiply
// less clk 
module mainLoop3(
		input						clk , 		
		input						rstn,
		input						go,
		input		[ 127:0]		hash0,  // 15~0bytes
		input		[ 127:0]		hash1,	// 31~16bytes
		input		[ 127:0]		hash2,	// 47~32bytes
		input		[ 127:0]		hash3,	// 63~48bytes
		input		[  63:0]		tweak1_2_0_i, // tweak1_2_0 =  {....input39,input38,input37,input36}    ^ {....hash195, hash194, hash193, hash192}
		
		output reg					ready,		
		output reg 	[`W_MEM:0]		db_scratchpad,
		output reg	[`W_AMEM:0]		ab_scratchpad,
		output reg					cenb_scratchpad,
		
		input	 	[`W_MEM:0]		qa_scratchpad,
		output reg					cena_scratchpad,
		output reg	[`W_AMEM:0]		aa_scratchpad
		
	);
	
	
	
	parameter 	W_CNT=24;
	parameter	CNT_MAX = 16*'h80000 - 1;  
	//parameter	CNT_MAX = 16*128;  
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	
	reg		[`W_AMEM:0]	pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14;
	reg		[`W_AMEM:0]	pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14;
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;


	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M

	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= cnt_max_f_d1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go_d1)		en <= 1;
		else if (cnt_max_f)	en <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
		
		
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
		if (`RST)		{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= 0;
		else			{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= {pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13};

	always @(`CLK_RST_EDGE)
		if (`RST)		{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= 0;
		else			{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= {pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13};

		

	reg		[127:0]		a;
	reg		[127:0]		b;
	reg					update_a, update_b;
(*use_dsp48 ="no"*) 	reg		[127:0]		byte_mul_b1, byte_mul, byte_mul_and_add_b1, byte_mul_and_add;
	reg		[127:0]		block_new_tweak, block_new_tweak_2;
	
	
	reg	 	[`W_MEM:0]		qa_scratchpad_d1;
	reg		[127:0]			key_in;
	reg						data_en;
	wire	[127:0]			enc_data;
	reg		[127:0]			aes_tweak;
	reg		[127:0]			block_new;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			a <= 0;
		else if (go)		a <= hash0^hash2;
	//	else if (update_a)	a <= byte_mul_and_add ^ qa_scratchpad_d1;   // 
		else if (update_a)	a <= byte_mul_and_add_b1^ qa_scratchpad_d1;   //  one clk ahead
	
	always @(`CLK_RST_EDGE)
		if (`RST)			b <= 0;
		else if (go)		b <= hash1^hash3;
		else if (update_b)	b <= enc_data;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)		update_b <= 0;
		else 			update_b <= (cnt[3:0] == 7);	
	
	always @(`CLK_RST_EDGE)
		if (`RST)		update_a <= 0;
	//	else 			update_a <= (cnt[3:0] == 14);	
		else 			update_a <= (cnt[3:0] == 13);	
	
	wire rd_pad1 = go_d1|(cnt[3:0] == 15);
	wire rd_pad2 = cnt[3:0] == 8;
	

	always @(`CLK_RST_EDGE)
		if (`ZST)						aa_scratchpad <= 0;
//		else if (cnt[3:0] == 0)	aa_scratchpad <= a>>4;
		else if (rd_pad1)				aa_scratchpad <= a>>4;
		else if (rd_pad2)				aa_scratchpad <= enc_data>>4;
		
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_scratchpad <= 1;
		else 		cena_scratchpad <= ~(rd_pad1 | rd_pad2);

`ifdef SIMULATING	
	always @(`CLK_RST_EDGE)
		if (!(cena_scratchpad|cenb_scratchpad)  && aa_scratchpad ==ab_scratchpad)
			$display("[WARNING] T%d scratchpad read write conflict iteraton %d @%x", $time, cnt[W_CNT:4], aa_scratchpad);
`endif	
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad <= 0;
	//	else			aa_scratchpad <= a>>4;
		
	reg 	[`W_MEM:0]		db_scratchpad_d1;
	reg		[`W_AMEM:0]		ab_scratchpad_d1;
	reg		[`W_AMEM:0]		aa_scratchpad_d1;
	reg						cenb_scratchpad_d1;
	reg						cena_scratchpad_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	begin
			db_scratchpad_d1 <= 0;
			ab_scratchpad_d1 <= 0;
			aa_scratchpad_d1 <= 0;
			cenb_scratchpad_d1 <= 1;
			cena_scratchpad_d1 <= 1;
		end else begin
			db_scratchpad_d1 <= db_scratchpad;
			ab_scratchpad_d1 <= ab_scratchpad;
			aa_scratchpad_d1 <= aa_scratchpad;
			cenb_scratchpad_d1 <= cenb_scratchpad;
			cena_scratchpad_d1 <= cena_scratchpad;
		end
	
	always @(`CLK_RST_EDGE)
		if (`ZST)			pad_addr1 <= 0;
		else if (rd_pad1)	pad_addr1 <= a>>4;	
	
	reg		scratch_pad_conflict;
	always @(`CLK_RST_EDGE)
		if (`RST)		scratch_pad_conflict <= 0;
		else			scratch_pad_conflict <= !cena_scratchpad && !cenb_scratchpad && (ab_scratchpad == aa_scratchpad);
	
	always @(`CLK_RST_EDGE)
		if (`ZST)		qa_scratchpad_d1 <= 0;
		//else if (!cena_scratchpad_d1 && !cenb_scratchpad_d1 && (ab_scratchpad_d1 == aa_scratchpad_d1))
		else if (scratch_pad_conflict)
						qa_scratchpad_d1 <= db_scratchpad_d1;
		else if (!cena_scratchpad_d1)	
						qa_scratchpad_d1 <= qa_scratchpad;
	
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	key_in <= 0;
	//	else 		key_in <= a;
	always @(*) key_in = a;
	always @(*) data_en = (cnt[3:0] == 2);
	aes_lowclk aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(data_en				), 
		.data_in				(qa_scratchpad_d1		),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new <= 0;
	//	else 		block_new <= enc_data ^ b;
	always @(*)
		block_new <= enc_data ^ b;
		
	// cryptonight_monero_tweak
	// 11 bytes  enc_data[12*8-1 -:8]  process tweak
	// block_new_tweak used to update scratchpad
	//=========================== First time  block_new_tweak used to update scratchpad =====================
	always @(*)
		block_new_tweak = {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new_tweak <= 0;
	//	else 		block_new_tweak <= {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
	
	
	// b = enc_data  //
	//  scratchpad_address = enc_data
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad_1 <= 0;
	//	else			aa_scratchpad_1 <= enc_data >> 4;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)			pad_addr2 <= 0;
		else if (rd_pad2)	pad_addr2 <= enc_data >> 4;	
		
	wire update_pad1 = cnt[3:0] == 8;
	wire update_pad2 = cnt[3:0] == 15;
	
	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)					ab_scratchpad <= 0;
//		else if (update_pad1)		ab_scratchpad <= pad_addr1_d9;
		else if (update_pad1)		ab_scratchpad <= pad_addr1_d1;   // dont need so much delay because  a dont change in the
		else if (update_pad2)		ab_scratchpad <= pad_addr2;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)					db_scratchpad <= 0;
		else if (update_pad1)		db_scratchpad <= block_new_tweak;
		else if (update_pad2)		db_scratchpad <= block_new_tweak_2;
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_scratchpad <= 1;
		else 		cenb_scratchpad <= ~(update_pad1 | update_pad2);
		
	
		
		
	// xilinx DSP 25 x 18   
	// a = 8byte_add(a, 8byte_mul(b, scratchpad[scratchpad_address]))
	
	// b * qa_scratchpad_d1
	
	// 
`ifdef NO_MULTICYCLE
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b1 <= 0;
		else			byte_mul_b1 <= enc_data[63:0] * qa_scratchpad_d1[63:0];
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= byte_mul_b1;	
`else	
	// byte_mul_and_add_b1
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= enc_data[63:0] * qa_scratchpad_d1[63:0];	
`endif
	
	always @(*)			byte_mul_and_add_b1 = { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_and_add <= 0;
	//	else			byte_mul_and_add <= { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
		else			byte_mul_and_add <= byte_mul_and_add_b1;    // !!! exxchange low and hi  and no carry bit
		
		
	// a <= a + byte_mul;  
	// db_scratchpad = {tweak1_2_0 ^ a[127:64], a[127:64] };   
	
	//=========================== Second time  block_new_tweak used to update scratchpad =====================
	// byte_mul_and_add <= a + byte_mul;   
	// db_scratchpad = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[127:64] }; 
	// a <= byte_mul_and_add ^ qa_scratchpad_d1  //  qa_scratchpad_d1 = block[aes]
	
	reg		[63:0]	tweak1_2_0;
	always @(`CLK_RST_EDGE)
		if (`ZST)	tweak1_2_0 <= 0;
		else		tweak1_2_0 <= tweak1_2_0_i;
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	block_new_tweak_2 <= 0;
//		else 		block_new_tweak_2 <= {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	always @(*)
		block_new_tweak_2 = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	
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

//=============== reduce the clks for aes with more clk fot multiply  
// 6clk aes  3clk multiply
module mainLoop2(
		input						clk , 		
		input						rstn,
		input						go,
		input		[ 127:0]		hash0,  // 15~0bytes
		input		[ 127:0]		hash1,	// 31~16bytes
		input		[ 127:0]		hash2,	// 47~32bytes
		input		[ 127:0]		hash3,	// 63~48bytes
		input		[  63:0]		tweak1_2_0_i, // tweak1_2_0 =  {....input39,input38,input37,input36}    ^ {....hash195, hash194, hash193, hash192}
		
(* keep = "true", max_fanout = 64 *)		
		output reg					ready,		
		output reg 	[`W_MEM:0]		db_scratchpad,
		output reg	[`W_AMEM:0]		ab_scratchpad,
		output reg					cenb_scratchpad,
		
		input	 	[`W_MEM:0]		qa_scratchpad,
		output reg					cena_scratchpad,
		output reg	[`W_AMEM:0]		aa_scratchpad
		
	);
	
	
	
	parameter 	W_CNT=24;
`ifdef SIMULATION_LESS_MAINLOOP_CYCLES
	parameter	CNT_MAX = 16*'h800 - 1;  
`else	
	parameter	CNT_MAX = 16*'h80000 - 1;  
`endif	

	//parameter	CNT_MAX = 16*128;  
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	
	reg		[`W_AMEM:0]	pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14;
	reg		[`W_AMEM:0]	pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14;
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;


	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M

	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= cnt_max_f_d1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go_d1)		en <= 1;
		else if (cnt_max_f)	en <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
		
		
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
		if (`RST)		{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= 0;
		else			{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= {pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13};

	always @(`CLK_RST_EDGE)
		if (`RST)		{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= 0;
		else			{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= {pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13};

		

	reg		[127:0]		a;
	reg		[127:0]		b;
	reg					update_a, update_b;
(*use_dsp48 ="no"*) 	reg		[127:0]		byte_mul_b1, byte_mul, byte_mul_and_add_b1, byte_mul_and_add;
	reg		[127:0]		block_new_tweak, block_new_tweak_2;
	
	
	reg	 	[`W_MEM:0]		qa_scratchpad_d1;
	reg		[127:0]			key_in;
	reg						data_en;
	wire	[127:0]			enc_data;
	reg		[127:0]			aes_tweak;
	reg		[127:0]			block_new;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			a <= 0;
		else if (go)		a <= hash0^hash2;
	//	else if (update_a)	a <= byte_mul_and_add ^ qa_scratchpad_d1;   // 
		else if (update_a)	a <= byte_mul_and_add_b1^ qa_scratchpad_d1;   //  one clk ahead
	
	always @(`CLK_RST_EDGE)
		if (`RST)			b <= 0;
		else if (go)		b <= hash1^hash3;
		else if (update_b)	b <= enc_data;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)		update_b <= 0;
		else 			update_b <= (cnt[3:0] == 7);	
	
	always @(`CLK_RST_EDGE)
		if (`RST)		update_a <= 0;
	//	else 			update_a <= (cnt[3:0] == 14);	
		else 			update_a <= (cnt[3:0] == 13);	
	
	wire rd_pad1 = go_d1|(cnt[3:0] == 15);
	wire rd_pad2 = cnt[3:0] == 8;
	

	always @(`CLK_RST_EDGE)
		if (`ZST)						aa_scratchpad <= 0;
//		else if (cnt[3:0] == 0)	aa_scratchpad <= a>>4;
		else if (rd_pad1)				aa_scratchpad <= a>>4;
		else if (rd_pad2)				aa_scratchpad <= enc_data>>4;
		
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_scratchpad <= 1;
		else 		cena_scratchpad <= ~(rd_pad1 | rd_pad2);

`ifdef SIMULATING	
	always @(`CLK_RST_EDGE)
		if (!(cena_scratchpad|cenb_scratchpad)  && aa_scratchpad ==ab_scratchpad)
			$display("[WARNING] T%d scratchpad read write conflict iteraton %d @%x", $time, cnt[W_CNT:4], aa_scratchpad);
`endif	
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad <= 0;
	//	else			aa_scratchpad <= a>>4;
		
	reg 	[`W_MEM:0]		db_scratchpad_d1;
	reg		[`W_AMEM:0]		ab_scratchpad_d1;
	reg		[`W_AMEM:0]		aa_scratchpad_d1;
	reg						cenb_scratchpad_d1;
	reg						cena_scratchpad_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	begin
			db_scratchpad_d1 <= 0;
			ab_scratchpad_d1 <= 0;
			aa_scratchpad_d1 <= 0;
			cenb_scratchpad_d1 <= 1;
			cena_scratchpad_d1 <= 1;
		end else begin
			db_scratchpad_d1 <= db_scratchpad;
			ab_scratchpad_d1 <= ab_scratchpad;
			aa_scratchpad_d1 <= aa_scratchpad;
			cenb_scratchpad_d1 <= cenb_scratchpad;
			cena_scratchpad_d1 <= cena_scratchpad;
		end
	
	always @(`CLK_RST_EDGE)
		if (`ZST)			pad_addr1 <= 0;
		else if (rd_pad1)	pad_addr1 <= a>>4;	
	
	reg		scratch_pad_conflict;
	always @(`CLK_RST_EDGE)
		if (`RST)		scratch_pad_conflict <= 0;
		else			scratch_pad_conflict <= !cena_scratchpad && !cenb_scratchpad && (ab_scratchpad == aa_scratchpad);
	
	always @(`CLK_RST_EDGE)
		if (`ZST)		qa_scratchpad_d1 <= 0;
		//else if (!cena_scratchpad_d1 && !cenb_scratchpad_d1 && (ab_scratchpad_d1 == aa_scratchpad_d1))
		else if (scratch_pad_conflict)
						qa_scratchpad_d1 <= db_scratchpad_d1;
		else if (!cena_scratchpad_d1)	
						qa_scratchpad_d1 <= qa_scratchpad;
	
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	key_in <= 0;
	//	else 		key_in <= a;
	always @(*) key_in = a;
	always @(*) data_en = (cnt[3:0] == 2);
	aes_lowclk aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(data_en				), 
		.data_in				(qa_scratchpad_d1		),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new <= 0;
	//	else 		block_new <= enc_data ^ b;
	always @(*)
		block_new = enc_data ^ b;
		
	// cryptonight_monero_tweak
	// 11 bytes  enc_data[12*8-1 -:8]  process tweak
	// block_new_tweak used to update scratchpad
	//=========================== First time  block_new_tweak used to update scratchpad =====================
	always @(*)
		block_new_tweak = {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new_tweak <= 0;
	//	else 		block_new_tweak <= {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
	
	//  b
	// b = enc_data  // 
	//  scratchpad_address = enc_data
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad_1 <= 0;
	//	else			aa_scratchpad_1 <= enc_data >> 4;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)			pad_addr2 <= 0;
		else if (rd_pad2)	pad_addr2 <= enc_data >> 4;	
		
	wire update_pad1 = cnt[3:0] == 8;
	wire update_pad2 = cnt[3:0] == 15;
	
	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)					ab_scratchpad <= 0;
//		else if (update_pad1)		ab_scratchpad <= pad_addr1_d9;
		else if (update_pad1)		ab_scratchpad <= pad_addr1_d1;   // dont need so much delay because  a dont change in the
		else if (update_pad2)		ab_scratchpad <= pad_addr2;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)					db_scratchpad <= 0;
		else if (update_pad1)		db_scratchpad <= block_new_tweak;
		else if (update_pad2)		db_scratchpad <= block_new_tweak_2;
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_scratchpad <= 1;
		else 		cenb_scratchpad <= ~(update_pad1 | update_pad2);
		
	
		
		
	// xilinx DSP 25 x 18   
	// a = 8byte_add(a, 8byte_mul(b, scratchpad[scratchpad_address]))
	
	// b * qa_scratchpad_d1
	
	// 
`ifdef NO_MULTICYCLE
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b1 <= 0;
		else			byte_mul_b1 <= enc_data[63:0] * qa_scratchpad_d1[63:0];
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= byte_mul_b1;	
`else	
	// byte_mul_and_add_b1
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= enc_data[63:0] * qa_scratchpad_d1[63:0];	
`endif
	
	always @(*)			byte_mul_and_add_b1 = { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_and_add <= 0;
	//	else			byte_mul_and_add <= { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
		else			byte_mul_and_add <= byte_mul_and_add_b1;    // !!! exxchange low and hi  and no carry bit
		
		
	// a <= a + byte_mul;   // 
	// db_scratchpad = {tweak1_2_0 ^ a[127:64], a[127:64] };   // 
	
	//=========================== Second time  block_new_tweak used to update scratchpad =====================
	// byte_mul_and_add <= a + byte_mul;   //  
	// db_scratchpad = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[127:64] };   // 
	// a <= byte_mul_and_add ^ qa_scratchpad_d1  //   qa_scratchpad_d1 = block[aes]
	
	reg		[63:0]	tweak1_2_0;
	always @(`CLK_RST_EDGE)
		if (`ZST)	tweak1_2_0 <= 0;
		else		tweak1_2_0 <= tweak1_2_0_i;
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	block_new_tweak_2 <= 0;
//		else 		block_new_tweak_2 <= {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	always @(*)
		block_new_tweak_2 = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	
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


module mainLoop(
		input						clk , 		
		input						rstn,
		input						go,
		input		[ 127:0]		hash0,  // 15~0bytes
		input		[ 127:0]		hash1,	// 31~16bytes
		input		[ 127:0]		hash2,	// 47~32bytes
		input		[ 127:0]		hash3,	// 63~48bytes
		input		[  63:0]		tweak1_2_0_i, // tweak1_2_0 =  {....input39,input38,input37,input36}    ^ {....hash195, hash194, hash193, hash192}
		
		output reg					ready,		
		output reg 	[`W_MEM:0]		db_scratchpad,
		output reg	[`W_AMEM:0]		ab_scratchpad,
		output reg					cenb_scratchpad,
		
		input	 	[`W_MEM:0]		qa_scratchpad,
		output reg					cena_scratchpad,
		output reg	[`W_AMEM:0]		aa_scratchpad
		
	);
	
	
	
	parameter 	W_CNT=24;
	parameter	CNT_MAX = 16*'h80000 - 1;  
	//parameter	CNT_MAX = 16*128;  
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	
	reg		[`W_AMEM:0]	pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14;
	reg		[`W_AMEM:0]	pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14;
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;


	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M

	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= cnt_max_f_d1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go_d1)		en <= 1;
		else if (cnt_max_f)	en <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
		
		
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
		if (`RST)		{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= 0;
		else			{pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13, pad_addr1_d14} <= {pad_addr1, pad_addr1_d1, pad_addr1_d2, pad_addr1_d3, pad_addr1_d4, pad_addr1_d5, pad_addr1_d6, pad_addr1_d7, pad_addr1_d8, pad_addr1_d9, pad_addr1_d10, pad_addr1_d11, pad_addr1_d12, pad_addr1_d13};

	always @(`CLK_RST_EDGE)
		if (`RST)		{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= 0;
		else			{pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13, pad_addr2_d14} <= {pad_addr2, pad_addr2_d1, pad_addr2_d2, pad_addr2_d3, pad_addr2_d4, pad_addr2_d5, pad_addr2_d6, pad_addr2_d7, pad_addr2_d8, pad_addr2_d9, pad_addr2_d10, pad_addr2_d11, pad_addr2_d12, pad_addr2_d13};

		

	reg		[127:0]		a;
	reg		[127:0]		b;
	reg					update_a, update_b;
(*use_dsp48 ="no"*) 	reg		[127:0]		byte_mul_b1, byte_mul, byte_mul_and_add_b1, byte_mul_and_add;
	reg		[127:0]		block_new_tweak, block_new_tweak_2;
	
	
	reg	 	[`W_MEM:0]		qa_scratchpad_d1;
	reg		[127:0]			key_in;
	reg						data_en;
	wire	[127:0]			enc_data;
	reg		[127:0]			aes_tweak;
	reg		[127:0]			block_new;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			a <= 0;
		else if (go)		a <= hash0^hash2;
	//	else if (update_a)	a <= byte_mul_and_add ^ qa_scratchpad_d1;   // 
		else if (update_a)	a <= byte_mul_and_add_b1^ qa_scratchpad_d1;   //  one clk ahead
	
	always @(`CLK_RST_EDGE)
		if (`RST)			b <= 0;
		else if (go)		b <= hash1^hash3;
		else if (update_b)	b <= enc_data;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)		update_b <= 0;
		else 			update_b <= (cnt[3:0] == 8);	
	
	always @(`CLK_RST_EDGE)
		if (`RST)		update_a <= 0;
	//	else 			update_a <= (cnt[3:0] == 14);	
		else 			update_a <= (cnt[3:0] == 13);	
	
	wire rd_pad1 = go_d1|(cnt[3:0] == 15);
	wire rd_pad2 = cnt[3:0] == 9;
	

	always @(`CLK_RST_EDGE)
		if (`ZST)						aa_scratchpad <= 0;
//		else if (cnt[3:0] == 0)	aa_scratchpad <= a>>4;
		else if (rd_pad1)				aa_scratchpad <= a>>4;
		else if (rd_pad2)				aa_scratchpad <= enc_data>>4;
		
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_scratchpad <= 1;
		else 		cena_scratchpad <= ~(rd_pad1 | rd_pad2);

`ifdef SIMULATING	
	always @(`CLK_RST_EDGE)
		if (!(cena_scratchpad|cenb_scratchpad)  && aa_scratchpad ==ab_scratchpad)
			$display("[WARNING] T%d scratchpad read write conflict iteraton %d @%x", $time, cnt[W_CNT:4], aa_scratchpad);
`endif	
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad <= 0;
	//	else			aa_scratchpad <= a>>4;
		
	reg 	[`W_MEM:0]		db_scratchpad_d1;
	reg		[`W_AMEM:0]		ab_scratchpad_d1;
	reg		[`W_AMEM:0]		aa_scratchpad_d1;
	reg						cenb_scratchpad_d1;
	reg						cena_scratchpad_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	begin
			db_scratchpad_d1 <= 0;
			ab_scratchpad_d1 <= 0;
			aa_scratchpad_d1 <= 0;
			cenb_scratchpad_d1 <= 1;
			cena_scratchpad_d1 <= 1;
		end else begin
			db_scratchpad_d1 <= db_scratchpad;
			ab_scratchpad_d1 <= ab_scratchpad;
			aa_scratchpad_d1 <= aa_scratchpad;
			cenb_scratchpad_d1 <= cenb_scratchpad;
			cena_scratchpad_d1 <= cena_scratchpad;
		end
	
	always @(`CLK_RST_EDGE)
		if (`ZST)		pad_addr1 <= 0;
		else			pad_addr1 <= a>>4;	

	always @(`CLK_RST_EDGE)
		if (`ZST)		qa_scratchpad_d1 <= 0;
		else if (!cena_scratchpad_d1 && !cenb_scratchpad_d1 && (ab_scratchpad_d1 == aa_scratchpad_d1))
						qa_scratchpad_d1 <= db_scratchpad_d1;
		else if (!cena_scratchpad_d1)	
						qa_scratchpad_d1 <= qa_scratchpad;
	
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	key_in <= 0;
	//	else 		key_in <= a;
	always @(*) key_in = a;
	always @(*) data_en = (cnt[3:0] == 2);
	aes_ecb_enc aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(data_en				), 
		.data_in				(qa_scratchpad_d1		),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new <= 0;
	//	else 		block_new <= enc_data ^ b;
	always @(*)
		block_new <= enc_data ^ b;
		
	// cryptonight_monero_tweak
	// 11 bytes  enc_data[12*8-1 -:8]  process tweak
	// block_new_tweak used to update scratchpad
	//=========================== First time  block_new_tweak used to update scratchpad =====================
	always @(*)
		block_new_tweak = {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
		
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	block_new_tweak <= 0;
	//	else 		block_new_tweak <= {block_new[127:12*8], tweak(block_new[12*8-1 -:8]), block_new[11*8-1:0]};
	
	//  b
	// b = enc_data  // 
	//  scratchpad_address = enc_data
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)		aa_scratchpad_1 <= 0;
	//	else			aa_scratchpad_1 <= enc_data >> 4;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)		pad_addr2 <= 0;
		else			pad_addr2 <= enc_data >> 4;	
		
	wire update_pad1 = cnt[3:0] == 9;
	wire update_pad2 = cnt[3:0] == 15;
	
	
	
	always @(`CLK_RST_EDGE)
		if (`ZST)					ab_scratchpad <= 0;
		else if (update_pad1)		ab_scratchpad <= pad_addr1_d9;
		else if (update_pad2)		ab_scratchpad <= pad_addr2_d5;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)					db_scratchpad <= 0;
		else if (update_pad1)		db_scratchpad <= block_new_tweak;
		else if (update_pad2)		db_scratchpad <= block_new_tweak_2;
	always @(`CLK_RST_EDGE)
		if (`RST)	cenb_scratchpad <= 1;
		else 		cenb_scratchpad <= ~(update_pad1 | update_pad2);
		
	
		
		
	// xilinx DSP 25 x 18   
	// a = 8byte_add(a, 8byte_mul(b, scratchpad[scratchpad_address]))
	
	// b * qa_scratchpad_d1
	
	// 
`ifdef NO_MULTICYCLE
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_b1 <= 0;
		else			byte_mul_b1 <= enc_data[63:0] * qa_scratchpad_d1[63:0];
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= byte_mul_b1;	
`else	
	// byte_mul_and_add_b1
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul <= 0;
		else			byte_mul <= enc_data[63:0] * qa_scratchpad_d1[63:0];	
`endif
	
	always @(*)			byte_mul_and_add_b1 = { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
	always @(`CLK_RST_EDGE)
		if (`ZST)		byte_mul_and_add <= 0;
	//	else			byte_mul_and_add <= { (a[127:64] + byte_mul[63:0] ), (a[63:0] +  byte_mul[127:64])};    // !!! exxchange low and hi  and no carry bit
		else			byte_mul_and_add <= byte_mul_and_add_b1;    // !!! exxchange low and hi  and no carry bit
		
		
	// a <= a + byte_mul;   // 
	// db_scratchpad = {tweak1_2_0 ^ a[127:64], a[127:64] };   // 
	
	//=========================== Second time  block_new_tweak used to update scratchpad =====================
	// byte_mul_and_add <= a + byte_mul;   //  
	// db_scratchpad = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[127:64] };   // 
	// a <= byte_mul_and_add ^ qa_scratchpad_d1  //   qa_scratchpad_d1 = block[aes]
	
	reg		[63:0]	tweak1_2_0;
	always @(`CLK_RST_EDGE)
		if (`ZST)	tweak1_2_0 <= 0;
		else		tweak1_2_0 <= tweak1_2_0_i;
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	block_new_tweak_2 <= 0;
//		else 		block_new_tweak_2 <= {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	always @(*)
		block_new_tweak_2 = {tweak1_2_0 ^ byte_mul_and_add[127:64], byte_mul_and_add[63:0] };
		
	
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





module cn_explode_scratchpad(
		input						clk , 		
		input						rstn,
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
		
		output reg					ready,	
		
		output reg [`W_MEM	:0]		db_scratchpad,
		output reg					cenb_scratchpad,
		output reg	[`W_AMEM:0]		ab_scratchpad
	);
	

	
	parameter W_CNT=20;
	
//	wire	[127:0]	k0 = 128'h726f2c94d83fdd7e802a5dba67c9ae01;
//	wire	[127:0]	k1 = 128'he3b094726f759cf7c110ebbf6129c6c0;
//	wire	[127:0]	k2 = 128'h0da2e5727fcdc9e6a7f2149827d84922;
//	wire	[127:0]	k3 = 128'hfbc6fcba187668c87703f43fb6131f80;
//	wire	[127:0]	k4 = 128'h064ac59c0be820ee7425e908d3d7fd90;
//	wire	[127:0]	k5 = 128'h4d76d913b6b025a9aec64d61d9c5b95e;
//	wire	[127:0]	k6 = 128'hd7b3c9dbd1f90c47da112ca9ae34c5a1;
//	wire	[127:0]	k7 = 128'h82a8d53ccfde0c2f796e2986d7a864e7;
//	wire	[127:0]	k8 = 128'h997cee9f4ecf27449f362b03452707aa;
//	wire	[127:0]	k9 = 128'h0da0bca98f08699540d665ba39b84c3c;
//	

//	// 
//	
//	wire	[127:0]	blk0 = 128'hbd191be7261500bd96b844433f27156d;
//	wire	[127:0]	blk1 = 128'h27b7d142fc8af47dfec6e39941387935;
//	wire	[127:0]	blk2 = 128'h393d18a8333b8965c9082e620613e556;
//	wire	[127:0]	blk3 = 128'h01b532e26dd2fd75c175f8593924e68b;
//	wire	[127:0]	blk4 = 128'he5453d69603aac235594dfbd174854c1;
//	wire	[127:0]	blk5 = 128'h29512736a8f561d6484e17309f2831d5;
//	wire	[127:0]	blk6 = 128'h332c8940a5db71be1027b8fb4ea6608b;
//	wire	[127:0]	blk7 = 128'h588b56ad42cb21dcdc7d45ee90f4c7d0;
	
	
	
	reg		[127:0]		blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg;
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	reg		[127:0]		data_in;
	reg		[127:0]		key_in;
	wire	[127:0]		enc_data;
	
	wire	[W_CNT:0] cnt_max_and = 10* (`MEM/16)-1;
	wire 	cnt_max_f = cnt == 10* (`MEM/16)-1;  // = 2^(21-4) = 128K*10 = 1M
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;

	reg		[3:0]		cnt_rem10;  // cnt[W_CNT:3] % 10
	reg		[3:0]		cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= cnt_max_f_d7;
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go)		en <= 1;
		else if (cnt_max_f)	en <= 0;    
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 			cnt_rem10 <= 0;
		else if (go) 			cnt_rem10 <= 0;
		else if(cnt[2:0]==7)	cnt_rem10 <= cnt_rem10==9? 0 : cnt_rem10+1;
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
		if (`ZST) {blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= 0;
		else if (go)
			{blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= {blk0, blk1, blk2, blk3, blk4, blk5, blk6, blk7};
		else case (cnt_d8[2:0])
			0: 	blk0_reg <= enc_data;
			1:  blk1_reg <= enc_data;
			2:  blk2_reg <= enc_data;
			3:  blk3_reg <= enc_data;
			4:  blk4_reg <= enc_data;
			5:  blk5_reg <= enc_data;
		    6:  blk6_reg <= enc_data;
		    7:  blk7_reg <= enc_data;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in <= 0;
		else if (cnt[W_CNT:3]==0)
			case(cnt[2:0])
			0: 	data_in <= blk0_reg;
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			4:  data_in <= blk4_reg;
			5:  data_in <= blk5_reg;
			6:  data_in <= blk6_reg;
		    7:  data_in <= blk7_reg;
			endcase
		else if (en)
			data_in <= enc_data;
			
		
	always @(`CLK_RST_EDGE)
		if (`ZST) key_in <= 0;
		//else case(cnt[W_CNT:3] % 10)
		else case(cnt_rem10)
			0: 	key_in <= k0;
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
	
	aes_ecb_enc aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(1'b1    				), 
		.data_in				(data_in				),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	//############# write scratch pad ############################
	
		
	always @(`CLK_RST_EDGE)
		if (`ZST)   db_scratchpad <= 0;
		else 		db_scratchpad <= enc_data;
	
	always @(`CLK_RST_EDGE)
		if (`RST)   						cenb_scratchpad <= 1;
	//	else if (cnt_d8[W_CNT:3]%10 ==9) 	cenb_scratchpad <= 0;
		else if (cnt_rem10_d8 ==9) 			cenb_scratchpad <= 0;
		else 								cenb_scratchpad <= 1;

	always @(`CLK_RST_EDGE)
		if (`RST)   				ab_scratchpad <= 0;
		else if (go_d8)				ab_scratchpad <= 0;
		else if (~cenb_scratchpad)	ab_scratchpad <= ab_scratchpad + 1;

endmodule







module cn_explode_scratchpad_3clk(
		input						clk , 		
		input						rstn,
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
		
		output reg					ready,	
		
		output reg [`W_MEM	:0]		db_scratchpad,
		output reg					cenb_scratchpad,
		output reg	[`W_AMEM:0]		ab_scratchpad
	);
	

	
	parameter W_CNT=20;
	
//	wire	[127:0]	k0 = 128'h726f2c94d83fdd7e802a5dba67c9ae01;
//	wire	[127:0]	k1 = 128'he3b094726f759cf7c110ebbf6129c6c0;
//	wire	[127:0]	k2 = 128'h0da2e5727fcdc9e6a7f2149827d84922;
//	wire	[127:0]	k3 = 128'hfbc6fcba187668c87703f43fb6131f80;
//	wire	[127:0]	k4 = 128'h064ac59c0be820ee7425e908d3d7fd90;
//	wire	[127:0]	k5 = 128'h4d76d913b6b025a9aec64d61d9c5b95e;
//	wire	[127:0]	k6 = 128'hd7b3c9dbd1f90c47da112ca9ae34c5a1;
//	wire	[127:0]	k7 = 128'h82a8d53ccfde0c2f796e2986d7a864e7;
//	wire	[127:0]	k8 = 128'h997cee9f4ecf27449f362b03452707aa;
//	wire	[127:0]	k9 = 128'h0da0bca98f08699540d665ba39b84c3c;
//	

//	// 
//	
//	wire	[127:0]	blk0 = 128'hbd191be7261500bd96b844433f27156d;
//	wire	[127:0]	blk1 = 128'h27b7d142fc8af47dfec6e39941387935;
//	wire	[127:0]	blk2 = 128'h393d18a8333b8965c9082e620613e556;
//	wire	[127:0]	blk3 = 128'h01b532e26dd2fd75c175f8593924e68b;
//	wire	[127:0]	blk4 = 128'he5453d69603aac235594dfbd174854c1;
//	wire	[127:0]	blk5 = 128'h29512736a8f561d6484e17309f2831d5;
//	wire	[127:0]	blk6 = 128'h332c8940a5db71be1027b8fb4ea6608b;
//	wire	[127:0]	blk7 = 128'h588b56ad42cb21dcdc7d45ee90f4c7d0;
	
	
	
	reg		[127:0]		blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg;
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;
	reg		[127:0]		data_in;
	reg		[127:0]		key_in;
	wire	[127:0]		enc_data;
	
	reg		[127:0]		data_in_1;
	reg		[127:0]		key_in_1;
	wire	[127:0]		enc_data_1;
	
	
	wire	[W_CNT:0] cnt_max_and = 10/2* (`MEM/16)-1;
`ifdef SIMULATION_LESS_EXPLODE_CYCLES
	wire 	cnt_max_f = cnt == 10/2* (`MEM/512)-1;  // = 2^(21-4) = 128K*10 = 1M
`else
	wire 	cnt_max_f = cnt == 10/2* (`MEM/16)-1;  // = 2^(21-4) = 128K*10 = 1M
`endif
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;

	reg		[3:0]		cnt_rem10;  // cnt[W_CNT:3] % 10
	reg		[3:0]		cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14;
	
	
	//always @(`CLK_RST_EDGE)
	//	if (`RST)	ready <= 0;
	//	else 		ready <= cnt_max_f_d7;
	always @(`CLK_RST_EDGE)
		if (`RST)	ready <= 0;
		else 		ready <= cnt_max_f_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go)		en <= 1;
		else if (cnt_max_f)	en <= 0;    
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 			cnt_rem10 <= 0;
		else if (go) 			cnt_rem10 <= 0;
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
		else if (go)
			{blk0_reg, blk1_reg, blk2_reg, blk3_reg} <= {blk0, blk1, blk2, blk3};
		else case (cnt_d4[1:0])
			0: 	blk0_reg <= enc_data;
			1:  blk1_reg <= enc_data;
			2:  blk2_reg <= enc_data;
			3:  blk3_reg <= enc_data;
			
		endcase
	
	always @(`CLK_RST_EDGE)
		if (`ZST) {blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= 0;
		else if (go_d4)
			{blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= {blk4, blk5, blk6, blk7};
		else case (cnt_d8[2:0])
			0:  blk4_reg <= enc_data_1;
			1:  blk5_reg <= enc_data_1;
		    2:  blk6_reg <= enc_data_1;
		    3:  blk7_reg <= enc_data_1;
		endcase

		
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in <= 0;
		else if (cnt[W_CNT:2]==0)
			case(cnt[1:0])
			0: 	data_in <= blk0_reg;
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			endcase
		else if (en)
			data_in <= enc_data;
	
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in_1 <= 0;
		else if (cnt_d4[W_CNT:2]==0)
			case(cnt_d4[1:0])
			0:  data_in_1 <= blk4_reg;
			1:  data_in_1 <= blk5_reg;
			2:  data_in_1 <= blk6_reg;
		    3:  data_in_1 <= blk7_reg;
			endcase
		else if (en_d4)
			data_in_1 <= enc_data_1;
			
		
	always @(`CLK_RST_EDGE)
		if (`ZST) key_in <= 0;
		//else case(cnt[W_CNT:3] % 10)
		else case(cnt_rem10)
			0: 	key_in <= k0;
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
		//else case(cnt[W_CNT:3] % 10)
		else case(cnt_rem10_d4)
			0: 	key_in_1 <= k0;
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
		.data_in				(data_in				),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);

	aes_3clk aes_ecb_enc2(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in_1					),	
		.data_en				(1'b1    				), 
		.data_in				(data_in_1				),
		.enc_data_en			(enc_data_en_1			), 
		.enc_data				(enc_data_1				)
	);
	
	//############# write scratch pad ############################
	
		
	always @(`CLK_RST_EDGE)
		if (`ZST)   db_scratchpad <= 0;
	//	else 		db_scratchpad <= enc_data;
		else if (cnt_rem10_d4 ==9)
					db_scratchpad <= enc_data;
		else if (cnt_rem10_d8 ==9)
					db_scratchpad <= enc_data_1;
	always @(`CLK_RST_EDGE)
		if (`RST)   						cenb_scratchpad <= 1;
	//	else if (cnt_d8[W_CNT:3]%10 ==9) 	cenb_scratchpad <= 0;
		else if (cnt_rem10_d4 ==9||cnt_rem10_d8 ==9) 			cenb_scratchpad <= 0;
		else 								cenb_scratchpad <= 1;

	always @(`CLK_RST_EDGE)
		if (`RST)   				ab_scratchpad <= 0;
		else if (go_d8)				ab_scratchpad <= 0;
		else if (~cenb_scratchpad)	ab_scratchpad <= ab_scratchpad + 1;

endmodule





module cn_implode_scratchpad(
	input						clk , 		
	input						rstn,
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
	
	output reg					ready,
	input	 	[`W_MEM:0]		qa_scratchpad,
	output reg					cena_scratchpad,
	output reg	[`W_AMEM:0]		aa_scratchpad
	);
	
	

	parameter 	W_CNT = 20;
	parameter	CNT_MAX = 10* (`MEM/16)-1;
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
	
	reg		[3:0]		cnt_rem10;  // cnt[W_CNT:3] % 10
	reg		[3:0]		cnt_rem10_d1, cnt_rem10_d2, cnt_rem10_d3, cnt_rem10_d4, cnt_rem10_d5, cnt_rem10_d6, cnt_rem10_d7, cnt_rem10_d8, cnt_rem10_d9, cnt_rem10_d10, cnt_rem10_d11, cnt_rem10_d12, cnt_rem10_d13, cnt_rem10_d14;

	
	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;
	reg					ready_b1;
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
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	 			cnt_rem10 <= 0;
		else if (go) 			cnt_rem10 <= 0;
		else if(cnt[2:0]==7)	cnt_rem10 <= cnt_rem10==9? 0 : cnt_rem10+1;
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
		if (`ZST) {blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= 0;
		else if (go)
			{blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= {blk0, blk1, blk2, blk3, blk4, blk5, blk6, blk7};
		else if (en_d8) case (cnt_d8[2:0])
			0: 	blk0_reg <= enc_data;
			1:  blk1_reg <= enc_data;
			2:  blk2_reg <= enc_data;
			3:  blk3_reg <= enc_data;
			4:  blk4_reg <= enc_data;
			5:  blk5_reg <= enc_data;
		    6:  blk6_reg <= enc_data;
		    7:  blk7_reg <= enc_data;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in <= 0;
		else if (cnt[W_CNT:3]==0)
			case(cnt[2:0])
			0: 	data_in <= blk0_reg;
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			4:  data_in <= blk4_reg;
			5:  data_in <= blk5_reg;
			6:  data_in <= blk6_reg;
		    7:  data_in <= blk7_reg;
			endcase
		else if (en)
			data_in <= enc_data;
	
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

	
	
	aes_ecb_enc aes_ecb_enc(
		.clk					(clk					),	
		.rstn					(rstn					),
		.key_in					(key_in					),	
		.data_en				(1'b1    				), 
		.data_in				(aes_data_in				),
		.enc_data_en			(enc_data_en			), 
		.enc_data				(enc_data				)
	);
	
	
	
	wire   go_sum = go | go_d1 |go_d2 |go_d3 |go_d4 |go_d5 | go_d6 | go_d7;
	always @(`CLK_RST_EDGE)
		if (`RST)   						cena_scratchpad <= 1;
		else if (go_sum) 					cena_scratchpad <= 0;
	//	else if (cnt_d6[W_CNT:3]%10 ==9) 	cena_scratchpad <= 0;
		else if (cnt_rem10_d6 ==9) 			cena_scratchpad <= 0;
		else 								cena_scratchpad <= 1;
	always @(`CLK_RST_EDGE)
		if (`RST)   				aa_scratchpad <= 0;
		else if (go)				aa_scratchpad <= 0;
		else if (~cena_scratchpad)	aa_scratchpad <= aa_scratchpad + 1;

	always @(`CLK_RST_EDGE)
		if (`RST) {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= 0;
		else if (ready_b1)
				 {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= {blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg};
endmodule




module cn_implode_scratchpad_3clk(
	input						clk , 		
	input						rstn,
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
	
	output reg					ready,
	input	 	[`W_MEM:0]		qa_scratchpad,
	output reg					cena_scratchpad,
	output reg	[`W_AMEM:0]		aa_scratchpad
	);
	
	

	parameter 	W_CNT = 20;
	parameter	CNT_MAX = 10/2* (`MEM/16)-1;
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

	
	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M
	reg					cnt_max_f_d1, cnt_max_f_d2, cnt_max_f_d3, cnt_max_f_d4, cnt_max_f_d5, cnt_max_f_d6, cnt_max_f_d7, cnt_max_f_d8, cnt_max_f_d9, cnt_max_f_d10, cnt_max_f_d11, cnt_max_f_d12, cnt_max_f_d13, cnt_max_f_d14;
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
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	 			cnt_rem10 <= 0;
		else if (go) 			cnt_rem10 <= 0;
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
		else if (go)
			{blk0_reg, blk1_reg, blk2_reg, blk3_reg} <= {blk0, blk1, blk2, blk3};
		else if (en_d4) case (cnt_d4[1:0])
			0: 	blk0_reg <= enc_data;
			1:  blk1_reg <= enc_data;
			2:  blk2_reg <= enc_data;
			3:  blk3_reg <= enc_data;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in <= 0;
		else if (cnt[W_CNT:2]==0)
			case(cnt[1:0])
			0: 	data_in <= blk0_reg;
			1:  data_in <= blk1_reg;
			2:  data_in <= blk2_reg;
			3:  data_in <= blk3_reg;
			endcase
		else if (en)
			data_in <= enc_data;
	always @(`CLK_RST_EDGE)
		if (`ZST) {blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= 0;
		else if (go_d4)
			{blk4_reg, blk5_reg, blk6_reg, blk7_reg} <= {blk4, blk5, blk6, blk7};
		else if (en_d8) case (cnt_d8[1:0])
			0:  blk4_reg <= enc_data_1;
			1:  blk5_reg <= enc_data_1;
		    2:  blk6_reg <= enc_data_1;
		    3:  blk7_reg <= enc_data_1;
		endcase
			
	always @(`CLK_RST_EDGE)
		if (`ZST) data_in_1 <= 0;
		else if (cnt_d4[W_CNT:2]==0)
			case(cnt_d4[1:0])
			0:  data_in_1 <= blk4_reg;
			1:  data_in_1 <= blk5_reg;
			2:  data_in_1 <= blk6_reg;
		    3:  data_in_1 <= blk7_reg;
			endcase
		else if (en_d4)
			data_in_1 <= enc_data_1;
	
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
		else if (cnt_rem10_d2 ==9 || cnt_rem10_d6 ==9) 			cena_scratchpad <= 0;
		else 								cena_scratchpad <= 1;
	always @(`CLK_RST_EDGE)
		if (`RST)   				aa_scratchpad <= 0;
		else if (go)				aa_scratchpad <= 0;
		else if (~cena_scratchpad)	aa_scratchpad <= aa_scratchpad + 1;

	always @(`CLK_RST_EDGE)
		if (`RST) {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= 0;
		else if (ready_b1)
				 {xout0, xout1, xout2, xout3, xout4, xout5, xout6, xout7} <= {blk0_reg, blk1_reg, blk2_reg, blk3_reg, blk4_reg, blk5_reg, blk6_reg, blk7_reg};
endmodule



module ase_genkey(
	input						clk , 		
	input						rstn,
	input						go,
	input		[ 127:0]		hash0,  // 15~0bytes
	input		[ 127:0]		hash1,	// 31~16bytes
	input		[ 127:0]		hash2,	// 47~32bytes
	input		[ 127:0]		hash3,	// 63~48bytes
	output reg	[ 127:0] 		k0, k1, k2, k3, k4, k5, k6, k7, k8, k9,
	output reg	[ 127:0] 		ik0, ik1, ik2, ik3, ik4, ik5, ik6, ik7, ik8, ik9,
	
	output reg					ik_ready_sub,
	output reg	[ 127:0]		ik,
	output reg	[2:0]			ik_cnt
	
	
	);

	
	parameter 	W_CNT=7;
	parameter	CNT_MAX = 4*8*2 - 1;  
	//parameter	CNT_MAX = 16*128;  
	reg					en;
	reg		[W_CNT:0]	cnt;
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	reg					en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14;
	reg		[W_CNT:0]	cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14;

	
	wire 	cnt_max_f = cnt == CNT_MAX;  // = 2^(21-4) = 128K*10 = 1M
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= 0;
		else			{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= {go, go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13};
	always @(`CLK_RST_EDGE)
		if (`RST)		{en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14} <= 0;
		else			{en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13, en_d14} <= {en, en_d1, en_d2, en_d3, en_d4, en_d5, en_d6, en_d7, en_d8, en_d9, en_d10, en_d11, en_d12, en_d13};
	
	always @(`CLK_RST_EDGE)
		if (`RST)		{cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14} <= 0;
		else			{cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13, cnt_d14} <= {cnt, cnt_d1, cnt_d2, cnt_d3, cnt_d4, cnt_d5, cnt_d6, cnt_d7, cnt_d8, cnt_d9, cnt_d10, cnt_d11, cnt_d12, cnt_d13};

	
	
	
	reg						go_sub;
	wire					ready_sub;
	reg						even; // 2 4 6 8  high  3 5 7 9 low
	reg		[7:0]			rcon; //
	reg		[127: 0] 		k0_sub, k1_sub;   //
	wire	[127: 0] 		kout;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			en <= 0;
		else if (go_d1)		en <= 1;
		else if (cnt_max_f)	en <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)	 cnt <= 0;
		else if (en) cnt <= cnt + 1;
		else		 cnt <= 0;
		
	//always @(`CLK_RST_EDGE)
	//	if (`RST)	 go_sub <= 0;
	//	else		 go_sub <= en &(cnt[1:0]==0);
		
	
	
	always @(*)
		go_sub = en &(cnt[1:0]==0);
	
	always @(`CLK_RST_EDGE)
		if (`ZST)						{k0_sub, k1_sub} <= 0;
		else if (go_d1)					{k0_sub, k1_sub} <= {hash0, hash1};
		else if (ready_sub&cnt[5:2]==7)	{k0_sub, k1_sub} <= {hash2, hash3};
		else if (ready_sub)				{k0_sub, k1_sub} <= {k1_sub, kout};
	always @(`CLK_RST_EDGE)
		if (`ZST)			even <= 0;
		else if (go_d1)     even <= 1;
		else if (ready_sub)	even <= ~even;
	always @(`CLK_RST_EDGE)
		if (`ZST)			rcon <= 0;
		else if (go_d1)     rcon <= 1;
		else if (ready_sub)	
			case (cnt[4:2])
				1 : rcon <= 2;
				3 : rcon <= 4;
				5 : rcon <= 8;
				7 : rcon <= 1;
			endcase
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	{k0, k1, ik0, ik1} <= 0;
	//	else if (go){k0, k1, ik0, ik1} <= {hash0, hash1, hash2, hash3};
	always @(*)
		{k0, k1, ik0, ik1} = {hash0, hash1, hash2, hash3};
	always @(`CLK_RST_EDGE)
		if (`ZST)	{k2, k3, k4, k5, k6, k7, k8, k9, ik2, ik3, ik4, ik5, ik6, ik7, ik8, ik9} <= 0;
		else if (ready_sub)
			case(cnt[5:2])
			0 :  k2	 <= kout;	
			1 :  k3  <= kout;
			2 :  k4  <= kout;
			3 :  k5  <= kout;
			4 :  k6  <= kout;
			5 :  k7  <= kout;
			6 :  k8  <= kout;
			7 :  k9  <= kout;
			8 :  ik2 <= kout;
			9 :  ik3 <= kout;
			10:  ik4 <= kout;
			11:  ik5 <= kout;
			12:  ik6 <= kout;
			13:  ik7 <= kout;
		    14:  ik8 <= kout;
	        15:  ik9 <= kout;
			endcase
			
	
	aes_genkey_sub aes_genkey_sub(
		.clk 	(clk), 
		.rstn	(rstn),
		.go		(go_sub),
		.even	(even), 
		.rcon	(rcon), 
		.k0		(k0_sub), 
		.k1		(k1_sub),
		.ready	(ready_sub),
		.kout   (kout)
	);

	always @(`CLK_RST_EDGE)
		if (`RST)		ik_ready_sub <= 0;
		else 			ik_ready_sub <= ready_sub & cnt[5];
	always @(`CLK_RST_EDGE)
		if (`RST)		ik_cnt <= 0;
		else 			ik_cnt <=  cnt[4:2];
	always @(`CLK_RST_EDGE)
		if (`RST)		ik <= 0;
		else 			ik <=  kout;
		
	
	
endmodule

	
	

//=== 
module aes_genkey_sub(
	input						clk , 		
	input						rstn,
	input						go,
	input						even, // 2 4 6 8  high  2 5 7 9 low
	input		[7:0]			rcon, // 
	input		[127: 0] 		k0, k1,   //
	output 						ready,
	output reg	[127: 0] 		kout
	);
	
	// =========================================================================
	// [7:0]	rcon;
	//  soft_aes_genkey_sub  3rd or 4th elem
	reg					go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= 0;
		else			{go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13, go_d14} <= {go, go_d1, go_d2, go_d3, go_d4, go_d5, go_d6, go_d7, go_d8, go_d9, go_d10, go_d11, go_d12, go_d13};

		
	assign 			ready = go_d3;
	
	wire [127:0]	xout0 = k0; 
	wire [127:0]	xout2 = k1; 

	//=======================soft_aeskeygenassist ===============================
	
	wire	[7:0]	aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3, aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7;
	wire	[7:0]	qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3, qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7;
	assign {aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3} = xout2[63:32];
	assign {aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7} = xout2[127:96];
	reg		[31:0]	X1, X3;
	always @(`CLK_RST_EDGE)
		if (`ZST) {X1, X3} <= 0;
		else begin
			X1 <= {qa_sbox0, qa_sbox1, qa_sbox2, qa_sbox3};
			X3 <= {qa_sbox4, qa_sbox5, qa_sbox6, qa_sbox7};
		end
	wire	[31:0]	X1_rotr8 = {X1[7:0], X1[31:16], X1[15:8]^rcon};
	wire	[31:0]	X3_rotr8 = {X3[7:0], X3[31:16], X3[15:8]^rcon};
	wire	[127:0]	aeskeygenassist = { X3_rotr8, X3, X1_rotr8, X1};
	//wire 	[127:0] xout1 = even? {4{ aeskeygenassist[127:96]}} : {4{ aeskeygenassist[95:64]}};   
	//wire 	[127:0] xout0_sl_xor = sl_xor(xout0);	
	//assign kout = xout0_sl_xor ^ xout1;
	
	reg 	[127:0] xout1;
	reg 	[127:0] xout0_sl_xor;
	
		
	always @(`CLK_RST_EDGE)
		if (`ZST) 	xout1 <= 0;
		else 		xout1 <= even? {4{ aeskeygenassist[127:96]}} : {4{ aeskeygenassist[95:64]}};   	
	always @(`CLK_RST_EDGE)
		if (`ZST) 	xout0_sl_xor <= 0;
		else 		xout0_sl_xor <= sl_xor(xout0);	
	
	//always @(`CLK_RST_EDGE)
	//	if (`ZST) 	kout <= 0;
	//	else 		kout <= xout0_sl_xor ^ xout1;		
		
	always @(*)		kout = xout0_sl_xor ^ xout1;	
	
	sbox_rom sbox_rom0 (aa_sbox0 ,1'b1,clk,qa_sbox0 );
	sbox_rom sbox_rom1 (aa_sbox1 ,1'b1,clk,qa_sbox1 );
	sbox_rom sbox_rom2 (aa_sbox2 ,1'b1,clk,qa_sbox2 );
	sbox_rom sbox_rom3 (aa_sbox3 ,1'b1,clk,qa_sbox3 );

	sbox_rom sbox_rom4 (aa_sbox4 ,1'b1,clk,qa_sbox4 );
	sbox_rom sbox_rom5 (aa_sbox5 ,1'b1,clk,qa_sbox5 );
	sbox_rom sbox_rom6 (aa_sbox6 ,1'b1,clk,qa_sbox6 );
	sbox_rom sbox_rom7 (aa_sbox7 ,1'b1,clk,qa_sbox7 );
	
	function [127:0] sl_xor( input	[127:0] xout0);
		sl_xor = {xout0[127-:32]^xout0[95-:32]^xout0[63-:32]^ xout0[31-:32], xout0[95-:32]^xout0[63-:32]^ xout0[31-:32], xout0[63-:32]^ xout0[31-:32] , xout0[31-:32]};
	endfunction

endmodule


