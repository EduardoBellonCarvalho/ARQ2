module top (
    input        CLOCK_50,
    input  [3:0] KEY,  
    input [9:0] SW,      
    output [9:0] LEDR,       
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 
);
  wire clk = CLOCK_50;
  wire reset = ~KEY[0]; 

    wire [31:0] PC, Instr, Address, WriteData, ReadData, memreaddata;
  wire MemWrite, endcontrol;
    wire [31:0] ram_data_out;
    
  reg [25:0] counter;
always(@posedge CLOCK_50) begin
  counter <= counter + 1;
end

  wire clock_1hz = counter[25];
  wire cpu_clk = SW[0] ? clock_1hz: CLOCK_50;
    
wire isIO = Address[8]; // 0x0000_0100
wire isRAM = !isIO;
localparam IO_SW_bit = 5; // 0x0000_0120

wire [31:0] IO_readdata;
assign IO_readdata = Address[IO_SW_bit] ? {22'b0, SW} : 32'b0;
assign memreaddata = isRAM ? ram_data_out : IO_readdata;
    
    riscvpipeline cpu (
        .clk(cpu_clk), .reset(reset), .PC(PC), .Instr(Instr),
        .Address(Address), .WriteData(WriteData), .MemWrite(MemWrite),
        .ReadData(memreaddata), .endcontrol(endcontrol)
    );

    mem ram (.clk(clk),.we(MemWrite && isRAM),.a(Address),.wd(WriteData),.rd(ram_data_out),.pc(PC),.instr(Instr));

    reg [31:0] cycle_count;
    always @(posedge cpu_clk) begin
        if (reset) cycle_count <= 0;
      else if (!endcontrol) cycle_count <= cycle_count + 1;
    end

    assign LEDR = PC[11:2]; // LEDs mostram o PC

    // Mostra contador nos displays
    dec7seg d0 (cycle_count[3:0],   HEX0);
    dec7seg d1 (cycle_count[7:4],   HEX1);
    dec7seg d2 (cycle_count[11:8],  HEX2);
    dec7seg d3 (cycle_count[15:12], HEX3);
    dec7seg d4 (cycle_count[19:16], HEX4);
    dec7seg d5 (cycle_count[23:20], HEX5);
endmodule
