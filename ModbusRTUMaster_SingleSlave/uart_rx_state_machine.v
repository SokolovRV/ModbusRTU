module uart_rx_state_machine (
											input clk,
											input reset,
											input rx,
																output reg [7:0] data,
																output reg 		 data_update
																										);

parameter         baudrate         =  187_500;
parameter         clk_freq_MHz     =  80;

localparam [15:0] clk_per_baud     =  (clk_freq_MHz * 1_000_000) / baudrate;
localparam [15:0] half_baud_period =  clk_per_baud >> 1;

localparam [3:0]  IDLE             =  4'b0000;
localparam [3:0]  START_BIT 	     =  4'b0001;
localparam [3:0]  BIT_0            =  4'b0010;
localparam [3:0]  BIT_1            =  4'b0011;
localparam [3:0]  BIT_2            =  4'b0100;
localparam [3:0]  BIT_3            =  4'b0101;
localparam [3:0]  BIT_4            =  4'b0110;
localparam [3:0]  BIT_5            =  4'b0111;
localparam [3:0]  BIT_6            =  4'b1000;
localparam [3:0]  BIT_7            =  4'b1001;
localparam [3:0]  STOP_BIT         =  4'b1010;

       reg [3:0]  state            =  4'b0000;
       reg [3:0]  next_state       =  4'b0000;

       reg [15:0] base_count       = 16'h0000;
       reg [7:0]  data_buff        = 16'h0000;

       reg        previous_strb    =  1'b0;
       reg        start_recieve    =  1'b0;
       reg        read_flag        =  1'b0;


initial begin
	
	data        = 8'h00;
	data_update = 1'b0;

end

always @(posedge clk) begin
	
	if(reset) begin
		
		base_count 	   <= 16'h0000;
		state 		   <= IDLE;
		next_state     <= IDLE;
		previous_strb  <= 1'b0;
		data           <= 8'h00;
		data_update    <= 1'b0;
		start_recieve  <= 1'b0;
		read_flag      <= 1'b0;
		
	end
	else begin
	
		previous_strb <= rx;

	    if(start_recieve)
			base_count <= base_count + 16'h0001;
		else
			base_count <= 16'h0000;

		if(base_count == clk_per_baud) begin
			base_count <= 16'h0000;
			state <= next_state;
			read_flag <= 1'b0;
		end
		else begin end

		case(state)

			IDLE: begin
				if(!rx && previous_strb) begin
					next_state <= START_BIT;
					start_recieve <= 1'b1;
					base_count <= half_baud_period;
				end
				else begin end
			end

			START_BIT: begin
				data_update <= 1'b0;
				
				next_state <= BIT_0;
			end

			BIT_0: begin
			 if(!read_flag) begin
				data_buff[0] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_1;
			end

			BIT_1: begin
			 if(!read_flag) begin
				data_buff[1] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_2;
			end

			BIT_2: begin
			 if(!read_flag) begin
				data_buff[2] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_3;
			end

			BIT_3: begin
			 if(!read_flag) begin
				data_buff[3] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end

				next_state <= BIT_4;
			end

			BIT_4: begin
			 if(!read_flag) begin
				data_buff[4] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_5;
			end

			BIT_5: begin
			 if(!read_flag) begin
				data_buff[5] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_6;
			end

			BIT_6: begin
			 if(!read_flag) begin
				data_buff[6] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end
				
				next_state <= BIT_7;
			end

			BIT_7: begin
			 if(!read_flag) begin
				data_buff[7] <= rx;
				read_flag <= 1'b1;
			 end
			 else begin end

				next_state <= STOP_BIT;
			end

			STOP_BIT: begin
				if(rx) begin
					data <= data_buff;
					data_update <= 1'b1;
				end
				else begin end
				
				start_recieve <= 1'b0;
				state <= IDLE;
			end

			default: begin
				state <= IDLE;
			end
		endcase

	end

end


endmodule