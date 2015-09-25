function [xOut] = stpIterateEqual(A, xInit, B, iterNum)
% ����AX = B���㷨������X
% 
% ���
% �������x��ֵ
%
% ����
% A                 A����
% xInit             ��ʼ��X����
% B                 ��ʼ��B����
% iterNum           ��������

    [m, n] = size(A);

    xOut = xInit;

    error = 1e-4;
    
    % ����ע�͵���Ǯ��ʦ�Ĵ���
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
        alpha = e' * A * dr / (dr' * AA * dr);      % ���߹�ʽ��ɵĴ���
        xOut = xOut - alpha * dr;

        RMSE(i) = sqrt( mse(e) );
        if ( i>=2 && abs(RMSE(i-1)-RMSE(i)) < error)
            break;
        end
    end
%     figure; plot(RMSE(2:iterNum)); grid on; title('�������');
end