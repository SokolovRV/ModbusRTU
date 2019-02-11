module modbus_rtu_tx_control	(
											input        clk,
											input [7:0]  adr,
											input [15:0] adr_first_reg_tx,
											input [7:0]  num_reg_tx,
											input [15:0] adr_first_reg_rx,
											input [7:0]  num_reg_rx,
											input [15:0] data_in,
											input [15:0] crc_16,
											input        answer_received,
											input		 	 busy_tx,
											input        reset, 
																					output reg [7:0] byte_out,
																					output reg [7:0] num_reg,
																					output reg       start_tx,
																					output reg       DE,
																					output reg       reset_crc,
																					output reg       transfer_done
																																);

parameter  [17:0] delay_us 	     =  1;
parameter  [6:0]  clk_freq_MHz     =  80;

localparam [23:0] delay_period     =  delay_us * clk_freq_MHz;
localparam [7:0]  func_code_write  =  8'h10;
localparam [7:0]  func_code_read   =  8'h03;

localparam [4:0]  IDLE           =  5'b00000;
localparam [4:0]  STAGE_0   	   =  5'b00001;
localparam [4:0]  STAGE_1   	   =  5'b00010;
localparam [4:0]  STAGE_2   	   =  5'b00011;
localparam [4:0]  STAGE_3   	   =  5'b00100;
localparam [4:0]  STAGE_4   	   =  5'b00101;
localparam [4:0]  STAGE_5   	   =  5'b00110;
localparam [4:0]  STAGE_6   	   =  5'b00111;
localparam [4:0]  STAGE_7   	   =  5'b01000;
localparam [4:0]  STAGE_8   	   =  5'b01001;
localparam [4:0]  STAGE_9   	   =  5'b01010;
localparam [4:0]  STAGE_10   	   =  5'b01011;
localparam [4:0]  STAGE_11   	   =  5'b01100;
localparam [4:0]  STAGE_12   	   =  5'b01101;
localparam [4:0]  STAGE_13   	   =  5'b01110;
localparam [4:0]  STAGE_14   	   =  5'b01111;
localparam [4:0]  STAGE_15   	   =  5'b10000;
localparam [4:0]  STAGE_16  	   =  5'b10001;
localparam [4:0]  STAGE_17   	   =  5'b10010;
localparam [4:0]  STAGE_18   	   =  5'b10011;
localparam [4:0]  STAGE_19   	   =  5'b10100;
localparam [4:0]  STAGE_20   	   =  5'b10101;
localparam [4:0]  STAGE_21   	   =  5'b10110;

		reg [4:0]  state              =  5'b00000;
	   
	   reg [1:0]  data_delay_cnt     =  2'b00;
	   reg [15:0] data_buff          = 16'h0000;
	   reg [23:0] transfer_delay_cnt = 24'h000000;

	   reg        start_delay        =  1'b0;
	   reg        start_data_delay   =  1'b0;
	   reg        previous_strb_0    =  1'b0;
	   reg        previous_strb_1    =  1'b0;

initial begin
	byte_out      = 8'h00;
	num_reg  	  = 8'h01;
	start_tx 	  = 1'b0;
	DE       	  = 1'b1;
	transfer_done = 1'b0;
	reset_crc     = 1'b0;
end

