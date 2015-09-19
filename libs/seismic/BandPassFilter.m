function y = BPassFilter(data)

% T=0:0.002:(79-1)*0.002;
% data=sin(2*pi*40*T);
% data=data';
% figure;plot(T,data); title('�˲�ǰ�ź�');
% N=512;
% fs=500;%����Ƶ��
% df=fs/(N-1) ;%�ֱ���
% f=(0:N-1)*df;%����ÿ���Ƶ��
% Y=fft(data,512)/N*2;%��ʵ�ķ�ֵ
% figure;plot(f(1:N/2),abs(Y(1:N/2)));

%%
centerFre=40;offsetFre=10;sampFre=1./0.002;

    %���I�ʹ�ͨ�˲���
    M = 0 ;    %�˲���������������ż����
    Ap = 0.9; %ͨ��˥��
    As = 45;   %���˥��
    Wp1 = 2*pi*(centerFre - offsetFre)/sampFre;  %����±�Ƶ
    Wp1 = 2*pi*(centerFre - 30)/sampFre;  %����±�Ƶ
    Wp2 = 2*pi*(centerFre + offsetFre)/sampFre;  %����ϱ�Ƶ
 
    % (1)���δ�
    N = ceil(3.6*sampFre/offsetFre);             %�����˲�������,���þ��δ���3dB��Ƶ������Ƶ�ʵ����±�Ƶ���е�
    M = N - 1;
    M = mod(M,2) + M ; %ʹ�˲���ΪI��(ż��)
    %��λ������Ӧ���½ű�
    h = zeros(1,M+1);  %��λ�����Ӧ��������ֵ
    for k = 1:(M+1);
        if (( k -1 - 0.5*M)==0)
            h(k) = Wp2/pi - Wp1/pi;
        else
            h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
        end
    end
    
    
  % (2) Hann Window
%   N = ceil(12.4*sampFre/offsetFre);             %�����˲�������,���þ��δ���3dB��Ƶ������Ƶ�ʵ����±�Ƶ���е�
%   M = N - 1;
%   M = mod(M,2) + M ; %ʹ�˲���ΪI��(ż��)
%       h = zeros(1,M+1);  %��λ�����Ӧ��������ֵ
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.5 - 0.5*cos(2*pi*K/M);
%   h = h.*w;
 
  % (3)Hamming Window
%   N = ceil(14*sampFre/offsetFre);             %�����˲�������,���þ��δ���3dB��Ƶ������Ƶ�ʵ����±�Ƶ���е�
%   M = N - 1;
%   M = mod(M,2) + M ; %ʹ�˲���ΪI��(ż��)
%     h = zeros(1,M+1);  %��λ�����Ӧ��������ֵ
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.54 - 0.46*cos(2*pi*k/M);
%   h = h.*w;

% (4)Blackman window
%   N = ceil(22.8*sampFre/offsetFre);             %�����˲�������,���þ��δ���3dB��Ƶ������Ƶ�ʵ����±�Ƶ���е�
%   M = N - 1;
%   M = mod(M,2) + M ; %ʹ�˲���ΪI��(ż��)
%     h = zeros(1,M+1);  %��λ�����Ӧ��������ֵ
%     for k = 1:(M+1);
%         if (( k -1 - 0.5*M)==0)
%             h(k) = Wp2/pi - Wp1/pi;
%         else
%             h(k) = Wp2*sin(Wp2.*(k - 1 - 0.5*M))/(pi*(Wp2*(k -1 - 0.5*M))) - Wp1*sin(Wp1*(k - 1 - 0.5*M))/(pi*(Wp1*(k -1 - 0.5*M)));
%         end
%     end
%   K = 0:M;
%   w = 0.42 - 0.5*cos(2*pi*K/M) + 0.08*cos(4*pi*K/M);
%   h = h.*w;

  h=h';
  
  
  y= conv(h,data);y=y(fix(length(h)./2)+1:length(y)-fix(length(h)./2),1);


%   N=512;
%   fs=512;%����Ƶ��
%   df=fs/(N-1) ;%�ֱ���
%   f=(0:N-1)*df;%����ÿ���Ƶ��
%   Y=fft(h,512)/N*2;%��ʵ�ķ�ֵ
%   figure;plot(f(1:N/2),abs(Y(1:N/2)));
%   
%     f=(0:N-1)*df;%����ÿ���Ƶ��
%   Y=fft(y,512)/N*2;%��ʵ�ķ�ֵ
%   figure;plot(f(1:N/2),abs(Y(1:N/2)));
%   
%   figure;
%   plot(T,y);set(gca,'ylim',[-1 1]);
