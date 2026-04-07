 module vending_machine_multiple_item_tb();

    // 1. Internal Signals
    reg clk;
    reg rst;
    reg [1:0] coin;
    reg sel;
    wire dispense_a;
    wire dispense_b;
    wire change;

    // 2. Instantiate the Unit Under Test (UUT)
    vending_machine_multiple_item uut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .sel(sel),
        .dispense_a(dispense_a),
        .dispense_b(dispense_b),
        .change(change)
    );

    // 3. Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // 4. Stimulation Block
    initial begin
        // Initialize
        rst = 1;
        coin = 2'b00;
        sel = 0;
        
        $monitor("Time=%0t | State=%b | Coin=%b | Sel=%b | Disp_A=%b | Disp_B=%b | Change=%b", 
                  $time, uut.state, coin, sel, dispense_a, dispense_b, change);

        #10 rst = 0;

        // --- Case 1: Buy Item A (Rs 15) using 10 + 5 ---
        $display("\n--- Testing Item A (10 + 5) ---");
        sel = 0; 
        @(negedge clk) coin = 2'b10; // Rs 10
        @(negedge clk) coin = 2'b00; // Pulse end
        @(negedge clk) coin = 2'b01; // Rs 5
        @(negedge clk) coin = 2'b00; // Pulse end -> Should dispense_a here
        
        #20;

        // --- Case 2: Buy Item B (Rs 20) using 10 + 10 ---
        $display("\n--- Testing Item B (10 + 10) ---");
        sel = 1;
        @(negedge clk) coin = 2'b10; // Rs 10
        @(negedge clk) coin = 2'b00; 
        @(negedge clk) coin = 2'b10; // Rs 10
        @(negedge clk) coin = 2'b00; // Should dispense_b here

        #20;

        // --- Case 3: Overpayment (Change Logic) ---
        // Scenario: Rs 10 + Rs 5 + Rs 10 (Total 25) for Item B (Rs 20)
        $display("\n--- Testing Item B Overpayment (10 + 5 + 10) ---");
        sel = 1;
        @(negedge clk) coin = 2'b10; // Total 10
        @(negedge clk) coin = 2'b00;
        @(negedge clk) coin = 2'b01; // Total 15
        @(negedge clk) coin = 2'b00;
        @(negedge clk) coin = 2'b10; // Total 25 -> Should dispense_b AND change
        @(negedge cl