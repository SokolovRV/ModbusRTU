from jinja2 import Template

input_module = Template("""
module data_mux_{{t_adress}}_{{t_prefix}} (
											input        clk,
											input [7:0]  selector,
										{%- for n in range(t_n_ports_w) %}
											input [15:0] data_{{n+t_first_reg_w}}_{{t_adress}},
										{%- endfor %}
											input 		 reset,
																		output reg [7:0]  adr,
																		output reg [15:0] adr_first_reg_tx,
																		output reg [7:0]  num_reg_tx,
																		output reg [15:0] adr_first_reg_rx,
																		output reg [7:0]  num_reg_rx,
																		output reg [15:0] data_out
																												);


parameter [7:0]  slave_adr            = {{t_adress}};
parameter [15:0] adr_first_reg_write  = {{t_first_reg_w}};
parameter [7:0]  num_reg_write		  = {{t_n_ports_w}};
parameter [15:0] adr_first_reg_read   = {{t_first_reg_r}};
parameter [7:0]  num_reg_write_read	  = {{t_n_ports_r}};


initial begin
	data_out         = 16'h0000;
	adr 		     = slave_adr;
	adr_first_reg_tx = adr_first_reg_write;
	num_reg_tx 		 = num_reg_write;
	adr_first_reg_rx = adr_first_reg_read;
	num_reg_rx 		 = num_reg_write_read;
end

always @(posedge clk) begin

	if(reset)
		data_out <= 16'h0000;
	else begin

		case(selector)
		{%- for n in range(t_n_ports_w) %}
			{{n+1}}: data_out <= data_{{n+t_first_reg_w}}_{{t_adress}};
		{%- endfor %}

			default: data_out <= 16'h0000;

		endcase

	end

end
endmodule
""")

output_module = Template("""
module data_demux_{{t_adress}}_{{t_prefix}} (
								input 		 clk,
								input [7:0]  adr,
								input [7:0]  n_data,
								input [15:0] data_in,
								input 		 data_strb,
								input        crc_validate,
								input 		 reset,
														{%- for n in range(t_n_ports_r) %}
															output [15:0] data_{{n+t_first_reg_r}}_{{t_adress}}{% if (n+1)<t_n_ports_r %},{% endif %}
														{%- endfor %}
																								);

parameter [7:0]  slave_id        = {{t_adress}};
parameter [7:0]  number_of_reg   = {{t_n_ports_r}};

(*ramstyle = "no_rw_check"*)reg [15:0] mem [number_of_reg:0];
	
        reg        previous_strb_0 =  1'b0;
		
		reg [15:0] data_buff       = 16'h0000;
		reg [7:0]  n                =  8'h00;
		
initial begin
{%- for n in range(t_n_ports_r) %}
	data_{{n+t_first_reg_r}}_{{t_adress}} = 16'h0000;
{%- endfor %}
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
	{%- for n in range(t_n_ports_r) %}
		data_{{n+t_first_reg_r}}_{{t_adress}} <= 16'h0000;
	{%- endfor %}
	end
	else begin
	
		case(n)
		{%- for n in range(t_n_ports_r) %}
			{{n+1}}: data_{{n+t_first_reg_r}}_{{t_adress}} <= data_buff;
		{%- endfor %}
	
			default: begin end
		endcase
	
	end
		
end

endmodule
""")

select_module = Template("""
module slave_select_{{t_prefix}} (
							input        clk,
						{%- for n in t_n_slaves %}

							input [7:0]  adr_{{n}},
							input [15:0] adr_first_reg_tx_{{n}},
							input [7:0]  num_reg_tx_{{n}},
							input [15:0] adr_first_reg_rx_{{n}},
							input [7:0]  num_reg_rx_{{n}},
							input [15:0] data_in_{{n}},
						{%- endfor %}

							input        transfer_done,
							input		 reset,
															output reg [7:0]  adr,
															output reg [15:0] adr_first_reg_tx,
															output reg [7:0]  num_reg_tx,
															output reg [15:0] adr_first_reg_rx,
															output reg [7:0]  num_reg_rx,
															output reg [15:0] data_out
																											);

parameter [7:0] number_of_slaves = {{t_cnt_slaves}};

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
		{%- for n in range(t_cnt_slaves) %}
			{{n+1}}: begin
				adr 			 <= adr_{{t_n_slaves[n]}};
				adr_first_reg_rx <= adr_first_reg_rx_{{t_n_slaves[n]}};
				adr_first_reg_tx <= adr_first_reg_tx_{{t_n_slaves[n]}};
				num_reg_rx       <= num_reg_rx_{{t_n_slaves[n]}};
				num_reg_tx       <= num_reg_tx_{{t_n_slaves[n]}};
				data_out         <= data_in_{{t_n_slaves[n]}};	
			end
		{%- endfor %}

			default: begin end
		endcase

	end

end

endmodule
""")

print('\n ::: Modbus ports modules generator (Verylog) :::\n'
      ' ::: version: 1.0 :::\n '
      '::: developer: Sokolov R.V. :::\n '
      '::: For more information read the txt file in root folder ::: \n\n')

mode = int(input('What modules need to be generated (select 1 or 2):\n'
                 '      1. - input + output modules \n'
                 '      2. - select module\n'
                 '                              Your choice: '))
print('\n')

if mode == 1:
    p_prefix = input('\nInput prefix for modules names (data_mux(/demux)_{your prefix}.v): ')
    p_address = int(input('Input address of slave device: '))
    p_n_ports_w = int(input('Input count of INPUT ports: '))
    p_first_reg_w = int(input('Input number of first register for WRITE in slave (INPUT): '))
    p_n_ports_r = int(input('Input count of OUTPUT ports: '))
    p_first_reg_r = int(input('Input number of first register for READ in slave (OUTPUT): '))
    txt_in = input_module.render(
        t_prefix = p_prefix,
        t_adress = p_address,
        t_n_ports_w = p_n_ports_w,
        t_n_ports_r = p_n_ports_r,
        t_first_reg_w = p_first_reg_w,
        t_first_reg_r = p_first_reg_r
    )
    txt_out = output_module.render(
        t_prefix = p_prefix,
        t_adress = p_address,
        t_n_ports_r = p_n_ports_r,
        t_first_reg_r = p_first_reg_r
    )
    file_name_in = 'data_mux_' + p_prefix + '.v'
    file_name_out = 'data_demux_' + p_prefix + '.v'
    file = open(file_name_in, 'w')
    file.write(txt_in)
    file.close()
    file = open(file_name_out, 'w')
    file.write(txt_out)
    file.close()
    print('\n >>> ' + file_name_in + '\n >>> ' + file_name_out + '  - files was generated in root folder! \n\n')

if mode == 2:
    n_slaves = int(input('How many slave devices are used: '))
    p_n_slaves = list(range(n_slaves))
    for i in range(n_slaves):
        p_n_slaves[i] = int(input('     Input address of slave device number - ' + str(i+1) + ': '))
    p_prefix = input('\nInput prefix for module name (slave_select_{your prefix}.v): ')
    txt = select_module.render(
        t_prefix = p_prefix,
        t_cnt_slaves = n_slaves,
        t_n_slaves = p_n_slaves)
    file_name = 'slave_select_'+p_prefix+'.v'
    file = open(file_name,'w')
    file.write(txt)
    file.close()
    print('\n >>> ' + file_name + '  - file was generated in root folder! \n\n')

input(' >>> for exit push Enter ... <<<')