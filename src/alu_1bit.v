`timescale 1ns / 1ps

// ============================================================================
// Module: alu_1bit
// Description: Beginner-friendly 1-bit Arithmetic Logic Unit (ALU).
//              Performs AND, OR, XOR, and ADD on 1-bit inputs A and B.
//              Uses an instantiated 1-bit full adder for the ADD operation.
//
// Operation Table:
//   OP = 2'b00 -> AND : Result = A & B, Cout = 0
//   OP = 2'b01 -> OR  : Result = A | B, Cout = 0
//   OP = 2'b10 -> XOR : Result = A ^ B, Cout = 0
//   OP = 2'b11 -> ADD : Result = Sum(A, B, Cin), Cout = Cout(A, B, Cin)
// ============================================================================

module alu_1bit (
    input  wire       A,        // 1-bit input operand A
    input  wire       B,        // 1-bit input operand B
    input  wire       Cin,      // 1-bit carry input
    input  wire [1:0] OP,       // 2-bit operation selector code
    output reg        Result,   // 1-bit ALU computation result
    output reg        Cout      // 1-bit carry output
);

    // ------------------------------------------------------------------------
    // Step 1: Compute candidate results in parallel
    // In hardware, these logic gates evaluate continuously.
    // ------------------------------------------------------------------------
    wire and_result = A & B;
    wire or_result  = A | B;
    wire xor_result = A ^ B;
    wire add_sum;
    wire add_cout;

    // ------------------------------------------------------------------------
    // Step 2: Instantiate the 1-bit Full Adder for the ADD operation
    // ------------------------------------------------------------------------
    full_adder u_full_adder (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(add_sum),
        .Cout(add_cout)
    );

    // ------------------------------------------------------------------------
    // Step 3: Multiplexer (MUX) to select output based on OP[1:0]
    // The case statement models a 4-to-1 multiplexer in combinational logic.
    // ------------------------------------------------------------------------
    always @(*) begin
        case (OP)
            2'b00: begin // AND operation
                Result = and_result;
                Cout   = 1'b0;
            end
            2'b01: begin // OR operation
                Result = or_result;
                Cout   = 1'b0;
            end
            2'b10: begin // XOR operation
                Result = xor_result;
                Cout   = 1'b0;
            end
            2'b11: begin // ADD operation
                Result = add_sum;
                Cout   = add_cout;
            end
            default: begin
                Result = 1'b0;
                Cout   = 1'b0;
            end
        endcase
    end

endmodule
