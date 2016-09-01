/****************************************          **
该模块是根据来自frame_decoder(fd)在fifo上          **
的申请位来计算出总线选择器（bus_mux and bus_demux）**
所真正的申请成功的fd所需的bus_sel_bits   
该模块为时序模块 第一个周期输入信号fifo_sel_bits产生变化 **
一个时钟上升沿后 输出信号fifo_sel_res_final发生变化**
****************************************/
module fifo_sel_cal(
glb_areset_n,
glb_clk,

fifo_sel_bits,//来自frame_decoder(fd)在fifo上的申请位 **
fifo_sel_res_final//最终竞争成功的选择码  **

);
input glb_areset_n;
input glb_clk    ;


input        [3:0]   fifo_sel_bits;
output       [3:0]   fifo_sel_res_final;
reg          [3:0]   fifo_sel_res_final_r;
reg          [3:0]   fifo_sel_res_r;
reg          [3:0]   fifo_sel_res ;
//来自上层模块的设置值                 ***
//该参数需要 在上层传递进来以保证统一性***
//注意 ：用于选择的参数不能设置为0     ***
//防止在复位时与设置值相关的寄存器     ***
//复位置零导致不该连接的通路           ***
parameter CHOOSE_FIFO_0=  4'b0100;   //输出选择0号总线输入**
parameter CHOOSE_FIFO_1=  4'b0101;   //输出选择0号总线输入**
parameter CHOOSE_FIFO_2=  4'b0110;   //输出选择0号总线输入**
parameter CHOOSE_FIFO_3=  4'b0111;   //输出选择0号总线输入**
parameter NON_FIFO_CHOOSE=4'b0000;   //输出不选择任何总线输入，输出为0**

always @(fifo_sel_bits)
begin
        if(fifo_sel_bits[0])
        begin
            fifo_sel_res=CHOOSE_FIFO_0;
        end
        else if(fifo_sel_bits[1])
        begin
            fifo_sel_res=CHOOSE_FIFO_1;
        end
        else if(fifo_sel_bits[2])
        begin
            fifo_sel_res=CHOOSE_FIFO_2;
        end
        else if(fifo_sel_bits[3])
        begin
            fifo_sel_res=CHOOSE_FIFO_3;
        end
        else fifo_sel_res=NON_FIFO_CHOOSE;
end

//该逻辑为了确保在输出跳变为NON_FIFO_CHOOSE的情况下也是经过一个周期而不是两个周期**
assign fifo_sel_res_final=(fifo_sel_res_r==NON_FIFO_CHOOSE&&fifo_sel_res==NON_FIFO_CHOOSE)?
                         NON_FIFO_CHOOSE:fifo_sel_res_final_r;
always @(posedge glb_clk or negedge glb_areset_n)
begin
    if(!glb_areset_n)
    begin
        fifo_sel_res_r<=4'h0;
        fifo_sel_res_final_r<=4'h0;
    end
    else
    begin
        //如果上一个周期为NON_FIFO_CHOOSE 说明总线是空闲的 且本周期有申请 **
        //所以修改输出结果
        if(fifo_sel_res_r==NON_FIFO_CHOOSE&&fifo_sel_res!=NON_FIFO_CHOOSE)
            fifo_sel_res_final_r<=fifo_sel_res;
        //如果上一个周期为NON_FIFO_CHOOSE  且本周期为NON_FIFO_CHOOSE  **
        //所以修改输出结果为NON_FIFO_CHOOSE 使总线回归到空闲状态**
        else if(fifo_sel_res_r==NON_FIFO_CHOOSE&&fifo_sel_res==NON_FIFO_CHOOSE)
            fifo_sel_res_final_r<=NON_FIFO_CHOOSE;
        else;//否则 保持final输出不变 这样来保证一次传输中**
             //总线优先级低的传输不会被优先级更高的传输打断***
        
        
        //fifo_sel_res_r保存上一个周期的仲裁状态***
        fifo_sel_res_r<=fifo_sel_res;    
    end
end
endmodule