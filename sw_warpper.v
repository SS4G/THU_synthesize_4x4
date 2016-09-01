/******************************************
交换机的主核心模块，是交换机除了输出fifo**
以外的的部分                             **
                                         **
*******************************************/
module sw_warpper(
glb_clk,
glb_areset_n,

//rxd_axis_port
rxd_s_axis_0_tvalid,
rxd_s_axis_0_tready,
rxd_s_axis_0_tdata ,
rxd_s_axis_0_tkeep ,
rxd_s_axis_0_tlast ,

//rxd_axis_port
rxd_s_axis_1_tvalid,
rxd_s_axis_1_tready,
rxd_s_axis_1_tdata ,
rxd_s_axis_1_tkeep ,
rxd_s_axis_1_tlast ,

//rxd_axis_port
rxd_s_axis_2_tvalid,
rxd_s_axis_2_tready,
rxd_s_axis_2_tdata ,
rxd_s_axis_2_tkeep ,
rxd_s_axis_2_tlast ,

//rxd_axis_port
rxd_s_axis_3_tvalid,
rxd_s_axis_3_tready,
rxd_s_axis_3_tdata ,
rxd_s_axis_3_tkeep ,
rxd_s_axis_3_tlast ,

//txd_fifo_axis_port
txd_m_axis_0_tvalid,
txd_m_axis_0_tready,
txd_m_axis_0_tdata ,
txd_m_axis_0_tkeep ,
txd_m_axis_0_tlast ,


//txd_fifo_axis_port
txd_m_axis_1_tvalid,
txd_m_axis_1_tready,
txd_m_axis_1_tdata ,
txd_m_axis_1_tkeep ,
txd_m_axis_1_tlast ,


//txd_fifo_axis_port
txd_m_axis_2_tvalid,
txd_m_axis_2_tready,
txd_m_axis_2_tdata ,
txd_m_axis_2_tkeep ,
txd_m_axis_2_tlast ,

//txd_fifo_axis_port
txd_m_axis_3_tvalid,
txd_m_axis_3_tready,
txd_m_axis_3_tdata ,
txd_m_axis_3_tkeep ,
txd_m_axis_3_tlast ,

fifo_0_space_used ,
fifo_1_space_used ,
fifo_2_space_used ,
fifo_3_space_used 
);
input           glb_clk     ;
input           glb_areset_n;
//来自Eth-IP的接收数据总线 ***

                //rxd_axis_port
input           rxd_s_axis_0_tvalid;
output          rxd_s_axis_0_tready;
input   [31:0]  rxd_s_axis_0_tdata ;
input   [3:0]   rxd_s_axis_0_tkeep ;
input           rxd_s_axis_0_tlast ;

                //rxd_axis_port
input           rxd_s_axis_1_tvalid;
output          rxd_s_axis_1_tready;
input   [31:0]  rxd_s_axis_1_tdata ;
input   [3:0]   rxd_s_axis_1_tkeep ;
input           rxd_s_axis_1_tlast ;

                //rxd_axis_port
input           rxd_s_axis_2_tvalid;
output          rxd_s_axis_2_tready;
input   [31:0]  rxd_s_axis_2_tdata ;
input   [3:0]   rxd_s_axis_2_tkeep ;
input           rxd_s_axis_2_tlast ;

                //rxd_axis_port
input           rxd_s_axis_3_tvalid;
output          rxd_s_axis_3_tready;
input   [31:0]  rxd_s_axis_3_tdata ;
input   [3:0]   rxd_s_axis_3_tkeep ;
input           rxd_s_axis_3_tlast ;

//向输出端fifo发送的数据总线 ***
                //txd_fifo_axis_port
output          txd_m_axis_0_tvalid;
input           txd_m_axis_0_tready;
output  [31:0]  txd_m_axis_0_tdata ;
output  [3:0]   txd_m_axis_0_tkeep ;
output          txd_m_axis_0_tlast ;



                //txd_fifo_axis_port
output          txd_m_axis_1_tvalid;
input           txd_m_axis_1_tready;
output  [31:0]  txd_m_axis_1_tdata ;
output  [3:0]   txd_m_axis_1_tkeep ;
output          txd_m_axis_1_tlast ;



                //txd_fifo_axis_port
