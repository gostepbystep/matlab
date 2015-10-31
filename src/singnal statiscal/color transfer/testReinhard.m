clear;
close all;
clc;

%% ������ɫǨ�ƵĴ���
func = {'stpReinhard'; 'stpCorrelated'};
strs = {'Reinhard�㷨'; 'RGB��ɫ������㷨'};
nMothods = length(func);

for i = 1 : nMothods;
    [ srgb1, trgb1, outImg1] = feval(func{i}, 'data\\2.jpg', 'data\\10.jpg');
    [ srgb2, trgb2, outImg2] = feval(func{i}, 'data\\5.jpg', 'data\\10.jpg');
    [ srgb3, trgb3, outImg3] = feval(func{i}, 'data\\9.jpg', 'data\\10.jpg');
    
    % ��ͼ
    figure;  subplot(3, 3, 1); imshow(srgb1);
    hold on; subplot(3, 3, 2); imshow(trgb1);
    hold on; subplot(3, 3, 3); imshow(outImg1);
    hold on; subplot(3, 3, 4); imshow(srgb2);
    hold on; subplot(3, 3, 5); imshow(trgb2);
    hold on; subplot(3, 3, 6); imshow(outImg2);
    hold on; subplot(3, 3, 7); imshow(srgb3);
    hold on; subplot(3, 3, 8); imshow(trgb3);
    hold on; subplot(3, 3, 9); imshow(outImg3);
    hold on; subtitle(3, strs{i});
end