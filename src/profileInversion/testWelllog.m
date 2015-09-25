close all;
% ��������Ϊ�˻�����ھ����������
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
    fprintf('\t���ڷ��ݵ�%d��...\n', i);
    welllog = profileWelllog(:, :, i)'; 

    % ��7.1���� ���������G���󣬼���d = Gx��������
    % ע�⣬���������һ��������Ҫ
    [G, d, x, lsCoff, ldCoff] = stpCalcInitModel(welllog, superTrData(:, (i-1)*superTrNum+1 : i*superTrNum-1 ), angleTrNum, superTrNum-1, offsetMin, offsetMax, dt);
% 
%     f = 0.9;    [b, a] = butter(10, f, 'low');
%     d  = filtfilt(b, a, d); 
% %     
    % ��7.2���裬������������
    [Cgeo, F, matrixB, Cphysgeo, invCphysgeo, Cd, invCd, mPhys, mGeo, lsCoff, ldCoff] = stpBayesParam(welllog, x, d, lsCoff, ldCoff);

    % ��7.3���裬����
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
  
  