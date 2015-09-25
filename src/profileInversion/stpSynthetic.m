function [synthRecord, outWelllog] = stpSynthetic(postSeisData, wellDepths, inputWelllog, dt)
% �����������ڼ���ϳɼ�¼���Լ�Ѱ��Ŀ�Ĳ�λ��ѵĲ⾮����
%
% ���
% synthRecord       �ϳɼ�¼��һ��ʱ�����У���С�� ��������*����
% outWelllog           ��ѵĲ⾮���ߣ�Ϊһ��Ԫ�����飬ά���Ǿ�������ÿһ��Ԫ������һ����ά������ȷ�Χ*������������ȷ�Χ = ����������
% 
% ����
% postSeisData      ��������¼
% wellDepths        �⾮Ŀ�Ĳ�λ����Ϣ
% inputWelllog      Ԥ����������ʱ����⾮���ߣ�һ�ھ���Ӧһ��cell
% dt                ����ʱ����, ��λ����
% 

    postSeisData = -postSeisData;                               % �ո��������¼��Ҫ��ת          
    [sampNum, wellNum] = size(postSeisData);                    % �õ��� ���������Ͳ�������

    %%
    % ���Ƴ�����
    %
    % ��ɫ�Ļ��Ʒ���
    % figure;
    % TX = 1 : wellNum;
    % TY = 1 : sampNum;
    % imagesc(TX, TY, postSeisData);
    % colorbar;

    %%
    % �����Ӳ�����Ƶ
    N = 512; 
    j = 0 : N - 1; 
    centerPos = 45;

    bestft = zeros(wellNum, 1);
    for i = 1 : wellNum
        Fs = 1000.0 / dt; %����Ƶ��   
        % ���Ӳ������²��ָ�ȡ20������и���Ҷ�任
        fr = fft(postSeisData(centerPos-15 : centerPos+15, i), N);
        mag = sqrt(real(fr).^2 + imag(fr).^2);
        f = j * Fs / N;  
        bestft(i, 1) = min( f(  mag(:, 1) == max(mag)  ) );
    end
    % �����еľ���Ƶ����ȡһ��ƽ��ֵ
    freq = mean( bestft );

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
    ricker = wavelet(index+1 : waveletNum);                     % ��ȡ�Ӳ�����
    [~, index] = max(ricker);
    wMatrix = convmtx(ricker, sampNum);                         % ʹ�þ�����ɾ���, ���ɺ�����С�� 
                                                                % (length(ricker)+sampNum-1)*sampNum
    wMatrix = wMatrix(index : index+sampNum-1, :);              % ��ȡ��Ҫ�Ĳ��֣���С��sampNum*sampNum

    sumWaveletGain = 0.0;                                       % �Ӳ�����ϵ��

    %%
    % ѭ������ÿһ�ڲ⾮����
    synthRecord = zeros(sampNum, wellNum);                      % ������ĺϳɵ����¼����ռ�
    isCreateWelllog = false;
    
    for i = 1 : wellNum
        layerDep = wellDepths(i);                               % ��ȡ��Ŀ�Ĳ�����
        welllogData = inputWelllog{1, i};                       % �⾮���ߣ�depth, vp, vs, rho, por, sw, sh

        % ����⾮����
        [layerNum, propertyNum] = size(welllogData);                            % �õ���λ���������Ե�����
        dz = 0.125;%2 * welllogData(layerNum, 2) * 0.001;                                % 2�����ڣ����һ�����ȼ��
        
        % ����⾮�����������û�д�������ô�ʹ���
        if isCreateWelllog == false
            outWelllog = zeros(wellNum, sampNum, propertyNum);                  % �⾮���ߵ�����
            isCreateWelllog = true;
        end

        % ����100����λ
        for j = 1 : 100
            welllogData(layerNum+j, 1) = welllogData(layerNum, 1) + j * dz;
            welllogData(layerNum+j, 2 : propertyNum) = welllogData(layerNum, 2 : propertyNum);
        end

        dist = abs(welllogData(:, 1) - layerDep);                       % �õ�ÿ�㵽Ŀ�Ĳ�Ĵ�ֱ����
        depthIndex = find(dist(:, 1) == min(dist), 1 );                 % �ҵ�Ŀ�Ĳ�Ĳ�λ����

        % ���㲨�迹 Vp*Pho
        waveImp = welllogData(:, 2) .* welllogData(:, 4);
        waveRef = Reflection(waveImp);                                  % ���㷴��ϵ��

        % Ѱ�������صĲ⾮����
        maxCorrelation = -1;
        upLayer = sampNum / 2;                                          % ���Ͽ����ٸ�                
        downLayer = sampNum - upLayer - 1;                              % ���¿����ٸ��� ע��up+down����sampNum-1��
        calcNum = 15;                                                   % �ȽϵĴ���,���������������м�λ�����¸�ȡ��ͬ����
        bestSyntheSeis = zeros(sampNum, 0);

        for j = 1 : calcNum
            index = depthIndex - (calcNum+1)/2 + j;
            upIndex = index - upLayer;
            dowIndex = index + downLayer;

            subRef = waveRef(upIndex : dowIndex, 1);                    % ȡ����һ�����еķ���ϵ��
            synthSeis = wMatrix * subRef;                               % �ϳ���һ���Ӳ�������ʵ�������Ӳ��ͷ���ϵ���������

            % ͨ����أ�����ϳɵĵ����¼����ʵ�����¼�����ƶ�
            correlation = corrcoef(synthSeis, postSeisData(:, i));

            if correlation(1, 2) > maxCorrelation
                maxCorrelation = correlation(1, 2);
                bestIndex = index;
                bestSyntheSeis = synthSeis;
            end
        end

        %%
        % �õ���ѵĲ⾮����
        bestWelllog = welllogData(bestIndex - upLayer : bestIndex + downLayer, 1 : propertyNum);
        outWelllog(i, :, :) = bestWelllog;
        % ����������ߵĺϳɼ�¼
        % waveImp = outWelllog(i, :, 2) .* outWelllog(i, :, 4);
        % subRef = Reflection(waveImp);                                  % ���㷴��ϵ��
        % bestSyntheSeis = wMatrix*subRef;

        % ������þ����Ӳ�����
        [waveletGain] = computeGain(bestSyntheSeis, postSeisData(:, i));
        % �ۻ��Ӳ�����
        sumWaveletGain = sumWaveletGain + waveletGain;
        % �Ǻϳɼ�¼������������ʵ��¼һ��
        bestSyntheSeis  = bestSyntheSeis ./ waveletGain;

        % �洢��Ѻϳɼ�¼
        synthRecord(:, i) = bestSyntheSeis;

       %%
