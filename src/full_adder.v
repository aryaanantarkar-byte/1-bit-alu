`timescale 1ns / 1ps

// ============================================================================
// Module: full_adder
// Description: Beginner-friendly 1-bit Full Adder using Boolean logic.
//              Adds two 1-bit operands (A, B) and a carry-in (Cin).
//              Outputs a 1-bit Sum and a 1-bit carry-out (Cout).
// ============================================================================

module full_adder (
    input  wire A,
    input  wire B,
    input  wire Cin,
    output wire Sum,
    output wire Cout
);

    // Sum bit is 1 when an odd number of inputs are 1:
    // Sum = A ^ B ^ Cin
    assign Sum = A ^ B ^ Cin;

    // Carry-out bit is 1 when at least two inputs are 1 (majority logic):
    // Cout = (A & B) | (A & Cin) | (B & Cin)
    assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule
