module rx_module_demo
(
    CLK, RSTn,
	RX_Pin_In,
	RX_Data_Out
);

    input CLK;
	input RSTn;
	input RX_Pin_In;
    output [7:0]RX_Data_Out;
	 
	/**********************************/
	 
	wire RX_Done_Sig;
	wire [7:0]RX_Data;
	 
	rx_module U1
	(
	    .CLK( CLK ),
		.RSTn( RSTn ),
		.RX_Pin_In( RX_Pin_In ),   // input - from top
		.RX_En_Sig( RX_En_Sig ),   // input - from U2
		.RX_Done_Sig( RX_Done_Sig ),  // output - to U2
		.RX_Data( RX_Data )           // output - to U2
	);
	 
	/***********************************/
	 
	wire RX_En_Sig;
	wire [7:0]Output_Data;
	 
	control_module U2
	(
	    .CLK( CLK ),
	    .RSTn( RSTn ),
		.RX_Done_Sig( RX_Done_Sig ),  // input - from U1
		.RX_Data( RX_Data ),          // input - from U1
		.RX_En_Sig( RX_En_Sig ),      // output - to U1
		.RX_Data_Out( Output_Data )   // output - to top
	);
	 
	/***********************************/

	 assign RX_Data_Out = Output_Data;
	 
endmodule
