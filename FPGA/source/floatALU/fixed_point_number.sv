`include "../configuration.vh"

module fixed_point_number(	/*input		wire	[`FLOAT_NUMBER_LENGHT - 1:0]	data_a,
									input		wire	[`FLOAT_NUMBER_LENGHT - 1:0]	data_b,
									input		wire	[`ALU_LEN - 1:0]					action,*/
									
									output	wire	[`FLOAT_NUMBER_LENGHT - 1:0]	result
									);
									
	reg	[`FLOAT_NUMBER_LENGHT - 1:0]	data_a;
	reg	[`FLOAT_NUMBER_LENGHT - 1:0]	data_b;
	reg	[`ALU_LEN - 1:0]					action;
	
	reg 	[`FLOAT_NUMBER_LENGHT - 1:0]	mem_in_a	[25:0];
	reg 	[`FLOAT_NUMBER_LENGHT - 1:0]	mem_in_b	[25:0];
	reg 	[`ALU_LEN - 1:0]					mem_in_action	[25:0];
	reg	[5:0]	k = 0;
	
	wire	[`FLOAT_NUMBER_INTEGER_PART - 1:0]	data_a_int_part;
	wire	[`FLOAT_NUMBER_FLOAT_PART 	 - 1:0]	data_a_real_part;
	wire													data_a_sign;
	
	assign {data_a_sign, data_a_int_part, data_a_real_part} 	= data_a;
	 
	wire	[`FLOAT_NUMBER_INTEGER_PART - 1:0]	data_b_int_part;
	wire	[`FLOAT_NUMBER_FLOAT_PART 	 - 1:0]	data_b_real_part;
	wire													data_b_sign;
	
	assign {data_b_sign, data_b_int_part, data_b_real_part} 	= data_b;
	
	reg	[`FLOAT_NUMBER_INTEGER_PART:0]		result_int_part	= 0;
	reg	[`FLOAT_NUMBER_FLOAT_PART	:0]		result_real_part	= 0;
	reg													sign					= 0;	

	reg [((`FLOAT_NUMBER_INTEGER_PART + `FLOAT_NUMBER_FLOAT_PART ) << 1) - 1 : 0] mlt = 0;
	reg [5:0] i = 0;
	reg	[`FLOAT_NUMBER_LENGHT - 2:0]	mlt_b;
	reg	[`FLOAT_NUMBER_LENGHT - 2:0]	num;
	reg	[`FLOAT_NUMBER_INTEGER_PART:0]	mult_int_part	= 0;
	reg	[`FLOAT_NUMBER_FLOAT_PART	:0]		mult_real_part	= 0;
	
	assign result = {sign, result_int_part[`FLOAT_NUMBER_INTEGER_PART - 1:0], result_real_part[`FLOAT_NUMBER_FLOAT_PART - 1:0]};
	
	mult	mult_inst (
	.dataa ( dataa_sig ),
	.datab ( datab_sig ),
	.result ( result_sig )
	);
	
	divider	divider_inst (
	.denom ( denom_sig ),
	.numer ( numer_sig ),
	.quotient ( quotient_sig ),
	.remain ( remain_sig )
	);

	
	
	initial
	begin
		$display("initial started");
		$readmemb("C:/Users/ISM/OneDrive/Verilog_modules/jerk_acc_speed/source/fixed_point_number_data_a.mem", mem_in_a);	
		$readmemb("C:/Users/ISM/OneDrive/Verilog_modules/jerk_acc_speed/source/fixed_point_number_data_b.mem", mem_in_b);	
		$readmemb("C:/Users/ISM/OneDrive/Verilog_modules/jerk_acc_speed/source/fixed_point_number_action.mem", mem_in_action);	

		for (k = 24; k < 'd26; k = k + 1)
		 begin
			data_a = mem_in_a[k];
			data_b = mem_in_b[k];
			action = mem_in_action[k];
			#500;
			$display("-----%d-----", k);
			$display("action = %d", action);

			sign = data_a_sign ^ data_b_sign;

			mlt_b = {data_b_int_part, data_b_real_part};

			$display("mult_int_part = %b, mult_real_part = %b", 
						 $unsigned(mult_int_part), 
						 $unsigned(mult_real_part));



			mlt_b = {data_b_int_part, data_b_real_part};

			mult_real_part = data_a_real_part;
			mult_int_part = data_a_int_part;

			for (i = 0; i < `FLOAT_NUMBER_LENGHT - 2; i = i + 1)
			begin
				$display("mult_int_part = %b, mult_real_part = %b", 
						 $unsigned(mult_int_part), 
						 $unsigned(mult_real_part));
				mlt = mlt + (mlt_b[i] ? {mult_int_part, mult_real_part[`FLOAT_NUMBER_FLOAT_PART - 1 : 0]} : 'b0);
				/*if (mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] > `FLOAT_NUMBER_MAX_FLOAT_PART)
				begin
					mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] = 
					mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] - `FLOAT_NUMBER_MAX_FLOAT_PART_MULT - 1;
					mlt[((`FLOAT_NUMBER_INTEGER_PART + `FLOAT_NUMBER_FLOAT_PART ) << 1) - 1 : (`FLOAT_NUMBER_FLOAT_PART << 1)] = 
					mlt[((`FLOAT_NUMBER_INTEGER_PART + `FLOAT_NUMBER_FLOAT_PART ) << 1) - 1 : (`FLOAT_NUMBER_FLOAT_PART >> 1)] + 1;
				end*/
				mult_int_part = mult_int_part << 1;
				mult_real_part = mult_real_part << 1;
				mult_int_part[0] = mult_real_part[`FLOAT_NUMBER_FLOAT_PART];
				/*if (mult_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
				begin
					mult_real_part = mult_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
					mult_int_part = mult_int_part + 1;
				end*/
			end				

			mlt = mlt >> `FLOAT_NUMBER_FLOAT_PART;
			result_real_part = mlt[(`FLOAT_NUMBER_FLOAT_PART - 1) : 0];
			mlt = mlt >> `FLOAT_NUMBER_FLOAT_PART;
			result_int_part = mlt[(`FLOAT_NUMBER_INTEGER_PART - 1) : 0];				

			if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
			begin
				result_int_part = result_int_part + 1;
				result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
			end

			$display("data_a_sign = %b, data_a_int = %d, data_a_real = %d", 
						 $unsigned(data_a_sign), 
						 $unsigned(data_a_int_part), 
						 $unsigned(data_a_real_part));
						 
			$display("data_b_sign = %b, data_b_int = %d, data_b_real = %d", 
						 $unsigned(data_b_sign), 
						 $unsigned(data_b_int_part), 
						 $unsigned(data_b_real_part));
			#10;
			$display("result_sign = %b, result_int = %d, result_real = %d", 
						 $unsigned(sign), 
						 $unsigned(result_int_part), 
						 $unsigned(result_real_part));			
		 end
		 $display("initial finished");
		 $monitor("mult %b %b", mult_int_part, mult_real_part);
    $finish;
	end
		
	
	always @(data_a_sign or data_a_int_part or data_a_real_part or data_b_sign or data_b_int_part or data_b_real_part or action)
	begin
		result_int_part = 0;
		result_real_part = 0;
		sign = 0;
		mlt = 0;
		case (action)
			`FLOAT_ADD:
			begin
				case ({data_a_sign, data_b_sign})
					2'b00:
					begin
						sign = 0;
						result_real_part = data_a_real_part + data_b_real_part;
						if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
						begin
							result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
							result_int_part = 1;
						end
						result_int_part = data_a_int_part + data_b_int_part + result_int_part;
					end
					2'b01:
					begin
						if ({data_a_int_part, data_a_real_part} < {data_b_int_part, data_b_real_part})
						begin
							sign = 1;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_b_int_part - data_a_int_part - 1;
								result_real_part = data_b_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_a_real_part;
							end
							else
							begin
								result_int_part = data_b_int_part - data_a_int_part;
								result_real_part = data_b_real_part - data_a_real_part;								
							end
						end
						else
						begin
							sign = 0;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_a_int_part - data_b_int_part;
								result_real_part = data_a_real_part - data_b_real_part;
							end
							else
							begin
								result_int_part = data_a_int_part - data_b_int_part - 1;
								result_real_part = data_a_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_b_real_part;								
							end
						end
					end
					2'b10:
					begin
						if ({data_a_int_part, data_a_real_part} <= {data_b_int_part, data_b_real_part})
						begin
							sign = 0;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_b_int_part - data_a_int_part - 1;
								result_real_part = data_b_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_a_real_part;
							end
							else
							begin
								result_int_part = data_b_int_part - data_a_int_part;
								result_real_part = data_b_real_part - data_a_real_part;
							end
						end
						else
						begin
							sign = 1;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_a_int_part - data_b_int_part;
								result_real_part = data_a_real_part - data_b_real_part;
							end
							else
							begin
								result_int_part = data_a_int_part - data_b_int_part - 1;
								result_real_part = data_a_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_b_real_part;								
							end
						end
					end
					2'b11:
					begin
						sign = 1;
						result_real_part = data_a_real_part + data_b_real_part;
						if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
						begin
							result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
							result_int_part = 1;
						end
						result_int_part = data_a_int_part + data_b_int_part + result_int_part;
					end
					default: ;				
				endcase
			end
			`FLOAT_SUB:
			begin
				case ({data_a_sign, data_b_sign})
					2'b01:
					begin
						sign = 0;
						result_real_part = data_a_real_part + data_b_real_part;
						if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
						begin
							result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
							result_int_part = 1;
						end
						result_int_part = data_a_int_part + data_b_int_part + result_int_part;
					end
					2'b00:
					begin
						if ({data_a_int_part, data_a_real_part} < {data_b_int_part, data_b_real_part})
						begin
							sign = 1;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_b_int_part - data_a_int_part - 1;
								result_real_part = data_b_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_a_real_part;
							end
							else
							begin
								result_int_part = data_b_int_part - data_a_int_part;
								result_real_part = data_b_real_part - data_a_real_part;								
							end
						end
						else
						begin
							sign = 0;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_a_int_part - data_b_int_part;
								result_real_part = data_a_real_part - data_b_real_part;
							end
							else
							begin
								result_int_part = data_a_int_part - data_b_int_part - 1;
								result_real_part = data_a_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_b_real_part;								
							end
						end
					end
					2'b11:
					begin
						if ({data_a_int_part, data_a_real_part} <= {data_b_int_part, data_b_real_part})
						begin
							sign = 0;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_b_int_part - data_a_int_part - 1;
								result_real_part = data_b_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_a_real_part;
							end
							else
							begin
								result_int_part = data_b_int_part - data_a_int_part;
								result_real_part = data_b_real_part - data_a_real_part;
							end
						end
						else
						begin
							sign = 1;
							if (data_a_real_part >= data_b_real_part)
							begin
								result_int_part = data_a_int_part - data_b_int_part;
								result_real_part = data_a_real_part - data_b_real_part;
							end
							else
							begin
								result_int_part = data_a_int_part - data_b_int_part - 1;
								result_real_part = data_a_real_part + `FLOAT_NUMBER_MAX_FLOAT_PART + 1 - data_b_real_part;								
							end
						end
					end
					2'b10:
					begin
						sign = 1;
						result_real_part = data_a_real_part + data_b_real_part;
						if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
						begin
							result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
							result_int_part = 1;
						end
						result_int_part = data_a_int_part + data_b_int_part + result_int_part;
					end
					default: ;				
				endcase
			end
			`FLOAT_MUL:
			begin
				sign = data_a_sign ^ data_b_sign;

				mlt_b = {data_b_int_part, data_b_real_part};

				mult_real_part = data_a_real_part;
				mult_int_part = data_a_int_part;

				for (i = 0; i < `FLOAT_NUMBER_LENGHT - 2; i = i + 1)
				begin
					mlt = mlt + (mlt_b[i] ? {mult_int_part, mult_real_part[`FLOAT_NUMBER_FLOAT_PART - 1 : 0]} : 'b0);
					/*if (mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] > `FLOAT_NUMBER_MAX_FLOAT_PART)
					begin
						mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] = 
						mlt[((`FLOAT_NUMBER_FLOAT_PART << 1) - 1) : `FLOAT_NUMBER_FLOAT_PART - 1] - `FLOAT_NUMBER_MAX_FLOAT_PART_MULT - 1;
						mlt[((`FLOAT_NUMBER_INTEGER_PART + `FLOAT_NUMBER_FLOAT_PART ) << 1) - 1 : (`FLOAT_NUMBER_FLOAT_PART << 1)] = 
						mlt[((`FLOAT_NUMBER_INTEGER_PART + `FLOAT_NUMBER_FLOAT_PART ) << 1) - 1 : (`FLOAT_NUMBER_FLOAT_PART >> 1)] + 1;
					end*/
					mult_int_part = mult_int_part << 1;
					mult_real_part = mult_real_part << 1;
					mult_int_part[0] = mult_real_part[`FLOAT_NUMBER_FLOAT_PART];
					/*if (mult_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
					begin
						mult_real_part = mult_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
						mult_int_part = mult_int_part + 1;
					end*/
				end				

				mlt = mlt >> `FLOAT_NUMBER_FLOAT_PART;
				result_real_part = mlt[(`FLOAT_NUMBER_FLOAT_PART - 1) : 0];
				mlt = mlt >> `FLOAT_NUMBER_FLOAT_PART;
				result_int_part = mlt[(`FLOAT_NUMBER_INTEGER_PART - 1) : 0];				

				if (result_real_part > `FLOAT_NUMBER_MAX_FLOAT_PART)
				begin
					result_int_part = result_int_part + 1;
					result_real_part = result_real_part - `FLOAT_NUMBER_MAX_FLOAT_PART - 'b1;
				end
			end
			`FLOAT_DIV:
			begin
				sign = data_a_sign ^ data_b_sign;
				result_int_part = 0;
				result_real_part = 0;
			end
			
			default: 
			begin
				result_int_part = 0;
				result_real_part = 0;
				sign = 0;
			end
		endcase
	end
	
endmodule
