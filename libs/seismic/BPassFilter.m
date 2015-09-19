function y = BPassFilter(data)
 centerFre=40;
 offsetFre=30;
 sampFre=500;
    %���I�ʹ�ͨ�˲���
    M = 0 ;    %�˲���������������ż����
    Ap = 0.82; %ͨ��˥��
    As = 45;   %���˥��
    Wp1 = 2*pi*(centerFre - offsetFre)/sampFre;  %����±�Ƶ
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
  
  y = conv(data,h');
  y=y(fix(length(h)./2)+1:length(y)-fix(length(h)./2));