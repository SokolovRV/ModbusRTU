module digital_fltr	(

						input clk,
						input signal_in,
											output reg signal_out
																	);

parameter [7:0] clk_cnt = 20;

      reg [7:0] cnt_pos = 8'h00;
      reg [7:0] cnt_neg = 8'h00;

initial begin
	signal_out <= 1'b0;
end

always @(posedge clk) begin
	if(signal_in) begin
		cnt_neg <= 8'h00;
		cnt_pos <= cnt_pos + 8'h01;
	end
	else begin
		cnt_neg <= cnt_neg + 8'h01;
		cnt_pos <= 8'h00;
	end

	if(cnt_pos > clk_cnt) begin
		signal_out <= 1'b1;
		cnt_pos <= clk_cnt;
	end
	else begin end

	if(cnt_neg > clk_cnt) begin
		signal_out <= 1'b0;
		cnt_neg <= clk_cnt;
	end
	else begin end

end
endmodule 

