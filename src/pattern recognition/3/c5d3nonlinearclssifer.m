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
X = [one_vector; 2*one_vector; 3*one_vector; 4*one_vector; 5*one_vector];
Y = [x1; x2; x3; x4; x5]';

C=Inf;
ker='linear';
global p1 p2
p1=3;
p2=1;
[nsv alpha bias] = svc(X,Y,ker,C);





