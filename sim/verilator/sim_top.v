module sim_top (
    input clk,
    input resetn
);
    wire        mem_valid, mem_instr;
    reg         mem_ready;
    wire [31:0] mem_addr, mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;
    wire        trap;

    picorv32 #(
        .ENABLE_MUL(0), .ENABLE_DIV(0), .COMPRESSED_ISA(0)
    ) cpu (
        .clk(clk), .resetn(resetn), .trap(trap),
        .mem_valid(mem_valid), .mem_instr(mem_instr), .mem_ready(mem_ready),
        .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata)
    );

    reg [31:0] memory [0:16*1024-1];  // 64KB
    initial $readmemh("firmware.hex", memory);

    localparam PRINT_ADDR  = 32'h1000_0000;
    localparam FINISH_ADDR = 32'h2000_0000;

    always @(posedge clk) begin
        mem_ready <= 0;
        if (mem_valid && !mem_ready) begin
            if (mem_addr == PRINT_ADDR) begin
                if (|mem_wstrb) $write("%c", mem_wdata[7:0]);
                mem_ready <= 1;
            end else if (mem_addr == FINISH_ADDR) begin
                if (|mem_wstrb) begin
                    $display("\n[sim] finish code=%0d", mem_wdata);
                    $finish;
                end
                mem_ready <= 1;
            end else begin
                mem_rdata <= memory[mem_addr[17:2]];
                if (mem_wstrb[0]) memory[mem_addr[17:2]][7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) memory[mem_addr[17:2]][15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) memory[mem_addr[17:2]][23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) memory[mem_addr[17:2]][31:24] <= mem_wdata[31:24];
                mem_ready <= 1;
            end
        end
    end

    always @(posedge clk) if (trap) begin
        $display("[sim] TRAP"); $finish;
    end
endmodule