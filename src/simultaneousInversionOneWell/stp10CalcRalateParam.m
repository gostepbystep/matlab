function [Cgeo, A, B, C, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, lsCoff, ldCoff, mPhys, mGeo] = stp10CalcRalateParam(welllog, rInit, dTheory, lsCoff, ldCoff)
% 这是一个计算贝叶斯定理需要的相关矩阵的代码

    % 得到采样点数
    [sampNum, ~] = size(welllog);

    % 读取基本测井数据
    tDepth = welllog(:, 1);
    tVp = welllog(:, 2);
    tVs = welllog(:, 3);
    tRho = welllog(:, 4);
    tPor = welllog(:, 5);           % 孔隙度
    tSw = welllog(:, 6);            % 含水饱和度
    tSh = welllog(:, 7);            % clay content

    % 单位矩阵
    I = eye(sampNum);
    Zero = zeros(sampNum, sampNum);

    % 计算Cgeo
    X = [tPor, tSw, tSh];
    cgeo = cov(X);          

    Cgeo = [cgeo(1, 1)*I, cgeo(1, 2)*I, cgeo(1, 3)*I;
            cgeo(2, 1)*I, cgeo(2, 2)*I, cgeo(2, 3)*I;
            cgeo(3, 1)*I, cgeo(3, 2)*I, cgeo(3, 3)*I];

    % 得到Lp，deltaLs，deltaLd
%     Lp = rInit(1 : sampNum, 1);
%     deltaLs = rInit(sampNum+1    : sampNum*2, 1);
%     deltaLd = rInit(sampNum*2+1  : sampNum*3, 1);
    
    Lp = log(tRho .* tVp);
    Ls = log(tRho .* tVs);
    Ld = log(tRho);
    [lsCoff, ~] = polyfit(Lp, Ls, 1);
    deltaLs = Ls - (lsCoff(1) * Lp + lsCoff(2)); 
    [ldCoff, ~] = polyfit(Lp,Ld,1);
    deltaLd = Ld - (ldCoff(1) * Lp + ldCoff(2));

    X = [X, ones(sampNum, 1)];
    A = regress(Lp , X);
    B = regress(deltaLs , X);
    C = regress(deltaLd , X);

    % 计算F矩阵
    F = [A(1)*I, A(2)*I, A(3)*I;
         B(1)*I, B(2)*I, B(3)*I;
         C(1)*I, C(2)*I, C(3)*I];
    IVector = ones(sampNum, 1);
    matrixB = [A(4)*IVector; B(4)*IVector; C(4)*IVector];

    % 计算按照拟合得到的Lp，deltaLs，deltaLd
    nLp = A(1)*tPor + A(2)*tSw + A(3)*tSh + A(4);
    nDeltaLs = B(1)*tPor + B(2)*tSw + B(3)*tSh + B(4);
    nDeltaLd = C(1)*tPor + C(2)*tSw + C(3)*tSh + C(4);

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

    % 计算Cphysgeo
    cphysgeo = cov([nLp, nDeltaLs, nDeltaLd]);
    % Cphysgeo = [cphysgeo(1, 1)*I, cphysgeo(1, 2)*I, cphysgeo(1, 3)*I;
    %             cphysgeo(2, 1)*I, cphysgeo(2, 2)*I, cphysgeo(2, 3)*I;
    %             cphysgeo(3, 1)*I, cphysgeo(3, 2)*I, cphysgeo(3, 3)*I];
    Cphysgeo = [cphysgeo(1, 1)*I,   Zero,               Zero;
                Zero,               cphysgeo(2, 2)*I,   Zero;
                Zero,               Zero,               cphysgeo(3, 3)*I];

    invCphysgeo = [ 1.0/cphysgeo(1, 1)*I,   Zero,                   Zero;
                    Zero,                   1.0/cphysgeo(2, 2)*I,   Zero;
                    Zero,                   Zero,                   1.0/cphysgeo(3, 3)*I];


    covd = cov(dTheory);
    [trNum, ~] = size(dTheory);
    Cd = covd * eye(trNum);
    invCd = 1.0/covd * eye(trNum);

    f = 0.1;    [b, a] = butter(10, f, 'low');
    tfVp  = filtfilt(b, a, tVp); 
    tfVs = filtfilt(b, a, tVs); 
    tfRho = filtfilt(b, a, tRho); 
    Lp = log(tfRho .* tfVp);
    Ls = log(tfRho .* tfVs);
    Ld = log(tfRho);
    % 线性回归
    % [ldCoff lsCoff] = stp6CalcLinearRefByImp(Lp, Ls, Ld);
    deltaLs = Ls - ( lsCoff(1)*Lp + lsCoff(2) ); 
    deltaLd = Ld - ( ldCoff(1)*Lp + ldCoff(2) );
    
    mPhys = [Lp; deltaLs; deltaLd];
    
     f = 0.1;    [b, a] = butter(10, f, 'low');
    tfPor  = filtfilt(b, a, tPor); 
    tfSw = filtfilt(b, a, tSw); 
    tfSh = filtfilt(b, a, tSh); 
    mGeo = [tfPor; tfSw; tfSh];
end