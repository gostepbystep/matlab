function [ srgb, trgb, outImg] = stpReinhard(spath, tpath)
%% ��spath�е�ͼƬ��ɫǨ�Ƶ�tpath�е�ͼƬ��

    %% ��ȡ��ת����ɫ�ռ�
    srgb = imread(spath);
    trgb = imread(tpath);

    slab = stpRgb2Lab(srgb);
    tlab = stpRgb2Lab(trgb);
    
    %% ���㷽��ͱ�׼��
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
    
%     %% ��Դͼ��ԭ�е����ݼ���Դͼ��ľ�ֵ
%     sL = slab(:, :, 1) - msl;
%     sa = slab(:, :, 2) - msa;
%     sb = slab(:, :, 3) - msb;
%     
%     % �ٽ��õ��������ݰ����������������ϵ��������ͼ���׼����ı�ֵ
%     sL = (stdtl / stdsl) * sL;
%     sa = (stdta / stdsa) * sa;
%     sb = (stdtb / stdsb) * sb;
%     
%     % ���õ���sL, sa, sb �ֱ����Ŀ��ͼ������ͨ���ľ�ֵ���õ���������
%     sL = sL + mtl;
%     sa = sa + mta;
%     sb = sb + mtb;
%     
    % ����õ�
    L = (stdsl / stdtl) * (tlab(:, :, 1) - mtl) + msl;
    a = (stdsa / stdta) * (tlab(:, :, 2) - mta) + msa;
    b = (stdsb / stdtb) * (tlab(:, :, 3) - mtb) + msb;
    
    [M, N] = size(trgb(:, :, 1));
    
    L = reshape(L, M, N); 
    a = reshape(a, M, N); 
    b = reshape(b, M, N); 

    labimg = cat(3, L, a, b); 
    
    %% ת���� rgb �ռ�
    outImg = stpLab2Rgb(labimg);
end

