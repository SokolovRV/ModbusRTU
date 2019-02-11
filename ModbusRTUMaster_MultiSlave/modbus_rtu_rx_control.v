module modbus_rtu_rx_control (
											input        clk,
											input [7:0]  byte_in,
											input        update_rx,
											input        DE,
											input [15:0] crc_16,
											input        reset,
																			output reg [7:0]  adr,
																			output reg [15:0] data_out,
																			output reg [7:0]  n_data,
																			output reg        data_strb,
																			output reg		  crc_validate,
																			output reg        reset_crc,
																			output reg [15:0] error_code,
																			output reg [15:0] error_cnt,
																			output reg        connection,
																			output reg        answer_received
																															);

parameter  [17:0] timeout_us 	   =  1;
parameter  [6:0]  clk_freq_MHz     =  80;

localparam [23:0] main_timeout     =  timeout_us * clk_freq_MHz;
localparam [19:0] symbol_timeout   =  3_000 * clk_freq_MHz;
localparam [7:0]  func_code_write  =  8'h10;
localparam [7:0]  func_code_read   =  8'h03;

localparam [3:0] IDLE      = 4'b0000;
localparam [3:0] ID_DEF    = 4'b0001;
localparam [3:0] FUNC_DEF  = 4'b0010;

localparam [3:0] ERROR_0   = 4'b0011;
localparam [3:0] ERROR_1   = 4'b0100;
localparam [3:0] ERROR_2   = 4'b0101;

localparam [3:0] ACK       = 4'b0110;

localparam [3:0] READ_0    = 4'b0111;
localparam [3:0] READ_1    = 4'b1000;
localparam [3:0] READ_2    = 4'b1001;
localparam [3:0] READ_3    = 4'b1010;
localparam [3:0] READ_4    = 4'b1011;
localparam [3:0] READ_5    = 4'b1100;

	   reg [4:0] state             =  4'b0000;

	   reg [3:0]  err_code_buff    =  4'h0;
	   reg [7:0]  crc_low          =  8'h00;
	   reg [2:0]  ack_byte_count   =  3'b000;
	   reg [7:0]  number_of_data   =  8'h00;


	   reg        previous_strb_0  =  1'b0;
	   reg        previous_strb_1  =  1'b0;

	   reg        start_main_tmout =  1'b0;
	   reg        start_symb_tmout =  1'b0;

	   reg [23:0] cnt_main_tmout   = 24'h000000;
	   reg [19:0] cnt_symb_tmout   = 20'h00000;

initial begin
	adr             =  8'h00;
	data_out        = 16'h0000;
	n_data          =  8'h00;
	data_strb       =  1'b0;
	crc_validate    =  1'b0;
	reset_crc       =  1'b0;
	error_code      = 16'h0000;
	error_cnt       = 16'h0000;
	connection      =  1'b0;
	answer_received =  1'b0;
end


