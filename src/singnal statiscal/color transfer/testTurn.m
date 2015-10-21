%% 测试颜色空间转换的代码
path = 'F:\picture\cvx\bbs\1.jpg';
imdata = imread(path);

lab = stpRgb2Lab(imdata);
rgb = stpLab2Rgb(lab);

figure;
subplot(1,2,1);
imshow(imdata);

hold on;
subplot(1, 2, 2);
imshow(rgb);
