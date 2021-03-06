function [ osrgb, otrgb, outImg] = stpCorrelated(spath, tpath)
%% 参考论文Color Transfer in Correlated Color Space

    %% 读取并转换颜色空间
    osrgb = imread(spath);
    otrgb = imread(tpath);
    
    srgb = im2double(osrgb);
    trgb = im2double(otrgb);

    [sm, sn, ~] = size(srgb);
    [tm, tn, ~] = size(trgb);

    srgb = reshape(srgb, sm*sn, 3);
    trgb = reshape(trgb, tm*tn, 3);
    
%     figure;
%     plot3(srgb(:, 1), srgb(:, 2), srgb(:, 3), '*');
%     figure;
%     plot3(trgb(:, 1), trgb(:, 2), trgb(:, 3), 'o');
    
    means = mean(srgb);
    meant = mean(trgb);
    
    covs = cov(srgb);
    covt = cov(trgb);
    
    [sU, sA, sV] = svd(covs);
    [tU, tA, tV] = svd(covt); 
    
    sT = eye(4); sT(1:3, 4) = means';
    tT = eye(4); tT(1:3, 4) = -meant';
    sR = eye(4); sR(1:3, 1:3) = sU;
    tR = eye(4); tR(1:3, 1:3) = inv(tU);
    
%     sS = diag( [sA(1,1), sA(2,2), sA(3,3), 1] );
    tS = diag( [1/sqrt(tA(1,1)), 1/sqrt(tA(2,2)), 1/sqrt(tA(3,3)), 1] );
    sS = diag( [sqrt(sA(1,1)), sqrt(sA(2,2)), sqrt(sA(3,3)), 1] );
%     tS = diag( [1/(tA(1,1)), 1/(tA(2,2)), 1/(tA(3,3)), 1] );
    
    
    tI = [trgb'; ones(1, tm*tn)];
    
    coef = sT * sR  * sS * tS * tR * tT;
    I =  coef * tI;
    
    image = reshape(I(1:3, :)', tm, tn, 3);

    outImg = im2uint8(image);
end

