`timescale 1ns/1ps
module multiplier(a,b, c); //8 bit multiplier

	input [7:0] a;
	input [7:0] b;
	output [7:0] c;
	wire[15:0] ans= a * b;
	
	assign c= (ans[15:8] == 8'b0) ? ans : 8'b11111111;

endmodule
module multiplier_24(a,b,c);// 24 bit multiplier , one line 
	input [23:0] a;
	input [23:0] b;
	output [7:0] c;
	wire[7:0] result1,result2,result3;
	multiplier first(.a(a[7:0]),.b(b[7:0]),.c(result1));
	multiplier sec(.a(a[15:8]),.b(b[15:8]),.c(result2));
	multiplier third(.a(a[23:16]),.b(b[23:16]),.c(result3));
	wire[15:0] ans= result1+ result2+result3;

	assign c= (ans[15:8] == 8'b0) ? ans : 8'b11111111;
endmodule

module multiplier_3x3(a0,a1,a2,b0,b1,b2,c);//full iteration
	input [23:0] a0;
	input [23:0] a1;
	input [23:0] a2; 
	input [23:0] b0;
	input [23:0] b1;
	input [23:0] b2;
	output [7:0] c;
	wire[7:0] result1,result2,result3;
	
	multiplier_24 firstrow(.a(a0),.b(b0),.c(result1));
	multiplier_24 secrow(.a(a1),.b(b1),.c(result2));
	multiplier_24 thirdrow(.a(a2),.b(b2),.c(result3));
	wire[15:0] ans= result1+ result2+result3;

	assign c= (ans[15:8] == 8'b0) ? ans : 8'b11111111;
endmodule

 module average(a,b,c,d,outt);
	input [7:0] a;
	input [7:0] b;
	input [7:0] c;
	input [7:0] d;
	output [7:0]outt;
	wire[15:0] result=a+b+c+d;
	assign outt=result[9:2];
endmodule

module square(a,avg,outt);
	input [7:0] a;
	input [7:0] avg;
	output [15:0]outt;
	wire[7:0] result=(a>avg)? a-avg : avg-a; //abs
	wire [15:0] post_square=result*result;
	assign outt={2'b0,post_square[15:2]}; //divide by 4
endmodule


 

 



// Module Declaration
module ai_accel
(
        rst_n		,  // Reset Neg
        clk,             // Clk
        addr		,  // Address
		  wr_en,		//Write enable
		  accel_select,
		  data_in,
		  ctr,
        data_out	   // Output Data
    );
	 
	 input rst_n;
	 input clk;
	 input [31:0] addr;
	 input wr_en;
	 input accel_select;
	 input [31:0] data_in;
	 output [31:0] data_out;
	 output [15:0] ctr;
	 
	 
	 reg [31:0] data_out;
 
	 reg go_bit;
	 wire go_bit_in;
	 reg done_bit;
	 wire done_bit_in;

	 reg [15:0] counter;
	 reg [31:0] data_A0;
	 reg [31:0] data_A1;
	 reg [31:0] data_A2;
	 reg [31:0] data_B0;
	 reg [31:0] data_B1;
	 reg [31:0] data_B2;
	 reg [31:0] data_B3;
	 reg [31:0] result;
	 
	 wire [7:0] level3_avg;
	
	 wire [31:0] data_C;
	 wire [31:0] data_C2;

	 
	 reg [7:0] in1, in2;
	 wire[7:0] out;

	 assign ctr = counter;
	 
	 always @(addr[5:2], data_A0,data_A1,data_A2, data_B0,data_B1,data_B2,data_B3, data_C,data_C2, counter, done_bit, go_bit, counter) begin
		case(addr[5:2])
		4'b1000: data_out = {done_bit, 30'b0, go_bit};
		4'b1001: data_out = {16'b0, counter}; 
		4'b1010: data_out = data_A0;
		4'b1011: data_out = data_A1;
		4'b1100: data_out = data_A2;
		4'b1101: data_out = data_B0;
		4'b1110: data_out = data_B1;
		4'b1111: data_out = data_B2;
		4'b0000: data_out = data_B3;
		4'b0001: data_out = data_C;
		4'b0010: data_out = data_C2;
		default: data_out = 32'b0;
		endcase
	 end
	 
	 assign go_bit_in = (wr_en & accel_select & (addr[5:2] == 4'b1000));
	
	 always @(posedge clk or negedge rst_n)
		if(~rst_n) go_bit <= 1'b0;
		else go_bit <=  go_bit_in ? 1'b1 : 1'b0;
		
	 always @(posedge clk or negedge rst_n)
		if(~rst_n) begin
			counter <=16'b0;
			data_A0 <= 32'b0;
			data_A1 <= 32'b0;
			data_A2 <= 32'b0;
			data_B0 <= 32'b0;
			data_B1 <= 32'b0;
			data_B2 <= 32'b0;
			data_B3 <= 32'b0;
		end
		
		else begin
			if (wr_en & accel_select) begin
				data_A0 <= (addr[5:2] == 4'b1010) ? data_in : data_A0;
				data_A1 <= (addr[5:2] == 4'b1011) ? data_in : data_A1;
				data_A2 <= (addr[5:2] == 4'b1100) ? data_in : data_A2;
				data_B0 <= (addr[5:2] == 4'b1101) ? data_in : data_B0;
				data_B1 <= (addr[5:2] == 4'b1110) ? data_in : data_B1;
				data_B2 <= (addr[5:2] == 4'b1111) ? data_in : data_B2;
				data_B3 <= (addr[5:2] == 4'b0000) ? data_in : data_B3;
			end
			else begin
				data_A0 <= data_A0;
				data_A1 <= data_A1;
				data_A2 <= data_A2;
				data_B0 <= data_B0;
				data_B1 <= data_B1;
				data_B2 <= data_B2;
				data_B3 <= data_B3;
			end
			counter <= go_bit_in? 16'h00 : done_bit_in ? counter : counter +16'h01;
		end
		
	 		
//	 always @(data_A, counter) begin
//		case(counter)
//		16'b0: 	in1 = data_A[7:0];
//		16'b1:	in1 = data_A[15:8];
//		default: in1 = data_A[7:0];
//		endcase
//	 end
//	
//	  always @(data_B, counter) begin
//		case(counter)
//		32'b0: 	in2 = data_B[7:0];
//		32'b1:	in2 = data_B[15:8];
//		default: in2 = data_B[7:0];
//		endcase
//	 end
	 

	wire[7:0] result1,result2,result3,result4;

	 multiplier_3x3 firstitert(.a0(data_A0),.a1(data_A1),.a2(data_A2),.b0(data_B0[31:8]),.b1(data_B1[31:8]),.b2(data_B2[31:8]),.c(result1));
	 multiplier_3x3 secitert(.a0(data_A0),.a1(data_A1),.a2(data_A2),.b0(data_B0[23:0]),.b1(data_B1[23:0]),.b2(data_B2[23:0]),.c(result2));
	 multiplier_3x3 thirditeret(.a0(data_A0),.a1(data_A1),.a2(data_A2),.b0(data_B1[31:8]),.b1(data_B2[31:8]),.b2(data_B3[31:8]),.c(result3));
	 multiplier_3x3 fourthiteret(.a0(data_A0),.a1(data_A1),.a2(data_A2),.b0(data_B1[23:0]),.b1(data_B2[23:0]),.b2(data_B3[23:0]),.c(result4));

	average step3(.a(result1),.b(result2),.c(result3),.d(result4),.outt(level3_avg));
	
	wire [31:0] result_in;
	
	//taking care of the normilized matrix data_c
	assign result_in[31:24]=(result1>level3_avg) ? result1-level3_avg : 8'b0;
	assign result_in[23:16]=(result2>level3_avg) ? result2-level3_avg : 8'b0;
	assign result_in[15:8]=(result3>level3_avg) ? result3-level3_avg : 8'b0;
	assign result_in[7:0]=(result4>level3_avg) ? result4-level3_avg : 8'b0;
	
	//taking care of the variance
	wire[15:0] resultcov1,resultcov2,resultcov3,resultcov4;
	square firstcov(.a(result1),.avg(level3_avg),.outt(resultcov1));
	square seccov(.a(result2),.avg(level3_avg),.outt(resultcov2));
	square thirdcov(.a(result3),.avg(level3_avg),.outt(resultcov3));
	square fourthcov(.a(result4),.avg(level3_avg),.outt(resultcov4));
	assign data_C2={16'b0, resultcov1} +{16'b0,resultcov2}+{16'b0,resultcov3}+{16'b0,resultcov4};
	
	
	//prints stable original	
//	assign result_in[31:24]=result1;
//	assign result_in[23:16]=result2;
//	assign result_in[15:8]=result3;
//	assign result_in[7:0]=result4;
	
	//else if
//	assign result_in = (counter==16'd0) ? {result[31:8], out} : 
//							(counter==16'd1) ? {result[31:16], out, result[7:0]}:
//							 result;
							 
	 always @(posedge clk or negedge rst_n)
		if(~rst_n) result <=32'h0;
		else result <= result_in;
	 	 
	 assign data_C = result;
	 
//	 assign done_bit_in = (counter == 16'd2);
	 
	 always @(posedge clk or negedge rst_n)
		if(~rst_n) done_bit <= 1'b0;
		else done_bit <= go_bit_in ? 1'b0 : done_bit_in;
	 
endmodule