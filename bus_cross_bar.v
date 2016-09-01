//this module is used for switch axis buses from write logic
//and  fifo logic   
/***************************************************
该模块用于切换总线，在逻辑上可以理解为一个总线数据选择器
****************************************************/
module bus_cross_bar(
glb_clk,
glb_areset_n,
//port 0
//fifo endian port
//--0--              ,
fifo_m_axis_0_tvalid ,
fifo_m_axis_0_tready ,
fifo_m_axis_0_tdata  ,
fifo_m_axis_0_tkeep  ,
fifo_m_axis_0_tlast  ,
//--1--              ,
fifo_m_axis_1_tvalid ,
fifo_m_axis_1_tready ,
fifo_m_axis_1_tdata  ,
fifo_m_axis_1_tkeep  ,
fifo_m_axis_1_tlast  ,
//--2--              ,
fifo_m_axis_2_tvalid ,
fifo_m_axis_2_tready ,
fifo_m_axis_2_tdata  ,
fifo_m_axis_2_tkeep  ,
fifo_m_axis_2_tlast  ,
//--3--              ,
fifo_m_axis_3_tvalid ,
fifo_m_axis_3_tready ,
fifo_m_axis_3_tdata  ,
fifo_m_axis_3_tkeep  ,
fifo_m_axis_3_tlast  ,

//rxd endian port
//--0--
rx_s_axis_0_tvalid ,
rx_s_axis_0_tready ,
rx_s_axis_0_tdata  ,
rx_s_axis_0_tkeep  ,
rx_s_axis_0_tlast  ,
//--1--            ,
rx_s_axis_1_tvalid ,
rx_s_axis_1_tready ,
rx_s_axis_1_tdata  ,
rx_s_axis_1_tkeep  ,
rx_s_axis_1_tlast  ,
//--2--            ,
rx_s_axis_2_tvalid ,
rx_s_axis_2_tready ,
rx_s_axis_2_tdata  ,
rx_s_axis_2_tkeep  ,
rx_s_axis_2_tlast  ,
//--3--            ,
rx_s_axis_3_tvalid ,
rx_s_axis_3_tready ,
rx_s_axis_3_tdata  ,
rx_s_axis_3_tkeep  ,
rx_s_axis_3_tlast  ,


//--0--
fifo_sel_bits_0      ,
//--1--      _0      ,
fifo_sel_bits_1      ,
//--2--      _0      ,
fifo_sel_bits_2      ,
//--3--      _0      ,
fifo_sel_bits_3      
);

input           glb_clk     ;
input           glb_areset_n;
//port 0
//fifo endian port
//--0--
output          fifo_m_axis_0_tvalid ;
input           fifo_m_axis_0_tready ;
output   [31:0] fifo_m_axis_0_tdata  ;
output   [3:0]  fifo_m_axis_0_tkeep  ;
output          fifo_m_axis_0_tlast  ;
//--1--
output          fifo_m_axis_1_tvalid ;
input           fifo_m_axis_1_tready ;
output   [31:0] fifo_m_axis_1_tdata  ;
output   [3:0]  fifo_m_axis_1_tkeep  ;
output          fifo_m_axis_1_tlast  ;
//--2--
output          fifo_m_axis_2_tvalid ;
input           fifo_m_axis_2_tready ;
output   [31:0] fifo_m_axis_2_tdata  ;
output   [3:0]  fifo_m_axis_2_tkeep  ;
output          fifo_m_axis_2_tlast  ;
//--3--
output          fifo_m_axis_3_tvalid ;
input           fifo_m_axis_3_tready ;
output   [31:0] fifo_m_axis_3_tdata  ;
output   [3:0]  fifo_m_axis_3_tkeep  ;
output          fifo_m_axis_3_tlast  ;

