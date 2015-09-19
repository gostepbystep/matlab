function [out] = stpLinearMixGFunc(x)
% hubber function ���ݶ�
    global globalA globalB threshold gloabalTheta;
    
%     out = mb_numDiff(@stpHubberFunc,x);
    
    n = length(globalB);
    
    z = globalA * x -globalB;
    
    for i = 1 : n
        % һ�׷���
        temp = z(i, 1);
        
        if( temp >= 0)
            temp = 1;
        else
            temp = -1;
        end
        
        z(i, 1) = gloabalTheta*temp + (1 - gloabalTheta)*z(i, 1);
        
    end
    
    out = globalA' * z;
    

end