always @(posedge clk) begin
	
	if(reset) begin
		start_tx <= 1'b0;
		state <= IDLE;
		DE <= 1'b1;
		transfer_done <= 1'b0;
		num_reg <= 8'h01;
		reset_crc <= 1'b0;
	end
	else begin

	if(start_delay) begin
		if(transfer_delay_cnt >= delay_period) begin
			transfer_delay_cnt <= 24'h000000;
			start_delay <= 1'b0;
		end
		else begin
			transfer_delay_cnt <= transfer_delay_cnt + 24'h000001;
		end
	end
	else begin end

	if(start_data_delay) begin
		if(&data_delay_cnt) begin
			data_delay_cnt <= 2'b00;
			start_data_delay <= 1'b0;
			data_buff <= data_in;
		end
		else begin
			data_delay_cnt <= data_delay_cnt + 2'b01;
		end
	end
	else begin end
	
	previous_strb_0 <= busy_tx;
	previous_strb_1 <= answer_received;

		case(state)

			IDLE: begin
				if(!start_delay) begin
					state <= STAGE_0;
					transfer_done <= 1'b0;
				end
				else begin
					state <= IDLE;
				end

				reset_crc <= 1'b0;

			end

			STAGE_0: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_1;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= adr;
					start_tx <= 1'b1;
				end
			end

			STAGE_1: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_2;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= func_code_write;
					start_tx <= 1'b1;
				end
			end

			STAGE_2: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_3;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= adr_first_reg_tx[15:8];
					start_tx <= 1'b1;
				end
			end

			STAGE_3: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_4;
					start_tx <= 1'b0;
				end
				else begin 
					byte_out <= adr_first_reg_tx[7:0];
					start_tx <= 1'b1;
				end
			end

			STAGE_4: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_5;
					start_tx <= 1'b0;
				end
				else begin 
					byte_out <= 8'h00;
					start_tx <= 1'b1;
				end
			end

			STAGE_5: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_6;
					start_tx <= 1'b0;
				end
				else begin 
					byte_out <= num_reg_tx;
					start_tx <= 1'b1;
				end
			end

			STAGE_6: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_7;
					start_tx <= 1'b0;
					data_buff <= data_in;
				end
				else begin 
					byte_out <= num_reg_tx << 8'h01;
					start_tx <= 1'b1;
				end
			end

			STAGE_7: begin

				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_8;
					start_tx <= 1'b0;
				end
				else begin 
					if(!start_data_delay) begin
						byte_out <= data_buff[15:8];
						start_tx <= 1'b1;
					end
				end

			end

			STAGE_8: begin

				if(!busy_tx && previous_strb_0) begin

					if(num_reg == num_reg_tx)begin
						state <= STAGE_9;
						num_reg <= 8'h01;
						reset_crc <= 1'b1;
					end
					else begin
						num_reg <= num_reg + 8'h01;
						start_data_delay <= 1'b1;
						state <= STAGE_7;
					end

					start_tx <= 1'b0;
				end
				else begin
					byte_out <= data_buff[7:0];
					start_tx <= 1'b1;
				end

			end

			STAGE_9: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_10;
					start_tx <= 1'b0;
				end
				else begin 
					byte_out <= crc_16[7:0];
					start_tx <= 1'b1;
				end
			end

			STAGE_10: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_11;
					start_tx <= 1'b0;
					DE <= 1'b0;
				end
				else begin 
					byte_out <= crc_16[15:8];
					start_tx <= 1'b1;
				end
			end

			STAGE_11: begin
				if(answer_received && !previous_strb_1) begin
					DE <= 1'b1;
					start_delay <= 1'b1;
					state <= STAGE_12;
				end
				else begin end
			end

			STAGE_12: begin
				if(!start_delay) begin
					state <= STAGE_13;
					reset_crc <= 1'b0;
				end
				else begin end
			end

			STAGE_13: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_14;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= adr;
					start_tx <= 1'b1;
				end
			end

			STAGE_14: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_15;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= func_code_read;
					start_tx <= 1'b1;
				end
			end

			STAGE_15: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_16;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= adr_first_reg_rx[15:8];
					start_tx <= 1'b1;
				end
			end

			STAGE_16: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_17;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= adr_first_reg_rx[7:0];
					start_tx <= 1'b1;
				end
			end

			STAGE_17: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_18;
					start_tx <= 1'b0;
				end
				else begin
					byte_out <= 8'h00;
					start_tx <= 1'b1;
				end
			end

			STAGE_18: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_19;
					start_tx <= 1'b0;
					reset_crc <= 1'b1;
				end
				else begin
					byte_out <= num_reg_rx;
					start_tx <= 1'b1;
				end
			end

			STAGE_19: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_20;
					start_tx <= 1'b0;
				end
				else begin 
					byte_out <= crc_16[7:0];
					start_tx <= 1'b1;
				end
			end

			STAGE_20: begin
				if(!busy_tx && previous_strb_0) begin
					state <= STAGE_21;
					start_tx <= 1'b0;
					DE <= 1'b0;
				end
				else begin 
					byte_out <= crc_16[15:8];
					start_tx <= 1'b1;
				end
			end

			STAGE_21: begin
				if(answer_received && !previous_strb_1) begin
					DE <= 1'b1;
					transfer_done <= 1'b1;
					start_delay <= 1'b1;
					state <= IDLE;
				end
				else begin end
			end

			default: state <= IDLE;

		endcase

	end

end
endmodule