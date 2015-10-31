function [ a, b, c ] = stpParabola(x1, y1, x2, y2, x3, y3)
% 计算抛物线的系数
    sx1 = x1 - x2;
    sx2 = x2 - x3;
    sx3 = x3 - x1;
    
    sy1 = y1 - y2;
    sy2 = y2 - y3;
    sy3 = y3 - y1;
    
    temp = sx1 * sx2 * sx3;
    
    a = (sy1 * -sx3 + sy3 * sx1) / -temp;
    b = (sy1 * (x1*x1 - x3*x3) + sy3 * (x1*x1 - x2*x2)) / temp;
    c = (y1*sx1*-sx3*sx2 + x1*x3*sy1*-sx3 - x1*x2*-sy3*sx1) / -temp;
end

