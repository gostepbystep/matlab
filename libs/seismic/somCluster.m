function [facies, dataModel] = somCluster(seiData, clusterNum)
% ��������

sD = som_data_struct(seiData);
sM = som_make(sD, 'msize', [1 clusterNum],'training', 'long');
dataModel = sM.codebook;
facies = som_bmus(sM,sD); % ����ƥ�䵥Ԫ

end