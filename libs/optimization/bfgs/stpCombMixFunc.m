function [out] = stpLinearMixFunc(x)
% hubber function 
% ע�� globalA, b, ����threshold���붼�Ѿ�����
    global globalA globalB threshold gloabalTheta;
   
    
    vr = abs(globalA * x - globalB);
    sum = 0;
    
    n = length(globalB);
    
    for i = 1 : n
        r = vr(i, 1);
        
        r = gloabalTheta*r + (1-gloabalTheta)*0.5*r*r;
       
        sum = sum + r;
    end
    
    out = sum;
end