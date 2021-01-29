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

#include <io.h>
#include <stdio.h>

int main(void)
{
    printf("board: %s (id=%d)\n",board_name(io.board_id),io.board_id);
    printf("build: darkriscv fw build %s\n",BUILD);

    printf("core0: darkriscv@%d.%dMHz with %s%s%s\n",
        io.board_cm,                        // board clock MHz
        io.board_ck,                        // board clock kHz
        ARCH,                               // architecture
        threads>1?"+MT":"",                 //  MT support
        mac(1000,16,16)==1256?"+MAC":"");   // MAC support

    threads = 0; // prepare for the next restart

    printf("uart0: 115200 bps (div=%d)\n",io.uart.baud);
    printf("timr0: periodic timer=%dHz (io.timer=%d)\n",(io.board_cm*1000000u+io.board_ck*10000u)/(io.timer+1),io.timer);
    printf("\n");

    printf("Welcome to DarkertergRISCV!\n");

    usleep(10);

     __asm__ volatile("j start;");

    //  __asm__ volatile("li a0,63; \
	// call putchar; ");
}

void success()
{

    putstr("Success >");
    // putchar('M');
    // putchar('O');
  
}

void failure()
{
    putstr("Failure >");
    // putchar('M');
    // putchar('O');  
}

void OK()
{
    putstr("..OK\n");
}