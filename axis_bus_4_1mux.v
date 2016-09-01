/***********************************
总线四选一数据选择模块              **
该模块结构上隶属于输出fifo          **
该模块用于选择来自RX端的总线数据    **
并将选择好的数据通过axis总线输出到  **
axis_fifo 的slave端将数据输入fifo中 **
                                    **
axis_bus_4_1_mux 的输入端与四个     **
frame-decoder 的数据输出相连        **
根据 bus_sel 的设置值来决定输出     **
哪一路输入数据                      **
***********************************/




//bus mux used for tvalid tdata tkeep tlast
module axis_bus_4_1_mux(
bus_sel,

axis_in_0_tvalid ,
axis_in_0_tdata  ,
axis_in_0_tkeep  ,
axis_in_0_tlast  ,

axis_in_1_tvalid ,
axis_in_1_tdata  ,
axis_in_1_tkeep  ,
axis_in_1_tlast  ,

axis_in_2_tvalid ,
axis_in_2_tdata  ,
axis_in_2_tkeep  ,
axis_in_2_tlast  ,
   
axis_in_3_tvalid ,
axis_in_3_tdata  ,
axis_in_3_tkeep  ,
axis_in_3_tlast  ,

axis_out_tvalid  ,
axis_out_tdata   ,
axis_out_tkeep   ,
axis_out_tlast   

);

input  [3:0]    bus_sel;

input           axis_in_0_tvalid ;
input  [31:0]   axis_in_0_tdata  ;
input  [3:0]    axis_in_0_tkeep  ;
input           axis_in_0_tlast  ;
  //
input           axis_in_1_tvalid ;
input  [31:0]   axis_in_1_tdata  ;
input  [3:0]    axis_in_1_tkeep  ;
input           axis_in_1_tlast  ;
 //                                ;
input           axis_in_2_tvalid ;
input  [31:0]   axis_in_2_tdata  ;
input  [3:0]    axis_in_2_tkeep  ;
input           axis_in_2_tlast  ;
  //                               ;
input           axis_in_3_tvalid ;
input  [31:0]   axis_in_3_tdata  ;
input  [3:0]    axis_in_3_tkeep  ;
input           axis_in_3_tlast  ;
 //                                ;
output reg           axis_out_tvalid  ;
output reg  [31:0]   axis_out_tdata   ;
output reg  [3:0]    axis_out_tkeep   ;
output reg           axis_out_tlast   ;

//来自上层模块的设置值                 ***
//该参数需要 在上层传递进来以保证统一性***
//注意 ：用于选择的参数不能设置为0     ***
//防止在复位时与设置值相关的寄存器     ***
//复位置零导致不该连接的通路           ***
parameter CHOOSE_FIFO_0=  4'b0100;//输出选择0号总线输入**
parameter CHOOSE_FIFO_1=  4'b0101;//输出选择0号总线输入**
parameter CHOOSE_FIFO_2=  4'b0110;//输出选择0号总线输入**
parameter CHOOSE_FIFO_3=  4'b0111;//输出选择0号总线输入**
parameter NON_FIFO_CHOOSE=4'b0000;//输出不选择任何总线输入，输出为0**

always @(bus_sel,axis_in_0_tvalid,axis_in_1_tvalid,axis_in_2_tvalid,axis_in_3_tvalid,
                 axis_in_0_tdata ,axis_in_1_tdata ,axis_in_2_tdata ,axis_in_3_tdata ,
                 axis_in_0_tkeep ,axis_in_1_tkeep ,axis_in_2_tkeep ,axis_in_3_tkeep ,
                 axis_in_0_tlast ,axis_in_1_tlast ,axis_in_2_tlast , axis_in_3_tlast )
begin
            case (bus_sel)//ps:pay attention to the code of bus_sel 
            CHOOSE_FIFO_0:begin
                   axis_out_tvalid=axis_in_0_tvalid;
                   axis_out_tkeep =axis_in_0_tkeep;
                   axis_out_tlast =axis_in_0_tlast;
                   axis_out_tdata =axis_in_0_tdata;
                   end
            CHOOSE_FIFO_1:begin
                   axis_out_tvalid=axis_in_1_tvalid;
                   axis_out_tkeep =axis_in_1_tkeep;
                   axis_out_tlast = axis_in_1_tlast;
                   axis_out_tdata =axis_in_1_tdata;
                   end
            CHOOSE_FIFO_2:begin
                   axis_out_tvalid=axis_in_2_tvalid;
                   axis_out_tkeep =axis_in_2_tkeep;
                   axis_out_tlast = axis_in_2_tlast;
                   axis_out_tdata =axis_in_2_tdata;
                   end
            CHOOSE_FIFO_3:begin
                   axis_out_tvalid=axis_in_3_tvalid;
                   axis_out_tkeep =axis_in_3_tkeep;
                   axis_out_tlast = axis_in_3_tlast;
                   axis_out_tdata =axis_in_3_tdata;
                   end
            default:begin
                   axis_out_tvalid=0;axis_out_tkeep=0;
                   axis_out_tlast= 0;axis_out_tdata=0;
                   end
            endcase
end
endmodule
