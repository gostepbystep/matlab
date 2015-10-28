clear all;
close all;

N=2000;
for i=1:N/2
    x1(1,i)=-3.0+randn(1);
    x1(2,i)= 0.0+randn(1);
end;
for i=N/2+1:N
    x1(1,i)=-0.5+randn(1);
    x1(2,i)= 2.0+randn(1);
end;

for i=1:N
    x2(1,i)=-0.0+randn(1);
    x2(2,i)=-2.0+randn(1);
end;

plot(x1(1,:),x1(2,:),'*',x2(1,:),x2(2,:),'o');