//rxd endian port
//--0-- 
input           rx_s_axis_0_tvalid ;
output          rx_s_axis_0_tready ;
input   [31:0]  rx_s_axis_0_tdata  ;
input   [3:0]   rx_s_axis_0_tkeep  ;
input           rx_s_axis_0_tlast  ;
//--1-- 
input           rx_s_axis_1_tvalid ;
output          rx_s_axis_1_tready ;
input   [31:0]  rx_s_axis_1_tdata  ;
input   [3:0]   rx_s_axis_1_tkeep  ;
input           rx_s_axis_1_tlast  ;
//--2-- 
input           rx_s_axis_2_tvalid ;
output          rx_s_axis_2_tready ;
input   [31:0]  rx_s_axis_2_tdata  ;
input   [3:0]   rx_s_axis_2_tkeep  ;
input           rx_s_axis_2_tlast  ;
//--3-- 
input           rx_s_axis_3_tvalid ;
output          rx_s_axis_3_tready ;
input   [31:0]  rx_s_axis_3_tdata  ;
input   [3:0]   rx_s_axis_3_tkeep  ;
input           rx_s_axis_3_tlast  ;

//申请使用fifo的控制位 隶属于fifo  aaa
//--0--
input   [3:0]   fifo_sel_bits_0      ;
//--1--
input   [3:0]   fifo_sel_bits_1      ;
//--2--
input   [3:0]   fifo_sel_bits_2      ;
//--3--
input   [3:0]   fifo_sel_bits_3      ;

//分配的tready信号 隶属于fifo aaa
wire [3:0] fifo_0_tready_2rx;//该组的四个信号相或后连接到fifo0的tready上**
wire [3:0] fifo_1_tready_2rx;//该组的四个信号相或后连接到fifo1的tready上**
wire [3:0] fifo_2_tready_2rx;//该组的四个信号相或后连接到fifo2的tready上**
wire [3:0] fifo_3_tready_2rx;//该组的四个信号相或后连接到fifo3的tready上**

//控制fifo axis-bus导向的信号 隶属于fifo aaa
wire [3:0] bus_sel_2fifo_0;
wire [3:0] bus_sel_2fifo_1;
wire [3:0] bus_sel_2fifo_2;
wire [3:0] bus_sel_2fifo_3;

//fifo 导向信号产生器实例化 隶属于fifo aaa
fifo_sel_cal CAL_0(
.glb_clk            (glb_clk     ),
.glb_areset_n       (glb_areset_n),
.fifo_sel_bits      (fifo_sel_bits_0),
.fifo_sel_res_final (bus_sel_2fifo_0)
);

fifo_sel_cal  CAL_1(
.glb_clk            (glb_clk     ),
.glb_areset_n       (glb_areset_n),
.fifo_sel_bits      (fifo_sel_bits_1),
.fifo_sel_res_final (bus_sel_2fifo_1)
);

fifo_sel_cal CAL_2(
.glb_clk            (glb_clk     ),
.glb_areset_n       (glb_areset_n),
.fifo_sel_bits      (fifo_sel_bits_2),
.fifo_sel_res_final (bus_sel_2fifo_2)
);

fifo_sel_cal CAL_3(
.glb_clk            (glb_clk     ),
.glb_areset_n       (glb_areset_n),
.fifo_sel_bits      (fifo_sel_bits_3),
.fifo_sel_res_final (bus_sel_2fifo_3)
);

//fifo tready 信号分配器 隶属于fifo aaa
axis_bus_1_4_demux DEMUX_0(
.bus_sel            (bus_sel_2fifo_0),
.axis_out_0_tready  (fifo_0_tready_2rx[0]),
.axis_out_1_tready  (fifo_0_tready_2rx[1]),
.axis_out_2_tready  (fifo_0_tready_2rx[2]),
.axis_out_3_tready  (fifo_0_tready_2rx[3]),
.axis_in_tready     (fifo_m_axis_0_tready)
);

axis_bus_1_4_demux DEMUX_1(
.bus_sel            (bus_sel_2fifo_1),
.axis_out_0_tready  (fifo_1_tready_2rx[0]),
.axis_out_1_tready  (fifo_1_tready_2rx[1]),
.axis_out_2_tready  (fifo_1_tready_2rx[2]),
.axis_out_3_tready  (fifo_1_tready_2rx[3]),
.axis_in_tready     (fifo_m_axis_1_tready)
);

