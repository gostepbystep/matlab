function [predict_label] = stpAnnBP(training_label_vector, training_instance_matrix, val, nClass)
%% 人工神经网络的方法
    %% bp 神经网络
    %特征值归一化
    [input, minI, maxI] = premnmx( training_instance_matrix' )  ;

    %构造输出矩阵
    s = length( training_label_vector ) ;
    output = zeros(s , nClass) ;
    for i = 1 : s 
       output( i , training_label_vector( i )  ) = 1 ;
    end

    %创建神经网络
    net = newff( minmax(input) , [20 nClass] , { 'logsig' 'purelin' } , 'traingdx' ) ; 

    %设置训练参数
    % net.trainparam.show = 50 ;
    % net.trainparam.epochs = 500 ;
    % net.trainparam.goal = 0.01 ;
    % net.trainParam.lr = 0.01 ;

    %开始训练
    net = train( net, input , output' ) ;

    %测试数据归一化
    testInput = tramnmx ( val' , minI, maxI ) ;

    %仿真
    Y = sim( net , testInput ) 

    % 完全识别所有像素
    [~, predict_label] = max(Y, [], 1);
end