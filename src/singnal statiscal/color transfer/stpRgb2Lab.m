function labimg = stpRgb2Lab(rgbimg)
%% rgb ת���� lab ��ɫ�ռ�

    rgbimg = im2double(rgbimg);
    
    R = rgbimg(:, :, 1);
    G = rgbimg(:, :, 2);
    B = rgbimg(:, :, 3);
    
    if ((max(max(R)) > 1.0) || (max(max(G)) > 1.0) || (max(max(B)) > 1.0)) 
      R = R /255; 
      G = G /255; 
      B = B /255; 
    end 

    [M, N] = size(R); 
    s = M*N; 

    % Set a threshold 
    T = 0.008856; 

    RGB = [reshape(R, 1, s); reshape(G, 1, s); reshape(B, 1, s)]; 

    % RGB to XYZ 
    MAT = [0.412453 0.357580 0.180423; 
           0.212671 0.715160 0.072169; 
           0.019334 0.119193 0.950227]; 
    XYZ = MAT * RGB; 

    X = XYZ(1, :) / 0.950456; 
    Y = XYZ(2, :); 
    Z = XYZ(3, :) / 1.088754; 

    XT = X > T; 
    YT = Y > T; 
    ZT = Z > T; 

    fX = XT .* X.^(1/3) + (~XT) .* (7.787 .* X + 16/116); 

    % Compute L 
    Y3 = Y.^(1/3);  
    fY = YT .* Y3 + (~YT) .* (7.787 .* Y + 16/116); 
    L  = YT .* (116 * Y3 - 16.0) + (~YT) .* (903.3 * Y); 

    fZ = ZT .* Z.^(1/3) + (~ZT) .* (7.787 .* Z + 16/116); 

    % Compute a and b 
    a = 500 * (fX - fY); 
    b = 200 * (fY - fZ); 

    L = reshape(L, M, N); 
    a = reshape(a, M, N); 
    b = reshape(b, M, N); 

    labimg = cat(3, L, a, b); 
end