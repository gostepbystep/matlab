clear;
close all;
clc;

%% ������������
% ����������
preFileName = 'F:\data\��������\��������\�����\new_erwu_Prestack80.sgy';                                  % ��ǰ�ĵ����¼
dt = 2;                                                                             % ʱ��2����   
superTrNum = 10;                                                                    % ������ÿ�������10��
angleTrNum = 41;                                                                    % �ǵ�������
wellPath = 'F:\data\��������\��������\�����\Sulige Inversion150403\2�⾮����\�⾮����(����ǰ)\';            % �⾮���ݴ��·��
layerPath = 'F:\data\��������\��������\�����\Sulige Inversion150403\2�⾮����\�⾮����(�����)\profile_modle_layer\';
loacationPath = 'F:\data\��������\��������\�����\Sulige Inversion150403\1��λ��λ����ֲ�\welllog_location.txt';
% horizonPath = 'F:\data\��������\��������\�����\Sulige Inversion150403\1��λ��λ����ֲ�\profile_layer.txt';
goalLayerPath = 'he8.txt';

firstCdp = 1500;
traceNum = 601;
subLayerNum = 50;
propertyNum = 7;

% ��59-13-48     19240457.95	4263119.93	2626	1651	3520
% ��59-13-49     19241063.73	4263393.77	2656	1665	3519
% ��59-13-49A	19241264.99	4263919.976	2666	1691	3514
% ��59-11-50     19241928	4266440     2712	1810(1)	3501
% ��59-10-51     19243265.12	4267452.924	2766	1868	3489

% wellNames = {'SU59-13-48', 'SU59-13-49', 'SU59-13-49A', 'SU59-11-50', 'SU59-10-51'};
% wellInIds = [2626, 2656, 2666, 2712, 2766];
% wellCrossIds = [1651, 1665, 1691, 1810, 1868];
% wellDepths = [3520, 3519, 3514, 3501, 3489];
%wellDepths = [3510, 3510, 3510, 3510, 3510];

% ��59-16-48	19240006	4260438	2603	1517	3541
% ��59-13-48	19240457.95	4263119.93	2626	1651	3520
% ��59-11-50	19241928	4266440	2712	1810(1)	3501
% ��59-7-53	19244626.02	4271337.412	2834	2062	3483

% wellNames = {'SU59-16-48', 'SU59-13-48', 'SU59-11-50', 'SU59-7-53'};
% wellInIds = [2603, 2626, 2712, 2834];
% wellCrossIds = [1517, 1651, 1810, 2062];
% wellDepths = [3541, 3520, 3501, 3483];

% ���뾮λ

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

%% ��һ������ȡʱ����⾮����
fprintf('����ִ�е�1������ȡʱ����⾮���ߣ�\n');
    welllog = cell(1, wellNum);
    for i = 1 : wellNum
        path = [wellPath, wellNames{i}, '.txt'];
        temp = stpCalcWelllog(path, wellDepths(i), 240, dt);
        welllog{i} = temp;
    end
fprintf('\n');

%% ��2������������������ֵ��һ����������ߣ�������inlineId��crosslineId
fprintf('����ִ�е�2������ֵ����λ��\n');
    [outInIds, outCrossIds] = stpCalcSurveyLine(wellInIds, wellCrossIds, wellNames, firstCdp, traceNum);
%     ����Ŀ�Ĳ�����
%     timeLine = stpCalcTimeLine(goalLayerPath, outInIds, outCrossIds, firstCdp);
fprintf('\n');

%% ��3��������ÿһ�������ڵĹ����������ĵ����¼
fprintf('����ִ�е�3��������⾮�����¼\n');
    postSeisData = stpCalcPostStack(preFileName, wellInIds, wellCrossIds);
    
    % ������������ĵ����¼
%     load postProfileSeiData;
%     profileSeiseData = stpCalcPostStack(preFileName, outInIds, outCrossIds);   
%     figure; imagesc(1 : traceNum, 1 : 80, profileSeiseData); title('��������¼'); colorbar; 

fprintf('\n');

%% ��4��������ϳɼ�¼��Ѱ����ѵĲ⾮����
fprintf('����ִ�е�4����Ѱ����ѵĲ⾮����\n');
    [synthRecord, outWelllog] = stpSynthetic(postSeisData, wellDepths, welllog, dt);
fprintf('\n');

%% ��5����������������������ֵһ������
fprintf('����ִ�е�5������ֵ����\n');
%     [profileWelllog] = stpFillProfile(layerPath, outWelllog, firstCdp, wellCrossIds, traceNum, subLayerNum);
%     save profile profileWelllog;

    load profile;
    stpPaintProfile(profileWelllog);      % ������

    % ������־��ʦ�ֽ���������
%     testLoadLzyProfile;

    fprintf('\n');

%% �����������������ĳ�����
fprintf('����ִ�е�6�������㳬����\n');
    [offsetMin, offsetMax, superTrData] = stpCalcSuperChannelSet(preFileName, superTrNum, outInIds, outCrossIds);
        save superGather superTrData offsetMin offsetMax;
%     load superGather;
%     figure; imagesc(1 : traceNum, 1 : 80, superTrData); title('���泬����'); colorbar; 
    % ������Ҫ��ת

    superTrData = -superTrData;
fprintf('\n');

%% ���߲�����ʼ����
fprintf('����ִ�е�7������ʼ����...\n');
    [~, sampNum, ~] = size(profileWelllog);
    
    inverWelllog = zeros(propertyNum, sampNum, traceNum);
    
    for i = 1 : traceNum
        fprintf('\t���ڷ��ݵ�%d��...\n', i);
        welllog = profileWelllog(:, :, i)'; 
        
        % ��7.1���� ���������G���󣬼���d = Gx��������
        % ע�⣬���������һ��������Ҫ
        [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
    
        % ��7.2���裬������������
        [Cgeo, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, mPhys, mGeo, lsCoff, ldCoff] = stpBayesParam(welllog, x, d, lsCoff, ldCoff);
        
        % ��7.3���裬����
        inverWelllog(:, :, i) = stpCalcIterate(welllog, mGeo, mPhys, F, matrixB, ...
            Cgeo, invCd, Cphysgeo, G, d, lsCoff, ldCoff, 3);
        
        % ���ú�������ȫ�ĵ�������
%         inverWelllog(:, :, i) = stpInversionFunc(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), ...
%             angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
    end
    
    save inverResultLast2 inverWelllog;
    
    stpPaintProfile(inverWelllog);

%   
%       testWelllog;
    
 fprintf('\n');



