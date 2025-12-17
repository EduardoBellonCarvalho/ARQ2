module mem (
    input             clk,
    input      [31:0] pc_addr,
    output     [31:0] instr_out,
    input      [31:0] data_addr,
    input      [31:0] data_in,
    input             mem_write,
    output     [31:0] data_out
);
    reg [31:0] RAM [0:1023]; // 4KB RAM

    initial begin
      $readmemh("riscv.hex", RAM); 
    end

    assign instr_out = RAM[pc_addr[11:2]];
    assign data_out  = RAM[data_addr[11:2]];

    always @(posedge clk) begin
        if (mem_write) RAM[data_addr[11:2]] <= data_in;
    end
endmodule
