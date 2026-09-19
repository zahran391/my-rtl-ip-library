module common_bus 
(
    input [2:0] sel,          // Selection lines S2, S1, S0
// in --> بنحطها جنب الريجيسترات لتعبر عن انها داخله للباص لكن في التوب بتربطها بخرج الريجيستر 
    // Inputs from  registers and memory read data
    input [11:0] ar_in,       //  [AR] --> is 12 bits, zero-extended to 16 in case of bus output
    input [11:0] pc_in,       //  [PC] --> is 12 bits, zero-extended to 16 in case of bus output
    input [15:0] dr_in,
    input [15:0] ac_in,
    input [15:0] ir_in,
    input [15:0] tr_in,
    input [15:0] mem_in,      // Data coming from RAM
    
    output reg [15:0] bus_out // The shared common bus line to all registers and memory in the system
);

    always @(*) 
    begin
        case (sel)
            3'b000: bus_out = 16'd0;                // All 0s
            3'b001: bus_out = {4'b0000, ar_in};     // AR (12-bit extended to 16-bit) اول اربع بيتات بصفر
            3'b010: bus_out = {4'b0000, pc_in};     // PC (12-bit extended to 16-bit) اول اربع بيتات بصفر
            3'b011: bus_out = dr_in;                // DR
            3'b100: bus_out = ac_in;                // AC
            3'b101: bus_out = ir_in;                // IR
            3'b110: bus_out = tr_in;                // TR
            3'b111: bus_out = mem_in;               // Memory read data
            default: 
            begin
              bus_out = 16'd0;
            end 
        endcase
    end

endmodule
