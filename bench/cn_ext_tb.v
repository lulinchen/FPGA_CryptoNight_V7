// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"


module tb;
    parameter	S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15;
	reg	clk,clk_enc,clk_dec,rstn,clk_str,clk_init;
	reg		rstn_i;
	initial begin
		rstn_i = 0;
		#1    rstn_i = 0;
		#1000 rstn_i = 1;
	end


	initial begin
		clk = 0;  ///main process clock
		clk_enc = 0; ///work for enc out clock
		clk_dec = 0; ///work for dec out clock
		clk_str = 0; ///work for stream in clock
		clk_init = 0; ///work for init process
	end

`ifdef  IDEAL_EXTMEM
	always #2.5 clk=~clk;
	always @(*)	rstn = rstn_i;
`else
	wire	emif_usr_reset_n;
	wire	emif_usr_clk;
	wire	local_cal_success;
	always @(*)	rstn = rstn_i & emif_usr_reset_n & local_cal_success;
	always @(*)	clk = emif_usr_clk;

`endif
`ifdef DUMP_FSDB
	initial begin
		$fsdbDumpfile("ecb.fsdb");
		$fsdbDumpvars(3, tb);
		//$fsdbDumpvars(3, tb);
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
		
		
	//	#500000
	//	$finish;
	
		//#500000
		//$finish;
		#5000000
		#5000000
		#2000000
	//	//$finish;
	//	#220000000
		# 1200000000
	//	//# 1000000
		$finish;
		
	end
	reg	[127:0] hash_idx[32][12] = '{
			'{
			128'h8143e42b1d509f0b86e055f1f8eb487e,				//e8a1e02cab00704765870a15b908d5f8
			128'h7e2498f3ca213370f84a7452ac86c200,              //2d0e825736dea54e9584c626ce30886f
			128'hc03f51b56385cd986227e3b94367ba5e,              //f4cc12387ae72fcc3701f4d0427b5ac6
			128'hc7fb67e2e4684765ac6a48aba3df0997,              //c9c3baa0600bce60776109cd0b8e51ec
			128'haf66129b89f65275079b2fef8c05ced3,              //b47ef671c166eea0c39ca584f0f94c3c
			128'hc291645338d798fc3229e9d56e4200d8,              //bad00796c615d67a36b80a70d7cb32bd
			128'h7ec333f00d8d977613eef4cfb62f3c1b,              //4653444d6df9117bf024abc402cd8b74
			128'hc19a404a057494ccb87efbc853d1918b,              //702865eb92a39374e204f6cb71855987
			128'ha97e622149ad3c13a24e826452ff715e,
			128'hc339691af50b906935fdcb24fdff0ea7,
			128'he99aeda813d124d61710ed17d43ab4d3,
			128'hbf6a7d0feab8f1765ba71b64be73442a 
			},
			
			'{
			128'h4aab46c7db31d49334b0b2b8a3514032,				//4b3bef71052c9dce5e7ba50d137725c1
			128'h7bbcc837597d025d3300aaa823e3065d,              //703760fe3a39cd6e2a4e95e16058240c
			128'h9c5a0537d6f143f00dc09763397025db,              //33312f4e23b09efc6b73efe179151fe6
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,              //bc16756943ca68ffd371f95cfe09f7bd
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              //fd7b2105d3f11afc7db11c528f6a3feb
			128'h11bf8733fd238a366a034f04a45e886b,              //db82e58fa598a48940ae9601e4ee530c
			128'h52189a4747cdb0edce429f70913cf31d,              //3d1df821bc79fa902df2a4097800bcf2
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              //9b999a90dacf82fcd2f5320f0193b54e
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h7518d75c7749969189cfd4e3bd302000,				// 813c81e664fbb0105981015fd0278c24
			128'h3148a28aa2c3ef3fe080a30817abd0c4,              // 879a010fc00025c215b5c5cc011d230a
			128'h4869e7153d7130494a38a6d8c3f7723b,              // 461f937f27b0bec210906425f889779d
			128'h3659aa20071108aaa5d2e7954552449d,              // 14f11b1a84e6e62c55c2ad3b44dedf83
			128'h4bd2c81103bb2f043eca1f4d74f2b995,              // 094437539fb5d1fa6d63e4e5daaecbda
			128'h627de9005424432053354b8af6e7ac1f,              // 23adf1d0ea6178e8bd6ae38d96a85ab1
			128'h61fbbed72a2976c6299259c21758468f,              // eb87ea1e780c527ff2966a2405d44b30
			128'h7c84e3bb1ef90abb4add499b19e80211,              // 0c6b40715e3ab21dd8b29cf6c6c0bedf
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f,
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f 
			},
			
				'{
			128'hbb868de0996c16b3a115c4b78fdc28c6,				// 54fc09f93b5e800e1142104b8ca246b6
			128'h10674c6bb1934820c3561a6ab8b46fb7,              // 5eaf35cca8eeff970ea13e42bcb6717f
			128'h1032822fb625d29be5f0d9821bea9282,              // eefd6f85cea5acadb6191b2aec446109
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,              // a115372ec2b6253fb42108efe4c36e83
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              // 7681e29da5752c4721477a012fb25e7d
			128'h11bf8733fd238a366a034f04a45e886b,              // c99bdfbcdb07424095e3029b3ae44009
			128'h52189a4747cdb0edce429f70913cf31d,              // b488327b98b0c42497c0ba2c304e5972
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              // 81e0f36b35e5d374b85967e7c67c176c
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'hea7866e496fc855f88058fe4c2d8c67f,			// eeaf992d7569b34ecadcd6f257551a57
			128'h7bbcc837597d025d3300aaa823e3065d,          // e882cae358a9366cb5978749f240304c
			128'h9c5a0537d6f143f00dc09763397025db,          // a3451795ae1d8ee07a2e0cb556a7b7f7
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // 9d16a61661924ee1d798842d4d7a5d04
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // 8aeb93d39bb7088dd947d21da5e5e1e7
			128'h11bf8733fd238a366a034f04a45e886b,          // 38caaf6a8f615193c370290845a44489
			128'h52189a4747cdb0edce429f70913cf31d,          // f896afd0125ca4af0e262e07c65bf4a8
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 588488a791fbbcf5b3c592b080e16637
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h9f088845fef33692d4da4054fd481996,			// 004c236035c197954ad6fda379288a70
			128'h7bbcc837597d025d3300aaa823e3065d,          // b26c8ecc11ef4659d25c07ee1cf9d05b
			128'h9c5a0537d6f143f00dc09763397025db,          // f88ca75eaee6534fbface511e838fec8
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // e8b9626cd6960d53a47207f027b8db20
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // a94f9a3a57c78d1401ddba0c795d8ee7
			128'h11bf8733fd238a366a034f04a45e886b,          // abbcd79f9fedaa3014643cf59fe4a241
			128'h52189a4747cdb0edce429f70913cf31d,          // efcc27b5941caf7d95ece729334ae5fc
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 56dd98f65b2603efd951876dd2e24676
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h627de9005424432053354b8af6e7ac1f,			// 302c5d85b5f3e038f17f9edd3fe5dae2
			128'h7bbcc837597d025d3300aaa823e3065d,          // efe31361259adce436cf585af76e42ea
			128'h9c5a0537d6f143f00dc09763397025db,          // 009d602e7e55f2711223e86af6aa346d
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // b046dc7d01e462269f47ea86d7571710
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // f3817be5bd4a275c886c2dc89f50a474
			128'h11bf8733fd238a366a034f04a45e886b,          // e5a27737f3765e29b6822d5585892424
			128'h52189a4747cdb0edce429f70913cf31d,          // 3eac69320d8dd4f63f65ab284020399b
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // fa93c586a568d370034cd53044a23ec3
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h1032822fb625d29be5f0d9821bea9282,			// b14297c24107c50f2e053ffacd0c26ba
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,          // 112ab51a15d0c93af8b602cb71fae83e
			128'h603acbae36abdd1816a56787e283a856,          // d3331c1c995040b4cdf47b2ec4f54127
			128'haca65a590c7bacbe4215e614f6388779,          // c52248cfeb1b433b0269886cc8687045
			128'ha71c5ac4f49eee0b01c33dca4a066ffb,          // a53b8afae9996598df94d8af0ac9f7ad
			128'h11bf8733fd238a366a034f04a45e886b,          // 3f406757d7ed444a2a281a436ae71d0c
			128'h52189a4747cdb0edce429f70913cf31d,          // 922a873fbf26af2ecaba86fa5e1f4426
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // f2ac03807ed3624a4083a23140e73a75
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			}
			
			,
			'{
			128'h8143e42b1d509f0b86e055f1f8eb487e,				//e8a1e02cab00704765870a15b908d5f8
			128'h7e2498f3ca213370f84a7452ac86c200,              //2d0e825736dea54e9584c626ce30886f
			128'hc03f51b56385cd986227e3b94367ba5e,              //f4cc12387ae72fcc3701f4d0427b5ac6
			128'hc7fb67e2e4684765ac6a48aba3df0997,              //c9c3baa0600bce60776109cd0b8e51ec
			128'haf66129b89f65275079b2fef8c05ced3,              //b47ef671c166eea0c39ca584f0f94c3c
			128'hc291645338d798fc3229e9d56e4200d8,              //bad00796c615d67a36b80a70d7cb32bd
			128'h7ec333f00d8d977613eef4cfb62f3c1b,              //4653444d6df9117bf024abc402cd8b74
			128'hc19a404a057494ccb87efbc853d1918b,              //702865eb92a39374e204f6cb71855987
			128'ha97e622149ad3c13a24e826452ff715e,
			128'hc339691af50b906935fdcb24fdff0ea7,
			128'he99aeda813d124d61710ed17d43ab4d3,
			128'hbf6a7d0feab8f1765ba71b64be73442a 
			},
			
			'{
			128'h4aab46c7db31d49334b0b2b8a3514032,				//4b3bef71052c9dce5e7ba50d137725c1
			128'h7bbcc837597d025d3300aaa823e3065d,              //703760fe3a39cd6e2a4e95e16058240c
			128'h9c5a0537d6f143f00dc09763397025db,              //33312f4e23b09efc6b73efe179151fe6
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,              //bc16756943ca68ffd371f95cfe09f7bd
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              //fd7b2105d3f11afc7db11c528f6a3feb
			128'h11bf8733fd238a366a034f04a45e886b,              //db82e58fa598a48940ae9601e4ee530c
			128'h52189a4747cdb0edce429f70913cf31d,              //3d1df821bc79fa902df2a4097800bcf2
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              //9b999a90dacf82fcd2f5320f0193b54e
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h7518d75c7749969189cfd4e3bd302000,				// 813c81e664fbb0105981015fd0278c24
			128'h3148a28aa2c3ef3fe080a30817abd0c4,              // 879a010fc00025c215b5c5cc011d230a
			128'h4869e7153d7130494a38a6d8c3f7723b,              // 461f937f27b0bec210906425f889779d
			128'h3659aa20071108aaa5d2e7954552449d,              // 14f11b1a84e6e62c55c2ad3b44dedf83
			128'h4bd2c81103bb2f043eca1f4d74f2b995,              // 094437539fb5d1fa6d63e4e5daaecbda
			128'h627de9005424432053354b8af6e7ac1f,              // 23adf1d0ea6178e8bd6ae38d96a85ab1
			128'h61fbbed72a2976c6299259c21758468f,              // eb87ea1e780c527ff2966a2405d44b30
			128'h7c84e3bb1ef90abb4add499b19e80211,              // 0c6b40715e3ab21dd8b29cf6c6c0bedf
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f,
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f 
			},
			
				'{
			128'hbb868de0996c16b3a115c4b78fdc28c6,				// 54fc09f93b5e800e1142104b8ca246b6
			128'h10674c6bb1934820c3561a6ab8b46fb7,              // 5eaf35cca8eeff970ea13e42bcb6717f
			128'h1032822fb625d29be5f0d9821bea9282,              // eefd6f85cea5acadb6191b2aec446109
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,              // a115372ec2b6253fb42108efe4c36e83
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              // 7681e29da5752c4721477a012fb25e7d
			128'h11bf8733fd238a366a034f04a45e886b,              // c99bdfbcdb07424095e3029b3ae44009
			128'h52189a4747cdb0edce429f70913cf31d,              // b488327b98b0c42497c0ba2c304e5972
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              // 81e0f36b35e5d374b85967e7c67c176c
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'hea7866e496fc855f88058fe4c2d8c67f,			// eeaf992d7569b34ecadcd6f257551a57
			128'h7bbcc837597d025d3300aaa823e3065d,          // e882cae358a9366cb5978749f240304c
			128'h9c5a0537d6f143f00dc09763397025db,          // a3451795ae1d8ee07a2e0cb556a7b7f7
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // 9d16a61661924ee1d798842d4d7a5d04
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // 8aeb93d39bb7088dd947d21da5e5e1e7
			128'h11bf8733fd238a366a034f04a45e886b,          // 38caaf6a8f615193c370290845a44489
			128'h52189a4747cdb0edce429f70913cf31d,          // f896afd0125ca4af0e262e07c65bf4a8
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 588488a791fbbcf5b3c592b080e16637
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h9f088845fef33692d4da4054fd481996,			// 004c236035c197954ad6fda379288a70
			128'h7bbcc837597d025d3300aaa823e3065d,          // b26c8ecc11ef4659d25c07ee1cf9d05b
			128'h9c5a0537d6f143f00dc09763397025db,          // f88ca75eaee6534fbface511e838fec8
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // e8b9626cd6960d53a47207f027b8db20
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // a94f9a3a57c78d1401ddba0c795d8ee7
			128'h11bf8733fd238a366a034f04a45e886b,          // abbcd79f9fedaa3014643cf59fe4a241
			128'h52189a4747cdb0edce429f70913cf31d,          // efcc27b5941caf7d95ece729334ae5fc
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 56dd98f65b2603efd951876dd2e24676
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h627de9005424432053354b8af6e7ac1f,			// 302c5d85b5f3e038f17f9edd3fe5dae2
			128'h7bbcc837597d025d3300aaa823e3065d,          // efe31361259adce436cf585af76e42ea
			128'h9c5a0537d6f143f00dc09763397025db,          // 009d602e7e55f2711223e86af6aa346d
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // b046dc7d01e462269f47ea86d7571710
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // f3817be5bd4a275c886c2dc89f50a474
			128'h11bf8733fd238a366a034f04a45e886b,          // e5a27737f3765e29b6822d5585892424
			128'h52189a4747cdb0edce429f70913cf31d,          // 3eac69320d8dd4f63f65ab284020399b
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // fa93c586a568d370034cd53044a23ec3
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h1032822fb625d29be5f0d9821bea9282,			// b14297c24107c50f2e053ffacd0c26ba
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,          // 112ab51a15d0c93af8b602cb71fae83e
			128'h603acbae36abdd1816a56787e283a856,          // d3331c1c995040b4cdf47b2ec4f54127
			128'haca65a590c7bacbe4215e614f6388779,          // c52248cfeb1b433b0269886cc8687045
			128'ha71c5ac4f49eee0b01c33dca4a066ffb,          // a53b8afae9996598df94d8af0ac9f7ad
			128'h11bf8733fd238a366a034f04a45e886b,          // 3f406757d7ed444a2a281a436ae71d0c
			128'h52189a4747cdb0edce429f70913cf31d,          // 922a873fbf26af2ecaba86fa5e1f4426
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // f2ac03807ed3624a4083a23140e73a75
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			'{
			128'h8143e42b1d509f0b86e055f1f8eb487e,				//e8a1e02cab00704765870a15b908d5f8
			128'h7e2498f3ca213370f84a7452ac86c200,              //2d0e825736dea54e9584c626ce30886f
			128'hc03f51b56385cd986227e3b94367ba5e,              //f4cc12387ae72fcc3701f4d0427b5ac6
			128'hc7fb67e2e4684765ac6a48aba3df0997,              //c9c3baa0600bce60776109cd0b8e51ec
			128'haf66129b89f65275079b2fef8c05ced3,              //b47ef671c166eea0c39ca584f0f94c3c
			128'hc291645338d798fc3229e9d56e4200d8,              //bad00796c615d67a36b80a70d7cb32bd
			128'h7ec333f00d8d977613eef4cfb62f3c1b,              //4653444d6df9117bf024abc402cd8b74
			128'hc19a404a057494ccb87efbc853d1918b,              //702865eb92a39374e204f6cb71855987
			128'ha97e622149ad3c13a24e826452ff715e,
			128'hc339691af50b906935fdcb24fdff0ea7,
			128'he99aeda813d124d61710ed17d43ab4d3,
			128'hbf6a7d0feab8f1765ba71b64be73442a 
			},
			
			'{
			128'h4aab46c7db31d49334b0b2b8a3514032,				//4b3bef71052c9dce5e7ba50d137725c1
			128'h7bbcc837597d025d3300aaa823e3065d,              //703760fe3a39cd6e2a4e95e16058240c
			128'h9c5a0537d6f143f00dc09763397025db,              //33312f4e23b09efc6b73efe179151fe6
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,              //bc16756943ca68ffd371f95cfe09f7bd
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              //fd7b2105d3f11afc7db11c528f6a3feb
			128'h11bf8733fd238a366a034f04a45e886b,              //db82e58fa598a48940ae9601e4ee530c
			128'h52189a4747cdb0edce429f70913cf31d,              //3d1df821bc79fa902df2a4097800bcf2
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              //9b999a90dacf82fcd2f5320f0193b54e
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h7518d75c7749969189cfd4e3bd302000,				// 813c81e664fbb0105981015fd0278c24
			128'h3148a28aa2c3ef3fe080a30817abd0c4,              // 879a010fc00025c215b5c5cc011d230a
			128'h4869e7153d7130494a38a6d8c3f7723b,              // 461f937f27b0bec210906425f889779d
			128'h3659aa20071108aaa5d2e7954552449d,              // 14f11b1a84e6e62c55c2ad3b44dedf83
			128'h4bd2c81103bb2f043eca1f4d74f2b995,              // 094437539fb5d1fa6d63e4e5daaecbda
			128'h627de9005424432053354b8af6e7ac1f,              // 23adf1d0ea6178e8bd6ae38d96a85ab1
			128'h61fbbed72a2976c6299259c21758468f,              // eb87ea1e780c527ff2966a2405d44b30
			128'h7c84e3bb1ef90abb4add499b19e80211,              // 0c6b40715e3ab21dd8b29cf6c6c0bedf
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f,
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f 
			},
			
				'{
			128'hbb868de0996c16b3a115c4b78fdc28c6,				// 54fc09f93b5e800e1142104b8ca246b6
			128'h10674c6bb1934820c3561a6ab8b46fb7,              // 5eaf35cca8eeff970ea13e42bcb6717f
			128'h1032822fb625d29be5f0d9821bea9282,              // eefd6f85cea5acadb6191b2aec446109
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,              // a115372ec2b6253fb42108efe4c36e83
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              // 7681e29da5752c4721477a012fb25e7d
			128'h11bf8733fd238a366a034f04a45e886b,              // c99bdfbcdb07424095e3029b3ae44009
			128'h52189a4747cdb0edce429f70913cf31d,              // b488327b98b0c42497c0ba2c304e5972
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              // 81e0f36b35e5d374b85967e7c67c176c
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'hea7866e496fc855f88058fe4c2d8c67f,			// eeaf992d7569b34ecadcd6f257551a57
			128'h7bbcc837597d025d3300aaa823e3065d,          // e882cae358a9366cb5978749f240304c
			128'h9c5a0537d6f143f00dc09763397025db,          // a3451795ae1d8ee07a2e0cb556a7b7f7
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // 9d16a61661924ee1d798842d4d7a5d04
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // 8aeb93d39bb7088dd947d21da5e5e1e7
			128'h11bf8733fd238a366a034f04a45e886b,          // 38caaf6a8f615193c370290845a44489
			128'h52189a4747cdb0edce429f70913cf31d,          // f896afd0125ca4af0e262e07c65bf4a8
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 588488a791fbbcf5b3c592b080e16637
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h9f088845fef33692d4da4054fd481996,			// 004c236035c197954ad6fda379288a70
			128'h7bbcc837597d025d3300aaa823e3065d,          // b26c8ecc11ef4659d25c07ee1cf9d05b
			128'h9c5a0537d6f143f00dc09763397025db,          // f88ca75eaee6534fbface511e838fec8
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // e8b9626cd6960d53a47207f027b8db20
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // a94f9a3a57c78d1401ddba0c795d8ee7
			128'h11bf8733fd238a366a034f04a45e886b,          // abbcd79f9fedaa3014643cf59fe4a241
			128'h52189a4747cdb0edce429f70913cf31d,          // efcc27b5941caf7d95ece729334ae5fc
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 56dd98f65b2603efd951876dd2e24676
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h627de9005424432053354b8af6e7ac1f,			// 302c5d85b5f3e038f17f9edd3fe5dae2
			128'h7bbcc837597d025d3300aaa823e3065d,          // efe31361259adce436cf585af76e42ea
			128'h9c5a0537d6f143f00dc09763397025db,          // 009d602e7e55f2711223e86af6aa346d
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // b046dc7d01e462269f47ea86d7571710
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // f3817be5bd4a275c886c2dc89f50a474
			128'h11bf8733fd238a366a034f04a45e886b,          // e5a27737f3765e29b6822d5585892424
			128'h52189a4747cdb0edce429f70913cf31d,          // 3eac69320d8dd4f63f65ab284020399b
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // fa93c586a568d370034cd53044a23ec3
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h1032822fb625d29be5f0d9821bea9282,			// b14297c24107c50f2e053ffacd0c26ba
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,          // 112ab51a15d0c93af8b602cb71fae83e
			128'h603acbae36abdd1816a56787e283a856,          // d3331c1c995040b4cdf47b2ec4f54127
			128'haca65a590c7bacbe4215e614f6388779,          // c52248cfeb1b433b0269886cc8687045
			128'ha71c5ac4f49eee0b01c33dca4a066ffb,          // a53b8afae9996598df94d8af0ac9f7ad
			128'h11bf8733fd238a366a034f04a45e886b,          // 3f406757d7ed444a2a281a436ae71d0c
			128'h52189a4747cdb0edce429f70913cf31d,          // 922a873fbf26af2ecaba86fa5e1f4426
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // f2ac03807ed3624a4083a23140e73a75
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			'{
			128'h8143e42b1d509f0b86e055f1f8eb487e,				//e8a1e02cab00704765870a15b908d5f8
			128'h7e2498f3ca213370f84a7452ac86c200,              //2d0e825736dea54e9584c626ce30886f
			128'hc03f51b56385cd986227e3b94367ba5e,              //f4cc12387ae72fcc3701f4d0427b5ac6
			128'hc7fb67e2e4684765ac6a48aba3df0997,              //c9c3baa0600bce60776109cd0b8e51ec
			128'haf66129b89f65275079b2fef8c05ced3,              //b47ef671c166eea0c39ca584f0f94c3c
			128'hc291645338d798fc3229e9d56e4200d8,              //bad00796c615d67a36b80a70d7cb32bd
			128'h7ec333f00d8d977613eef4cfb62f3c1b,              //4653444d6df9117bf024abc402cd8b74
			128'hc19a404a057494ccb87efbc853d1918b,              //702865eb92a39374e204f6cb71855987
			128'ha97e622149ad3c13a24e826452ff715e,
			128'hc339691af50b906935fdcb24fdff0ea7,
			128'he99aeda813d124d61710ed17d43ab4d3,
			128'hbf6a7d0feab8f1765ba71b64be73442a 
			},
			
			'{
			128'h4aab46c7db31d49334b0b2b8a3514032,				//4b3bef71052c9dce5e7ba50d137725c1
			128'h7bbcc837597d025d3300aaa823e3065d,              //703760fe3a39cd6e2a4e95e16058240c
			128'h9c5a0537d6f143f00dc09763397025db,              //33312f4e23b09efc6b73efe179151fe6
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,              //bc16756943ca68ffd371f95cfe09f7bd
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              //fd7b2105d3f11afc7db11c528f6a3feb
			128'h11bf8733fd238a366a034f04a45e886b,              //db82e58fa598a48940ae9601e4ee530c
			128'h52189a4747cdb0edce429f70913cf31d,              //3d1df821bc79fa902df2a4097800bcf2
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              //9b999a90dacf82fcd2f5320f0193b54e
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h7518d75c7749969189cfd4e3bd302000,				// 813c81e664fbb0105981015fd0278c24
			128'h3148a28aa2c3ef3fe080a30817abd0c4,              // 879a010fc00025c215b5c5cc011d230a
			128'h4869e7153d7130494a38a6d8c3f7723b,              // 461f937f27b0bec210906425f889779d
			128'h3659aa20071108aaa5d2e7954552449d,              // 14f11b1a84e6e62c55c2ad3b44dedf83
			128'h4bd2c81103bb2f043eca1f4d74f2b995,              // 094437539fb5d1fa6d63e4e5daaecbda
			128'h627de9005424432053354b8af6e7ac1f,              // 23adf1d0ea6178e8bd6ae38d96a85ab1
			128'h61fbbed72a2976c6299259c21758468f,              // eb87ea1e780c527ff2966a2405d44b30
			128'h7c84e3bb1ef90abb4add499b19e80211,              // 0c6b40715e3ab21dd8b29cf6c6c0bedf
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f,
			128'h9f088845fef33692d4da4054fd481996,
			128'hea7866e496fc855f88058fe4c2d8c67f 
			},
			
				'{
			128'hbb868de0996c16b3a115c4b78fdc28c6,				// 54fc09f93b5e800e1142104b8ca246b6
			128'h10674c6bb1934820c3561a6ab8b46fb7,              // 5eaf35cca8eeff970ea13e42bcb6717f
			128'h1032822fb625d29be5f0d9821bea9282,              // eefd6f85cea5acadb6191b2aec446109
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,              // a115372ec2b6253fb42108efe4c36e83
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              // 7681e29da5752c4721477a012fb25e7d
			128'h11bf8733fd238a366a034f04a45e886b,              // c99bdfbcdb07424095e3029b3ae44009
			128'h52189a4747cdb0edce429f70913cf31d,              // b488327b98b0c42497c0ba2c304e5972
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,              // 81e0f36b35e5d374b85967e7c67c176c
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'hea7866e496fc855f88058fe4c2d8c67f,			// eeaf992d7569b34ecadcd6f257551a57
			128'h7bbcc837597d025d3300aaa823e3065d,          // e882cae358a9366cb5978749f240304c
			128'h9c5a0537d6f143f00dc09763397025db,          // a3451795ae1d8ee07a2e0cb556a7b7f7
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // 9d16a61661924ee1d798842d4d7a5d04
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // 8aeb93d39bb7088dd947d21da5e5e1e7
			128'h11bf8733fd238a366a034f04a45e886b,          // 38caaf6a8f615193c370290845a44489
			128'h52189a4747cdb0edce429f70913cf31d,          // f896afd0125ca4af0e262e07c65bf4a8
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 588488a791fbbcf5b3c592b080e16637
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h9f088845fef33692d4da4054fd481996,			// 004c236035c197954ad6fda379288a70
			128'h7bbcc837597d025d3300aaa823e3065d,          // b26c8ecc11ef4659d25c07ee1cf9d05b
			128'h9c5a0537d6f143f00dc09763397025db,          // f88ca75eaee6534fbface511e838fec8
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // e8b9626cd6960d53a47207f027b8db20
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // a94f9a3a57c78d1401ddba0c795d8ee7
			128'h11bf8733fd238a366a034f04a45e886b,          // abbcd79f9fedaa3014643cf59fe4a241
			128'h52189a4747cdb0edce429f70913cf31d,          // efcc27b5941caf7d95ece729334ae5fc
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // 56dd98f65b2603efd951876dd2e24676
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h627de9005424432053354b8af6e7ac1f,			// 302c5d85b5f3e038f17f9edd3fe5dae2
			128'h7bbcc837597d025d3300aaa823e3065d,          // efe31361259adce436cf585af76e42ea
			128'h9c5a0537d6f143f00dc09763397025db,          // 009d602e7e55f2711223e86af6aa346d
			128'hec9c0d059720c532ce5dc76ffd5d6dc7,          // b046dc7d01e462269f47ea86d7571710
			128'h15d52aaa898f2f9d5f7e6c6d52befb0e,          // f3817be5bd4a275c886c2dc89f50a474
			128'h11bf8733fd238a366a034f04a45e886b,          // e5a27737f3765e29b6822d5585892424
			128'h52189a4747cdb0edce429f70913cf31d,          // 3eac69320d8dd4f63f65ab284020399b
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // fa93c586a568d370034cd53044a23ec3
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			},
			
				'{
			128'h1032822fb625d29be5f0d9821bea9282,			// b14297c24107c50f2e053ffacd0c26ba
			128'h2b7888a3f36fd6d869a4a7b5290f92d9,          // 112ab51a15d0c93af8b602cb71fae83e
			128'h603acbae36abdd1816a56787e283a856,          // d3331c1c995040b4cdf47b2ec4f54127
			128'haca65a590c7bacbe4215e614f6388779,          // c52248cfeb1b433b0269886cc8687045
			128'ha71c5ac4f49eee0b01c33dca4a066ffb,          // a53b8afae9996598df94d8af0ac9f7ad
			128'h11bf8733fd238a366a034f04a45e886b,          // 3f406757d7ed444a2a281a436ae71d0c
			128'h52189a4747cdb0edce429f70913cf31d,          // 922a873fbf26af2ecaba86fa5e1f4426
			128'h226c72ca33d3f5f9cef07fcfa4f330cb,          // f2ac03807ed3624a4083a23140e73a75
			128'h3e38168f6c208cc82bed3c25e5afa355,
			128'hc9bb8f44ebd7fd8ed804087716f477b8,
			128'hbb868de0996c16b3a115c4b78fdc28c6,
			128'h10674c6bb1934820c3561a6ab8b46fb7 
			}
			
			
		};
		
	reg	[63:0] tweak_idx[32] = { 	
			64'hdd05eb3e987ff6ef,
			64'h6d869a4a7b5290f9,
			64'h24d61710ed17d43a,
			64'h4ccb87efbc853d19,
			64'h487efbc853d1918b,
			64'h6de055f1f8eb487e,
			64'h129b89f652750724,
			64'h0feab8f1765ba71b
			,
			64'hdd05eb3e987ff6ef,
			64'h6d869a4a7b5290f9,
			64'h24d61710ed17d43a,
			64'h4ccb87efbc853d19,
			64'h487efbc853d1918b,
			64'h6de055f1f8eb487e,
			64'h129b89f652750724,
			64'h0feab8f1765ba71b
			,
			64'hdd05eb3e987ff6ef,
			64'h6d869a4a7b5290f9,
			64'h24d61710ed17d43a,
			64'h4ccb87efbc853d19,
			64'h487efbc853d1918b,
			64'h6de055f1f8eb487e,
			64'h129b89f652750724,
			64'h0feab8f1765ba71b
			,
			64'hdd05eb3e987ff6ef,
			64'h6d869a4a7b5290f9,
			64'h24d61710ed17d43a,
			64'h4ccb87efbc853d19,
			64'h487efbc853d1918b,
			64'h6de055f1f8eb487e,
			64'h129b89f652750724,
			64'h0feab8f1765ba71b
			
			
		};

		
	reg	[127:0] hash_idx0[12] = {
		128'h8143e42b1d509f0b86e055f1f8eb487e,
		128'h7e2498f3ca213370f84a7452ac86c200,
		128'hc03f51b56385cd986227e3b94367ba5e,
		128'hc7fb67e2e4684765ac6a48aba3df0997,
		128'haf66129b89f65275079b2fef8c05ced3,
		128'hc291645338d798fc3229e9d56e4200d8,
		128'h7ec333f00d8d977613eef4cfb62f3c1b,
		128'hc19a404a057494ccb87efbc853d1918b,
		128'ha97e622149ad3c13a24e826452ff715e,
		128'hc339691af50b906935fdcb24fdff0ea7,
		128'he99aeda813d124d61710ed17d43ab4d3,
		128'hbf6a7d0feab8f1765ba71b64be73442a 
		};
	reg	[127:0] hash_idx1[12] = {
		128'h4aab46c7db31d49334b0b2b8a3514032,
		128'h7bbcc837597d025d3300aaa823e3065d,
		128'h9c5a0537d6f143f00dc09763397025db,
		128'hec9c0d059720c532ce5dc76ffd5d6dc7,
		128'h15d52aaa898f2f9d5f7e6c6d52befb0e,
		128'h11bf8733fd238a366a034f04a45e886b,
		128'h52189a4747cdb0edce429f70913cf31d,
		128'h226c72ca33d3f5f9cef07fcfa4f330cb,
		128'h3e38168f6c208cc82bed3c25e5afa355,
		128'hc9bb8f44ebd7fd8ed804087716f477b8,
		128'hbb868de0996c16b3a115c4b78fdc28c6,
		128'h10674c6bb1934820c3561a6ab8b46fb7 
		};
	reg	[127:0] hash_idx2[12] = {
		128'h8143e42b1d509f0b86e055f1f8eb487e,
		128'h7e2498f3ca213370f84a7452ac86c200,
		128'hc03f51b56385cd986227e3b94367ba5e,
		128'hc7fb67e2e4684765ac6a48aba3df0997,
		128'haf66129b89f65275079b2fef8c05ced3,
		128'hc291645338d798fc3229e9d56e4200d8,
		128'h7ec333f00d8d977613eef4cfb62f3c1b,
		128'hc19a404a057494ccb87efbc853d1918b,
		128'ha97e622149ad3c13a24e826452ff715e,
		128'hc339691af50b906935fdcb24fdff0ea7,
		128'he99aeda813d124d61710ed17d43ab4d3,
		128'hbf6a7d0feab8f1765ba71b64be73442a 
		};
	reg	[127:0] hash_idx3[12] = {
		128'h8143e42b1d509f0b86e055f1f8eb487e,
		128'h7e2498f3ca213370f84a7452ac86c200,
		128'hc03f51b56385cd986227e3b94367ba5e,
		128'hc7fb67e2e4684765ac6a48aba3df0997,
		128'haf66129b89f65275079b2fef8c05ced3,
		128'hc291645338d798fc3229e9d56e4200d8,
		128'h7ec333f00d8d977613eef4cfb62f3c1b,
		128'hc19a404a057494ccb87efbc853d1918b,
		128'ha97e622149ad3c13a24e826452ff715e,
		128'hc339691af50b906935fdcb24fdff0ea7,
		128'he99aeda813d124d61710ed17d43ab4d3,
		128'hbf6a7d0feab8f1765ba71b64be73442a 
		};
	
	
	
	reg		[127:0]	imp_k_idx[`TASKN][10];
	
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
				  


	wire 	[127:0]	        xout0;
	wire 	[127:0]	        xout1;	
	wire 	[127:0]	        xout2;	
	wire 	[127:0]	        xout3;	
	wire 	[127:0]	        xout4;	
	wire 	[127:0]	        xout5;	
	wire 	[127:0]	        xout6;	
	wire 	[127:0]	        xout7;	
	
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
	
	reg											cenb_init_rbuf;
	reg			[`W_IDX+1+`W_AMEM:0]			db_init_rbuf;
	reg			[`W_IDX:0]						ab_init_rbuf;

	wire										cena_init_rbuf;
	wire		[`W_IDX+1+`W_AMEM:0]			qa_init_rbuf;
	wire		[`W_IDX:0]						aa_init_rbuf;
	
	reg											cenb_loop1_buf;
	reg			[`W_MEM:0]						db_loop1_buf;
	reg			[`W_IDX:0]						ab_loop1_buf;
	wire										cena_loop1_buf;
	wire		[`W_MEM:0]						qa_loop1_buf;
	wire		[`W_IDX:0]						aa_loop1_buf;
	
	reg											cenb_loop2_buf;
	reg			[`W_MEM:0]						db_loop2_buf;
	reg			[`W_IDX:0]						ab_loop2_buf;
	wire										cena_loop2_buf;
	wire		[`W_MEM:0]						qa_loop2_buf;
	wire		[`W_IDX:0]						aa_loop2_buf;
	
	
	reg											cenb_im_buf;
	reg			[`W_MEM:0]						db_im_buf;
	reg			[`W_IDX+3:0]					ab_im_buf;
	reg											cena_im_buf;
	reg			[`W_MEM:0]						qa_im_buf;
	reg			[`W_IDX+3:0]					aa_im_buf;
	
	wire										w_loop1_buf_ready;
	wire										w_loop2_buf_ready;
	wire										w_im_buf_ready;
	
	
	
	
	
	
			
	reg					go_cn_d1, go_cn_d2, go_cn_d3, go_cn_d4, go_cn_d5, go_cn_d6, go_cn_d7, go_cn_d8, go_cn_d9, go_cn_d10, go_cn_d11, go_cn_d12, go_cn_d13, go_cn_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_cn_d1, go_cn_d2, go_cn_d3, go_cn_d4, go_cn_d5, go_cn_d6, go_cn_d7, go_cn_d8, go_cn_d9, go_cn_d10, go_cn_d11, go_cn_d12, go_cn_d13, go_cn_d14} <= 0;
		else			{go_cn_d1, go_cn_d2, go_cn_d3, go_cn_d4, go_cn_d5, go_cn_d6, go_cn_d7, go_cn_d8, go_cn_d9, go_cn_d10, go_cn_d11, go_cn_d12, go_cn_d13, go_cn_d14} <= {go_cn, go_cn_d1, go_cn_d2, go_cn_d3, go_cn_d4, go_cn_d5, go_cn_d6, go_cn_d7, go_cn_d8, go_cn_d9, go_cn_d10, go_cn_d11, go_cn_d12, go_cn_d13};
	
	reg							go_ex0;
	wire						go_ex1, go_ex2, go_ex3;
	wire						ready_ex0, ready_ex1, ready_ex2, ready_ex3;
	wire 		[`W_MEM	:0]		db_scratchpad_ex0;
	wire						cenb_scratchpad_ex0;
	wire		[`W_AMEM:0]		ab_scratchpad_ex0;
	wire 		[`W_MEM	:0]		db_scratchpad_ex1;
	wire						cenb_scratchpad_ex1;
	wire		[`W_AMEM:0]		ab_scratchpad_ex1;
	wire 		[`W_MEM	:0]		db_scratchpad_ex2;
	wire						cenb_scratchpad_ex2;
	wire		[`W_AMEM:0]		ab_scratchpad_ex2;
	wire 		[`W_MEM	:0]		db_scratchpad_ex3;
	wire						cenb_scratchpad_ex3;
	wire		[`W_AMEM:0]		ab_scratchpad_ex3;
	
	reg 		[`W_MEM	:0]		db_scratchpad_ex;
	reg							cenb_scratchpad_ex;
	reg			[`W_EXTMWADDR:0]ab_scratchpad_ex;
	
	reg							cenb_scratchpad_ex0_d1;
	
	
		
		
	always @(`CLK_RST_EDGE)
		if (`RST) 	cenb_scratchpad_ex0_d1 <= 1;
		else 		cenb_scratchpad_ex0_d1 <= cenb_scratchpad_ex0;
	
	wire	go_write_ex = !cenb_scratchpad_ex0& cenb_scratchpad_ex0_d1;

	
	
`ifdef EX_IMPLODE_INSTANCE_4
	reg	[`W_IDX:0]			round_ex0, round_ex1, round_ex2, round_ex3; 

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
			ab_scratchpad_ex <= {round_ex0, 2'h0, ab_scratchpad_ex0};
		else if (!cenb_scratchpad_ex1)	
			ab_scratchpad_ex <= {round_ex1, 2'h1, ab_scratchpad_ex1};
		else if (!cenb_scratchpad_ex2)		
			ab_scratchpad_ex <= {round_ex2, 2'h2, ab_scratchpad_ex2};
		else if (!cenb_scratchpad_ex3)		
			ab_scratchpad_ex <= {round_ex3, 2'h3, ab_scratchpad_ex3};

	reg						go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14;
	reg						go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14;
	reg						go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= 0;
		else			{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= {go_ex0, go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13};

	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14} <= 0;
		else			{go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13, go_ex1_d14} <= {go_ex1, go_ex1_d1, go_ex1_d2, go_ex1_d3, go_ex1_d4, go_ex1_d5, go_ex1_d6, go_ex1_d7, go_ex1_d8, go_ex1_d9, go_ex1_d10, go_ex1_d11, go_ex1_d12, go_ex1_d13};

	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14} <= 0;
		else			{go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13, go_ex2_d14} <= {go_ex2, go_ex2_d1, go_ex2_d2, go_ex2_d3, go_ex2_d4, go_ex2_d5, go_ex2_d6, go_ex2_d7, go_ex2_d8, go_ex2_d9, go_ex2_d10, go_ex2_d11, go_ex2_d12, go_ex2_d13};
	
	
	reg		[`W_IDX:0]			ex_wr_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)		ex_wr_idx <= 0;
		else			ex_wr_idx <= {round_ex0, {2{1'b0}} };
		
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex0 <= 0;
		else if (go_cn)		round_ex0 <= 0;
		else if (ready_ex0) round_ex0 <= round_ex0 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex1 <= 0;
		else if (go_cn)		round_ex1 <= 0;
		else if (ready_ex1) round_ex1 <= round_ex1 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex2 <= 0;
		else if (go_cn)		round_ex2 <= 0;
		else if (ready_ex2) round_ex2 <= round_ex2 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex3 <= 0;
		else if (go_cn)		round_ex3 <= 0;
		else if (ready_ex3) round_ex3 <= round_ex3 + 1;
	always @(`CLK_EDGE)
		if (ready_ex0) begin
			imp_k_idx[round_ex0*4+0][0] <= ex0.imp_k0;
			imp_k_idx[round_ex0*4+0][1] <= ex0.imp_k1;
			imp_k_idx[round_ex0*4+0][2] <= ex0.imp_k2;
			imp_k_idx[round_ex0*4+0][3] <= ex0.imp_k3;
			imp_k_idx[round_ex0*4+0][4] <= ex0.imp_k4;
			imp_k_idx[round_ex0*4+0][5] <= ex0.imp_k5;
			imp_k_idx[round_ex0*4+0][6] <= ex0.imp_k6;
			imp_k_idx[round_ex0*4+0][7] <= ex0.imp_k7;
			imp_k_idx[round_ex0*4+0][8] <= ex0.imp_k8;
			imp_k_idx[round_ex0*4+0][9] <= ex0.imp_k9;
		end                          
	always @(`CLK_EDGE)
		if (ready_ex1) begin
			imp_k_idx[round_ex1*4+1][0] <= ex1.imp_k0;
			imp_k_idx[round_ex1*4+1][1] <= ex1.imp_k1;
			imp_k_idx[round_ex1*4+1][2] <= ex1.imp_k2;
			imp_k_idx[round_ex1*4+1][3] <= ex1.imp_k3;
			imp_k_idx[round_ex1*4+1][4] <= ex1.imp_k4;
			imp_k_idx[round_ex1*4+1][5] <= ex1.imp_k5;
			imp_k_idx[round_ex1*4+1][6] <= ex1.imp_k6;
			imp_k_idx[round_ex1*4+1][7] <= ex1.imp_k7;
			imp_k_idx[round_ex1*4+1][8] <= ex1.imp_k8;
			imp_k_idx[round_ex1*4+1][9] <= ex1.imp_k9;
		end   	
	always @(`CLK_EDGE)
		if (ready_ex2) begin
			imp_k_idx[round_ex2*4+2][0] <= ex2.imp_k0;
			imp_k_idx[round_ex2*4+2][1] <= ex2.imp_k1;
			imp_k_idx[round_ex2*4+2][2] <= ex2.imp_k2;
			imp_k_idx[round_ex2*4+2][3] <= ex2.imp_k3;
			imp_k_idx[round_ex2*4+2][4] <= ex2.imp_k4;
			imp_k_idx[round_ex2*4+2][5] <= ex2.imp_k5;
			imp_k_idx[round_ex2*4+2][6] <= ex2.imp_k6;
			imp_k_idx[round_ex2*4+2][7] <= ex2.imp_k7;
			imp_k_idx[round_ex2*4+2][8] <= ex2.imp_k8;
			imp_k_idx[round_ex2*4+2][9] <= ex2.imp_k9;
		end                          
	always @(`CLK_EDGE)
		if (ready_ex3) begin
			imp_k_idx[round_ex3*4+3][0] <= ex3.imp_k0;
			imp_k_idx[round_ex3*4+3][1] <= ex3.imp_k1;
			imp_k_idx[round_ex3*4+3][2] <= ex3.imp_k2;
			imp_k_idx[round_ex3*4+3][3] <= ex3.imp_k3;
			imp_k_idx[round_ex3*4+3][4] <= ex3.imp_k4;
			imp_k_idx[round_ex3*4+3][5] <= ex3.imp_k5;
			imp_k_idx[round_ex3*4+3][6] <= ex3.imp_k6;
			imp_k_idx[round_ex3*4+3][7] <= ex3.imp_k7;
			imp_k_idx[round_ex3*4+3][8] <= ex3.imp_k8;
			imp_k_idx[round_ex3*4+3][9] <= ex3.imp_k9;
		end                          
	
	always @(`CLK_RST_EDGE)
		if (`RST)	go_ex0 <= 0;
	//	else		go_ex0 <= go_cn | (ready_ex0 & !round_ex0);
		else		go_ex0 <= go_cn | (ready_ex0 & (round_ex0 != {(`W_IDX-1){1'b1}}));

	
	//assign go_ex0 = go_cn | (ready_ex0 & !round_ex0);
//	assign go_ex0 = go_cn;
	assign go_ex1 = go_ex0_d8;	
	assign go_ex2 = go_ex1_d8;	
	assign go_ex3 = go_ex2_d8;	
	
	genkeyExplode ex0(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex0),
		.hash0              (hash_idx[round_ex0*4+0][0]),
		.hash1              (hash_idx[round_ex0*4+0][1]),
		.hash2              (hash_idx[round_ex0*4+0][2]),
		.hash3              (hash_idx[round_ex0*4+0][3]),
		.hash4              (hash_idx[round_ex0*4+0][4]),
		.hash5              (hash_idx[round_ex0*4+0][5]),
		.hash6              (hash_idx[round_ex0*4+0][6]),
		.hash7              (hash_idx[round_ex0*4+0][7]),
		.hash8              (hash_idx[round_ex0*4+0][8]),
		.hash9              (hash_idx[round_ex0*4+0][9]),
		.hash10             (hash_idx[round_ex0*4+0][10]),
		.hash11             (hash_idx[round_ex0*4+0][11]),
		.ready				(ready_ex0),
		.db_scratchpad_ex	(db_scratchpad_ex0	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex0	),
		.ab_scratchpad_ex	(ab_scratchpad_ex0	)
	);
	
	genkeyExplode ex1(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex1),
		.hash0              (hash_idx[round_ex1*4+1][0]),
		.hash1              (hash_idx[round_ex1*4+1][1]),
		.hash2              (hash_idx[round_ex1*4+1][2]),
		.hash3              (hash_idx[round_ex1*4+1][3]),
		.hash4              (hash_idx[round_ex1*4+1][4]),
		.hash5              (hash_idx[round_ex1*4+1][5]),
		.hash6              (hash_idx[round_ex1*4+1][6]),
		.hash7              (hash_idx[round_ex1*4+1][7]),
		.hash8              (hash_idx[round_ex1*4+1][8]),
		.hash9              (hash_idx[round_ex1*4+1][9]),
		.hash10             (hash_idx[round_ex1*4+1][10]),
		.hash11             (hash_idx[round_ex1*4+1][11]),
		.ready				(ready_ex1),
		.db_scratchpad_ex	(db_scratchpad_ex1	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex1	),
		.ab_scratchpad_ex	(ab_scratchpad_ex1	)
	);

	genkeyExplode ex2(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex2),
		.hash0              (hash_idx[round_ex2*4+2][0]),
		.hash1              (hash_idx[round_ex2*4+2][1]),
		.hash2              (hash_idx[round_ex2*4+2][2]),
		.hash3              (hash_idx[round_ex2*4+2][3]),
		.hash4              (hash_idx[round_ex2*4+2][4]),
		.hash5              (hash_idx[round_ex2*4+2][5]),
		.hash6              (hash_idx[round_ex2*4+2][6]),
		.hash7              (hash_idx[round_ex2*4+2][7]),
		.hash8              (hash_idx[round_ex2*4+2][8]),
		.hash9              (hash_idx[round_ex2*4+2][9]),
		.hash10             (hash_idx[round_ex2*4+2][10]),
		.hash11             (hash_idx[round_ex2*4+2][11]),
		.ready				(ready_ex2),
		.db_scratchpad_ex	(db_scratchpad_ex2	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex2	),
		.ab_scratchpad_ex	(ab_scratchpad_ex2	)
	);
	
	genkeyExplode ex3(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex3),
		.hash0              (hash_idx[round_ex3*4+3][0]),
		.hash1              (hash_idx[round_ex3*4+3][1]),
		.hash2              (hash_idx[round_ex3*4+3][2]),
		.hash3              (hash_idx[round_ex3*4+3][3]),
		.hash4              (hash_idx[round_ex3*4+3][4]),
		.hash5              (hash_idx[round_ex3*4+3][5]),
		.hash6              (hash_idx[round_ex3*4+3][6]),
		.hash7              (hash_idx[round_ex3*4+3][7]),
		.hash8              (hash_idx[round_ex3*4+3][8]),
		.hash9              (hash_idx[round_ex3*4+3][9]),
		.hash10             (hash_idx[round_ex3*4+3][10]),
		.hash11             (hash_idx[round_ex3*4+3][11]),
		.ready				(ready_ex3),
		.db_scratchpad_ex	(db_scratchpad_ex3	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex3	),
		.ab_scratchpad_ex	(ab_scratchpad_ex3	)
	);
	
`else
	wire	[127:0]		ex0_imp_k0;
	wire	[127:0]		ex0_imp_k1;
	wire	[127:0]		ex0_imp_k2;
	wire	[127:0]		ex0_imp_k3;
	wire	[127:0]		ex0_imp_k4;
	wire	[127:0]		ex0_imp_k5;
	wire	[127:0]		ex0_imp_k6;
	wire	[127:0]		ex0_imp_k7;
	wire	[127:0]		ex0_imp_k8;
	wire	[127:0]		ex0_imp_k9;

	wire	[127:0]		ex1_imp_k0;
	wire	[127:0]		ex1_imp_k1;
	wire	[127:0]		ex1_imp_k2;
	wire	[127:0]		ex1_imp_k3;
	wire	[127:0]		ex1_imp_k4;
	wire	[127:0]		ex1_imp_k5;
	wire	[127:0]		ex1_imp_k6;
	wire	[127:0]		ex1_imp_k7;
	wire	[127:0]		ex1_imp_k8;
	wire	[127:0]		ex1_imp_k9;

	
	reg		[`W_IDX-1:0]		round_ex0, round_ex1; 
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
			ab_scratchpad_ex <= {round_ex0, 1'h0, ab_scratchpad_ex0};
		else if (!cenb_scratchpad_ex1)	
			ab_scratchpad_ex <= {round_ex1, 1'h1, ab_scratchpad_ex1};

	reg						go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= 0;
		else			{go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13, go_ex0_d14} <= {go_ex0, go_ex0_d1, go_ex0_d2, go_ex0_d3, go_ex0_d4, go_ex0_d5, go_ex0_d6, go_ex0_d7, go_ex0_d8, go_ex0_d9, go_ex0_d10, go_ex0_d11, go_ex0_d12, go_ex0_d13};
	
	reg		[`W_IDX:0]			ex_wr_idx;
	always @(`CLK_RST_EDGE)
		if (`RST)		ex_wr_idx <= 0;
		else			ex_wr_idx <= {round_ex0,  1'b0 };
		
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex0 <= 0;
		else if (go_cn)		round_ex0 <= 0;
		else if (ready_ex0) round_ex0 <= round_ex0 + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			round_ex1 <= 0;
		else if (go_cn)		round_ex1 <= 0;
		else if (ready_ex1) round_ex1 <= round_ex1 + 1;

		
	always @(`CLK_EDGE)
		if (ready_ex0) begin
			imp_k_idx[round_ex0*2+0][0] <= ex0_imp_k0;
			imp_k_idx[round_ex0*2+0][1] <= ex0_imp_k1;
			imp_k_idx[round_ex0*2+0][2] <= ex0_imp_k2;
			imp_k_idx[round_ex0*2+0][3] <= ex0_imp_k3;
			imp_k_idx[round_ex0*2+0][4] <= ex0_imp_k4;
			imp_k_idx[round_ex0*2+0][5] <= ex0_imp_k5;
			imp_k_idx[round_ex0*2+0][6] <= ex0_imp_k6;
			imp_k_idx[round_ex0*2+0][7] <= ex0_imp_k7;
			imp_k_idx[round_ex0*2+0][8] <= ex0_imp_k8;
			imp_k_idx[round_ex0*2+0][9] <= ex0_imp_k9;
		end                          
	//always @(`CLK_EDGE)
		else 
		if (ready_ex1) begin
			imp_k_idx[round_ex1*2+1][0] <= ex1_imp_k0;
			imp_k_idx[round_ex1*2+1][1] <= ex1_imp_k1;
			imp_k_idx[round_ex1*2+1][2] <= ex1_imp_k2;
			imp_k_idx[round_ex1*2+1][3] <= ex1_imp_k3;
			imp_k_idx[round_ex1*2+1][4] <= ex1_imp_k4;
			imp_k_idx[round_ex1*2+1][5] <= ex1_imp_k5;
			imp_k_idx[round_ex1*2+1][6] <= ex1_imp_k6;
			imp_k_idx[round_ex1*2+1][7] <= ex1_imp_k7;
			imp_k_idx[round_ex1*2+1][8] <= ex1_imp_k8;
			imp_k_idx[round_ex1*2+1][9] <= ex1_imp_k9;
		end   	
		
	
	       
	always @(`CLK_RST_EDGE)
		if (`RST)	go_ex0 <= 0;
		else		go_ex0 <= go_cn | (ready_ex0 & (round_ex0 != {`W_IDX{1'b1}}));
	
	//assign go_ex0 = go_cn | (ready_ex0 & !round_ex0);
//	assign go_ex0 = go_cn;
	assign go_ex1 = go_ex0_d8;	
	
	genkeyExplode ex0(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex0),
		.hash0              (hash_idx[round_ex0*2+0][0]),
		.hash1              (hash_idx[round_ex0*2+0][1]),
		.hash2              (hash_idx[round_ex0*2+0][2]),
		.hash3              (hash_idx[round_ex0*2+0][3]),
		.hash4              (hash_idx[round_ex0*2+0][4]),
		.hash5              (hash_idx[round_ex0*2+0][5]),
		.hash6              (hash_idx[round_ex0*2+0][6]),
		.hash7              (hash_idx[round_ex0*2+0][7]),
		.hash8              (hash_idx[round_ex0*2+0][8]),
		.hash9              (hash_idx[round_ex0*2+0][9]),
		.hash10             (hash_idx[round_ex0*2+0][10]),
		.hash11             (hash_idx[round_ex0*2+0][11]),
		
		
		.imp_k0				(ex0_imp_k0),
		.imp_k1				(ex0_imp_k1),
		.imp_k2				(ex0_imp_k2),
		.imp_k3				(ex0_imp_k3),
		.imp_k4				(ex0_imp_k4),
		.imp_k5				(ex0_imp_k5),
		.imp_k6				(ex0_imp_k6),
		.imp_k7				(ex0_imp_k7),
		.imp_k8				(ex0_imp_k8),
		.imp_k9				(ex0_imp_k9),
		
		
		
		.ready				(ready_ex0),
		.db_scratchpad_ex	(db_scratchpad_ex0	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex0	),
		.ab_scratchpad_ex	(ab_scratchpad_ex0	)
	);
	
	genkeyExplode ex1(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_ex1),
		.hash0              (hash_idx[round_ex1*2+1][0]),
		.hash1              (hash_idx[round_ex1*2+1][1]),
		.hash2              (hash_idx[round_ex1*2+1][2]),
		.hash3              (hash_idx[round_ex1*2+1][3]),
		.hash4              (hash_idx[round_ex1*2+1][4]),
		.hash5              (hash_idx[round_ex1*2+1][5]),
		.hash6              (hash_idx[round_ex1*2+1][6]),
		.hash7              (hash_idx[round_ex1*2+1][7]),
		.hash8              (hash_idx[round_ex1*2+1][8]),
		.hash9              (hash_idx[round_ex1*2+1][9]),
		.hash10             (hash_idx[round_ex1*2+1][10]),
		.hash11             (hash_idx[round_ex1*2+1][11]),
		
		.imp_k0				(ex1_imp_k0),
		.imp_k1				(ex1_imp_k1),
		.imp_k2				(ex1_imp_k2),
		.imp_k3				(ex1_imp_k3),
		.imp_k4				(ex1_imp_k4),
		.imp_k5				(ex1_imp_k5),
		.imp_k6				(ex1_imp_k6),
		.imp_k7				(ex1_imp_k7),
		.imp_k8				(ex1_imp_k8),
		.imp_k9				(ex1_imp_k9),
		
		.ready				(ready_ex1),
		.db_scratchpad_ex	(db_scratchpad_ex1	),
		.cenb_scratchpad_ex	(cenb_scratchpad_ex1	),
		.ab_scratchpad_ex	(ab_scratchpad_ex1	)
	);


`endif	
	//========implode======================================================================
	
//	wire										cenb_im_buf;
//	wire		[`W_MEM:0]						db_im_buf;
//	wire		[`W_IDX:0]						ab_im_buf;
//	wire										cena_im_buf;
//	wire		[`W_MEM:0]						qa_im_buf;
//	wire		[`W_IDX:0]						aa_im_buf;
	
	wire 	[127:0]	        xout0_im0;
	wire 	[127:0]	        xout1_im0;	
	wire 	[127:0]	        xout2_im0;	
	wire 	[127:0]	        xout3_im0;	
	wire 	[127:0]	        xout4_im0;	
	wire 	[127:0]	        xout5_im0;	
	wire 	[127:0]	        xout6_im0;	
	wire 	[127:0]	        xout7_im0;	
	
	wire 	[127:0]	        xout0_im1;
	wire 	[127:0]	        xout1_im1;	
	wire 	[127:0]	        xout2_im1;	
	wire 	[127:0]	        xout3_im1;	
	wire 	[127:0]	        xout4_im1;	
	wire 	[127:0]	        xout5_im1;	
	wire 	[127:0]	        xout6_im1;	
	wire 	[127:0]	        xout7_im1;	
	
	wire 	[127:0]	        xout0_im2;
	wire 	[127:0]	        xout1_im2;	
	wire 	[127:0]	        xout2_im2;	
	wire 	[127:0]	        xout3_im2;	
	wire 	[127:0]	        xout4_im2;	
	wire 	[127:0]	        xout5_im2;	
	wire 	[127:0]	        xout6_im2;	
	wire 	[127:0]	        xout7_im2;	
	
	wire 	[127:0]	        xout0_im3;
	wire 	[127:0]	        xout1_im3;	
	wire 	[127:0]	        xout2_im3;	
	wire 	[127:0]	        xout3_im3;	
	wire 	[127:0]	        xout4_im3;	
	wire 	[127:0]	        xout5_im3;	
	wire 	[127:0]	        xout6_im3;	
	wire 	[127:0]	        xout7_im3;	
	
	
	
	wire		main_ready;
	reg			go_im0;
	wire		ready_for_next_im0;
	reg			doing_im_round; 
	reg			doing_im;
	reg		[`W_IDX:0] 			idx_im0;	
	reg							ready_im0;	
	wire						ready_round_im0;
`ifdef 	SIMULATION_LESS_IMPLODE_CYCLES
	parameter IM_ROUND_MAX = (`MEM/16)/8/32 -1;
`else
	parameter IM_ROUND_MAX = (`MEM/16)/8 -1;
`endif
	//parameter IM_ROUND_MAX = (`MEM/16)/1024 -1;
	//parameter IM_ROUND_MAX = 8 -1;
	reg		[15:0]	im_round;
	wire 	im_round_maxminus1_f = im_round == IM_ROUND_MAX-1;  // = 2^(21-4) = 128K*10 = 1M多
	wire 	im_round_max_f = im_round == IM_ROUND_MAX;  // = 2^(21-4) = 128K*10 = 1M多
	reg					im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14} <= 0;
		else			{im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13, im_round_max_f_d14} <= {im_round_max_f, im_round_max_f_d1, im_round_max_f_d2, im_round_max_f_d3, im_round_max_f_d4, im_round_max_f_d5, im_round_max_f_d6, im_round_max_f_d7, im_round_max_f_d8, im_round_max_f_d9, im_round_max_f_d10, im_round_max_f_d11, im_round_max_f_d12, im_round_max_f_d13};

	reg		[1:0]	im_buf_cached;

	
	
	wire go_round_im0 = !doing_im_round & doing_im & (im_buf_cached!=0);
	
	always @(`CLK_RST_EDGE)
		if (`RST)	im_buf_cached <= 0;
		else case({go_round_im0, w_im_buf_ready})
			2'b10: im_buf_cached <= im_buf_cached - 1;
			2'b01: im_buf_cached <= im_buf_cached + 1;
			endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)	go_im0 <= 0;
	//	else		go_im0 <= go_cn | ( ready_im0 & (idx_im0==0) ) ;
`ifdef EX_IMPLODE_INSTANCE_4
		else		go_im0 <= main_ready | ( ready_im0 & (idx_im0==0) ) ;
`else
		else		go_im0 <= main_ready | ( ready_im0 & (idx_im0!={{`W_IDX{1'b1}}, 1'b0}) ) ;
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
	
	//reg		im_datahub_req;
	reg					go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14} <= 0;
		else			{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13, go_im0_d14} <= {go_im0, go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8, go_im0_d9, go_im0_d10, go_im0_d11, go_im0_d12, go_im0_d13};
	wire	 im_datahub_req = go_im0 | go_im0_d6 | (go_round_im0 & !im_round_max_f & !im_round_maxminus1_f);
		
	always @(`CLK_RST_EDGE)
		if (`RST)					 	 idx_im0 <= 0;
	//	else if (go_im0)				 idx_im0 <= 0;
		else if (go_cn)				 	idx_im0 <= 0;
`ifdef 	EX_IMPLODE_INSTANCE_4
		else if (ready_im0) 			idx_im0 <= idx_im0 + 4;
`else
		else if (ready_im0) 			idx_im0 <= idx_im0 + 2;
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

	cn_implode im0(
		.clk 			(clk), 		
		.rstn			(rstn),
		.init_f			(go_im0),
		.go				(go_round_im0),
		
	//	.k0             (ex0.imp_k0),
	//	.k1             (ex0.imp_k1),
	//	.k2             (ex0.imp_k2),
	//	.k3             (ex0.imp_k3),
	//	.k4             (ex0.imp_k4),
	//	.k5             (ex0.imp_k5),
	//	.k6             (ex0.imp_k6),
	//	.k7             (ex0.imp_k7),
	//	.k8             (ex0.imp_k8),
	//	.k9             (ex0.imp_k9),
		.k0             (imp_k_idx[idx_im0][0]),
		.k1             (imp_k_idx[idx_im0][1]),
		.k2             (imp_k_idx[idx_im0][2]),
		.k3             (imp_k_idx[idx_im0][3]),
		.k4             (imp_k_idx[idx_im0][4]),
		.k5             (imp_k_idx[idx_im0][5]),
		.k6             (imp_k_idx[idx_im0][6]),
		.k7             (imp_k_idx[idx_im0][7]),
		.k8             (imp_k_idx[idx_im0][8]),
		.k9             (imp_k_idx[idx_im0][9]),
	
	
		
		.blk0			(hash_idx[idx_im0][4]),
		.blk1           (hash_idx[idx_im0][5]),
		.blk2           (hash_idx[idx_im0][6]),
		.blk3           (hash_idx[idx_im0][7]),
		.blk4           (hash_idx[idx_im0][8]),
		.blk5           (hash_idx[idx_im0][9]),
		.blk6           (hash_idx[idx_im0][10]),
		.blk7           (hash_idx[idx_im0][11]),
		        
		.xout0			 (xout0_im0),
		.xout1           (xout1_im0),
		.xout2           (xout2_im0),
		.xout3           (xout3_im0),
		.xout4           (xout4_im0),
		.xout5           (xout5_im0),
		.xout6           (xout6_im0),
		.xout7           (xout7_im0),
		
		.ready_for_next	(ready_for_next_im0),
		.ready			(ready_round_im0),
		.qa_scratchpad	(qa_im_buf),
		.cena_scratchpad(cena_scratchpad_im0),
		.aa_scratchpad	(aa_scratchpad_im0)
	);
	
	reg		go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8} <= 0;
		else		{go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7, go_im0_d8} <= 
						{go_im0, go_im0_d1, go_im0_d2, go_im0_d3, go_im0_d4, go_im0_d5, go_im0_d6, go_im0_d7};
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
		.init_f			(go_im1),
		.go				(go_round_im1),
		
		// .k0             (ex1.imp_k0),
		// .k1             (ex1.imp_k1),
		// .k2             (ex1.imp_k2),
		// .k3             (ex1.imp_k3),
		// .k4             (ex1.imp_k4),
		// .k5             (ex1.imp_k5),
		// .k6             (ex1.imp_k6),
		// .k7             (ex1.imp_k7),
		// .k8             (ex1.imp_k8),
		// .k9             (ex1.imp_k9),
		.k0             (imp_k_idx[idx_im1][0]),
		.k1             (imp_k_idx[idx_im1][1]),
		.k2             (imp_k_idx[idx_im1][2]),
		.k3             (imp_k_idx[idx_im1][3]),
		.k4             (imp_k_idx[idx_im1][4]),
		.k5             (imp_k_idx[idx_im1][5]),
		.k6             (imp_k_idx[idx_im1][6]),
		.k7             (imp_k_idx[idx_im1][7]),
		.k8             (imp_k_idx[idx_im1][8]),
		.k9             (imp_k_idx[idx_im1][9]),
		
		.blk0			(hash_idx[idx_im1][4]),
		.blk1           (hash_idx[idx_im1][5]),
		.blk2           (hash_idx[idx_im1][6]),
		.blk3           (hash_idx[idx_im1][7]),
		.blk4           (hash_idx[idx_im1][8]),
		.blk5           (hash_idx[idx_im1][9]),
		.blk6           (hash_idx[idx_im1][10]),
		.blk7           (hash_idx[idx_im1][11]),
		        
		.xout0			 (xout0_im1),
		.xout1           (xout1_im1),
		.xout2           (xout2_im1),
		.xout3           (xout3_im1),
		.xout4           (xout4_im1),
		.xout5           (xout5_im1),
		.xout6           (xout6_im1),
		.xout7           (xout7_im1),
		
		.ready_for_next	(ready_for_next_im1),
		.ready			(ready_round_im1),
		.qa_scratchpad	(qa_im_buf)
	);
	
	
`ifdef 	EX_IMPLODE_INSTANCE_4
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
		.init_f			(go_im2),
		.go				(go_round_im2),
		
		// .k0             (ex1.imp_k0),
		// .k1             (ex1.imp_k1),
		// .k2             (ex1.imp_k2),
		// .k3             (ex1.imp_k3),
		// .k4             (ex1.imp_k4),
		// .k5             (ex1.imp_k5),
		// .k6             (ex1.imp_k6),
		// .k7             (ex1.imp_k7),
		// .k8             (ex1.imp_k8),
		// .k9             (ex1.imp_k9),
		.k0             (imp_k_idx[idx_im2][0]),
		.k1             (imp_k_idx[idx_im2][1]),
		.k2             (imp_k_idx[idx_im2][2]),
		.k3             (imp_k_idx[idx_im2][3]),
		.k4             (imp_k_idx[idx_im2][4]),
		.k5             (imp_k_idx[idx_im2][5]),
		.k6             (imp_k_idx[idx_im2][6]),
		.k7             (imp_k_idx[idx_im2][7]),
		.k8             (imp_k_idx[idx_im2][8]),
		.k9             (imp_k_idx[idx_im2][9]),
		
		.blk0			(hash_idx[idx_im2][4]),
		.blk1           (hash_idx[idx_im2][5]),
		.blk2           (hash_idx[idx_im2][6]),
		.blk3           (hash_idx[idx_im2][7]),
		.blk4           (hash_idx[idx_im2][8]),
		.blk5           (hash_idx[idx_im2][9]),
		.blk6           (hash_idx[idx_im2][10]),
		.blk7           (hash_idx[idx_im2][11]),
		        
		.xout0			 (xout0_im2),
		.xout1           (xout1_im2),
		.xout2           (xout2_im2),
		.xout3           (xout3_im2),
		.xout4           (xout4_im2),
		.xout5           (xout5_im2),
		.xout6           (xout6_im2),
		.xout7           (xout7_im2),
		
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
		.init_f			(go_im3),
		.go				(go_round_im3),
		
		// .k0             (ex1.imp_k0),
		// .k1             (ex1.imp_k1),
		// .k2             (ex1.imp_k2),
		// .k3             (ex1.imp_k3),
		// .k4             (ex1.imp_k4),
		// .k5             (ex1.imp_k5),
		// .k6             (ex1.imp_k6),
		// .k7             (ex1.imp_k7),
		// .k8             (ex1.imp_k8),
		// .k9             (ex1.imp_k9),
		.k0             (imp_k_idx[idx_im3][0]),
		.k1             (imp_k_idx[idx_im3][1]),
		.k2             (imp_k_idx[idx_im3][2]),
		.k3             (imp_k_idx[idx_im3][3]),
		.k4             (imp_k_idx[idx_im3][4]),
		.k5             (imp_k_idx[idx_im3][5]),
		.k6             (imp_k_idx[idx_im3][6]),
		.k7             (imp_k_idx[idx_im3][7]),
		.k8             (imp_k_idx[idx_im3][8]),
		.k9             (imp_k_idx[idx_im3][9]),
		
		.blk0			(hash_idx[idx_im3][4]),
		.blk1           (hash_idx[idx_im3][5]),
		.blk2           (hash_idx[idx_im3][6]),
		.blk3           (hash_idx[idx_im3][7]),
		.blk4           (hash_idx[idx_im3][8]),
		.blk5           (hash_idx[idx_im3][9]),
		.blk6           (hash_idx[idx_im3][10]),
		.blk7           (hash_idx[idx_im3][11]),
		        
		.xout0			 (xout0_im3),
		.xout1           (xout1_im3),
		.xout2           (xout2_im3),
		.xout3           (xout3_im3),
		.xout4           (xout4_im3),
		.xout5           (xout5_im3),
		.xout6           (xout6_im3),
		.xout7           (xout7_im3),
		
		.ready_for_next	(ready_for_next_im3),
		.ready			(ready_round_im3),
		.qa_scratchpad	(qa_im_buf)
	);
	
`endif	
	reg		ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8} <= 0;
		else		{ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7, ready_im0_d8} <= 
						{ready_im0, ready_im0_d1, ready_im0_d2, ready_im0_d3, ready_im0_d4, ready_im0_d5, ready_im0_d6, ready_im0_d7};	
						
	wire	ready_im1= ready_im0_d8;	
`ifdef EX_IMPLODE_INSTANCE_4
	reg		ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8} <= 0;
		else		{ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7, ready_im1_d8} <= 
						{ready_im1, ready_im1_d1, ready_im1_d2, ready_im1_d3, ready_im1_d4, ready_im1_d5, ready_im1_d6, ready_im1_d7};
	wire	ready_im2= ready_im1_d8;	
	reg		ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8} <= 0;
		else		{ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7, ready_im2_d8} <= 
						{ready_im2, ready_im2_d1, ready_im2_d2, ready_im2_d3, ready_im2_d4, ready_im2_d5, ready_im2_d6, ready_im2_d7};
	wire	ready_im3= ready_im2_d8;	
`endif
	always @(`CLK_RST_EDGE)
		if(ready_im0)   begin
			$display("T%dsimulation done===================", $time);
			$display("%032x", xout0_im0);
			$display("%032x", xout1_im0);
			$display("%032x", xout2_im0);
			$display("%032x", xout3_im0);
			$display("%032x", xout4_im0);
			$display("%032x", xout5_im0);
			$display("%032x", xout6_im0);
			$display("%032x", xout7_im0);
`ifdef 	EX_IMPLODE_INSTANCE_4	
			if (idx_im0 != 0)
`else
			if (idx_im0 == {{`W_IDX{1'b1}}, 1'b0})
`endif
				#2000 $finish;
		end

	always @(`CLK_RST_EDGE)
		if(ready_im1)   begin
			$display("T%dsimulation done==im1=================", $time);
			$display("%032x", xout0_im1);
			$display("%032x", xout1_im1);
			$display("%032x", xout2_im1);
			$display("%032x", xout3_im1);
			$display("%032x", xout4_im1);
			$display("%032x", xout5_im1);
			$display("%032x", xout6_im1);
			$display("%032x", xout7_im1);
		
			//if (idx_im0 != 0)
			//	#2000 $finish;
		end
`ifdef EX_IMPLODE_INSTANCE_4
	always @(`CLK_RST_EDGE)
		if(ready_im2)   begin
			$display("T%dsimulation done==im2=================", $time);
			$display("%032x", xout0_im2);
			$display("%032x", xout1_im2);
			$display("%032x", xout2_im2);
			$display("%032x", xout3_im2);
			$display("%032x", xout4_im2);
			$display("%032x", xout5_im2);
			$display("%032x", xout6_im2);
			$display("%032x", xout7_im2);
		
			//if (idx_im0 != 0)
			//	#2000 $finish;
		end
	always @(`CLK_RST_EDGE)
		if(ready_im3)   begin
			$display("T%dsimulation done==im3=================", $time);
			$display("%032x", xout0_im3);
			$display("%032x", xout1_im3);
			$display("%032x", xout2_im3);
			$display("%032x", xout3_im3);
			$display("%032x", xout4_im3);
			$display("%032x", xout5_im3);
			$display("%032x", xout6_im3);
			$display("%032x", xout7_im3);
		
			//if (idx_im0 != 0)
			//	#2000 $finish;
		end
	
		
`endif		
		
	//wire	 init_datahub_req = go_cn | go_cn_d6;
	//wire	 init_datahub_req = (ready_ex0 & ex_round);
`ifdef 	EX_IMPLODE_INSTANCE_4
	wire	mainloop_go = (ready_ex3 & round_ex3);
`else
	wire	mainloop_go = (ready_ex1 & (round_ex1 == {`W_IDX{1'b1}}) );
`endif
	reg					mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14;
	always @(`CLK_RST_EDGE)
		if (`RST)		{mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14} <= 0;
		else			{mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13, mainloop_go_d14} <= {mainloop_go, mainloop_go_d1, mainloop_go_d2, mainloop_go_d3, mainloop_go_d4, mainloop_go_d5, mainloop_go_d6, mainloop_go_d7, mainloop_go_d8, mainloop_go_d9, mainloop_go_d10, mainloop_go_d11, mainloop_go_d12, mainloop_go_d13};

	
	wire	 init_datahub_req = mainloop_go | mainloop_go_d6;
	
	
	// init read and initial a b  an  tweak
	
	reg						init_ab_f;
	reg		[127:0]			init_a, init_b;
	reg		[63:0]			init_tweak;
	reg		[`W_IDX:0]		init_ab_idx;

`ifdef 	EX_IMPLODE_INSTANCE_4
	always @(`CLK_RST_EDGE)
		if (`RST)	init_ab_f <= 0;
		else		init_ab_f <= go_ex0 | go_ex1 | go_ex2 | go_ex3;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			{init_a, init_b } <= 0;
		else if (go_ex0)	{init_a, init_b } <= {hash_idx[round_ex0*4 + 0][0]^hash_idx[round_ex0*4 + 0][2], hash_idx[round_ex0*4 + 0][1]^hash_idx[round_ex0*4 + 0][3]};
		else if (go_ex1)	{init_a, init_b } <= {hash_idx[round_ex1*4 + 1][0]^hash_idx[round_ex1*4 + 1][2], hash_idx[round_ex1*4 + 1][1]^hash_idx[round_ex1*4 + 1][3]};
		else if (go_ex2)	{init_a, init_b } <= {hash_idx[round_ex2*4 + 2][0]^hash_idx[round_ex2*4 + 2][2], hash_idx[round_ex2*4 + 2][1]^hash_idx[round_ex2*4 + 2][3]};
		else if (go_ex3)	{init_a, init_b } <= {hash_idx[round_ex3*4 + 3][0]^hash_idx[round_ex3*4 + 3][2], hash_idx[round_ex3*4 + 3][1]^hash_idx[round_ex3*4 + 3][3]};
	always @(`CLK_RST_EDGE)
		if (`RST)			init_ab_idx <= 0;
		else if (go_ex0)	init_ab_idx <= {round_ex0, 2'h0};
	    else if (go_ex1)    init_ab_idx <= {round_ex1, 2'h1};
	    else if (go_ex2)    init_ab_idx <= {round_ex2, 2'h2};
	    else if (go_ex3)    init_ab_idx <= {round_ex3, 2'h3};
`else
	always @(`CLK_RST_EDGE)
		if (`RST)	init_ab_f <= 0;
		else		init_ab_f <= go_ex0 | go_ex1;
	always @(`CLK_RST_EDGE)
		if (`RST)			{init_a, init_b } <= 0;
		else if (go_ex0)	{init_a, init_b } <= {hash_idx[round_ex0*2 + 0][0]^hash_idx[round_ex0*2 + 0][2], hash_idx[round_ex0*2 + 0][1]^hash_idx[round_ex0*2 + 0][3]};
		else if (go_ex1)	{init_a, init_b } <= {hash_idx[round_ex1*2 + 1][0]^hash_idx[round_ex1*2 + 1][2], hash_idx[round_ex1*2 + 1][1]^hash_idx[round_ex1*2 + 1][3]};
	always @(`CLK_RST_EDGE)
		if (`RST)			init_ab_idx <= 0;
		else if (go_ex0)	init_ab_idx <= {round_ex0, 1'h0};
	    else if (go_ex1)    init_ab_idx <= {round_ex1, 1'h1};
`endif		
	always @(*)	init_tweak	= tweak_idx[init_ab_idx];
	
	rfdp32x22 init_rbuf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_init_rbuf),
		.DB		(db_init_rbuf	),
		.AB		(ab_init_rbuf	),
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
		
	
`ifdef SIMULATING
	reg		[31:0]	mainloop_clk_cnt; 
	always @(`CLK_RST_EDGE)
		if (`RST)				mainloop_clk_cnt <= 0;
		else if (mainloop_go)	mainloop_clk_cnt <= 0;
		else					mainloop_clk_cnt <= mainloop_clk_cnt + 1;

	always @(`CLK_RST_EDGE)
		if(main_ready)   begin
			$display("==main_ready: %d", mainloop_clk_cnt);
		//	$finish;
		end		
`endif
	
	
	mainlooptest mainlooptest(
		.clk 				(clk), 		
		.rstn				(rstn),
		.go					(go_cn),
		
		.init_ab_f			(init_ab_f	),
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
	
	rfdp256x128 im_buf (
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_im_buf),
		.DB		(db_im_buf	),
		.AB		(ab_im_buf	),
		.CENA	(cena_im_buf),
		.QA		(qa_im_buf	),
	    .AA		(aa_im_buf	)
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
		
		.go_write_ex			(go_write_ex),
		
		.im_datahub_req			(im_datahub_req),
		.idx_im0				(idx_im0),
		
		.cena_init_rbuf			(cena_init_rbuf	),
		.qa_init_rbuf			(qa_init_rbuf	),
		.aa_init_rbuf			(aa_init_rbuf	),
		
		.imp_rd_addr			(imp_rd_addr),
		.ex_wr_addr				(ex_wr_addr),
		
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


	wire		[`W_DQ:0]			dq;
	wire		[`W_DQM:0]			dqm;
	wire		[`W_SDNUM:0]		cs_n;
	wire		[`W_SDNUM:0]		odt;
	wire		[`W_SDCLK:0]		sdctrl_clk;
	wire		[`W_SDCLK:0]		sdctrl_clk_n;
	wire							sdctrl_rst_n;		// for DDR3
	wire		[`W_DQS:0]			dqs;
	wire		[`W_DQS:0]			dqs_n;		
	wire		[`W_SDADDR:0]		addr;
	wire		[`W_SDBA  :0]		ba;
	wire		[`W_CKE   :0]		cke;
	wire							ras_n;
	wire							cas_n;
	wire							we_n;
	
	
	
	reg		global_reset_n;
	initial begin
		
		global_reset_n = 0;
		#1    global_reset_n = 0;
		#1000 global_reset_n = 1;
		
		//#200000 $finish;
	end
	
	reg		ddrc_clk_ref; //1066/4 = 266.5  27.5

	initial begin
		ddrc_clk_ref = 0;
		forever begin
			ddrc_clk_ref = ~ddrc_clk_ref;
`ifdef DDR4
			#(3.3/2);
`else
	`ifdef FPGA_0_STRATIX5
				#(10/2);
	`else
				#(3.75/2);
	`endif
`endif
		end
	end
		
//	wire							emif_usr_reset_n;
//	wire							emif_usr_clk;
//	wire							local_cal_success;	
`endif	
	
	extm_controller (
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
		.im_rd_idx				(idx_im0),

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

	`ifdef FPGA_0_STRATIX5
		ddrc3 controller(
			.pll_ref_clk		(ddrc_clk_ref),    
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

			
			.mem_ck				(sdctrl_clk),           
			.mem_ck_n			(sdctrl_clk_n),         
			.mem_a				(addr),            
			.mem_ba				(ba),           
			.mem_cke				(cke),          
			.mem_cs_n			(cs_n),         
			.mem_odt				(odt),          
			.mem_reset_n			(sdctrl_rst_n),      
			.mem_we_n			(we_n),         
			.mem_ras_n			(ras_n),        
			.mem_cas_n			(cas_n),        
			.mem_dqs				(dqs),          
			.mem_dqs_n			(dqs_n),        
			.mem_dq				(dq),           
			.mem_dm				(dqm),           
			.oct_rzqin			(1'b0),        	

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
			.mem_ck				(sdctrl_clk),           
			.mem_ck_n			(sdctrl_clk_n),         
			.mem_a				(addr),            
			.mem_ba				(ba),           
			.mem_cke			(cke),          
			.mem_cs_n			(cs_n),         
			.mem_odt			(odt),          
			.mem_reset_n		(sdctrl_rst_n),      
			.mem_we_n			(we_n),         
			.mem_ras_n			(ras_n),        
			.mem_cas_n			(cas_n),        
			.mem_dqs			(dqs),          
			.mem_dqs_n			(dqs_n),        
			.mem_dq				(dq),           
			.mem_dm				(dqm),           
			.oct_rzqin			(1'b0),        	
			.pll_ref_clk		(ddrc_clk_ref),      
			.local_cal_success	(local_cal_success),
			.local_cal_fail		(local_cal_fail) 
		);
		
	`endif	
		ddr3 m0 (
			.dq		(dq),
			.dqs	(dqs),
			.dqs_n	(dqs_n),
			.addr	(addr),
			.ba		(ba),
			.ck		(sdctrl_clk),
			.ck_n	(sdctrl_clk_n),
			.cke	(cke),
			.cs_n	(cs_n),
			.cas_n	(cas_n),
			.ras_n	(ras_n),
			.we_n	(we_n),
			.dm_tdqs(dqm),
			.tdqs_n	(),
			.odt	(odt),
			.rst_n	(sdctrl_rst_n));
`endif
	
	
endmodule


