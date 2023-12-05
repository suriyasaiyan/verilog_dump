// Write HIT:  Write-back: In a write-back cache, data is written to the cache and only later to the main memory when the cache line is replaced. 
// Write MISS: Write allocate: when a write miss occurs, the cache line is loaded into the cache, and then the write operation is performed.
// Look-through:  which means it checks the main memory for cache misses.
// LRU (Least Recently Used):  which means the least recently used cache line is selected for replacement.

// ECC, 2 words per block., CACHE CONFLICT, gate clocking

`timescale 1ns / 1ps
module L1_Data_Cache(
    input wire clk,
    input wire reset,
    input wire write_enable, read_enable,
    input wire [31:0] request_address,
    input wire [31:0] write_data,
    output reg [31:0] response_data,
    output reg [1:0] c_state,
    
    // To LOWER MEMORY
    output reg l2_request,
    output reg l2_write_enable,
    output reg [31:0] l2_address, 
    output reg [31:0] l2_write_data,
    input wire [31:0] l2_response_data,
    input wire l2_ready
);
    // Hardcoded parameters for the data cache
    localparam CACHE_SIZE    = 4 * 1024;   // Cache size: 4 KB
    localparam BLOCK_SIZE    = 4;          // Block size: 4 bytes (32 bits)
    localparam ASSOCIATIVITY = 2;          // 2-way
    localparam DATA_WIDTH    = 32;
    
    localparam BLOCK_WIDTH   = BLOCK_SIZE * 8; //32 bits
    localparam NUM_SETS      = CACHE_SIZE/(BLOCK_SIZE * ASSOCIATIVITY); // 512 sets
    localparam ADDR_WIDTH    = 32;                        

    // Calculating the number of bits for offset, index, and tag
    localparam OFFSET_WIDTH   = $clog2(BLOCK_SIZE);    // 2 bits
    localparam INDEX_WIDTH    = $clog2(NUM_SETS);       // 9 bits
    localparam TAG_WIDTH      = ADDR_WIDTH - OFFSET_WIDTH - INDEX_WIDTH;  // 21 bits
  
    typedef enum integer {IDLE, CHECK_TAG, WRITEBACK, FILL} cache_state_t;
    cache_state_t state = IDLE;

    // Internal Variables
    reg [BLOCK_WIDTH- 1:0] cache_data [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
    //need to add offset access
    reg [TAG_WIDTH - 1:0] cache_tags [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
    reg valid [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
    reg dirty [0:NUM_SETS-1][0:ASSOCIATIVITY-1];
    reg [ASSOCIATIVITY-1:0] lru_counter [0:NUM_SETS-1];

    reg [ADDR_WIDTH-1:0]     current_address;
    reg [TAG_WIDTH-1:0]      current_tag;
    reg [INDEX_WIDTH-1:0]    current_index;
    reg [OFFSET_WIDTH-1:0]   current_offset;
    
    reg hit;
    reg [ASSOCIATIVITY-1:0] way, lru_way;
    
       
    // LRU Function
    function integer get_lru_way(input integer set_index);
        integer i;
        reg [ASSOCIATIVITY-1:0] max_count;
        begin
            max_count = 0;
            //max_count = -1; -1 here is 32'hFFFFFFFF turnication happens and max_count will be 3
            lru_way = 0;
            for (i = 0; i < ASSOCIATIVITY; i = i + 1) begin            
                if (lru_counter[set_index][i] > max_count) begin
                    max_count = lru_counter[set_index][i];
                    lru_way = i;
                end
            end
            get_lru_way = lru_way;
        end
    endfunction

    // Cache Operation Tasks
    task reset_cache;
        integer i, j;
        begin
            state <= IDLE;
            for (i = 0; i < NUM_SETS; i = i+1) begin
                for (j = 0; j < ASSOCIATIVITY; j = j+1) begin
                    cache_data[i][j] <= 0;
                    cache_tags[i][j] <= 0;
                    valid[i][j] <= 0;
                    dirty[i][j] <= 0;
                    lru_counter[i][j] <= j;
                end
            end
        end
    endtask

    task idle_state_logic;
        begin
            if (write_enable || read_enable) begin
                current_address <= request_address;
                current_tag     <= request_address[ADDR_WIDTH-1 -: TAG_WIDTH];
                current_index   <= request_address[(ADDR_WIDTH - TAG_WIDTH - 1)-: INDEX_WIDTH];
                current_offset  <= request_address[OFFSET_WIDTH-1 -: OFFSET_WIDTH];                      
                state <= CHECK_TAG;
            end
        end
    endtask

    task check_tag_logic;
        integer i;
        begin
            hit = 0;
            // have to parallel check for better performance
            lru_way = get_lru_way(current_index); // new
            for (i = 0; i < ASSOCIATIVITY; i = i + 1) begin
                if (valid[current_index][i] && cache_tags[current_index][i] == current_tag) begin
                    hit = 1;
                    way = i;                
                    break;
                end
            end
            if (hit) begin
                handle_cache_hit();
            end else begin
                handle_cache_miss();
            end
        end
    endtask

    task handle_cache_hit;
        begin
            if (write_enable) begin
                cache_data[current_index][way] <= write_data;
                dirty[current_index][way] <= 1;
                state <= IDLE;
            end else if (read_enable) begin
                response_data <= cache_data[current_index][way];
                //do we need to make read_enable low here?
                state <= IDLE;
            end
            update_lru_counters(current_index, way);
        end
    endtask

    task handle_cache_miss;
        begin
            if (dirty[current_index][lru_way]) begin
                state <= WRITEBACK;
            end else begin
                state <= FILL;
            end
        end
    endtask

    task writeback_logic;
        begin
            l2_request <= 1;
            l2_address <= {cache_tags[current_index][lru_way], current_index, 2'b10};
            l2_write_enable <= 1;
            l2_write_data <= cache_data[current_index][lru_way];
    
            if (l2_ready) begin
                l2_write_enable <= 0;
                l2_request <=0;
                state <= FILL; // Proceed to fill the cache line
            end 
//            else begin
//            state <= FILL; // Directly proceed to fill if the line is not dirty
//            end
        end
    endtask
    
    task fill_logic;
        begin  
            l2_request <= 1;
            l2_address <= current_address;
            if (l2_ready) begin
                cache_data[current_index][lru_way] <= l2_response_data;
                cache_tags[current_index][lru_way] <= current_tag;
                valid[current_index][lru_way] <= 1;
                dirty[current_index][lru_way] <= 0; 
    
                update_lru_counters(current_index, lru_way);
    
                l2_request <= 0; 
                state <= CHECK_TAG; 
            end
            // Similar to writeback_logic, consider adding handling for when l2_ready is low
        end
    endtask

    task update_lru_counters(input integer set_index, input integer accessed_way);
        integer i;
        begin
            for (i = 0; i < ASSOCIATIVITY; i = i + 1) begin
                if (i == accessed_way) begin
                    lru_counter[set_index][i] <= 0;
                end else if (lru_counter[set_index][i] != (ASSOCIATIVITY - 1)) begin
                    lru_counter[set_index][i] <= lru_counter[set_index][i] + 1;
                end
            end
        end
    endtask

    // Main Cache Operation 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_cache();
        end else begin
            case (state)
                IDLE: begin
                    idle_state_logic();
                    c_state <= 0;
                end
                CHECK_TAG: begin
                    check_tag_logic();
                    c_state <= 1; 
                end
                WRITEBACK: begin
                    writeback_logic();
                    c_state <= 2; 
                end
                FILL: begin
                    fill_logic();
                    c_state <= 3; 
                end
                default: begin
                    idle_state_logic();
                    c_state <= 0; 
                end
            endcase
        end
    end
    
endmodule