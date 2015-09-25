function [wellLog] = stp8CalcWellLog(fileName, targetDep, distInv)
% 这是一个计算测井曲线的函数
%
% 输出
% wellLog       输出的测井曲线，当前是一个3列的矩阵，[深度，vp(m/s)，vs(m/s)，密度]
%
% 输入
% fileName      segy文件
% targetDep     目的层深度
% distInv       采样间隔，上下各扩张多少米
% timeInv       采样时间，每隔多少毫秒输出一次
%
% 范例
% stpCalcWellLog('E:\苏里格\SuligeInversion\SU59-13-49A - 副本.TXT', 3514, 200, 2);
%
% 读取文件的数据格式
% LOGEXPRESSTOP_TEXT_FORMAT
% WELLNAME  = SU59-13-49A
% STDEP     =     461.1250
% ENDEP     =    3694.7500
% RLEV      =       0.1250
% CURVENAME = AC, AMOD, C1, C2, C3, C4, C5, C6, CAL, CNL, DAZ, DEN, DEV, DREC, GAWA, GR, GRFC, P12, PERM, PGAS, POR, PORA, PORD, PORF, PORH, PORL, PORN, PORT, PORW, PWAT, PWIR, QC, RSFL, RT, RTB, RXO, SH, SP, SPA, SW, SWIR, UU, VV, WW, XX, YY, ZZ
% #DEPTH            AC        AMOD          C1          C2          C3          C4          C5          C6         CAL         CNL         DAZ         DEN         DEV        DREC        GAWA          GR        GRFC         P12        PERM        PGAS         POR        PORA        PORD        PORF        PORH        PORL        PORN        PORT        PORW        PWAT        PWIR          QC        RSFL          RT         RTB         RXO          SH          SP         SPA          SW        SWIR          UU          VV          WW          XX          YY          ZZ

    % 打开文件
    fin = fopen(fileName,'r');

    % 读取第2-地5行的数据
    baseInfo = textscan(fin, '%s=%s', 4, 'headerlines', 1);
    baseInfo = baseInfo{1,2};

    % 输出文件信息
    wellName = char(baseInfo(1,1));
    startDep = str2double(baseInfo(2,1));
    endDep = str2double(baseInfo(3, 1));
    dz = str2double(baseInfo(4, 1));
    % 读取基本数据
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
    

    fprintf('正在计算井 %s 的测井曲线...(%.3f-%.3f, dz=%.3f)\n', wellName, startDep, endDep, dz);

    %%
    % 一共有48列
    formatString = repmat(' %f',1,length(curveName)+1);
    data = textscan(fin, formatString, 'headerlines', 7);
    % 关闭文件
    fclose(fin);
    
    depth = data{1, 1};                 % 第一列
    ac = data{1, acIndex};
    den = data{1, denIndex};
    por = data{1, porIndex};
    sw = data{1, swIndex};
    sh = data{1, shIndex};
    
    %%
    % 使用二分法函数找出目的层位置, 此处depth需要转置
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
  
    % 计算测井数据
    interval = 10;
    wellLog = zeros((endPos-startPos)/interval-1, 7);
    index = 0;
    
    for i = startPos : endPos
        if mod(i, interval) == 0
            index = index + 1;
            
            if ac(i, 1) > 160       % 表示 微妙/m
                ac(i, 1) = 1000000 / ac(i, 1);
            else                    % 表示 微妙/英尺
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