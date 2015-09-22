function [synthRecord, outWelllog, ricker] = stp3Synthetic(postSeisData, sWell, welllogData, dt)
% 本程序是用于计算合成记录，以及寻找目的层位最佳的测井曲线
%
% 输出
% synthRecord       合成记录，一个时间序列，大小是 采样数量*井数
% outWelllog           最佳的测井曲线，为一个元胞数组，维度是井数量，每一个元胞都是一个二维矩阵深度范围*参数个数（深度范围 = 采样数量）
% 
% 输入
% postFileName      叠后地震记录存放的位置
% wellLocFileName   测井位置信息
% preWellFilePath   预处理后的完整测井曲线，一口井对应一个文件（从中间找出最相关的一段序列）
% outWellFilePath   输出得到的最佳测井曲线保存文件的路径 （一口井对应一个文件）
% dt                采样时间间隔, 单位毫秒
% 

    postSeisData = -postSeisData;                          % 因为苏格里的波需要取反，所以加上-号 

    %%
    % 估算子波的主频
    N = 512; 
    j = 0 : N - 1; 
    [sampNum, ~] = size(postSeisData);
    centerPos = 45;%sampNum / 2;

    Fs = 1000.0 / dt; %采样频率   
    % 从子波的上下部分各取20个点进行傅里叶变换
    fr = fft(postSeisData(centerPos-20 : centerPos+20, 1), N);
    mag = sqrt(real(fr).^2 + imag(fr).^2);
    f = j * Fs / N;  
    freq = min( f(  mag(:, 1) == max(mag)  ) );
%     freq = 15;

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
    ricker = wavelet(index : waveletNum);                     % 截取子波序列
    
    [~, index] = max(ricker);
    wMatrix = convmtx(ricker, sampNum);                         % 使用卷积生成矩阵, 生成后矩阵大小是 
                                                                % (length(ricker)+sampNum-1)*sampNum
    wMatrix = wMatrix(index : index+sampNum-1, :);              % 截取需要的部分，大小是sampNum*sampNum
    
    sumWaveletGain = 0.0;                                       % 子波增益系数

    %%
    % 循环遍历每一口测井曲线
    % synthRecord = zeros(sampNum, 1);                            % 给输出的合成地震记录分配空间

    % 补齐测井曲线
    [layerNum, propertyNum] = size(welllogData);                % 得到层位数量和属性的数量
    dz =  2 * welllogData(layerNum, 2)*0.001;                    % 2毫秒内，最后一层的深度间隔
    
    outWelllog = zeros(sampNum, propertyNum);                   % 测井曲线的数据

    % 扩充500个层位
    for j = 1 : 500
        welllogData(layerNum+j, 1) = welllogData(layerNum, 1) + j * dz;
        welllogData(layerNum+j, 2 : propertyNum) = welllogData(layerNum, 2 : propertyNum);
    end

    dist = abs(welllogData(:, 1) - sWell.depth);                % 得到每层到目的层的垂直距离
    depthIndex = find(dist(:, 1) == min(dist), 1);              % 找到目的层的层位索引

    % 计算波阻抗 Vp*Pho
    waveImp = welllogData(:, 2) .* welllogData(:, 4);
    waveRef = Reflection(waveImp);                              % 计算反射系数

    % 寻找最佳相关的测井曲线
    maxCorrelation = -1;
    upLayer = sampNum / 2;                                          % 向上看多少个                
    downLayer = sampNum - upLayer - 1;                              % 向下看多少个， 注意up+down共有sampNum-1层
    calcNum = 11;                                                   % 比较的次数,必须是奇数，从中间位置上下各取相同数量

    for j = 1 : calcNum
        index = depthIndex - (calcNum+1)/2 + j;
        upIndex = index - upLayer;
        dowIndex = index + downLayer;

        subRef = waveRef(upIndex : dowIndex, 1);                    % 取出这一段序列的反射系数
        synthSeis = wMatrix * subRef;                               % 合成了一个子波（这里实际上是子波和反射系数做卷积）
% 
        % 通过相关，计算合成的地震记录和真实地震记录的相似度
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
    % 得到最佳的测井曲线
    outWelllog = welllogData(bestIndex - upLayer : bestIndex + downLayer, 1 : propertyNum);

    % 计算出该井的子波增益
    [waveletGain] = computeGain(synthRecord, postSeisData(:, 1));
    % 是合成记录的数量级与真实记录一样
    synthRecord  = synthRecord ./ waveletGain;
    ricker = ricker ./ waveletGain;
    [row, col] = size(ricker); 
    
%     testRicker;
%     ricker = rand(length(ricker), 1);
    [error, ricker, synthRecord] = stpIterationRicker(ricker, postSeisData, outWelllog, sampNum);

    path = fileparts(mfilename('fullpath'));
    SaveTxtFile([path, '\\ricker.txt'], ricker, row, col); 

    %%
    % 绘制叠后数据和合成记录
    figure;
    subplot(1, 2, 1);
    plot( postSeisData(:, 1), 1 : length(synthRecord));
    hold on;
    plot( synthRecord, 1 : length(synthRecord), 'r' );
    set(gca, 'xlim', [-1500 1500]);
    set(gca, 'ydir', 'reverse');
    legend('Poststack seismic', 'Synthtic seismic');
    
    % 绘制测井曲线，vp、vs、rho
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