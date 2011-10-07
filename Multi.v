module Multi( A,
              B,
              N,
              clk,
              start,
              out, 
              done );

// ==== IO ==== //
  input [255:0] A, B, N;
  input clk;
  input start;  // negedge
  output [255:0] out;
  output done;  // posedge

// ==== Claim ====/
  reg [255:0] a, b;
  reg [255:0] a1;
  reg [258:0] accu1, accu2, accu3, n;
  reg done;
  reg enable_clk;
  reg [10:0] i1, i2;

/* ==== Start Case ==== //
  always @(negedge start) begin
    accu1 = 258'd0;
    a = A;
    b = B;
    n = { 3'd0, N[255:0] };
    done =1'b0;
    $display("Start!!");
    $display("A = %h", a);
    $display("B = %h", b);
    $display("N = %h", n);
    enable_clk =1'b1;
  end
*/

// ==== Combinational Part ==== //

  always @(*) begin

    if ( a[0] ==1'b1 ) begin
      accu2 = accu1 + b;
    end
    else begin
      accu2 = accu1;
    end

    if (accu2[0] ==1'b1) begin
      if (accu2 >= n) begin
        accu3 = accu2 - n;
      end
      else begin
        accu3 = accu2 + n;
      end
    end
    else begin
      accu3 = accu2;
    end

    a1 = {1'b0, a[255:1] };
    i2 = i1;

  end

  assign out[255:0] = accu1[255:0];

// ==== Sequential Part ==== //

  always @(posedge clk or negedge start) begin
    if (~start) begin
      accu1 = 258'd0;
      a = A;
      b = B;
      n = { 3'd0, N[255:0] };
      done =1'b0;
      $display("Start!!");
      $display("A = %h", a);
      $display("B = %h", b);
      $display("N = %h", n);
      enable_clk =1'b1;
      i1 = 11'd0;
    end
    else begin
      if (done == 1'b1) begin
        accu1 = accu3;
      end
      else begin
        accu1 = {1'b0, accu3[258:1]};
        a = a1;
        i1 = i2+1;
        $display ("Clock is ticking now! XD");
      end
    end
  end
// ==== End Case ==== //
  always @( i2 >= 11'd256 ) begin
    if (accu3 >=n) begin
      $display("Error");
    end
    $display("out = %h", accu3);
    done =1'b1;
    enable_clk = 1'b0;
  end

endmodule
