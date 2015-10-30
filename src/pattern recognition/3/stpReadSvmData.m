function [ label, data ] = stpReadSvmData( fileName)
%% 读取 svm训练数据

     % 打开文件
    fin = fopen(fileName, 'r');
    
    info = textscan(fin, '%d 1:%f 2:%f'); 
    
    label = info{1, 1};
    data = [info{1, 2}, info{1, 3}];
end

