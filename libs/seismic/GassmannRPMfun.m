function [Vp,Vs,Den] = GassmannRPMfun(Por,Sw,Clay);

Por(find(Por(:,1)<=0),1)=0.0001;     Por(find(Por(:,1)>=1),1)=0.9999;
Sw(find(Sw(:,1)<=0),1)=0.0001;       Sw(find(Sw(:,1)>=1),1)=0.9999;
Clay(find(Clay(:,1)<=0),1)=0.0001;   Clay(find(Clay(:,1)>=1),1)=0.9999;

load('GassmannRPM.mat');
%0��϶������ʯ�����ģ���ͼ���ģ��
Kmat=0.5.*((Clay.*Kc+(1-Clay).*Ks)./(1-0)+(1-0)./(Clay./Kc+(1-Clay)./Ks));%0��϶������ʯ�����ģ��
Umat=0.5.*((Clay.*Uc+(1-Clay).*Us)./(1-0)+(1-0)./(Clay./Uc+(1-Clay)./Us));%0��϶������ʯ�ļ���ģ��
v=(Kmat-2./3.*Umat)./(2.*Kmat+2./3.*Umat);%���ɱ�
%�ٽ��϶������ʯ�����ģ���ͼ���ģ��
KHM=(P.*(n.*(1-POR0).*Umat).^2./(18.*(3.14159.*(1-v)).^2)).^(1/3);
UHM=((5-4.*v)./(10-5.*v)).*((3.*P.*(n.*(1-POR0).*Umat).^2)./(2.*(3.14159.*(1-v)).^2)).^(1/3);
%����ʵ�ʿ�϶���¸�����ʯ�����ģ���ͼ���ģ��
sigma=(9.*Kmat+8.*Umat)./(Kmat+2.*Umat);
Kdry=1./((Por./POR0)./(KHM+4./3.*Umat)+(1-Por./POR0)./(Kmat+4./3.*Umat))-4./3.*Umat;
Udry=1./((Por./POR0)./(UHM+1./6.*sigma.*Umat)+(1-Por./POR0)./(Umat+1./6.*sigma.*Umat))-1./6.*sigma.*Umat;
%����ʵ�ʿ�϶���º�����������ʯ�����ģ���ͼ���ģ��
Khc=0.02;%���������ģ��GPa
Kbrine=2.29;%�ز�ˮ�����ģ��GPa
Kfl=1./(Sw./Kbrine+(1-Sw)./Khc);%��������ģ��
K0=0.5.*((Clay.*Kc+(1-Clay).*Ks)./(1-Por)+(1-Por)./(Clay./Kc+(1-Clay)./Ks));%�����ʯ��������ģ��
Ksat=Kdry+((1-Kdry./K0).^2)./(Por./Kfl+(1-Por)./K0-Kdry./(K0.^2));%������������ʯ�����ģ��������֮������д����
Usat=Udry;
%����ʵ�ʿ�϶���µĵ�Ч�ٶȡ��ܶ�
Den=((1-Por).*bestRhomatrix+Por.*bestRhofluid)./1000;
Vp=(((Ksat+4./3.*Usat)./Den).^(1./2))*1000;%�ݲ��ٶ�
Vs=((Usat./Den).^(1./2)).*1000;%�Შ�ٶ�


