function stpPaintProfile(profile)
% 绘制剖面的函数
% 
% 输入
% profile           剖面， depth, vs, vp, rho, por, sw, sh

    % 绘图
    
    % 载入目的层时间曲线
    load h8;
    meanTime = mean(timeLine);
    f = 0.1;[b,a] = butter(10, f, 'low');
    timeLine  = filtfilt(b, a, timeLine); 
    mintime = min(timeLine)-1-(45+20)*2;
    maxntime = max(timeLine)+(34+20)*2;
    

    %profileDepth = profile{1};    
    
%     profileDep = reshape( profile(1, :, :), m, n);
    [~, m, n] = size(profile);
    profileVp = reshape( profile(2, :, :), m, n);
    profileVs = reshape( profile(3, :, :), m, n);
    profileDen = reshape( profile(4, :, :), m, n);
    profilePor = reshape( profile(5, :, :), m, n);
    profileSw = reshape( profile(6, :, :), m, n); 
    profileClay = reshape( profile(7, :, :), m, n); 
    
    profileVp = fillData(timeLine,profileVp);
    profileVs = fillData(timeLine,profileVs);
    profileDen = fillData(timeLine,profileDen);
    profilePor = fillData(timeLine,profilePor);
    profileSw = fillData(timeLine,profileSw);
    profileClay = fillData(timeLine,profileClay);
    
    [~, m, n] = size(profile);
    
    load goodCmap;
    
    fig = figure(); 
    TX = 1 : 1 : n;
    profileDepth = mintime:2:maxntime;
    
%     profileDepth = meanTime-44  : 1 : meanTime+35;
    
%     index = floor(n / 2);
%     profileDepth = profileDep(index);
    subplot(3, 1, 1); imagesc(TX, profileDepth, profileVp); colorbar; 
    hold on; subplot(3, 1, 1); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '{\it Vp}/(m{\cdot}s^-^1)', 'FontSize', 14);    

    subplot(3, 1, 2); imagesc(TX, profileDepth, profileVs); colorbar;
    hold on; subplot(3, 1, 2); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '{\it Vs}/(m{\cdot}s^-^1)', 'FontSize', 14);    

    subplot(3, 1, 3); imagesc(TX, profileDepth, profileDen); colorbar; 
    hold on; subplot(3, 1, 3); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '{\it{\rho}}/(g{\cdot}cm^-^3)', 'FontSize', 14);  
    
    set(fig,'Colormap', goodCmap);
    
    
%     subplot(4, 1, 4); imagesc(TX, profileDepth, profileDep); colorbar; 
%     xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
%     ylabel(colorbar, '{\it{Depth}}/(m)', 'FontSize', 14);
    %%
    fig = figure; 
    subplot(3, 1, 1); imagesc(TX, profileDepth, profilePor); colorbar; 
    hold on; subplot(3, 1, 1); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '\it{\phi}', 'FontSize', 14);    

    subplot(3, 1, 2); imagesc(TX, profileDepth, profileSw); colorbar; 
    hold on; subplot(3, 1, 2); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '\it{sw}', 'FontSize', 14);    

    subplot(3, 1, 3); imagesc(TX, profileDepth, profileClay); colorbar;
    hold on; subplot(3, 1, 3); plot(TX, timeLine, 'black','LineWidth',1.3);
    xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
    ylabel(colorbar, '\it{clay}', 'FontSize', 14);    
    
    load goodCmap2;
    set(fig,'Colormap', goodCmap2);
end