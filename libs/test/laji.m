%% matalba ¸øÍ¼Ïñ»æÖÆ×ø±ê

path = 'F:\\QQ\\1933588939\\FileRecv\\vel1.jpg';

imdata = imread(path);
figure;
subimage(imdata);

[yrange, xrange, ~] = size(imdata);

left = 542;
right = 934;
down = 657;
up = 157;

% 
xnum = 10;
xcelllabel = cell(1, xnum+1);
xnumrange = zeros(1, xnum+1);
for i = 0 : xnum
    xcelllabel{i+1} = left + floor((right-left)/xnum * i);
    xnumrange(i+1) = 1 + floor((xrange-1)/xnum * i);
end

ynum = 5;
ycelllabel = cell(1, ynum+1);
ynumrange = zeros(1, ynum+1);
for i = 0 : ynum
    ycelllabel{ynum+1-i} = up + floor((down-up)/ynum * i);
    ynumrange(i+1) = 1 + floor((yrange-1)/ynum * i);
end

set(gca, 'xtick', xnumrange, 'xticklabel', xcelllabel);
set(gca, 'ytick', ynumrange, 'yticklabel', ycelllabel);
