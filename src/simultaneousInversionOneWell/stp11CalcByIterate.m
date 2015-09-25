function stp11CalcByIterate(Cgeo, A, B, C, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, lsCoff, ldCoff, G, dTheory, mPhys, mGeo, welllog)
% 本函数用于迭代mPhys和mGeo

    tVs = welllog(:, 3);
    tVp = welllog(:, 2);
    tRho = welllog(:, 4);
    tPor = welllog(:, 5);           % 孔隙度
    tSw = welllog(:, 6);            % 含水饱和度
    tSh = welllog(:, 7);            % clay content

    iterNum = 3;

    mGeoProir = mGeo;
    [~, sampNum] = size(G);

    B1 = ( Cphysgeo + F*Cgeo*F' ) * G' * invCd;
    A = eye(sampNum) + B1 * G;
    B2 = Cgeo * F' * G' * invCd;
    deltaMphys = zeros(sampNum, 1);
    
    global globalA globalB threshold gloabalTheta globalx thresholdx;
    globalA = A;
    threshold = max(abs(B)) / 100;
    gloabalTheta = 0.7;
    
    for i = 1 : 3
        i
        subProir = (mGeoProir - mGeo);
        subTheory = (dTheory - G * mPhys);

        B = F * mGeo + matrixB - mPhys + F * subProir  + B1 * subTheory;
        globalB = B;
        %deltaMphys = stp12IterateEqual(A, deltaMphys, B, 20);
        deltaMphys = stpMinBFGS(@stpHubberFunc, deltaMphys, 500);
        deltaMgeo = subProir + B2 * (subTheory - G * deltaMphys);
        mGeo = mGeo + deltaMgeo;
        mPhys = mPhys + deltaMphys;
    end
    
%     subProir = (mGeoProir - mGeo);
%     subTheory = (dTheory - G * mPhys);
% 
%     B = F * mGeo + matrixB - mPhys + F * subProir  + B1 * subTheory;
% 
%     deltaMphys = stp12IterateEqual(A, deltaMphys, B, 20);
%     deltaMgeo = subProir + B2 * (subTheory - G * deltaMphys);
%     mGeo = mGeo + deltaMgeo;
%     mPhys = mPhys + deltaMphys;

    
    % 计算按照拟合得到的Lp，deltaLs，deltaLd
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

    figure;
    subplot(1,3,1);
    DY = 1 : sampNum;
    plot(estVp,DY,'r','LineWidth',2);hold on;plot(tVp,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('vp');ylabel('sample');
    subplot(1,3,2);
    plot(estVs,DY,'r','LineWidth',2);hold on;plot(tVs,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('vs');ylabel('sample');
    subplot(1,3,3);
    plot(estRho,DY,'r','LineWidth',2);hold on;plot(tRho,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('den');ylabel('sample');
    legend('petrophysical transform','well log');

    figure;
    subplot(1,3,1);
    DY = 1 : sampNum;
    plot(mGeo(1 : sampNum),DY,'r','LineWidth',2);hold on;plot(tPor,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('por');ylabel('sample');
    subplot(1,3,2);
    plot(mGeo(sampNum+1 : sampNum*2),DY,'r','LineWidth',2);hold on;plot(tSw,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('sw');ylabel('sample');
    subplot(1,3,3);
    plot(mGeo(sampNum*2+1 : sampNum*3),DY,'r','LineWidth',2);hold on;plot(tSh,DY,'b-.','LineWidth',2); set(gca,'ydir','reverse');xlabel('sh');ylabel('sample');
    legend('petrophysical transform','well log');
    
%     figure;
%     plot(RmsePhys(2:iterNum), 'r'); grid on;title('均方误差');
end