clear all;
close all;

N=1000;
for i=1:N/2
    x1(1,i)=-3.0+randn(1);
    x1(2,i)= 3.0+randn(1);
end;
for i=N/2+1:N
    x1(1,i)=3+randn(1);
    x1(2,i)= -3+randn(1);
end;

for i=1:N
    x2(1,i)=0+randn(1);
    x2(2,i)=0+randn(1);
end;

% x1 = [];
% x2 = [];
% 
% [ label, data ] = stpReadSvmData( 'fourclass_scale.txt');
% for i = 1 : length(label)
%     switch (label(i) )
%         case 1
%             x1 = [x1, data(i, :)'];
%         case -1
%             x2 = [x2, data(i, :)'];
%     end
% end

plot(x1(1,:),x1(2,:),'*',x2(1,:),x2(2,:),'o');
axis([-5 5 -5 5]);

% one_vector = ones(N, 1);
n1 = length(x1);
n2 = length(x2);
training_label_vector = [ones(n1, 1); 2*ones(n2, 1)];
training_instance_matrix  = [x1, x2]';
model = libsvmtrain(training_label_vector, training_instance_matrix, '-c 2 -t 2');

M=500;
x11=linspace(-5,5,M);
x12=linspace(-5,5,M);
[x11,x12]=meshgrid(x11,x12);

NM = M*M;
label = ones(NM, 1);
val = [reshape(x11, NM,1), reshape(x12, NM,1)];
[predict_label, accuracy, dec_values] = libsvmpredict(label, val, model);
result = cell(2, 1);

% for i = 1 : NM
%     switch( predict_label(i) )
%         case 1
%             result{1} = [result{1}, val(i, :)'];
%         case 2
%             result{2} = [result{2}, val(i, :)'];
%     end
% end

figure;
stpPaint2DResult(training_label_vector, training_instance_matrix, predict_label, M, M, -5, 5, -5, 5)

% image = 
% 
% figure;
% plot(result{1}(1,:),result{1}(2,:),'*',...
%     result{2}(1,:),result{2}(2, :),'o');