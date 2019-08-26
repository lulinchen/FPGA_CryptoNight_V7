// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`ifndef	INC_GLOBAL
`define	INC_GLOBAL

`ifdef EXTMEM_W64
	// x8 local memory width 64
	`define  x8
	`define  W_SDD  63
	`define  W_EXTMWADDR  24  // 
	
	`define W_AEXBUF 3
	`define W_AIKBUF 3

`else
	//DDR x16 local memory width 128
	`define  x16
	`define EX_IMPLODE_INSTANCE_4
	`define  W_SDD  127
	`define  W_EXTMWADDR  23  // 2Gbit
	
	`define W_AEXBUF 4
	`define W_AIKBUF 4
	
`endif

`ifdef TASK_N32
	`define W_IDX 	4
	`define TASKN   32
`elsif TASK_N16
	`define W_IDX 	3
	`define TASKN   16
`else
	`define W_IDX 	2	
	`define TASKN   8
`endif



`ifdef x16

	`define W_DQ							15
	`define W_DQM							1
	`define W_DQS							1
	`define W_SDNUM						    0 
	`define W_SDCLK						    0 
	`define W_SDBA						    2 
	`define W_CKE						    0 
	`ifdef x4Gb	
		`define W_SDADDR					    14
	`else
		`define W_SDADDR					    13 
	`endif
`else
	`define W_DQ							7
	`define W_DQM							0
	`define W_DQS							0
	`define W_SDNUM						    0 
	`define W_SDCLK						    0 
	`define W_SDBA						    2 
	`define W_CKE						    0 
	`define W_SDADDR					    13 
`endif	
	


	
`define MEM 	(2*1024*1024)  //2^21 
`define W_MEM 	127            // 2^4 bytes
`define W_AMEM 	16			  // 2^17



`define CN_TWO_INSTANCE
`define CN_THREE_INSTANCE
`define UART_BUF_4

//`define WITH_TWO_MAIN
`ifdef WITH_SIX_MAIN
	`define W_MAIN 2
	`define WITH_FOUR_MAIN
`else
	`define W_MAIN 1
`endif

`ifdef SIMULATING 
	`define BAUD_CNT_MAX 	  12     // 300/0.921600  = 325
`elsif FPGA_0_STRATIX5
	`ifdef MAIN_CLK_167MHZ
		`define BAUD_CNT_MAX 	  181     // 167/0.921600  = 217
	`elsif MAIN_CLK_100MHZ
		`define BAUD_CNT_MAX 	  108     // 100/0.921600  = 108
	`else
		`define BAUD_CNT_MAX 	  217     // 200/0.921600  = 217
	`endif
`else
	`define BAUD_CNT_MAX 	  325     // 300/0.921600  = 325
	//`define BAUD_CNT_MAX 	  135     // 125/0.921600  = 325
`endif
`ifdef SIMULATING 
	`define BAUD_CNT_MAX_RCV (`BAUD_CNT_MAX + 1)
`else
	`define BAUD_CNT_MAX_RCV (`BAUD_CNT_MAX + `BAUD_CNT_MAX/20)
`endif

`ifdef SIMULATING
	`define RST          !rstn
	`define ZST          1'b0
	`define CLK_RST_EDGE posedge clk
	`define CLK_EDGE     posedge clk
	`define RST_EDGE
	`define RESET_ACTIVE 1'b0
	`define RESET_IDLE   1'b1
`elsif FPGA_0_XILINX
	`define RST          !rstn
	`define ZST          1'b0
	`define CLK_RST_EDGE posedge clk
	`define CLK_EDGE     posedge clk
	`define RST_EDGE
	`define RESET_ACTIVE 1'b0
	`define RESET_IDLE   1'b1
`else
	`define RST          !rstn
	`define ZST          !rstn
	`define CLK_RST_EDGE posedge clk or negedge rstn
	`define CLK_EDGE     posedge clk
	`define RST_EDGE    
	`define RESET_ACTIVE 1'b0
	`define RESET_IDLE   1'b1
`endif

`endif