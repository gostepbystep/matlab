%bayesian classification
close all;
clear ;
N1=440;
x1(1,:)=-1.7+0.9*randn(1,N1);
x1(2,:)= 1.6+0.7*randn(1,N1);
x1(3,:)=-1.5+0.8*randn(1,N1);
plot3(x1(1,:),x1(2,:),x1(3,:),'ko','linewidth',2,'markeredgecolor','y');
hold on
N2=400;
x2(1,:)= 1.3+1.2*randn(1,N2);
x2(2,:)=-1.5+1.3*randn(1,N2);
x2(3,:)= 1.4+1.1*randn(1,N2);
plot3(x2(1,:),x2(2,:),x2(3,:),'ko','linewidth',2,'markeredgecolor','r');
hold on
P1=N1/(N1+N2)
P2=N2/(N1+N2)
E1=mean(x1,2)
E2=mean(x2,2)
Covariance1=cov(x1')
Covariance2=cov(x2')
invCovariance1=inv(Covariance1)
invCovariance2=inv(Covariance2)
M=50;
x11=linspace(-5,5,M);
x12=linspace(-5,5,M);
x13=linspace(-5,5,M);

val = zeros(M, M, M);

for i=1:M
    for j=1:M
        minz = inf;
        index = -1;
        
        for k=1:M
            x=[x11(i);x12(j);x13(k)];
            val1_temp=-0.5*(x-E1)'*invCovariance1*(x-E1)+log(P1)-log(2*pi)-0.5*log(det(Covariance1));
            val2_temp=-0.5*(x-E2)'*invCovariance2*(x-E2)+log(P2)-log(2*pi)-0.5*log(det(Covariance2));
            error = norm(val1_temp-val2_temp, 1);
            
            val(j, i, k) = val1_temp-val2_temp;
            
        end
        
    end
end


[x11,x12,x13]=meshgrid(x11,x12,x13);
axis equal;
h = patch( isosurface(x11,x12,x13,val,0)); 
isonormals(x11,x12,x13,val,h)              
set(h,'FaceColor','g','EdgeColor','none');
xlabel('x');ylabel('y');zlabel('z'); 
alpha(1)   
grid on; view([1,1,1]); axis equal; camlight; lighting gouraud