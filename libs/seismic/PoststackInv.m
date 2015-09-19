function [x_new]=PoststackInv(dtrue,W,x_initial,itermax)

    G=RefRespecttoZ(x_initial);
    R=Reflection(x_initial);
    e=W*R-dtrue;  %��ʼ�����
    
    g=2*W'*G'*e;  %�ݶȷ���
    dr=-g;%��ʼ����������
    
    x_new=x_initial;
    iter=1;
    RMSE(iter)=sqrt(mse(e));
    
    while iter <= itermax 
        alpha_new =-(e'*(W'*G'*dr))/((W'*G'*dr)'*(W'*G'*dr));%�µ���������2015.0326
        x_new = x_new + alpha_new *dr; 
        
        G=RefRespecttoZ(x_new);
        R=Reflection(x_new);
        e = W*R-dtrue; %������
        g_new=2*W'*G'*e;  %�ݶȷ���
        bate=g_new'*(g_new-g)/(g'*g);%%PRP
        dr_new=-g_new+bate*dr;%��������

        g=g_new;
        dr=dr_new;
        
        iter=iter+1;
        RMSE(iter)=sqrt(mse(e));
%         if abs(RMSE(iter-1)-RMSE(iter))<0.01 || RMSE(iter)>RMSE(iter-1)
%             break;
%         end
    end  
    %figure;plot(RMSE);