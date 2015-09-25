function [synthRecord, outWelllog] = stpSynthetic(postSeisData, wellDepths, inputWelllog, dt)
% 本程序是用于计算合成记录，以及寻找目的层位最佳的测井曲线
%
% 输出
% synthRecord       合成记录，一个时间序列，大小是 采样数量*井数
% outWelllog           最佳的测井曲线，为一个元胞数组，维度是井数量，每一个元胞都是一个二维矩阵深度范围*参数个数（深度范围 = 采样数量）
% 
% 输入
% postSeisData      叠后地震记录
% wellDepths        测井目的层位置信息
% inputWelllog      预处理后的完整时间域测井曲线，一口井对应一个cell
% dt                采样时间间隔, 单位毫秒
% 

    postSeisData = -postSeisData;                               % 苏格拉地震记录需要反转          
    [sampNum, wellNum] = size(postSeisData);                    % 得到了 井的数量和采样数量

    %%
    % 绘制出波形
    %
    % 彩色的绘制方法
    % figure;
    % TX = 1 : wellNum;
    % TY = 1 : sampNum;
    % imagesc(TX, TY, postSeisData);
    % colorbar;

    %%
    % 估算子波的主频
    N = 512; 
    j = 0 : N - 1; 
    centerPos = 45;

    bestft = zeros(wellNum, 1);
    for i = 1 : wellNum
        Fs = 1000.0 / dt; %采样频率   
        % 从子波的上下部分各取20个点进行傅里叶变换
        fr = fft(postSeisData(centerPos-15 : centerPos+15, i), N);
        mag = sqrt(real(fr).^2 + imag(fr).^2);
        f = j * Fs / N;  
        bestft(i, 1) = min( f(  mag(:, 1) == max(mag)  ) );
    end
    % 从所有的井的频率中取一个平均值
    freq = mean( bestft );

    %%
    % 生成子波
    wave = s_create_wavelet({'type','ricker'}, {'frequencies',freq}, {'step', dt});   
    wavelet = wave.traces;                                      % 得到子波序列          
    waveletNum = length(wavelet);                               % 计算子波的长度                     
    [~, index] = max(wavelet);                                  % 找出子波的波峰位置  

    % 从波峰位置向前找，找到第一个小于0的位置
    while index > 1 && wavelet(index) > 0                                           
        index = index - 1;                                                          
    end             

    % 生成矩阵
    ricker = wavelet(index+1 : waveletNum);                     % 截取子波序列
    [~, index] = max(ricker);
    wMatrix = convmtx(ricker, sampNum);                         % 使用卷积生成矩阵, 生成后矩阵大小是 
                                                                % (length(ricker)+sampNum-1)*sampNum
    wMatrix = wMatrix(index : index+sampNum-1, :);              % 截取需要的部分，大小是sampNum*sampNum

    sumWaveletGain = 0.0;                                       % 子波增益系数

    %%
    % 循环遍历每一口测井曲线
    synthRecord = zeros(sampNum, wellNum);                      % 给输出的合成地震记录分配空间
    isCreateWelllog = false;
    
    for i = 1 : wellNum
        layerDep = wellDepths(i);                               % 读取到目的层的深度
        welllogData = inputWelllog{1, i};                       % 测井曲线，depth, vp, vs, rho, por, sw, sh

        % 补齐测井曲线
        [layerNum, propertyNum] = size(welllogData);                            % 得到层位数量和属性的数量
        dz = 0.125;%2 * welllogData(layerNum, 2) * 0.001;                                % 2毫秒内，最后一层的深度间隔
        
        % 如果测井曲线输出矩阵还没有创建，那么就创建
        if isCreateWelllog == false
            outWelllog = zeros(wellNum, sampNum, propertyNum);                  % 测井曲线的数据
            isCreateWelllog = true;
        end

        % 扩充100个层位
        for j = 1 : 100
            welllogData(layerNum+j, 1) = welllogData(layerNum, 1) + j * dz;
            welllogData(layerNum+j, 2 : propertyNum) = welllogData(layerNum, 2 : propertyNum);
        end

        dist = abs(welllogData(:, 1) - layerDep);                       % 得到每层到目的层的垂直距离
        depthIndex = find(dist(:, 1) == min(dist), 1 );                 % 找到目的层的层位索引

        % 计算波阻抗 Vp*Pho
        waveImp = welllogData(:, 2) .* welllogData(:, 4);
        waveRef = Reflection(waveImp);                                  % 计算反射系数

        % 寻找最佳相关的测井曲线
        maxCorrelation = -1;
        upLayer = sampNum / 2;                                          % 向上看多少个                
        downLayer = sampNum - upLayer - 1;                              % 向下看多少个， 注意up+down共有sampNum-1层
        calcNum = 15;                                                   % 比较的次数,必须是奇数，从中间位置上下各取相同数量
        bestSyntheSeis = zeros(sampNum, 0);

        for j = 1 : calcNum
            index = depthIndex - (calcNum+1)/2 + j;
            upIndex = index - upLayer;
            dowIndex = index + downLayer;

            subRef = waveRef(upIndex : dowIndex, 1);                    % 取出这一段序列的反射系数
            synthSeis = wMatrix * subRef;                               % 合成了一个子波（这里实际上是子波和反射系数做卷积）

            % 通过相关，计算合成的地震记录和真实地震记录的相似度
            correlation = corrcoef(synthSeis, postSeisData(:, i));

            if correlation(1, 2) > maxCorrelation
                maxCorrelation = correlation(1, 2);
                bestIndex = index;
                bestSyntheSeis = synthSeis;
            end
        end

        %%
        % 得到最佳的测井曲线
        bestWelllog = welllogData(bestIndex - upLayer : bestIndex + downLayer, 1 : propertyNum);
        outWelllog(i, :, :) = bestWelllog;
        % 计算最佳曲线的合成记录
        % waveImp = outWelllog(i, :, 2) .* outWelllog(i, :, 4);
        % subRef = Reflection(waveImp);                                  % 计算反射系数
        % bestSyntheSeis = wMatrix*subRef;

        % 计算出该井的子波增益
        [waveletGain] = computeGain(bestSyntheSeis, postSeisData(:, i));
        % 累积子波增益
        sumWaveletGain = sumWaveletGain + waveletGain;
        % 是合成记录的数量级与真实记录一样
        bestSyntheSeis  = bestSyntheSeis ./ waveletGain;

        % 存储最佳合成记录
        synthRecord(:, i) = bestSyntheSeis;

       %%
%         绘制叠后数据和合成记录
        figure;
        subplot(1, 3, 1);
        plot( postSeisData(:, i), 1 : length(bestSyntheSeis));
        hold on;
        plot( bestSyntheSeis, 1 : length(bestSyntheSeis), 'r' );
        set(gca, 'xlim', [-1000 1000]);
        set(gca, 'ydir', 'reverse');
        legend('Poststack seismic', 'Synthtic seismic');
        
        % 绘制测井曲线，vp、vs、rho
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
        
        % 绘制孔隙度等信息
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
    title('合成地震记录');
    
    %%
    % 子波平均增益， 并保存
    sumWaveletGain = sumWaveletGain ./ wellNum;
    [row, col] = size(ricker); 
    SaveTxtFile('ricker.txt', ricker ./ sumWaveletGain, row, col); 
end