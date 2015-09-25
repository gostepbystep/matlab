function [s] = stpCubicSpline(x, y, u, pp0, ppn)
% 本函数是一个三次样条插值的函数
% 
% 输出
% s             插值结果
%
% 输入   
% x             已知点坐标
% y             已知点坐标对应的函数值
% u             待插值点的坐标
% pp0           首点二阶导
% ppn           尾点二阶导
%
% 说明          本断程序参考 http://www.cnblogs.com/xpvincent/archive/2013/01/26/2878092.html 内容
    
    %% 计算基本信息, 并分配空间
    [~, inNum] = size(x);
    [~, outNum] = size(u);

    h = zeros(1, inNum-1);                  % 步长
    dy = zeros(1, inNum-1);                 % 函数值的差
    m = zeros(1, inNum);                    % 二次微分值
    A = zeros(inNum, inNum);                % 最终矩阵Am = B中的A
    B = zeros(inNum, 1);                    % 最终矩阵Am = B中的B

    a = zeros(1, inNum-1);                  % 三次样条的系数a,b,c,d
    b = zeros(1, inNum-1);
    c = zeros(1, inNum-1);
    d = zeros(1, inNum-1);

    s = zeros(1, outNum);                   % 插值结果

    %% 第一步，计算步长
    for i = 1 : inNum-1
        h(i) = x(i+1) - x(i);
        dy(i) = y(i+1) - y(i);
    end

    %% 构造矩阵，并求m
    % 处理第一行和最后一行
    A(1, 1) = 1;            B(1) = pp0;
    A(inNum, inNum) = 1;    B(inNum) = ppn;

    % 计算中间行
    for i = 2 : inNum-1
        % A 矩阵的三个元素
        A(i, i-1) = h(i-1);
        A(i, i) = 2 * ( h(i-1) + h(i) );
        A(i, i+1) = h(i);
        % B矩阵
        B(i, 1) = 6 * ( dy(i) / h(i) - dy(i-1) / h(i-1) );
    end

    % 计算m
    m = A \ B;

    %% 计算三次样条系数
    for i = 1 : inNum-1
        a(i) = y(i);
        b(i) = dy(i)/h(i) - 0.5*h(i)*m(i) - h(i)/6*( m(i+1) - m(i) );
        c(i) = m(i) / 2;
        d(i) = ( m(i+1) - m(i) ) / (6 * h(i));
    end

    % 计算插值结果
    j = 1;

    for i = 1 : outNum
        ox = u(i);

        % 找到小于 x(j+1) 的第一个位置
        while ( j<inNum-1 &&  ox>x(j+1) )
            j = j + 1;
        end

        dx = ox - x(j);

        % 计算插值点的值
        s(i) = a(j) + b(j)*dx + c(j)*dx*dx + d(j)*dx*dx*dx;
    end

    % 绘图
%     figure;
%     plot(x, y, 'r');    
%     hold on;    
%     plot(u, s, 'g');
%     legend('已知数据', '插值结果');
%     title('三次样条插值');
end