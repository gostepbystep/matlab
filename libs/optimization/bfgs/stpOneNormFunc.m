function [f, g] = stpOneNormFunc(x)
%% one norm function
    global globalA globalB;
 
    n = length(globalB);
    z = globalA * x -globalB;
    
    f = sum( abs(z) );
    
    % calculate the gradient
    for i = 1 : n
        temp = z(i, 1);
        
        if( temp >= 0)
            temp = 1;
        else
            temp = -1;
        end
        
        z(i, 1) = temp;
    end
    
    g = globalA' * z;
end