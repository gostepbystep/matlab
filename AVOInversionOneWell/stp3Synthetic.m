function [synthRecord, outWelllog, ricker] = stp3Synthetic(postSeisData, sWell, welllogData, dt)
% �����������ڼ���ϳɼ�¼���Լ�Ѱ��Ŀ�Ĳ�λ��ѵĲ⾮����
%
% ���
% synthRecord       �ϳɼ�¼��һ��ʱ�����У���С�� ��������*����
% outWelllog           ��ѵĲ⾮���ߣ�Ϊһ��Ԫ�����飬ά���Ǿ�������ÿһ��Ԫ������һ����ά������ȷ�Χ*������������ȷ�Χ = ����������
% 
% ����
% postFileName      ��������¼��ŵ�λ��
% wellLocFileName   �⾮λ����Ϣ
% preWellFilePath   Ԥ�����������⾮���ߣ�һ�ھ���Ӧһ���ļ������м��ҳ�����ص�һ�����У�
% outWellFilePath   ����õ�����Ѳ⾮���߱����ļ���·�� ��һ�ھ���Ӧһ���ļ���
% dt                ����ʱ����, ��λ����
% 

    postSeisData = -postSeisData;                          % ��Ϊ�ո���Ĳ���Ҫȡ�������Լ���-�� 

    %%
    % �����Ӳ�����Ƶ
    N = 512; 
    j = 0 : N - 1; 
    [sampNum, ~] = size(postSeisData);
    centerPos = 45;%sampNum / 2;

    Fs = 1000.0 / dt; %����Ƶ��   
    % ���Ӳ������²��ָ�ȡ20������и���Ҷ�任
    fr = fft(postSeisData(centerPos-20 : centerPos+20, 1), N);
    mag = sqrt(real(fr).^2 + imag(fr).^2);
    f = j * Fs / N;  
    freq = min( f(  mag(:, 1) == max(mag)  ) );
%     freq = 15;

    %%
    % �����Ӳ�
    wave = s_create_wavelet({'type','ricker'}, {'frequencies',freq}, {'step', dt});   
    wavelet = wave.traces;                                      % �õ��Ӳ�����          
    waveletNum = length(wavelet);                               % �����Ӳ��ĳ���                     
    [~, index] = max(wavelet);                                  % �ҳ��Ӳ��Ĳ���λ��  

    % �Ӳ���λ����ǰ�ң��ҵ���һ��С��0��λ��
    while index > 1 && wavelet(index) > 0                                           
        index = index - 1;                                                          
    end             

    % ���ɾ���
    ricker = wavelet(index : waveletNum);                     % ��ȡ�Ӳ�����
    
    [~, index] = max(ricker);
    wMatrix = convmtx(ricker, sampNum);                         % ʹ�þ�����ɾ���, ���ɺ�����С�� 
                                                                % (length(ricker)+sampNum-1)*sampNum
    wMatrix = wMatrix(index : index+sampNum-1, :);              % ��ȡ��Ҫ�Ĳ��֣���С��sampNum*sampNum
    
    sumWaveletGain = 0.0;                                       % �Ӳ�����ϵ��

    %%
    % ѭ������ÿһ�ڲ⾮����
    % synthRecord = zeros(sampNum, 1);                            % ������ĺϳɵ����¼����ռ�

    % ����⾮����
    [layerNum, propertyNum] = size(welllogData);                % �õ���λ���������Ե�����
    dz =  2 * welllogData(layerNum, 2)*0.001;                    % 2�����ڣ����һ�����ȼ��
    
    outWelllog = zeros(sampNum, propertyNum);                   % �⾮���ߵ�����

    % ����500����λ
    for j = 1 : 500
        welllogData(layerNum+j, 1) = welllogData(layerNum, 1) + j * dz;
        welllogData(layerNum+j, 2 : propertyNum) = welllogData(layerNum, 2 : propertyNum);
    end

    dist = abs(welllogData(:, 1) - sWell.depth);                % �õ�ÿ�㵽Ŀ�Ĳ�Ĵ�ֱ����
    depthIndex = find(dist(:, 1) == min(dist), 1);              % �ҵ�Ŀ�Ĳ�Ĳ�λ����

    % ���㲨�迹 Vp*Pho
    waveImp = welllogData(:, 2) .* welllogData(:, 4);
    waveRef = Reflection(waveImp);                              % ���㷴��ϵ��

    % Ѱ�������صĲ⾮����
    maxCorrelation = -1;
    upLayer = sampNum / 2;                                          % ���Ͽ����ٸ�                
    downLayer = sampNum - upLayer - 1;                              % ���¿����ٸ��� ע��up+down����sampNum-1��
    calcNum = 11;                                                   % �ȽϵĴ���,���������������м�λ�����¸�ȡ��ͬ����

    for j = 1 : calcNum
        index = depthIndex - (calcNum+1)/2 + j;
        upIndex = index - upLayer;
        dowIndex = index + downLayer;

        subRef = waveRef(upIndex : dowIndex, 1);                    % ȡ����һ�����еķ���ϵ��
        synthSeis = wMatrix * subRef;                               % �ϳ���һ���Ӳ�������ʵ�������Ӳ��ͷ���ϵ���������
% 
        % ͨ����أ�����ϳɵĵ����¼����ʵ�����¼�����ƶ�
        correlation = corrcoef(synthSeis, postSeisData(:, 1));
        
        if correlation(1, 2) > maxCorrelation
%             if error < maxCorrelation
%             error
            maxCorrelation = correlation(1, 2) ;
            bestIndex = index;
            synthRecord = synthSeis;
        end
    end

    %%
    % �õ���ѵĲ⾮����
    outWelllog = welllogData(bestIndex - upLayer : bestIndex + downLayer, 1 : propertyNum);

    % ������þ����Ӳ�����
    [waveletGain] = computeGain(synthRecord, postSeisData(:, 1));
    % �Ǻϳɼ�¼������������ʵ��¼һ��
    synthRecord  = synthRecord ./ waveletGain;
    ricker = ricker ./ waveletGain;
    [row, col] = size(ricker); 
    
%     testRicker;
%     ricker = rand(length(ricker), 1);
    [error, ricker, synthRecord] = stpIterationRicker(ricker, postSeisData, outWelllog, sampNum);

    path = fileparts(mfilename('fullpath'));
    SaveTxtFile([path, '\\ricker.txt'], ricker, row, col); 

    %%
    % ���Ƶ������ݺͺϳɼ�¼
    figure;
    subplot(1, 2, 1);
    plot( postSeisData(:, 1), 1 : length(synthRecord));
    hold on;
    plot( synthRecord, 1 : length(synthRecord), 'r' );
    set(gca, 'xlim', [-1500 1500]);
    set(gca, 'ydir', 'reverse');
    legend('Poststack seismic', 'Synthtic seismic');
    
    % ���Ʋ⾮���ߣ�vp��vs��rho
    subplot(1, 2, 2);
    plot( outWelllog(:, 2), outWelllog(:, 1), 'r' );
    hold on;
    plot( outWelllog(:, 3), outWelllog(:, 1), 'g' );
    hold on;
    plot( outWelllog(:, 4) .* 1000, outWelllog(:, 1), 'b' );
    set(gca, 'ylim', [min(outWelllog(:,1)) max(outWelllog(:,1))]);
    set(gca, 'ydir', 'reverse'); 
    set(gca, 'xlim', [1000 6000]);
    legend('Vp', 'Vs', 'Rho');
    
end