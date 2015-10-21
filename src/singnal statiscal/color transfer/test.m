clear;
close all;
clc;

%% ²âÊÔÑÕÉ«Ç¨ÒÆµÄ´úÂë

[ srgb1, trgb1, outImg1] = stpReinhard('data\\1.jpg', 'data\\3.jpg');
[ srgb2, trgb2, outImg2] = stpReinhard('data\\6.jpg', 'data\\3.jpg');

% »æÍ¼
figure;  subplot(2, 3, 1); imshow(srgb1);
hold on; subplot(2, 3, 2); imshow(trgb1);
hold on; subplot(2, 3, 3); imshow(outImg1);
hold on; subplot(2, 3, 4); imshow(srgb2);
hold on; subplot(2, 3, 5); imshow(trgb2);
hold on; subplot(2, 3, 6); imshow(outImg2);
hold on; subtitle(3, 'ReinhardËã·¨');