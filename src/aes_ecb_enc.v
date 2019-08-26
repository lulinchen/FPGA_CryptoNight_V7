// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"




// 3 clk
module aes_3clk(
///system
	input					clk , 		
	input					rstn,
	input		[127:0]		key_in,		

	input					data_en,   
	input		[127:0]		data_in,   //  coloum order
	
	output					enc_data_en,
	output	reg	[127:0]		enc_data
);

	reg		[127:0]	key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= 0;
		else		{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= {key_in, key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7};
	
	reg				data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= 0;
		else		{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= {data_en, data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7};
	
	//assign enc_data_en = data_en_d8;
	assign enc_data_en = data_en_d3;
	
	
	
	
	reg		[7:0]	rkey_part0,rkey_part1,rkey_part2,rkey_part3;
	reg		[7:0]	rkey_part4,rkey_part5,rkey_part6,rkey_part7;
	reg		[7:0]	rkey_part8,rkey_part9,rkey_part10,rkey_part11;
	reg		[7:0]	rkey_part12,rkey_part13,rkey_part14,rkey_part15;
	
	// 
	always @(`CLK_RST_EDGE)
		if (`ZST)	{rkey_part0, rkey_part1, rkey_part2, rkey_part3,
					 rkey_part4, rkey_part5, rkey_part6, rkey_part7,
					 rkey_part8, rkey_part9, rkey_part10,rkey_part11,
					 rkey_part12,rkey_part13,rkey_part14,rkey_part15} <= 0;
		//else begin
		else if (data_en) begin
			rkey_part0  <= key_in[1 *8-1 -:8];
            rkey_part4  <= key_in[2 *8-1 -:8];
            rkey_part8  <= key_in[3 *8-1 -:8];
            rkey_part12 <= key_in[4 *8-1 -:8];
            rkey_part1  <= key_in[5 *8-1 -:8];
            rkey_part5  <= key_in[6 *8-1 -:8];
            rkey_part9  <= key_in[7 *8-1 -:8];
            rkey_part13 <= key_in[8 *8-1 -:8];
            rkey_part2  <= key_in[9 *8-1 -:8];
            rkey_part6  <= key_in[10*8-1 -:8];
            rkey_part10 <= key_in[11*8-1 -:8];
            rkey_part14 <= key_in[12*8-1 -:8];
            rkey_part3  <= key_in[13*8-1 -:8];
            rkey_part7  <= key_in[14*8-1 -:8];
            rkey_part11 <= key_in[15*8-1 -:8];
            rkey_part15 <= key_in[16*8-1 -:8];
		end
		
	reg		[7:0]	state_t0_0,state_t1_0,state_t2_0,state_t3_0;
	reg		[7:0]	state_t4_0,state_t5_0,state_t6_0,state_t7_0;
	reg		[7:0]	state_t8_0,state_t9_0,state_t10_0,state_t11_0;
	reg		[7:0]	state_t12_0,state_t13_0,state_t14_0,state_t15_0;
//	always @(`CLK_RST_EDGE)
//		if (`RST)	{state_t0_0,state_t1_0,state_t2_0,state_t3_0,
//                     state_t4_0,state_t5_0,state_t6_0,state_t7_0,
//                     state_t8_0,state_t9_0,state_t10_0,state_t11_0,
//                     state_t12_0,state_t13_0,state_t14_0,state_t15_0} <= 0;
//		//else begin
//		else if (data_en) begin
//			state_t0_0 <= data_in[1 *8-1 -:8];
//            state_t4_0 <= data_in[2 *8-1 -:8];
//            state_t8_0 <= data_in[3 *8-1 -:8];
//            state_t12_0 <= data_in[4 *8-1 -:8];
//            state_t1_0 <= data_in[5 *8-1 -:8];
//            state_t5_0 <= data_in[6 *8-1 -:8];
//            state_t9_0 <= data_in[7 *8-1 -:8];
//            state_t13_0 <= data_in[8 *8-1 -:8];
//            state_t2_0 <= data_in[9 *8-1 -:8];
//            state_t6_0 <= data_in[10*8-1 -:8];
//            state_t10_0 <= data_in[11*8-1 -:8];
//            state_t14_0 <= data_in[12*8-1 -:8];
//            state_t3_0 <= data_in[13*8-1 -:8];
//            state_t7_0 <= data_in[14*8-1 -:8];
//            state_t11_0 <= data_in[15*8-1 -:8];
//            state_t15_0 <= data_in[16*8-1 -:8];
//		end
	always @(*) begin
		state_t0_0  = data_in[1 *8-1 -:8];
		state_t4_0  = data_in[2 *8-1 -:8];
		state_t8_0  = data_in[3 *8-1 -:8];
		state_t12_0 = data_in[4 *8-1 -:8];
		state_t1_0  = data_in[5 *8-1 -:8];
		state_t5_0  = data_in[6 *8-1 -:8];
		state_t9_0  = data_in[7 *8-1 -:8];
		state_t13_0 = data_in[8 *8-1 -:8];
		state_t2_0  = data_in[9 *8-1 -:8];
		state_t6_0  = data_in[10*8-1 -:8];
		state_t10_0 = data_in[11*8-1 -:8];
		state_t14_0 = data_in[12*8-1 -:8];
		state_t3_0  = data_in[13*8-1 -:8];
		state_t7_0  = data_in[14*8-1 -:8];
		state_t11_0 = data_in[15*8-1 -:8];
		state_t15_0 = data_in[16*8-1 -:8];
	end
///get data stage1 -- SubBytes
	reg		[7:0]	aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7;
	reg		[7:0]	aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15;
	wire	[7:0]	qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3;
	wire	[7:0]	qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7;
	wire	[7:0]	qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11;
	wire	[7:0]	qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15;

	
	
	always @(*) begin
		 aa_sbox0  = state_t0_0  ;
		 aa_sbox1  = state_t1_0  ;
		 aa_sbox2  = state_t2_0  ;
		 aa_sbox3  = state_t3_0  ;
		 aa_sbox4  = state_t4_0  ;
		 aa_sbox5  = state_t5_0  ;
		 aa_sbox6  = state_t6_0  ;
		 aa_sbox7  = state_t7_0  ;
		 aa_sbox8  = state_t8_0  ;
		 aa_sbox9  = state_t9_0  ;
	     aa_sbox10 = state_t10_0 ;
	     aa_sbox11 = state_t11_0 ;
	     aa_sbox12 = state_t12_0 ;
	     aa_sbox13 = state_t13_0 ;
	     aa_sbox14 = state_t14_0 ;
	     aa_sbox15 = state_t15_0 ;
	end
		
		
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	{aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7,
//                     aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15} <= 0;
//		else begin
//            aa_sbox0  <= state_t0_0  ;
//            aa_sbox1  <= state_t1_0  ;
//            aa_sbox2  <= state_t2_0  ;
//            aa_sbox3  <= state_t3_0  ;
//            aa_sbox4  <= state_t4_0  ;
//            aa_sbox5  <= state_t5_0  ;
//            aa_sbox6  <= state_t6_0  ;
//            aa_sbox7  <= state_t7_0  ;
//            aa_sbox8  <= state_t8_0  ;
//            aa_sbox9  <= state_t9_0  ;
//            aa_sbox10 <= state_t10_0 ;
//            aa_sbox11 <= state_t11_0 ;
//            aa_sbox12 <= state_t12_0 ;
//            aa_sbox13 <= state_t13_0 ;
//            aa_sbox14 <= state_t14_0 ;
//            aa_sbox15 <= state_t15_0 ;
//		end

	reg		[7:0]	qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1;
	reg		[7:0]	qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1;
	reg		[7:0]	qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1;
	reg		[7:0]	qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
                     qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
                     qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
                     qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 0;
		else {qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
              qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
              qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
              qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 
				{qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3,
                 qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7,
                 qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11,
                 qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15};

	wire	[7:0]	state_t0_1,state_t1_1,state_t2_1,state_t3_1;
	wire	[7:0]	state_t4_1,state_t5_1,state_t6_1,state_t7_1;
	wire	[7:0]	state_t8_1,state_t9_1,state_t10_1,state_t11_1;
	wire	[7:0]	state_t12_1,state_t13_1,state_t14_1,state_t15_1;
//	assign {state_t0_1,state_t1_1,state_t2_1,state_t3_1,
//            state_t4_1,state_t5_1,state_t6_1,state_t7_1,
//            state_t8_1,state_t9_1,state_t10_1,state_t11_1,
//            state_t12_1,state_t13_1,state_t14_1,state_t15_1} = 
//			{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
//	         qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
//             qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
//             qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} ;
	assign {state_t0_1,state_t1_1,state_t2_1,state_t3_1,
            state_t4_1,state_t5_1,state_t6_1,state_t7_1,
            state_t8_1,state_t9_1,state_t10_1,state_t11_1,
            state_t12_1,state_t13_1,state_t14_1,state_t15_1} = 
				{qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3,
                 qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7,
                 qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11,
                 qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15};

///get data stage2 -- ShiftRows
	wire	[7:0]	state_t0_2,state_t1_2,state_t2_2,state_t3_2;
	wire	[7:0]	state_t4_2,state_t5_2,state_t6_2,state_t7_2;
	wire	[7:0]	state_t8_2,state_t9_2,state_t10_2,state_t11_2;
	wire	[7:0]	state_t12_2,state_t13_2,state_t14_2,state_t15_2;
	assign	{state_t0_2,state_t1_2,state_t2_2,state_t3_2,
             state_t4_2,state_t5_2,state_t6_2,state_t7_2,
             state_t8_2,state_t9_2,state_t10_2,state_t11_2,
             state_t12_2,state_t13_2,state_t14_2,state_t15_2} =
				{state_t0_1,state_t1_1,state_t2_1,state_t3_1,
                 state_t5_1,state_t6_1,state_t7_1,state_t4_1,
                 state_t10_1,state_t11_1,state_t8_1,state_t9_1,
                 state_t15_1,state_t12_1,state_t13_1,state_t14_1} ;


///get data stage3 -- MixColumns
	wire	[7:0]	state_t0_3,state_t1_3,state_t2_3,state_t3_3;
	wire	[7:0]	state_t4_3,state_t5_3,state_t6_3,state_t7_3;
	wire	[7:0]	state_t8_3,state_t9_3,state_t10_3,state_t11_3;
	wire	[7:0]	state_t12_3,state_t13_3,state_t14_3,state_t15_3;
	mixcolums_1clk mixcolums0(clk,rstn,state_t0_2,state_t4_2,state_t8_2,state_t12_2,state_t0_3,state_t4_3,state_t8_3,state_t12_3);
	mixcolums_1clk mixcolums1(clk,rstn,state_t1_2,state_t5_2,state_t9_2,state_t13_2,state_t1_3,state_t5_3,state_t9_3,state_t13_3);
	mixcolums_1clk mixcolums2(clk,rstn,state_t2_2,state_t6_2,state_t10_2,state_t14_2,state_t2_3,state_t6_3,state_t10_3,state_t14_3);
	mixcolums_1clk mixcolums3(clk,rstn,state_t3_2,state_t7_2,state_t11_2,state_t15_2,state_t3_3,state_t7_3,state_t11_3,state_t15_3);
	
	
	
// AddRoundKey
	
	wire 	[127:0]	enc_data_b1 = { state_t15_3, state_t11_3, state_t7_3, state_t3_3,
									state_t14_3, state_t10_3, state_t6_3, state_t2_3,
									state_t13_3, state_t9_3, state_t5_3, state_t1_3,
									state_t12_3, state_t8_3, state_t4_3, state_t0_3};
	always @(`CLK_RST_EDGE)
		if (`RST)	enc_data <= 0;
		else        enc_data <=  enc_data_b1 ^ key_in_d2;
	


////////////////////////////////////////////////////////////////////////////////////
/////// the ram or rom for ecb

	sbox_rom sbox_rom0 (aa_sbox0 ,1'b1,clk,qa_sbox0 );
	sbox_rom sbox_rom1 (aa_sbox1 ,1'b1,clk,qa_sbox1 );
	sbox_rom sbox_rom2 (aa_sbox2 ,1'b1,clk,qa_sbox2 );
	sbox_rom sbox_rom3 (aa_sbox3 ,1'b1,clk,qa_sbox3 );
	sbox_rom sbox_rom4 (aa_sbox4 ,1'b1,clk,qa_sbox4 );
	sbox_rom sbox_rom5 (aa_sbox5 ,1'b1,clk,qa_sbox5 );
	sbox_rom sbox_rom6 (aa_sbox6 ,1'b1,clk,qa_sbox6 );
	sbox_rom sbox_rom7 (aa_sbox7 ,1'b1,clk,qa_sbox7 );
	sbox_rom sbox_rom8 (aa_sbox8 ,1'b1,clk,qa_sbox8 );
	sbox_rom sbox_rom9 (aa_sbox9 ,1'b1,clk,qa_sbox9 );
	sbox_rom sbox_rom10(aa_sbox10,1'b1,clk,qa_sbox10);
	sbox_rom sbox_rom11(aa_sbox11,1'b1,clk,qa_sbox11);
	sbox_rom sbox_rom12(aa_sbox12,1'b1,clk,qa_sbox12);
	sbox_rom sbox_rom13(aa_sbox13,1'b1,clk,qa_sbox13);
	sbox_rom sbox_rom14(aa_sbox14,1'b1,clk,qa_sbox14);
	sbox_rom sbox_rom15(aa_sbox15,1'b1,clk,qa_sbox15);



endmodule




// 6 clk
module aes_lowclk(
///system
	input					clk , 		
	input					rstn,
	input		[127:0]		key_in,		

	input					data_en,   
	input		[127:0]		data_in,   //  coloum order
	
	output					enc_data_en,
	output	reg	[127:0]		enc_data
);

	reg		[127:0]	key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= 0;
		else		{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= {key_in, key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7};
	
	reg				data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= 0;
		else		{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= {data_en, data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7};
	
	//assign enc_data_en = data_en_d8;
	assign enc_data_en = data_en_d6;
	
	
	
	
	reg		[7:0]	rkey_part0,rkey_part1,rkey_part2,rkey_part3;
	reg		[7:0]	rkey_part4,rkey_part5,rkey_part6,rkey_part7;
	reg		[7:0]	rkey_part8,rkey_part9,rkey_part10,rkey_part11;
	reg		[7:0]	rkey_part12,rkey_part13,rkey_part14,rkey_part15;
	
	// 
	always @(`CLK_RST_EDGE)
		if (`ZST)	{rkey_part0, rkey_part1, rkey_part2, rkey_part3,
					 rkey_part4, rkey_part5, rkey_part6, rkey_part7,
					 rkey_part8, rkey_part9, rkey_part10,rkey_part11,
					 rkey_part12,rkey_part13,rkey_part14,rkey_part15} <= 0;
		//else begin
		else if (data_en) begin
			rkey_part0  <= key_in[1 *8-1 -:8];
            rkey_part4  <= key_in[2 *8-1 -:8];
            rkey_part8  <= key_in[3 *8-1 -:8];
            rkey_part12 <= key_in[4 *8-1 -:8];
            rkey_part1  <= key_in[5 *8-1 -:8];
            rkey_part5  <= key_in[6 *8-1 -:8];
            rkey_part9  <= key_in[7 *8-1 -:8];
            rkey_part13 <= key_in[8 *8-1 -:8];
            rkey_part2  <= key_in[9 *8-1 -:8];
            rkey_part6  <= key_in[10*8-1 -:8];
            rkey_part10 <= key_in[11*8-1 -:8];
            rkey_part14 <= key_in[12*8-1 -:8];
            rkey_part3  <= key_in[13*8-1 -:8];
            rkey_part7  <= key_in[14*8-1 -:8];
            rkey_part11 <= key_in[15*8-1 -:8];
            rkey_part15 <= key_in[16*8-1 -:8];
		end
		
	reg		[7:0]	state_t0_0,state_t1_0,state_t2_0,state_t3_0;
	reg		[7:0]	state_t4_0,state_t5_0,state_t6_0,state_t7_0;
	reg		[7:0]	state_t8_0,state_t9_0,state_t10_0,state_t11_0;
	reg		[7:0]	state_t12_0,state_t13_0,state_t14_0,state_t15_0;
	always @(`CLK_RST_EDGE)
		if (`RST)	{state_t0_0,state_t1_0,state_t2_0,state_t3_0,
                     state_t4_0,state_t5_0,state_t6_0,state_t7_0,
                     state_t8_0,state_t9_0,state_t10_0,state_t11_0,
                     state_t12_0,state_t13_0,state_t14_0,state_t15_0} <= 0;
		//else begin
		else if (data_en) begin
			state_t0_0 <= data_in[1 *8-1 -:8];
            state_t4_0 <= data_in[2 *8-1 -:8];
            state_t8_0 <= data_in[3 *8-1 -:8];
            state_t12_0 <= data_in[4 *8-1 -:8];
            state_t1_0 <= data_in[5 *8-1 -:8];
            state_t5_0 <= data_in[6 *8-1 -:8];
            state_t9_0 <= data_in[7 *8-1 -:8];
            state_t13_0 <= data_in[8 *8-1 -:8];
            state_t2_0 <= data_in[9 *8-1 -:8];
            state_t6_0 <= data_in[10*8-1 -:8];
            state_t10_0 <= data_in[11*8-1 -:8];
            state_t14_0 <= data_in[12*8-1 -:8];
            state_t3_0 <= data_in[13*8-1 -:8];
            state_t7_0 <= data_in[14*8-1 -:8];
            state_t11_0 <= data_in[15*8-1 -:8];
            state_t15_0 <= data_in[16*8-1 -:8];
		end
///get data stage1 -- SubBytes
	reg		[7:0]	aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7;
	reg		[7:0]	aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15;
	wire	[7:0]	qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3;
	wire	[7:0]	qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7;
	wire	[7:0]	qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11;
	wire	[7:0]	qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15;

	
	
	always @(*) begin
		 aa_sbox0  = state_t0_0  ;
		 aa_sbox1  = state_t1_0  ;
		 aa_sbox2  = state_t2_0  ;
		 aa_sbox3  = state_t3_0  ;
		 aa_sbox4  = state_t4_0  ;
		 aa_sbox5  = state_t5_0  ;
		 aa_sbox6  = state_t6_0  ;
		 aa_sbox7  = state_t7_0  ;
		 aa_sbox8  = state_t8_0  ;
		 aa_sbox9  = state_t9_0  ;
	     aa_sbox10 = state_t10_0 ;
	     aa_sbox11 = state_t11_0 ;
	     aa_sbox12 = state_t12_0 ;
	     aa_sbox13 = state_t13_0 ;
	     aa_sbox14 = state_t14_0 ;
	     aa_sbox15 = state_t15_0 ;
	end
		
		
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	{aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7,
//                     aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15} <= 0;
//		else begin
//            aa_sbox0  <= state_t0_0  ;
//            aa_sbox1  <= state_t1_0  ;
//            aa_sbox2  <= state_t2_0  ;
//            aa_sbox3  <= state_t3_0  ;
//            aa_sbox4  <= state_t4_0  ;
//            aa_sbox5  <= state_t5_0  ;
//            aa_sbox6  <= state_t6_0  ;
//            aa_sbox7  <= state_t7_0  ;
//            aa_sbox8  <= state_t8_0  ;
//            aa_sbox9  <= state_t9_0  ;
//            aa_sbox10 <= state_t10_0 ;
//            aa_sbox11 <= state_t11_0 ;
//            aa_sbox12 <= state_t12_0 ;
//            aa_sbox13 <= state_t13_0 ;
//            aa_sbox14 <= state_t14_0 ;
//            aa_sbox15 <= state_t15_0 ;
//		end

	reg		[7:0]	qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1;
	reg		[7:0]	qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1;
	reg		[7:0]	qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1;
	reg		[7:0]	qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
                     qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
                     qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
                     qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 0;
		else {qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
              qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
              qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
              qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 
				{qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3,
                 qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7,
                 qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11,
                 qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15};

	wire	[7:0]	state_t0_1,state_t1_1,state_t2_1,state_t3_1;
	wire	[7:0]	state_t4_1,state_t5_1,state_t6_1,state_t7_1;
	wire	[7:0]	state_t8_1,state_t9_1,state_t10_1,state_t11_1;
	wire	[7:0]	state_t12_1,state_t13_1,state_t14_1,state_t15_1;
	assign {state_t0_1,state_t1_1,state_t2_1,state_t3_1,
            state_t4_1,state_t5_1,state_t6_1,state_t7_1,
            state_t8_1,state_t9_1,state_t10_1,state_t11_1,
            state_t12_1,state_t13_1,state_t14_1,state_t15_1} = 
			{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
	         qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
             qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
             qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} ;

///get data stage2 -- ShiftRows
	wire	[7:0]	state_t0_2,state_t1_2,state_t2_2,state_t3_2;
	wire	[7:0]	state_t4_2,state_t5_2,state_t6_2,state_t7_2;
	wire	[7:0]	state_t8_2,state_t9_2,state_t10_2,state_t11_2;
	wire	[7:0]	state_t12_2,state_t13_2,state_t14_2,state_t15_2;
	assign	{state_t0_2,state_t1_2,state_t2_2,state_t3_2,
             state_t4_2,state_t5_2,state_t6_2,state_t7_2,
             state_t8_2,state_t9_2,state_t10_2,state_t11_2,
             state_t12_2,state_t13_2,state_t14_2,state_t15_2} =
				{state_t0_1,state_t1_1,state_t2_1,state_t3_1,
                 state_t5_1,state_t6_1,state_t7_1,state_t4_1,
                 state_t10_1,state_t11_1,state_t8_1,state_t9_1,
                 state_t15_1,state_t12_1,state_t13_1,state_t14_1} ;


///get data stage3 -- MixColumns
	wire	[7:0]	state_t0_3,state_t1_3,state_t2_3,state_t3_3;
	wire	[7:0]	state_t4_3,state_t5_3,state_t6_3,state_t7_3;
	wire	[7:0]	state_t8_3,state_t9_3,state_t10_3,state_t11_3;
	wire	[7:0]	state_t12_3,state_t13_3,state_t14_3,state_t15_3;
	mixcolums_2clk mixcolums0(clk,rstn,state_t0_2,state_t4_2,state_t8_2,state_t12_2,state_t0_3,state_t4_3,state_t8_3,state_t12_3);
	mixcolums_2clk mixcolums1(clk,rstn,state_t1_2,state_t5_2,state_t9_2,state_t13_2,state_t1_3,state_t5_3,state_t9_3,state_t13_3);
	mixcolums_2clk mixcolums2(clk,rstn,state_t2_2,state_t6_2,state_t10_2,state_t14_2,state_t2_3,state_t6_3,state_t10_3,state_t14_3);
	mixcolums_2clk mixcolums3(clk,rstn,state_t3_2,state_t7_2,state_t11_2,state_t15_2,state_t3_3,state_t7_3,state_t11_3,state_t15_3);
	
	
	
// AddRoundKey
	
	wire 	[127:0]	enc_data_b1 = { state_t15_3, state_t11_3, state_t7_3, state_t3_3,
									state_t14_3, state_t10_3, state_t6_3, state_t2_3,
									state_t13_3, state_t9_3, state_t5_3, state_t1_3,
									state_t12_3, state_t8_3, state_t4_3, state_t0_3};
	always @(`CLK_RST_EDGE)
		if (`RST)	enc_data <= 0;
	//	else        enc_data <=  enc_data_b1 ^ key_in_d7;
	//	else        enc_data <=  enc_data_b1 ^ key_in_d6;
		else        enc_data <=  enc_data_b1 ^ key_in_d5;
	


////////////////////////////////////////////////////////////////////////////////////
/////// the ram or rom for ecb

	sbox_rom sbox_rom0 (aa_sbox0 ,1'b1,clk,qa_sbox0 );
	sbox_rom sbox_rom1 (aa_sbox1 ,1'b1,clk,qa_sbox1 );
	sbox_rom sbox_rom2 (aa_sbox2 ,1'b1,clk,qa_sbox2 );
	sbox_rom sbox_rom3 (aa_sbox3 ,1'b1,clk,qa_sbox3 );
	sbox_rom sbox_rom4 (aa_sbox4 ,1'b1,clk,qa_sbox4 );
	sbox_rom sbox_rom5 (aa_sbox5 ,1'b1,clk,qa_sbox5 );
	sbox_rom sbox_rom6 (aa_sbox6 ,1'b1,clk,qa_sbox6 );
	sbox_rom sbox_rom7 (aa_sbox7 ,1'b1,clk,qa_sbox7 );
	sbox_rom sbox_rom8 (aa_sbox8 ,1'b1,clk,qa_sbox8 );
	sbox_rom sbox_rom9 (aa_sbox9 ,1'b1,clk,qa_sbox9 );
	sbox_rom sbox_rom10(aa_sbox10,1'b1,clk,qa_sbox10);
	sbox_rom sbox_rom11(aa_sbox11,1'b1,clk,qa_sbox11);
	sbox_rom sbox_rom12(aa_sbox12,1'b1,clk,qa_sbox12);
	sbox_rom sbox_rom13(aa_sbox13,1'b1,clk,qa_sbox13);
	sbox_rom sbox_rom14(aa_sbox14,1'b1,clk,qa_sbox14);
	sbox_rom sbox_rom15(aa_sbox15,1'b1,clk,qa_sbox15);



endmodule




// 7 clk
module aes_ecb_enc(
///system
	input					clk , 		
	input					rstn,
	input		[127:0]		key_in,		

	input					data_en,   
	input		[127:0]		data_in,   //  coloum order
	
	output					enc_data_en,
	output	reg	[127:0]		enc_data
);

	reg		[127:0]	key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= 0;
		else		{key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7, key_in_d8} <= {key_in, key_in_d1, key_in_d2, key_in_d3, key_in_d4, key_in_d5, key_in_d6, key_in_d7};
	
	reg				data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= 0;
		else		{data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7, data_en_d8} <= {data_en, data_en_d1, data_en_d2, data_en_d3, data_en_d4, data_en_d5, data_en_d6, data_en_d7};
	
	assign enc_data_en = data_en_d8;
	
	
	
	
	reg		[7:0]	rkey_part0,rkey_part1,rkey_part2,rkey_part3;
	reg		[7:0]	rkey_part4,rkey_part5,rkey_part6,rkey_part7;
	reg		[7:0]	rkey_part8,rkey_part9,rkey_part10,rkey_part11;
	reg		[7:0]	rkey_part12,rkey_part13,rkey_part14,rkey_part15;
	
	// 
	always @(`CLK_RST_EDGE)
		if (`ZST)	{rkey_part0, rkey_part1, rkey_part2, rkey_part3,
					 rkey_part4, rkey_part5, rkey_part6, rkey_part7,
					 rkey_part8, rkey_part9, rkey_part10,rkey_part11,
					 rkey_part12,rkey_part13,rkey_part14,rkey_part15} <= 0;
		//else begin
		else if (data_en) begin
			rkey_part0  <= key_in[1 *8-1 -:8];
            rkey_part4  <= key_in[2 *8-1 -:8];
            rkey_part8  <= key_in[3 *8-1 -:8];
            rkey_part12 <= key_in[4 *8-1 -:8];
            rkey_part1  <= key_in[5 *8-1 -:8];
            rkey_part5  <= key_in[6 *8-1 -:8];
            rkey_part9  <= key_in[7 *8-1 -:8];
            rkey_part13 <= key_in[8 *8-1 -:8];
            rkey_part2  <= key_in[9 *8-1 -:8];
            rkey_part6  <= key_in[10*8-1 -:8];
            rkey_part10 <= key_in[11*8-1 -:8];
            rkey_part14 <= key_in[12*8-1 -:8];
            rkey_part3  <= key_in[13*8-1 -:8];
            rkey_part7  <= key_in[14*8-1 -:8];
            rkey_part11 <= key_in[15*8-1 -:8];
            rkey_part15 <= key_in[16*8-1 -:8];
		end
		
	reg		[7:0]	state_t0_0,state_t1_0,state_t2_0,state_t3_0;
	reg		[7:0]	state_t4_0,state_t5_0,state_t6_0,state_t7_0;
	reg		[7:0]	state_t8_0,state_t9_0,state_t10_0,state_t11_0;
	reg		[7:0]	state_t12_0,state_t13_0,state_t14_0,state_t15_0;
	always @(`CLK_RST_EDGE)
		if (`RST)	{state_t0_0,state_t1_0,state_t2_0,state_t3_0,
                     state_t4_0,state_t5_0,state_t6_0,state_t7_0,
                     state_t8_0,state_t9_0,state_t10_0,state_t11_0,
                     state_t12_0,state_t13_0,state_t14_0,state_t15_0} <= 0;
		//else begin
		else if (data_en) begin
			state_t0_0 <= data_in[1 *8-1 -:8];
            state_t4_0 <= data_in[2 *8-1 -:8];
            state_t8_0 <= data_in[3 *8-1 -:8];
            state_t12_0 <= data_in[4 *8-1 -:8];
            state_t1_0 <= data_in[5 *8-1 -:8];
            state_t5_0 <= data_in[6 *8-1 -:8];
            state_t9_0 <= data_in[7 *8-1 -:8];
            state_t13_0 <= data_in[8 *8-1 -:8];
            state_t2_0 <= data_in[9 *8-1 -:8];
            state_t6_0 <= data_in[10*8-1 -:8];
            state_t10_0 <= data_in[11*8-1 -:8];
            state_t14_0 <= data_in[12*8-1 -:8];
            state_t3_0 <= data_in[13*8-1 -:8];
            state_t7_0 <= data_in[14*8-1 -:8];
            state_t11_0 <= data_in[15*8-1 -:8];
            state_t15_0 <= data_in[16*8-1 -:8];
		end
///get data stage1 -- SubBytes
	reg		[7:0]	aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7;
	reg		[7:0]	aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15;
	wire	[7:0]	qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3;
	wire	[7:0]	qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7;
	wire	[7:0]	qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11;
	wire	[7:0]	qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15;

	
	
	always @(*) begin
		 aa_sbox0  = state_t0_0  ;
		 aa_sbox1  = state_t1_0  ;
		 aa_sbox2  = state_t2_0  ;
		 aa_sbox3  = state_t3_0  ;
		 aa_sbox4  = state_t4_0  ;
		 aa_sbox5  = state_t5_0  ;
		 aa_sbox6  = state_t6_0  ;
		 aa_sbox7  = state_t7_0  ;
		 aa_sbox8  = state_t8_0  ;
		 aa_sbox9  = state_t9_0  ;
	     aa_sbox10 = state_t10_0 ;
	     aa_sbox11 = state_t11_0 ;
	     aa_sbox12 = state_t12_0 ;
	     aa_sbox13 = state_t13_0 ;
	     aa_sbox14 = state_t14_0 ;
	     aa_sbox15 = state_t15_0 ;
	end
		
		
//	always @(`CLK_RST_EDGE)
//		if (`ZST)	{aa_sbox0,aa_sbox1,aa_sbox2,aa_sbox3,aa_sbox4,aa_sbox5,aa_sbox6,aa_sbox7,
//                     aa_sbox8,aa_sbox9,aa_sbox10,aa_sbox11,aa_sbox12,aa_sbox13,aa_sbox14,aa_sbox15} <= 0;
//		else begin
//            aa_sbox0  <= state_t0_0  ;
//            aa_sbox1  <= state_t1_0  ;
//            aa_sbox2  <= state_t2_0  ;
//            aa_sbox3  <= state_t3_0  ;
//            aa_sbox4  <= state_t4_0  ;
//            aa_sbox5  <= state_t5_0  ;
//            aa_sbox6  <= state_t6_0  ;
//            aa_sbox7  <= state_t7_0  ;
//            aa_sbox8  <= state_t8_0  ;
//            aa_sbox9  <= state_t9_0  ;
//            aa_sbox10 <= state_t10_0 ;
//            aa_sbox11 <= state_t11_0 ;
//            aa_sbox12 <= state_t12_0 ;
//            aa_sbox13 <= state_t13_0 ;
//            aa_sbox14 <= state_t14_0 ;
//            aa_sbox15 <= state_t15_0 ;
//		end

	reg		[7:0]	qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1;
	reg		[7:0]	qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1;
	reg		[7:0]	qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1;
	reg		[7:0]	qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
                     qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
                     qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
                     qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 0;
		else {qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
              qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
              qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
              qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} <= 
				{qa_sbox0,qa_sbox1,qa_sbox2,qa_sbox3,
                 qa_sbox4,qa_sbox5,qa_sbox6,qa_sbox7,
                 qa_sbox8,qa_sbox9,qa_sbox10,qa_sbox11,
                 qa_sbox12,qa_sbox13,qa_sbox14,qa_sbox15};

	wire	[7:0]	state_t0_1,state_t1_1,state_t2_1,state_t3_1;
	wire	[7:0]	state_t4_1,state_t5_1,state_t6_1,state_t7_1;
	wire	[7:0]	state_t8_1,state_t9_1,state_t10_1,state_t11_1;
	wire	[7:0]	state_t12_1,state_t13_1,state_t14_1,state_t15_1;
	assign {state_t0_1,state_t1_1,state_t2_1,state_t3_1,
            state_t4_1,state_t5_1,state_t6_1,state_t7_1,
            state_t8_1,state_t9_1,state_t10_1,state_t11_1,
            state_t12_1,state_t13_1,state_t14_1,state_t15_1} = 
			{qa_sbox0_d1,qa_sbox1_d1,qa_sbox2_d1,qa_sbox3_d1,
	         qa_sbox4_d1,qa_sbox5_d1,qa_sbox6_d1,qa_sbox7_d1,
             qa_sbox8_d1,qa_sbox9_d1,qa_sbox10_d1,qa_sbox11_d1,
             qa_sbox12_d1,qa_sbox13_d1,qa_sbox14_d1,qa_sbox15_d1} ;

///get data stage2 -- ShiftRows
	wire	[7:0]	state_t0_2,state_t1_2,state_t2_2,state_t3_2;
	wire	[7:0]	state_t4_2,state_t5_2,state_t6_2,state_t7_2;
	wire	[7:0]	state_t8_2,state_t9_2,state_t10_2,state_t11_2;
	wire	[7:0]	state_t12_2,state_t13_2,state_t14_2,state_t15_2;
	assign	{state_t0_2,state_t1_2,state_t2_2,state_t3_2,
             state_t4_2,state_t5_2,state_t6_2,state_t7_2,
             state_t8_2,state_t9_2,state_t10_2,state_t11_2,
             state_t12_2,state_t13_2,state_t14_2,state_t15_2} =
				{state_t0_1,state_t1_1,state_t2_1,state_t3_1,
                 state_t5_1,state_t6_1,state_t7_1,state_t4_1,
                 state_t10_1,state_t11_1,state_t8_1,state_t9_1,
                 state_t15_1,state_t12_1,state_t13_1,state_t14_1} ;


///get data stage3 -- MixColumns
	wire	[7:0]	state_t0_3,state_t1_3,state_t2_3,state_t3_3;
	wire	[7:0]	state_t4_3,state_t5_3,state_t6_3,state_t7_3;
	wire	[7:0]	state_t8_3,state_t9_3,state_t10_3,state_t11_3;
	wire	[7:0]	state_t12_3,state_t13_3,state_t14_3,state_t15_3;
	mixcolums mixcolums0(clk,rstn,state_t0_2,state_t4_2,state_t8_2,state_t12_2,state_t0_3,state_t4_3,state_t8_3,state_t12_3);
	mixcolums mixcolums1(clk,rstn,state_t1_2,state_t5_2,state_t9_2,state_t13_2,state_t1_3,state_t5_3,state_t9_3,state_t13_3);
	mixcolums mixcolums2(clk,rstn,state_t2_2,state_t6_2,state_t10_2,state_t14_2,state_t2_3,state_t6_3,state_t10_3,state_t14_3);
	mixcolums mixcolums3(clk,rstn,state_t3_2,state_t7_2,state_t11_2,state_t15_2,state_t3_3,state_t7_3,state_t11_3,state_t15_3);
	
	
	
// AddRoundKey
	
	wire 	[127:0]	enc_data_b1 = { state_t15_3, state_t11_3, state_t7_3, state_t3_3,
									state_t14_3, state_t10_3, state_t6_3, state_t2_3,
									state_t13_3, state_t9_3, state_t5_3, state_t1_3,
									state_t12_3, state_t8_3, state_t4_3, state_t0_3};
	always @(`CLK_RST_EDGE)
		if (`RST)	enc_data <= 0;
	//	else        enc_data <=  enc_data_b1 ^ key_in_d7;
		else        enc_data <=  enc_data_b1 ^ key_in_d6;
	


////////////////////////////////////////////////////////////////////////////////////
/////// the ram or rom for ecb

	sbox_rom sbox_rom0 (aa_sbox0 ,1'b1,clk,qa_sbox0 );
	sbox_rom sbox_rom1 (aa_sbox1 ,1'b1,clk,qa_sbox1 );
	sbox_rom sbox_rom2 (aa_sbox2 ,1'b1,clk,qa_sbox2 );
	sbox_rom sbox_rom3 (aa_sbox3 ,1'b1,clk,qa_sbox3 );
	sbox_rom sbox_rom4 (aa_sbox4 ,1'b1,clk,qa_sbox4 );
	sbox_rom sbox_rom5 (aa_sbox5 ,1'b1,clk,qa_sbox5 );
	sbox_rom sbox_rom6 (aa_sbox6 ,1'b1,clk,qa_sbox6 );
	sbox_rom sbox_rom7 (aa_sbox7 ,1'b1,clk,qa_sbox7 );
	sbox_rom sbox_rom8 (aa_sbox8 ,1'b1,clk,qa_sbox8 );
	sbox_rom sbox_rom9 (aa_sbox9 ,1'b1,clk,qa_sbox9 );
	sbox_rom sbox_rom10(aa_sbox10,1'b1,clk,qa_sbox10);
	sbox_rom sbox_rom11(aa_sbox11,1'b1,clk,qa_sbox11);
	sbox_rom sbox_rom12(aa_sbox12,1'b1,clk,qa_sbox12);
	sbox_rom sbox_rom13(aa_sbox13,1'b1,clk,qa_sbox13);
	sbox_rom sbox_rom14(aa_sbox14,1'b1,clk,qa_sbox14);
	sbox_rom sbox_rom15(aa_sbox15,1'b1,clk,qa_sbox15);



endmodule


// 3 clk
module mixcolums(
	input				clk,
	input				rstn,
	input	[7:0]		data0,
	input	[7:0]		data1,
	input	[7:0]		data2,
	input	[7:0]		data3,
	output	reg	[7:0]	data0_o,
	output	reg	[7:0]	data1_o,
	output	reg	[7:0]	data2_o,
	output	reg	[7:0]	data3_o
);
	reg	[7:0]	Tmp_p0,Tmp_p1,Tmp;
	reg	[7:0]	Tm_p0_0,Tm_p1_0;
	reg	[7:0]	Tm_p0_1,Tm_p1_1;
	reg	[7:0]	Tm_p0_2,Tm_p1_2;
	reg	[7:0]	Tm_p0_3,Tm_p1_3;

	reg	[7:0]	data0_d1,data0_d2,data0_d3,data0_d4;
	reg	[7:0]	data1_d1,data1_d2,data1_d3,data1_d4;
	reg	[7:0]	data2_d1,data2_d2,data2_d3,data2_d4;
	reg	[7:0]	data3_d1,data3_d2,data3_d3,data3_d4;

	always @(`CLK_RST_EDGE)
		if (`ZST)	{data0_d1,data0_d2,data0_d3,data0_d4,
                     data1_d1,data1_d2,data1_d3,data1_d4,
                     data2_d1,data2_d2,data2_d3,data2_d4,
                     data3_d1,data3_d2,data3_d3,data3_d4} <= 0;
		else begin
			{data0_d1,data0_d2,data0_d3,data0_d4} <= {data0,data0_d1,data0_d2,data0_d3};
			{data1_d1,data1_d2,data1_d3,data1_d4} <= {data1,data1_d1,data1_d2,data1_d3};
			{data2_d1,data2_d2,data2_d3,data2_d4} <= {data2,data2_d1,data2_d2,data2_d3};
			{data3_d1,data3_d2,data3_d3,data3_d4} <= {data3,data3_d1,data3_d2,data3_d3};
		end

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tmp_p0 <= 0;
		else		Tmp_p0 <= data0 ^ data1;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tmp_p1 <= 0;
		else		Tmp_p1 <= data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tmp <= 0;
		else		Tmp <= Tmp_p0 ^ Tmp_p1;

//data0 part
	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p0_0 <= 0;
		else		Tm_p0_0 <= data0 ^ data1;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_0 <= 0;
		else		Tm_p1_0 <= Tm_p0_0[7] ? {Tm_p0_0[6:0],1'b0} ^ 8'h1b : {Tm_p0_0[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data0_o <= 0;
		else		data0_o <= data0_d2 ^ (Tm_p1_0 ^ Tmp) ;

//data1 part
	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p0_1 <= 0;
		else		Tm_p0_1 <= data1 ^ data2;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_1 <= 0;
		else		Tm_p1_1 <= Tm_p0_1[7] ? {Tm_p0_1[6:0],1'b0} ^ 8'h1b : {Tm_p0_1[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data1_o <= 0;
		else		data1_o <= data1_d2 ^ (Tm_p1_1 ^ Tmp) ;

//data2 part
	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p0_2 <= 0;
		else		Tm_p0_2 <= data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_2 <= 0;
		else		Tm_p1_2 <= Tm_p0_2[7] ? {Tm_p0_2[6:0],1'b0} ^ 8'h1b : {Tm_p0_2[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data2_o <= 0;
		else		data2_o <= data2_d2 ^ (Tm_p1_2 ^ Tmp) ;

//data3 part
	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p0_3 <= 0;
		else		Tm_p0_3 <= data3 ^ data0;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_3 <= 0;
		else		Tm_p1_3 <= Tm_p0_3[7] ? {Tm_p0_3[6:0],1'b0} ^ 8'h1b : {Tm_p0_3[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data3_o <= 0;
		else		data3_o <= data3_d2 ^ (Tm_p1_3 ^ Tmp) ;

endmodule

// 2 clk
module mixcolums_2clk(
	input				clk,
	input				rstn,
	input	[7:0]		data0,
	input	[7:0]		data1,
	input	[7:0]		data2,
	input	[7:0]		data3,
	output	reg	[7:0]	data0_o,
	output	reg	[7:0]	data1_o,
	output	reg	[7:0]	data2_o,
	output	reg	[7:0]	data3_o
);
	reg	[7:0]	Tmp_p0,Tmp_p1,Tmp;
	reg	[7:0]	Tm_p0_0,Tm_p1_0;
	reg	[7:0]	Tm_p0_1,Tm_p1_1;
	reg	[7:0]	Tm_p0_2,Tm_p1_2;
	reg	[7:0]	Tm_p0_3,Tm_p1_3;

	reg	[7:0]	data0_d1,data0_d2,data0_d3,data0_d4;
	reg	[7:0]	data1_d1,data1_d2,data1_d3,data1_d4;
	reg	[7:0]	data2_d1,data2_d2,data2_d3,data2_d4;
	reg	[7:0]	data3_d1,data3_d2,data3_d3,data3_d4;

	always @(`CLK_RST_EDGE)
		if (`ZST)	{data0_d1,data0_d2,data0_d3,data0_d4,
                     data1_d1,data1_d2,data1_d3,data1_d4,
                     data2_d1,data2_d2,data2_d3,data2_d4,
                     data3_d1,data3_d2,data3_d3,data3_d4} <= 0;
		else begin
			{data0_d1,data0_d2,data0_d3,data0_d4} <= {data0,data0_d1,data0_d2,data0_d3};
			{data1_d1,data1_d2,data1_d3,data1_d4} <= {data1,data1_d1,data1_d2,data1_d3};
			{data2_d1,data2_d2,data2_d3,data2_d4} <= {data2,data2_d1,data2_d2,data2_d3};
			{data3_d1,data3_d2,data3_d3,data3_d4} <= {data3,data3_d1,data3_d2,data3_d3};
		end

	always @(*)
		Tmp_p0 = data0 ^ data1;

	always @(*)
		Tmp_p1 = data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tmp <= 0;
		else		Tmp <= Tmp_p0 ^ Tmp_p1;

//data0 part
	always @(*)
		Tm_p0_0 = data0 ^ data1;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_0 <= 0;
		else		Tm_p1_0 <= Tm_p0_0[7] ? {Tm_p0_0[6:0],1'b0} ^ 8'h1b : {Tm_p0_0[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data0_o <= 0;
		else		data0_o <= data0_d1 ^ (Tm_p1_0 ^ Tmp) ;

//data1 part
	always @(*)
			Tm_p0_1  = data1 ^ data2;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_1 <= 0;
		else		Tm_p1_1 <= Tm_p0_1[7] ? {Tm_p0_1[6:0],1'b0} ^ 8'h1b : {Tm_p0_1[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data1_o <= 0;
		else		data1_o <= data1_d1 ^ (Tm_p1_1 ^ Tmp) ;

//data2 part
	always @(*)
			Tm_p0_2 = data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_2 <= 0;
		else		Tm_p1_2 <= Tm_p0_2[7] ? {Tm_p0_2[6:0],1'b0} ^ 8'h1b : {Tm_p0_2[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data2_o <= 0;
		else		data2_o <= data2_d1 ^ (Tm_p1_2 ^ Tmp) ;

//data3 part
	always @(*)
			Tm_p0_3 = data3 ^ data0;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_3 <= 0;
		else		Tm_p1_3 <= Tm_p0_3[7] ? {Tm_p0_3[6:0],1'b0} ^ 8'h1b : {Tm_p0_3[6:0],1'b0};

	always @(`CLK_RST_EDGE)
		if (`ZST)	data3_o <= 0;
		else		data3_o <= data3_d1 ^ (Tm_p1_3 ^ Tmp) ;

endmodule



// 1 clk
module mixcolums_1clk(
	input				clk,
	input				rstn,
	input	[7:0]		data0,
	input	[7:0]		data1,
	input	[7:0]		data2,
	input	[7:0]		data3,
	output	reg	[7:0]	data0_o,
	output	reg	[7:0]	data1_o,
	output	reg	[7:0]	data2_o,
	output	reg	[7:0]	data3_o
);
	reg	[7:0]	Tmp_p0,Tmp_p1,Tmp;
	reg	[7:0]	Tm_p0_0,Tm_p1_0;
	reg	[7:0]	Tm_p0_1,Tm_p1_1;
	reg	[7:0]	Tm_p0_2,Tm_p1_2;
	reg	[7:0]	Tm_p0_3,Tm_p1_3;

	reg	[7:0]	data0_d1,data0_d2,data0_d3,data0_d4;
	reg	[7:0]	data1_d1,data1_d2,data1_d3,data1_d4;
	reg	[7:0]	data2_d1,data2_d2,data2_d3,data2_d4;
	reg	[7:0]	data3_d1,data3_d2,data3_d3,data3_d4;

	always @(`CLK_RST_EDGE)
		if (`ZST)	{data0_d1,data0_d2,data0_d3,data0_d4,
                     data1_d1,data1_d2,data1_d3,data1_d4,
                     data2_d1,data2_d2,data2_d3,data2_d4,
                     data3_d1,data3_d2,data3_d3,data3_d4} <= 0;
		else begin
			{data0_d1,data0_d2,data0_d3,data0_d4} <= {data0,data0_d1,data0_d2,data0_d3};
			{data1_d1,data1_d2,data1_d3,data1_d4} <= {data1,data1_d1,data1_d2,data1_d3};
			{data2_d1,data2_d2,data2_d3,data2_d4} <= {data2,data2_d1,data2_d2,data2_d3};
			{data3_d1,data3_d2,data3_d3,data3_d4} <= {data3,data3_d1,data3_d2,data3_d3};
		end

	always @(*)
		Tmp_p0 = data0 ^ data1;

	always @(*)
		Tmp_p1 = data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tmp <= 0;
		else		Tmp <= Tmp_p0 ^ Tmp_p1;

//data0 part
	always @(*)
		Tm_p0_0 = data0 ^ data1;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_0 <= 0;
		else		Tm_p1_0 <= Tm_p0_0[7] ? {Tm_p0_0[6:0],1'b0} ^ 8'h1b : {Tm_p0_0[6:0],1'b0};

	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	data0_o <= 0;
	//	else		data0_o <= data0_d1 ^ (Tm_p1_0 ^ Tmp) ;
		
	always @(*)
		data0_o = data0_d1 ^ (Tm_p1_0 ^ Tmp) ;

		

//data1 part
	always @(*)
			Tm_p0_1  = data1 ^ data2;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_1 <= 0;
		else		Tm_p1_1 <= Tm_p0_1[7] ? {Tm_p0_1[6:0],1'b0} ^ 8'h1b : {Tm_p0_1[6:0],1'b0};

	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	data1_o <= 0;
	//	else		data1_o <= data1_d1 ^ (Tm_p1_1 ^ Tmp) ;
	always @(*)
		data1_o = data1_d1 ^ (Tm_p1_1 ^ Tmp) ;

//data2 part
	always @(*)
			Tm_p0_2 = data2 ^ data3;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_2 <= 0;
		else		Tm_p1_2 <= Tm_p0_2[7] ? {Tm_p0_2[6:0],1'b0} ^ 8'h1b : {Tm_p0_2[6:0],1'b0};

	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	data2_o <= 0;
	//	else		data2_o <= data2_d1 ^ (Tm_p1_2 ^ Tmp) ;
	always @(*)
			data2_o = data2_d1 ^ (Tm_p1_2 ^ Tmp) ;

//data3 part
	always @(*)
			Tm_p0_3 = data3 ^ data0;

	always @(`CLK_RST_EDGE)
		if (`ZST)	Tm_p1_3 <= 0;
		else		Tm_p1_3 <= Tm_p0_3[7] ? {Tm_p0_3[6:0],1'b0} ^ 8'h1b : {Tm_p0_3[6:0],1'b0};

	//always @(`CLK_RST_EDGE)
	//	if (`ZST)	data3_o <= 0;
	//	else		data3_o <= data3_d1 ^ (Tm_p1_3 ^ Tmp) ;
	always @(*)
			data3_o <= data3_d1 ^ (Tm_p1_3 ^ Tmp) ;

endmodule


module sbox_rom(
	address,
	clken,
	clock,
	q);

	input	[7:0]  address;
	input	  clken;
	input	  clock;
	output	reg	[7:0]  q;
	
(* ramstyle = "M20K" *)	reg	[7:0] rom[255:0];
	
	initial begin
		rom[0  ] =8'h63 ;
		rom[1  ] =8'h7c ;
		rom[2  ] =8'h77 ;
		rom[3  ] =8'h7b ;
		rom[4  ] =8'hf2 ;
		rom[5  ] =8'h6b ;
		rom[6  ] =8'h6f ;
		rom[7  ] =8'hc5 ;
		rom[8  ] =8'h30 ;
		rom[9  ] =8'h1  ;
		rom[10 ] =8'h67 ;
		rom[11 ] =8'h2b ;
		rom[12 ] =8'hfe ;
		rom[13 ] =8'hd7 ;
		rom[14 ] =8'hab ;
		rom[15 ] =8'h76 ;
		rom[16 ] =8'hca ;
		rom[17 ] =8'h82 ;
		rom[18 ] =8'hc9 ;
		rom[19 ] =8'h7d ;
		rom[20 ] =8'hfa ;
		rom[21 ] =8'h59 ;
		rom[22 ] =8'h47 ;
		rom[23 ] =8'hf0 ;
		rom[24 ] =8'had ;
		rom[25 ] =8'hd4 ;
		rom[26 ] =8'ha2 ;
		rom[27 ] =8'haf ;
		rom[28 ] =8'h9c ;
		rom[29 ] =8'ha4 ;
		rom[30 ] =8'h72 ;
		rom[31 ] =8'hc0 ;
		rom[32 ] =8'hb7 ;
		rom[33 ] =8'hfd ;
		rom[34 ] =8'h93 ;
		rom[35 ] =8'h26 ;
		rom[36 ] =8'h36 ;
		rom[37 ] =8'h3f ;
		rom[38 ] =8'hf7 ;
		rom[39 ] =8'hcc ;
		rom[40 ] =8'h34 ;
		rom[41 ] =8'ha5 ;
		rom[42 ] =8'he5 ;
		rom[43 ] =8'hf1 ;
		rom[44 ] =8'h71 ;
		rom[45 ] =8'hd8 ;
		rom[46 ] =8'h31 ;
		rom[47 ] =8'h15 ;
		rom[48 ] =8'h4  ;
		rom[49 ] =8'hc7 ;
		rom[50 ] =8'h23 ;
		rom[51 ] =8'hc3 ;
		rom[52 ] =8'h18 ;
		rom[53 ] =8'h96 ;
		rom[54 ] =8'h5  ;
		rom[55 ] =8'h9a ;
		rom[56 ] =8'h7  ;
		rom[57 ] =8'h12 ;
		rom[58 ] =8'h80 ;
		rom[59 ] =8'he2 ;
		rom[60 ] =8'heb ;
		rom[61 ] =8'h27 ;
		rom[62 ] =8'hb2 ;
		rom[63 ] =8'h75 ;
		rom[64 ] =8'h9  ;
		rom[65 ] =8'h83 ;
		rom[66 ] =8'h2c ;
		rom[67 ] =8'h1a ;
		rom[68 ] =8'h1b ;
		rom[69 ] =8'h6e ;
		rom[70 ] =8'h5a ;
		rom[71 ] =8'ha0 ;
		rom[72 ] =8'h52 ;
		rom[73 ] =8'h3b ;
		rom[74 ] =8'hd6 ;
		rom[75 ] =8'hb3 ;
		rom[76 ] =8'h29 ;
		rom[77 ] =8'he3 ;
		rom[78 ] =8'h2f ;
		rom[79 ] =8'h84 ;
		rom[80 ] =8'h53 ;
		rom[81 ] =8'hd1 ;
		rom[82 ] =8'h0  ;
		rom[83 ] =8'hed ;
		rom[84 ] =8'h20 ;
		rom[85 ] =8'hfc ;
		rom[86 ] =8'hb1 ;
		rom[87 ] =8'h5b ;
		rom[88 ] =8'h6a ;
		rom[89 ] =8'hcb ;
		rom[90 ] =8'hbe ;
		rom[91 ] =8'h39 ;
		rom[92 ] =8'h4a ;
		rom[93 ] =8'h4c ;
		rom[94 ] =8'h58 ;
		rom[95 ] =8'hcf ;
		rom[96 ] =8'hd0 ;
		rom[97 ] =8'hef ;
		rom[98 ] =8'haa ;
		rom[99 ] =8'hfb ;
		rom[100] =8'h43 ;
		rom[101] =8'h4d ;
		rom[102] =8'h33 ;
		rom[103] =8'h85 ;
		rom[104] =8'h45 ;
		rom[105] =8'hf9 ;
		rom[106] =8'h2  ;
		rom[107] =8'h7f ;
		rom[108] =8'h50 ;
		rom[109] =8'h3c ;
		rom[110] =8'h9f ;
		rom[111] =8'ha8 ;
		rom[112] =8'h51 ;
		rom[113] =8'ha3 ;
		rom[114] =8'h40 ;
		rom[115] =8'h8f ;
		rom[116] =8'h92 ;
		rom[117] =8'h9d ;
		rom[118] =8'h38 ;
		rom[119] =8'hf5 ;
		rom[120] =8'hbc ;
		rom[121] =8'hb6 ;
		rom[122] =8'hda ;
		rom[123] =8'h21 ;
		rom[124] =8'h10 ;
		rom[125] =8'hff ;
		rom[126] =8'hf3 ;
		rom[127] =8'hd2 ;
		rom[128] =8'hcd ;
		rom[129] =8'hc  ;
		rom[130] =8'h13 ;
		rom[131] =8'hec ;
		rom[132] =8'h5f ;
		rom[133] =8'h97 ;
		rom[134] =8'h44 ;
		rom[135] =8'h17 ;
		rom[136] =8'hc4 ;
		rom[137] =8'ha7 ;
		rom[138] =8'h7e ;
		rom[139] =8'h3d ;
		rom[140] =8'h64 ;
		rom[141] =8'h5d ;
		rom[142] =8'h19 ;
		rom[143] =8'h73 ;
		rom[144] =8'h60 ;
		rom[145] =8'h81 ;
		rom[146] =8'h4f ;
		rom[147] =8'hdc ;
		rom[148] =8'h22 ;
		rom[149] =8'h2a ;
		rom[150] =8'h90 ;
		rom[151] =8'h88 ;
		rom[152] =8'h46 ;
		rom[153] =8'hee ;
		rom[154] =8'hb8 ;
		rom[155] =8'h14 ;
		rom[156] =8'hde ;
		rom[157] =8'h5e ;
		rom[158] =8'hb  ;
		rom[159] =8'hdb ;
		rom[160] =8'he0 ;
		rom[161] =8'h32 ;
		rom[162] =8'h3a ;
		rom[163] =8'ha  ;
		rom[164] =8'h49 ;
		rom[165] =8'h6  ;
		rom[166] =8'h24 ;
		rom[167] =8'h5c ;
		rom[168] =8'hc2 ;
		rom[169] =8'hd3 ;
		rom[170] =8'hac ;
		rom[171] =8'h62 ;
		rom[172] =8'h91 ;
		rom[173] =8'h95 ;
		rom[174] =8'he4 ;
		rom[175] =8'h79 ;
		rom[176] =8'he7 ;
		rom[177] =8'hc8 ;
		rom[178] =8'h37 ;
		rom[179] =8'h6d ;
		rom[180] =8'h8d ;
		rom[181] =8'hd5 ;
		rom[182] =8'h4e ;
		rom[183] =8'ha9 ;
		rom[184] =8'h6c ;
		rom[185] =8'h56 ;
		rom[186] =8'hf4 ;
		rom[187] =8'hea ;
		rom[188] =8'h65 ;
		rom[189] =8'h7a ;
		rom[190] =8'hae ;
		rom[191] =8'h8  ;
		rom[192] =8'hba ;
		rom[193] =8'h78 ;
		rom[194] =8'h25 ;
		rom[195] =8'h2e ;
		rom[196] =8'h1c ;
		rom[197] =8'ha6 ;
		rom[198] =8'hb4 ;
		rom[199] =8'hc6 ;
		rom[200] =8'he8 ;
		rom[201] =8'hdd ;
		rom[202] =8'h74 ;
		rom[203] =8'h1f ;
		rom[204] =8'h4b ;
		rom[205] =8'hbd ;
		rom[206] =8'h8b ;
		rom[207] =8'h8a ;
		rom[208] =8'h70 ;
		rom[209] =8'h3e ;
		rom[210] =8'hb5 ;
		rom[211] =8'h66 ;
		rom[212] =8'h48 ;
		rom[213] =8'h3  ;
		rom[214] =8'hf6 ;
		rom[215] =8'he  ;
		rom[216] =8'h61 ;
		rom[217] =8'h35 ;
		rom[218] =8'h57 ;
		rom[219] =8'hb9 ;
		rom[220] =8'h86 ;
		rom[221] =8'hc1 ;
		rom[222] =8'h1d ;
		rom[223] =8'h9e ;
		rom[224] =8'he1 ;
		rom[225] =8'hf8 ;
		rom[226] =8'h98 ;
		rom[227] =8'h11 ;
		rom[228] =8'h69 ;
		rom[229] =8'hd9 ;
		rom[230] =8'h8e ;
		rom[231] =8'h94 ;
		rom[232] =8'h9b ;
		rom[233] =8'h1e ;
		rom[234] =8'h87 ;
		rom[235] =8'he9 ;
		rom[236] =8'hce ;
		rom[237] =8'h55 ;
		rom[238] =8'h28 ;
		rom[239] =8'hdf ;
		rom[240] =8'h8c ;
		rom[241] =8'ha1 ;
		rom[242] =8'h89 ;
		rom[243] =8'hd  ;
		rom[244] =8'hbf ;
		rom[245] =8'he6 ;
		rom[246] =8'h42 ;
		rom[247] =8'h68 ;
		rom[248] =8'h41 ;
		rom[249] =8'h99 ;
		rom[250] =8'h2d ;
		rom[251] =8'hf  ;
		rom[252] =8'hb0 ;
		rom[253] =8'h54 ;
		rom[254] =8'hbb ;
		rom[255] =8'h16 ;
	
	end
	

	always @(posedge clock)
		q <= rom[address];
endmodule



