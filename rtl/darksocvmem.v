
`timescale 1ns / 1ps

module darksocvmem(
    input        XCLK,
    output[31:0] DBUS_MEM,
    input [31:0] IADDR_in

);
   
    // memory initialization
   reg [31:0] MEM [0:72080-1]; // ro memory

    integer i;
    initial
    begin
        for(i=0;i!=72080-1;i=i+1)
        begin
            MEM[i] = 32'd0;
        end
        
        // workaround for vivado: no path in simulation and .mem extension

        $readmemh("../src/darksocv.mem",MEM);
            
    end

    wire [31:0] IADDR;
    wire [31:0] DADDR;
    wire [31:0] IDATA;    
    wire [31:0] DATAO;        
    wire [31:0] DATAI;
    wire        WR,RD;
    wire [3:0]  BE;
    wire [31:0] IOMUX [0:3];

    reg [31:0] ROMFF;

    assign IADDR = IADDR_in;

    always@(posedge CLK) // stage #0.5    
    begin

        ROMFF <= MEM[IADDR[30:2]];

    end

    assign DBUS_MEM = ROMFF;