output          txd_m_axis_2_tvalid;
input           txd_m_axis_2_tready;
output  [31:0]  txd_m_axis_2_tdata ;
output  [3:0]   txd_m_axis_2_tkeep ;
output          txd_m_axis_2_tlast ;



                //txd_fifo_axis_port
output          txd_m_axis_3_tvalid;
input           txd_m_axis_3_tready;
output  [31:0]  txd_m_axis_3_tdata ;
output  [3:0]   txd_m_axis_3_tkeep ;
output          txd_m_axis_3_tlast ;

//输出端fifo 已被使用的空间数 （空间数为4Byte）**
input   [31:0]  fifo_0_space_used;
input   [31:0]  fifo_1_space_used;
input   [31:0]  fifo_2_space_used;
input   [31:0]  fifo_3_space_used;

//内部信号定义 aaa
//连接frame_decoder 和 cross_bar 的连线 aaa
wire            fd_bar_axis_0_tvalid;
wire            fd_bar_axis_0_tready;
wire    [31:0]  fd_bar_axis_0_tdata ;
wire    [3:0]   fd_bar_axis_0_tkeep ;
wire            fd_bar_axis_0_tlast ;

wire            fd_bar_axis_1_tvalid;
wire            fd_bar_axis_1_tready;
wire    [31:0]  fd_bar_axis_1_tdata ;
wire    [3:0]   fd_bar_axis_1_tkeep ;
wire            fd_bar_axis_1_tlast ;

wire            fd_bar_axis_2_tvalid;
wire            fd_bar_axis_2_tready;
wire    [31:0]  fd_bar_axis_2_tdata ;
wire    [3:0]   fd_bar_axis_2_tkeep ;
wire            fd_bar_axis_2_tlast ;

wire            fd_bar_axis_3_tvalid;
wire            fd_bar_axis_3_tready;
wire    [31:0]  fd_bar_axis_3_tdata ;
wire    [3:0]   fd_bar_axis_3_tkeep ;
wire            fd_bar_axis_3_tlast ;

//从 fd中引出的 总线选择位信号 连接到***
//bus_sel_bits_interconnect***
wire    [3:0]   bus_sel_from_0_fd   ;
wire    [3:0]   bus_sel_from_1_fd   ;
wire    [3:0]   bus_sel_from_2_fd   ;
wire    [3:0]   bus_sel_from_3_fd   ;
//
wire    [3:0]   bus_sel_to_0_fifo   ;
wire    [3:0]   bus_sel_to_1_fifo   ;
wire    [3:0]   bus_sel_to_2_fifo   ;
wire    [3:0]   bus_sel_to_3_fifo   ;

