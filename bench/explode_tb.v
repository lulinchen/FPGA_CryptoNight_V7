// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"


interface itf(input bit clk);
	logic update_a;
	logic go_mainloop;
	logic rxd = 1;

	clocking cb@(`CLK_EDGE);
		input update_a;
		input go_mainloop;
		output	rxd;
	endclocking 
endinterface

class uart_stim;
	virtual itf 			itfu;
	reg [7:0]	start  = 8'h55;  
	reg [7:0]	hash[200]  = {  
		8'hB6, 8'h7F, 8'h66, 8'h4E, 8'h8B, 8'h38, 8'h00, 8'h1A, 8'h74, 8'hBF, 8'h22, 8'hA2, 8'hFB, 8'h83, 8'h3C, 8'h9E,
		8'hF1, 8'hCE, 8'h47, 8'h47, 8'h96, 8'h0B, 8'h20, 8'hAC, 8'hA0, 8'hA7, 8'h5F, 8'hE0, 8'hE2, 8'h67, 8'hAF, 8'hFE,
		8'h07, 8'h48, 8'h44, 8'h16, 8'hF0, 8'h0B, 8'h24, 8'hF3, 8'hCF, 8'h98, 8'hC3, 8'h9A, 8'h4D, 8'h5F, 8'hE5, 8'h74,
		8'h27, 8'h56, 8'h24, 8'h1E, 8'hA5, 8'hDF, 8'hBB, 8'h13, 8'h50, 8'h16, 8'h59, 8'hB4, 8'hB4, 8'hB6, 8'h83, 8'h29,
		8'h7A, 8'hAF, 8'h63, 8'h1C, 8'hCC, 8'h60, 8'h73, 8'hE8, 8'hFC, 8'hEA, 8'hF8, 8'h13, 8'hBF, 8'h5D, 8'h16, 8'h2A,
		8'hB1, 8'h51, 8'h7E, 8'h14, 8'h0B, 8'h3E, 8'h31, 8'h55, 8'h78, 8'h23, 8'h9A, 8'hDD, 8'h74, 8'hCA, 8'h64, 8'h00,
		8'h70, 8'h70, 8'h0C, 8'h82, 8'hAB, 8'hE5, 8'h64, 8'h06, 8'h1C, 8'hC7, 8'h00, 8'h8C, 8'h12, 8'h64, 8'hE9, 8'h69,
		8'hB1, 8'h46, 8'h6E, 8'h3F, 8'h64, 8'hC8, 8'h3B, 8'hE4, 8'hAE, 8'h6A, 8'h8F, 8'hFE, 8'h5D, 8'hAF, 8'h35, 8'h5F,
		8'h14, 8'h7A, 8'h0A, 8'hA2, 8'hEE, 8'h41, 8'h91, 8'h16, 8'hC5, 8'h42, 8'h61, 8'hB3, 8'h6B, 8'h8F, 8'hF9, 8'hC8,
		8'h0D, 8'hD4, 8'h2D, 8'hDB, 8'hD1, 8'hF4, 8'hC6, 8'hA9, 8'hB0, 8'hF9, 8'h77, 8'h07, 8'hE4, 8'h6E, 8'hFD, 8'h2A,
		8'h09, 8'h49, 8'hFC, 8'h3D, 8'hA9, 8'h14, 8'hEC, 8'hD0, 8'h2B, 8'hAC, 8'h9C, 8'hEC, 8'h74, 8'hB4, 8'hDA, 8'h09,
		8'h87, 8'h35, 8'h1A, 8'h8B, 8'h0B, 8'h81, 8'h49, 8'h70, 8'h1B, 8'h40, 8'h16, 8'h0D, 8'h00, 8'hBC, 8'h9D, 8'h4F,
		8'h0e, 8'h6e, 8'h89, 8'h52, 8'h89, 8'h46, 8'h5f, 8'hf1
	};
	
	//d86bf9afc62950dbbc3ad3e2fbe93568
	//ebce2e5a4a85feba237ddd6346df94b9
	//7338516a0afc9b07f24db57c8db7b8e4
	//4c1c0fe60074f04a739318b1eeadb042
	//f4b5ac038969d8b839999ce36c91a2f7
	//02ba285bb6a26eef637b6a7f8bc78230
	//a4d13d0c151c5f12d507c448da6077be
	//616e364e2ef8a4b64430d85fcf4bfdd6


	
	reg [7:0]	hash2[200]  = {  
		8'hC7, 8'h66, 8'hD3, 8'h2E, 8'h9F, 8'hC0, 8'hEE, 8'h4D, 8'h42, 8'h8F, 8'hC8, 8'hA6, 8'hAB, 8'hFE, 8'h22,
		8'hC5, 8'h87, 8'h3D, 8'h61, 8'hEE, 8'h1D, 8'h3A, 8'hAD, 8'h6E, 8'h01, 8'hAB, 8'h75, 8'h5B, 8'hAA, 8'hD2, 8'h54,
		8'hB3, 8'hE2, 8'h72, 8'h8E, 8'h10, 8'h35, 8'hB3, 8'hFD, 8'hD5, 8'h88, 8'h68, 8'h95, 8'hE2, 8'hDE, 8'h30, 8'hC5,
		8'hAE, 8'hD6, 8'h3C, 8'hFD, 8'h48, 8'hA8, 8'hB4, 8'hFF, 8'h14, 8'hA2, 8'h69, 8'h9E, 8'hD3, 8'hDA, 8'h33, 8'h73,
		8'hCD, 8'h46, 8'h6A, 8'h42, 8'h61, 8'h7E, 8'h8D, 8'h22, 8'hCF, 8'h2E, 8'hF3, 8'h51, 8'h09, 8'hBD, 8'h59, 8'hFD,
		8'h92, 8'h19, 8'h82, 8'h73, 8'h32, 8'hE5, 8'h9E, 8'h8C, 8'h90, 8'h16, 8'hF4, 8'h47, 8'hBC, 8'hD5, 8'h17, 8'h8E,
		8'hCB, 8'h38, 8'h06, 8'hBF, 8'h01, 8'h15, 8'h99, 8'h3F, 8'hA5, 8'h6E, 8'hF2, 8'h4D, 8'h09, 8'hFD, 8'hF1, 8'h28,
		8'h69, 8'hCD, 8'h61, 8'hA1, 8'hEF, 8'h4C, 8'h21, 8'h96, 8'hE8, 8'hC0, 8'hEF, 8'h1D, 8'h9B, 8'h35, 8'hA1, 8'h14,
		8'h5E, 8'h89, 8'hCF, 8'h49, 8'h70, 8'h5E, 8'h9E, 8'hE8, 8'hD9, 8'h60, 8'h8B, 8'hAF, 8'h1C, 8'h28, 8'hA5, 8'h52,
		8'h44, 8'hD2, 8'h05, 8'hE8, 8'hE6, 8'hE5, 8'h80, 8'h90, 8'hEF, 8'h04, 8'h22, 8'h5F, 8'hBE, 8'hDE, 8'h26, 8'h7A,
		8'h43, 8'h5B, 8'h6E, 8'h49, 8'h3A, 8'h7E, 8'h15, 8'h53, 8'hFA, 8'h95, 8'h42, 8'h72, 8'h21, 8'h88, 8'hCC, 8'hDF,
		8'hAA, 8'hB4, 8'hCC, 8'h9E, 8'h4D, 8'hD9, 8'h05, 8'h5F, 8'h4D, 8'hDC, 8'h57, 8'hCE, 8'h28, 8'h19, 8'hD0, 8'h7D,
		8'h1D, 8'h8F, 8'hC6, 8'h1E, 8'hD5, 8'h38, 8'hF1, 8'h22, 8'h6A
	};
	reg [7:0]	hash3[200]  = {  
		8'h87, 8'h98, 8'h0D, 8'hFF, 8'h6A, 8'h37, 8'h9F, 8'hC0, 8'h22, 8'h42, 8'h4D, 8'h38, 8'h79, 8'h87, 8'h47, 8'hEE,
		8'h67, 8'h1C, 8'hD9, 8'h61, 8'hEB, 8'h49, 8'h4D, 8'h6F, 8'hB5, 8'h25, 8'h6B, 8'hC4, 8'h4C, 8'h8E, 8'h6E, 8'h74,
		8'h69, 8'hAC, 8'h68, 8'hD1, 8'hA9, 8'hBF, 8'hF6, 8'h24, 8'h0B, 8'h5D, 8'h0B, 8'h99, 8'h6D, 8'hD0, 8'h64, 8'hB5,
		8'h2F, 8'h7C, 8'h63, 8'hFE, 8'hBD, 8'h4F, 8'h54, 8'hA0, 8'h4B, 8'hAF, 8'hB4, 8'hAC, 8'h80, 8'hE1, 8'h2E, 8'hEE,
		8'hBA, 8'h01, 8'hA0, 8'hCF, 8'hA0, 8'h50, 8'hB0, 8'h97, 8'h66, 8'h33, 8'hB9, 8'h0E, 8'h6B, 8'h0A, 8'h2E, 8'h98,
		8'h41, 8'h8E, 8'h47, 8'hFF, 8'h30, 8'hC4, 8'hF0, 8'hCC, 8'hF9, 8'h47, 8'h4B, 8'h3F, 8'h19, 8'hBD, 8'h8C, 8'hAD,
		8'h40, 8'h81, 8'h89, 8'hAE, 8'h73, 8'h62, 8'hC8, 8'hFA, 8'hA1, 8'h98, 8'h6D, 8'h57, 8'hCF, 8'h2F, 8'h19, 8'hBA,
		8'h4C, 8'h9D, 8'hC1, 8'h15, 8'h8E, 8'hD0, 8'hB7, 8'hCD, 8'h4E, 8'h67, 8'h5B, 8'hD2, 8'hE4, 8'h72, 8'h37, 8'hD7,
		8'h18, 8'hA5, 8'h84, 8'h90, 8'h7D, 8'h80, 8'hCD, 8'h94, 8'h4E, 8'h10, 8'h23, 8'hE3, 8'hDA, 8'h4F, 8'hF5, 8'hF9,
		8'h9C, 8'h7B, 8'h64, 8'h47, 8'h81, 8'h37, 8'hBD, 8'h39, 8'hB7, 8'h69, 8'h6C, 8'h90, 8'hC5, 8'h3A, 8'h60, 8'h1F,
		8'h28, 8'h7E, 8'h7E, 8'hAD, 8'h7A, 8'h83, 8'h0E, 8'hCF, 8'hC8, 8'h24, 8'hB4, 8'h9C, 8'hC5, 8'hAB, 8'h6B, 8'h4E,
		8'hC1, 8'hDE, 8'hFC, 8'h21, 8'hC5, 8'hB4, 8'hD1, 8'h3B, 8'h0A, 8'h12, 8'h4E, 8'h2D, 8'h9B, 8'h2F, 8'hEB, 8'h0A,
		8'hD3, 8'hC4, 8'h44, 8'h2E, 8'hAD, 8'h43, 8'h9D, 8'h97
		};
	reg [7:0]	hash4[200]  = { 	
		8'hB6, 8'h5A, 8'hD6, 8'h30, 8'h02, 8'h68, 8'h2E, 8'h71, 8'hBA, 8'h50, 8'h2A, 8'h90, 8'h73, 8'h08, 8'h2A, 8'h17,
		8'h60, 8'hDB, 8'hCF, 8'hD7, 8'hF8, 8'hC2, 8'h85, 8'hCA, 8'hFB, 8'h59, 8'h25, 8'h76, 8'h4B, 8'hAD, 8'h56, 8'h95,
		8'hF5, 8'h37, 8'h47, 8'hC9, 8'h66, 8'h89, 8'hFF, 8'h44, 8'hC5, 8'hC6, 8'h12, 8'hFD, 8'h66, 8'hE4, 8'h27, 8'h4F,
		8'hC9, 8'hC3, 8'h1E, 8'h00, 8'h3F, 8'hB0, 8'h7A, 8'h85, 8'h8F, 8'hA7, 8'h74, 8'h7B, 8'hFC, 8'hD4, 8'h2C, 8'h20,
		8'h09, 8'h52, 8'hA8, 8'h96, 8'hDC, 8'hE7, 8'h96, 8'hF5, 8'hFA, 8'hDF, 8'h7A, 8'hA8, 8'h57, 8'h81, 8'h1D, 8'h87,
		8'hFF, 8'h28, 8'hC4, 8'h71, 8'h3F, 8'h39, 8'h54, 8'h1F, 8'hFD, 8'h48, 8'hEF, 8'hA7, 8'h60, 8'h03, 8'hF9, 8'h13,
		8'hDB, 8'hE9, 8'hE2, 8'hFA, 8'h70, 8'hBD, 8'hCD, 8'h75, 8'h3D, 8'h52, 8'hCD, 8'h90, 8'h2C, 8'hE6, 8'h23, 8'hB2,
		8'hC7, 8'hA6, 8'h8C, 8'hE7, 8'h5C, 8'hC7, 8'hDE, 8'hE1, 8'h7A, 8'h5D, 8'h85, 8'h78, 8'h4D, 8'h33, 8'hB9, 8'hCF,
		8'h05, 8'h15, 8'h2F, 8'hC7, 8'hDD, 8'h3E, 8'hBB, 8'hF1, 8'hE1, 8'h8F, 8'h5C, 8'h72, 8'hD5, 8'h8E, 8'hEA, 8'h1F,
		8'hEA, 8'h7B, 8'hDC, 8'hFA, 8'h54, 8'hB5, 8'h83, 8'h21, 8'h34, 8'hEC, 8'h51, 8'h42, 8'h41, 8'h98, 8'h42, 8'h3D,
		8'h58, 8'h5B, 8'h71, 8'hD5, 8'h10, 8'hCF, 8'hEE, 8'h7F, 8'h3A, 8'h12, 8'hFD, 8'hAA, 8'h66, 8'h28, 8'hDD, 8'h53,
		8'h7C, 8'h8C, 8'h0B, 8'h36, 8'hED, 8'h3F, 8'hD8, 8'h1A, 8'hF8, 8'h42, 8'h8E, 8'hEE, 8'hA6, 8'h4D, 8'hEC, 8'hC8,
		8'h7A, 8'h49, 8'h26, 8'h10, 8'h60, 8'h1A, 8'h29, 8'hF0
		};
	//integer BAUD_CNT_MAX = 325;
	function new( virtual itf itfu );
		this.itfu = itfu;	
	endfunction
	
	task stimulate; 
		//for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
		//	if ( bitcnt == 0)
		//		itfu.rxd = 0;
		//	else if ( bitcnt == 9)
		//		itfu.rxd = 1;
		//	else 
		//		itfu.rxd = start[bitcnt-1];
		//	for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
		//		@itfu.cb;
		//end 
		//for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
		//	for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
		//		if ( bitcnt == 0)
		//			itfu.rxd = 0;
		//		else if ( bitcnt == 9)
		//			itfu.rxd = 1;
		//		else 
		//			itfu.rxd = hash[byytcnt][bitcnt-1];
		//		for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
		//			@itfu.cb;
		//	end 
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash2[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash3[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash4[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
						
						
						
						
						
						
						
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash2[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash3[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 @itfu.cb;
		 
		 for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
			if ( bitcnt == 0)
				itfu.rxd = 0;
			else if ( bitcnt == 9)
				itfu.rxd = 1;
			else 
				itfu.rxd = start[bitcnt-1];
			for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
				@itfu.cb;
		end 
		 for(int byytcnt = 0; byytcnt < 200 ; byytcnt++) 
			for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
				if ( bitcnt == 0)
					itfu.rxd = 0;
				else if ( bitcnt == 9)
					itfu.rxd = 1;
				else 
					itfu.rxd = hash4[byytcnt][bitcnt-1];
				for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
					@itfu.cb;
			end 
			
			
			
			
	endtask
endclass

//class ab_print;
//	virtual itf 			itfu;
//	integer					fd, fo;
//	integer					errno;
//	reg			  [639:0]	errinfo;
//	function new( virtual itf itfu );
//		this.itfu = itfu;	
//		fo = $fopen("./ab.log", "wb");
//		errno = $ferror(fo, errinfo);
//		if (errno != 0) begin
//			$display("Failed to open file %0s, errno: %0d, reason: %0s", "./debug_inter.log", errno, errinfo);	
//			$finish();
//		end		
//	endfunction
//	
//	task start_moni; 
//		 @itfu.cb;
//		 @itfu.cb;
//		 @itfu.cb;
//		$fwrite(fo,"%d:\n", tb.mainLoop.cnt[24:4]);
//		$fwrite(fo,"a: %032x\n", tb.mainLoop.a );
//		$fwrite(fo,"b: %032x\n", tb.mainLoop.b );
//		
//	endtask
//endclass


module tb;
    parameter	S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15;
	reg	clk,clk_enc,clk_dec,rstn,clk_str,clk_init;
	initial begin
		rstn = 0;
		#1    rstn = 0;
		#1000 rstn = 1;
	end

	initial begin
		clk = 0;  ///main process clock
		clk_enc = 0; ///work for enc out clock
		clk_dec = 0; ///work for dec out clock
		clk_str = 0; ///work for stream in clock
		clk_init = 0; ///work for init process
	end

	always #2.5 clk=~clk;

`ifdef DUMP_FSDB
	initial begin
		$fsdbDumpfile("ecb.fsdb");
		$fsdbDumpvars(5, tb);
		//$fsdbDumpvars(5, tb.aes_ecb_enc);
	end  
`endif 

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
	wire			aes_fifo_afull;
	wire			aes_ofifo_afull = 0;

	wire			aes_fifo_dec_afull;
	wire			aes_ofifo_dec_afull = 0;

	wire			aes_init_done;
	wire			aes_init_done_dec;	

	reg				data_en;
	reg		[127:0]	data_in;
	wire			enc_data_en;
	wire	[127:0]	enc_data;

	wire			dec_data_en;
	wire	[7:0]	dec_data;


	reg		[3:0]	st_test;
	reg		[31:0]	test_time;

	initial begin
		
		# 5000000
		$finish;
		
	end
	
	
	reg	 			go_cn;
	wire	 		explode_ready;
	wire	 		implode_ready;
	reg		[7:0]	st_tb;
	initial begin
		go_cn = 0;
	end
	always @(posedge clk) 
		go_cn <= (128== st_tb);
	

	always @(posedge clk)
		if (!rstn) 			 st_tb <= 0;
		else if (st_tb!=255) st_tb <= st_tb + 1;
			



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
		
//	wire	[127:0]	k0   = 128'h726f2c94d83fdd7e802a5dba67c9ae01;
//	wire	[127:0]	k1   = 128'he3b094726f759cf7c110ebbf6129c6c0;
//	wire	[127:0]	k2   = 128'h0da2e5727fcdc9e6a7f2149827d84922;
//	wire	[127:0]	k3   = 128'hfbc6fcba187668c87703f43fb6131f80;
//	wire	[127:0]	k4   = 128'h064ac59c0be820ee7425e908d3d7fd90;
//	wire	[127:0]	k5   = 128'h4d76d913b6b025a9aec64d61d9c5b95e;
//	wire	[127:0]	k6   = 128'hd7b3c9dbd1f90c47da112ca9ae34c5a1;
//	wire	[127:0]	k7   = 128'h82a8d53ccfde0c2f796e2986d7a864e7;
//	wire	[127:0]	k8   = 128'h997cee9f4ecf27449f362b03452707aa;
//	wire	[127:0]	k9   = 128'h0da0bca98f08699540d665ba39b84c3c;
//	wire	[127:0]	blk0 = 128'hbd191be7261500bd96b844433f27156d;
//	wire	[127:0]	blk1 = 128'h27b7d142fc8af47dfec6e39941387935;
//	wire	[127:0]	blk2 = 128'h393d18a8333b8965c9082e620613e556;
//	wire	[127:0]	blk3 = 128'h01b532e26dd2fd75c175f8593924e68b;
//	wire	[127:0]	blk4 = 128'he5453d69603aac235594dfbd174854c1;
//	wire	[127:0]	blk5 = 128'h29512736a8f561d6484e17309f2831d5;
//	wire	[127:0]	blk6 = 128'h332c8940a5db71be1027b8fb4ea6608b;
//	wire	[127:0]	blk7 = 128'h588b56ad42cb21dcdc7d45ee90f4c7d0;
//
//	wire	[ 63:0]	tweak1_2_0_i = 64'h ;

	
	wire	[127:0]	k0   = 128'h7518d75c7749969189cfd4e3bd302000;
	wire	[127:0]	k1   = 128'h3148a28aa2c3ef3fe080a30817abd0c4;
	wire	[127:0]	k2   = 128'h4869e7153d7130494a38a6d8c3f7723b;
	wire	[127:0]	k3   = 128'h3659aa20071108aaa5d2e7954552449d;
	wire	[127:0]	k4   = 128'h4bd2c81103bb2f043eca1f4d74f2b995;
	wire	[127:0]	k5   = 128'h627de9005424432053354b8af6e7ac1f;
	wire	[127:0]	k6   = 128'h61fbbed72a2976c6299259c21758468f;
	wire	[127:0]	k7   = 128'h7c84e3bb1ef90abb4add499b19e80211;
	wire	[127:0]	k8   = 128'h9f088845fef33692d4da4054fd481996;
	wire	[127:0]	k9   = 128'hea7866e496fc855f88058fe4c2d8c67f;
	
	wire	[127:0]	blk0 = 128'hbb868de0996c16b3a115c4b78fdc28c6;
	wire	[127:0]	blk1 = 128'h10674c6bb1934820c3561a6ab8b46fb7;
	wire	[127:0]	blk2 = 128'h1032822fb625d29be5f0d9821bea9282;
	wire	[127:0]	blk3 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
	wire	[127:0]	blk4 = 128'h603acbae36abdd1816a56787e283a856;
	wire	[127:0]	blk5 = 128'haca65a590c7bacbe4215e614f6388779;
	wire	[127:0]	blk6 = 128'ha71c5ac4f49eee0b01c33dca4a066ffb;
	wire	[127:0]	blk7 = 128'h116c3f9250cb534141aa806140cc28cb;

	wire	[127:0]	imp_k0   = 128'h4aab46c7db31d49334b0b2b8a3514032;
	wire	[127:0]	imp_k1   = 128'h7bbcc837597d025d3300aaa823e3065d;
	wire	[127:0]	imp_k2   = 128'h9c5a0537d6f143f00dc09763397025db;
	wire	[127:0]	imp_k3   = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
	wire	[127:0]	imp_k4   = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	wire	[127:0]	imp_k5   = 128'h11bf8733fd238a366a034f04a45e886b;
	wire	[127:0]	imp_k6   = 128'h52189a4747cdb0edce429f70913cf31d;
	wire	[127:0]	imp_k7   = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	wire	[127:0]	imp_k8   = 128'h3e38168f6c208cc82bed3c25e5afa355;
	wire	[127:0]	imp_k9   = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	
	wire	[127:0]	imp_blk0 = 128'hbb868de0996c16b3a115c4b78fdc28c6;
	wire	[127:0]	imp_blk1 = 128'h10674c6bb1934820c3561a6ab8b46fb7;
	wire	[127:0]	imp_blk2 = 128'h1032822fb625d29be5f0d9821bea9282;
	wire	[127:0]	imp_blk3 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
	wire	[127:0]	imp_blk4 = 128'h603acbae36abdd1816a56787e283a856;
	wire	[127:0]	imp_blk5 = 128'haca65a590c7bacbe4215e614f6388779;
	wire	[127:0]	imp_blk6 = 128'ha71c5ac4f49eee0b01c33dca4a066ffb;
	wire	[127:0]	imp_blk7 = 128'h116c3f9250cb534141aa806140cc28cb;		

	// 
	//cn_explode_scratchpad cn_explode_scratchpad(
	cn_explode_scratchpad_3clk cn_explode_scratchpad(
		.clk 			(clk), 		
		.rstn			(rstn),
		.go				(go_cn),
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

endmodule


