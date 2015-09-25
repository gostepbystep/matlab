function [outWelllog] = stpInversionFunc(welllog, superTrData, angleTrNum, superTrNum, offsetMin, offsetMax, dt)

    deltaMphys = zeros(240, 1);
    vecNum = 80;
    
     % 第7.1步骤 计算剖面的G矩阵，计算d = Gx这三部分
    [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData, angleTrNum, superTrNum, offsetMin, offsetMax, dt);
    [Cgeo, F, matrixB, Cphysgeo, ~, ~, invCd, mPhys, mGeo, lsCoff, ldCoff] = stpBayesParam(welllog, x, d, lsCoff, ldCoff);
        
    initGeo = mGeo;
    initPhys = mPhys;
    
    for i = 1 : 4
        % 注意，超道集最后一个道集不要
        mGeoProir = mGeo;
        [~, sampNum] = size(G);

        B1 = ( Cphysgeo + F*Cgeo*F' ) * G' * invCd;
        A = eye(sampNum) + B1 * G;
        B2 = Cgeo * F' * G' * invCd;
    
        subProir = (mGeoProir - mGeo);
        subTheory = (d - G * mPhys);

        B = F * mGeo + matrixB - mPhys + F * subProir  + B1 * subTheory;

        deltaMphys = stpIterateEqual(A, deltaMphys, B, 8);
        deltaMgeo = subProir + B2 * (subTheory - G * deltaMphys);
        mGeo = mGeo + deltaMgeo;
        mPhys = mPhys + deltaMphys;
        
        nLp = mPhys(1 : vecNum);
        nDeltaLs = mPhys( vecNum+1 : vecNum*2);
        nDeltaLd = mPhys( vecNum*2+1 : vecNum*3);

        estLp = nLp;
        estLs = lsCoff(1) * nLp + lsCoff(2) +  nDeltaLs;
        estLd = ldCoff(1) * nLp + ldCoff(2) + nDeltaLd;
        estVp = exp(estLp - estLd);
        estVs = exp(estLs - estLd);
        estRho = exp(estLd);
    
        test = [welllog(:, 1), estVp, estVs, estRho, mGeo(1 : 80), mGeo(81 : 160), mGeo(161 : 240)];
        [Cgeo, F, matrixB, Cphysgeo, ~, ~, invCd, ~, ~, lsCoff, ldCoff] = stpBayesParam(test, x, d, lsCoff, ldCoff);
    end
    
%     figure; plot(RMSE(2:iterNum)); grid on; title('均方误差');
    % 计算按照拟合得到的Lp，deltaLs，deltaLd
    % 计算按照拟合得到的Lp，deltaLs，deltaLd
    sampNum = vecNum;
    
    nLp = mPhys(1 : sampNum);
    nDeltaLs = mPhys( sampNum+1 : sampNum*2);
    nDeltaLd = mPhys( sampNum*2+1 : sampNum*3);

    estLp = nLp;
    estLs = lsCoff(1) * nLp + lsCoff(2) +  nDeltaLs;
    estLd = ldCoff(1) * nLp + ldCoff(2) + nDeltaLd;
    estVp = exp(estLp - estLd);
    estVs = exp(estLs - estLd);
    estRho = exp(estLd);
    
    initLp = initPhys(1 : sampNum);
    initDeltaLs = initPhys( sampNum+1 : sampNum*2);
    initDeltaLd = initPhys( sampNum*2+1 : sampNum*3);

    initEstLp = initLp;
    initEstLs = lsCoff(1) * initLp + lsCoff(2) +  initDeltaLs;
    initEstLd = ldCoff(1) * initLp + ldCoff(2) + initDeltaLd;
    initEstVp = exp(initEstLp - initEstLd);
    initEstVs = exp(initEstLs - initEstLd);
    initEstRho = exp(initEstLd);
    
    mGeo(mGeo(:,1)<0,1)=0;
    mGeo(mGeo(:,1)>1,1)=1;
    estRho(estRho(:,1)<2.4) = 2.4;
    
    outWelllog = zeros(3, 80, 7);
    outWelllog(1, :, :) = welllog;
    outWelllog(2, :, :) = [welllog(:, 1), initEstVp, initEstVs, initEstRho, initGeo(1 : sampNum), initGeo(sampNum+1 : sampNum*2), initGeo(sampNum*2+1 : sampNum*3)];
    outWelllog(3, :, :) = [welllog(:, 1), estVp, estVs, estRho, mGeo(1 : sampNum), mGeo(sampNum+1 : sampNum*2), mGeo(sampNum*2+1 : sampNum*3)];
%     outWelllog = [welllog(:, 1)'; estVp'; estVs'; estRho'; mGeo(1 : sampNum)'; mGeo(sampNum+1 : sampNum*2)'; mGeo(sampNum*2+1 : sampNum*3)'];
end