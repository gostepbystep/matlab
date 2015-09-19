function [f, g] = stpCombMixFunc(x)
%% combination mixture funtion 
    global globalA globalB threshold gloabalTheta;
   
    z = globalA * x - globalB;
    sum = 0;
    n = length(globalB);
    
    for i = 1 : n
        % calculate the function value
        r = abs ( z(i, 1) );
        r = gloabalTheta*r + (1-gloabalTheta)*0.5*r*r;
        sum = sum + r;
        
        % calculate the gradient
        temp = z(i, 1);
        if( temp >= 0)
            temp = 1;
        else
            temp = -1;
        end
        
        z(i, 1) = gloabalTheta*temp + (1 - gloabalTheta)*z(i, 1);
    end
    
    f = sum;
    g = globalA' * z;
end