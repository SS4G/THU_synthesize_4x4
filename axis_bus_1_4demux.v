/********************************
该数据分配器用于将来自fifo的                ***
tready应答信号分配到对应的fd上              ***
该信号并非直接连接到frame_decoder(fd)       ***
的输出端的tready上，因为一个fd              ***
的tready将可能接受四个fifo的应答信号        ***
所以，对于一个fd的tready的结果是四个fifo的  ***
tready相或的结果，只要对应所申请的fifo      ***
的tready有了应答，申请者fd将会收到tready    ***
若申请失败 将不会收到tready回应信号         ***
********************************/
module axis_bus_1_4_demux(
bus_sel,

axis_out_0_tready,
axis_out_1_tready,
axis_out_2_tready,
axis_out_3_tready,

axis_in_tready
);

input [3:0] bus_sel;

output reg axis_out_0_tready;
output reg axis_out_1_tready;
output reg axis_out_2_tready;
output reg axis_out_3_tready;
input  axis_in_tready;


//来自上层模块的设置值                 ***
//该参数需要 在上层传递进来以保证统一性***
//注意 ：用于选择的参数不能设置为0     ***
//防止在复位时与设置值相关的寄存器     ***
//复位置零导致不该连接的通路           ***
parameter CHOOSE_FIFO_0  =4'b0100; //输出选择0号总线输入**
parameter CHOOSE_FIFO_1  =4'b0101; //输出选择0号总线输入**
parameter CHOOSE_FIFO_2  =4'b0110; //输出选择0号总线输入**
parameter CHOOSE_FIFO_3  =4'b0111; //输出选择0号总线输入**
parameter NON_FIFO_CHOOSE=4'b0000; //输出不选择任何总线输入，输出为0**


always @ (bus_sel,axis_in_tready)
begin
            case (bus_sel)//ps:pay attention to the code of bus_sel 
            CHOOSE_FIFO_0:begin
                    axis_out_0_tready=axis_in_tready;
                    axis_out_1_tready=0;
                    axis_out_2_tready=0;
                    axis_out_3_tready=0;
                   end
            CHOOSE_FIFO_1:begin
                    axis_out_0_tready=0;
                    axis_out_1_tready=axis_in_tready;
                    axis_out_2_tready=0;
                    axis_out_3_tready=0;
                   end
            CHOOSE_FIFO_2:begin
                    axis_out_0_tready=0;
                    axis_out_1_tready=0;
                    axis_out_2_tready=axis_in_tready;
                    axis_out_3_tready=0;
                   end
            CHOOSE_FIFO_3:begin
                    axis_out_0_tready=0;
                    axis_out_1_tready=0;
                    axis_out_2_tready=0;
                    axis_out_3_tready=axis_in_tready;
                   end
            default:begin//non fifo choosed
                    axis_out_0_tready=0;
                    axis_out_1_tready=0;
                    axis_out_2_tready=0;
                    axis_out_3_tready=0;
                    end
            endcase
end
endmodule