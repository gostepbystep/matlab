function [out] = stpOneNormFunc(x)
% hubber function 
% ע�� globalA, b, ����threshold���붼�Ѿ�����
    global globalA globalB threshold;
   
    
    vr = abs(globalA * x - globalB);
    
    n = length(globalB);
    
    out = sum(vr);
end