close all;
dy = 1 : 80;

synthData = zeros(80, 5);

load ricker.txt;
wavelet= ricker;

Wmatrix = convmtx(wavelet, 80);
W = Wmatrix(1:80,:);clear Wmatrix  

for i = 1 : wellNum
    lzyWelllog = profileWelllog(:, :, wellCrossIds(i)-firstCdp+1)';
    waveImp = lzyWelllog(:, 2) .* lzyWelllog(:, 4);
    waveRef = Reflection(waveImp);                                  % ���㷴��ϵ��
    synthData(:, i) = W * waveRef;
end

figure;
postSeisData = -postSeisData;
for i = 1 : wellNum
    subplot(1,wellNum,i);
    plot( synthData(:, i),  dy, 'b-.','LineWidth',2);
    hold on;
    plot( postSeisData(:, i),  dy, 'r','LineWidth',2);
    
    legend('�ϳɼ�¼','�����¼');
end

profileSeiseData = stpCalcPostStack(preFileName, outInIds, outCrossIds);
    
figure; imagesc(1 : traceNum, 1 : 80, profileSeiseData); title('��������¼'); colorbar; 
    