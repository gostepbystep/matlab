% close all;

x = R; G = GMatrix; d = SeismicAngleTraceVector;  

dimention = length(x);

f = 0.2;[b,a] = butter(10, f, 'low');
x1 = filtfilt(b, a, x(1:dimention/3));x2 = filtfilt(b, a,x(dimention/3+1:2*dimention/3));x3 = filtfilt(b, a, x(2*dimention/3+1:dimention));
x0=[x1;x2;x3];  % 初始化 X
x_initial = R;

iters = [50];

path = fileparts( mfilename('fullpath') );
picPath = [path, '\\对比图\\实际数据\\'];

createDir(picPath);

th = max(abs(d)) / 100;
global globalA globalB threshold gloabalTheta;
globalA = G;
globalB = d;
threshold = th;
gloabalTheta = 0.4;

xn = R;
x0 = x_initial;
A = G;
B = d;

% save realSesmicData xn x0 A B;

for i = 1 : length(iters)
    iterNum = iters(1, i);
   
    % % [out,state] = BFGS(@stpBFGSObj,x_initial, iterNum, 1000, false);
    for j = 1 : 1
        if j == 1
             type = 'bfgs';
             [out] = stpMinBFGS('stpCombMixFunc', 'stpCombMixGFunc', x_initial, iterNum);
        else
            type = '最速下降法';
            [out] = stpMinSDLinearEqual(G, x_initial, d, iterNum, true);
        end
        
        x0 = out;
       
        r = out-x_initial;
        r = r' * r

        figure;
        subplot(311);plot(R(1:dimention/3), 'b');                hold on;plot(x0(1:dimention/3),'r');                plot(x_initial(1:dimention/3),'g');                 
        subplot(312);plot(R(dimention/3+1:2*dimention/3), 'b');  hold on;plot(x0(dimention/3+1:2*dimention/3),'r');  plot(x_initial(dimention/3+1:2*dimention/3),'g');   
        subplot(313);plot(R(2*dimention/3+1:dimention), 'b');    hold on;plot(x0(2*dimention/3+1:dimention),'r');    plot(x_initial(2*dimention/3+1:dimention),'g');     
        legend('真实值','估计值','初始值');
        subtitle(3, sprintf('对数图-迭代%d次-方法%s', iterNum, type));

        str = sprintf('%s%d-Log-%s.jpg',picPath, iterNum, type);
        saveas(gcf, str);

        % 代表计算后的结果
        Lp=out(1:dimention/3);
        Ls = LsCoff(1) * Lp + LsCoff(2) + out(dimention/3+1:2*dimention/3);
        Ld = LdCoff(1) * Lp + LdCoff(2) + out(2*dimention/3+1:dimention);

        estVp = exp(Lp-Ld);
        estVs = exp(Ls-Ld);
        estrho = exp(Ld);

        % 初始后的结果
        Lp=x_initial(1:dimention/3);
        Ls = LsCoff(1) * Lp + LsCoff(2) + x_initial(dimention/3+1:2*dimention/3);
        Ld = LdCoff(1) * Lp + LdCoff(2) + x_initial(2*dimention/3+1:dimention);

        initEstVp = exp(Lp-Ld);
        initEstVs = exp(Ls-Ld);
        initEstrho = exp(Ld);

        % 绘图
        figure;subplot(1,3,1);plot(tVp,1:size(estVp),'b');hold on;plot(estVp,1:size(estVp),'r');hold on;plot(initEstVp,1:size(estVp),'g');
        set(gca, 'xlim', [2000 6000]);
        subplot(1,3,2);plot(tVs,1:size(estVp),'b');hold on;plot(estVs,1:size(estVp),'r');hold on;plot(initEstVs,1:size(estVp),'g');
        set(gca, 'xlim', [1000 4000]);
        subplot(1,3,3);plot(tRho,1:size(estVp),'b');hold on;plot(estrho,1:size(estVp),'r');hold on;plot(initEstrho,1:size(estVp),'g');
        set(gca, 'xlim', [1.8 2.8]);
        legend('真实值','估计值','初始值');
         subtitle(3, sprintf('测井曲线图-迭代%d次-方法%s', iterNum, type));
         
        str = sprintf('%s%d-Normal-%s.jpg', picPath, iterNum, type);
        saveas(gcf, str);
        
    end

end
