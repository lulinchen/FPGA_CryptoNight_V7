// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"


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


//	always @(`CLKSTR_RST_EDGE)
//		if (`RST)	data_in <= 8'h61;
////		else		data_in <= (test_time[3:0] == 4'hf) ? 8'h60 : 8'h61;
//		else 
//			case(test_time[3:0])
//			default : data_in <= 8'h61;
//			1 : data_in <= 8'h20;
//			3 : data_in <= 8'h60;
//			10 : data_in <= 8'h35;
//			15 : data_in <= 8'h60;
//			endcase
//
	reg	[127:0]	key_in;
	//always @(`CLK_RST_EDGE)
	//	if (`RST)			data_in <= 0;
	////	else if(data_en)	data_in <= 128'h0123456789abcedf;
	//	else if(data_en)	data_in <= 128'h0;
		
	//always @(`CLK_RST_EDGE)
	//	if (`RST)			key_in <= 0;
	////	else if(data_en)	key_in <= 128'h0123012301230123;
	//	else if(data_en)	key_in <= 128'h0;
	
	// bb5a0cf66d6f79554d9abab644ceece9
	initial begin
		data_en = 1;
		data_in = 128'h0;
		key_in = 128'h0;
		#1000
		
		data_in = 128'h0;
		key_in = 128'h0;
		# 100
		
		data_in = 128'h0;
		key_in = 128'h1;
		# 100
		
		data_in = 128'h1;
		key_in = 128'h0;
		# 100

		data_in = 128'h00000000_00000000_00000001_00000000;
		key_in = 128'h0;
		# 100
		
		data_in = 128'h00000000_00000001_00000000_00000000;
		key_in = 128'h0;
		# 100
		
		data_in = 128'h00000001_00000000_00000001_00000000;
		key_in = 128'h0;
		# 100
		
		data_in = 128'h100;
		key_in = 128'h0;
		# 100
		
		data_in = 128'h00010000_00000000_00000000_00000000;
		key_in = 128'h0;
		# 100
		data_in = 128'h00112233445566778899aabbccddeeff;
		key_in =  128'h00112233445566778899aabbccddeeff;
		# 100
		data_in = 128'h00112233445566778899aabbccddeeff;
		key_in = 128'h0;
		# 100
		data_in = 128'hffeeddccbbaa99887766554433221100;
		key_in = 128'hffeeddccbbaa99887766554433221100;
		
		//# 8000000
		//$finish;
		# 120000000
		//# 120000000
		//# 1000000
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
				  

//////////////////////////////////////////////////////////////////////////////////////////////////////
/////encoder
//	aes_ecb_enc aes_ecb_enc(
//	///system
//		.clk					(clk					),	
//		.rstn					(rstn					),
//		.key_in					(key_in					),	
//		.data_en				(data_en				), 
//		.data_in				(data_in				),
//		.enc_data_en			(enc_data_en			), 
//		.enc_data				(enc_data				)
//	);
// 	 0 ~ 15 
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

	
//	wire	[127:0]	k0   = 128'h7518d75c7749969189cfd4e3bd302000;
//	wire	[127:0]	k1   = 128'h3148a28aa2c3ef3fe080a30817abd0c4;
//	wire	[127:0]	k2   = 128'h4869e7153d7130494a38a6d8c3f7723b;
//	wire	[127:0]	k3   = 128'h3659aa20071108aaa5d2e7954552449d;
//	wire	[127:0]	k4   = 128'h4bd2c81103bb2f043eca1f4d74f2b995;
//	wire	[127:0]	k5   = 128'h627de9005424432053354b8af6e7ac1f;
//	wire	[127:0]	k6   = 128'h61fbbed72a2976c6299259c21758468f;
//	wire	[127:0]	k7   = 128'h7c84e3bb1ef90abb4add499b19e80211;
//	wire	[127:0]	k8   = 128'h9f088845fef33692d4da4054fd481996;
//	wire	[127:0]	k9   = 128'hea7866e496fc855f88058fe4c2d8c67f;
//	
//	wire	[127:0]	blk0 = 128'hbb868de0996c16b3a115c4b78fdc28c6;
//	wire	[127:0]	blk1 = 128'h10674c6bb1934820c3561a6ab8b46fb7;
//	wire	[127:0]	blk2 = 128'h1032822fb625d29be5f0d9821bea9282;
//	wire	[127:0]	blk3 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
//	wire	[127:0]	blk4 = 128'h603acbae36abdd1816a56787e283a856;
//	wire	[127:0]	blk5 = 128'haca65a590c7bacbe4215e614f6388779;
//	wire	[127:0]	blk6 = 128'ha71c5ac4f49eee0b01c33dca4a066ffb;
//	wire	[127:0]	blk7 = 128'h116c3f9250cb534141aa806140cc28cb;
	
