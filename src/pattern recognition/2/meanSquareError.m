function [w, ww] = meanSquareError( data, nSample, dim)
%% mse�㷨 ��С�� ||y - w'x||
%% ����
% data ѵ������
% nSample ѵ���ĸ�������һ��������ÿ����ĸ�����
% dim ���������ĸ���
%
%% ���
% w ���Է����� w'x = y;  (y ֵΪ1����-1)
% ww ��Ȩ�صģ���y ֵΪ n1/n, -n2/n��
    
    %% ��С��������
    n1 = nSample(1);
    n2 = nSample(2);
    n = n1 + n2;
    
    x = zeros(dim+1, n);
    y = zeros(n, 1);
    
    x(:, 1 : n1) = data{1, 1};
    x(:, n1+1 : n) = data{1, 2};
    
    %% û��Ȩ�ص����
    y(1:n1, 1) = 1;
    y(n1+1 : n) = -1;
    
    % ��С���˹�ʽ��α��
    w = inv(x * x') * x * y;
    
    %% ��Ȩ�ص����
    y(1:n1, 1) = n2 / n;
    y(n1+1 : n) = -n1 / n;
    
    % ��С���˹�ʽ��α��
    ww = inv(x * x') * x * y;
  
end

