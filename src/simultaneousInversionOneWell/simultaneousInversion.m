%% 反演程序，针对具体的某一口井进行反演
clear;
clc;
close all;

%% 基本信息
preFileName = 'F:\data\地震数据\地震资料\苏里格\new_erwu_Prestack80.sgy';      % 叠前的地震记录
dt = 2;                                                 % 时间2毫秒   
superTrNum = 10;                                        % 超道集每个反射点10个
angleTrNum = 41;                                        % 角道集道数

% 得到一口井的基本信息
sWell.name = 'SU59-13-49A';                             % 井名 
sWell.inId = 2666;                                      % inline号
sWell.crossId = 1691;                                   % corssline 号
sWell.depth = 3514;                                     % 目的层深度

% sWell.name = 'SU59-9-53';                               % 井名 
% sWell.inId = 2835;                                      % inline号
% sWell.crossId = 1897;                                   % corssline 号
% sWell.depth = 3478;                                     % 目的层深度

% sWell.name = 'SU59-12-54';                              % 井名 
% sWell.inId = 2902;                                      % inline号
% sWell.crossId = 1764;                                   % corssline 号
% sWell.depth = 3461;                                     % 目的层深度

sWell.fileName = ['F:\data\地震数据\地震资料\苏里格\Sulige Inversion150403\2测井曲线\测井曲线(处理前)\', sWell.name, '.txt'];

    %% 第一步，得到该井的测井曲线
    % 参数表示井信息文件路径，目的层深度，采样扩张范围（米），采样间隔（毫秒）
    initWelllog = stp1CalcWellLog(sWell.fileName, sWell.depth, 200, dt);

    %% 第二步，计算该井的共反射点道集的叠后道集
    postSeisData = stp2CalcPoststackOneCRPTrace(preFileName, sWell.inId, sWell.crossId);

    %% 第三步，计算该井的合成记录，寻找最佳的测井曲线
    [synthRecord, welllog, ricker] = stp3Synthetic(postSeisData, sWell, initWelllog, dt);
    %% 第四步，计算该井的超道集
    [superTrData, offsetMin, offsetMax] = stp4CalcSuperChannelSet(preFileName, superTrNum, sWell.inId, sWell.crossId);

    %% 第五步，超道集转换为角道集
    [angleSeisData, angleData] = stp5Anglegather(superTrData(:, 1:superTrNum-1), welllog, angleTrNum, offsetMin, offsetMax, dt);

    %% 第6, 7步， 首先求出回归系数， 求出 d = Gx 中的G，d, x0
%     tVp tVs tRho GMatrix R SeismicAngleTraceVector LsFitLpCoefficient LdFitLpCoefficient
    [tVp, tVs, tRho, gMatrix, rInit, dTheory, lsCoff, ldCoff] = stp7CalcInversionParam(welllog, angleSeisData, angleData);

%% 第一步，得到该井的测井曲线
% 参数表示井信息文件路径，目的层深度，采样扩张范围（米），采样间隔（毫秒）
% welllog = stp8CalcWellLog(sWell.fileName, sWell.depth, 100);

%% 第二步，计算G矩阵等
% [gMatrix, rInit, dTheory, lsCoff, ldCoff] = stp9CalcInitModel(angleTrNum, superTrNum, welllog, 20, 4178, dt);

%% 第三部，计算贝叶斯定理先关的矩阵
[Cgeo, A, B, C, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, lsCoff, ldCoff, mPhys, mGeo] = stp10CalcRalateParam(welllog, rInit, dTheory, lsCoff, ldCoff);

%% 第四步，开始迭代
stp11CalcByIterate(Cgeo, A, B, C, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, lsCoff, ldCoff, gMatrix, dTheory, mPhys, mGeo, welllog);

