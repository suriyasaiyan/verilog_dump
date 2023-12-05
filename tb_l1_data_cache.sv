//ver.0
`timescale 1ns / 1ps
module tb_L1_Data_Cache;
    parameter CLOCK_PERIOD   = 10;    
    reg clk;
    reg reset;
    reg write_enable;
    reg read_enable;
    reg [31:0] request_address;
    reg [31:0] write_data;
    wire [31:0] response_data;
    wire [1:0] c_state;

    // L2 Cache 
    reg [31:0] l2_response_data;
    reg l2_ready;
    reg l2_request;
    reg l2_write_enable;
    wire [31:0] l2_address;
    wire [31:0] l2_write_data;
    
    // Hardcoded parameters for the data cache
    localparam L2_CACHE_SIZE    = 16 * 1024;   // Cache size: 4 KB
    localparam L2_BLOCK_SIZE    = 4;          // Block size: 4 bytes (32 bits)
    localparam L2_ASSOCIATIVITY = 4;          // 2-way
    localparam L2_DATA_WIDTH    = 32;
    
    localparam L2_BLOCK_WIDTH   = L2_BLOCK_SIZE * 8;
    localparam L2_NUM_SETS      = L2_CACHE_SIZE/(L2_BLOCK_SIZE * L2_ASSOCIATIVITY);
    localparam L2_ADDR_WIDTH    = 32;                        

    // Calculating the number of bits for offset, index, and tag
    localparam L2_OFFSET_WIDTH   = $clog2(L2_BLOCK_SIZE);    
    localparam L2_INDEX_WIDTH    = $clog2(L2_NUM_SETS);        
    localparam L2_TAG_WIDTH      = L2_ADDR_WIDTH - L2_OFFSET_WIDTH - L2_INDEX_WIDTH; 
    
    // L2 Cache Address Decomposition
    reg [L2_TAG_WIDTH-1:0]      current_tag;
    reg [L2_INDEX_WIDTH-1:0]    current_index;
    reg [L2_OFFSET_WIDTH-1:0]   current_offset;

    L1_Data_Cache dut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .request_address(request_address),
        .write_data(write_data),
        .response_data(response_data),
        .c_state(c_state),
        
        .l2_response_data(l2_response_data),
        .l2_ready(l2_ready),
        .l2_request(l2_request),
        .l2_write_enable(l2_write_enable),
        .l2_address(l2_address),
        .l2_write_data(l2_write_data)      
    );
    
    // L2 Cache Data Storage
    reg [L2_BLOCK_WIDTH-1:0] l2_cache_data [0: L2_NUM_SETS-1][0: L2_ASSOCIATIVITY-1];
    reg [L2_TAG_WIDTH - 1:0] l2_cache_tags [0:L2_NUM_SETS-1][0:L2_ASSOCIATIVITY-1];
    
    initial begin

       l2_cache_data [2][0] <= 32'hAAAAAAAA;
       l2_cache_data [2][1] <= 32'hBBBBBBBB;
       l2_cache_data [2][2] <= 32'hCCCCCCCC;
       l2_cache_data [2][3] <= 32'hDDDDDDDD;
        
       l2_cache_data [524][0] <= 32'hEEEEEEEE;
       l2_cache_data [524][1] <= 32'hFFFFFFFF;
       l2_cache_data [524][2] <= 32'hABCDEFAB;
       l2_cache_data [524][3] <= 32'hFEDCBAFE;

       l2_cache_tags [2][0] <= 20'h00001;
       l2_cache_tags [2][1] <= 20'h00002;
       l2_cache_tags [2][2] <= 20'h00003;
       l2_cache_tags [2][3] <= 20'h00004;
        
       l2_cache_tags [524][0] <= 20'h00000;        // 32'h00000832
       l2_cache_tags [524][1] <= 20'hABCDE;        // 32'hABCDE832
       l2_cache_tags [524][2] <= 20'hAAAAA;        // 32'hAAAAA832
       l2_cache_tags [524][3] <= 20'hFFFFF;        // 32'hFFFFF832
    end

    initial begin
        clk =0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    initial begin
        reset_signals();
        
        read_enable =1;  
        request_address = 32'h00000832;
        #61 read_enable = 0; #9;  // fill and read 
        
        #10 read_enable = 1;  
        request_address = 32'hABCDE832;
        #61 read_enable = 0; #9;
        
        test_cache_read_hit (32'h00000832, 32'hEEEEEEEE);
        test_cache_read_hit (32'hABCDE832, 32'hFFFFFFFF);
        
        test_cache_read_miss(32'hAAAAA832, 32'hABCDEFAB); // new
        
        test_cache_read_hit (32'hABCDE832, 32'hFFFFFFFF);
        test_cache_read_miss(32'h00000832, 32'hEEEEEEEE); // new
        test_cache_write_hit(32'hABCDE832, 32'hFFFFFFFF);
        test_cache_read_miss(32'hAAAAA832, 32'hABCDEFAB);
        test_cache_read_writeback_miss(32'hFFFFF832, 32'hFEDCBAFE);
    end

    task reset_signals;
        begin
            reset = 1;
            write_enable = 0;
            read_enable = 0;
            l2_ready = 0;
            l2_request = 0;
            l2_write_enable = 0;
            write_data = 0;
            l2_response_data = 0;
            
            #15 reset = 0; 
        end
    endtask

    task test_cache_read_hit(input [L2_ADDR_WIDTH-1:0] addr, input [31:0] expected_data);
        begin
            #10 read_enable = 1;
            request_address = addr;

            #31 read_enable = 0;
            assert(response_data == expected_data) else $display("Read Hit Test Failed for address %h", addr);
            #9;
        end
    endtask
    
    task test_cache_read_writeback_miss(input[L2_ADDR_WIDTH-1:0] addr, input [31:0] expected_data);
        begin
            #10 read_enable = 1;
            request_address = addr;
            
            #81 read_enable = 0;
            assert(response_data == expected_data) else $display("Read Miss Test Failed for address %h", addr);
            #9;
        end
    endtask

    task test_cache_write_hit(input [L2_ADDR_WIDTH-1:0] addr, input [31:0] data);
        begin
            #10 write_enable = 1;
            request_address = addr;
            write_data = data;         
            #31 write_enable = 0; #9;         
        end
    endtask

    task test_cache_read_miss(input [L2_ADDR_WIDTH-1:0] addr, input [31:0] expected_data);
        begin
            #10 read_enable = 1;
            request_address = addr;
            #61; 
            read_enable = 0;
            assert(response_data == expected_data) else $display("Read Miss Test Failed for address %h", addr);
            #9;
        end
    endtask

    task test_cache_write_miss(input [L2_ADDR_WIDTH-1:0] addr, input [31:0] data);
        begin
            write_enable = 1;
            request_address = addr;
            write_data = data;
            #41; 
            write_enable = 0;
        end
    endtask
       
    // L2 Cache Simulation Logic
    always @(posedge clk) begin
        integer i;
        reg hit;
        reg [31:0] selected_data;
        
        if (l2_request && !l2_ready) begin

            current_offset = l2_address[L2_OFFSET_WIDTH-1 -: L2_OFFSET_WIDTH];
            current_index  = l2_address[(L2_ADDR_WIDTH - L2_TAG_WIDTH - 1)-: L2_INDEX_WIDTH];
            current_tag    = l2_address[L2_ADDR_WIDTH-1 -: L2_TAG_WIDTH]; 
            
            hit = 0;
            for (i = 0; i < L2_ASSOCIATIVITY; i = i + 1) begin
                if (l2_cache_tags[current_index][i] == current_tag) begin
                
                    hit = 1;
                    selected_data = l2_cache_data[current_index][i];
                    break;
                end
            end
    
            if (hit) begin
                if (l2_write_enable) begin
//                    l2_cache_data[current_index][i] = l2_write_data;
                end else begin
                    l2_response_data = selected_data;
                end
                l2_ready = 1;
                #10 l2_ready = 0;
            end else begin
                l2_response_data = 32'hdeadbeef; 
                l2_ready = 1;
                #10 l2_ready = 0;
                end
            end
    end
endmodule
