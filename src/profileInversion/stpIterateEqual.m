function [xOut] = stpIterateEqual(A, xInit, B, iterNum)
% 计算AX = B的算法，迭代X
% 
% 输出
% 迭代后的x的值
%
% 输入
% A                 A矩阵
% xInit             初始的X矩阵
% B                 初始的B矩阵
% iterNum           迭代次数

    [m, n] = size(A);

    xOut = xInit;

    error = 1e-4;
    
    % 下面注释的是钱老师的代码
%     for i = 1 : iterNum
%         e = B - A * xOut;
%         g = zeros(n, 1);
% 
%         for ii = 1 : length(e);
%             g = g + 0.2 * 4 * e(ii) * e(ii) * e(ii) *( -A(ii, :) )';
%             g = g + 0.8 * e(ii) * (- A(ii, :) )';
%         end
%         dr = -g;
%         alpha = e' * A * dr / (dr' * A' * A * dr);%adaptive stepsize
%         xOut = xOut + alpha*dr;
%         
%         if( sqrt( mse(e) ) < error )
%             break;
%         end
%         RMSE(i) = sqrt( mse(e) );
%     end

    AA = A' * A;
    AB = A' * B;

    for i = 1 : iterNum
        e = A * xOut - B;
        
        dr = AA * xOut - AB;
        alpha = e' * A * dr / (dr' * AA * dr);      % 工具公式完成的代码
        xOut = xOut - alpha * dr;

        RMSE(i) = sqrt( mse(e) );
        if ( i>=2 && abs(RMSE(i-1)-RMSE(i)) < error)
            break;
        end
    end
%     figure; plot(RMSE(2:iterNum)); grid on; title('均方误差');
end