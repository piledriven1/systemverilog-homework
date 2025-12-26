//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input              clk,
    input              rst,
    input        [1:0] requests,
    output logic [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01
    logic preference, next_preference;

    always_comb begin
      case(requests)
        2'b00: begin
          grants = 2'b00;
        end
        2'b01: begin
          grants = 2'b01;
          next_preference = 1;
        end
        2'b10: begin
          grants = 2'b10;
          next_preference = 0;
        end
        2'b11: begin
          if(!preference) begin
            grants = 2'b01;
            next_preference = 1;
          end else begin
            grants = 2'b10;
            next_preference = 0;
          end
        end
      endcase
    end

    always_ff @ (posedge clk) begin
      if(rst) begin
        preference <= 0;
      end else begin
        preference <= next_preference;
      end
    end

endmodule
