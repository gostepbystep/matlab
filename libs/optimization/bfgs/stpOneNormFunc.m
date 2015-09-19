function [out] = stpOneNormFunc(x)
% hubber function 
% 注意 globalA, b, 还有threshold必须都已经存在
    global globalA globalB threshold;
   
    
    vr = abs(globalA * x - globalB);
    
    n = length(globalB);
    
    out = sum(vr);
end