module data_mux_2 (
					input        clk,
					input [7:0]  selector,
					input [15:0] data_300_2,
					input [15:0] data_301_2,
					input [15:0] data_302_2,
					input [15:0] data_303_2,
					input [15:0] data_304_2,
					input [15:0] data_305_2,
					input [15:0] data_306_2,
					input [15:0] data_307_2,
					input [15:0] data_308_2,
					input [15:0] data_309_2,
					input 		 reset,
												output reg [7:0]  adr,
												output reg [15:0] adr_first_reg_tx,
												output reg [7:0]  num_reg_tx,
												output reg [15:0] adr_first_reg_rx,
												output reg [7:0]  num_reg_rx,
												output reg [15:0] data_out
																						);

parameter [7:0]  slave_adr            = 2;
parameter [15:0] adr_first_reg_write  = 300;
parameter [7:0]  num_reg_write		  = 10;
parameter [15:0] adr_first_reg_read   = 340;
parameter [7:0]  num_reg_write_read	  = 10;


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

			1: data_out <= data_300_2;

			2: data_out <= data_301_2;

			3: data_out <= data_302_2;

			4: data_out <= data_303_2;

			5: data_out <= data_304_2;

			6: data_out <= data_305_2;

			7: data_out <= data_306_2;

			8: data_out <= data_307_2;

			9: data_out <= data_308_2;

			10: data_out <= data_309_2;

			default: data_out <= 16'h0000;

		endcase

	end

end
endmodule
