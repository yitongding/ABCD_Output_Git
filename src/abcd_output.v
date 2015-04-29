`timescale 1ms/5ns

module abcd_output
(
	input clk,						//主时�晶振主�00MHz)
	input rstn,
	input rx_pin_in,
	output ch_a_output, ch_b_output, ch_c_output, ch_d_output
	
);
/****************************/

	wire [7:0] rx_data_out;			//串口数据处理后的读取�	wire [15:0] delay_set_a;		//各端口输出延�	
	wire [15:0] delay_set_b;
	wire [15:0] delay_set_c;
	wire [15:0] delay_set_d;		
	wire [15:0] duty_cycle;			//输出信号占空时间
	wire [15:0] sub_clk_feq;
	wire [15:0] sub_clk_scl;
	wire sub_clk;					//次级时钟
	wire subsub_clk;

	
	rx_module_demo u1				//串口数据处理
	(
		.CLK(clk),
		.RSTn(rstn),
		.RX_Pin_In(rx_pin_in),		//原始数据输入
		.RX_Data_Out(rx_data_out)	//处理后的数据
	);
	
	
	data_pro u2						//控制信号生成
	(
		.clk(clk),
		.rstn(rstn),
		.data_in(rx_data_out),		//数据输入
		.delay_set_a(delay_set_a),	//延迟设定
		.delay_set_b(delay_set_b),
		.delay_set_c(delay_set_c),
		.delay_set_d(delay_set_d),
		.duty_cycle(duty_cycle),	//占空时长
		.sub_clk_feq(sub_clk_feq),	//次级时钟频率
		.sub_clk_scl(sub_clk_scl)	//次次级时钟频�	);
	);
	
	/*
	sub_clk_module u3				//次级时钟生成
	(
		.clk(clk),
		.sub_clk_feq(sub_clk_feq),
		.sub_clk_scl(sub_clk_scl),
		.sub_clk(sub_clk),
		.subsub_clk(subsub_clk)
	);
	*/
	
	ch_output_module u_a
	(
		.clk(clk),
		.sub_clk_feq(sub_clk_feq),
		.sub_clk_scl(sub_clk_scl),
		.rstn(rstn),
		.delay_set(delay_set_a),
		.duty_cycle(duty_cycle),
		.ch_output(ch_a_output)
	);

	ch_output_module u_b
	(
		.clk(clk),
		.sub_clk_feq(sub_clk_feq),
		.sub_clk_scl(sub_clk_scl),
		.rstn(rstn),
		.delay_set(delay_set_b),
		.duty_cycle(duty_cycle),
		.ch_output(ch_b_output)
	);

	ch_output_module u_c
	(
		.clk(clk),
		.sub_clk_feq(sub_clk_feq),
		.sub_clk_scl(sub_clk_scl),
		.rstn(rstn),
		.delay_set(delay_set_c),
		.duty_cycle(duty_cycle),
		.ch_output(ch_c_output)
	);

	ch_output_module u_d
	(
		.clk(clk),
		.sub_clk_feq(sub_clk_feq),
		.sub_clk_scl(sub_clk_scl),
		.rstn(rstn),
		.delay_set(delay_set_d),
		.duty_cycle(duty_cycle),
		.ch_output(ch_d_output)
	);


/****************************/
endmodule