//	wire	[127:0]	imp_k0   = 128'h4aab46c7db31d49334b0b2b8a3514032;
//	wire	[127:0]	imp_k1   = 128'h7bbcc837597d025d3300aaa823e3065d;
//	wire	[127:0]	imp_k2   = 128'h9c5a0537d6f143f00dc09763397025db;
//	wire	[127:0]	imp_k3   = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
//	wire	[127:0]	imp_k4   = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
//	wire	[127:0]	imp_k5   = 128'h11bf8733fd238a366a034f04a45e886b;
//	wire	[127:0]	imp_k6   = 128'h52189a4747cdb0edce429f70913cf31d;
//	wire	[127:0]	imp_k7   = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
//	wire	[127:0]	imp_k8   = 128'h3e38168f6c208cc82bed3c25e5afa355;
//	wire	[127:0]	imp_k9   = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
//	
//	wire	[127:0]	imp_blk0 = 128'hbb868de0996c16b3a115c4b78fdc28c6;
//	wire	[127:0]	imp_blk1 = 128'h10674c6bb1934820c3561a6ab8b46fb7;
//	wire	[127:0]	imp_blk2 = 128'h1032822fb625d29be5f0d9821bea9282;
//	wire	[127:0]	imp_blk3 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
//	wire	[127:0]	imp_blk4 = 128'h603acbae36abdd1816a56787e283a856;
//	wire	[127:0]	imp_blk5 = 128'haca65a590c7bacbe4215e614f6388779;
//	wire	[127:0]	imp_blk6 = 128'ha71c5ac4f49eee0b01c33dca4a066ffb;
//	wire	[127:0]	imp_blk7 = 128'h116c3f9250cb534141aa806140cc28cb;
	
	// wire	[127:0]	hash0 = 128'h4aab46c7db31d49334b0b2b8a3514032;
	// wire	[127:0]	hash1 = 128'h7bbcc837597d025d3300aaa823e3065d;
	// wire	[127:0]	hash2 = 128'h9c5a0537d6f143f00dc09763397025db;
	// wire	[127:0]	hash3 = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
	// wire	[127:0]	hash4 = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	// wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
	// wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
	// wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	// wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
	// wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	// wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
	// wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
	// wire	[ 63:0]	tweak1_2_0_i = 64'h6d869a4a7b5290f9;

//4b3bef71052c9dce5e7ba50d137725c1
//703760fe3a39cd6e2a4e95e16058240c
//33312f4e23b09efc6b73efe179151fe6
//bc16756943ca68ffd371f95cfe09f7bd
//fd7b2105d3f11afc7db11c528f6a3feb
//db82e58fa598a48940ae9601e4ee530c
//3d1df821bc79fa902df2a4097800bcf2
//9b999a90dacf82fcd2f5320f0193b54e



//	wire	[127:0]	hash0 = 128'h8143e42b1d509f0b86e055f1f8eb487e;
//	wire	[127:0]	hash1 = 128'h7e2498f3ca213370f84a7452ac86c200;
//	wire	[127:0]	hash2 = 128'hc03f51b56385cd986227e3b94367ba5e;
//	wire	[127:0]	hash3 = 128'hc7fb67e2e4684765ac6a48aba3df0997;
//	wire	[127:0]	hash4 = 128'haf66129b89f65275079b2fef8c05ced3;
//	wire	[127:0]	hash5 = 128'hc291645338d798fc3229e9d56e4200d8;
//	wire	[127:0]	hash6 = 128'h7ec333f00d8d977613eef4cfb62f3c1b;
//	wire	[127:0]	hash7 = 128'hc19a404a057494ccb87efbc853d1918b;
//	wire	[127:0]	hash8 = 128'ha97e622149ad3c13a24e826452ff715e;
//	wire	[127:0]	hash9 = 128'hc339691af50b906935fdcb24fdff0ea7;
//	wire	[127:0]	hash10= 128'he99aeda813d124d61710ed17d43ab4d3;
//	wire	[127:0]	hash11= 128'hbf6a7d0feab8f1765ba71b64be73442a;
//	wire	[ 63:0]	tweak1_2_0_i = 64'hdd05eb3e987ff6ef ;
	
//e8a1e02cab00704765870a15b908d5f8
//2d0e825736dea54e9584c626ce30886f
//f4cc12387ae72fcc3701f4d0427b5ac6
//c9c3baa0600bce60776109cd0b8e51ec
//b47ef671c166eea0c39ca584f0f94c3c
//bad00796c615d67a36b80a70d7cb32bd
//4653444d6df9117bf024abc402cd8b74
//702865eb92a39374e204f6cb71855987

