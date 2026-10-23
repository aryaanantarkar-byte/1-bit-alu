`timescale 1ns / 1ps

// ============================================================================
// Module: alu_1bit_tb
// Description: Exhaustive self-checking testbench for 1-bit ALU.
//              Systematically tests all 32 combinations:
//              - 4 operations (OP = 00, 01, 10, 11)
//              - 2 states of A (0, 1)
//              - 2 states of B (0, 1)
//              - 2 states of Cin (0, 1)
//              Total tests = 4 * 2 * 2 * 2 = 32 tests.
// ============================================================================

module alu_1bit_tb;

    // ------------------------------------------------------------------------
    // Signals to connect to the Device Under Test (DUT)
    // Inputs to DUT are driven by 'reg' in testbench.
    // Outputs from DUT are observed using 'wire' in testbench.
    // ------------------------------------------------------------------------
    reg        A;
    reg        B;
    reg        Cin;
    reg  [1:0] OP;

    wire       Result;
    wire       Cout;

    // Golden model variables for automatic self-checking
    reg        expected_result;
    reg        expected_cout;
    reg [31:0] op_name; // 4-character ASCII string for display ("AND ", etc.)

    // Loop indices and test counters
    integer i_op;
    integer i_a;
    integer i_b;
    integer i_cin;
    integer test_num;
    integer pass_count;
    integer fail_count;

    // ------------------------------------------------------------------------
    // Instantiate Device Under Test (DUT)
    // ------------------------------------------------------------------------
    alu_1bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .OP(OP),
        .Result(Result),
        .Cout(Cout)
    );

    // ------------------------------------------------------------------------
    // Test Procedure
    // ------------------------------------------------------------------------
    initial begin
        // Set up waveform dumping for GTKWave
        $dumpfile("alu_1bit.vcd");
        $dumpvars(0, alu_1bit_tb);

        // Initialize counters and inputs
        test_num   = 0;
        pass_count = 0;
        fail_count = 0;
        A   = 1'b0;
        B   = 1'b0;
        Cin = 1'b0;
        OP  = 2'b00;

        $display("=================================================================");
        $display("              STARTING 1-BIT ALU EXHAUSTIVE TEST                 ");
        $display("=================================================================");
        $display("Test # | OP (Name) | A B Cin | Result Cout | Expected | Status");
        $display("-----------------------------------------------------------------");

        // Loop systematically through all 32 combinations
        for (i_op = 0; i_op < 4; i_op = i_op + 1) begin
            for (i_a = 0; i_a < 2; i_a = i_a + 1) begin
                for (i_b = 0; i_b < 2; i_b = i_b + 1) begin
                    for (i_cin = 0; i_cin < 2; i_cin = i_cin + 1) begin
                        test_num = test_num + 1;

                        // 1. Apply inputs
                        OP  = i_op[1:0];
                        A   = i_a[0];
                        B   = i_b[0];
                        Cin = i_cin[0];

                        // 2. Compute expected golden outputs
                        case (OP)
                            2'b00: begin // AND
                                expected_result = A & B;
                                expected_cout   = 1'b0;
                                op_name         = "AND ";
                            end
                            2'b01: begin // OR
                                expected_result = A | B;
                                expected_cout   = 1'b0;
                                op_name         = "OR  ";
                            end
                            2'b10: begin // XOR
                                expected_result = A ^ B;
                                expected_cout   = 1'b0;
                                op_name         = "XOR ";
                            end
                            2'b11: begin // ADD
                                expected_result = A ^ B ^ Cin;
                                expected_cout   = (A & B) | (A & Cin) | (B & Cin);
                                op_name         = "ADD ";
                            end
                        endcase

                        // 3. Wait 10 simulation time units for logic to settle
                        #10;

                        // 4. Verify outputs against golden model
                        if ((Result === expected_result) && (Cout === expected_cout)) begin
                            $display("  %2d   | %b (%s) | %b %b  %b  |   %b     %b   |   %b     %b   | PASS",
                                     test_num, OP, op_name, A, B, Cin, Result, Cout, expected_result, expected_cout);
                            pass_count = pass_count + 1;
                        end else begin
                            $display("  %2d   | %b (%s) | %b %b  %b  |   %b     %b   |   %b     %b   | FAIL ***",
                                     test_num, OP, op_name, A, B, Cin, Result, Cout, expected_result, expected_cout);
                            fail_count = fail_count + 1;
                        end
                    end
                end
            end
        end

        // --------------------------------------------------------------------
        // Summary Report
        // --------------------------------------------------------------------
        $display("-----------------------------------------------------------------");
        $display("TEST SUMMARY: %0d Total | %0d PASSED | %0d FAILED", test_num, pass_count, fail_count);
        $display("=================================================================");

        if (fail_count == 0) begin
            $display(">>> ALL 32 TESTS PASSED SUCCESSFULLY! <<<");
        end else begin
            $display(">>> SOME TESTS FAILED! CHECK OUTPUT ABOVE. <<<");
        end

        $finish;
    end

endmodule
