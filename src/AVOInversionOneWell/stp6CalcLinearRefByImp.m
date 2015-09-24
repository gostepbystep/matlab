function [LdFitLpCoefficient LsFitLpCoefficient] = stp6CalcLinearRefByImp(lnZp, lnZs, lnZd)
% ��������Ǽ���P�迹��S�迹��rho�迹�����Իع��ϵ
% ���
% LdFitLpCoefficient        �ܶ��迹ϵ��
% LsFitLpCoefficient        �Შ�迹ϵ��
%
% ����
% welllog                   �⾮����
%     tVp = welllog(:, 2);
%     tVs = welllog(:, 3);
%     tRho = welllog(:, 4);
% 
%     lnZp = log( tVp .* tRho );
%     lnZs = log( tVs .* tRho );
%     lnZd = log( tRho );

    figure;
    plot(lnZp, lnZs, 'r');
    hold on;
    plot(lnZp, lnZd, 'b');
    legend('Zp-Zs', 'Zp-Zd');
    
    LdFitLpCoefficient = polyfit(lnZp',lnZd', 1);
    LsFitLpCoefficient = polyfit( lnZp', lnZs',1);
    
end