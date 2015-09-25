fin = fopen(preFileName, 'r', 'ieee-be');                % 以IEEE方式打开文件
volHeader = stpReadVolHeader(fin, preFileName);             % 读取卷头

index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, 2905, 1514);

fclose(fin);