function stpSetColor( m, n, x, y, color )
    global image;

    if x <= 0 
        x = 1;
    end

    if y <= 0
        y = 1;
    end

    if x > n
        x = m;
    end;

    if y > m
        y = m;
    end
    
    image(m-y+1, x, :) = color;

end

