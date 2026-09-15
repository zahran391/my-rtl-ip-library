
module D_ff_counter_tb();
    reg clk, rstn;
    wire [3:0] out;

    D_ff_counter DUT (
        .clk(clk),
        .rstn(rstn),
        .out(out)
    );

    
    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    
    initial begin
        rstn = 0;
        @(negedge clk);
        rstn = 1;

        repeat (100) begin
            rstn = ($random % 10 != 0);
            @(negedge clk);
        end

        $stop;
    end
endmodule
