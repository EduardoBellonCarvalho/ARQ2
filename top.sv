module top (
    input      CLOCK_50,
    input [3:0] KEY,  
    input [9:0] SW,      
    output [9:0] LEDR,      
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5

);
  wire clk = CLOCK_50;
  wire reset = ~KEY[0];
  
    wire [31:0] PC, Instr, Address, WriteData, ReadData, memreaddata, reg_t0, reg_t1;

  wire MemWrite, endcontrol;

    wire [31:0] ram_data_out;

   

  reg [25:0] counter;

always @(posedge CLOCK_50) begin

  if (reset) counter <= 0;

  else counter <= counter + 1;

end

  wire clock_1hz = counter[25];
  wire aux_clk = SW[0] ? clock_1hz: CLOCK_50;
  wire cpu_clk = aux_clk & ~SW[9];

   

wire isIO = Address[8]; // 0x0000_0100
wire isRAM = !isIO;
localparam IO_SW_bit = 5; // 0x0000_0120



wire [31:0] IO_readdata;

assign IO_readdata = Address[IO_SW_bit] ? {22'b0, SW} : 32'b0;
assign memreaddata = isRAM ? ram_data_out : IO_readdata;


    riscvpipeline cpu (

        .clk(cpu_clk), .reset(reset), .PC(PC), .Instr(Instr),

        .Address(Address), .WriteData(WriteData), .MemWrite(MemWrite),

        .ReadData(memreaddata), .endcontrol(endcontrol), .reg_t0(reg_t0), .reg_t1(reg_t1)

    );



    mem ram (.clk(clk),.we(MemWrite && isRAM),.a(Address),.wd(WriteData),.rd(ram_data_out),.pc(PC),.instr(Instr));

    reg [31:0] cycle_count;

    always @(posedge cpu_clk) begin

        if (reset) cycle_count <= 0;

      else if (!endcontrol) cycle_count <= cycle_count + 1;

    end


    assign LEDR = reset? 10'b0000000000 : PC[11:2];

    wire [31:0] hex_data;

    assign hex_data = SW[1] ? reg_t0 : SW[2] ? reg_t1 : cycle_count;
    wire [6:0] txt_h0, txt_h1, txt_h2, txt_h3, txt_h4, txt_h5;
    decinstr decoder(Instr,txt_h0,txt_h1,txt_h2,txt_h3,txt_h4,txt_h5);
    wire [6:0] num_h0, num_h1, num_h2, num_h3, num_h4, num_h5;

    dec7seg d0 (hex_data[3:0],   num_h0);
    dec7seg d1 (hex_data[7:4],   num_h1);
    dec7seg d2 (hex_data[11:8],  num_h2);
    dec7seg d3 (hex_data[15:12], num_h3);
    dec7seg d4 (hex_data[19:16], num_h4);
    dec7seg d5 (hex_data[23:20], num_h5);

    assign HEX0 = SW[4] ? txt_h0 : num_h0;
    assign HEX1 = SW[4] ? txt_h1 : num_h1;
    assign HEX2 = SW[4] ? txt_h2 : num_h2;
    assign HEX3 = SW[4] ? txt_h3 : num_h3;
    assign HEX4 = SW[4] ? txt_h4 : num_h4;
    assign HEX5 = SW[4] ? txt_h5 : num_h5;



endmodule
