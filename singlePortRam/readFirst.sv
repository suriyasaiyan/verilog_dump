module ReadFirstRAM #(
    parameter RAM_WIDTH = 8,                   // Data width: 8 bits
    parameter RAM_DEPTH = 256,                 // Number of entries: 256
    parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE",
    parameter INIT_FILE = ""                   // No initialization file used
)(
    input wire [$clogb2(RAM_DEPTH)-1:0] addra, // Address bus
    input wire [RAM_WIDTH-1:0] dina,           // Data input
    input wire clka,                           // Clock
    input wire wea,                            // Write enable
    input wire ena,                            // RAM Enable
    input wire rsta,                           // Output reset
    input wire regcea,                         // Output register enable
    output wire [RAM_WIDTH-1:0] douta          // Data output
);

    reg [RAM_WIDTH-1:0] ram [RAM_DEPTH-1:0];
    reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};

    generate
        if (INIT_FILE != "") begin: use_init_file
            initial $readmemh(INIT_FILE, ram, 0, RAM_DEPTH-1);
        end else begin: init_ram_to_zero
            integer i;
            initial for (i = 0; i < RAM_DEPTH; i = i + 1)
                ram[i] = {RAM_WIDTH{1'b0}};
        end
    endgenerate

    always @(posedge clka) begin
        if (ena) begin
            if (wea)
                ram[addra] <= dina;
            ram_data <= ram[addra]; // Read before write
        end
    end

    generate
        if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register
            assign douta = ram_data;
        end else begin: output_register
            reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
            always @(posedge clka) begin
                if (rsta)
                    douta_reg <= {RAM_WIDTH{1'b0}};
                else if (regcea)
                    douta_reg <= ram_data;
            end
            assign douta = douta_reg;
        end
    endgenerate

endmodule
