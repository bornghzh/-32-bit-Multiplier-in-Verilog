`timescale 1ns/1ns
module multiplier4#(parameter nb = 32)
(
//---------------------Port directions and deceleration
   input clk,  
   input start,
   input [nb-1:0] A,
   input [nb-1:0] B, 
   output reg signed [(2*nb)-1:0] Product,
   output ready
    );




//----------------------------------------------------

//--------------------------------- register deceleration
reg [nb-1:0] Multiplicand;
reg [$clog2(nb):0] counter;
//-----------------------------------------------------

//----------------------------------- wire deceleration
wire [nb:0] adder_output;
wire c_out;
wire [nb-1:0] chose;
//-------------------------------------------------------

//------------------------------------ combinational logic
assign ready = counter[$clog2(nb)];
assign chose=Product[0] ? Multiplicand : {nb{1'b0}};
assign adder_output =counter==(nb-1)?    {Product[(2*nb)-1],Product[(2*nb)-1:nb]} +1+~{chose[nb-1],chose} :   {Product[(2*nb)-1],Product[(2*nb)-1:nb]} + {chose[nb-1],chose};
//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= {(nb/2){1'b0}} ;
      Multiplicand <= A;
      Product <= {{nb{1'b0}}, B};
   end

   else if(! ready) begin
         Product <= { adder_output, Product[nb-1:1]};
         counter <= counter + 1;
   end   

endmodule
