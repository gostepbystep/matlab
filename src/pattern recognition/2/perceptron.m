function [w, ws, miss] = perceptron( data, nSample, dim, alpha, nStep)
%% ��֪���㷨
%% ����
% data ѵ������
% nSample ѵ���ĸ�������һ��������ÿ����ĸ�����
% dim ���������ĸ���
% alpha ��������
% nStep ��������
%
%% ���
% w ���Է����� w'x = 0;  (x����������)
% ws ��������ws�ı仯���
% miss ���������зִ����ı仯���

    %% ��ʼ��Ȩ������
    w = rand(dim+1, 1);
    ws = zeros(dim+1, nStep);
    miss = zeros(1, nStep);
    
    data1 = data{1, 1};
    data2 = data{1, 2};
    
    %% ��֪���㷨����
    for i = 1 : nStep
        % ����i�ε���
        ws(:, i) = w;                 % �洢��ǰw��ֵ
        missNum = 0;
        
        % ��һ��ִ�ͳ��
        for k = 1 : nSample(1)
            % ������ǰ��ĵ�k��ʵ��
            x = data1(:, k);
            if(w' * x < 0)
                w = w + alpha * x;              % �޸�w�� �ִ���x����x���ڵ�һ�࣬��Ӧ������w'x > 0��
                missNum = missNum + 1;
            end
        end
        
        % �ڶ���ִ�ͳ��
        for k = 1 : nSample(2)
            % ������ǰ��ĵ�k��ʵ��
            x = data2(:, k);
            if(w' * x > 0)
                w = w - alpha * x;
                missNum = missNum + 1;
            end
        end
        
        miss(i) = missNum;
    end
    
end