always @(posedge clk) begin
	
	if(reset)  begin
		error_cnt <= 16'h0000;
		cnt_symb_tmout <= 20'h00000;
		cnt_main_tmout <= 24'h000000;
		start_main_tmout <= 1'b0;
		start_symb_tmout <= 1'b0;
		state <= IDLE;
	end
	else begin
	
		answer_received <= 1'b0;
		
		previous_strb_0 <= DE;
		previous_strb_1 <= update_rx;

		if(start_main_tmout)
			cnt_main_tmout <= cnt_main_tmout + 24'h000001;
		else
			cnt_main_tmout <= 24'h000000;

		if(cnt_main_tmout == main_timeout) begin
			error_cnt <= error_cnt + 16'h0001;
			state <= IDLE;
			error_code[3:0] <= 4'b0001;
			start_main_tmout <= 1'b0;
			connection <= 1'b0;
		end
		else begin end

		if(start_symb_tmout)
			cnt_symb_tmout <= cnt_symb_tmout + 20'h00001;
		else
			cnt_symb_tmout <= 20'h00000;

		if(cnt_symb_tmout == symbol_timeout) begin
			error_cnt <= error_cnt + 16'h0001;
			state <= IDLE;
			error_code[3:0] <= 4'b0010;
			start_symb_tmout <= 1'b0;
			connection <= 1'b0;
			n_data <= 8'h00;
		end
		else begin end

		case(state)

			IDLE: begin
				start_symb_tmout <= 1'b0;
				data_strb <= 1'b0;
				crc_validate <= 1'b0;
				answer_received <= 1'b1;
				if(!DE && previous_strb_0) begin
					state <= ID_DEF;
					start_main_tmout <= 1'b1;
					reset_crc <= 1'b0;
				end
				else
					reset_crc <= 1'b1;
			end

			ID_DEF: begin
				if(update_rx && !previous_strb_1) begin
					state <= FUNC_DEF;
					start_main_tmout <= 1'b0;
					start_symb_tmout <= 1'b1;
					adr <= byte_in;
				end
				else begin end
			end

			FUNC_DEF: begin
				if(update_rx && !previous_strb_1) begin
					if(byte_in == func_code_write)
						state <= ACK;
					else
						if(byte_in == func_code_read)
							state <= READ_0;
							else
								state <= ERROR_0;

					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			ERROR_0: begin
				if(update_rx && !previous_strb_1) begin
					err_code_buff <= byte_in[3:0];
					state <= ERROR_1;
					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			ERROR_1: begin
				if(update_rx && !previous_strb_1) begin
					crc_low <= byte_in;
					reset_crc <= 1'b1;
					state <= ERROR_2;
					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			ERROR_2: begin
				if(update_rx && !previous_strb_1) begin
					if(crc_16 == {byte_in, crc_low})
						error_code <= {adr, err_code_buff, 4'b0000};
					else
						error_code[3:0] <= 4'b0100;

					error_cnt <= error_cnt + 16'h0001;
					connection <= 1'b0;
					cnt_symb_tmout <= 20'h00000;
					state <= IDLE;
				end
				else begin end
			end

			ACK: begin
				if(update_rx && !previous_strb_1) begin
					if(ack_byte_count == 3'b101) begin
						ack_byte_count <= 3'b000;
						state <= IDLE;
						reset_crc <= 1'b1;
					end
					else
						ack_byte_count <= ack_byte_count + 3'b001;

					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			READ_0: begin
				if(update_rx && !previous_strb_1) begin
					number_of_data <= byte_in >> 8'h01;
					n_data <= 8'h00;
					state <= READ_1;
					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			READ_1: begin
				if(update_rx && !previous_strb_1) begin
					data_out[15:8] <= byte_in;
					cnt_symb_tmout <= 20'h00000;
					n_data <= n_data + 8'h01;
					state <= READ_2;
				end
				else begin end
				data_strb <= 1'b0;
			end

			READ_2: begin
				if(update_rx && !previous_strb_1) begin
					data_out[7:0] <= byte_in;
					cnt_symb_tmout <= 20'h00000;
					if(n_data == number_of_data) begin
						state <= READ_3;
					end
					else begin
						state <= READ_1;
					end
					data_strb <= 1'b1;
				end
				else begin end
			end

			READ_3: begin
				data_strb <= 1'b0;
				if(update_rx && !previous_strb_1) begin
					crc_low <= byte_in;
					reset_crc <= 1'b1;
					state <= READ_4;
					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end

			READ_4: begin
				if(update_rx && !previous_strb_1) begin
					if(crc_16 == {byte_in, crc_low}) begin
						crc_validate <= 1'b1;
						n_data <= 8'h01;
						error_code <= 16'h0000;
						connection <= 1'b1;
						state <= READ_5;
					end
					else begin
						error_cnt <= error_cnt + 16'h0001;
						error_code[3:0] <= 4'b0100;
						connection <= 1'b0;
						state <= IDLE;
					end
					
					cnt_symb_tmout <= 20'h00000;
				end
				else begin end
			end
			
			READ_5: begin
				if(n_data == number_of_data)
					state <= IDLE;
				else
					n_data <= n_data + 8'h01;		
			end

			default: state <= IDLE;

		endcase


	end

end
endmodule







