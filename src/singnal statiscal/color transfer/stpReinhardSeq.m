function [ otrgb, outImg] = stpReinhardSeq(spaths, tpath, N, M)
%% 迁移过程

    %% 读取并转换颜色空间
    otrgb = imread(tpath);
    [tm, tn, ~] = size(otrgb);
    
    dtlab = stpRgb2Lab(otrgb);
    tlab = reshape(dtlab, tm*tn, 3);
    tmean = mean(tlab);
    tstd = std(tlab);
    
    nBImg = length(spaths);
    slab = cell(1, nBImg);
    dims = zeros(nBImg, 3);
    smean = zeros(nBImg, 3);
    sstd = zeros(nBImg, 3);
    
    outImg = cell(1, nBImg);
    
    % 存储系数， al, bl, cl; aa, ba, ca; ab, bb, cb;
    uCoef = zeros(3, 3);
    vCoef = zeros(3, 3);
    
    for i = 1 : nBImg
        temp = imread( spaths{i} );
        temp = stpRgb2Lab(temp);
        
        dims(i, :) = size(temp);
        slab{i} = reshape(temp, dims(i,1)*dims(i,2), 3);
        smean(i, :) = mean( slab{i} );
        sstd(i, :) = std( slab{i} );
    end
    
    % 计算系数
    for i = 1 : 3
        [uCoef(i, 1), uCoef(i, 2), uCoef(i, 3)] = stpParabola(1, smean(1, i), M, smean(2, i), N, smean(3, i));
        [vCoef(i, 1), vCoef(i, 2), vCoef(i, 3)] = stpParabola(1, sstd(1, i), M, sstd(2, i), N, sstd(3, i));
    end
    
    %% 绘制曲线
    figure;
    stpPlotParabola(uCoef(1, 1), b, c, sp, color)
    
    dtlab(:, :, 1) = dtlab(:, :, 1) - tmean(1);
    dtlab(:, :, 2) = dtlab(:, :, 2) - tmean(2);
    dtlab(:, :, 3) = dtlab(:, :, 3) - tmean(3);
    
    lab = zeros(tm, tn, 3);
    
    for i = 1 : N
        u = uCoef(:, 1) * i * i + uCoef(:, 2) * i + uCoef(:, 3);
        v = vCoef(:, 1) * i * i + vCoef(:, 2) * i + vCoef(:, 3);

%         u = smean(i, :);
%         v = sstd(i, :);

        lab(:, :, 1) = (v(1) / tstd(1)) * dtlab(:, :, 1) + u(1);
        lab(:, :, 2) = (v(2) / tstd(2)) * dtlab(:, :, 2) + u(2);
        lab(:, :, 3) = (v(3) / tstd(3)) * dtlab(:, :, 3) + u(3);
        
        outImg{i} = stpLab2Rgb(lab);
    end
%     % 整理得到
%     L = (stdsl / stdtl) * (tlab(:, :, 1) - mtl) + msl;
%     a = (stdsa / stdta) * (tlab(:, :, 2) - mta) + msa;
%     b = (stdsb / stdtb) * (tlab(:, :, 3) - mtb) + msb;
    
end

