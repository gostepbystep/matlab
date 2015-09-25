 load data2
 close all;
theta = 0.1;

% Z = [S(:, 2), S(:, 1)];
% S = Z;
[dmodel, perf] =dacefit(S, Y, @regpoly0, @corrlin, theta);
    
m = 80;
n = 601;

X = gridsamp([1 1; 601 80], [n m]);
[YX MSE] = predictor(X, dmodel);

X1 = reshape(X(:,1),m, n); X2 = reshape(X(:,2), m, n);
YX = reshape(YX, size(X1));

figure(1);
mesh(X1, X2, YX);
hold on;
plot3(S(:,1),S(:,2),Y, '.k', 'MarkerSize',10);

TX = 1 : 1 : n;
profileDepth = 1 : 1 : m;
figure;
subplot(3, 1, 1);
imagesc(TX, profileDepth, YX); colorbar; 
xlabel('CDP', 'FontSize', 14); ylabel('{\it t}/ms', 'FontSize', 14);    
ylabel(colorbar, '{\it Vp}/(m{\cdot}s^-^1)', 'FontSize', 14);   
hold off;
