function [predict_label] = stpAnnBP(training_label_vector, training_instance_matrix, val, nClass)
%% �˹�������ķ���
    %% bp ������
    %����ֵ��һ��
    [input, minI, maxI] = premnmx( training_instance_matrix' )  ;

    %�����������
    s = length( training_label_vector ) ;
    output = zeros(s , nClass) ;
    for i = 1 : s 
       output( i , training_label_vector( i )  ) = 1 ;
    end

    %����������
    net = newff( minmax(input) , [20 nClass] , { 'logsig' 'purelin' } , 'traingdx' ) ; 

    %����ѵ������
    % net.trainparam.show = 50 ;
    % net.trainparam.epochs = 500 ;
    % net.trainparam.goal = 0.01 ;
    % net.trainParam.lr = 0.01 ;

    %��ʼѵ��
    net = train( net, input , output' ) ;

    %�������ݹ�һ��
    testInput = tramnmx ( val' , minI, maxI ) ;

    %����
    Y = sim( net , testInput ) 

    % ��ȫʶ����������
    [~, predict_label] = max(Y, [], 1);
end