module data_demux_1 (
								input 		 clk,
								input [7:0]  adr,
								input [7:0]  n_data,
								input [15:0] data_in,
								input 		 data_strb,
								input        crc_validate,
								input 		 reset,
																	output reg [15:0] data_340_1,
																	output reg [15:0] data_341_1,
																	output reg [15:0] data_342_1,
																	output reg [15:0] data_343_1,
																	output reg [15:0] data_344_1,
																	output reg [15:0] data_345_1,
																	output reg [15:0] data_346_1,
																	output reg [15:0] data_347_1,
																	output reg [15:0] data_348_1,
																	output reg [15:0] data_349_1,
																	output reg [15:0] data_350_1,
																	output reg [15:0] data_351_1,
																	output reg [15:0] data_352_1,
																	output reg [15:0] data_353_1,
																	output reg [15:0] data_354_1,
																	output reg [15:0] data_355_1,
																	output reg [15:0] data_356_1,
																	output reg [15:0] data_357_1,
																	output reg [15:0] data_358_1,
																	output reg [15:0] data_359_1,
																	output reg [15:0] data_360_1,
																	output reg [15:0] data_361_1,
																	output reg [15:0] data_362_1,
																	output reg [15:0] data_363_1,
																	output reg [15:0] data_364_1,
																	output reg [15:0] data_365_1,
																	output reg [15:0] data_366_1,
																	output reg [15:0] data_367_1,
																	output reg [15:0] data_368_1,
																	output reg [15:0] data_369_1

																											);

parameter [7:0]  slave_id        = 1;
parameter [7:0]  number_of_reg   = 30;

(*ramstyle = "no_rw_check"*)reg [15:0] mem [number_of_reg:0];
	
      reg        previous_strb_0 =  1'b0;
		
		reg [15:0] data_buff       = 16'h0000;
		reg [7:0]  n                =  8'h00;
		
initial begin
	data_340_1 = 16'h0000;
	data_341_1 = 16'h0000;
	data_342_1 = 16'h0000;
	data_343_1 = 16'h0000;
	data_344_1 = 16'h0000;
	data_345_1 = 16'h0000;
	data_346_1 = 16'h0000;
	data_347_1 = 16'h0000; 
	data_348_1 = 16'h0000;
	data_349_1 = 16'h0000;
	data_350_1 = 16'h0000;
	data_351_1 = 16'h0000;
	data_352_1 = 16'h0000;
	data_353_1 = 16'h0000;
	data_354_1 = 16'h0000;
	data_355_1 = 16'h0000;
	data_356_1 = 16'h0000;
	data_357_1 = 16'h0000; 
	data_358_1 = 16'h0000;
	data_359_1 = 16'h0000;
	data_360_1 = 16'h0000;
	data_361_1 = 16'h0000;
	data_362_1 = 16'h0000;
	data_363_1 = 16'h0000;
	data_364_1 = 16'h0000;
	data_365_1 = 16'h0000;
	data_366_1 = 16'h0000;
	data_367_1 = 16'h0000; 
	data_368_1 = 16'h0000;
	data_369_1 = 16'h0000;
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
		data_340_1 <= 16'h0000;
		data_341_1 <= 16'h0000;
		data_342_1 <= 16'h0000;
		data_343_1 <= 16'h0000;
		data_344_1 <= 16'h0000;
		data_345_1 <= 16'h0000;
		data_346_1 <= 16'h0000;
		data_347_1 <= 16'h0000; 
		data_348_1 <= 16'h0000;
		data_349_1 <= 16'h0000;
		data_350_1 <= 16'h0000;
		data_351_1 <= 16'h0000;
		data_352_1 <= 16'h0000;
		data_353_1 <= 16'h0000;
		data_354_1 <= 16'h0000;
		data_355_1 <= 16'h0000;
		data_356_1 <= 16'h0000;
		data_357_1 <= 16'h0000; 
		data_358_1 <= 16'h0000;
		data_359_1 <= 16'h0000;
		data_360_1 <= 16'h0000;
		data_361_1 <= 16'h0000;
		data_362_1 <= 16'h0000;
		data_363_1 <= 16'h0000;
		data_364_1 <= 16'h0000;
		data_365_1 <= 16'h0000;
		data_366_1 <= 16'h0000;
		data_367_1 <= 16'h0000; 
		data_368_1 <= 16'h0000;
		data_369_1 <= 16'h0000;
	end
	else begin
	
		case(n)
		
			1:  data_340_1 <= data_buff;
			2:  data_341_1 <= data_buff;
			3:  data_342_1 <= data_buff;
			4:  data_343_1 <= data_buff;
			5:  data_344_1 <= data_buff;
			6:  data_345_1 <= data_buff;
			7:  data_346_1 <= data_buff;
			8:  data_347_1 <= data_buff;
			9:  data_348_1 <= data_buff;
			10: data_349_1 <= data_buff;
			11: data_350_1 <= data_buff;
			12: data_351_1 <= data_buff;
			13: data_352_1 <= data_buff;
			14: data_353_1 <= data_buff;
			15: data_354_1 <= data_buff;
			16: data_355_1 <= data_buff;
			17: data_356_1 <= data_buff;
			18: data_357_1 <= data_buff;
			19: data_358_1 <= data_buff;
			20: data_359_1 <= data_buff;
			21: data_360_1 <= data_buff;
			22: data_361_1 <= data_buff;
			23: data_362_1 <= data_buff;
			24: data_363_1 <= data_buff;
			25: data_364_1 <= data_buff;
			26: data_365_1 <= data_buff;
			27: data_366_1 <= data_buff;
			28: data_367_1 <= data_buff;
			29: data_368_1 <= data_buff;
			30: data_369_1 <= data_buff;
	
			default: begin end
		endcase
	
	end
		
end

endmodule