%         ���Ƶ������ݺͺϳɼ�¼
        figure;
        subplot(1, 3, 1);
        plot( postSeisData(:, i), 1 : length(bestSyntheSeis));
        hold on;
        plot( bestSyntheSeis, 1 : length(bestSyntheSeis), 'r' );
        set(gca, 'xlim', [-1000 1000]);
        set(gca, 'ydir', 'reverse');
        legend('Poststack seismic', 'Synthtic seismic');
        
        % ���Ʋ⾮���ߣ�vp��vs��rho
        subplot(1, 3, 2);
        plot( bestWelllog(:, 2), bestWelllog(:, 1), 'r' );
        hold on;
        plot( bestWelllog(:, 3), bestWelllog(:, 1), 'g' );
        hold on;
        plot( bestWelllog(:, 4) .* 1000, bestWelllog(:, 1), 'b' );
        set(gca, 'ylim', [min(bestWelllog(:,1)) max(bestWelllog(:,1))]);
        set(gca, 'ydir', 'reverse'); 
        set(gca, 'xlim', [2000 5000]);
        legend('Vp', 'Vs', 'Rho');
        
        % ���ƿ�϶�ȵ���Ϣ
        subplot(1, 3, 3);
        plot( bestWelllog(:, 5), bestWelllog(:, 1), 'r' );
        hold on;
        plot( bestWelllog(:, 6), bestWelllog(:, 1), 'g' );
        hold on;
        plot( bestWelllog(:, 7), bestWelllog(:, 1), 'b' );
        set(gca, 'ylim', [min(bestWelllog(:,1)) max(bestWelllog(:,1))]);
        set(gca, 'ydir', 'reverse'); 
        set(gca, 'xlim', [0 1]);
        legend('Porosity','Water saturation','Clay content');
    end

    seismic= s_convert(synthRecord, 0, 2);
    s_wplot(seismic);
    title('�ϳɵ����¼');
    
    %%
    % �Ӳ�ƽ�����棬 ������
    sumWaveletGain = sumWaveletGain ./ wellNum;
    [row, col] = size(ricker); 
    SaveTxtFile('ricker.txt', ricker ./ sumWaveletGain, row, col); 
end