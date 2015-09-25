function [s] = stpCubicSpline(x, y, u, pp0, ppn)
% ��������һ������������ֵ�ĺ���
% 
% ���
% s             ��ֵ���
%
% ����   
% x             ��֪������
% y             ��֪�������Ӧ�ĺ���ֵ
% u             ����ֵ�������
% pp0           �׵���׵�
% ppn           β����׵�
%
% ˵��          ���ϳ���ο� http://www.cnblogs.com/xpvincent/archive/2013/01/26/2878092.html ����
    
    %% ���������Ϣ, ������ռ�
    [~, inNum] = size(x);
    [~, outNum] = size(u);

    h = zeros(1, inNum-1);                  % ����
    dy = zeros(1, inNum-1);                 % ����ֵ�Ĳ�
    m = zeros(1, inNum);                    % ����΢��ֵ
    A = zeros(inNum, inNum);                % ���վ���Am = B�е�A
    B = zeros(inNum, 1);                    % ���վ���Am = B�е�B

    a = zeros(1, inNum-1);                  % ����������ϵ��a,b,c,d
    b = zeros(1, inNum-1);
    c = zeros(1, inNum-1);
    d = zeros(1, inNum-1);

    s = zeros(1, outNum);                   % ��ֵ���

    %% ��һ�������㲽��
    for i = 1 : inNum-1
        h(i) = x(i+1) - x(i);
        dy(i) = y(i+1) - y(i);
    end

    %% ������󣬲���m
    % �����һ�к����һ��
    A(1, 1) = 1;            B(1) = pp0;
    A(inNum, inNum) = 1;    B(inNum) = ppn;

    % �����м���
    for i = 2 : inNum-1
        % A ���������Ԫ��
        A(i, i-1) = h(i-1);
        A(i, i) = 2 * ( h(i-1) + h(i) );
        A(i, i+1) = h(i);
        % B����
        B(i, 1) = 6 * ( dy(i) / h(i) - dy(i-1) / h(i-1) );
    end

    % ����m
    m = A \ B;

    %% ������������ϵ��
    for i = 1 : inNum-1
        a(i) = y(i);
        b(i) = dy(i)/h(i) - 0.5*h(i)*m(i) - h(i)/6*( m(i+1) - m(i) );
        c(i) = m(i) / 2;
        d(i) = ( m(i+1) - m(i) ) / (6 * h(i));
    end

    % �����ֵ���
    j = 1;

    for i = 1 : outNum
        ox = u(i);

        % �ҵ�С�� x(j+1) �ĵ�һ��λ��
        while ( j<inNum-1 &&  ox>x(j+1) )
            j = j + 1;
        end

        dx = ox - x(j);

        % �����ֵ���ֵ
        s(i) = a(j) + b(j)*dx + c(j)*dx*dx + d(j)*dx*dx*dx;
    end

    % ��ͼ
%     figure;
%     plot(x, y, 'r');    
%     hold on;    
%     plot(u, s, 'g');
%     legend('��֪����', '��ֵ���');
%     title('����������ֵ');
end