//下一层模块实例化***
bus_cross_bar BCB(
.glb_clk     (glb_clk     ),
.glb_areset_n(glb_areset_n),

//port 0
//fifo endian port
//--0--             
.fifo_m_axis_0_tvalid (txd_m_axis_0_tvalid),
.fifo_m_axis_0_tready (txd_m_axis_0_tready),
.fifo_m_axis_0_tdata  (txd_m_axis_0_tdata ),
.fifo_m_axis_0_tkeep  (txd_m_axis_0_tkeep ),
.fifo_m_axis_0_tlast  (txd_m_axis_0_tlast ),
//--1--               ()
.fifo_m_axis_1_tvalid (txd_m_axis_1_tvalid),
.fifo_m_axis_1_tready (txd_m_axis_1_tready),
.fifo_m_axis_1_tdata  (txd_m_axis_1_tdata ),
.fifo_m_axis_1_tkeep  (txd_m_axis_1_tkeep ),
.fifo_m_axis_1_tlast  (txd_m_axis_1_tlast ),
//--2--               ()
.fifo_m_axis_2_tvalid (txd_m_axis_2_tvalid),
.fifo_m_axis_2_tready (txd_m_axis_2_tready),
.fifo_m_axis_2_tdata  (txd_m_axis_2_tdata ),
.fifo_m_axis_2_tkeep  (txd_m_axis_2_tkeep ),
.fifo_m_axis_2_tlast  (txd_m_axis_2_tlast ),
//--3--               ()
.fifo_m_axis_3_tvalid (txd_m_axis_3_tvalid),
.fifo_m_axis_3_tready (txd_m_axis_3_tready),
.fifo_m_axis_3_tdata  (txd_m_axis_3_tdata ),
.fifo_m_axis_3_tkeep  (txd_m_axis_3_tkeep ),
.fifo_m_axis_3_tlast  (txd_m_axis_3_tlast ),

//rxd endian port
//--0--
.rx_s_axis_0_tvalid (fd_bar_axis_0_tvalid),
.rx_s_axis_0_tready (fd_bar_axis_0_tready),
.rx_s_axis_0_tdata  (fd_bar_axis_0_tdata ),
.rx_s_axis_0_tkeep  (fd_bar_axis_0_tkeep ),
.rx_s_axis_0_tlast  (fd_bar_axis_0_tlast ),
//--1--             ()
.rx_s_axis_1_tvalid (fd_bar_axis_1_tvalid),
.rx_s_axis_1_tready (fd_bar_axis_1_tready),
.rx_s_axis_1_tdata  (fd_bar_axis_1_tdata ),
.rx_s_axis_1_tkeep  (fd_bar_axis_1_tkeep ),
.rx_s_axis_1_tlast  (fd_bar_axis_1_tlast ),
//--2--             ()
.rx_s_axis_2_tvalid (fd_bar_axis_2_tvalid),
.rx_s_axis_2_tready (fd_bar_axis_2_tready),
.rx_s_axis_2_tdata  (fd_bar_axis_2_tdata ),
.rx_s_axis_2_tkeep  (fd_bar_axis_2_tkeep ),
.rx_s_axis_2_tlast  (fd_bar_axis_2_tlast ),
//--3--            ,()
.rx_s_axis_3_tvalid (fd_bar_axis_3_tvalid),
.rx_s_axis_3_tready (fd_bar_axis_3_tready),
.rx_s_axis_3_tdata  (fd_bar_axis_3_tdata ),
.rx_s_axis_3_tkeep  (fd_bar_axis_3_tkeep ),
.rx_s_axis_3_tlast  (fd_bar_axis_3_tlast ),


.fifo_sel_bits_0     (bus_sel_to_0_fifo),
.fifo_sel_bits_1     (bus_sel_to_1_fifo),
.fifo_sel_bits_2     (bus_sel_to_2_fifo),
.fifo_sel_bits_3     (bus_sel_to_3_fifo)
);

frame_decoder FD0( 
.glb_clk     (glb_clk     ),
.glb_areset_n(glb_areset_n),

.fd_s_axis_tvalid ( rxd_s_axis_0_tvalid),
.fd_s_axis_tready ( rxd_s_axis_0_tready),
.fd_s_axis_tdata  ( rxd_s_axis_0_tdata ),
.fd_s_axis_tkeep  ( rxd_s_axis_0_tkeep ),
.fd_s_axis_tlast  ( rxd_s_axis_0_tlast ),
//                  ()
.fd_m_axis_tvalid (fd_bar_axis_0_tvalid),
.fd_m_axis_tready (fd_bar_axis_0_tready),
.fd_m_axis_tdata  (fd_bar_axis_0_tdata ),
.fd_m_axis_tkeep  (fd_bar_axis_0_tkeep ),
.fd_m_axis_tlast  (fd_bar_axis_0_tlast ),
 //                 ()
.fd_bus_sel_bits  (bus_sel_from_0_fd),
 //                 ()
.fifo_0_space_used (fifo_0_space_used), 
.fifo_1_space_used (fifo_1_space_used),
.fifo_2_space_used (fifo_2_space_used),
.fifo_3_space_used (fifo_3_space_used)
);

