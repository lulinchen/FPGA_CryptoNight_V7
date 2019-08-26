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
	logic [7:0]	rx_byte = 0;
	logic 		rx_en = 0;

	clocking cb@(`CLK_EDGE);
		input update_a;
		input go_mainloop;
		output	rxd;
		output	rx_byte;
		output	rx_en;
	endclocking 
endinterface

class uart_stim;
	virtual itf 			itfu;
	reg [7:0]	start  = 8'h55;  

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
			
		//	'{
		//	128'h4aab46c7db31d49334b0b2b8a3514032,				//4b3bef71052c9dce5e7ba50d137725c1
		//	128'h7bbcc837597d025d3300aaa823e3065d,              //703760fe3a39cd6e2a4e95e16058240c
		//	128'h9c5a0537d6f143f00dc09763397025db,              //33312f4e23b09efc6b73efe179151fe6
		//	128'hec9c0d059720c532ce5dc76ffd5d6dc7,              //bc16756943ca68ffd371f95cfe09f7bd
		//	128'h15d52aaa898f2f9d5f7e6c6d52befb0e,              //fd7b2105d3f11afc7db11c528f6a3feb
		//	128'h11bf8733fd238a366a034f04a45e886b,              //db82e58fa598a48940ae9601e4ee530c
		//	128'h52189a4747cdb0edce429f70913cf31d,              //3d1df821bc79fa902df2a4097800bcf2
		//	128'h226c72ca33d3f5f9cef07fcfa4f330cb,              //9b999a90dacf82fcd2f5320f0193b54e
		//	128'h3e38168f6c208cc82bed3c25e5afa355,
		//	128'hc9bb8f44ebd7fd8ed804087716f477b8,
		//	128'hbb868de0996c16b3a115c4b78fdc28c6,
		//	128'h10674c6bb1934820c3561a6ab8b46fb7 
		//	},
			
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
			64'hdd05eb3e987ff6ef,
		//	64'h6d869a4a7b5290f9,
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
		
		
	//integer BAUD_CNT_MAX = 325;
	function new( virtual itf itfu );
		this.itfu = itfu;	
	endfunction
	
	task stimulate; 
	
	for(int t = 0; t < 6; t++)
		for(int r = 0; r < 16; r++)
		begin
			 @itfu.cb;
			 @itfu.cb;
			 @itfu.cb;
			 @itfu.cb;
			 @itfu.cb;
		`ifdef STIMULATE_USE_UART			
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
			 for(int byytcnt = 0; byytcnt < 192 ; byytcnt++) begin
				for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
					if ( bitcnt == 0)
						itfu.rxd = 0;
					else if ( bitcnt == 9)
						itfu.rxd = 1;
					else 
						itfu.rxd = hash_idx[r][byytcnt/16][(byytcnt%16)*8+ bitcnt-1];
					for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
						@itfu.cb;
				end 
			end
			
			for(int byytcnt = 0; byytcnt < 8 ; byytcnt++) begin
				for(int bitcnt = 0; bitcnt < 10 ; bitcnt++) begin
					if ( bitcnt == 0)
						itfu.rxd = 0;
					else if ( bitcnt == 9)
						itfu.rxd = 1;
					else 
						itfu.rxd = tweak_idx[r][byytcnt*8+ bitcnt-1];
					for( int baud_cnt=0 ; baud_cnt<`BAUD_CNT_MAX ; baud_cnt++ )
						@itfu.cb;
				end 
			end
		`else
				itfu.rx_byte =  8'h55;
				itfu.rx_en = 1;
				@itfu.cb;
				itfu.rx_en = 0;
				@itfu.cb;
			
			
			 for(int byytcnt = 0; byytcnt < 192 ; byytcnt++) begin
			 
					itfu.rx_byte = hash_idx[r][byytcnt/16][(byytcnt%16)*8 +: 8];
					itfu.rx_en = 1;
					@itfu.cb;
					itfu.rx_en = 0;
					@itfu.cb;
			end
			
			for(int byytcnt = 0; byytcnt < 8 ; byytcnt++) begin
			
			
					itfu.rx_byte = tweak_idx[r][byytcnt*8 +: 8];
					itfu.rx_en = 1;
					@itfu.cb;
					itfu.rx_en = 0;
					@itfu.cb;
					
			end
			
			
		`endif	
		end		
	endtask
endclass



module tb;
    parameter	S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11,S12=12,S13=13,S14=14,S15=15;
	reg		clk,rstn;
	reg		rstn_i;
	initial begin
		rstn_i = 0;
		#1    rstn_i = 0;
		#1000 rstn_i = 1;
	end



`ifdef  IDEAL_EXTMEM

	always @(*)	rstn = rstn_i;
	
	initial clk = 0; 
		always #2.5 clk=~clk;
	`ifdef WITH_TWO_MAIN
		reg		clk_main0, clk_main1;
		initial begin
			clk_main0 = 0; 
			clk_main1 = 0;
		end
	//	always #2.1 clk_main0=~clk_main0;
	//	always #2.9 clk_main1=~clk_main1;
		always #2.5 clk_main0=~clk_main0;
		always #2.5 clk_main1=~clk_main1;

		`ifdef WITH_FOUR_MAIN
			reg		clk_main2, clk_main3;
			initial begin
				clk_main2 = 0; 
				clk_main3 = 0;
			end
			always #2.5 clk_main2=~clk_main2;
			always #2.5 clk_main3=~clk_main3;
		`endif
		`ifdef WITH_SIX_MAIN
			reg		clk_main4, clk_main5;
			initial begin
				clk_main4 = 0; 
				clk_main5 = 0;
			end
			always #2.5 clk_main4=~clk_main4;
			always #2.5 clk_main5=~clk_main5;
		`endif
		
	`endif
`else

	wire	emif_usr_reset_n;
	wire	emif_usr_clk;
	wire	local_cal_success;
	
	
	
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
					#(10/2);			// 100MHz
		`else
					#(3.75/2);
		`endif
	`endif
		end
	end
		
	`ifdef WITH_TWO_MAIN
		wire	mem1_ddrc_clk_ref = ddrc_clk_ref;
	`endif
	`ifdef WITH_FOUR_MAIN
		wire	mem2_ddrc_clk_ref = ddrc_clk_ref;
		wire	mem3_ddrc_clk_ref = ddrc_clk_ref;
	`endif
	`ifdef WITH_SIX_MAIN
		wire	mem4_ddrc_clk_ref = ddrc_clk_ref;
		wire	mem5_ddrc_clk_ref = ddrc_clk_ref;
	`endif
	
	
	
	`ifdef WITH_SIX_MAIN
		reg		clk_main0, clk_main1;
		reg		clk_main2, clk_main3;
		reg		clk_main4, clk_main5;
		wire	mem1_emif_usr_clk, mem1_emif_usr_reset_n, mem1_local_cal_success;
		wire	mem2_emif_usr_clk, mem2_emif_usr_reset_n, mem2_local_cal_success;
		wire	mem3_emif_usr_clk, mem3_emif_usr_reset_n, mem3_local_cal_success;
		wire	mem4_emif_usr_clk, mem4_emif_usr_reset_n, mem4_local_cal_success;
		wire	mem5_emif_usr_clk, mem5_emif_usr_reset_n, mem5_local_cal_success;
	
		always @(*)	rstn = rstn_i & emif_usr_reset_n & local_cal_success
							& mem1_emif_usr_reset_n & mem1_local_cal_success
							& mem2_emif_usr_reset_n & mem2_local_cal_success
							& mem3_emif_usr_reset_n & mem3_local_cal_success
							& mem4_emif_usr_reset_n & mem4_local_cal_success
							& mem5_emif_usr_reset_n & mem5_local_cal_success;
		always @(*) clk = ddrc_clk_ref;					
		always @(*)	clk_main0 = emif_usr_clk;
		always @(*)	clk_main1 = mem1_emif_usr_clk;					
		always @(*)	clk_main2 = mem2_emif_usr_clk;					
		always @(*)	clk_main3 = mem3_emif_usr_clk;		
		always @(*)	clk_main4 = mem4_emif_usr_clk;					
		always @(*)	clk_main5 = mem5_emif_usr_clk;		
	`elsif WITH_FOUR_MAIN
		reg		clk_main0, clk_main1;
		reg		clk_main2, clk_main3;
		wire	mem1_emif_usr_clk, mem1_emif_usr_reset_n, mem1_local_cal_success;
		wire	mem2_emif_usr_clk, mem2_emif_usr_reset_n, mem2_local_cal_success;
		wire	mem3_emif_usr_clk, mem3_emif_usr_reset_n, mem3_local_cal_success;
		always @(*)	rstn = rstn_i & emif_usr_reset_n & local_cal_success
							& mem1_emif_usr_reset_n & mem1_local_cal_success
							& mem2_emif_usr_reset_n & mem2_local_cal_success
							& mem3_emif_usr_reset_n & mem3_local_cal_success;
		always @(*) clk = ddrc_clk_ref;					
		always @(*)	clk_main0 = emif_usr_clk;
		always @(*)	clk_main1 = mem1_emif_usr_clk;					
		always @(*)	clk_main2 = mem2_emif_usr_clk;					
		always @(*)	clk_main3 = mem3_emif_usr_clk;					
	`elsif WITH_TWO_MAIN
		reg		clk_main0, clk_main1;
		wire	mem1_emif_usr_clk;
		wire	mem1_emif_usr_reset_n;
		wire	mem1_local_cal_success;
		
		always @(*)	rstn = rstn_i & emif_usr_reset_n & local_cal_success
							& mem1_emif_usr_reset_n & mem1_local_cal_success;
		//initial clk = 0; 
		//always #2 clk=~clk;
		
		always @(*) clk = ddrc_clk_ref;
		
		always @(*)	clk_main0 = emif_usr_clk;
		always @(*)	clk_main1 = mem1_emif_usr_clk;
	`else
	
		always @(*)	rstn = rstn_i & emif_usr_reset_n & local_cal_success;
		always @(*)	clk = emif_usr_clk;
	`endif
	
	

`endif
`ifdef DUMP_FSDB
	initial begin
		$fsdbDumpfile("ecb.fsdb");
		$fsdbDumpvars(5, tb);
		//$fsdbDumpvars(3, tb);
		//$fsdbDumpvars(5, tb.aes_ecb_enc);
	end  
`endif 

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////


	initial begin
		
	//	#500000
	//	$finish;
	
		//#500000
		//$finish;
		#5000000
		#5000000
		#10000000
		$finish;
	//	#220000000
		# 1200000000
	//	//# 1000000
		$finish;
		
	end
	

	
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
				  


	wire						ready_im0;
	wire 		[127:0]	        xout0_im0;
	wire 		[127:0]	        xout1_im0;	
	wire 		[127:0]	        xout2_im0;	
	wire 		[127:0]	        xout3_im0;	
	wire 		[127:0]	        xout4_im0;	
	wire 		[127:0]	        xout5_im0;	
	wire 		[127:0]	        xout6_im0;	
	wire 		[127:0]	        xout7_im0;	
	wire						ready_im1;
	wire	 	[127:0]	        xout0_im1;
	wire	 	[127:0]	        xout1_im1;	
	wire	 	[127:0]	        xout2_im1;	
	wire	 	[127:0]	        xout3_im1;	
	wire	 	[127:0]	        xout4_im1;	
	wire	 	[127:0]	        xout5_im1;	
	wire	 	[127:0]	        xout6_im1;	
	wire	 	[127:0]	        xout7_im1;
`ifdef EX_IMPLODE_INSTANCE_4
	wire						ready_im2;
	wire 		[127:0]	        xout0_im2;
	wire 		[127:0]	        xout1_im2;	
	wire 		[127:0]	        xout2_im2;	
	wire 		[127:0]	        xout3_im2;	
	wire 		[127:0]	        xout4_im2;	
	wire 		[127:0]	        xout5_im2;	
	wire 		[127:0]	        xout6_im2;	
	wire 		[127:0]	        xout7_im2;	
	wire						ready_im3;
	wire	 	[127:0]	        xout0_im3;
	wire	 	[127:0]	        xout1_im3;	
	wire	 	[127:0]	        xout2_im3;	
	wire	 	[127:0]	        xout3_im3;	
	wire	 	[127:0]	        xout4_im3;	
	wire	 	[127:0]	        xout5_im3;	
	wire	 	[127:0]	        xout6_im3;	
	wire	 	[127:0]	        xout7_im3;

`endif
	
	wire			rxd_in;
	wire			rx_error;
	wire			rx_en;
	wire	[7:0]	rx_byte;
	
	wire					cenb_hash_buf;
	wire	[3:0]			ab_hash_buf;
	wire	[127:0]			db_hash_buf;
	reg						cena_hash_buf;
	reg		[3:0]			aa_hash_buf;
	wire	[127:0]			qa_hash_buf;
	
	reg		[`W_IDX+2:0]	hash_buf_wid;
	reg		[`W_IDX+2:0]	hash_buf_rid;
	
	
	wire					cenb_hash_buf2;
	wire	[3:0]			ab_hash_buf2;
	wire	[127:0]			db_hash_buf2;
	reg						cena_hash_buf2;
	reg		[3:0]			aa_hash_buf2;
	wire	[127:0]			qa_hash_buf2;
	
	reg		[`W_IDX+2:0]	hash_buf2_wid;
	reg		[`W_IDX+2:0]	hash_buf2_rid;
	
	
	
	reg		[7:0]			hash_buf_item;
	wire					ready_hash_buf;		
	wire					ready_hash_buf2;		
	

	
	
`define MONITOR
`ifdef MONITOR	
	itf itfu(clk);
	//assign itfu.rxd = rxd_in;
	assign rxd_in = itfu.rxd;
	
	uart_stim  stim = new (itfu);
	always @(`CLK_RST_EDGE)
		if(go_cn)
			stim.stimulate();
`endif

`ifdef STIMULATE_USE_UART	
	uart_receiver uart_receiver(
		.clk			(clk),
		.rstn			(rstn),
		.rxd			(rxd_in),
		.rx_error		(),
		.rx_byte		(rx_byte),
		.rx_en          (rx_en)
	);
`else
	assign	rx_en = itfu.rx_en;
	assign	rx_byte = itfu.rx_byte;
`endif
	
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
	
	
	//rfdp512x128 hash_buf(
	rfdp1024x128 hash_buf(
		.CLKA	(clk),
		.CLKB	(clk),
		.CENB	(cenb_hash_buf),
		.DB		(db_hash_buf	),
		.AB		({hash_buf_wid, ab_hash_buf}	),
		.CENA	(cena_hash_buf),
		.QA		(qa_hash_buf	),
	    .AA		({hash_buf_rid, aa_hash_buf}	)
		);
	
	rfdp1024x128 hash_buf2(
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
	//	if (`RST) 	hash_buf_item <= 16;
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
	reg 	[127:0]		xout0_send, xout1_send, xout2_send, xout3_send,	xout4_send, xout5_send, xout6_send, xout7_send;	

	
	
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
		
	wire			tx_en;
	wire	[7:0]	tx_byte;
	wire			tx_busy;
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
	
	int  	result_cnt;	
	always @(`CLK_RST_EDGE)
		if(ready_im0)   begin
			$display("T%dsimulation done==%d=================", $time, result_cnt++);
			$display("%032x", xout0_im0);
			$display("%032x", xout1_im0);
			$display("%032x", xout2_im0);
			$display("%032x", xout3_im0);
			$display("%032x", xout4_im0);
			$display("%032x", xout5_im0);
			$display("%032x", xout6_im0);
			$display("%032x", xout7_im0);
//`ifdef 	EX_IMPLODE_INSTANCE_4	
//			if (idx_im0 != 0)
//`else
//			if (idx_im0 == {{`W_IDX{1'b1}}, 1'b0})
//`endif
//				#2000 $finish;
		end

	always @(`CLK_RST_EDGE)
		if(ready_im1)   begin
			$display("T%dsimulation done==%d=================", $time, result_cnt++);
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
			$display("T%dsimulation done==%d=================", $time, result_cnt++);
			$display("%032x", xout0_im2);
			$display("%032x", xout1_im2);
			$display("%032x", xout2_im2);
			$display("%032x", xout3_im2);
			$display("%032x", xout4_im2);
			$display("%032x", xout5_im2);
			$display("%032x", xout6_im2);
			$display("%032x", xout7_im2);
		end

	always @(`CLK_RST_EDGE)
		if(ready_im3)   begin
			$display("T%dsimulation done==%d=================", $time, result_cnt++);
			$display("%032x", xout0_im3);
			$display("%032x", xout1_im3);
			$display("%032x", xout2_im3);
			$display("%032x", xout3_im3);
			$display("%032x", xout4_im3);
			$display("%032x", xout5_im3);
			$display("%032x", xout6_im3);
			$display("%032x", xout7_im3);
		end
`endif
	
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
	
	`ifdef WITH_TWO_MAIN
		wire	  	[`W_EXTMWADDR :0] 		extm1_a;			
		wire	  	[`W_SDD       :0]		extm1_d;			
		wire		[`W_SDD       :0]		extm1_q;	
		wire	  							extm1_ren;		
		wire	  							extm1_wen;		
		wire								extm1_af_afull;
		wire								extm1_qv;		
		wire								extm1_brst;		
		wire			[ 5:0]				extm1_brst_len;
		wire								extm1_clk;
	
	`endif
	`ifdef WITH_FOUR_MAIN
		wire	  	[`W_EXTMWADDR :0] 		extm2_a;			
		wire	  	[`W_SDD       :0]		extm2_d;			
		wire		[`W_SDD       :0]		extm2_q;	
		wire	  							extm2_ren;		
		wire	  							extm2_wen;		
		wire								extm2_af_afull;
		wire								extm2_qv;		
		wire								extm2_brst;		
		wire			[ 5:0]				extm2_brst_len;
		wire								extm2_clk;
		
		wire	  	[`W_EXTMWADDR :0] 		extm3_a;			
		wire	  	[`W_SDD       :0]		extm3_d;			
		wire		[`W_SDD       :0]		extm3_q;	
		wire	  							extm3_ren;		
		wire	  							extm3_wen;		
		wire								extm3_af_afull;
		wire								extm3_qv;		
		wire								extm3_brst;		
		wire			[ 5:0]				extm3_brst_len;
		wire								extm3_clk;
	`endif
	`ifdef WITH_SIX_MAIN
		wire	  	[`W_EXTMWADDR :0] 		extm4_a;			
		wire	  	[`W_SDD       :0]		extm4_d;			
		wire		[`W_SDD       :0]		extm4_q;	
		wire	  							extm4_ren;		
		wire	  							extm4_wen;		
		wire								extm4_af_afull;
		wire								extm4_qv;		
		wire								extm4_brst;		
		wire			[ 5:0]				extm4_brst_len;
		wire								extm4_clk;
		
		wire	  	[`W_EXTMWADDR :0] 		extm5_a;			
		wire	  	[`W_SDD       :0]		extm5_d;			
		wire		[`W_SDD       :0]		extm5_q;	
		wire	  							extm5_ren;		
		wire	  							extm5_wen;		
		wire								extm5_af_afull;
		wire								extm5_qv;		
		wire								extm5_brst;		
		wire			[ 5:0]				extm5_brst_len;
		wire								extm5_clk;
	`endif
	
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
		.xout0_im0		    (xout0_im0),
		.xout1_im0		    (xout1_im0),
		.xout2_im0		    (xout2_im0),
		.xout3_im0		    (xout3_im0),
		.xout4_im0		    (xout4_im0),
		.xout5_im0		    (xout5_im0),
		.xout6_im0		    (xout6_im0),
		.xout7_im0		    (xout7_im0),
		.ready_im1		    (ready_im1),
		.xout0_im1		    (xout0_im1),
		.xout1_im1		    (xout1_im1),
		.xout2_im1		    (xout2_im1),
		.xout3_im1		    (xout3_im1),
		.xout4_im1		    (xout4_im1),
		.xout5_im1		    (xout5_im1),
		.xout6_im1		    (xout6_im1),
		.xout7_im1		    (xout7_im1),
`ifdef EX_IMPLODE_INSTANCE_4
		.ready_im2			(ready_im2),
		.xout0_im2		    (xout0_im2),
		.xout1_im2		    (xout1_im2),
		.xout2_im2		    (xout2_im2),
		.xout3_im2		    (xout3_im2),
		.xout4_im2		    (xout4_im2),
		.xout5_im2		    (xout5_im2),
		.xout6_im2		    (xout6_im2),
		.xout7_im2		    (xout7_im2),
		.ready_im3		    (ready_im3),
		.xout0_im3		    (xout0_im3),
		.xout1_im3		    (xout1_im3),
		.xout2_im3		    (xout2_im3),
		.xout3_im3		    (xout3_im3),
		.xout4_im3		    (xout4_im3),
		.xout5_im3		    (xout5_im3),
		.xout6_im3		    (xout6_im3),
		.xout7_im3		    (xout7_im3),
`endif
		
		
		
		
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
		
	`ifdef WITH_TWO_MAIN
		,
		.extm1_a			(extm1_a			),
		.extm1_d			(extm1_d			),
		.extm1_q	        (extm1_q	),
		.extm1_ren		    (extm1_ren		),
		.extm1_wen		    (extm1_wen		),
		.extm1_af_afull     (extm1_af_afull),
		.extm1_qv		    (extm1_qv		),
		.extm1_brst		    (extm1_brst		),
		.extm1_brst_len     (extm1_brst_len),
		.extm1_clk          (extm1_clk)
	`endif
	`ifdef WITH_FOUR_MAIN
		,
		.extm2_a			(extm2_a			),
		.extm2_d			(extm2_d			),
		.extm2_q	        (extm2_q	),
		.extm2_ren		    (extm2_ren		),
		.extm2_wen		    (extm2_wen		),
		.extm2_af_afull     (extm2_af_afull),
		.extm2_qv		    (extm2_qv		),
		.extm2_brst		    (extm2_brst		),
		.extm2_brst_len     (extm2_brst_len),
		.extm2_clk          (extm2_clk)
		
		,
		.extm3_a			(extm3_a			),
		.extm3_d			(extm3_d			),
		.extm3_q	        (extm3_q	),
		.extm3_ren		    (extm3_ren		),
		.extm3_wen		    (extm3_wen		),
		.extm3_af_afull     (extm3_af_afull),
		.extm3_qv		    (extm3_qv		),
		.extm3_brst		    (extm3_brst		),
		.extm3_brst_len     (extm3_brst_len),
		.extm3_clk          (extm3_clk)
	`endif
	`ifdef WITH_SIX_MAIN
		,
		.extm4_a			(extm4_a			),
		.extm4_d			(extm4_d			),
		.extm4_q	        (extm4_q	),
		.extm4_ren		    (extm4_ren		),
		.extm4_wen		    (extm4_wen		),
		.extm4_af_afull     (extm4_af_afull),
		.extm4_qv		    (extm4_qv		),
		.extm4_brst		    (extm4_brst		),
		.extm4_brst_len     (extm4_brst_len),
		.extm4_clk          (extm4_clk)
		
		,
		.extm5_a			(extm5_a			),
		.extm5_d			(extm5_d			),
		.extm5_q	        (extm5_q	),
		.extm5_ren		    (extm5_ren		),
		.extm5_wen		    (extm5_wen		),
		.extm5_af_afull     (extm5_af_afull),
		.extm5_qv		    (extm5_qv		),
		.extm5_brst		    (extm5_brst		),
		.extm5_brst_len     (extm5_brst_len),
		.extm5_clk          (extm5_clk)
	`endif
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
		.amm2_readdatavalid       (amm2_readdatavalid      )
		
		,
		.amm3_burstbegin          (amm3_burstbegin               ),   
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
		.amm4_readdatavalid       (amm4_readdatavalid      )
		
		,
		.amm5_burstbegin          (amm5_burstbegin               ),   
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
		.clk			(extm_clk),
		.ren	        (extm_ren),
		.wen	        (extm_wen),
		.a				(extm_a),
	    .d				(extm_d),
	    .q				(extm_q),
		.qv             (extm_qv),
		.af_afull       (extm_af_afull)
	);
	
	`ifdef WITH_TWO_MAIN
		extm_sram  extm_sram1 (
		.clk			(extm1_clk),
		.ren	        (extm1_ren),
		.wen	        (extm1_wen),
		.a				(extm1_a),
	    .d				(extm1_d),
	    .q				(extm1_q),
		.qv             (extm1_qv),
		.af_afull       (extm1_af_afull)
		);	
		
	`endif	
	`ifdef WITH_FOUR_MAIN
		extm_sram  extm_sram2 (
		.clk			(extm2_clk),
		.ren	        (extm2_ren),
		.wen	        (extm2_wen),
		.a				(extm2_a),
	    .d				(extm2_d),
	    .q				(extm2_q),
		.qv             (extm2_qv),
		.af_afull       (extm2_af_afull)
		);	
		extm_sram  extm_sram3 (
		.clk			(extm3_clk),
		.ren	        (extm3_ren),
		.wen	        (extm3_wen),
		.a				(extm3_a),
	    .d				(extm3_d),
	    .q				(extm3_q),
		.qv             (extm3_qv),
		.af_afull       (extm3_af_afull)
		);	
		
	`endif	
	`ifdef WITH_SIX_MAIN
		extm_sram  extm_sram4 (
		.clk			(extm4_clk),
		.ren	        (extm4_ren),
		.wen	        (extm4_wen),
		.a				(extm4_a),
	    .d				(extm4_d),
	    .q				(extm4_q),
		.qv             (extm4_qv),
		.af_afull       (extm4_af_afull)
		);	
		extm_sram  extm_sram5 (
		.clk			(extm5_clk),
		.ren	        (extm5_ren),
		.wen	        (extm5_wen),
		.a				(extm5_a),
	    .d				(extm5_d),
	    .q				(extm5_q),
		.qv             (extm5_qv),
		.af_afull       (extm5_af_afull)
		);	
		
	`endif	
`else

	`ifdef DDRC_PINGPONG_PHY
			
				wire		[`W_DQ:0]			mem1_dq;
				wire		[`W_DQM:0]			mem1_dqm;
				wire		[`W_SDNUM:0]		mem1_cs_n;
				wire		[`W_SDNUM:0]		mem1_odt;
				wire		[`W_SDCLK:0]		mem1_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem1_sdctrl_clk_n;
				wire							mem1_sdctrl_rst_n;		// for DDR3
				wire		[`W_DQS:0]			mem1_dqs;
				wire		[`W_DQS:0]			mem1_dqs_n;		
				wire		[`W_SDADDR:0]		mem1_addr;
				wire		[`W_SDBA  :0]		mem1_ba;
				wire		[`W_CKE   :0]		mem1_cke;
				wire							mem1_ras_n;
				wire							mem1_cas_n;
				wire							mem1_we_n;
				
				assign mem1_sdctrl_clk = sdctrl_clk;
				assign mem1_sdctrl_clk_n = sdctrl_clk_n;
		`ifdef FPGA_0_STRATIX5

				assign mem1_emif_usr_clk = emif_usr_clk;
				assign mem1_emif_usr_reset_n = emif_usr_reset_n;

			ddrc3 controller(
					.pll_ref_clk		(ddrc_clk_ref),    
					.global_reset_n		(global_reset_n),
					.soft_reset_n		(global_reset_n),
					.afi_clk			(emif_usr_clk),
					.afi_reset_n		(emif_usr_reset_n), 
					
					.avl_c0_ready					(amm_ready					),	  
					.avl_c0_burstbegin	    		(amm_burstbegin				),
					.avl_c0_read_req				(amm_read					),                    
					.avl_c0_write_req				(amm_write					),                   
					.avl_c0_addr					(amm_address					),                 
					.avl_c0_rdata					(amm_readdata				),                
					.avl_c0_wdata					(amm_writedata				),               
					.avl_c0_size					(amm_burstcount				),              
					.avl_c0_be						(16'hFFFF				),              
					.avl_c0_rdata_valid				(amm_readdatavalid			),           
					.autoprecharge_req_c0_local_autopch_req				(ctrl_auto_precharge_req		),  
					
					.status_c0_local_cal_success	(local_cal_success),
					.status_c0_local_cal_fail		(local_cal_fail),
					.status_c0_local_init_done		(local_init_done),
				
				
					
					.avl_c1_ready					(amm1_ready				),	  
					.avl_c1_burstbegin	    		(amm1_burstbegin				),
					.avl_c1_read_req				(amm1_read					),                    
					.avl_c1_write_req				(amm1_write					),                   
					.avl_c1_addr					(amm1_address					),                 
					.avl_c1_rdata					(amm1_readdata				),                
					.avl_c1_wdata					(amm1_writedata				),               
					.avl_c1_size					(amm1_burstcount			),              
					.avl_c1_be						(16'hFFFF				),              
					.avl_c1_rdata_valid				(amm1_readdatavalid			),           
					.autoprecharge_req_c1_local_autopch_req				(ctrl1_auto_precharge_req		),  
					
					
					
					.mem_ck					(sdctrl_clk),           
					.mem_ck_n				(sdctrl_clk_n),         
					.mem_a					(addr),            
					.mem_ba					(ba),         
					
					.mem_cke				({mem1_cke, cke}),          
					.mem_cs_n				({mem1_cs_n, cs_n}),         
					.mem_odt				({mem1_odt, odt}),  
					
					.mem_reset_n			(sdctrl_rst_n),      
					.mem_we_n				(we_n),         
					.mem_ras_n				(ras_n),        
					.mem_cas_n				(cas_n),  
					
					.mem_dqs				({mem1_dqs, dqs}),          
					.mem_dqs_n				({mem1_dqs_n,dqs_n}),        
					.mem_dq					({mem1_dq, dq}),        
					.mem_dm					({mem1_dqm, dqm}),   
 
					
					.oct_rzqin			(1'b0)    	

				);
		
		`else
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
				.mem_ck					(sdctrl_clk),           
				.mem_ck_n				(sdctrl_clk_n),         
				.mem_a					(addr),            
				.mem_ba					(ba),         
				
				.mem_cke				({mem1_cke, cke}),          
				.mem_cs_n				({mem1_cs_n, cs_n}),         
				.mem_odt				({mem1_odt, odt}),  
				
				.mem_reset_n			(sdctrl_rst_n),      
				.mem_we_n				(we_n),         
				.mem_ras_n				(ras_n),        
				.mem_cas_n				(cas_n),  
				
				.mem_dqs				({mem1_dqs, dqs}),          
				.mem_dqs_n				({mem1_dqs_n,dqs_n}),        
				.mem_dq					({mem1_dq, dq}),        
				.mem_dm					({mem1_dqm, dqm}),   
				
				.oct_rzqin				(1'b0),        	
				.pll_ref_clk			(ddrc_clk_ref),      
				.local_cal_success		(local_cal_success),
				.local_cal_fail			(local_cal_fail) 
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
			
			ddr3 m1 (
				.dq		(mem1_dq),
				.dqs	(mem1_dqs),
				.dqs_n	(mem1_dqs_n),
				.addr	( addr),
				.ba		( ba),
				.ck		(mem1_sdctrl_clk),
				.ck_n	(mem1_sdctrl_clk_n),
				.cke	(mem1_cke),
				.cs_n	(mem1_cs_n),
				.cas_n	( cas_n),
				.ras_n	( ras_n),
				.we_n	( we_n),
				.dm_tdqs(mem1_dqm),
				.tdqs_n	(),
				.odt	(mem1_odt),
				.rst_n	(sdctrl_rst_n));
	
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
				
		`ifdef WITH_TWO_MAIN
			
				wire		[`W_DQ:0]			mem1_dq;
				wire		[`W_DQM:0]			mem1_dqm;
				wire		[`W_SDNUM:0]		mem1_cs_n;
				wire		[`W_SDNUM:0]		mem1_odt;
				wire		[`W_SDCLK:0]		mem1_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem1_sdctrl_clk_n;
				wire							mem1_sdctrl_rst_n;		// for DDR3
				wire		[`W_DQS:0]			mem1_dqs;
				wire		[`W_DQS:0]			mem1_dqs_n;		
				wire		[`W_SDADDR:0]		mem1_addr;
				wire		[`W_SDBA  :0]		mem1_ba;
				wire		[`W_CKE   :0]		mem1_cke;
				wire							mem1_ras_n;
				wire							mem1_cas_n;
				wire							mem1_we_n;
		
		
		
			`ifdef FPGA_0_STRATIX5
				ddrc3 controller1(
					.pll_ref_clk		(mem1_ddrc_clk_ref),    
					.global_reset_n		(global_reset_n),
					.soft_reset_n		(global_reset_n),
					.afi_clk			(mem1_emif_usr_clk),
					.afi_reset_n		(mem1_emif_usr_reset_n), 
					
					
					.avl_ready					(amm1_ready					),	  
				//	.avl_burstbegin	    		(amm1_burstbegin				),
					.avl_read_req				(amm1_read					),                    
					.avl_write_req				(amm1_write					),                   
					.avl_addr					(amm1_address					),                 
					.avl_rdata					(amm1_readdata				),                
					.avl_wdata					(amm1_writedata				),               
					.avl_size					(amm1_burstcount				),              
					.avl_be						(16'hFFFF					),              
					.avl_rdata_valid			(amm1_readdatavalid			),           
					.local_autopch_req			(ctrl1_auto_precharge_req		),  

					
					.mem_ck				(mem1_sdctrl_clk),           
					.mem_ck_n			(mem1_sdctrl_clk_n),         
					.mem_a				(mem1_addr),            
					.mem_ba				(mem1_ba),           
					.mem_cke			(mem1_cke),          
					.mem_cs_n			(mem1_cs_n),         
					.mem_odt			(mem1_odt),          
					.mem_reset_n		(mem1_sdctrl_rst_n),      
					.mem_we_n			(mem1_we_n),         
					.mem_ras_n			(mem1_ras_n),        
					.mem_cas_n			(mem1_cas_n),        
					.mem_dqs			(mem1_dqs),          
					.mem_dqs_n			(mem1_dqs_n),        
					.mem_dq				(mem1_dq),           
					.mem_dm				(mem1_dqm),           
					.oct_rzqin			(1'b0),        	

					.local_cal_success	(mem1_local_cal_success),
					.local_cal_fail		(mem1_local_cal_fail),
					.local_init_done	(mem1_local_init_done) 
					);
					
			`else
				ddrc3 controller1(	
					.amm_ready_0						(amm1_ready					),	                   
					.amm_read_0							(amm1_read					),                    
					.amm_write_0						(amm1_write					),                   
					.amm_address_0						(amm1_address					),                 
					.amm_readdata_0						(amm1_readdata				),                
					.amm_writedata_0					(amm1_writedata				),               
					.amm_burstcount_0					(amm1_burstcount				),              
					.amm_byteenable_0					(16'hFFFF				),              
					.amm_readdatavalid_0				(amm1_readdatavalid			),           
					.ctrl_auto_precharge_req_0			(ctrl1_auto_precharge_req		),  

				`ifdef DDR3_USER_REFRESH	
					.mmr_slave_read_0					(1'b0				),              
					.mmr_slave_write_0					(1'b0				),     

				`endif
					.emif_usr_clk		(mem1_emif_usr_clk),
					.emif_usr_reset_n	(mem1_emif_usr_reset_n),
					.global_reset_n		(global_reset_n),
					.mem_ck				(mem1_sdctrl_clk),           
					.mem_ck_n			(mem1_sdctrl_clk_n),         
					.mem_a				(mem1_addr),            
					.mem_ba				(mem1_ba),           
					.mem_cke			(mem1_cke),          
					.mem_cs_n			(mem1_cs_n),         
					.mem_odt			(mem1_odt),          
					.mem_reset_n		(mem1_sdctrl_rst_n),      
					.mem_we_n			(mem1_we_n),         
					.mem_ras_n			(mem1_ras_n),        
					.mem_cas_n			(mem1_cas_n),        
					.mem_dqs			(mem1_dqs),          
					.mem_dqs_n			(mem1_dqs_n),        
					.mem_dq				(mem1_dq),           
					.mem_dm				(mem1_dqm),           
					.oct_rzqin			(1'b0),        	
					.pll_ref_clk		(mem1_ddrc_clk_ref),      
					.local_cal_success	(mem1_local_cal_success),
					.local_cal_fail		(mem1_local_cal_fail) 
				);
				
			`endif	
				ddr3 m1 (
					.dq		(mem1_dq),
					.dqs	(mem1_dqs),
					.dqs_n	(mem1_dqs_n),
					.addr	(mem1_addr),
					.ba		(mem1_ba),
					.ck		(mem1_sdctrl_clk),
					.ck_n	(mem1_sdctrl_clk_n),
					.cke	(mem1_cke),
					.cs_n	(mem1_cs_n),
					.cas_n	(mem1_cas_n),
					.ras_n	(mem1_ras_n),
					.we_n	(mem1_we_n),
					.dm_tdqs(mem1_dqm),
					.tdqs_n	(),
					.odt	(mem1_odt),
					.rst_n	(mem1_sdctrl_rst_n));
			`ifdef WITH_FOUR_MAIN
				wire		[`W_DQ:0]			mem2_dq;
				wire		[`W_DQM:0]			mem2_dqm;
				wire		[`W_SDNUM:0]		mem2_cs_n;
				wire		[`W_SDNUM:0]		mem2_odt;
				wire		[`W_SDCLK:0]		mem2_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem2_sdctrl_clk_n;
				wire							mem2_sdctrl_rst_n;		// for DDR3
				wire		[`W_DQS:0]			mem2_dqs;
				wire		[`W_DQS:0]			mem2_dqs_n;		
				wire		[`W_SDADDR:0]		mem2_addr;
				wire		[`W_SDBA  :0]		mem2_ba;
				wire		[`W_CKE   :0]		mem2_cke;
				wire							mem2_ras_n;
				wire							mem2_cas_n;
				wire							mem2_we_n;
		
				ddrc3 controller2(	
					.amm_ready_0						(amm2_ready					),	                   
					.amm_read_0							(amm2_read					),                    
					.amm_write_0						(amm2_write					),                   
					.amm_address_0						(amm2_address					),                 
					.amm_readdata_0						(amm2_readdata				),                
					.amm_writedata_0					(amm2_writedata				),               
					.amm_burstcount_0					(amm2_burstcount				),              
					.amm_byteenable_0					(16'hFFFF				),              
					.amm_readdatavalid_0				(amm2_readdatavalid			),           
					.ctrl_auto_precharge_req_0			(ctrl2_auto_precharge_req		),  
				`ifdef DDR3_USER_REFRESH	
					.mmr_slave_read_0					(1'b0				),              
					.mmr_slave_write_0					(1'b0				),     
				`endif
					.emif_usr_clk		(mem2_emif_usr_clk),
					.emif_usr_reset_n	(mem2_emif_usr_reset_n),
					.global_reset_n		(global_reset_n),
					.mem_ck				(mem2_sdctrl_clk),           
					.mem_ck_n			(mem2_sdctrl_clk_n),         
					.mem_a				(mem2_addr),            
					.mem_ba				(mem2_ba),           
					.mem_cke			(mem2_cke),          
					.mem_cs_n			(mem2_cs_n),         
					.mem_odt			(mem2_odt),          
					.mem_reset_n		(mem2_sdctrl_rst_n),      
					.mem_we_n			(mem2_we_n),         
					.mem_ras_n			(mem2_ras_n),        
					.mem_cas_n			(mem2_cas_n),        
					.mem_dqs			(mem2_dqs),          
					.mem_dqs_n			(mem2_dqs_n),        
					.mem_dq				(mem2_dq),           
					.mem_dm				(mem2_dqm),           
					.oct_rzqin			(1'b0),        	
					.pll_ref_clk		(mem2_ddrc_clk_ref),      
					.local_cal_success	(mem2_local_cal_success),
					.local_cal_fail		(mem2_local_cal_fail) 
				);
				
				ddr3 m2(
					.dq		(mem2_dq),
					.dqs	(mem2_dqs),
					.dqs_n	(mem2_dqs_n),
					.addr	(mem2_addr),
					.ba		(mem2_ba),
					.ck		(mem2_sdctrl_clk),
					.ck_n	(mem2_sdctrl_clk_n),
					.cke	(mem2_cke),
					.cs_n	(mem2_cs_n),
					.cas_n	(mem2_cas_n),
					.ras_n	(mem2_ras_n),
					.we_n	(mem2_we_n),
					.dm_tdqs(mem2_dqm),
					.tdqs_n	(),
					.odt	(mem2_odt),
					.rst_n	(mem2_sdctrl_rst_n));
		
		
		
				wire		[`W_DQ:0]			mem3_dq;
				wire		[`W_DQM:0]			mem3_dqm;
				wire		[`W_SDNUM:0]		mem3_cs_n;
				wire		[`W_SDNUM:0]		mem3_odt;
				wire		[`W_SDCLK:0]		mem3_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem3_sdctrl_clk_n;
				wire							mem3_sdctrl_rst_n;		// for DDR3
				wire		[`W_DQS:0]			mem3_dqs;
				wire		[`W_DQS:0]			mem3_dqs_n;		
				wire		[`W_SDADDR:0]		mem3_addr;
				wire		[`W_SDBA  :0]		mem3_ba;
				wire		[`W_CKE   :0]		mem3_cke;
				wire							mem3_ras_n;
				wire							mem3_cas_n;
				wire							mem3_we_n;
		
				ddrc3 controller3(	
					.amm_ready_0						(amm3_ready					),	                   
					.amm_read_0							(amm3_read					),                    
					.amm_write_0						(amm3_write					),                   
					.amm_address_0						(amm3_address					),                 
					.amm_readdata_0						(amm3_readdata				),                
					.amm_writedata_0					(amm3_writedata				),               
					.amm_burstcount_0					(amm3_burstcount				),              
					.amm_byteenable_0					(16'hFFFF				),              
					.amm_readdatavalid_0				(amm3_readdatavalid			),           
					.ctrl_auto_precharge_req_0			(ctrl3_auto_precharge_req		),  
				`ifdef DDR3_USER_REFRESH	
					.mmr_slave_read_0					(1'b0				),              
					.mmr_slave_write_0					(1'b0				),     
				`endif
					.emif_usr_clk		(mem3_emif_usr_clk),
					.emif_usr_reset_n	(mem3_emif_usr_reset_n),
					.global_reset_n		(global_reset_n),
					.mem_ck				(mem3_sdctrl_clk),           
					.mem_ck_n			(mem3_sdctrl_clk_n),         
					.mem_a				(mem3_addr),            
					.mem_ba				(mem3_ba),           
					.mem_cke			(mem3_cke),          
					.mem_cs_n			(mem3_cs_n),         
					.mem_odt			(mem3_odt),          
					.mem_reset_n		(mem3_sdctrl_rst_n),      
					.mem_we_n			(mem3_we_n),         
					.mem_ras_n			(mem3_ras_n),        
					.mem_cas_n			(mem3_cas_n),        
					.mem_dqs			(mem3_dqs),          
					.mem_dqs_n			(mem3_dqs_n),        
					.mem_dq				(mem3_dq),           
					.mem_dm				(mem3_dqm),           
					.oct_rzqin			(1'b0),        	
					.pll_ref_clk		(mem3_ddrc_clk_ref),      
					.local_cal_success	(mem3_local_cal_success),
					.local_cal_fail		(mem3_local_cal_fail) 
				);
				
				ddr3 m3(
					.dq		(mem3_dq),
					.dqs	(mem3_dqs),
					.dqs_n	(mem3_dqs_n),
					.addr	(mem3_addr),
					.ba		(mem3_ba),
					.ck		(mem3_sdctrl_clk),
					.ck_n	(mem3_sdctrl_clk_n),
					.cke	(mem3_cke),
					.cs_n	(mem3_cs_n),
					.cas_n	(mem3_cas_n),
					.ras_n	(mem3_ras_n),
					.we_n	(mem3_we_n),
					.dm_tdqs(mem3_dqm),
					.tdqs_n	(),
					.odt	(mem3_odt),
					.rst_n	(mem3_sdctrl_rst_n));
		
		
			`endif
			
			`ifdef WITH_SIX_MAIN
				wire		[`W_DQ:0]			mem4_dq;
				wire		[`W_DQM:0]			mem4_dqm;
				wire		[`W_SDNUM:0]		mem4_cs_n;
				wire		[`W_SDNUM:0]		mem4_odt;
				wire		[`W_SDCLK:0]		mem4_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem4_sdctrl_clk_n;
				wire							mem4_sdctrl_rst_n;		// for DDR3
				wire		[`W_DQS:0]			mem4_dqs;
				wire		[`W_DQS:0]			mem4_dqs_n;		
				wire		[`W_SDADDR:0]		mem4_addr;
				wire		[`W_SDBA  :0]		mem4_ba;
				wire		[`W_CKE   :0]		mem4_cke;
				wire							mem4_ras_n;
				wire							mem4_cas_n;
				wire							mem4_we_n;
		
				ddrc3 controller4(	
					.amm_ready_0						(amm4_ready					),	                   
					.amm_read_0							(amm4_read					),                    
					.amm_write_0						(amm4_write					),                   
					.amm_address_0						(amm4_address					),                 
					.amm_readdata_0						(amm4_readdata				),                
					.amm_writedata_0					(amm4_writedata				),               
					.amm_burstcount_0					(amm4_burstcount				),              
					.amm_byteenable_0					(16'hFFFF				),              
					.amm_readdatavalid_0				(amm4_readdatavalid			),           
					.ctrl_auto_precharge_req_0			(ctrl4_auto_precharge_req		),  
				`ifdef DDR3_USER_REFRESH	
					.mmr_slave_read_0					(1'b0				),              
					.mmr_slave_write_0					(1'b0				),     
				`endif
					.emif_usr_clk		(mem4_emif_usr_clk),
					.emif_usr_reset_n	(mem4_emif_usr_reset_n),
					.global_reset_n		(global_reset_n),
					.mem_ck				(mem4_sdctrl_clk),           
					.mem_ck_n			(mem4_sdctrl_clk_n),         
					.mem_a				(mem4_addr),            
					.mem_ba				(mem4_ba),           
					.mem_cke			(mem4_cke),          
					.mem_cs_n			(mem4_cs_n),         
					.mem_odt			(mem4_odt),          
					.mem_reset_n		(mem4_sdctrl_rst_n),      
					.mem_we_n			(mem4_we_n),         
					.mem_ras_n			(mem4_ras_n),        
					.mem_cas_n			(mem4_cas_n),        
					.mem_dqs			(mem4_dqs),          
					.mem_dqs_n			(mem4_dqs_n),        
					.mem_dq				(mem4_dq),           
					.mem_dm				(mem4_dqm),           
					.oct_rzqin			(1'b0),        	
					.pll_ref_clk		(mem4_ddrc_clk_ref),      
					.local_cal_success	(mem4_local_cal_success),
					.local_cal_fail		(mem4_local_cal_fail) 
				);
				
				ddr3 m4(
					.dq		(mem4_dq),
					.dqs	(mem4_dqs),
					.dqs_n	(mem4_dqs_n),
					.addr	(mem4_addr),
					.ba		(mem4_ba),
					.ck		(mem4_sdctrl_clk),
					.ck_n	(mem4_sdctrl_clk_n),
					.cke	(mem4_cke),
					.cs_n	(mem4_cs_n),
					.cas_n	(mem4_cas_n),
					.ras_n	(mem4_ras_n),
					.we_n	(mem4_we_n),
					.dm_tdqs(mem4_dqm),
					.tdqs_n	(),
					.odt	(mem4_odt),
					.rst_n	(mem4_sdctrl_rst_n));
		
		
		
				wire		[`W_DQ:0]			mem5_dq;
				wire		[`W_DQM:0]			mem5_dqm;
				wire		[`W_SDNUM:0]		mem5_cs_n;
				wire		[`W_SDNUM:0]		mem5_odt;
				wire		[`W_SDCLK:0]		mem5_sdctrl_clk;
				wire		[`W_SDCLK:0]		mem5_sdctrl_clk_n;
				wire							mem5_sdctrl_rst_n;		// for DDR5
				wire		[`W_DQS:0]			mem5_dqs;
				wire		[`W_DQS:0]			mem5_dqs_n;		
				wire		[`W_SDADDR:0]		mem5_addr;
				wire		[`W_SDBA  :0]		mem5_ba;
				wire		[`W_CKE   :0]		mem5_cke;
				wire							mem5_ras_n;
				wire							mem5_cas_n;
				wire							mem5_we_n;
		
				ddrc3 controller5(	
					.amm_ready_0						(amm5_ready					),	                   
					.amm_read_0							(amm5_read					),                    
					.amm_write_0						(amm5_write					),                   
					.amm_address_0						(amm5_address					),                 
					.amm_readdata_0						(amm5_readdata				),                
					.amm_writedata_0					(amm5_writedata				),               
					.amm_burstcount_0					(amm5_burstcount				),              
					.amm_byteenable_0					(16'hFFFF				),              
					.amm_readdatavalid_0				(amm5_readdatavalid			),           
					.ctrl_auto_precharge_req_0			(ctrl5_auto_precharge_req		),  
				`ifdef DDR5_USER_REFRESH	
					.mmr_slave_read_0					(1'b0				),              
					.mmr_slave_write_0					(1'b0				),     
				`endif
					.emif_usr_clk		(mem5_emif_usr_clk),
					.emif_usr_reset_n	(mem5_emif_usr_reset_n),
					.global_reset_n		(global_reset_n),
					.mem_ck				(mem5_sdctrl_clk),           
					.mem_ck_n			(mem5_sdctrl_clk_n),         
					.mem_a				(mem5_addr),            
					.mem_ba				(mem5_ba),           
					.mem_cke			(mem5_cke),          
					.mem_cs_n			(mem5_cs_n),         
					.mem_odt			(mem5_odt),          
					.mem_reset_n		(mem5_sdctrl_rst_n),      
					.mem_we_n			(mem5_we_n),         
					.mem_ras_n			(mem5_ras_n),        
					.mem_cas_n			(mem5_cas_n),        
					.mem_dqs			(mem5_dqs),          
					.mem_dqs_n			(mem5_dqs_n),        
					.mem_dq				(mem5_dq),           
					.mem_dm				(mem5_dqm),           
					.oct_rzqin			(1'b0),        	
					.pll_ref_clk		(mem5_ddrc_clk_ref),      
					.local_cal_success	(mem5_local_cal_success),
					.local_cal_fail		(mem5_local_cal_fail) 
				);
				
				ddr3 m5(
					.dq		(mem5_dq),
					.dqs	(mem5_dqs),
					.dqs_n	(mem5_dqs_n),
					.addr	(mem5_addr),
					.ba		(mem5_ba),
					.ck		(mem5_sdctrl_clk),
					.ck_n	(mem5_sdctrl_clk_n),
					.cke	(mem5_cke),
					.cs_n	(mem5_cs_n),
					.cas_n	(mem5_cas_n),
					.ras_n	(mem5_ras_n),
					.we_n	(mem5_we_n),
					.dm_tdqs(mem5_dqm),
					.tdqs_n	(),
					.odt	(mem5_odt),
					.rst_n	(mem5_sdctrl_rst_n));
		
			`endif
			
		`endif
	`endif
`endif
	
	
endmodule


