function [LdFitLpCoefficient LsFitLpCoefficient] = stp6CalcLinearRefByImp(lnZp, lnZs, lnZd)
% 这个函数是计算P阻抗，S阻抗，rho阻抗的线性回归关系
% 输出
% LdFitLpCoefficient        密度阻抗系数
% LsFitLpCoefficient        横波阻抗系数
%
% 输入
% welllog                   测井曲线
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