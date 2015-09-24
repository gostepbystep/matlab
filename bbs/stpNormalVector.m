function [ out ] = stpNormalVector( v )
    n = length( v );
    
    cvx_begin
        variable s(n);
        
        minimize abs(v' * s);
    cvx_end
    
    out = s / norm(s);
    
end

