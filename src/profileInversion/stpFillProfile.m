function [outWelllog] = stpFillProfile(layerInfoPath, inputWelllog, firstCdp, wellCdps, traceNum, subLayerNum)
% ����һ����ֵ����ĺ���
    
    %% ��ȡ��λ��Ϣ
    layerFiles = dir(fullfile(layerInfoPath, '*.txt'));
    fileNum = length(layerFiles);

    layerData = zeros(traceNum, fileNum);

    % ������λ�ļ�
    for i = 1 : fileNum
        fileName = [layerInfoPath, layerFiles(i).name];
        layerInfo = load(fileName);

        layerInfo(:, 1) = layerInfo(:, 1) - firstCdp + 1;           % ����cdp��Ϣ
        [lineNum, ~] = size(layerInfo);

        for j = 1 : lineNum
            layerData(j, i) = layerInfo(j, 4);                      % �洢cdp��Ϣ
        end
    end

    [wellNum, sampNum, propertyNum] = size(inputWelllog);           % ����ά��

    % ��������Ĳ�λ����
    layerNum = (subLayerNum + 1) * (fileNum - 1) + 1;
    % ����ֵ����
    profilePosData = zeros(wellNum, layerNum);
    % ׼������ֵ������
    prePosData = 1 : sampNum;
    % ����ֵ����
    profileWellData = zeros(wellNum, layerNum, propertyNum);

    for i = 1 : wellNum
        % ��ǰ��λ�Ĳ�λ��Ϣ
        data = layerData( wellCdps(i) - firstCdp , :);
        sort(data);

        index = 1;
        % �����λ��Ϣ
        for j = 1 : fileNum-1
            step = 1.0 * (data(j+1) - data(j) ) / (subLayerNum + 1);    % ÿ��֮��ļ��
            for k = 0 : subLayerNum
                profilePosData(i, index) = data(j) + k * step;
                index = index + 1;
            end
        end
        profilePosData(i, layerNum) = data(fileNum);

        % ��������������ֵ�������ÿ���������Ĳ⾮����
        for j = 1 : propertyNum
            profileWellData(i, :, j) = stpCubicSpline(prePosData, inputWelllog(i, :, j), profilePosData(i, :), 0, 0);
        end
        
%         figure;
%         subplot(1, 3, 1);
%         plot(inputWelllog(i, :, 2), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 2), profilePosData(i, :), 'b');
%         legend('��֪','��ֵ');
%         
%         subplot(1, 3, 2);
%         plot(inputWelllog(i, :, 4), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 4), profilePosData(i, :), 'b');
%         legend('��֪','��ֵ');
%         
%         subplot(1, 3, 3);
%         plot(inputWelllog(i, :, 5), prePosData, 'r');
%         hold on;
%         plot(profileWellData(i, :, 5), profilePosData(i, :), 'b');
%         legend('��֪','��ֵ');
    end
    
    % ������ֵ׼��
    S = zeros(wellNum*layerNum, 2);
    Y = zeros(wellNum*layerNum, 1);
    X = gridsamp([1 1; traceNum sampNum  ], [traceNum sampNum]);
    % X = gridsamp([1 1; traceNum layerNum], [40 40]);
    
    outWelllog = zeros(propertyNum, sampNum, traceNum);
    
    % ׼��S��ֵ
    for i = 1 : wellNum
        startPos = (i-1)*layerNum+1;
        endPos = startPos + layerNum - 1;
        S(startPos : endPos, 1) = wellCdps(i) - firstCdp;
        S(startPos : endPos, 2) = profilePosData(i, :);
    end
    
    % ׼��Y��ֵ������ֵ
    theta = 0.01;
    
    for i = 1 : propertyNum
        fprintf('\t ���ڲ�ֵ��%d�����Ե�����...\n', i);
        
        % �õ���Y
        for j = 1 : wellNum
            start = (j-1)*layerNum+1;
            Y(start : start+layerNum-1) = profileWellData(j, :, i);
        end
        
        % ���ÿ�����ֵ
        [dmodel ~] = dacefit(S, Y, @regpoly0, @corrlin, theta);
        [YX ~] = predictor(X, dmodel);

        % ��ͼ
        X1 = reshape(X(:,1), sampNum, traceNum); X2 = reshape(X(:,2), sampNum, traceNum );
        % X1 = reshape(X(:,1),40,40); X2 = reshape(X(:,2),40,40);
        YX = reshape(YX, size(X1));
        
        % ��ֵ������Ĳ⾮����
        outWelllog(i, :, :) = YX;

%         figure;
%         mesh(X1, X2, YX);
%         hold on;
%         plot3(S(:,1),S(:,2),Y, '.k', 'MarkerSize',10);
%         hold off;
%         save data3 S Y;
    end
    
end