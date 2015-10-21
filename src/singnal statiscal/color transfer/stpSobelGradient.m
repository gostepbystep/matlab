function [g, theta, gx, gy] = stpSobelGradient( imdata, quiet )
% ����sobel���Ӽ����ݶȵķ���

    imdata = im2double(imdata);
    
    %% sobel����
    Gx = [-1 0 +1;
          -2 0 +2;
          -1 0 +1];
      
    Gy = [+1 +2 +1;
          0  0  0;
          -1 -2 -1;
            ];
        
    [m, n, dim] = size(imdata);
    
    gx = zeros(m, n, dim);
    gy = zeros(m, n, dim);
    
    for i = 1 : dim
        gx(:, :, i) = conv2(imdata(:, :, i), Gx, 'same');
        gy(:, :, i) = conv2(imdata(:, :, i), Gy, 'same');
%         gx(:, :, dim) = imfilter(imdata(:, :, dim), Gx, 'replicate');
%         gy(:, :, dim) = imfilter(imdata(:, :, dim), Gy, 'replicate');
    end
    
%     for i = 1 : m
%         for j = 1 : n
%             for k = 1 : dim
%                 if gx(i, j, k) > 255 
%             end
%         end
%     end

    g = abs(gx) + abs(gy);
    theta = atan( gx ./ gy );
    
    gx = im2uint8(gx);
    gy = im2uint8(gy);
    g = im2uint8(g);
    theta = im2uint8(theta);
    
    if ~quiet
        figure;  subplot(3, 2, 1);  imshow(imdata); title('ԭͼ'); 
        hold on; subplot(3, 2, 3);  imshow(gx);    title('x�����Ե���');
        hold on; subplot(3, 2, 4);  imshow(gy);    title('y�����Ե���');
        hold on; subplot(3, 2, 5);  imshow(g);     title('�ݶ�');
        hold on; subplot(3, 2, 6);  imshow(theta); title('�Ƕȱ仯');
    end
    
end

