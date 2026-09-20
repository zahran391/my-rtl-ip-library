module arithmetic_unit #(parameter DATA_SIZE = 8, OPCODE_SIZE=3)
(
input [DATA_SIZE-1:0]A,B,
input[OPCODE_SIZE-1:0]OPCODE,
input clk,rst_n, CIN,
output reg [DATA_SIZE-1:0]RESULT,
output reg COUT
);

reg[DATA_SIZE-1:0]A_regis, B_regis;
reg[OPCODE_SIZE-1:0]OPCODE_regis;
reg CIN_regis;

always @(posedge clk or negedge rst_n) begin

if(~rst_n) // active low zero
begin
A_regis <= 0;
B_regis <= 0;
COUT <= 0;
CIN_regis <= 0;
OPCODE_regis <= 0;
RESULT <= 0;
end
// else ياخد القيم من الريجيستر
begin
A_regis <= A; B_regis <= B; CIN_regis <= CIN; OPCODE_regis <= OPCODE;
end
end

always @(*) //opcode
begin
case (OPCODE_regis)
3'b000: {COUT, RESULT} <= A_regis+B_regis+CIN_regis;
3'b001: {COUT, RESULT} <= A_regis-B_regis-CIN_regis;
3'b010: {COUT, RESULT} <= A_regis+1;
3'b011: {COUT, RESULT} <= B_regis-1;
default:begin
{COUT, RESULT} <= 0;
end
endcase
end

endmodule
