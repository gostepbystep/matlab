function [outWelllog] = stpCalcIterate(welllog, mGeo, mPhys, F, matrixB, Cgeo, invCd, Cphysgeo, G, d, lsCoff, ldCoff, iterNum)
% 本函数用于迭代mPhys和mGeo
    
    initGeo = mGeo;
    initPhys = mPhys;
    
    mGeoProir = mGeo;
    [~, sampNum] = size(G);

    B1 = ( Cphysgeo + F*Cgeo*F' ) * G' * invCd;
    A = eye(sampNum) + B1 * G;
    B2 = Cgeo * F' * G' * invCd;
    deltaMphys = zeros(sampNum, 1);
    
    dim = sampNum / 3;
    lamuda = zeros(3*dim,1);
    lamuda(1:dim,1) = -0.4;
    lamuda(dim+1:2*dim,1)=-0.4;
    lamuda(2*dim+1:3*dim,1)=0.2;
    
    lastPhys = stpIterateEqual(G, mPhys, d, 8);
    for i = 1 : iterNum
        subProir = (mGeoProir - mGeo);
        subTheory = (d - G * mPhys);

        B = F * mGeo + matrixB - mPhys + F * subProir  + B1 * subTheory;

        %deltaMphys = stpIterateEqual(A, deltaMphys, B, 6);
        deltaMphys = stpMinBFGSLinearEqual(@stpHubberFunc,  A, deltaMphys, B, 6);
        
%         tempPhys = mPhys;
%         mPhys = stpIterateEqual(G, tempPhys, d, 8);
%         deltaMphys = mPhys - tempPhys;
        
        deltaMgeo = subProir + B2 * (subTheory - G * deltaMphys);
        mGeo = mGeo + deltaMgeo;
        mPhys = mPhys + deltaMphys;
    end
    
    mPhys = lastPhys;

    % 测试一种新的方法，先求出具体的x
%     lastPhys = stpIterateEqual(G, mPhys, d, 8);
    
%     temp = F * mGeoProir + matrixB;
% %     mPhys = lastPhys;
%     for i = 1 : iterNum
%         subProir = (mGeoProir - mGeo);
%         subTheory = (d - G * mPhys);
% 
%         B = temp - mPhys  + B1 * subTheory;
% %         B = F * mGeo + matrixB - mPhys + F * subProir  + B1 * subTheory;
% 
%         deltaMphys = stpIterateEqual(A, deltaMphys, B, 8);
%         deltaMgeo = subProir + B2 * (subTheory - G * deltaMphys);
%         
%         mGeo = mGeo + deltaMgeo;
%         mPhys = mPhys + deltaMphys;
%         
%         RMSE(i) = sqrt( mse(deltaMphys) ) + sqrt( mse(deltaMgeo) );
%         
%         if ( i>=2 && abs(RMSE(i-1)-RMSE(i)) < error)
%             break;
%         end
%     end
    
%     mPhys = lastPhys;
    
    % 计算按照拟合得到的Lp，deltaLs，deltaLd
    %%
    sampNum = sampNum / 3;
    
    nLp = mPhys(1 : sampNum);
    nDeltaLs = mPhys( sampNum+1 : sampNum*2);
    nDeltaLd = mPhys( sampNum*2+1 : sampNum*3);

    estLp = nLp;
    estLs = lsCoff(1) * nLp + lsCoff(2) +  nDeltaLs;
    estLd = ldCoff(1) * nLp + ldCoff(2) + nDeltaLd;
    estVp = exp(estLp - estLd);
    estVs = exp(estLs - estLd);
    estRho = exp(estLd);
    %%
    initLp = initPhys(1 : sampNum);
    initDeltaLs = initPhys( sampNum+1 : sampNum*2);
    initDeltaLd = initPhys( sampNum*2+1 : sampNum*3);

    initEstLp = initLp;
    initEstLs = lsCoff(1) * initLp + lsCoff(2) +  initDeltaLs;
    initEstLd = ldCoff(1) * initLp + ldCoff(2) + initDeltaLd;
    initEstVp = exp(initEstLp - initEstLd);
    initEstVs = exp(initEstLs - initEstLd);
    initEstRho = exp(initEstLd);
    

    %%
    mGeo(mGeo(:,1)<0,1)=0;
    mGeo(mGeo(:,1)>1,1)=1;
    estRho(estRho(:,1)<2.4) = 2.4;
    
%     outWelllog = zeros(3, 80, 7);
%     outWelllog(1, :, :) = welllog;
%     outWelllog(2, :, :) = [welllog(:, 1), initEstVp, initEstVs, initEstRho, initGeo(1 : sampNum), initGeo(sampNum+1 : sampNum*2), initGeo(sampNum*2+1 : sampNum*3)];
%     outWelllog(3, :, :) = [welllog(:, 1), estVp, estVs, estRho, mGeo(1 : sampNum), mGeo(sampNum+1 : sampNum*2), mGeo(sampNum*2+1 : sampNum*3)];
    outWelllog = [welllog(:, 1)'; estVp'; estVs'; estRho'; mGeo(1 : sampNum)'; mGeo(sampNum+1 : sampNum*2)'; mGeo(sampNum*2+1 : sampNum*3)'];
end