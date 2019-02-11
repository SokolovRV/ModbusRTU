module slave_select (
						input        clk,
					
						input [7:0]  adr_1,
						input [15:0] adr_first_reg_tx_1,
						input [7:0]  num_reg_tx_1,
						input [15:0] adr_first_reg_rx_1,
						input [7:0]  num_reg_rx_1,
						input [15:0] data_in_1,

						input [7:0]  adr_2,
						input [15:0] adr_first_reg_tx_2,
						input [7:0]  num_reg_tx_2,
						input [15:0] adr_first_reg_rx_2,
						input [7:0]  num_reg_rx_2,
						input [15:0] data_in_2,

						input        transfer_done,
						input		 	 reset,
															output reg [7:0]  adr,
															output reg [15:0] adr_first_reg_tx,
															output reg [7:0]  num_reg_tx,
															output reg [15:0] adr_first_reg_rx,
															output reg [7:0]  num_reg_rx,
															output reg [15:0] data_out
																											);

parameter [7:0] number_of_slaves = 2;

	  reg [7:0] selector 	    = 8'h01;
	  reg 		previous_strb   = 1'b0;

initial begin
	adr 			 =  8'h00;
	adr_first_reg_rx = 16'h0000;
	adr_first_reg_tx = 16'h0000;
	num_reg_rx       =  8'h00;
	num_reg_tx       =  8'h00;
	data_out         = 16'h0000;
end

always @(posedge clk) begin
	
	if(reset) begin
		selector <= 8'h01;
	end
	else begin
		
		previous_strb <= transfer_done;

		if(transfer_done && !previous_strb) begin
			if(selector == number_of_slaves)
				selector <= 8'h01;
			else
				selector <= selector + 8'h01;
		end
		else begin end

		case(selector)

			1: begin
				adr 			     <= adr_1;
				adr_first_reg_rx <= adr_first_reg_rx_1;
				adr_first_reg_tx <= adr_first_reg_tx_1;
				num_reg_rx       <= num_reg_rx_1;
				num_reg_tx       <= num_reg_tx_1;
				data_out         <= data_in_1;	
			end

			2: begin
				adr 			 	  <= adr_2;
				adr_first_reg_rx <= adr_first_reg_rx_2;
				adr_first_reg_tx <= adr_first_reg_tx_2;
				num_reg_rx       <= num_reg_rx_2;
				num_reg_tx       <= num_reg_tx_2;
				data_out         <= data_in_2;	
			end

			default: begin end
		endcase

	end

end

endmodule