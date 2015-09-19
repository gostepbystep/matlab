function [out] = stpOneNormGFunc(x)
% hubber function µÄÌÝ¶È
    global globalA globalB threshold;
    
%     out = mb_numDiff(@stpHubberFunc,x);
    
    n = length(globalB);
    
    z = globalA * x -globalB;
    
    for i = 1 : n
        temp = z(i, 1);
        
        if( temp >= 0)
            temp = 1;
        else
            temp = -1;
        end
        
        z(i, 1) = temp;
    end
    
    out = globalA' * z;

end