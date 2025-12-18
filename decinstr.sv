module decinstr (
    input  [31:0] Instr,
    output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    localparam OFF = 7'b1111111;
    // Alfabeto (Lógica Negativa: 0 = ON)
    localparam _A  = 7'b0001000;
    localparam _b  = 7'b0000011;
    localparam _C  = 7'b1000110;
    localparam _d  = 7'b0100001;
    localparam _E  = 7'b0000110;
    localparam _F  = 7'b0001110;
    localparam _G  = 7'b1000010; 
    localparam _H  = 7'b0001001;
    localparam _I  = 7'b1001111; 
    localparam _J  = 7'b1110001;
    localparam _L  = 7'b1000111;
    localparam _n  = 7'b0101011;
    localparam _O  = 7'b1000000; 
    localparam _P  = 7'b0001100;
    localparam _q  = 7'b0011000;
    localparam _r  = 7'b0101111;
    localparam _S  = 7'b0010010; 
    localparam _t  = 7'b0000111;
    localparam _U  = 7'b1000001;
    localparam _u  = 7'b1100011; 
    localparam _X  = 7'b0110111; 
    localparam _Y  = 7'b0010001; 

    wire [6:0] opcode = Instr[6:0];
    wire [2:0] funct3 = Instr[14:12];
    wire [6:0] funct7 = Instr[31:25];

    always @(*) begin
        {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {OFF, OFF, OFF, OFF, OFF, OFF};

        case (opcode)
            // TIPO R
            7'b0110011: begin 
                case (funct3)
                    3'b000: begin
                        if (funct7[5]) {HEX2, HEX1, HEX0} = {_S, _u, _b};
                        else           {HEX2, HEX1, HEX0} = {_A, _d, _d}; 
                    end
                    3'b001: {HEX2, HEX1, HEX0} = {_S, _L, _L};
                    3'b010: {HEX2, HEX1, HEX0} = {_S, _L, _t}; 
                    3'b100: {HEX2, HEX1, HEX0} = {_X, _O, _r}; 
                    3'b110: {HEX1, HEX0}       = {_O, _r}; 
                    3'b111: {HEX2, HEX1, HEX0} = {_A, _n, _d}; 
                    default: {HEX2, HEX1, HEX0} = {_A, _L, _U};
                endcase
            end

            // TIPO I
            7'b0010011: begin
                case (funct3)
                    3'b000: {HEX3, HEX2, HEX1, HEX0} = {_A, _d, _d, _I}; 
                    3'b100: {HEX3, HEX2, HEX1, HEX0} = {_X, _O, _r, _I}; 
                    3'b110: {HEX2, HEX1, HEX0}       = {_O, _r, _I}; 
                    3'b111: {HEX3, HEX2, HEX1, HEX0} = {_A, _n, _d, _I}; 
                    default: {HEX3, HEX2, HEX1, HEX0} = {_A, _L, _U, _I}; 
                endcase
            end

            // LOAD
            7'b0000011: begin
                {HEX3, HEX2, HEX1, HEX0} = {_L, _O, _A, _d}; 
            end

            // STORE
            7'b0100011: begin
                {HEX3, HEX2, HEX1, HEX0} = {_S, _t, _O, _r}; 
            end

            // BRANCH
            7'b1100011: begin
                case(funct3)
                    3'b000: {HEX2, HEX1, HEX0} = {_b, _E, _q};
                    3'b001: {HEX2, HEX1, HEX0} = {_b, _n, _E}; 
                    3'b100: {HEX2, HEX1, HEX0} = {_b, _L, _t}; 
                    3'b101: {HEX2, HEX1, HEX0} = {_b, _G, _E}; 
                    default:{HEX2, HEX1, HEX0} = {_b, _r, _A}; 
                endcase
            end

            // JUMPS
            7'b1101111: {HEX2, HEX1, HEX0} = {_J, _A, _L}; 
            7'b1100111: {HEX3, HEX2, HEX1, HEX0} = {_J, _A, _L, _r}; 

            // LUI / AUIPC
            7'b0110111: {HEX2, HEX1, HEX0} = {_L, _U, _I}; 
            7'b0010111: {HEX4, HEX3, HEX2, HEX1, HEX0} = {_A, _U, _I, _P, _C}; 
            
            7'b1110011: {HEX5,HEX4,HEX3, HEX2, HEX1, HEX0} = {_S, _Y, _S, _t, _E, _n}; 

            default: {HEX5,HEX4,HEX3, HEX2, HEX1, HEX0} = {OFF, OFF, OFF, OFF, OFF, OFF};
        endcase
    end
endmodule
