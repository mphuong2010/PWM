/*Down clocking module
Output clock frequency is the original frequency divided by an even number
*/
module	down_clocking_even(
input	i_clk,
input	i_rst_n,
input	[15:0] i_divisor,
output	o_clk
);

wire	[15:0] divisor;
wire	borrow;

minus_one	minus_one_0(
i_divisor,
divisor,
borrow
);

wire	go;
assign	go = ((i_divisor != 0) && i_rst_n);
reg	[15:0] counter;
reg	clk;
always@(posedge i_clk or negedge i_rst_n)
	if (!i_rst_n) begin
		counter <= 0;
		clk <= 0;
	end
	else if (go) begin
		if (counter >= divisor) begin
			counter <= 0;
			clk <= ~clk;
		end
		else counter <= counter + 1;
	end
assign	o_clk = go ? clk : i_clk;
endmodule