clear;
close all;
clc;

%% 基本数据设置
% 井数据设置
preFileName = 'F:\data\地震数据\地震资料\苏里格\new_erwu_Prestack80.sgy';                                  % 叠前的地震记录
dt = 2;                                                                             % 时间2毫秒   
superTrNum = 10;                                                                    % 超道集每个反射点10个
angleTrNum = 41;                                                                    % 角道集道数
wellPath = 'F:\data\地震数据\地震资料\苏里格\Sulige Inversion150403\2测井曲线\测井曲线(处理前)\';            % 测井数据存放路径
layerPath = 'F:\data\地震数据\地震资料\苏里格\Sulige Inversion150403\2测井曲线\测井曲线(处理后)\profile_modle_layer\';
loacationPath = 'F:\data\地震数据\地震资料\苏里格\Sulige Inversion150403\1井位层位地震分布\welllog_location.txt';
% horizonPath = 'F:\data\地震数据\地震资料\苏里格\Sulige Inversion150403\1井位层位地震分布\profile_layer.txt';
goalLayerPath = 'he8.txt';

firstCdp = 1500;
traceNum = 601;
subLayerNum = 50;
propertyNum = 7;

% 苏59-13-48     19240457.95	4263119.93	2626	1651	3520
% 苏59-13-49     19241063.73	4263393.77	2656	1665	3519
% 苏59-13-49A	19241264.99	4263919.976	2666	1691	3514
% 苏59-11-50     19241928	4266440     2712	1810(1)	3501
% 苏59-10-51     19243265.12	4267452.924	2766	1868	3489

% wellNames = {'SU59-13-48', 'SU59-13-49', 'SU59-13-49A', 'SU59-11-50', 'SU59-10-51'};
% wellInIds = [2626, 2656, 2666, 2712, 2766];
% wellCrossIds = [1651, 1665, 1691, 1810, 1868];
% wellDepths = [3520, 3519, 3514, 3501, 3489];
%wellDepths = [3510, 3510, 3510, 3510, 3510];

% 苏59-16-48	19240006	4260438	2603	1517	3541
% 苏59-13-48	19240457.95	4263119.93	2626	1651	3520
% 苏59-11-50	19241928	4266440	2712	1810(1)	3501
% 苏59-7-53	19244626.02	4271337.412	2834	2062	3483

% wellNames = {'SU59-16-48', 'SU59-13-48', 'SU59-11-50', 'SU59-7-53'};
% wellInIds = [2603, 2626, 2712, 2834];
% wellCrossIds = [1517, 1651, 1810, 2062];
% wellDepths = [3541, 3520, 3501, 3483];

% 载入井位

% wellNames = {'SU59-16-48', 'SU59-13-48', 'SU59-11-50', 'SU59-7-53'};
% wellNames = {'SU59-7-45', 'SU59-7-46', 'SU59-7-47','SU59-12-49', 'SU59-11-50', 'SU59-13-51A'};
wellNames = {'SU59-13-51', 'SU59-13-51A', 'SU59-11-51','SU59-9-51'};
[temp wellNum] = size(wellNames);
wellInIds = zeros(1, wellNum);
wellCrossIds = zeros(1, wellNum);
wellDepths = zeros(1, wellNum);

wellInfo = importdata(loacationPath);

for i = 1 : wellNum
    index = find(strcmp(wellInfo.textdata, wellNames{i}));
    
    wellInIds(i) = wellInfo.data(index, 3);
    wellCrossIds(i) = wellInfo.data(index, 4);
    wellDepths(i) = wellInfo.data(index, 5);
end