frame_decoder FD1( 
.glb_clk     (glb_clk     ),
.glb_areset_n(glb_areset_n),

.fd_s_axis_tvalid ( rxd_s_axis_1_tvalid),
.fd_s_axis_tready ( rxd_s_axis_1_tready),
.fd_s_axis_tdata  ( rxd_s_axis_1_tdata ),
.fd_s_axis_tkeep  ( rxd_s_axis_1_tkeep ),
.fd_s_axis_tlast  ( rxd_s_axis_1_tlast ),
//                  ()
.fd_m_axis_tvalid (fd_bar_axis_1_tvalid),
.fd_m_axis_tready (fd_bar_axis_1_tready),
.fd_m_axis_tdata  (fd_bar_axis_1_tdata ),
.fd_m_axis_tkeep  (fd_bar_axis_1_tkeep ),
.fd_m_axis_tlast  (fd_bar_axis_1_tlast ),
 //                 ()
.fd_bus_sel_bits  (bus_sel_from_1_fd),
 //                 ()
.fifo_0_space_used (fifo_0_space_used), 
.fifo_1_space_used (fifo_1_space_used),
.fifo_2_space_used (fifo_2_space_used),
.fifo_3_space_used (fifo_3_space_used)
);

frame_decoder FD2( 
.glb_clk     (glb_clk     ),
.glb_areset_n(glb_areset_n),

.fd_s_axis_tvalid ( rxd_s_axis_2_tvalid),
.fd_s_axis_tready ( rxd_s_axis_2_tready),
.fd_s_axis_tdata  ( rxd_s_axis_2_tdata ),
.fd_s_axis_tkeep  ( rxd_s_axis_2_tkeep ),
.fd_s_axis_tlast  ( rxd_s_axis_2_tlast ),
//                  ()
.fd_m_axis_tvalid (fd_bar_axis_2_tvalid),
.fd_m_axis_tready (fd_bar_axis_2_tready),
.fd_m_axis_tdata  (fd_bar_axis_2_tdata ),
.fd_m_axis_tkeep  (fd_bar_axis_2_tkeep ),
.fd_m_axis_tlast  (fd_bar_axis_2_tlast ),
 //                 ()
.fd_bus_sel_bits  (bus_sel_from_2_fd),
 //                 ()
.fifo_0_space_used (fifo_0_space_used), 
.fifo_1_space_used (fifo_1_space_used),
.fifo_2_space_used (fifo_2_space_used),
.fifo_3_space_used (fifo_3_space_used)
);

frame_decoder FD3( 
.glb_clk     (glb_clk     ),
.glb_areset_n(glb_areset_n),

.fd_s_axis_tvalid  ( rxd_s_axis_3_tvalid),
.fd_s_axis_tready  ( rxd_s_axis_3_tready),
.fd_s_axis_tdata   ( rxd_s_axis_3_tdata ),
.fd_s_axis_tkeep   ( rxd_s_axis_3_tkeep ),
.fd_s_axis_tlast   ( rxd_s_axis_3_tlast ),
//                   ()
.fd_m_axis_tvalid  (fd_bar_axis_3_tvalid),
.fd_m_axis_tready  (fd_bar_axis_3_tready),
.fd_m_axis_tdata   (fd_bar_axis_3_tdata ),
.fd_m_axis_tkeep   (fd_bar_axis_3_tkeep ),
.fd_m_axis_tlast   (fd_bar_axis_3_tlast ),
 //                  ()
.fd_bus_sel_bits   (bus_sel_from_3_fd),
 //                 ()
.fifo_0_space_used (fifo_0_space_used), 
.fifo_1_space_used (fifo_1_space_used),
.fifo_2_space_used (fifo_2_space_used),
.fifo_3_space_used (fifo_3_space_used)
);

bus_sel_bits_interconnect BSBIC(
//fifo port
.fifo_0_bus_sel(bus_sel_to_0_fifo),
.fifo_1_bus_sel(bus_sel_to_1_fifo),
.fifo_2_bus_sel(bus_sel_to_2_fifo),
.fifo_3_bus_sel(bus_sel_to_3_fifo),

//frame_decoder port
.fd_0_bus_sel(bus_sel_from_0_fd),
.fd_1_bus_sel(bus_sel_from_1_fd),
.fd_2_bus_sel(bus_sel_from_2_fd),
.fd_3_bus_sel(bus_sel_from_3_fd)
);
endmodule