wellInfo = importdata(loacationPath);

preWellFilePath = 'E:\�����\Sulige Inversion150403\2�⾮����\�⾮����(�����)\welllog_time\';
welllogFiles = dir( fullfile( preWellFilePath, '*.txt' ) );
okNum = length(welllogFiles);                          % �õ��⾮���ߵĸ�����ע�����Щ�⾮��Ϊ���ݲ�ȫ��

okData = zeros(okNum, 3);
textData = cell(1, okNum);

for i = 1 : okNum
    welllogFileName = [ preWellFilePath, welllogFiles(i).name];
    [~, name, ~] = fileparts(welllogFileName);                          % ��ȡ�䲻����չ�����ļ���
    index = find(strcmp(wellInfo.textdata, name));
    
    okData(i, 1) = wellInfo.data(index,3);
    okData(i, 2) = wellInfo.data(index,4);
    okData(i, 3) = wellInfo.data(index,5);
    textData{i} = name;
end

plot(okData(:, 1),okData(:, 2),'k*');set(gca,'ydir','reverse');
hold on;grid;
str=wellInfo.textdata;
text(okData(:, 1),okData(:, 2),textData,'FontSize',8);
xlabel('Inline','FontSize',14);ylabel('Crossline','FontSize',14);
title('���������λ�ֲ�ͼ','FontSize',18);