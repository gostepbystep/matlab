function [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData, angleTrNum, superTrNum, offsetMin, offsetMax, dt)
% ������������������ʼģ�͵ģ�Gx = d

    % ����G����, �ͳ�ʼ��x
    [meanTheta, G, x, lsCoff, ldCoff] = stpCalcGmatrix(welllog, angleTrNum, superTrNum, offsetMin, offsetMax, dt);

    % �ѽǵ���д��һ��
    [sampNum, ~] = size(superTrData);
    sampNum = sampNum - 1;
    
    % ����ǵ���
    [angleSeisData ~] = Offset2Angle(meanTheta, angleTrNum, superTrData(1 : sampNum, :));   %����ת��  
    
    % ����ǵ���
%     seismic= s_convert(angleSeisData, 0, 2);
%     s_wplot(seismic);
%     title('�ǵ�����¼');
    
    d = zeros(sampNum*angleTrNum, 1);
    
    for i = 1 : angleTrNum
        d((i-1)*sampNum+1 : i*sampNum, 1) = angleSeisData(:, i);
    end

%     d = G * x;
end