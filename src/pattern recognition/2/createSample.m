function [data] = createSample(nSample, dim, coeff)
%% ����ѵ�����ϵĺ���
%% ����
% nSample ѵ���ĸ�������һ��������ÿ����ĸ�����
% dim ���������ĸ���
% coeff ������ѵ����ϵ�ϵ������һ��cell���͵�
%
%% ���
% ѵ�����ݼ��ϣ�һ��cell����

    [~, nGroup] = size(coeff);                                                       % the number of groups
    data = cell(1, nGroup);
    for i = 1 : nGroup
        curData = zeros(dim+1, nSample(i));                                            % create sample datas for data{i}
        curCoeff = coeff{i};

        for j = 1 : dim
            curData(j, :) = curCoeff(j, 1) + curCoeff(j, 2) * randn(1, nSample(i));  % the data distributed normally
        end
        curData(dim+1, :) = 1;
        
        data{i} = curData;
    end
end

