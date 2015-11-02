% clear;
close all;
% clc;

%% 测试颜色迁移的代码
func = {'stpReinhard'; 'stpCorrelated'};
strs = {'Reinhard算法'; 'RGB颜色相关性算法'};
nMothods = length(func);

for i = 1 : nMothods;
    
    [ srgb1, trgb1, outImg1] = feval(func{i}, 'data\\2.jpg', 'data\\10.jpg');
    [ srgb2, trgb2, outImg2] = feval(func{i}, 'data\\4.jpg', 'data\\3.jpg');
    [ srgb3, trgb3, outImg3] = feval(func{i}, 'data\\19.jpg', 'data\\22.jpg');
    
    % 绘图
    figure;  stpSubPlot(3, 3, 1); imshow(srgb1);
    hold on; stpSubPlot(3, 3, 2); imshow(trgb1);
    hold on; stpSubPlot(3, 3, 3); imshow(outImg1);
    hold on; stpSubPlot(3, 3, 4); imshow(srgb2);
    hold on; stpSubPlot(3, 3, 5); imshow(trgb2);
    hold on; stpSubPlot(3, 3, 6); imshow(outImg2);
    hold on; stpSubPlot(3, 3, 7); imshow(srgb3);
    hold on; stpSubPlot(3, 3, 8); imshow(trgb3);
    hold on; stpSubPlot(3, 3, 9); imshow(outImg3);
    hold on; subtitle(3, strs{i});
end