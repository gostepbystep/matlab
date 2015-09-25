function [meanTheta, G, x, lsCoff, ldCoff] = stpCalcGmatrix(welllog, angleTrNum, superTrNum, offsetMin, offsetMax, dt)
% ����һ�������ʼģ�͵ĺ���
    
    % ��ȡ�����⾮����
    tDepth = welllog(:, 1);
    tVs = welllog(:, 3);
    tVp = welllog(:, 2);
    tRho = welllog(:, 4);
    %tPor = welllog(:, 5);           % ��϶��
    %tSw = welllog(:, 6);            % ��ˮ���Ͷ�
    %tSh = welllog(:, 7);            % clay content

    %% �������Ĵ��빦���Ǽ���ǵ����ĽǶ�
    % ����ƫ�Ƽ��
    offsetInteval = (offsetMax - offsetMin) / superTrNum;
    xoff = zeros(1, superTrNum);
    xoff(1) = offsetMin + offsetInteval/2;
    for i = 2 : superTrNum
        xoff(i) = xoff(i - 1) + offsetInteval;
    end

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
    sampNum = length(tDepth);                    % ��Ч�������
    ts = zeros(sampNum, superTrNum);             % ʱ������
    ps = zeros(sampNum, superTrNum);             % ��������

    zsrc=0; zrec=0; caprad=100; itermax=40; pfan=-1; optflag=1; pflag=1; dflag=2; 
    % zsrc:����Դ����ȣ�zrecΪ����Դ����� % cap radius�������� 
    for j = 1 : sampNum
        zd = depth(startZ + j);                      % xoff���ĵ���(offsets)��zdΪ���������
        [t, p] = traceray_pp(vp, depth, zsrc, zrec, zd, xoff, caprad, pfan, itermax, optflag, pflag, dflag);
        ts(j, :) = t;
        ps(j, :) = p;
    end

     %ͨ��Zoepritz���̼���Ƕ�, ������Ƕ�
    [~, meanTheta] = Zoep_syn(xoff, tDepth, startZ, ps, vp, vs, rho);    %Zoepritz�������ɣ� meanTheta��͸���ݲ��������ݲ��ĽǶ�ƽ��
    angleScale = min(min(meanTheta)) : (max(max(meanTheta))-min(min(meanTheta)))/(angleTrNum) : max(max(meanTheta));
    angleData = zeros(1, angleTrNum);
    for i = 1: 1 : (length(angleScale)-1)
        angleData(i) = (angleScale(i) + angleScale(i+1)) / 2;
    end

    %% �������Ĵ����Ǽ���G����֮���
    % �˲�
    f = 0.1;    [b, a] = butter(10, f, 'low');
    tfVp  = filtfilt(b, a, tVp); 
    tfVs = filtfilt(b, a, tVs); 
    tfRho = filtfilt(b, a, tRho); 
    
%     tfVp(tfVp(1:10,1)>4200,1)=4200;  tfVs(tfVs(1:10,1)>2300,1)=2300; 
%     tfVp(tfVp(75:80,1)>4200,1)=4200; tfVs(tfVs(:,1)>2450,1)=2450;
%     tfVs(tfVs(:,1)<2.3,1)=2300;   tfVs(tfVs(75:80,1)>2.45,1)=2300;
   
%     
%     tfVp  = tVp;% filtfilt(b, a, tVp); 
%     tfVs = tVs; %filtfilt(b, a, tVs); 
%     tfRho = tRho; %filtfilt(b, a, tRho); 

    % �����������ϵ��
    [c1, c2, c3] = stpAkiSyn(angleData, tfVp, tfVs, tfRho);

     %����LP,LS,Ld
    Lp = log(tfRho .* tfVp);
    Ls = log(tfRho .* tfVs);
    Ld = log(tfRho);
    % ���Իع�
    lsCoff = polyfit(Lp, Ls, 1);
    ldCoff = polyfit(Lp, Ld, 1);
    
    

    %�ҵ��ǵ�����Ϊ���λ�ã������Ӧ��G����
    rangeCDP = 1 : angleTrNum;
    G = GenAMatrix(rangeCDP, c1,c2,c3, Lp, Ls, Ld, 1, lsCoff(1), ldCoff(1));   %��ȡ��������

    % ���㷴��ϵ��
    deltaLs = Ls - ( lsCoff(1)*Lp + lsCoff(2) ); 
    deltaLd = Ld - ( ldCoff(1)*Lp + ldCoff(2) );
    x = [Lp; deltaLs; deltaLd];
    
     %����LP,LS,Ld
    Lp = log(tRho .* tVp);
    Ls = log(tRho .* tVs);
    Ld = log(tRho);
    % ���Իع�
    lsCoff = polyfit(Lp, Ls, 1);
    ldCoff = polyfit(Lp, Ld, 1);
end