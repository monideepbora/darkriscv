/*
 * Copyright (c) 2018, Marcelo Samsoniuk
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the copyright holder nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

`timescale 1ns / 1ps
`include "../rtl/config.vh"

module darksocv
(
    input        XCLK,      // external clock
    input        XRES,      // external reset
    
    input        UART_RXD,  // UART receive line
    output       UART_TXD,  // UART transmit line

    output [3:0] LED,       // on-board leds
    output [3:0] DEBUG      // osciloscope
);

    // internal/external reset logic

    reg [7:0] IRES = -1;

`ifdef INVRES
    always@(posedge XCLK) IRES <= XRES==0 ? -1 : IRES[7] ? IRES-1 : 0; // reset low
`else
    always@(posedge XCLK) IRES <= XRES==1 ? -1 : IRES[7] ? IRES-1 : 0; // reset high
`endif

    // when there is no need for a clock generator:

    wire CLK = XCLK;
    wire RES = IRES[7];    

    // ro/rw memories

    reg [31:0] MEM [0:72080-1]; // ro memory

    // memory initialization

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
    // darkriscv bus interface

    wire [31:0] IADDR;
    wire [31:0] DADDR;
    wire [31:0] IDATA;    
    wire [31:0] DATAO;        
    wire [31:0] DATAI;
    wire        WR,RD;
    wire [3:0]  BE;
    wire [31:0] IOMUX [0:3];

    reg  [15:0] GPIOFF = 0;
    reg  [15:0] LEDFF  = 0;
    
    wire HLT;
    
    reg [31:0] ROMFF;

`ifdef __THREADING__
    initial begin
        $display("\nTHREADING ENABLED");
    end
`else
    initial begin
        $display("\nTHREADING DISABLED");
    end
`endif

`ifdef __WAITSTATES__
    initial begin
        $display("\nWAIT-STATES ENABLED");
    end
    
    reg [1:0] IHITACK = 0;
    
    wire IHIT = !(IHITACK!=1);
    
    always@(posedge CLK) // stage #1.0
    begin
        IHITACK <= RES ? 1 : IHITACK ? IHITACK-1 : 1; // wait-states
    end    
`else
     initial begin
        $display("\nWAIT-STATES DISABLED");
    end

    wire IHIT = 1;
    
`endif


`ifdef __3STAGE__   

    initial begin
        $display("\n3-STAGE PIPELINE ENABLED\n");
    end

    reg [31:0] ROMFF2 = 0;
    reg        HLT2   = 0;

    always@(posedge CLK) // stage #0.5    
    begin
        if(HLT)
        begin
            ROMFF2 <= ROMFF;
        end
        
        HLT2 <= HLT;
    end
    
    assign IDATA = HLT2 ? ROMFF2 : ROMFF;
`else    
    initial begin
        $display("\n2-STAGE PIPELINE ENABLED\n");
    end
    assign IDATA = ROMFF;
`endif

    always@(posedge CLK) // stage #0.5    
    begin

        ROMFF <= MEM[IADDR[30:2]];

    end

    // no cache!

    reg [31:0] RAMFF;
`ifdef __WAITSTATES__
    
    reg [1:0] DACK = 0;
    
    wire WHIT = 1;
    wire DHIT = !((WR||RD) && DACK!=1);
    
    always@(posedge CLK) // stage #1.0
    begin
        DACK <= RES ? 0 : DACK ? DACK-1 : (RD||WR) ? 1 : 0; // wait-states
    end

`elsif __3STAGE__

    // for single phase clock: 1 wait state in read op always required!

    reg [1:0] DACK = 0;
    
    wire WHIT = 1;
    wire DHIT = !((RD||WR) && DACK!=1); // the WR operatio does not need ws. in this config.
    
    always@(posedge CLK) // stage #1.0
    begin
        DACK <= RES ? 0 : DACK ? DACK-1 : (RD||WR) ? 1 : 0; // wait-states
    end

`else

    // for dual phase clock: 0 wait state

    wire WHIT = 1;
    wire DHIT = 1;

`endif
    
    always@(posedge CLK) // stage #1.5
    begin
        RAMFF <= MEM[DADDR[30:2]];
    end

    //assign DATAI = DADDR[31] ? IOMUX  : RAM[DADDR[11:2]];
    
    reg [31:0] IOMUXFF;

    //individual byte/word/long selection, thanks to HYF!
    
    always@(posedge CLK)
    begin    

`ifdef __3STAGE__

        // read-modify-write operation w/ 1 wait-state:

        if(!HLT&&WR&&DADDR[31]==0/*&&DADDR[12]==1*/)
        begin
    
            MEM[DADDR[30:2]] <=
               
                                {
                                    BE[3] ? DATAO[3 * 8 + 7: 3 * 8] : RAMFF[3 * 8 + 7: 3 * 8],
                                    BE[2] ? DATAO[2 * 8 + 7: 2 * 8] : RAMFF[2 * 8 + 7: 2 * 8],
                                    BE[1] ? DATAO[1 * 8 + 7: 1 * 8] : RAMFF[1 * 8 + 7: 1 * 8],
                                    BE[0] ? DATAO[0 * 8 + 7: 0 * 8] : RAMFF[0 * 8 + 7: 0 * 8]
                                };
        end

`else
   
        if(WR&&DADDR[31]==0&&/*DADDR[12]==1&&*/BE[3]) MEM[DADDR[30:2]][3 * 8 + 7: 3 * 8] <= DATAO[3 * 8 + 7: 3 * 8];
        if(WR&&DADDR[31]==0&&/*DADDR[12]==1&&*/BE[2]) MEM[DADDR[30:2]][2 * 8 + 7: 2 * 8] <= DATAO[2 * 8 + 7: 2 * 8];
        if(WR&&DADDR[31]==0&&/*DADDR[12]==1&&*/BE[1]) MEM[DADDR[30:2]][1 * 8 + 7: 1 * 8] <= DATAO[1 * 8 + 7: 1 * 8];
        if(WR&&DADDR[31]==0&&/*DADDR[12]==1&&*/BE[0]) MEM[DADDR[30:2]][0 * 8 + 7: 0 * 8] <= DATAO[0 * 8 + 7: 0 * 8];
`endif

        IOMUXFF <= IOMUX[DADDR[3:2]]; // read w/ 2 wait-states
    end    

    //assign DATAI = DADDR[31] ? IOMUX[DADDR[3:2]]  : RAMFF;
    assign DATAI = DADDR[31] ? /*IOMUX[DADDR[3:2]]*/ IOMUXFF  : RAMFF;



    // io for debug

    reg [7:0] IREQ = 0;
    reg [7:0] IACK = 0;
    
    reg [31:0] TIMERFF;

    wire [7:0] BOARD_IRQ;

    wire   [7:0] BOARD_ID = `BOARD_ID;              // board id
    wire   [7:0] BOARD_CM = (`BOARD_CK/1000000);    // board clock (MHz)
    wire   [7:0] BOARD_CK = (`BOARD_CK/10000)%100;  // board clock (kHz)

    assign IOMUX[0] = { BOARD_IRQ, BOARD_CK, BOARD_CM, BOARD_ID };
    //assign IOMUX[1] = from UART!
    assign IOMUX[2] = { GPIOFF, LEDFF };
    assign IOMUX[3] = TIMERFF;

    reg [31:0] TIMER = 0;

    reg XTIMER = 0;

    always@(posedge CLK)
    begin
        if(WR&&DADDR[31]&&DADDR[3:0]==4'b1000)
        begin
            LEDFF <= DATAO[15:0];
        end

        if(WR&&DADDR[31]&&DADDR[3:0]==4'b1010)
        begin
            GPIOFF <= DATAO[31:16];
        end

        if(RES)
            TIMERFF <= (`BOARD_CK/1000000)-1; // timer set to 1MHz by default
        else
        if(WR&&DADDR[31]&&DADDR[3:0]==4'b1100)
        begin
            TIMERFF <= DATAO[31:0];
        end

        if(RES)
            IACK <= 0;
        else
        if(WR&&DADDR[31]&&DADDR[3:0]==4'b0011)
        begin
            //$display("clear io.irq = %x (ireq=%x, iack=%x)",DATAO[32:24],IREQ,IACK);
            
            IACK[7] <= DATAO[7+24] ? IREQ[7] : IACK[7];
            IACK[6] <= DATAO[6+24] ? IREQ[6] : IACK[6];
            IACK[5] <= DATAO[5+24] ? IREQ[5] : IACK[5];
            IACK[4] <= DATAO[4+24] ? IREQ[4] : IACK[4];                                    
            IACK[3] <= DATAO[3+24] ? IREQ[3] : IACK[3];
            IACK[2] <= DATAO[2+24] ? IREQ[2] : IACK[2];
            IACK[1] <= DATAO[1+24] ? IREQ[1] : IACK[1];
            IACK[0] <= DATAO[0+24] ? IREQ[0] : IACK[0];
        end

        if(RES)
            IREQ <= 0;
        else        
        if(TIMERFF)
        begin
            TIMER <= TIMER ? TIMER-1 : TIMERFF;
            
            if(TIMER==0 && IREQ==IACK)
            begin
                IREQ[7] <= !IACK[7];
                
                //$display("timr0 set");
            end
            
            XTIMER  <= XTIMER+(TIMER==0);
        end
    end

    assign BOARD_IRQ = IREQ^IACK;

    assign HLT = !IHIT||!DHIT||!WHIT;

    // darkuart
  
    wire [3:0] UDEBUG;

    darkuart
//    #( 
//      .BAUD((`BOARD_CK/115200))
//    )
    uart0
    (
      .CLK(CLK),
      .RES(RES),
      .RD(!HLT&&RD&&DADDR[31]&&DADDR[3:2]==1),
      .WR(!HLT&&WR&&DADDR[31]&&DADDR[3:2]==1),
      .BE(BE),
      .DATAI(DATAO),
      .DATAO(IOMUX[1]),
      //.IRQ(BOARD_IRQ[1]),
      .RXD(UART_RXD),
      .TXD(UART_TXD),
      .DEBUG(UDEBUG)
    );

    // darkriscv

    wire [3:0] KDEBUG;

    darkriscv
//    #(
//        .RESET_PC(32'h00000000),
//        .RESET_SP(32'h00002000)
//    ) 
    core0 
    (
`ifdef __3STAGE__
        .CLK(CLK),
`else
        .CLK(!CLK),
`endif
        .RES(RES),
        .HLT(HLT),
`ifdef __THREADING__        
        .IREQ(|(IREQ^IACK)),
`endif        
        .IDATA(IDATA),
        .IADDR(IADDR),
        .DADDR(DADDR),
        .DATAI(DATAI),
        .DATAO(DATAO),
        .BE(BE),
        .WR(WR),
        .RD(RD),
        .DEBUG(KDEBUG)
    );

`ifdef __ICARUS__
  initial
  begin
    $dumpfile("darksocv.vcd");
    $dumpvars();
  end
`endif

    assign LED   = LEDFF[3:0];
    
    assign DEBUG = { GPIOFF[0], XTIMER, WR, RD }; // UDEBUG;

endmodule