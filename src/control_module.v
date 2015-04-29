module control_module
(
    CLK, RSTn,
	RX_Done_Sig,
	RX_Data,
	RX_En_Sig,
	RX_Data_Out
);

    input CLK;
	input RSTn;
	input RX_Done_Sig;
	input [7:0]RX_Data;
	output RX_En_Sig;
	output [7:0]RX_Data_Out;
	 
	/******************************/
	 
	reg [7:0]rData_0;
	reg isEn;
	 
    always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		    rData_0 <= 8'd0;
		else if( RX_Done_Sig )     
		    begin rData_0 <= RX_Data; isEn <= 1'b0; end
		else isEn <= 1'b1;

	/*********************************/
	
	assign RX_Data_Out  = rData_0 ;
	assign RX_En_Sig = isEn;
	
	/*********************************/
	 
endmodule
