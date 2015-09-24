clear all;
close all;

N1=440;
for i=1:N1
    x1(1,i)=-1.7+0.9*randn(1);         % 1类440个训练样本,3维正态分布
    x1(2,i)= 1.6+0.7*randn(1);
    x1(3,i)=-1.5+0.8*randn(1);
end;

N2=400;
for i=1:N2
    x2(1,i)= 1.3+1.2*randn(1);         % 2类400个训练样本,3维正态分布
    x2(2,i)=-1.5+1.3*randn(1);
    x2(3,i)= 1.4+1.1*randn(1);
end;

plot3(x1(1,:),x1(2,:),x1(3,:),'*',x2(1,:),x2(2,:),x2(3,:),'o');
grid on;
axis equal;
axis([-5 5 -5 5 -5 5]);

u1=0;                                    % 1类均值估计
for i=1:N1
    u1=u1+x1(:,i);
end;
u1=u1/N1
e1=0;                                    % 1类协方差矩阵估计
for i=1:N1
    xu1=x1(:,i)-u1;
    e1=e1+xu1*xu1';
end;
e1=e1/(N1-1)

u2=0;                                    % 2类均值估计
for i=1:N2
    u2=u2+x2(:,i);
end;
u2=u2/N2
e2=0;                                    % 2类协方差矩阵估计
for i=1:N2
    xu2=x2(:,i)-u2;
    e2=e2+xu2*xu2';
end;
e2=e2/(N2-1)


