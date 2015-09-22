function [wellLog] = stpCalcWelllog(fileName, targetDep, distInv, timeInv)
% ����һ������⾮���ߵĺ���
%
% ���
% wellLog       ����Ĳ⾮���ߣ���ǰ��һ��7�еľ���[��ȣ�vp(m/s)��vs(m/s)���ܶ�, por, sw, sh]
%
% ����
% fileName      segy�ļ�
% targetDep     Ŀ�Ĳ����
% distInv       ������������¸����Ŷ�����
% timeInv       ����ʱ�䣬ÿ�����ٺ������һ��
%
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
    

    fprintf('\t���ڼ��㾮 %s �Ĳ⾮����...(%.3f-%.3f, dz=%.3f)\n', wellName, startDep, endDep, dz);

    %%
    % һ����48��
    formatString = repmat(' %f', 1, length(curveName));
    data = textscan(fin, formatString);
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
        
        if ac(i, 1) > 140       % ��ʾ ΢��/m
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
            wellLog = [wellLog; [depth(i,1), vp, vs, rho, por(i,1)/100, sw(i,1)/100, sh(i,1)/100]];    % �˴��ٶȻ����� m/s
            
            sumVel = 0.0;
            sumDen = 0.0;
            interval = 0;
        end
    end
    
    % �������Ĵ����Ǵ���welllog���쳣ֵ����
    % ��20-60��λ���ҳ���Сֵ�������ֵ�����������Χ�͸�ֵ
    for i = 2 : 4
        
        [sampNum, ~] = size(wellLog(:, i));
        center = floor(sampNum / 2);
        maxValue = max(wellLog(center-25:center+25, i));
        minValue = min(wellLog(center-25:center+25, i));
        
        wellLog( wellLog(:, i) > maxValue, i) = maxValue;
        wellLog( wellLog(:, i) < minValue, i) = minValue;
    end
    
    
end