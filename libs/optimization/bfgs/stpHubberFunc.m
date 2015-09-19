function [out] = stpHubberFunc(x)
% hubber function 
% ע�� globalA, b, ����threshold���붼�Ѿ�����
    global globalA globalB threshold;
   
    
    vr = abs(globalA * x - globalB);
    sum = 0;
    
    n = length(globalB);
    
    for i = 1 : n
        r = vr(i, 1);
        
        if (r>=0 && r<=threshold)
            sum = sum + r*r/(2*threshold);
        else
            sum = sum + (r - threshold/2);
        end
        sum = sum + r;
    end
    
    out = sum;
end