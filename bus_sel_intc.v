/********************************************
该模块将相应的fd申请结果与fifo对应的申请位
相连接
Connect mode example:
Fd_0[1]-----Fifi_1[0]
general formula
Fd_x[y]-----Fifi_y[x]
********************************************/
module bus_sel_bits_interconnect(
//fifo port
//输出到bus_cross_bar 对应fifo的申请位**
fifo_0_bus_sel,//输出到bus_cross_bar 对应fifo0的申请位**
fifo_1_bus_sel,//输出到bus_cross_bar 对应fifo1的申请位**
fifo_2_bus_sel,//输出到bus_cross_bar 对应fifo2的申请位**
fifo_3_bus_sel,//输出到bus_cross_bar 对应fifo3的申请位**

//frame_decoder port
//来自fd的申请位**
fd_0_bus_sel,//来自fd0的申请位**
fd_1_bus_sel,//来自fd1的申请位**
fd_2_bus_sel,//来自fd2的申请位**
fd_3_bus_sel //来自fd3的申请位**
);

output [3:0]   fifo_0_bus_sel;
output [3:0]   fifo_1_bus_sel;
output [3:0]   fifo_2_bus_sel;
output [3:0]   fifo_3_bus_sel;
    
input  [3:0]   fd_0_bus_sel;//
input  [3:0]   fd_1_bus_sel;//
input  [3:0]   fd_2_bus_sel;//
input  [3:0]   fd_3_bus_sel;//

//Connect mode example:
//Fd_0[1]-----Fifi_1[0]
//general formula
//Fd_x[y]-----Fifi_y[x]
assign fifo_0_bus_sel[0]=fd_0_bus_sel[0];
assign fifo_0_bus_sel[1]=fd_1_bus_sel[0];
assign fifo_0_bus_sel[2]=fd_2_bus_sel[0];
assign fifo_0_bus_sel[3]=fd_3_bus_sel[0];
                                        
assign fifo_1_bus_sel[0]=fd_0_bus_sel[1];
assign fifo_1_bus_sel[1]=fd_1_bus_sel[1];
assign fifo_1_bus_sel[2]=fd_2_bus_sel[1];
assign fifo_1_bus_sel[3]=fd_3_bus_sel[1];
                                        
assign fifo_2_bus_sel[0]=fd_0_bus_sel[2];
assign fifo_2_bus_sel[1]=fd_1_bus_sel[2];
assign fifo_2_bus_sel[2]=fd_2_bus_sel[2];
assign fifo_2_bus_sel[3]=fd_3_bus_sel[2];
                                        
assign fifo_3_bus_sel[0]=fd_0_bus_sel[3];
assign fifo_3_bus_sel[1]=fd_1_bus_sel[3];
assign fifo_3_bus_sel[2]=fd_2_bus_sel[3];
assign fifo_3_bus_sel[3]=fd_3_bus_sel[3];

endmodule