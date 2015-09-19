function [SeisTrace_zoep meanTheta] = Zoep_syn(xoff,D,startP,P,vp,vs,rho)

offsets_num = length(xoff);
for j  = 1:length(D)-1 % ���һ������û�з���ϵ��
    for i = 1:offsets_num
        upper_indic = startP+j-1;lower_indic = startP+j;
        
        Theta1 = asin(vp(upper_indic)*P(j,i));%����p���Ƕ�
        Psi1 = asin(vs(upper_indic)*P(j,i)); %����Შ�Ƕ�
        Theta2 = asin(vp(lower_indic)*P(j,i));%�����ݲ��Ƕ�
        Psi2 = asin(vs(lower_indic)*P(j,i));%͸��Შ�Ƕ�
       
        Vs1 = vs(upper_indic);Vp1 = vp(upper_indic);rho1 = rho(upper_indic);
        Vs2 = vs(lower_indic);Vp2 = vp(lower_indic);rho2 = rho(lower_indic);
       
        [M,C,A] = zoeppritz(Theta1,Theta2,Psi1,Psi2,Vs1,Vp1,rho1,Vs2,Vp2,rho2); %zoepritz���� M*A=C
        meanTheta(j,i) = (Theta1+Theta2)/2;%͸���ݲ��������ݲ��ĽǶȲ�
        Rpp(j,i) = A(1);
    end
end

load ricker.txt;
wavelet= ricker;
Wmatrix = convmtx(wavelet,size(Rpp,1));W = Wmatrix(1:size(Rpp,1),:);%�γ��޻��Ӳ�����W
clear Wmatrix  

for i = 1:offsets_num
    SeisTrace_zoep(:,i) = W*Rpp(:,i);
end
