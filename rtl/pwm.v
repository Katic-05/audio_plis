`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2022 13:13:33
// Design Name: 
// Module Name: pwm
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

module pwm#(
  parameter F_CLK           =   100_000_000,
  parameter F_PWM           =   1_000_000,
  parameter MAX_COUNTER_PWM =   F_CLK/44100 - 1,
  parameter TWO16           =   65536
)(
  input clk_i,
  //input clk_pwm_i,
  input [15:0] data_i, 
  input resetn_i,
  
  output PWM
);

reg pwm;
reg clk_p;
reg [12:0] counter;
reg [20:0] div_counter;

assign PWM = pwm;

// frequency divider
always @(posedge clk_i or negedge resetn_i) begin
    if(!resetn_i) begin
        div_counter <= 'd0;
        clk_p <= 'd0;
    end
    else begin
        if (div_counter == (F_CLK/F_PWM - 1)) begin
            div_counter <= 'd0;
            clk_p <= ~clk_p;
        end
        else div_counter <= div_counter + 'd1;
    end

end

// pwm
always @(posedge clk_i or negedge resetn_i) begin
    if(!resetn_i) begin
         counter <= 'd0;
    end
     
    else begin
    counter <= counter + 'd1;
        if(data_i*MAX_COUNTER_PWM/TWO16 >= counter) begin
            pwm <= 'd1;
        end
        else begin
            pwm = 'd0;
        end
        
        if(counter >= MAX_COUNTER_PWM) counter<='d0;
    end
end
endmodule
