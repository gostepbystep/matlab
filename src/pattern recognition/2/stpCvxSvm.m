function [ out, cvx_optval] = stpCvxSvm(data, nSample, dim, type)
%% svm ���Ż���⣬ʹ��cvx������
% min ||w|| s.t. y .* (w' * x) >= 1 (x ����������)
%
%% ����
% data ѵ������
% nSample ѵ���ĸ�������һ��������ÿ����ĸ�����
% dim ���������ĸ���
% type  ��ʾsvm���ͣ����Ϊ1��ʾѵ������ȫ�ɷ֣����򲻿ɷ�
%
%% ���
% out ���Է����� out'x = y;  (y ֵΪ1����-1)
% cvx_optval cvx������

    %% ��ʼ������
    n1 = nSample(1);
    n2 = nSample(2);
    n = n1 + n2;
    
    x = zeros(dim+1, n);
    y = zeros(n, 1);
    
    x(:, 1 : n1) = data{1, 1};
    x(:, n1+1 : n) = data{1, 2};
    
    y(1:n1, 1) = 1;
    y(n1+1 : n) = -1;
    
    %% ���Ĵ��룬����cvx�����䣬�Ż���QP����
    if type == 1
        cvx_begin
        variable w(dim+1, 1);
        
        minimize( norm(w, 2));
        subject to
            y .* (x' * w) >= 1;
        cvx_end
    else
        cvx_begin
        variables w(dim+1, 1) rho(n);
        
        minimize( norm(w, 2) + 1 * sum(rho) );
        subject to
            y .* (x' * w) >= 1 - rho;
            rho >= 0;
        cvx_end
    end
    
    
    out = w;
end

