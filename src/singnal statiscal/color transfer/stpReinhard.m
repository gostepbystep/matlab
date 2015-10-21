function [ srgb, trgb, outImg] = stpReinhard(spath, tpath)
%% 把spath中的图片颜色迁移到tpath中的图片上

    %% 读取并转换颜色空间
    srgb = imread(spath);
    trgb = imread(tpath);

    slab = stpRgb2Lab(srgb);
    tlab = stpRgb2Lab(trgb);
    
    %% 计算方差和标准差
    msl = mean2( slab(:, :, 1) );
    msa = mean2( slab(:, :, 2) );
    msb = mean2( slab(:, :, 3) );
    mtl = mean2( tlab(:, :, 1) );
    mta = mean2( tlab(:, :, 2) );
    mtb = mean2( tlab(:, :, 3) );
    
    stdsl = std2( slab(:, :, 1) );
    stdsa = std2( slab(:, :, 2) );
    stdsb = std2( slab(:, :, 3) );
    stdtl = std2( tlab(:, :, 1) );
    stdta = std2( tlab(:, :, 2) );
    stdtb = std2( tlab(:, :, 3) );
    
%     %% 将源图像原有的数据减掉源图像的均值
%     sL = slab(:, :, 1) - msl;
%     sa = slab(:, :, 2) - msa;
%     sb = slab(:, :, 3) - msb;
%     
%     % 再将得到的新数据按比例放缩，其放缩系数是两幅图像标准方差的比值
%     sL = (stdtl / stdsl) * sL;
%     sa = (stdta / stdsa) * sa;
%     sb = (stdtb / stdsb) * sb;
%     
%     % 将得到的sL, sa, sb 分别加上目标图像三个通道的均值，得到最终数据
%     sL = sL + mtl;
%     sa = sa + mta;
%     sb = sb + mtb;
%     
    % 整理得到
    L = (stdsl / stdtl) * (tlab(:, :, 1) - mtl) + msl;
    a = (stdsa / stdta) * (tlab(:, :, 2) - mta) + msa;
    b = (stdsb / stdtb) * (tlab(:, :, 3) - mtb) + msb;
    
    [M, N] = size(trgb(:, :, 1));
    
    L = reshape(L, M, N); 
    a = reshape(a, M, N); 
    b = reshape(b, M, N); 

    labimg = cat(3, L, a, b); 
    
    %% 转换到 rgb 空间
    outImg = stpLab2Rgb(labimg);
end

