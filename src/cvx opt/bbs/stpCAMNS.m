function [ sdata ] = stpCAMNS( xdata )
    xdata = double(xdata);
    
    [L, N] = size(xdata);
    sdata = zeros(L, N);
    
    d = xdata(:, N);
    C = zeros(L, N-1);
    
    for i = 1 : N-1
        C(:, i) = xdata(:, i) - xdata(:, N);
    end
    
    %% 找出第一个源
    r = randn(L, 1);
    [ sdata(:, 1), ~] = stpCvxLp( C, d, r, 'min', L, N);
    [ sdata(:, 2), ~] = stpCvxLp( C, d, -r, 'min', L, N);
    
    [vn] = stpNormalVector(sdata(:, 1) - sdata(:, 2));
    
    [ v3, ~] = stpCvxLp( C, d, vn, 'min', L, N);
    if( abs ( vn' * (v3 - sdata(:, 1) ) ) < 1e-5)
        [ v3, ~] = stpCvxLp( C, d, -vn, 'min', L, N);
    end
       
    sdata(:, 3) = v3;
    
%     I = eye(L);
%     
%     while (l < N)
%         [Q, R] = qr(sdata(:, l));
%         B = I - Q * Q';
%         
%         r = B * randn(L, 1);
%         
%         [ sdata(:, l+1), cvx_optval] = stpCvxLp( C, d, r, 'min', L, N);
%         if( abs (cvx_optval) > 1e-5)
%             l = l + 1;
%         end
%         if( l >= N)     
%             break;
%         end
%         
%         [ sdata(:, l+1), cvx_optval] = stpCvxLp( C, d, r, 'max', L, N);
%         if( abs (cvx_optval) > 1e-5)
%             l = l + 1;
%             if( l >= N)     
%                 break;
%             end
%         end
%         
%     end
end

