function [ label, data ] = stpReadSvmData( fileName)
%% ��ȡ svmѵ������

     % ���ļ�
    fin = fopen(fileName, 'r');
    
    info = textscan(fin, '%d 1:%f 2:%f'); 
    
    label = info{1, 1};
    data = [info{1, 2}, info{1, 3}];
end

