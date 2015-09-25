function [tVp tVs tRho GMatrix R SeismicAngleTraceVector LsFitLpCoefficient LdFitLpCoefficient] = stp7CalcInversionParam(welllog, angleSeisData, angleData)
% 本程序是用来计算正演参数的
% 输出
%
%
% 输入
% 


    tVp = welllog(:, 2);
    tVs = welllog(:, 3);
    tRho = welllog(:, 4);

%     tVp( tVp(1:10, 1) > 4200, 1 ) = 4200; 
%     tVs( tVs(1:10, 1) > 2300, 1 ) = 2300;
%     tVp( tVp(75:80, 1) > 4200, 1 ) = 4200; 
%     tVs( tVs(:, 1) > 2450, 1) = 2450;
%     tVs( tVs(:, 1) < 2300, 1 ) = 2300;
%     tVs( tVs(75:80, 1) > 2450, 1 ) = 2450;
% % 
%     f = 0.7;    [b, a] = butter(10, f, 'low');
%     tVp  = filtfilt(b, a, tVp); 
%     tVs = filtfilt(b, a, tVs); 
%     tRho = filtfilt(b, a, tRho); 
   
    sampNum = length(tVp);
    angleSampNum = sampNum - 1;

    % f = 0.3;    [b,a] = butter(10, f, 'low');
    [~, c1, c2, c3] = Aki_syn(angleData, tVp(:, 1)', tVs(:, 1)', tRho(:, 1)');
   
    %计算LP,LS,Ld
    Lp = log(tRho .* tVp);
    Ls = log(tRho .* tVs);
    Ld = log(tRho);
    
    %% 第6步, 求出线性回归系数
    [LsFitLpCoefficient, ~] = polyfit(Lp, Ls, 1);
    [LdFitLpCoefficient, ~] = polyfit(Lp, Ld, 1);

    %找到角道集不为零的位置，计算对应的G矩阵
    indexCDP = find( mean(abs(angleSeisData), 1) );
    minCDP = indexCDP(1);
    maxCDP = indexCDP(length(indexCDP));
    rangeCDP = minCDP : maxCDP;

    GMatrix = GenAMatrix(rangeCDP, c1,c2,c3, Lp,Ls,Ld, 1,LsFitLpCoefficient(1), LdFitLpCoefficient(1));   %提取传播矩阵
 
    %计算反射系数
    deltaLs = Ls - ( LsFitLpCoefficient(1)*Lp + LsFitLpCoefficient(2) ); 
    deltaLd = Ld - ( LdFitLpCoefficient(1)*Lp + LdFitLpCoefficient(2) ); 

    R = [Lp; deltaLs; deltaLd];          %提取反射系数向量

% %     将角道集数据写成一列
%     SeismicAngleTraceVector = zeros( (maxCDP-minCDP+1) * angleSampNum, 1 );
%     for i = minCDP : 1 : maxCDP
%         index = (i - minCDP) * angleSampNum;
%         SeismicAngleTraceVector( index+1:index+angleSampNum, 1 ) = angleSeisData(:, i);
%     end 

    SeismicAngleTraceVector = GMatrix * R;
%     dTheory = GMatrix * R;
%     [~, angleTrNum] = size(angleSeisData);
%     seisAngleData = zeros(angleSampNum, angleTrNum);
%     start = 1;
%     for i = 1 : angleTrNum
%         seisAngleData(:, i) = dTheory(start : start+angleSampNum-1, 1);
%         start = start + angleSampNum;
%     end
%     seismic= s_convert(seisAngleData, 0, 2);
%     s_wplot(seismic);
%     title('理论角道集');
    
%     save ForwardData2 tVp tVs tRho GMatrix R SeismicAngleTraceVector LsFitLpCoefficient LdFitLpCoefficient;
end