function [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData, angleTrNum, superTrNum, offsetMin, offsetMax, dt)
% 这个函数是用来计算初始模型的，Gx = d

    % 计算G矩阵, 和初始的x
    [meanTheta, G, x, lsCoff, ldCoff] = stpCalcGmatrix(welllog, angleTrNum, superTrNum, offsetMin, offsetMax, dt);

    % 把角道集写成一列
    [sampNum, ~] = size(superTrData);
    sampNum = sampNum - 1;
    
    % 计算角道集
    [angleSeisData ~] = Offset2Angle(meanTheta, angleTrNum, superTrData(1 : sampNum, :));   %道集转换  
    
    % 汇出角道集
%     seismic= s_convert(angleSeisData, 0, 2);
%     s_wplot(seismic);
%     title('角道集记录');
    
    d = zeros(sampNum*angleTrNum, 1);
    
    for i = 1 : angleTrNum
        d((i-1)*sampNum+1 : i*sampNum, 1) = angleSeisData(:, i);
    end

%     d = G * x;
end