% ²âÊÔbfgsµÄ³ÌĞò
m = 10000;
n = 15;
A = round(8 * rand(m, n));
xn = round( 100 * rand(n, 1) );
    
B = A * xn;

%B = B + round(1 * rand(m, 1));

x0 = round( 100 * rand(n, 1) );

out = stpBFGSEqual(A, x0, B, 5000);