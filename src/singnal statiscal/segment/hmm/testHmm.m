%% ����viterbi�㷨

% ����ģ��
hmmModel = stpReadHmmModel( 'hmm_model.txt' );

% ��������
input = {'С��˶ʿ��ҵ���й���ѧԺ������',  ...
    '��������ѧϰ�Ĳ��Ͼ����뱻ʶ���������ͬ���������������', ...
    'ÿ��Ҷ������Ӧ�Ӹ��ڵ㵽��Ҷ�ڵ���������·������ʾ�Ķ����ֵ',...
    'Ĭ���������������Զ�������������л�������ʾ',...
    '����̬�ֲ��ĸ����ܶȺ������õ�����ض����ֵ�֪ʶ'};

% ����
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
    fprintf('\t���룺%s\n', observe);
    fprintf('\t�����%s\n', output);
%     fprintf('\t���ʣ�%f\n', maxProb);
end