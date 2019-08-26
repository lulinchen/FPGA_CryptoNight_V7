# FPGA CryptoNight V7 Minner

This is a project done in 2018, to mine Menoro using FPGA. The performance is not more profitable than GPU. And Monero updated CryptoNight algorithm to V8 which is hard to implement using hardware. So I decide to opensource this project , it can mine other coins still using CryptoNight V7. 


I modified the xmr-stak software to download data to FPGA using UART, and FPGA did the computing then send back to PC.

There are two version minners in this project with and without external DDR momery. 

The code is synthesized on KCU105,  VCU108 and Stratix V GX FPGA development board. This project is targeted in Arria 10 FPGA with multiple DDR3 chips, but we did not manufacture the custom board.

There is a lot of experimental code in this project, and I am reluctant to clean up.

## Author

LulinChen  
lulinchen@aliyun.com
