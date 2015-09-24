function stpScatter( points )
    x = points(:, 1);
    y = points(:, 2);
    z = points(:, 3);
    
    [X, Y, Z] = griddata(x, y, z, linspace(min(x),max(x), 100)', linspace(min(y),max(y),100), 'v4');
    
    surf(X, Y, Z);

end

