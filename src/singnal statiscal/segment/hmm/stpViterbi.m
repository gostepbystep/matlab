function [ maxProb, bestPath ] = stpViterbi(hmmModel, observe)
%% hmm viterbi 算法的实现
    % 观察值的数量
    obNum = length(observe);

    stateNum = hmmModel.stateNum;
    probStart = hmmModel.probStart;
    probEmit = hmmModel.probEmit;
    probTrans = hmmModel.probTrans;
    
    %% 初始化
    weight = zeros(obNum, stateNum);
    path = weight;
    
    for i = 1 : stateNum
        weight(1, i) = probStart(i) + probEmit{i}(observe(1));
    end
    
    %% 迭代
    for k = 2 : obNum
        for i = 1 : stateNum
           %% 求weight(k, i)
            maxWeight = -Inf;
            maxIndex = -1;
            
            for j = 1 : stateNum
                temp = weight(k-1, j) + probTrans(j, i);
                if(maxWeight < temp)
                    maxWeight = temp;
                    maxIndex = j;
                end
            end
            
            weight(k, i) = maxWeight + probEmit{i}(observe(k));
            path(k, i) = maxIndex;
        end
        
    end
    
    %% 终止
    bestPath = zeros(1, obNum);
    
    if( weight(obNum, 3) > weight(obNum, 4) ) 
        maxProb = weight(obNum, 3);
        bestPath(obNum) = 3;
    else
        maxProb = weight(obNum, 4);
        bestPath(obNum) = 4;    
    end
    
    i = obNum - 1;
    while i >= 1
        bestPath(i) = path(i+1, bestPath(i+1));
         i = i - 1;
    end
    
    maxProb = exp(maxProb);
end

