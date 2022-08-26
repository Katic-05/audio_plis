`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2022 19:29:19
// Design Name: 
// Module Name: experiment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module experiment(
    input  clock,
    input resetn,
    output aud_pwm,
    output aud_sd,
    output [9:0] LED
    );
    
    reg [9:0] LED_;
    assign LED = LED_;
parameter duo   =100_000_000/523;///4777;
parameter lai   =100_000_000/587;//4257;
parameter mi    =100_000_000/659;//3792;
parameter fa    =100_000_000/698;//3580;
parameter suo   =100_000_000/783;//3189;
parameter la    =100_000_000/880;//2906;
parameter xi    =100_000_000/987;//2531;

localparam DUO = 'b000;
localparam LAI = 'b001;
localparam MI  = 'b010;
localparam FA  = 'b011;
localparam SUO = 'b100;
localparam LA  = 'b101;
localparam XI  = 'b110;
    
reg [3:0] state;
reg audio;
initial audio ='d0;
assign aud_pwm = audio;
assign aud_sd = 'd1;

reg [30:0] time_state;
reg [20:0] counter;

/*
always @(posedge clock) begin
    if(counter==duo) begin
        counter <= 0; 
    end else begin
        counter <= counter + 1'b1;
    end
end

reg audio;
always @(posedge clock) if(counter==duo) audio <= ~audio;
*/
/*
parameter clkdivider = 100_000_000/440/2;

reg [14:0] counter; initial counter <= 15'd0;

reg [26:0] tone; initial tone <= 26'd0;
always @(posedge clock) tone <= tone+1;

always @(posedge clock) begin
    if(counter==0) begin
        counter <= (tone[26] ? clkdivider-1 : clkdivider/2-1); 
    end else begin
        counter <= counter - 1'b1;
    end
end
*/

//always @(posedge clock) if(counter==0) audio <= ~audio;


always @(posedge clock or negedge resetn) begin
    if(!resetn) begin
        time_state <= 'd0; //1.3 sec ??
        state      <= DUO;
        counter    <= 'd0;
     
    end
    else begin
        time_state <= time_state + 'b1;
        if(counter=='hfffff) counter <= 'd0;
        case(state)
            DUO: begin
                LED_ <= 'b00000001;
                if(time_state[27]) begin 
                    state <= LAI;
                    //counter <= 'd0;
                    time_state <='d0;
                end
               
                if(counter==0) begin
                    counter <= duo; 
                end else begin
                    counter <= counter - 1'b1;
                end
                
            end
            
            LAI: begin
                LED_ <= 'b00000010;
                if(time_state[27]) begin 
                    state <= MI;
                    //counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= lai; 
                end else begin
                    counter <= counter - 1'b1;
                end
            end
            
            MI: begin
                LED_ <= 'b00000100;
                if(time_state[27]) begin 
                    state <= FA;
                    //counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= mi; 
                end else begin
                    counter <= counter - 1'b1;
                end
            end
            
            FA: begin
                LED_ <= 'b00001000;
                if(time_state[27]) begin 
                    state <= SUO;
                    //counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= fa; 
                end else begin
                    counter <= counter - 1'b1;
                end
            end
            
            SUO: begin
                LED_ <= 'b00010000;
                if(time_state[27]) begin 
                    state <= LA;
                    //counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= suo; 
                end else begin
                    counter <= counter - 1'b1;
                end
            end
            
            LA: begin
                 LED_ <= 'b00100000;
                if(time_state[27]) begin 
                    state <= XI;
                    //counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= la; 
                end else begin
                    counter <= counter - 1'b1;
                end
              
            end
            
            XI: begin
                LED_ <= 'b01000000;
                if(time_state[27]) begin 
                    state <= DUO;
                   // counter <= 'd0;
                    time_state <='d0;
                end
                
                if(counter==0) begin
                    counter <= xi; 
                end else begin
                    counter <= counter - 1'b1;
                end
            end
        endcase
    
    end
end

always @(posedge clock) if(counter==0) audio <= ~audio;


endmodule
    
    

