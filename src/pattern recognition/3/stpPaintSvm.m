function stpPaintSvm(model)
%% 绘制svm的支持向量
    nSample = model.totalSV;
    nClass = model.nr_class;
    nSV = model.nSV;
    theta = 0.1;
    
    m = 100;
    n = 100;
    
    index = 0;
    
    for i = 1 : nClass
        nI = nSV(i);
        
        S = zeros(nI, 2);
        Y = zeros(nI, 1);
        
        for j = 1 : nSV(i)
            S(j, 1) = model.SVs(j+index, 1);
            S(j, 2) = model.SVs(j+index, 2);
            Y(j, 1) = model.SVs(j+index, 3);
        end
%         
%         % 克里金差值
%         [dmodel, perf] =dacefit(S, Y, @regpoly0, @corrlin, theta);
%         
%         X = gridsamp([-5 -5; 5 5], [n m]);
%         [YX MSE] = predictor(X, dmodel);
% 
%         X1 = reshape(X(:,1),m, n); X2 = reshape(X(:,2), m, n);
%         YX = reshape(YX, size(X1));
% 
%         
%         mesh(X1, X2, YX);
%         hold on;
% %         plot3(S(:,1),S(:,2),Y, '.k', 'MarkerSize',10);
% %         hold on;
%         axis([-5 5 -5 5 -5 5]);

        [x11, x12, x13] = meshgrid(x11,x12,x13);
        axis equal;
        h = patch( isosurface(x11, x12, x13, val,0)); 
        isonormals(x11,x12,x13,val,h)              
        set(h,'FaceColor','g','EdgeColor','none');
        xlabel('x');ylabel('y');zlabel('z'); 
        alpha(1)   
        grid on; view([1,1,1]); axis equal; camlight; lighting gouraud
        
        index = index + nI;
    end
end