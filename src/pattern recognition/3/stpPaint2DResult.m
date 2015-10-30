function stpPaint2DResult(slable, sval, rlable, m, n, xmin, xmax, ymin, ymax)
%% 绘制2维图片的结果, 注意，rlabel 按照 m * n 像素顺序排列
    
    colorTable = [197,193,170;
                  205,133,0;
                  0,122,127; 
                  0,205,0;
                  102,205,170;
                  255,255,0;
                  255,187,255;
                  255,52,179;
                  255,106,106;
                  255,0,0
                  ];            
          
    global image;
    image = zeros(m, n, 3);
    
    
    index = int32(1);
    
    for i = 1 : n
        for j = 1 : m
            switch( rlable(index) )
                case 1
                    image(m-j+1, i, :) = colorTable(1, :);
                case 2
                    image(m-j+1, i, :) = colorTable(3, :);
                case 3
                    image(m-j+1, i, :) = colorTable(5, :);
                case 4
                    image(m-j+1, i, :) = colorTable(7, :);
                case 5
                    image(m-j+1, i, :) = colorTable(9, :);
                    
            end
            index = index + 1;
        end
    end
    
    xdist = xmax - xmin;
    ydist = ymax - ymin;
    
    
    
    for i = 1 : length(slable)
        x = floor ( ( sval(i, 1) - xmin ) / xdist * n );
        y = floor ( ( sval(i, 2) - ymin ) / ydist * m );
        
        
        iClass = slable(i);
        cIndex = 2 * iClass;
        color = colorTable(cIndex, :);
        
        stpSetColor(m, n, x, y, color);
        stpSetColor(m, n, x-1, y-1, color);
        stpSetColor(m, n, x-1, y+1, color);
        stpSetColor(m, n, x+1, y-1, color);
        stpSetColor(m, n, x+1, y+1, color);
        
%         image(m-y+1, x, :) = colorTable(cIndex, :);
    end
    
    image = uint8(image);
    
    imshow(image);
end