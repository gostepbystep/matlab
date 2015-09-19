function [angleSeisData, angleData] = stp5Anglegather(superTrData, welllog, angleTrNum, minOffset, maxOffset, dt)
% ����������ת��������Ϊ�ǵ���
% ���
% angleTrData           �ǵ���
%
% ����
% superTrData           ������
% welllog               ��ʼ�⾮����
% angleTrNum            �ǵ�������
% minOffset             ��Сƫ�ƾ�
% maxOffset             ���ƫ�ƾ�

    % �����ʼ��Ϣ
    [sampNum, superTrNum] =  size(superTrData);

    offsetInteval = (maxOffset - minOffset) / superTrNum;
    xoff = zeros(1, superTrNum);
    xoff(1) = minOffset + offsetInteval/2;

    for i = 2 : superTrNum
        xoff(i) = xoff(i - 1) + offsetInteval;
    end

    superTrData = -superTrData(1 : sampNum-1, :);

    % �õ��⾮����
    tDepth = welllog(:, 1);
    tVs = welllog(:, 2);
    tVp = welllog(:, 3);
    tRho = welllog(:, 4);

    dz = tVp(1) * 0.001 * dt;               % ÿdt΢�봫���ľ�����Ϊdz
    z0 = 0 : dz : tDepth(1);                % ������
    z0Num = length(z0);                     % ���Ĳ���

    % ����ռ�
    vp0 = zeros(1, z0Num); vs0 = zeros(1, z0Num); rho0 = zeros(1, z0Num);
    % ���ģ�ͣ�����Ч��һ��һ��
    vp0(:) = tVp(1); vs0(:) = tVs(1); rho0(:) = tRho(1);
    % �������ģ��
    depth = [z0'; tDepth]; vp = [vp0'; tVp]; vs = [vs0'; tVs]; rho = [rho0'; tRho];

    % ����ˮƽ����
    startZ = z0Num;                             % ��Ч��ʼ��
    depNum = length(tDepth);                    % ��Ч�������
    ts = zeros(depNum, superTrNum);             % ʱ������
    ps = zeros(depNum, superTrNum);             % ��������

    zsrc=0; zrec=0; caprad=100; itermax=40; pfan=-1; optflag=1; pflag=1; dflag=2; 
    % zsrc:����Դ����ȣ�zrecΪ����Դ����� % cap radius�������� 
    for j = 1 : depNum
        zd = depth(startZ + j);                      % xoff���ĵ���(offsets)��zdΪ���������
        [t, p] = traceray_pp(vp, depth, zsrc, zrec, zd, xoff, caprad, pfan, itermax, optflag, pflag, dflag);
        ts(j, :) = t;
        ps(j, :) = p;
    end
    
    %ͨ��Zoepritz���̼���Ƕ�
    [seisTraceZoep meanTheta] = Zoep_syn(xoff, tDepth, startZ, ps, vp, vs, rho);    %Zoepritz�������ɣ� meanTheta��͸���ݲ��������ݲ��ĽǶ�ƽ��

    %������ת��Ϊ�ǵ���
    [angleSeisData angleData] = Offset2Angle(meanTheta, angleTrNum, superTrData);   %����ת��  
    
    %%
    % ���Ƶ�������
%     seismic = s_convert(angleData', 0, 2);
%     s_wplot(seismic);
%     title('�Ƕȼ�');

    seismic = s_convert(angleSeisData, 0, 2);
    s_wplot(seismic);
    title('�ǵ���');
end