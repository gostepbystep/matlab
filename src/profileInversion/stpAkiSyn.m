function [c1, c2, c3] = stpAkiSyn(angleData, vp, vs, rho)
    %%
    angleTrNum = length(angleData);
    [sampNum, ~] = size(vp);
    
    % 计算gamm的值
    sampNum = sampNum - 1;
   
    gamma = zeros(sampNum, 1);
    for i = 1 : sampNum
        gamma(i) = ( vs(i+1) + vs(i) ) / ( vp(i+1) + vp(i) );
    end
    
    
    meanTheta = size(sampNum, angleTrNum);
    Theta2 = size(sampNum, angleTrNum);
    
    % 计算meanTheta
    for i = 1 : sampNum
        for j = 1 : angleTrNum
            [Theta2(i,j), ~, ~] = snell(angleData(j), vs(i), vp(i), vs(i+1), vp(i+1));%angleData(j)入射角；Theta2(i,j)透射角
            meanTheta(i,j) = (Theta2(i,j) + angleData(j)) / 2;
        end
    end
    
    
    % 计算c1, c2, c3
    c1 = zeros(sampNum, angleTrNum);
    c2 = zeros(sampNum, angleTrNum);
    c3 = zeros(sampNum, angleTrNum);
    
    c1 = 1+(tan(meanTheta)).^2;
    
    for i = 1 : angleTrNum
        c2(:,i) = -8*gamma.^2.*(sin(meanTheta(:,i))).^2;
    end
    for i = 1 : angleTrNum
        c3(:,i) = -(tan(meanTheta(:,i))).^2/2+2*gamma.^2.*(sin(meanTheta(:,i))).^2;
    end
end