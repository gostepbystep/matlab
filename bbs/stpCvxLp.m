function [ out, cvx_optval] = stpCvxLp( C, d, r, type, L, N)
    cvx_begin
        variable s(L);
        variable param(N-1);
        
        if( strcmp(type, 'min') == 1 )
            minimize( r' * s );
        else
            maximize( r' * s);
        end
        subject to
            s == C * param + d;
            s >= 0;
    cvx_end
    
    out = s;
end