//	wire	[127:0]	hash0 = 128'h7518d75c7749969189cfd4e3bd302000;
//	wire	[127:0]	hash1 = 128'h3148a28aa2c3ef3fe080a30817abd0c4;
//	wire	[127:0]	hash2 = 128'h4869e7153d7130494a38a6d8c3f7723b;
//	wire	[127:0]	hash3 = 128'h3659aa20071108aaa5d2e7954552449d;
//	wire	[127:0]	hash4 = 128'h4bd2c81103bb2f043eca1f4d74f2b995;
//	wire	[127:0]	hash5 = 128'h627de9005424432053354b8af6e7ac1f;
//	wire	[127:0]	hash6 = 128'h61fbbed72a2976c6299259c21758468f;
//	wire	[127:0]	hash7 = 128'h7c84e3bb1ef90abb4add499b19e80211;
//	wire	[127:0]	hash8 = 128'h9f088845fef33692d4da4054fd481996;
//	wire	[127:0]	hash9 = 128'hea7866e496fc855f88058fe4c2d8c67f;
//	wire	[127:0]	hash10= 128'h9f088845fef33692d4da4054fd481996;
//	wire	[127:0]	hash11= 128'hea7866e496fc855f88058fe4c2d8c67f;
//	wire	[ 63:0]	tweak1_2_0_i = 64'h24d61710ed17d43a ;
	
// 813c81e664fbb0105981015fd0278c24
// 879a010fc00025c215b5c5cc011d230a
// 461f937f27b0bec210906425f889779d
// 14f11b1a84e6e62c55c2ad3b44dedf83
// 094437539fb5d1fa6d63e4e5daaecbda
// 23adf1d0ea6178e8bd6ae38d96a85ab1
// eb87ea1e780c527ff2966a2405d44b30
// 0c6b40715e3ab21dd8b29cf6c6c0bedf

	// wire	[127:0]	hash0 = 128'hbb868de0996c16b3a115c4b78fdc28c6;
	// wire	[127:0]	hash1 = 128'h10674c6bb1934820c3561a6ab8b46fb7;
	// wire	[127:0]	hash2 = 128'h1032822fb625d29be5f0d9821bea9282;
	// wire	[127:0]	hash3 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
	// wire	[127:0]	hash4 = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	// wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
	// wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
	// wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	// wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
	// wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	// wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
	// wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
	// wire	[ 63:0]	tweak1_2_0_i = 64'h4ccb87efbc853d19 ;
	
// 54fc09f93b5e800e1142104b8ca246b6
// 5eaf35cca8eeff970ea13e42bcb6717f
// eefd6f85cea5acadb6191b2aec446109
// a115372ec2b6253fb42108efe4c36e83
// 7681e29da5752c4721477a012fb25e7d
// c99bdfbcdb07424095e3029b3ae44009
// b488327b98b0c42497c0ba2c304e5972
// 81e0f36b35e5d374b85967e7c67c176c

	 wire	[127:0]	hash0 = 128'hea7866e496fc855f88058fe4c2d8c67f;
	 wire	[127:0]	hash1 = 128'h7bbcc837597d025d3300aaa823e3065d;
	 wire	[127:0]	hash2 = 128'h9c5a0537d6f143f00dc09763397025db;
	 wire	[127:0]	hash3 = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
	 wire	[127:0]	hash4 = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	 wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
	 wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
	 wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	 wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
	 wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	 wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
	 wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
	 wire	[ 63:0]	tweak1_2_0_i = 64'h487efbc853d1918b ;
	
// eeaf992d7569b34ecadcd6f257551a57
// e882cae358a9366cb5978749f240304c
// a3451795ae1d8ee07a2e0cb556a7b7f7
// 9d16a61661924ee1d798842d4d7a5d04
// 8aeb93d39bb7088dd947d21da5e5e1e7
// 38caaf6a8f615193c370290845a44489
// f896afd0125ca4af0e262e07c65bf4a8
// 588488a791fbbcf5b3c592b080e16637

	// wire	[127:0]	hash0 = 128'h9f088845fef33692d4da4054fd481996;
	// wire	[127:0]	hash1 = 128'h7bbcc837597d025d3300aaa823e3065d;
	// wire	[127:0]	hash2 = 128'h9c5a0537d6f143f00dc09763397025db;
	// wire	[127:0]	hash3 = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
	// wire	[127:0]	hash4 = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	// wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
	// wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
	// wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	// wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
	// wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	// wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
	// wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
	// wire	[ 63:0]	tweak1_2_0_i = 64'h6de055f1f8eb487e ;
	
