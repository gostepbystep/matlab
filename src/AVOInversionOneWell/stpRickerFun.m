function [f, g] = stpRickerFun(x)
    f = stpRickerFunValue(x);
    g = mb_numDiff(@stpRickerFunValue,x);
end

function [f] = stpRickerFunValue(x)

    global global_d global_sampNum global_waveRef threshold;
    
    [~, index] = max(x);
    wMatrix = convmtx(x, global_sampNum);                         % 使用卷积生成矩阵, 生成后矩阵大小是 
                                                                % (length(ricker)+sampNum-1)*sampNum
    wMatrix = wMatrix(index : index+global_sampNum-1, :);              % 截取需要的部分，大小是sampNum*sampNum

    synthSeis = wMatrix * global_waveRef;                               % 合成了一个子波（这里实际上是子波和反射系数做卷积）
    
    % 计算出该
    d = synthSeis - global_d;
    
    sum = 0;
    n = length(x);
    
%      for i = 1 : n
%         r = abs( d(i, 1) );
%         if (r>=0 && r<=threshold)
%             sum = sum + r*r/(2*threshold);
%         else
%             sum = sum + (r - threshold/2);
%         end
%         sum = sum + r;
%      end
%     
%      f = sum;

    f = d'*d;%norm(d, 1);

%     temp = -corrcoef(synthSeis, global_d);
%     f = temp(1, 2);
end
