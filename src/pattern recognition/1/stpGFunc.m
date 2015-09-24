function [ out ] = stpGFunc( x, meanValue, invCov, c)
    % the desision function
    d = x - meanValue;
    out = -0.5 * d' * invCov * d + c;
end

