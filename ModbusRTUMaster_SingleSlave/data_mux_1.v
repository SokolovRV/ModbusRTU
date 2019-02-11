module data_mux_1 (
					input        clk,
					input [7:0]  selector,
					
					input [15:0] data_300_1,
					input [15:0] data_301_1,
					input [15:0] data_302_1,
					input [15:0] data_303_1,
					input [15:0] data_304_1,
					input [15:0] data_305_1,
					input [15:0] data_306_1,
					input [15:0] data_307_1,
					input [15:0] data_308_1,
					input [15:0] data_309_1,
					input [15:0] data_310_1,
					input [15:0] data_311_1,
					input [15:0] data_312_1,
					input [15:0] data_313_1,
					input [15:0] data_314_1,
					input [15:0] data_315_1,
					input [15:0] data_316_1,
					input [15:0] data_317_1,
					input [15:0] data_318_1,
					input [15:0] data_319_1,
					input [15:0] data_320_1,
					input [15:0] data_321_1,
					input [15:0] data_322_1,
					input [15:0] data_323_1,
					input [15:0] data_324_1,
					input [15:0] data_325_1,
					input [15:0] data_326_1,
					input [15:0] data_327_1,
					input [15:0] data_328_1,
					input [15:0] data_329_1,
					
					input 		 reset,
												output reg [7:0]  adr,
												output reg [15:0] adr_first_reg_tx,
												output reg [7:0]  num_reg_tx,
												output reg [15:0] adr_first_reg_rx,
												output reg [7:0]  num_reg_rx,
												output reg [15:0] data_out
																						);

parameter [7:0]  slave_adr            = 1;
parameter [15:0] adr_first_reg_write  = 300;
parameter [7:0]  num_reg_write		  = 30;
parameter [15:0] adr_first_reg_read   = 340;
parameter [7:0]  num_reg_write_read	  = 30;


initial begin
	data_out         = 16'h0000;
	adr 				  = slave_adr;
	adr_first_reg_tx = adr_first_reg_write;
	num_reg_tx 		  = num_reg_write;
	adr_first_reg_rx = adr_first_reg_read;
	num_reg_rx 		  = num_reg_write_read;
end

always @(posedge clk) begin

	if(reset)
		data_out <= 16'h0000;
	else begin
	
		
		case(selector)

			1: data_out <= data_300_1;
			2: data_out <= data_301_1;
			3: data_out <= data_302_1;
			4: data_out <= data_303_1;
			5: data_out <= data_304_1;
			6: data_out <= data_305_1;
			7: data_out <= data_306_1;
			8: data_out <= data_307_1;
			9: data_out <= data_308_1;
			10: data_out <= data_309_1;	
			11: data_out <= data_310_1;			
			12: data_out <= data_311_1;			
			13: data_out <= data_312_1;			
			14: data_out <= data_313_1;			
			15: data_out <= data_314_1;		
			16: data_out <= data_315_1;			
			17: data_out <= data_316_1;			
			18: data_out <= data_317_1;			
			19: data_out <= data_318_1;			
			20: data_out <= data_319_1;			
			21: data_out <= data_320_1;			
			22: data_out <= data_321_1;			
			23: data_out <= data_322_1;			
			24: data_out <= data_323_1;			
			25: data_out <= data_324_1;
			26: data_out <= data_325_1;			
			27: data_out <= data_326_1;			
			28: data_out <= data_327_1;			
			29: data_out <= data_328_1;
			30: data_out <= data_329_1;			
			

			default: data_out <= 16'h0000;

		endcase

	end

end
endmodule
