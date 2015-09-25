function [outWelllog] = stpFillProfile(layerInfoPath, inputWelllog, firstCdp, wellCdps, traceNum, subLayerNum)
% 这是一个插值剖面的函数
    
    %% 读取层位信息
    layerFiles = dir(fullfile(layerInfoPath, '*.txt'));
    fileNum = length(layerFiles);

    layerData = zeros(traceNum, fileNum);

    % 遍历层位文件
    for i = 1 : fileNum
        fileName = [layerInfoPath, layerFiles(i).name];
        layerInfo = load(fileName);

        layerInfo(:, 1) = layerInfo(:, 1) - firstCdp + 1;           % 设置cdp信息
        [lineNum, ~] = size(layerInfo);

        for j = 1 : lineNum
            layerData(j, i) = layerInfo(j, 4);                      % 存储cdp信息
        end
    end

    [wellNum, sampNum, propertyNum] = size(inputWelllog);           % 计算维度

    % 计算填充后的层位数量
    layerNum = (subLayerNum + 1) * (fileNum - 1) + 1;
    % 待插值坐标
    profilePosData = zeros(wellNum, layerNum);
    % 准备已有值的坐标
    prePosData = 1 : sampNum;
    % 待插值数组
    profileWellData = zeros(wellNum, layerNum, propertyNum);

    for i = 1 : wellNum
        % 当前井位的层位信息
        data = layerData( wellCdps(i) - firstCdp , :);
        sort(data);

        index = 1;
        % 计算层位信息
        for j = 1 : fileNum-1
            step = 1.0 * (data(j+1) - data(j) ) / (subLayerNum + 1);    % 每层之间的间隔
            for k = 1 : subLayerNum+1
                profilePosData(i, index) = data(j) + k * step;
                index = index + 1;
            end
        end
        profilePosData(i, layerNum) = data(fileNum);

        % 调用三次样条插值，计算出每条井完整的测井曲线
        for j = 1 : propertyNum
            profileWellData(i, :, j) = stpCubicSpline(prePosData, inputWelllog(i, :, j), profilePosData(i, :), 0, 0);
        end
        
%         figure;
%         subplot(1, 3, 1);
%         plot(inputWelllog(i, :, 2), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 2), profilePosData(i, :), 'b');
%         legend('已知','插值');
%         
%         subplot(1, 3, 2);
%         plot(inputWelllog(i, :, 4), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 4), profilePosData(i, :), 'b');
%         legend('已知','插值');
%         
%         subplot(1, 3, 3);
%         plot(inputWelllog(i, :, 5), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 5), profilePosData(i, :), 'b');
%         legend('已知','插值');
    end
    
    % 克里金插值准备
    S = zeros(wellNum*layerNum, 2);
    Y = zeros(wellNum*layerNum, 1);
    X = gridsamp([1 1; traceNum layerNum], [traceNum layerNum]);
    % X = gridsamp([1 1; traceNum layerNum], [40 40]);
    
    outWelllog = cell(1, propertyNum);
    
    % 准备S的值
    for i = 1 : wellNum
        for j = 1 : layerNum
            pos = (i-1)*layerNum + j;
            S(pos, 1) = wellCdps(i) - firstCdp;
            S(pos, 2) = j;
        end
    end
    
    % 准备Y的值，并插值
    theta = [0.01, 90]; 
    
    for i = 1 : propertyNum
        fprintf('\t 正在插值第%d个属性的剖面...\n', i);
        
        % 得到了Y
        for j = 1 : wellNum
            start = (j-1)*layerNum+1;
            Y(start : start+layerNum-1) = profileWellData(j, :, i);
        end
        
        % 调用克里金插值
        [dmodel ~] = dacefit(S, Y, @regpoly0, @corrlin, theta);
        [YX ~] = predictor(X, dmodel);

        % 绘图
        X1 = reshape(X(:,1), traceNum, layerNum); X2 = reshape(X(:,2), traceNum, layerNum);
        % X1 = reshape(X(:,1),40,40); X2 = reshape(X(:,2),40,40);
        YX = reshape(YX, size(X1));
        
        % 赋值给输出的测井曲线
        outWelllog{1, i} = YX;

        figure;
        mesh(X1, X2, YX);
        hold on,
        plot3(S(:,1),S(:,2),Y, '.k', 'MarkerSize',10)
        hold off
    end
    
end