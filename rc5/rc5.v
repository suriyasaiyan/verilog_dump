/*module rc5_encryption (
    input clk,    
    input rst,    
    input [63:0] d_in, 
    output reg [63:0] d_out  
);

// Parameters for RC5
parameter WORD_SIZE     = 32;
parameter NUM_ROUNDS    = 12;
parameter KEY_LENGTH    = 26;

// Magic constants for RC5
parameter P = 32'hB7E15163;
parameter Q = 32'h9E3779B9; 

// Key array
reg [WORD_SIZE-1:0] key_rom[0:KEY_LENGTH-1];

initial begin

end

// Key scheduling arrays
reg [WORD_SIZE-1:0] L[0:KEY_LENGTH-1]; 
reg [WORD_SIZE-1:0] S[(2*NUM_ROUNDS+3)-1:0]; 

integer i, j, k, mix_i;
reg [WORD_SIZE-1:0] A, B;
reg [WORD_SIZE-1:0] tempA, tempB;

// Key expansion algorithm
initial begin
    // Copy key into L
    for (i = 0; i < KEY_LENGTH; i = i + 1) begin
        L[i] = key_rom[i];
    end

    // Initialize subkey array S
    S[0] = P;
    for (i = 1; i <= 2*NUM_ROUNDS+2; i = i + 1) begin
        S[i] = S[i - 1] + Q;
    end

    // Mix the key into the subkeys
    A = 0;
    B = 0;
    i = 0;
    j = 0;

    for (mix_i = 0; mix_i < 3 * max(KEY_LENGTH, 2 * NUM_ROUNDS + 3); mix_i = mix_i + 1) begin
        A = rol(S[i] + A + B, 3);
        S[i] = A;
        B = rol(L[j] + A + B, A + B);
        L[j] = B;

        i = (i + 1) % (2 * NUM_ROUNDS + 3);
        j = (j + 1) % KEY_LENGTH;
    end
end

// Function for left rotation
function [WORD_SIZE-1:0] rol;
    input [WORD_SIZE-1:0] value;
    input integer shift;
    begin
        rol = (value << shift) | (value >> (WORD_SIZE-shift));
    end
endfunction

// Function for right rotation
function [WORD_SIZE-1:0] ror;
    input [WORD_SIZE-1:0] value;
    input integer shift;
    begin
        ror = (value >> shift) | (value << (WORD_SIZE-shift));
    end
endfunction

// Encryption logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        d_out <= 0;
    end else begin
        A = d_in[63:32];
        B = d_in[31:0];

        // Initial mix of input data with key
        A = A + S[0];
        B = B + S[1];

        for (i = 1; i <= NUM_ROUNDS; i = i + 1) begin
            tempA = rol(A, B) + S[2*i];
            tempB = rol(B, tempA) + S[2*i + 1];

            A = tempA;
            B = tempB;
        end

        d_out = {A, B};
    end
end

endmodule*/



module rc5_encryption (
    input clk,
    input rst,
    input [63:0] d_in,
    output reg [63:0] d_out 
);
    parameter WORD_SIZE  = 32;
    parameter NUM_ROUNDS = 12;
    reg [WORD_SIZE-1:0] key_rom[2*NUM_ROUNDS+1:0];

    // Function for left rotation
    function [WORD_SIZE-1:0] rol;
        input [WORD_SIZE-1:0] value;
        input integer shift;
        begin
            rol = (value << shift) | (value >> (WORD_SIZE-shift));
        end
    endfunction

    localparam IDLE    = 2'b00,
               INIT    = 2'b01,
               ENCRYPT = 2'b10,
               DONE    = 2'b11;

    // Key initialization
    initial begin
        key_rom[0]  = 32'h0;
        key_rom[1]  = 32'h0;
        key_rom[2]  = 32'h46F8E8C5;
        key_rom[3]  = 32'h460C6085;
        key_rom[4]  = 32'h70F83B8A;
        key_rom[5]  = 32'h284B8303;
        key_rom[6]  = 32'h513E1454;
        key_rom[7]  = 32'hF621ED22;
        key_rom[8]  = 32'h3125065D;
        key_rom[9]  = 32'h11A83A5D;
        key_rom[10] = 32'hD427686B;
        key_rom[11] = 32'h713AD82D;
        key_rom[12] = 32'h4B792F99;
        key_rom[13] = 32'h2799A4DD;
        key_rom[14] = 32'hA7901C49;
        key_rom[15] = 32'hDEDE871A;
        key_rom[16] = 32'h36C03196;
        key_rom[17] = 32'hA7EFC249;
        key_rom[18] = 32'h61A78BB8;
        key_rom[19] = 32'h3B0A1D2B;
        key_rom[20] = 32'h4DBFCA76;
        key_rom[21] = 32'hAE162167;
        key_rom[22] = 32'h30D76B0A;
        key_rom[23] = 32'h43192304;
        key_rom[24] = 32'hF6CC1431;
        key_rom[25] = 32'h65046380; 
    end
    
    reg [1:0] state;
    reg [31:0] A, B, tempA, tempB;
    reg [3:0] round_counter;
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (!rst) begin
                        // sstart encryption when not in reset
                        state = INIT;
                    end
                end

                INIT: begin
                    A = d_in[63:32];
                    B = d_in[31:0];
                    A = A + key_rom[0];
                    B = B + key_rom[1];
                    round_counter = 1;
                    state = ENCRYPT;
                end

                ENCRYPT: begin
                    if (round_counter < NUM_ROUNDS+1) begin
                    
                          A = (rol((A^B), B[4:0])+ key_rom[2 * round_counter]);
                          B = (rol((B^A), A[4:0])+ key_rom[2 * round_counter + 1]);   

                        round_counter = round_counter + 1;
                        state = ENCRYPT;
                    end else begin
                        state = DONE;
                    end
                end

                DONE: begin
                    d_out = {A, B};
                    state = IDLE;
                end

                default: state = IDLE;
            endcase
        end
    end

endmodule





