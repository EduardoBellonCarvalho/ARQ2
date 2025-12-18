module mem (
    input  logic        clk, 
    input  logic        we,
    input  logic [31:0] a,  
    input  logic [31:0] wd,  
    output logic [31:0] rd, 
    input  logic [31:0] pc,  
    output logic [31:0] instr
);

    logic [31:0] RAM [0:255];


    initial
        $readmemh("riscv.hex", RAM);

    assign rd = RAM[a[31:2]]; 
    

    assign instr = RAM[pc[31:2]];


    always_ff @(posedge clk)
        if (we)
            RAM[a[31:2]] <= wd;

endmodule
