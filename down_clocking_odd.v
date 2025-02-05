/*
	Down clocking module
	Output clock frequency is the original frequency divided by an odd number
*/
module down_clocking_odd(
input	i_clk,
input	i_rst_n,
input	[15:0] i_divisor,
output	o_clk
);

reg	a,b;
wire c;

assign	c = (~a) & (~b);
wire	[15:0] divisor;
wire	borrow;
minus_one	minus_one_0(
i_divisor,
divisor,
borrow
);

wire	go;
assign	go = ((i_divisor != 0) && i_rst_n);
reg	[15:0] counter_0;

always@(posedge i_clk or negedge i_rst_n)
	if (!i_rst_n) begin
		a <= 0;
		counter_0 <= 0;	
	end
	else if (go) begin
		if (a) begin
			if (counter_0 >= divisor) begin
				counter_0 <= 0;
				a <= 0;
			end
			else 
				counter_0 <= counter_0 + 1;
		end
		else if (c)
			a <= c;
	end


reg	[15:0]counter_1;
always@(negedge i_clk or negedge i_rst_n)
	if (!i_rst_n) begin
		b <= 0;
		counter_1 <= 0;	
	end
	else if (go) begin
		if (b) begin
			if (counter_1 >= divisor) begin
				counter_1 <= 0;
				b <= 0;
			end
			else 
				counter_1 <= counter_1 + 1;
		end
		else if (c)
			b <= c;
	end

reg	clk;
always@(posedge c or negedge i_rst_n)
	if (!i_rst_n)
		clk <= 0;
	else	
		clk <= ~clk;

assign	o_clk = go ? clk : i_clk;

endmodule