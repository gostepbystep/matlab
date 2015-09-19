function [angleSeisData, angleData] = stp5Anglegather(superTrData, welllog, angleTrNum, minOffset, maxOffset, dt)
% 本程序用于转换超道集为角道集
% 输出
% angleTrData           角道集
%
% 输入
% superTrData           超道集
% welllog               初始测井曲线
% angleTrNum            角道集道数
% minOffset             最小偏移距
% maxOffset             最大偏移距

    % 计算初始信息
    [sampNum, superTrNum] =  size(superTrData);

    offsetInteval = (maxOffset - minOffset) / superTrNum;
    xoff = zeros(1, superTrNum);
    xoff(1) = minOffset + offsetInteval/2;

    for i = 2 : superTrNum
        xoff(i) = xoff(i - 1) + offsetInteval;
    end

    superTrData = -superTrData(1 : sampNum-1, :);

    % 得到测井曲线
    tDepth = welllog(:, 1);
    tVs = welllog(:, 2);
    tVp = welllog(:, 3);
    tRho = welllog(:, 4);

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
    
    %通过Zoepritz方程计算角度
    [seisTraceZoep meanTheta] = Zoep_syn(xoff, tDepth, startZ, ps, vp, vs, rho);    %Zoepritz道集生成； meanTheta：透射纵波与入射纵波的角度平均

    %超道集转换为角道集
    [angleSeisData angleData] = Offset2Angle(meanTheta, angleTrNum, superTrData);   %道集转换  
    
    %%
    % 绘制地震数据
%     seismic = s_convert(angleData', 0, 2);
%     s_wplot(seismic);
%     title('角度集');

    seismic = s_convert(angleSeisData, 0, 2);
    s_wplot(seismic);
    title('角道集');
end