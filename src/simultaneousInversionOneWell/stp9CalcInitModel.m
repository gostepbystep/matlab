function [gMatrix, rInit, dTheory, lsCoff, ldCoff] = stp9CalcInitModel(angleTrNum, superTrNum, welllog, minOffset, maxOffset, dt)
% 这是一个计算初始模型的函数

    % 得到采样点数
    [sampNum, ~] = size(welllog);

    % 读取基本测井数据
    tDepth = welllog(:, 1);
    tVs = welllog(:, 3);
    tVp = welllog(:, 2);
    tRho = welllog(:, 4);
    %tPor = welllog(:, 5);           % 孔隙度
    %tSw = welllog(:, 6);            % 含水饱和度
    %tSh = welllog(:, 7);            % clay content

    %% 接下来的代码功能是计算角道集的角度
    % 计算偏移间隔
    offsetInteval = (maxOffset - minOffset) / superTrNum;
    xoff = zeros(1, superTrNum);
    xoff(1) = minOffset + offsetInteval/2;
    for i = 2 : superTrNum
        xoff(i) = xoff(i - 1) + offsetInteval;
    end

    dz = tVp(1) * 0.001 * dt;               % 每dt微秒传播的距离作为dz
    z0 = 0 : dz : tDepth(1);                % 表层填充
    z0Num = length(z0);                     % 填充的层数

    % 分配空间
    vp0 = zeros(1, z0Num); vs0 = zeros(1, z0Num); rho0 = zeros(1, z0Num);
    % 填充模型，与有效第一层一样
    vp0(:) = tVp(1); vs0(:) = tVs(1); rho0(:) = tRho(1);
    % 组成完整模型
    depth = [z0'; tDepth]; vp = [vp0'; tVp]; vs = [vs0'; tVs]; rho = [rho0'; tRho];

    % 计算水平慢度
    startZ = z0Num;                             % 有效起始点
    depNum = length(tDepth);                    % 有效数据深度
    ts = zeros(depNum, superTrNum);             % 时间序列
    ps = zeros(depNum, superTrNum);             % 慢度序列

    zsrc=0; zrec=0; caprad=100; itermax=40; pfan=-1; optflag=1; pflag=1; dflag=2; 
    % zsrc:发射源的深度，zrec为接收源的深度 % cap radius最大迭代数 
    for j = 1 : depNum
        zd = depth(startZ + j);                      % xoff中心道集(offsets)；zd为发射点的深度
        [t, p] = traceray_pp(vp, depth, zsrc, zrec, zd, xoff, caprad, pfan, itermax, optflag, pflag, dflag);
        ts(j, :) = t;
        ps(j, :) = p;
    end

     %通过Zoepritz方程计算角度, 并计算角度
    [~, meanTheta] = Zoep_syn(xoff, tDepth, startZ, ps, vp, vs, rho);    %Zoepritz道集生成； meanTheta：透射纵波与入射纵波的角度平均
    angleScale = min(min(meanTheta)) : (max(max(meanTheta))-min(min(meanTheta)))/(angleTrNum) : max(max(meanTheta));
    angleData = zeros(1, angleTrNum);
    for i = 1: 1 : (length(angleScale)-1)
        angleData(i) = (angleScale(i) + angleScale(i+1)) / 2;
    end

    %% 接下来的代码是计算G矩阵之类的
    % 滤波
    f = 0.1;    [b, a] = butter(10, f, 'low');
%     tfVp  = filtfilt(b, a, tVp); 
%     tfVs = filtfilt(b, a, tVs); 
%     tfRho = filtfilt(b, a, tRho); 
    
    tfVp  = tVp;% filtfilt(b, a, tVp); 
    tfVs = tVs; %filtfilt(b, a, tVs); 
    tfRho = tRho; %filtfilt(b, a, tRho); 
    angleSampNum = sampNum - 1;

    % 计算最基本的系数
    [~, c1, c2, c3] = Aki_syn(angleData, tfVp(:, 1)', tfVs(:, 1)', tfRho(:, 1)');

     %计算LP,LS,Ld
    Lp = log(tfRho .* tfVp);
    Ls = log(tfRho .* tfVs);
    Ld = log(tfRho);
    % 线性回归
    [ldCoff lsCoff] = stp6CalcLinearRefByImp(Lp, Ls, Ld);

    %找到角道集不为零的位置，计算对应的G矩阵
    rangeCDP = 1 : angleTrNum;
    gMatrix = GenAMatrix(rangeCDP, c1,c2,c3, Lp, Ls, Ld, 1, lsCoff(1), ldCoff(1));   %提取传播矩阵

    % 计算反射系数
    deltaLs = Ls - ( lsCoff(1)*Lp + lsCoff(2) ); 
    deltaLd = Ld - ( ldCoff(1)*Lp + ldCoff(2) );
    rInit = [Lp; deltaLs; deltaLd];

    % 计算角道集
    dTheory = gMatrix * rInit;
    seisAngleData = zeros(angleSampNum, angleTrNum);
    start = 1;
    for i = 1 : angleTrNum
        seisAngleData(:, i) = dTheory(start : start+angleSampNum-1, 1);
        start = start + angleSampNum;
    end
    
    seismic= s_convert(seisAngleData, 0, 2);
    s_wplot(seismic);
    title('理论角道集');
end