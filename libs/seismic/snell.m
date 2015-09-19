function [Theta2,Psi1,Psi2] = snell(Theta1,Vs1,Vp1,Vs2,Vp2)
 
    
    
PP = sin(Theta1)/Vp1;
Theta2 = asin(PP*Vp2); % �����ݲ���͸���
Psi1 = asin(PP*Vs1);   % �����Შ�ķ����
Psi2 = asin(PP*Vs2);   % �����Შ��͸���

