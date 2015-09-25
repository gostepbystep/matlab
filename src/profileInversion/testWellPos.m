wellInfo = importdata(loacationPath);

preWellFilePath = 'E:\苏里格\Sulige Inversion150403\2测井曲线\测井曲线(处理后)\welllog_time\';
welllogFiles = dir( fullfile( preWellFilePath, '*.txt' ) );
okNum = length(welllogFiles);                          % 得到测井曲线的个数，注意的有些测井因为数据不全，

okData = zeros(okNum, 3);
textData = cell(1, okNum);

for i = 1 : okNum
    welllogFileName = [ preWellFilePath, welllogFiles(i).name];
    [~, name, ~] = fileparts(welllogFileName);                          % 获取其不带扩展名的文件名
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
title('苏里格工区井位分布图','FontSize',18);