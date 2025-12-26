//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_comparator_least_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // States
  enum logic[2:0]
  {
     st_a_less_b    = 3'b100,
     st_equal       = 3'b010,
     st_a_greater_b = 3'b001
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      st_equal       : if (~ a &   b) new_state = st_a_less_b;
                  else if (  a & ~ b) new_state = st_a_greater_b;
      st_a_less_b    : if (  a & ~ b) new_state = st_a_greater_b;
      st_a_greater_b : if (~ a &   b) new_state = st_a_less_b;
    endcase

    // verilator lint_on  CASEINCOMPLETE
  end

  // Output logic
  assign { a_less_b, a_eq_b, a_greater_b } = new_state;

  always_ff @ (posedge clk)
    if (rst)
      state <= st_equal;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_comparator_most_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // Task:
  // Implement a serial comparator module similar to the previus exercise
  // but use the Finite State Machine to evaluate the result.
  // Most significant bits arrive first.

  // States
  enum logic[2:0] {
     st_a_less_b    = 3'b001,
     st_equal       = 3'b010,
     st_a_greater_b = 3'b100
  }
  state, new_state;

  // State transition logic
  always_comb begin
    new_state = state;

    unique case(state)
      st_equal: begin
      if(~a & b)
        new_state = st_a_less_b;
      else if(a & ~ b)
        new_state = st_a_greater_b;
      end
      st_a_greater_b, st_a_less_b: new_state = state;
    endcase
  end
  assign { a_greater_b, a_eq_b, a_less_b } = new_state;

  always_ff @(posedge clk) begin
    state <= rst ? st_equal: new_state;
  end

endmodule
