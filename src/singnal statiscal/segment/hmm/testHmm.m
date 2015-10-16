%% 测试viterbi算法

% 载入模型
hmmModel = stpReadHmmModel( 'hmm_model.txt' );

% 输入样例
input = {'小明硕士毕业于中国科学院计算所',  ...
    '用来进行学习的材料就是与被识别对象属于同类的有限数量样本', ...
    '每个叶结点则对应从根节点到该叶节点所经历的路径所表示的对象的值',...
    '默认情况下命令窗口已自动在主界面的运行环境中显示',...
    '如正态分布的概率密度函数中用到了相关定积分的知识'};

% 测试
for i = 1 : length(input)
    observe = input{i};
    
    [ maxProb, bestPath ] = stpViterbi(hmmModel, observe);
    
    output = '';
    
    for j = 1 : length(bestPath)
        type = bestPath(j);
        
        if type == 1 || type == 3 || j == length(bestPath) 
            output = [output, observe(j)];
        else
            output = [output, observe(j), '/'];
        end
    end
    
    fprintf('Case %d:\n', i);
    fprintf('\t输入：%s\n', observe);
    fprintf('\t输出：%s\n', output);
%     fprintf('\t概率：%f\n', maxProb);
end