temps = [wellInIds', wellCrossIds', wellDepths'];
sortData = sortrows(temps, 2);

wellInIds = sortData(:, 1)';
wellCrossIds = sortData(:, 2)';
wellDepths = sortData(:, 3)';

%% 第一步，提取时间域测井曲线
fprintf('正在执行第1步，提取时间域测井曲线：\n');
    welllog = cell(1, wellNum);
    for i = 1 : wellNum
        path = [wellPath, wellNames{i}, '.txt'];
        temp = stpCalcWelllog(path, wellDepths(i), 240, dt);
        welllog{i} = temp;
    end
fprintf('\n');

%% 第2步，根据三次样条插值出一条剖面的曲线，计算其inlineId和crosslineId
fprintf('正在执行第2步，插值测线位置\n');
    [outInIds, outCrossIds] = stpCalcSurveyLine(wellInIds, wellCrossIds, wellNames, firstCdp, traceNum);
%     计算目的层曲线
%     timeLine = stpCalcTimeLine(goalLayerPath, outInIds, outCrossIds, firstCdp);
fprintf('\n');

%% 第3步，计算每一道井所在的共反射点道集的叠后记录
fprintf('正在执行第3步，计算测井叠后记录\n');
    postSeisData = stpCalcPostStack(preFileName, wellInIds, wellCrossIds);
    
    % 绘制整个剖面的叠后记录
%     load postProfileSeiData;
%     profileSeiseData = stpCalcPostStack(preFileName, outInIds, outCrossIds);   
%     figure; imagesc(1 : traceNum, 1 : 80, profileSeiseData); title('剖面叠后记录'); colorbar; 

fprintf('\n');

%% 第4步，计算合成记录，寻找最佳的测井曲线
fprintf('正在执行第4步，寻找最佳的测井曲线\n');
    [synthRecord, outWelllog] = stpSynthetic(postSeisData, wellDepths, welllog, dt);
fprintf('\n');

%% 第5步，根据三次样条函数插值一个剖面
fprintf('正在执行第5步，插值剖面\n');
%     [profileWelllog] = stpFillProfile(layerPath, outWelllog, firstCdp, wellCrossIds, traceNum, subLayerNum);
%     save profile profileWelllog;

    load profile;
    stpPaintProfile(profileWelllog);      % 画出来

    % 载入李志勇师兄建立的剖面
%     testLoadLzyProfile;

    fprintf('\n');

%% 第六步，计算该剖面的超道集
fprintf('正在执行第6步，计算超道集\n');
    [offsetMin, offsetMax, superTrData] = stpCalcSuperChannelSet(preFileName, superTrNum, outInIds, outCrossIds);
        save superGather superTrData offsetMin offsetMax;
%     load superGather;
%     figure; imagesc(1 : traceNum, 1 : 80, superTrData); title('剖面超道集'); colorbar; 
    % 波形需要反转

    superTrData = -superTrData;
fprintf('\n');

%% 第七步，开始正演
fprintf('正在执行第7步，开始反演...\n');
    [~, sampNum, ~] = size(profileWelllog);
    
    inverWelllog = zeros(propertyNum, sampNum, traceNum);
    
    for i = 1 : traceNum
        fprintf('\t正在反演第%d道...\n', i);
        welllog = profileWelllog(:, :, i)'; 
        
        % 第7.1步骤 计算剖面的G矩阵，计算d = Gx这三部分
        % 注意，超道集最后一个道集不要
        [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
    
        % 第7.2步骤，计算其他矩阵
        [Cgeo, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, mPhys, mGeo, lsCoff, ldCoff] = stpBayesParam(welllog, x, d, lsCoff, ldCoff);
        
        % 第7.3步骤，反演
        inverWelllog(:, :, i) = stpCalcIterate(welllog, mGeo, mPhys, F, matrixB, ...
            Cgeo, invCd, Cphysgeo, G, d, lsCoff, ldCoff, 3);
        
        % 调用函数，完全的迭代方案
%         inverWelllog(:, :, i) = stpInversionFunc(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), ...
%             angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
    end
    
    save inverResultLast2 inverWelllog;
    
    stpPaintProfile(inverWelllog);

%   
%       testWelllog;
    
 fprintf('\n');



