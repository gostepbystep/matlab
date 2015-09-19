function [x_new,RMSE]=poststackinversion(dtrue,W,x_initial,itermax)

    G=RefRespecttoZ(x_initial);
    R=Reflection(x_initial);
    e=W*R-dtrue;  %��ʼ�����
    g= 2*W'*G*e;  %�ݶȷ���
    dr=-g;%��ʼ����������
    
    x_new=x_initial;
    iter=1;
    
    while iter <= itermax 
        
        RMSE(iter)=sqrt(mse(e));
        
        
        alpha_new =-1*(e'*(W'*G)*dr)/(dr'*(W'*G)'*(W'*G)*dr);%�µ���������
        x_new = x_new + alpha_new *dr; 
        
        G=RefRespecttoZ(x_new);
        R=Reflection(x_new);
        e = W*R-dtrue; %������
        g_new= 2*W'*G*e;  %�ݶȷ���
        bate=g_new'*(g_new-g)/(g'*g);%%PRP
        dr_new=-g_new+bate*dr;%��������

        g=g_new;
        dr=dr_new;
        
        iter=iter+1;
    end  