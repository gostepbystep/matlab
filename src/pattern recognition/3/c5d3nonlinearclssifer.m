clear all;
close all;

N=200;
for i=1:N
    x1(1,i)=-2+0.8*randn(1);
    x1(2,i)=-2+0.9*randn(1);
    x1(3,i)=-2+0.7*randn(1);
end;

for i=1:N
    x2(1,i)= 2+0.9*randn(1);
    x2(2,i)=-2+0.9*randn(1);
    x2(3,i)=-2+0.8*randn(1);
end;

for i=1:N
    x3(1,i)=-2+0.9*randn(1);
    x3(2,i)= 2+0.8*randn(1);
    x3(3,i)=-2+0.7*randn(1);
end;

for i=1:N
    x4(1,i)=-2+0.7*randn(1);
    x4(2,i)=-2+0.9*randn(1);
    x4(3,i)= 2+0.8*randn(1);
end;

for i=1:N
    x5(1,i)= 2+1.0*randn(1);
    x5(2,i)= 2+0.9*randn(1);
    x5(3,i)= 2+0.9*randn(1);
end;

plot3(x1(1,:),x1(2,:),x1(3,:),'*',x2(1,:),x2(2,:),x2(3,:),'o',x3(1,:),x3(2,:),x2(3,:),'x',x4(1,:),x4(2,:),x4(3,:),'d',x5(1,:),x5(2,:),x5(3,:),'+');
grid on;
axis equal;
axis([-5 5 -5 5 -5 5]);

one_vector = ones(N, 1);
training_label_vector = [one_vector; 2*one_vector; 3*one_vector; 4*one_vector; 5*one_vector];
training_instance_matrix  = [x1, x2, x3, x4, x5]';
model = libsvmtrain(training_label_vector, training_instance_matrix);

M=50;
x11=linspace(-5,5,M);
x12=linspace(-5,5,M);
x13=linspace(-5,5,M);
[x11,x12,x13]=meshgrid(x11,x12,x13);

NM = M*M*M;
label = ones(NM, 1);
val = [reshape(x11, NM,1), reshape(x12, NM,1), reshape(x13, NM,1)];
[predict_label, accuracy, dec_values] = libsvmpredict(label, val, model);

result = cell(5, 1);

for i = 1 : NM
    switch( predict_label(i) )
        case 1
            result{1} = [result{1}, val(i, :)'];
        case 2
            result{2} = [result{2}, val(i, :)'];
        case 3
            result{3} = [result{3}, val(i, :)'];
        case 4
            result{4} = [result{4}, val(i, :)'];
        case 5
            result{5} = [result{5}, val(i, :)'];
    end
end

% figure;
% type = ['*', 'o', 'x', 'd', '+'];
% color = ['ro', 'go', 'bo', 'yo', 'mo'];
% for i = 1 : 5
%     hold on;
%     plot3(result{i}(1,:),result{i}(2, :), result{i}(3,:),  color(i));
% end
figure;
plot3(result{1}(1,:),result{1}(2,:),result{1}(3,:),'*',...
    result{2}(1,:),result{2}(2, :),result{2}(3,:),'o',...
    result{3}(1,:),result{3}(2,:),result{3}(3,:),'x',...
    result{4}(1,:),result{4}(2,:),result{4}(3,:),'d',...
    result{5}(1,:),result{5}(2,:),result{5}(3,:),'+');
grid on;
axis equal;
axis([-5 5 -5 5 -5 5]);