// 004c236035c197954ad6fda379288a70
// b26c8ecc11ef4659d25c07ee1cf9d05b
// f88ca75eaee6534fbface511e838fec8
// e8b9626cd6960d53a47207f027b8db20
// a94f9a3a57c78d1401ddba0c795d8ee7
// abbcd79f9fedaa3014643cf59fe4a241
// efcc27b5941caf7d95ece729334ae5fc
// 56dd98f65b2603efd951876dd2e24676

	// wire	[127:0]	hash0 = 128'h627de9005424432053354b8af6e7ac1f;
	// wire	[127:0]	hash1 = 128'h7bbcc837597d025d3300aaa823e3065d;
	// wire	[127:0]	hash2 = 128'h9c5a0537d6f143f00dc09763397025db;
	// wire	[127:0]	hash3 = 128'hec9c0d059720c532ce5dc76ffd5d6dc7;
	// wire	[127:0]	hash4 = 128'h15d52aaa898f2f9d5f7e6c6d52befb0e;
	// wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
	// wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
	// wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
	// wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
	// wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
	// wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
	// wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
	// wire	[ 63:0]	tweak1_2_0_i = 64'h129b89f652750724 ;

// 302c5d85b5f3e038f17f9edd3fe5dae2
// efe31361259adce436cf585af76e42ea
// 009d602e7e55f2711223e86af6aa346d
// b046dc7d01e462269f47ea86d7571710
// f3817be5bd4a275c886c2dc89f50a474
// e5a27737f3765e29b6822d5585892424
// 3eac69320d8dd4f63f65ab284020399b
// fa93c586a568d370034cd53044a23ec3
	
//	wire	[127:0]	hash0 = 128'h1032822fb625d29be5f0d9821bea9282;
//	wire	[127:0]	hash1 = 128'h2b7888a3f36fd6d869a4a7b5290f92d9;
//	wire	[127:0]	hash2 = 128'h603acbae36abdd1816a56787e283a856;
//	wire	[127:0]	hash3 = 128'haca65a590c7bacbe4215e614f6388779;
//	wire	[127:0]	hash4 = 128'ha71c5ac4f49eee0b01c33dca4a066ffb;
//	wire	[127:0]	hash5 = 128'h11bf8733fd238a366a034f04a45e886b;
//	wire	[127:0]	hash6 = 128'h52189a4747cdb0edce429f70913cf31d;
//	wire	[127:0]	hash7 = 128'h226c72ca33d3f5f9cef07fcfa4f330cb;
//	wire	[127:0]	hash8 = 128'h3e38168f6c208cc82bed3c25e5afa355;
//	wire	[127:0]	hash9 = 128'hc9bb8f44ebd7fd8ed804087716f477b8;
//	wire	[127:0]	hash10= 128'hbb868de0996c16b3a115c4b78fdc28c6;
//	wire	[127:0]	hash11= 128'h10674c6bb1934820c3561a6ab8b46fb7;
//	wire	[ 63:0]	tweak1_2_0_i = 64'h0feab8f1765ba71b ;
	
// b14297c24107c50f2e053ffacd0c26ba
// 112ab51a15d0c93af8b602cb71fae83e
// d3331c1c995040b4cdf47b2ec4f54127
// c52248cfeb1b433b0269886cc8687045
// a53b8afae9996598df94d8af0ac9f7ad
// 3f406757d7ed444a2a281a436ae71d0c
// 922a873fbf26af2ecaba86fa5e1f4426
// f2ac03807ed3624a4083a23140e73a75

	wire 	[127:0]	        xout0;
	wire 	[127:0]	        xout1;	
	wire 	[127:0]	        xout2;	
	wire 	[127:0]	        xout3;	
	wire 	[127:0]	        xout4;	
	wire 	[127:0]	        xout5;	
	wire 	[127:0]	        xout6;	
	wire 	[127:0]	        xout7;	
	
	cryptonight cryptonight(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_cn),
		.hash0              (hash0 ),
		.hash1              (hash1 ),
		.hash2              (hash2 ),
		.hash3              (hash3 ),
		.hash4              (hash4 ),
		.hash5              (hash5 ),
		.hash6              (hash6 ),
		.hash7              (hash7 ),
		.hash8              (hash8 ),
		.hash9              (hash9 ),
		.hash10             (hash10),
		.hash11             (hash11),
		.tweak1_2_0_i		(tweak1_2_0_i),
		.ready				(implode_ready),
		.xout0				(xout0),
		.xout1				(xout1),
		.xout2				(xout2),
		.xout3				(xout3),
		.xout4				(xout4),
		.xout5				(xout5),
		.xout6				(xout6),
		.xout7              (xout7)
		
	);
		
//	assign implode_ready = tb.miner.cn_ready;
	
	always @(`CLK_RST_EDGE)
		if(implode_ready)   begin
			$display("T%dsimulation done===================", $time);
			$display("%032x", xout0);
			$display("%032x", xout1);
			$display("%032x", xout2);
			$display("%032x", xout3);
			$display("%032x", xout4);
			$display("%032x", xout5);
			$display("%032x", xout6);
			$display("%032x", xout7);

			#2000 $finish;
		end
	
endmodule


