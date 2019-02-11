module data_demux_2 (
								input 		 clk,
								input [7:0]  adr,
								input [7:0]  n_data,
								input [15:0] data_in,
								input 		 data_strb,
								input        crc_validate,
								input 		 reset,
																	output reg [15:0] data_340_2,
																	output reg [15:0] data_341_2,
																	output reg [15:0] data_342_2,
																	output reg [15:0] data_343_2,
																	output reg [15:0] data_344_2,
																	output reg [15:0] data_345_2,
																	output reg [15:0] data_346_2,
																	output reg [15:0] data_347_2,
																	output reg [15:0] data_348_2,
																	output reg [15:0] data_349_2
																											);

parameter [7:0]  slave_id        = 2;
parameter [7:0]  number_of_reg   = 10;

(*ramstyle = "no_rw_check"*)reg [15:0] mem [number_of_reg:0];
	
      reg        previous_strb_0 =  1'b0;
		
		reg [15:0] data_buff       = 16'h0000;
		reg [7:0]  n               =  8'h00;
		
initial begin
	data_340_2 = 16'h0000;
	data_341_2 = 16'h0000;
	data_342_2 = 16'h0000;
	data_343_2 = 16'h0000;
	data_344_2 = 16'h0000;
	data_345_2 = 16'h0000;
	data_346_2 = 16'h0000;
	data_347_2 = 16'h0000; 
	data_348_2 = 16'h0000;
	data_349_2 = 16'h0000;
end


always @(posedge clk) begin
	
	if(reset)
		data_buff <= 16'h0000;
	else begin end
	
	previous_strb_0 <= data_strb;

	if(data_strb && !previous_strb_0 && adr == slave_id) begin
		mem[n_data] <= data_in;
	end
	else begin end

	
	if(crc_validate) begin	
			data_buff <= mem[n_data];
			n <= n_data;
	end
	else begin end
	
end

always @(posedge clk) begin
	
	if(reset) begin
		data_340_2 <= 16'h0000;
		data_341_2 <= 16'h0000;
		data_342_2 <= 16'h0000;
		data_343_2 <= 16'h0000;
		data_344_2 <= 16'h0000;
		data_345_2 <= 16'h0000;
		data_346_2 <= 16'h0000;
		data_347_2 <= 16'h0000; 
		data_348_2 <= 16'h0000;
		data_349_2 <= 16'h0000;
	end
	else begin
	
		case(n)
		
			1:  data_340_2 <= data_buff;
			2:  data_341_2 <= data_buff;
			3:  data_342_2 <= data_buff;
			4:  data_343_2 <= data_buff;
			5:  data_344_2 <= data_buff;
			6:  data_345_2 <= data_buff;
			7:  data_346_2 <= data_buff;
			8:  data_347_2 <= data_buff;
			9:  data_348_2 <= data_buff;
			10: data_349_2 <= data_buff;
			
			default: begin end
		endcase
	
	end
		
end

endmodule