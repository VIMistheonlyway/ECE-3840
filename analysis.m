
syms V_DUT C_DUT R_DUT V_ARB Z_ARB C_DMM R_DMM  real
syms w  real

XC_DUT = 1 ./ (1i .* w .* C_DUT);
Z_DUT = R_DUT + XC_DUT;

XC_DMM = 1 ./ (1i .* w .* C_DMM);
Z_DMM = (R_DMM .* XC_DMM) ./ (R_DMM + XC_DMM);

V_DUT = (V_ARB .* ((Z_DUT .*Z_DMM) ./ (Z_DMM + Z_DUT))) ./ (Z_ARB + ((Z_DUT .*Z_DMM) / (Z_DMM + Z_DUT)))
V_DUT = simplifyFraction( expand(V_DUT) )

fprintf('\n:: limit(V_DUT,w,0) ::\n\n');    %as w goes to 0
limit(V_DUT, w, 0)

fprintf('\n:: limit(V_DUT,w,+inf) ::\n\n'); %as w goes to positive infinity
limit(V_DUT, w, +inf)

vars = [     C_DUT  R_DUT   R_DMM  V_ARB C_DMM Z_ARB];     % variables
vals = [ 0.1e-6  510  1e6   1  100e-9 50];     % values
v_dut = subs(V_DUT, vars, vals);

sympref('FloatingPointOutput',true);
v_dut = simplifyFraction( v_dut )

fprintf('\n:: limit(v_dut,w,0) ::\n\n'); %part d answer
limit(v_dut, w, 0)

fprintf('\n:: limit(v_dut,w,+inf) ::\n\n'); %part f answer
limit(v_dut, w, +inf)

%testing at different frequencies
mf_v_dut = matlabFunction( v_dut )
test_frequencies_hz = [50 500 5000 50000]  % Hz
two_pi = 2 * pi;
test_frequencies_w = test_frequencies_hz .* two_pi  % rad/s
v_dut_w = abs( mf_v_dut(test_frequencies_w) )
