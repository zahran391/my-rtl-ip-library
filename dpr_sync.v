module dpr_sync #(
parameter MEM_WIDTH = 8, // Matched with ALU DATA_SIZE
parameter MEM_DEPTH = 16, // Number of memory locations
parameter ADDR_SIZE = 4 // Address bits for 16 locations
)
(
input wire clk,
input wire rst_n, // Active Low Reset to match ALU
input wire wr_en,
input wire rd_en,
input wire blk_select,
input wire [MEM_WIDTH-1:0] din, // Connects to ALU RESULT
input wire [ADDR_SIZE-1:0] addr_rd,
input wire [ADDR_SIZE-1:0] addr_wr,
output reg [MEM_WIDTH-1:0] dout
);

// Memory Array Architecture (16 x 8-bit)
reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

// Read/Write Synchronous Operation
always @(posedge clk or negedge rst_n)
begin
if (!rst_n) begin
dout <= {MEM_WIDTH{1'b0}};
end else begin
if (blk_select) begin
if (wr_en) begin
mem[addr_wr] <= din;
end
if (rd_en) begin
dout <= mem[addr_rd];
end
end
end
end

endmodule
