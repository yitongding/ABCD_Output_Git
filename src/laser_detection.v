module laser_detection
{
	input clk,
	input rstn,
	input laser_sig,
	output moter_laser_en
};

	reg moter_laser_en_reg;
	reg rst_flag;
 
	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			if (!laser_sig) begin
				rst_flag <= 1;
				moter_laser_control_reg <= 1;
			end else begin
				rst_flag <= 0;
				moter_laser_control_reg <= 0;
			end
		end else if (rst_flag) begin
			if (laser_sig) begin
				rst_flag <= 0;
				moter_laser_control_reg <= 0;
			end
		end
	end
	
endmodule
			