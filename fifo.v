module axi_fifo #(
    parameter DATA_WIDTH  = 64,
    parameter ENTRY_DEPTH = 16,
    parameter KEEP_WIDTH  = 8,
    parameter STRB_WIDTH  = 8,
    parameter ID_WIDTH    = 2,
    parameter DEST_WIDTH  = 2,
    parameter USER_WIDTH  = 4,
    parameter LAST_WIDTH  = 1,
    parameter ENTRY_WIDTH = DATA_WIDTH + KEEP_WIDTH + STRB_WIDTH + LAST_WIDTH + DEST_WIDTH + USER_WIDTH + ID_WIDTH // 89 Bits
) // Entry like mem in memory ** fifo is memory DEPTH WIDTH **
(
    input  wire                   ACLK,
    input  wire                   ARESETn,
    input  wire                   wr_en,
    input  wire                   rd_en,
    
    // ( Slave outputs)
    input  wire [DATA_WIDTH-1:0]  wr_data,
    input  wire [KEEP_WIDTH-1:0]  wr_keep,
    input  wire [STRB_WIDTH-1:0]  wr_strb,
    input  wire                   wr_last,
    input  wire [DEST_WIDTH-1:0]  wr_dest,
    input  wire [USER_WIDTH-1:0]  wr_user,
    input  wire [ID_WIDTH-1:0]    wr_id,

    output reg  [ENTRY_WIDTH-1:0] data_out, // for master input   
    output wire                   fifo_full,
    output wire                   fifo_empty
);

    localparam POINTER_WIDTH = $clog2(ENTRY_DEPTH);
     // هنستخدم طريقه البيت الزياده علشان يتشك من هو مليان ولا فاضي 
    // Memory array and Pointers (POINTER_WIDTH + 1 bit for full/empty detection)
    reg [ENTRY_WIDTH-1:0]  FIFO [0:ENTRY_DEPTH-1]; //like mem
    reg [POINTER_WIDTH:0]  wr_pointer, rd_pointer;

    // Full & Empty Conditions (Extra-bit logic)
    assign fifo_full  = (wr_pointer[POINTER_WIDTH] != rd_pointer[POINTER_WIDTH]) &&
                        (wr_pointer[POINTER_WIDTH-1:0] == rd_pointer[POINTER_WIDTH-1:0]);

    assign fifo_empty = (wr_pointer == rd_pointer);

    // Write Logic
    always @(posedge ACLK or negedge ARESETn) 
    begin
        if (!ARESETn) begin
            wr_pointer <= 0;
        end 
        else if (wr_en && !fifo_full) 
        begin
            // Packing Order strictly aligned with Layout: TDATA -> TKEEP -> TSTRB -> TLAST -> TDEST -> TUSER -> TID
            FIFO[wr_pointer[POINTER_WIDTH-1:0]] <= {wr_data, wr_keep, wr_strb, wr_last, wr_dest, wr_user, wr_id};
            wr_pointer                          <= wr_pointer + 1'b1;
        end
    end

    // Registered Read Logic
    always @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            rd_pointer <= 0;
            data_out   <= 0;
        end
        else if (rd_en && !fifo_empty) begin
            data_out   <= FIFO[rd_pointer[POINTER_WIDTH-1:0]];
            rd_pointer <= rd_pointer + 1'b1;
        end
    end

endmodule
