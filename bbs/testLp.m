L = 5;
N = 4;
C = rand(L, N-1);
d = rand(L, 1);
r = rand(L, 1);

cvx_begin
    variable s(L);
    variable param(N-1);
    
    minimize( r' * s );
    subject to
        s == C * param + d;
        s >= 0;
cvx_end