axis_bus_1_4_demux DEMUX_2(
.bus_sel            (bus_sel_2fifo_2),
.axis_out_0_tready  (fifo_2_tready_2rx[0]),
.axis_out_1_tready  (fifo_2_tready_2rx[1]),
.axis_out_2_tready  (fifo_2_tready_2rx[2]),
.axis_out_3_tready  (fifo_2_tready_2rx[3]),
.axis_in_tready     (fifo_m_axis_2_tready)
);

axis_bus_1_4_demux DEMUX_3(
.bus_sel            (bus_sel_2fifo_3),
.axis_out_0_tready  (fifo_3_tready_2rx[0]),
.axis_out_1_tready  (fifo_3_tready_2rx[1]),
.axis_out_2_tready  (fifo_3_tready_2rx[2]),
.axis_out_3_tready  (fifo_3_tready_2rx[3]),
.axis_in_tready     (fifo_m_axis_3_tready)
);


//fifo axis_bus 信号选择器 隶属于fifo aaa
axis_bus_4_1_mux MUX_0(
.bus_sel          (bus_sel_2fifo_0),
//                ()
.axis_in_0_tvalid (rx_s_axis_0_tvalid),
.axis_in_0_tdata  (rx_s_axis_0_tdata ),
.axis_in_0_tkeep  (rx_s_axis_0_tkeep ),
.axis_in_0_tlast  (rx_s_axis_0_tlast ),
//                 
.axis_in_1_tvalid (rx_s_axis_1_tvalid),
.axis_in_1_tdata  (rx_s_axis_1_tdata ),
.axis_in_1_tkeep  (rx_s_axis_1_tkeep ),
.axis_in_1_tlast  (rx_s_axis_1_tlast ),
//                ()
.axis_in_2_tvalid (rx_s_axis_2_tvalid),
.axis_in_2_tdata  (rx_s_axis_2_tdata ),
.axis_in_2_tkeep  (rx_s_axis_2_tkeep ),
.axis_in_2_tlast  (rx_s_axis_2_tlast ),
//                ()
.axis_in_3_tvalid (rx_s_axis_3_tvalid),
.axis_in_3_tdata  (rx_s_axis_3_tdata ),
.axis_in_3_tkeep  (rx_s_axis_3_tkeep ),
.axis_in_3_tlast  (rx_s_axis_3_tlast ),
//                ()
.axis_out_tvalid  (fifo_m_axis_0_tvalid),
.axis_out_tdata   (fifo_m_axis_0_tdata ),
.axis_out_tkeep   (fifo_m_axis_0_tkeep ),
.axis_out_tlast   (fifo_m_axis_0_tlast )
);

axis_bus_4_1_mux MUX_1(
.bus_sel          (bus_sel_2fifo_1),
//                ()
.axis_in_0_tvalid (rx_s_axis_0_tvalid),
.axis_in_0_tdata  (rx_s_axis_0_tdata ),
.axis_in_0_tkeep  (rx_s_axis_0_tkeep ),
.axis_in_0_tlast  (rx_s_axis_0_tlast ),
//                 
.axis_in_1_tvalid (rx_s_axis_1_tvalid),
.axis_in_1_tdata  (rx_s_axis_1_tdata ),
.axis_in_1_tkeep  (rx_s_axis_1_tkeep ),
.axis_in_1_tlast  (rx_s_axis_1_tlast ),
//                ()
.axis_in_2_tvalid (rx_s_axis_2_tvalid),
.axis_in_2_tdata  (rx_s_axis_2_tdata ),
.axis_in_2_tkeep  (rx_s_axis_2_tkeep ),
.axis_in_2_tlast  (rx_s_axis_2_tlast ),
//                ()
.axis_in_3_tvalid (rx_s_axis_3_tvalid),
.axis_in_3_tdata  (rx_s_axis_3_tdata ),
.axis_in_3_tkeep  (rx_s_axis_3_tkeep ),
.axis_in_3_tlast  (rx_s_axis_3_tlast ),
//                ()
.axis_out_tvalid  (fifo_m_axis_1_tvalid),
.axis_out_tdata   (fifo_m_axis_1_tdata ),
.axis_out_tkeep   (fifo_m_axis_1_tkeep ),
.axis_out_tlast   (fifo_m_axis_1_tlast )
);

