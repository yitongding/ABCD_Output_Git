`include "data_op.vh"								//定义恒量

module data_pro
(
	input clk,
	input rstn,
	input [7:0] data_in,
	output [15:0] delay_set_a, 
	output [15:0] delay_set_b,
	output [15:0] delay_set_c, 
	output [15:0] delay_set_d,
	output [15:0] duty_cycle,
	output [15:0] sub_clk_feq,
	output [15:0] sub_clk_scl
);

	reg [7:0] funct;
	reg [15:0] data;
	reg [1:0] state;
	
	reg [15:0] delay_set_a_reg;
	reg [15:0] delay_set_b_reg;
	reg [15:0] delay_set_c_reg;
	reg [15:0] delay_set_d_reg;
	reg [15:0] duty_cycle_reg;
	reg [15:0] sub_clk_feq_reg;
	reg [15:0] sub_clk_scl_reg;
	
	always @(posedge clk or negedge rstn) begin		//状态机
		if (!rstn) begin
			funct <= 8'd0;
			data <= 15'd0;
			state <= `STATE_FUNC;
		end
		else begin
			case (state)							//三输入�
			
				`STATE_FUNC: begin					//输入功能设定
					funct <= data_in;
					state <= state + 1;
				end
				
				`STATE_UP: begin					//输入数字高八�
					data[15:8] <= data_in;
					state <= state +1;
				end
				
				`STATE_LOW: begin 					//输入数字低八�
					data[7:0] <= data_in;
					state <= `STATE_FUNC;
				end
				
				default: begin
					funct <= `FUNCT_NONE;
					data[15:0] <= 15'd0;
					state <= `STATE_FUNC;
				end
				
			endcase
		end
	end
	
	always @(posedge clk or negedge rstn) begin		//根据功能 将数字赋值给端口设置
		if (!rstn) begin
			delay_set_a_reg <= 15'd0;				//默认倊			
			delay_set_b_reg <= 15'd10;
			delay_set_c_reg <= 15'd20;
			delay_set_d_reg <= 15'd30;
			duty_cycle_reg <= 15'd5;
			sub_clk_scl_reg <= 15'd1000;
			sub_clk_feq_reg <= 15'd10;
		end
		else begin
			case (funct)
				
				`FUNCT_PORTA: delay_set_a_reg <= data;
				`FUNCT_PORTB: delay_set_b_reg <= data;
				`FUNCT_PORTC: delay_set_c_reg <= data;
				`FUNCT_PORTD: delay_set_d_reg <= data;
				`FUNCT_DUTYC: duty_cycle_reg <= data;
				`FUNCT_SCLKF: sub_clk_feq_reg <= data;
				`FUNCT_SCLKS: sub_clk_scl_reg <= data;
				`FUNCT_NONE: ;
				default: ;
				
			endcase
		end
	end
	
	assign delay_set_a = delay_set_a_reg;
	assign delay_set_b = delay_set_b_reg;
	assign delay_set_c = delay_set_c_reg;
	assign delay_set_d = delay_set_d_reg;
	assign duty_cycle = duty_cycle_reg;
	assign sub_clk_feq = sub_clk_feq_reg;
	assign sub_clk_scl = sub_clk_scl_reg;
	

endmodule