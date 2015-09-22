%% ���ݳ�����Ծ����ĳһ�ھ����з���
clear;
clc;
close all;

%% ������Ϣ
preFileName = 'F:\data\��������\��������\�����\new_erwu_Prestack80.sgy';      % ��ǰ�ĵ����¼
dt = 2;                                                 % ʱ��2����   
superTrNum = 16;                                        % ������ÿ�������10��
angleTrNum = 41;                                        % �ǵ�������

% �õ�һ�ھ��Ļ�����Ϣ
sWell.name = 'SU59-13-49A';                             % ���� 
sWell.inId = 2666;                                      % inline��
sWell.crossId = 1691;                                   % corssline ��
sWell.depth = 3514;                                     % Ŀ�Ĳ����

% sWell.name = 'SU59-9-53';                               % ���� 
% sWell.inId = 2835;                                      % inline��
% sWell.crossId = 1897;                                   % corssline ��
% sWell.depth = 3478;                                     % Ŀ�Ĳ����

% sWell.name = 'SU59-12-54';                              % ���� 
% sWell.inId = 2902;                                      % inline��
% sWell.crossId = 1764;                                   % corssline ��
% sWell.depth = 3461;                                     % Ŀ�Ĳ����

sWell.fileName = ['F:\data\��������\��������\�����\Sulige Inversion150403\2�⾮����\�⾮����(����ǰ)\', sWell.name, '.txt'];

%% ��һ�����õ��þ��Ĳ⾮����
% ������ʾ����Ϣ�ļ�·����Ŀ�Ĳ���ȣ��������ŷ�Χ���ף���������������룩
welllog = stpCalcWelllog(sWell.fileName, sWell.depth, 200, dt);

%% �ڶ���������þ��Ĺ����������ĵ������
postSeisData = stp2CalcPoststackOneCRPTrace(preFileName, sWell.inId, sWell.crossId);

%% ������������þ��ĺϳɼ�¼��Ѱ����ѵĲ⾮����
[synthRecord, outWelllog, ricker] = stp3Synthetic(postSeisData, sWell, welllog, dt);

% break;

%% ���Ĳ�������þ��ĳ�����
[superTrData, offsetMin, offsetMax] = stp4CalcSuperChannelSet(preFileName, superTrNum, sWell.inId, sWell.crossId);

%% ���岽��������ת��Ϊ�ǵ���
[angleSeisData, angleData] = stp5Anglegather(superTrData(:, 1:superTrNum-1), outWelllog, angleTrNum, offsetMin, offsetMax, dt);

%% ��6, 7���� ��������ع�ϵ���� ��� d = Gx �е�G��d, x0
[tVp tVs tRho GMatrix R SeismicAngleTraceVector LsCoff LdCoff] = stp7CalcInversionParam(outWelllog, angleSeisData, angleData);

% ����
testIteration;

