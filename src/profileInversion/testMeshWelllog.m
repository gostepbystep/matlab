function testMeshWelllog(welllog)
% ��ά��ʽ��������
    close all;
    [propertyNum, sampNum, traceNum] = size(welllog);
    X = gridsamp([1 1; traceNum sampNum  ], [traceNum sampNum]);
    X1 = reshape(X(:,1), sampNum, traceNum);
    X2 = reshape(X(:,2), sampNum, traceNum );
    
    propertyName = {'Depth', 'Vp', 'Vs', 'Rho', 'Por', 'Sw', 'Sh'};
    
    for i = 1 : propertyNum
        figure;
        YX = reshape(welllog(i, :, :), size(X1));
        mesh(X1, X2, YX);
        title(['����', propertyName{i}]);
    end
    
end
