module vending_machine_multiple_item(
    input clk,
    input rst,
    input [1:0] coin, // 01=Rs5, 10=Rs10
    input sel,        // 0=ItemA (Rs15), 1=ItemB (Rs20)
    output reg dispense_a,
    output reg dispense_b,
    output reg change        // Added change output (Rs 5)
);

    parameter s0  = 3'b000,
              s5  = 3'b001,
              s10 = 3'b010,
              s15 = 3'b011,
              s20 = 3'b100;

    reg [2:0] state, next_state;

    // 1. State Register (Sequential Logic)
    always @(posedge clk or posedge rst) begin 
        if (rst)
            state <= s0;
        else
            state <= next_state;
    end

    // 2. Next State Logic (Combinational Logic)
    always @(*) begin
        case(state)
            s0: begin
                if (coin == 2'b01)      next_state = s5;
                else if (coin == 2'b10) next_state = s10;
                else                    next_state = s0;
            end
            s5: begin
                if (coin == 2'b01)      next_state = s10;
                else if (coin == 2'b10) next_state = s15;
                else                    next_state = s5;
            end
            s10: begin
                if (coin == 2'b01)      next_state = s15;
                else if (coin == 2'b10) next_state = s20;
                else                    next_state = s10;
            end
            s15: begin
                if (sel == 0)           next_state = s0;  // Dispense A and reset
                else if (coin == 2'b01) next_state = s20; // 15 + 5 = 20
                else if (coin == 2'b10) next_state = s20; // 15 + 10 = 25 (Needs Change)
                else                    next_state = s15;
            end
            s20: next_state = s0; // Dispense B and reset
            default: next_state = s0;
        endcase
    end

    // 3. Output Logic (Hybrid Moore/Mealy for Change)
    always @(*) begin 
        dispense_a = 0;
        dispense_b = 0;
        change = 0;
        
        case(state)
            s15: begin
                if (sel == 0) dispense_a = 1;
                // If user wants Item B but overpays with Rs 10 at Rs 15
                if (sel == 1 && coin == 2'b10) change = 1; 
            end
            s20: begin
                if (sel == 1) dispense_b = 1;
            end
        endcase
    end
endmodule