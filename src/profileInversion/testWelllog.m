close all;
% 本程序是为了绘制五口井的曲线情况
dy = 1 : 80;
type = {'Depth';'Vp';'Vs';'Rho';'Por';'Sw';'Sh'};

% wellNum = 7;
% index = [100,200,300,400,500];
% wellNum = 4;

inverWelllog = zeros(wellNum, 3, sampNum, propertyNum);
% 



  for j = 1 : wellNum
%     i = index(j);
    i = wellCrossIds(j)-firstCdp+1;
    fprintf('\t正在反演第%d道...\n', i);
    welllog = profileWelllog(:, :, i)'; 

    % 第7.1步骤 计算剖面的G矩阵，计算d = Gx这三部分
    % 注意，超道集最后一个道集不要
    [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
% 
%     f = 0.9;    [b, a] = butter(10, f, 'low');
%     d  = filtfilt(b, a, d); 
% %     
    % 第7.2步骤，计算其他矩阵
    [Cgeo, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, mPhys, mGeo, lsCoff, ldCoff] = stpBayesParam(welllog, x, d, lsCoff, ldCoff);

    % 第7.3步骤，反演
    inverWelllog(j, :, :, :) = stpCalcIterate(welllog, mGeo, mPhys, F, matrixB, ...
        Cgeo, invCd, Cphysgeo, G, d, lsCoff, ldCoff, 1);
    
%     inverWelllog(j, :, :, :) = stpInversionFunc(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), ...
%             angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
    colors = ['g';  'r'; 'b'];

  end

  for i = 2 : propertyNum
        figure;
        for j = 1 : wellNum
            subplot(1,wellNum,j);
            
            plot( reshape(inverWelllog(j, 2, :, i), 80, 1), dy, 'g','LineWidth',2); 
            hold on;
            plot( reshape(inverWelllog(j, 3, :, i), 80, 1), dy, 'r','LineWidth',2);
            hold on;
            plot( reshape(inverWelllog(j, 1, :, i), 80, 1), dy, 'b-.','LineWidth',2);
            
            set(gca, 'ydir', 'reverse'); 
            legend('init value','calculate', 'real value');
            title(['property: ',type{i}]);
        end
  end
  
  