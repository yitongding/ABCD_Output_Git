`define CLK_FEQ 50000000

module ch_output_module
(
	input clk,
	//input sub_clk,
	//input subsub_clk,
	input rstn,
	input [15:0] sub_clk_feq,
	input [15:0] sub_clk_scl,
	input [15:0] duty_cycle,
	input [15:0] delay_set,
	output ch_output
);
	
	reg ch_output_reg;
	reg [15:0] sub_clk_count;
	reg [15:0] subsub_clk_count;
	reg [15:0] subsub_count;
	wire [15:0] sub_clk_sum;
	wire [15:0] subsub_clk_sum;
	
	assign sub_clk_sum = `CLK_FEQ / sub_clk_feq;
	assign subsub_clk_sum = `CLK_FEQ / sub_clk_scl;
	
	always @(posedge clk or negedge rstn) begin 
		if (!rstn) begin
			ch_output_reg <= 0;
			sub_clk_count <= 0;
			subsub_clk_count <=0;
			subsub_count <= 0;
		end else if (sub_clk_count >= sub_clk_sum) begin
			sub_clk_count <= 0;
			subsub_clk_count <= 0;
			subsub_count <=0;
			if (delay_set == 0) begin 
				ch_output_reg <= 1;
			end else begin
				ch_output_reg <= 0;
			end
		end else if (subsub_clk_count >= subsub_clk_sum) begin
			subsub_clk_count <= 0;
			subsub_count <= subsub_count + 1;
			if ( (subsub_count < delay_set - 1) & (delay_set != 0) ) begin
				ch_output_reg <= 0;
			end else if (subsub_count < (delay_set + duty_cycle - 1) ) begin 
				ch_output_reg <= 1;
			end else if (subsub_count >= (delay_set + duty_cycle - 1) ) begin 
				ch_output_reg <= 0;
			end
		end else begin
			sub_clk_count <= sub_clk_count + 1;
			subsub_clk_count <= subsub_clk_count + 1;
		end
	end
	/*
	reg ch_output_reg;
	reg [15:0] subsub_count;

	always @ (posedge sub_clk or negedge rstn) begin
	//always @ ( (posedge sub_clk) | (posedge subsub_clk) | (negedge rstn) ) begin
		if ((!rstn | sub_clk) & (delay_set != 0) ) begin
			ch_output_reg <= 0;
			subsub_count <= 0;
		end else if ((!rstn | sub_clk) & (delay_set == 0) ) begin
			ch_output_reg <= 1;
			subsub_count <= 0;
		end else if (subsub_count < delay_set ) begin
			subsub_count <= subsub_count + 1;
			ch_output_reg <= 0;
		end else if (subsub_count < (delay_set + duty_cycle) ) begin 
			subsub_count <= subsub_count + 1;
			ch_output_reg <= 1;
		end else if (subsub_count >= (delay_set + duty_cycle) ) begin 
			subsub_count <= subsub_count + 1;
			ch_output_reg <= 0;
		end
	end
	*/
	assign ch_output = ch_output_reg;
	
endmodule