clear all;
close all;

N1=440;
for i=1:N1
    x1(1,i)=-2+0.9*randn(1);         % 1类440个训练样本,2维正态分布
    x1(2,i)= 2+0.7*randn(1);
    x1(3,i)= 1;
end;

N2=400;
for i=1:N2
    x2(1,i)= 2+0.9*randn(1);         % 2类400个训练样本,2维正态分布
    x2(2,i)=-2+0.7*randn(1);
    x2(3,i)= 1;
end;

w(1)=rand(1);                          % 感知机算法
w(2)=rand(1);
w(3)=rand(1);
p=0.001;
for j=1:1000
    k=0;
    n(j)=j;
    for i=1:N1
        xe=x1(:,i);
        if(w*xe<0)
            w=w+p*xe';
            k=k+1;
        end;
    end;
    for i=1:N2
        xe=x2(:,i);
        if(w*xe>0)
            w=w-p*xe';
            k=k+1;
        end;
    end;
    en(j)=k;
end;
subplot(2,2,1);
plot(n,en);
t1=-5:1:5;
t2=(-w(1)*t1-w(3))/w(2);
subplot(2,2,2);
plot(x1(1,:),x1(2,:),'*',x2(1,:),x2(2,:),'o',t1,t2,'r');
axis([-5 5 -5 5]);

for i=1:N1                             % 最小二乘法
    x(1,i)=x1(1,i);
    x(2,i)=x1(2,i);
    x(3,i)=x1(3,i);
    y(i)=1;
end;
for i=(N1+1):(N1+N2)
    x(1,i)=x2(1,(i-N1));
    x(2,i)=x2(2,(i-N1));
    x(3,i)=x2(3,(i-N1));
    y(i)=-1;
end;
w=inv(x*x')*x*y';
s1=-5:1:5;
s2=(-w(1)*t1-w(3))/w(2);

for i=1:N1
    y(i)=N2/(N1+N2);
end;
for i=(N1+1):(N1+N2)
    y(i)=-N1/(N1+N2);
end;
w=inv(x*x')*x*y';
s3=-5:1:5;
s4=(-w(1)*t1-w(3))/w(2);

subplot(2,2,3);
plot(x1(1,:),x1(2,:),'*',x2(1,:),x2(2,:),'o',s1,s2,'g',s3,s4,'b');
axis([-5 5 -5 5]);

subplot(2,2,4);                        % 感知机最小二乘法比较
plot(x1(1,:),x1(2,:),'*',x2(1,:),x2(2,:),'o',t1,t2,'r',s1,s2,'g',s3,s4,'b');
axis([-5 5 -5 5]);