axis_bus_4_1_mux MUX_2(
.bus_sel          (bus_sel_2fifo_2),
//                ()
.axis_in_0_tvalid (rx_s_axis_0_tvalid),
.axis_in_0_tdata  (rx_s_axis_0_tdata ),
.axis_in_0_tkeep  (rx_s_axis_0_tkeep ),
.axis_in_0_tlast  (rx_s_axis_0_tlast ),
//                 
.axis_in_1_tvalid (rx_s_axis_1_tvalid),
.axis_in_1_tdata  (rx_s_axis_1_tdata ),
.axis_in_1_tkeep  (rx_s_axis_1_tkeep ),
.axis_in_1_tlast  (rx_s_axis_1_tlast ),
//                ()
.axis_in_2_tvalid (rx_s_axis_2_tvalid),
.axis_in_2_tdata  (rx_s_axis_2_tdata ),
.axis_in_2_tkeep  (rx_s_axis_2_tkeep ),
.axis_in_2_tlast  (rx_s_axis_2_tlast ),
//                ()
.axis_in_3_tvalid (rx_s_axis_3_tvalid),
.axis_in_3_tdata  (rx_s_axis_3_tdata ),
.axis_in_3_tkeep  (rx_s_axis_3_tkeep ),
.axis_in_3_tlast  (rx_s_axis_3_tlast ),
//                ()
.axis_out_tvalid  (fifo_m_axis_2_tvalid),
.axis_out_tdata   (fifo_m_axis_2_tdata ),
.axis_out_tkeep   (fifo_m_axis_2_tkeep ),
.axis_out_tlast   (fifo_m_axis_2_tlast )
);

axis_bus_4_1_mux MUX_3(
.bus_sel          (bus_sel_2fifo_3),
//                ()
.axis_in_0_tvalid (rx_s_axis_0_tvalid),
.axis_in_0_tdata  (rx_s_axis_0_tdata ),
.axis_in_0_tkeep  (rx_s_axis_0_tkeep ),
.axis_in_0_tlast  (rx_s_axis_0_tlast ),
//                 
.axis_in_1_tvalid (rx_s_axis_1_tvalid),
.axis_in_1_tdata  (rx_s_axis_1_tdata ),
.axis_in_1_tkeep  (rx_s_axis_1_tkeep ),
.axis_in_1_tlast  (rx_s_axis_1_tlast ),
//                ()
.axis_in_2_tvalid (rx_s_axis_2_tvalid),
.axis_in_2_tdata  (rx_s_axis_2_tdata ),
.axis_in_2_tkeep  (rx_s_axis_2_tkeep ),
.axis_in_2_tlast  (rx_s_axis_2_tlast ),
//                ()
.axis_in_3_tvalid (rx_s_axis_3_tvalid),
.axis_in_3_tdata  (rx_s_axis_3_tdata ),
.axis_in_3_tkeep  (rx_s_axis_3_tkeep ),
.axis_in_3_tlast  (rx_s_axis_3_tlast ),
//                ()
.axis_out_tvalid  (fifo_m_axis_3_tvalid),
.axis_out_tdata   (fifo_m_axis_3_tdata ),
.axis_out_tkeep   (fifo_m_axis_3_tkeep ),
.axis_out_tlast   (fifo_m_axis_3_tlast )
);

//该组的四个信号相或的逻辑 相或后连接到fifo1的tready上
assign rx_s_axis_0_tready=  fifo_0_tready_2rx[0]|fifo_1_tready_2rx[0]|
                            fifo_2_tready_2rx[0]|fifo_3_tready_2rx[0];
assign rx_s_axis_1_tready=  fifo_0_tready_2rx[1]|fifo_1_tready_2rx[1]|
                            fifo_2_tready_2rx[1]|fifo_3_tready_2rx[1];
assign rx_s_axis_2_tready=  fifo_0_tready_2rx[2]|fifo_1_tready_2rx[2]|
                            fifo_2_tready_2rx[2]|fifo_3_tready_2rx[2];
assign rx_s_axis_3_tready=  fifo_0_tready_2rx[3]|fifo_1_tready_2rx[3]|
                            fifo_2_tready_2rx[3]|fifo_3_tready_2rx[3];                            
endmodule











