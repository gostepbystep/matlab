function [wellLog] = stp8CalcWellLog(fileName, targetDep, distInv)
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
    ac = data{1, acIndex};
    den = data{1, denIndex};
    por = data{1, porIndex};
    sw = data{1, swIndex};
    sh = data{1, shIndex};
    
    %%
    % ʹ�ö��ַ������ҳ�Ŀ�Ĳ�λ��, �˴�depth��Ҫת��
    index = stpIndexOf(depth', targetDep);
    startPos = index - floor(distInv/dz);
    endPos = index + floor(distInv/dz);
    [depthNum, ~] = size(depth);
    if(startPos < 1)   
        startPos = 1;
    end
    if(endPos > depthNum)
        endPos = depthNum;
    end
  
    % ����⾮����
    interval = 10;
    wellLog = zeros((endPos-startPos)/interval-1, 7);
    index = 0;
    
    for i = startPos : endPos
        if mod(i, interval) == 0
            index = index + 1;
            
            if ac(i, 1) > 160       % ��ʾ ΢��/m
                ac(i, 1) = 1000000 / ac(i, 1);
            else                    % ��ʾ ΢��/Ӣ��
                ac(i, 1) = 1000000 / ac(i, 1) * 0.3048;
            end
        
            wellLog(index, 1) = depth(i, 1);
            wellLog(index, 2) = ac(i, 1);
            wellLog(index, 3) = (ac(i, 1) - 1360)/1.16;
            wellLog(index, 4) = den(i, 1);
            wellLog(index, 5) = por(i, 1);
            wellLog(index, 6) = sw(i, 1);
            wellLog(index, 7) = sh(i, 1);
        end
    end
    
    figure;
    subplot(1,2,1);
    plot(wellLog(:,2),wellLog(:,1),'r');
    hold on;plot(wellLog(:,3),wellLog(:,1),'g');
    hold on;plot(wellLog(:,4).*1000,wellLog(:,1),'b');
    set(gca,'ylim',[min(wellLog(:,1)) max(wellLog(:,1))]);
    set(gca,'ydir','reverse'); 
    set(gca,'xlim',[2000 5000]);
    legend('Vp','Vs','Rho');
    
    subplot(1,2,2);
    plot(wellLog(:,5),wellLog(:,1),'g');
    hold on;plot(wellLog(:,6),wellLog(:,1),'r');
    hold on;plot(wellLog(:,7),wellLog(:,1),'b');
    set(gca,'ylim',[min(wellLog(:,1)) max(wellLog(:,1))]);
    set(gca,'ydir','reverse'); 
    set(gca,'xlim',[0 100]);
    legend('Porosity','Water saturation','Clay content');
    
end