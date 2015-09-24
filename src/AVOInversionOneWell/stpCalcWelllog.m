function [wellLog] = stpCalcWelllog(fileName, targetDep, distInv, timeInv)
% 这是一个计算测井曲线的函数
%
% 输出
% wellLog       输出的测井曲线，当前是一个7列的矩阵，[深度，vp(m/s)，vs(m/s)，密度, por, sw, sh]
%
% 输入
% fileName      segy文件
% targetDep     目的层深度
% distInv       采样间隔，上下各扩张多少米
% timeInv       采样时间，每隔多少毫秒输出一次
%
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
    str = textscan(fin, '%[^\n]', 1, 'headerlines', 2);
    names = str{1, 1};
    curveName = regexp(names, '\s+', 'split');
    curveName = curveName{1, 1};
    curveName = curveName(2 : end);
    
    for i = 1 : length(curveName)
        str = curveName{i};
        if(  strcmp( str, 'AC') )
            acIndex = i;
        elseif( strcmp(str, 'DEN') )
            denIndex = i;
        elseif( strcmp(str, 'POR') )
            porIndex = i;
        elseif( strcmp(str, 'SW') )
            swIndex = i;
        elseif( strcmp(str, 'SH') )
            shIndex = i;
        end
    end
    

    fprintf('\t正在计算井 %s 的测井曲线...(%.3f-%.3f, dz=%.3f)\n', wellName, startDep, endDep, dz);

    %%
    % 一共有48列
    formatString = repmat(' %f', 1, length(curveName));
    data = textscan(fin, formatString);
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
        
        if ac(i, 1) > 140       % 表示 微妙/m
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
            wellLog = [wellLog; [depth(i,1), vp, vs, rho, por(i,1)/100, sw(i,1)/100, sh(i,1)/100]];    % 此处速度换成了 m/s
            
            sumVel = 0.0;
            sumDen = 0.0;
            interval = 0;
        end
    end
    
    % 接下来的代码是处理welllog的异常值问题
    % 从20-60的位置找出最小值，和最大值，如果超出范围就赋值
    for i = 2 : 4
        
        [sampNum, ~] = size(wellLog(:, i));
        center = floor(sampNum / 2);
        maxValue = max(wellLog(center-25:center+25, i));
        minValue = min(wellLog(center-25:center+25, i));
        
        wellLog( wellLog(:, i) > maxValue, i) = maxValue;
        wellLog( wellLog(:, i) < minValue, i) = minValue;
    end
    
    
end