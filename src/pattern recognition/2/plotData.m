function plotData( data, wn, dim)
%% ����w�Ľ��ͼ��
    type = ['*', 'b'; 'o', 'm'];
    [~, n] = size(wn);
    
    if dim == 3
        for i = 1 : 2
            curData = data{i};
            plot3(curData(1, :), curData(2, :), curData(3, :), type(i, 1), 'LineWidth', 1,...
                        'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
            hold on;
        end

        % ������
        x = -5 : 0.1 : 5;
        y = -5 : 0.1 : 5;
        [X, Y] = meshgrid(x, y);
        
        for i = 1 : n
            w = wn(:, i);
            Z = (-w(4) - w(1)*X - w(2)*Y) / w(3);
            hold on;
            surf(X, Y, Z);
        end
        
        axis([-5 5 -5 5 -5 5]);
    else
       %% ��ά�������
        for i = 1 : 2
            curData = data{i};
            plot(curData(1, :), curData(2, :), type(i, 1), 'LineWidth', 1,...
                         'MarkerEdgeColor', type(i, 2), 'MarkerSize',6);
            hold on;
        end
        % �ֽ���
        x = -5 : 0.1 : 5;
        
        % ���Ƶ������� Ȩ��w�ı仯���
        startColor = [0.6, 1, 0.2];
        endColor = [1, 0.2, 0.3];
        
        for i = 1 : n
            w = wn(:, i);
            y = ( -w(3) - w(1)*x ) / w(2);
            
            if n == 1
                alpha = 1;
            else
                alpha = (i-1)/(n-1);
            end
            
            color = (1-alpha) * startColor + alpha * endColor;
            hold on;
            plot(x, y, 'Color', color, 'LineWidth', 1.3);
        end
        axis([-5 5 -5 5]);
    end
    
end

