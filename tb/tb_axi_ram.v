`timescale 1ns / 1ps

module tb_axi_ram;
    reg clk = 0;
    reg rst = 0;

    // AXI signals
    reg [15:0] s_axi_awaddr = 0;
    reg [15:0] s_axi_araddr = 0;   
    reg s_axi_awvalid = 0;
    wire s_axi_awready;

    reg [31:0] s_axi_wdata = 0;
    wire [31:0] s_axi_rdata;   
    reg s_axi_wvalid = 0; 
    reg s_axi_arvalid = 0;
    wire s_axi_rvalid;   
    wire s_axi_wready;

    wire [1:0] s_axi_bresp;
    wire s_axi_bvalid;
    reg s_axi_bready = 0;
    reg [3:0] s_axi_wstrb = 4'b1111;

   reg	      s_axi_rready = 1;
   

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_axi_ram.vcd");
        $dumpvars(0, tb_axi_ram);
        rst <= 1;
        #25 rst <= 0;
        #20;       
        // Тест: простая запись
        s_axi_awaddr <= 16'h0004;
        s_axi_wdata  <= 32'hDEADBEEF;
        s_axi_awvalid <= 1;
        s_axi_wvalid  <= 1;

        s_axi_bready <= 0;       
        #30;
        s_axi_awvalid <= 0;
        s_axi_wvalid  <= 0;
        #10;
        s_axi_araddr <= 16'h0004;
        s_axi_arvalid <= 1;
        #30;
       if(s_axi_rvalid & (s_axi_rdata == 32'hDEADBEEF))
	 $display("PASS: write succeed to addr 4, data DEADBEEF");
       else
	 $display("FAIL: read mismatch , addr 4 data not DEADBEEF as expected");
       
        s_axi_arvalid <= 0;        
        #100;
        $finish;
    end

    // DUT
    axi_ram DUT (
        .clk(clk),
        .rst(rst),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_araddr(s_axi_araddr),		 
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
	.s_axi_arvalid(s_axi_arvalid),
	.s_axi_awlen(8'h00),		 		 
	.s_axi_awsize(3'b100),		 
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
	.s_axi_awburst(2'b00),		 
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
	.s_axi_rdata(s_axi_rdata),
	.s_axi_rvalid(s_axi_rvalid),
	.s_axi_rready(s_axi_rready)
    );
endmodule
