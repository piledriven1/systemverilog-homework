//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110

  logic curr_out;
  logic [7:0] curr_count_ones, pending;

  assign b = curr_out;

  always_ff @ (posedge clk) begin
    if(rst) begin
      overflow <= 1'b0;
      curr_out <= 1'b0;
      curr_count_ones <= 8'd0;
      pending <= 8'd0;
    end else begin
      if(overflow) begin
        curr_out <= 1'b1;
        overflow <= 1'b1;
        curr_count_ones <= curr_count_ones;
        pending <= pending;
      end else begin
        if(curr_count_ones < 8'd200) begin
          overflow <= 1'b0;
          if(a) begin
            pending <= pending + 1;
            curr_out <= 1'b1;
            curr_count_ones <= curr_count_ones + 1;
          end else begin
            curr_count_ones <= 8'd0;
            if(pending > 0) begin
              pending <= pending - 1;
              curr_out <= 1'b1;
            end else begin
              curr_out <= 1'b0;
              pending <= pending;
            end
          end
        end else begin
          overflow <= 1'b1;
          curr_out <= 1'b1;
          curr_count_ones <= curr_count_ones;
          pending <= pending;
        end
      end
    end
  end

endmodule
