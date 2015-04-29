`define CLK_FEQ 50000000								//本应该是100M,但为了避免多次使用除法器,改为50M

module sub_clk_module
(
	input clk,
	input rstn,
	input [15:0] sub_clk_feq,
	input [15:0] sub_clk_scl,
	output sub_clk,
	output subsub_clk
);

	reg [15:0] sub_count;
	reg [15:0] subsub_count;
	reg sub_clk_reg;
	reg subsub_clk_reg;
	wire [31:0] sub_count_sum;
	wire [31:0] subsub_count_sum;

	assign sub_count_sum = `CLK_FEQ / sub_clk_feq;		//此处避免多次使用除法�	assign subsub_count_sum = `CLK_FEQ / sub_clk_scl;
	assign subsub_count_sum = `CLK_FEQ / sub_clk_scl;
	
	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			sub_count <= 0;
			sub_clk_reg <= 0;
			subsub_clk_reg <= 0;
		end
		else begin
			if (sub_count >= sub_count_sum ) begin 		//使用大于等于避免设置更新时无法回�				sub_count <= 0;
				sub_clk_reg <= !sub_clk_reg;
			end else begin 
				sub_count <= sub_count + 1;
			end
			if (subsub_count >= subsub_count_sum) begin
				subsub_count <= 0;
				subsub_clk_reg <= !subsub_clk_reg;
			end else begin
				subsub_count <= subsub_count + 1;
			end
		end
	end

	assign sub_clk = sub_clk_reg;
	assign subsub_clk = subsub_clk_reg;
	
endmodule