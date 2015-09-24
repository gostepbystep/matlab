function [wellLog] = stp1CalcWellLog(fileName, targetDep, distInv, timeInv)
% ����һ������⾮���ߵĺ���
%
% ���
% wellLog       ����Ĳ⾮���ߣ���ǰ��һ��3�еľ���[��ȣ�vp(m/s)��vs(m/s)���ܶ�]
%
% ����
% fileName      segy�ļ�
% targetDep     Ŀ�Ĳ����
% distInv       ������������¸����Ŷ�����
% timeInv       ����ʱ�䣬ÿ�����ٺ������һ��
%
% ����
% stpCalcWellLog('E:\�����\SuligeInversion\SU59-13-49A - ����.TXT', 3514, 200, 2);
%
% ��ȡ�ļ������ݸ�ʽ
% LOGEXPRESSTOP_TEXT_FORMAT
% WELLNAME  = SU59-13-49A
% STDEP     =     461.1250
% ENDEP     =    3694.7500
% RLEV      =       0.1250
% CURVENAME = AC, AMOD, C1, C2, C3, C4, C5, C6, CAL, CNL, DAZ, DEN, DEV, DREC, GAWA, GR, GRFC, P12, PERM, PGAS, POR, PORA, PORD, PORF, PORH, PORL, PORN, PORT, PORW, PWAT, PWIR, QC, RSFL, RT, RTB, RXO, SH, SP, SPA, SW, SWIR, UU, VV, WW, XX, YY, ZZ
% #DEPTH            AC        AMOD          C1          C2          C3          C4          C5          C6         CAL         CNL         DAZ         DEN         DEV        DREC        GAWA          GR        GRFC         P12        PERM        PGAS         POR        PORA        PORD        PORF        PORH        PORL        PORN        PORT        PORW        PWAT        PWIR          QC        RSFL          RT         RTB         RXO          SH          SP         SPA          SW        SWIR          UU          VV          WW          XX          YY          ZZ

    % ���ļ�
    fin = fopen(fileName,'r');

    % ��ȡ��2-��5�е�����
    baseInfo = textscan(fin, '%s=%s', 4, 'headerlines', 1);
    baseInfo = baseInfo{1,2};

    % ����ļ���Ϣ
    wellName = char(baseInfo(1,1));
    startDep = str2double(baseInfo(2,1));
    endDep = str2double(baseInfo(3, 1));
    dz = str2double(baseInfo(4, 1));
    % ��ȡ��������
    str = textscan(fin, 'CURVENAME =%[^\n]', 1);
    names = str{1, 1};
    curveName = regexp(names, ',\s+', 'split');
    curveName = curveName{1, 1};
    
    for i = 1 : length(curveName)
        str = curveName{i};
        if(  strcmp( str, 'AC') )
            acIndex = i+1;
        elseif( strcmp(str, 'DEN') )
            denIndex = i+1;
        elseif( strcmp(str, 'POR') )
            porIndex = i+1;
        elseif( strcmp(str, 'SW') )
            swIndex = i+1;
        elseif( strcmp(str, 'SH') )
        	shIndex = i+1;
        end
    end
    

    fprintf('���ڼ��㾮 %s �Ĳ⾮����...(%.3f-%.3f, dz=%.3f)\n', wellName, startDep, endDep, dz);

    %%
    % һ����48��
    formatString = repmat(' %f',1,length(curveName)+1);
    data = textscan(fin, formatString, 'headerlines', 7);
    % �ر��ļ�
    fclose(fin);
    
    depth = data{1, 1};                 % ��һ��
    ac = data{1, acIndex};              % �ڶ���
    den = data{1, denIndex};            % ��13��
    por = data{1, porIndex};
    sw = data{1, swIndex};
    sh = data{1, shIndex};
    [depthNum, ~] = size(den);

    %%
    % ʹ�ö��ַ������ҳ�Ŀ�Ĳ�λ��, �˴�depth��Ҫת��
    index = stpIndexOf(depth', targetDep);
    startPos = index - floor(distInv/dz);
    endPos = index + floor(distInv/dz);
    
    if(startPos < 1)   
        startPos = 1;
    end
    if(endPos > depthNum)
        endPos = depthNum;
    end
    
    %%
    % ����⾮����
    wellLog = zeros(0, 7);
    sumVel = 0.0;
    sumDen = 0.0;
    interval = 0;
    dz  = dz * 2;
    dt = 0.0;
    
    for i = startPos : endPos
        %ac(i, 1) = 1000 / ac(i, 1);                         % ΢��/�� ת��Ϊ m/���� (1Ӣ��(ft)=0.3048��(m) )
        
        if ac(i, 1) > 160       % ��ʾ ΢��/m
            ac(i, 1) = 1000 / ac(i, 1);
        else                    % ��ʾ ΢��/Ӣ��
            ac(i, 1) = 1000 / ac(i, 1) * 0.3048;
        end
    
        dt = dt + dz / ac(i, 1);                            % ����ò��dt

        sumVel = sumVel + ac(i, 1);
        sumDen = sumDen + den(i, 1);
        interval = interval + 1;

        vp = 1000*sumVel/interval;
        vs = (vp - 1360)/1.16; % vs = vp / 1.73;
        rho = sumDen/interval;
        
        % ������˲���ʱ��2����ʱ
        if(dt > timeInv)
            dt = 0.0;
            wellLog = [wellLog; [depth(i,1), vp, vs, rho, por(i,1), sw(i,1), sh(i,1)]];    % �˴��ٶȻ����� m/s
            
            sumVel = 0.0;
            sumDen = 0.0;
            interval = 0;
        end
    end
end