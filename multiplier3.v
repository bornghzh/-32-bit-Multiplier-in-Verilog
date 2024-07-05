`timescale 1ns/1ns
module multiplier3(
//---------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A,
   input [7:0] B, 
   output reg signed [15:0] Product,
   output ready
    );



//----------------------------------------------------

//--------------------------------- register deceleration
reg [7:0] Multiplicand;
reg [3:0] counter;
//-----------------------------------------------------

//----------------------------------- wire deceleration
wire [8:0] adder_output;
wire c_out;
wire [7:0] chose;
//-------------------------------------------------------

//------------------------------------ combinational logic
assign ready = counter[3];
assign chose=Product[0] ? Multiplicand : 8'h00;
assign adder_output =counter==7?    {Product[15],Product[15:8]} +1+~{chose[7],chose} :   {Product[15],Product[15:8]} + {chose[7],chose};
//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Multiplicand <= A;
      Product <= {8'h00, B};
   end

   else if(! ready) begin
         Product <= { adder_output, Product[7:1]};
         counter <= counter + 1;
   end   

endmodule
