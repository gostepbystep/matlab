fin = fopen(preFileName, 'r', 'ieee-be');                % ��IEEE��ʽ���ļ�
volHeader = stpReadVolHeader(fin, preFileName);             % ��ȡ��ͷ

index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, 2905, 1514);

fclose(fin);