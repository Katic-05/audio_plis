`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2022 20:11:31
// Design Name: 
// Module Name: top
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
//`default_nettype none

module top #(
parameter RAM_DEPTH     = 65278,
parameter FS_AUDIO      = 512     // 22.591 MHz/44100
)(
  input clock,
  input resetn,
  
  input [3:0] SW, // volume control( not used )

  // for pwm use
  //output aud_pwm,  
  //output aud_sd, 
    
  output [6:0] ja,
  input  ja_7
  
);

reg signal_bram;
wire pwm;
wire clk_22m591_pll;
wire clk_22m591;
wire locked;

reg  [15:0] addr_bram;
reg  [31:0] in_bram;
wire [31:0] out_bram;
reg         en_bram;
reg         wea_bram;
reg         regcea;

reg        clk_pwm;
reg [11:0] counter_fs;

reg aud_sd_top;
wire [12:0] data_pwm_test;

assign data_pwm_test = 'd3200;
//assign aud_pwm = pwm;
//assign aud_sd = aud_sd_top;

always@(posedge clk_22m591_pll or negedge resetn) begin
  if( !resetn ) begin
    //pwm<='d0;
    addr_bram   <= 'd0;
    counter_fs  <= 'd0;
    en_bram     <= 'd0;
    wea_bram    <= 'd0;
    regcea      <= 'd0;
    signal_bram <= 'd0; 
  end
  else if (locked)
    begin
      en_bram <= 'd1;
      regcea  <= 'd1;
      
      if( counter_fs == FS_AUDIO ) 
        begin
          addr_bram  <= addr_bram + 'd1;
          counter_fs <= 'd0; 
       end
      else 
        begin
          counter_fs <= counter_fs + 'd1;
          if( addr_bram == RAM_DEPTH )  
            addr_bram <= 'd0; 
        end 
   end 
end

reg [5:0] count_aud_sd;

// for pwm use
/*
always@( posedge clk_22m591_pll or negedge resetn ) begin
  if( !resetn ) count_aud_sd<='d0;
  else begin
      case( SW )
          4'b0000: aud_sd_top = 'd0;
          
          4'b0001:
            begin
              if( count_aud_sd == 'd4 ) 
                begin
                  aud_sd_top <= 'd1;
                  count_aud_sd <= 'd0;
                end
                else 
                  begin
                    aud_sd_top <= 'd0;
                    count_aud_sd <= count_aud_sd + 'd1;
                  end
            end
            
          4'b0010: 
            begin
              if( count_aud_sd == 'd3 ) begin
                aud_sd_top <= 'd1;
                count_aud_sd <= 'd0;
              end
              else 
                begin
                  aud_sd_top <= 'd0;
                  count_aud_sd <= count_aud_sd + 'd1;
                end
             end
             
            4'b0100: 
                begin
                    if( count_aud_sd == 'd2 ) begin
                        aud_sd_top <= 'd1;
                        count_aud_sd <= 'd0;
                    end
                    else 
                    begin
                        aud_sd_top <= 'd0;
                        count_aud_sd <= count_aud_sd + 'd1;
                    end
                end
            
            4'b1000: 
              begin
                aud_sd_top <= 'd1;
              end
            
            default : aud_sd_top <= 'd0;
        endcase
    end
end
*/

BRAM bram(
  .addra  ( addr_bram      ),
  .clka   ( clk_22m591_pll ),
  .dina   ( in_bram        ),
  .douta  ( out_bram       ),
  .ena    ( en_bram        ),
  .rsta   ( ~resetn        ),
  .wea    ( wea_bram       ),
  .regcea ( regcea         )
);

top_axis axis(
  .axis_clk         ( clk_22m591_pll ),
  .resetn           ( resetn         ),
  .sw               ( SW[3:0]        ),
  .tx_mclk          ( ja[0]          ),
  .tx_sclk          ( ja[2]          ),
  .tx_lrck          ( ja[1]          ),
  .tx_data          ( ja[3]          ),
  .rx_mclk          ( ja[4]          ),
  .rx_sclk          ( ja[6]          ),
  .rx_lrck          ( ja[5]          ),
  .rx_data          ( ja_7           ),
  .axis_rx_data_my  ( out_bram       )
);

clk_wiz_0 clk_wiz_0(
// Clock out ports
  .clk_22m591(clk_22m591_pll),     
// Clock in ports
  .clk_in1(clock),             
// Status and control signals               
  .locked(locked)
);

/*
pwm dut3(
    //.clk_pwm_i  (cll_pwm),
    .clk_i      (clock),
    .data_i     (out_bram),
    .resetn_i   (resetn),
    .PWM        (pwm)
);
*/
endmodule
