function [wellLog] = stp1CalcWellLog(fileName, targetDep, distInv, timeInv)
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
    ac = data{1, acIndex};              % 第二列
    den = data{1, denIndex};            % 第13列
    por = data{1, porIndex};
    sw = data{1, swIndex};
    sh = data{1, shIndex};
    [depthNum, ~] = size(den);

    %%
    % 使用二分法函数找出目的层位置, 此处depth需要转置
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
    % 计算测井数据
    wellLog = zeros(0, 7);
    sumVel = 0.0;
    sumDen = 0.0;
    interval = 0;
    dz  = dz * 2;
    dt = 0.0;
    
    for i = startPos : endPos
        %ac(i, 1) = 1000 / ac(i, 1);                         % 微秒/米 转换为 m/毫秒 (1英尺(ft)=0.3048米(m) )
        
        if ac(i, 1) > 160       % 表示 微妙/m
            ac(i, 1) = 1000 / ac(i, 1);
        else                    % 表示 微妙/英尺
            ac(i, 1) = 1000 / ac(i, 1) * 0.3048;
        end
    
        dt = dt + dz / ac(i, 1);                            % 计算该层的dt

        sumVel = sumVel + ac(i, 1);
        sumDen = sumDen + den(i, 1);
        interval = interval + 1;

        vp = 1000*sumVel/interval;
        vs = (vp - 1360)/1.16; % vs = vp / 1.73;
        rho = sumDen/interval;
        
        % 如果到了采样时间2毫秒时
        if(dt > timeInv)
            dt = 0.0;
            wellLog = [wellLog; [depth(i,1), vp, vs, rho, por(i,1), sw(i,1), sh(i,1)]];    % 此处速度换成了 m/s
            
            sumVel = 0.0;
            sumDen = 0.0;
            interval = 0;
        end
    end
end