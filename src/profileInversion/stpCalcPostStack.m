function [trData] = stpCalcPostStack(fileName, inIds, crossIds)
% ¸ø¶¨inlineºÍcrosslineºÅÖ®ºó£¬±éÀúµÀ¼¯£¬ÕÒ³öÓëÖ®ÏàÍ¬µÄµÀ¼¯£¬¶ÔÆä×öµþ¼Ó£¬µÃµ½Ò»¸öµþºóµÀ¼¯
%
% Êä³ö
% trData    Êä³öµþºóµÄµÀ£¨´¿Ê±¼äÐòÁÐµÄÊý¾Ý£©
%
% ÊäÈë
% fileName  segyÎÄ¼þÃû
% inId      inline ¸ø¶¨µÄÐèÒªÕÒµ½µÄinlineºÅÊý×é
% crossId   crossId ¸ø¶¨µÄÐèÒªÕÒµ½µÄcosslineºÅÊý×é
%
% ·¶Àý
% stpCalcPostStack('E:\ËÕÀï¸ñ\new_erwu_Prestack80.sgy', [2666], [1691]);
    
    %%
    fin = fopen(fileName, 'r', 'ieee-be');              % ÒÔIEEE·½Ê½´ò¿ªÎÄ¼þ
    volHeader = stpReadVolHeader(fin, fileName);        % ¶ÁÈ¡¾íÍ·

    

    [~, trNum] = size(inIds);                            % »ñÈ¡¼ÇÂ¼µÄÊýÁ¿
    trData = zeros(volHeader.sampNum, trNum);

    for i = 1 : trNum
        % ±éÀúµÀ¼¯
        inId = inIds(i);
        crossId = crossIds(i);

        % µ÷ÓÃº¯Êý¼ÆËãµÈÓÚinIdºÍµÈÓÚcrossIdµÄÆðÊ¼µÀÎ»ÖÃ£¬
        index = stpIndexOfTraceSetOnInIdAndCrossId(fin, volHeader, inId, crossId);
        if(index == -1)
            fprintf('ÔÚÎÄ¼þÖÐÎ´ÕÒµ½·ûºÏinline=%dÇÒcossline=%dµÄµÀ\n', inId, crossId);
            continue;
        end

        isFind = false;
        okTraceNum = 0;
        % Ìøµ½µ±Ç°Â·¾¶À´
        fseek(fin, 3600 + (index-1)*(240+volHeader.sizeTrace), -1);

        % Èç¹ûÕÒµ½ÁË£¬¾Í¼ÌÐø×ßÏÂÈ¥
        for j = index : volHeader.traceNum
            % ¶ÁÈ¡µÀÍ·
            trHeader = stpReadTraceHeader(fin);

            if(trHeader.inId==inId && trHeader.crossId==crossId)
                isFind = true;
                okTraceNum = okTraceNum + 1;
                
                % ¶ÁÈ¡Êý¾Ý²¢ÀÛ¼Ó
                data = stpReadTraceData(fin, volHeader.sampNum, volHeader.dataForm);
                trData(:, i) = trData(:, i) + data;
                continue;

            elseif(isFind == true || j == volHeader.traceNum)
                % ±íÊ¾ÒÑ¾­±éÀúÍêËùÓÐµÄ¸Ã·´ÉäµãµÄµÀ
                trData(:, i) = trData(:, i) / okTraceNum;
                break;
            end

            fseek(fin, volHeader.sizeTrace, 0);                       
        end
    end
    
    %%
%     % »æÖÆµØÕðÊý¾Ý
%     seismic= s_convert(-trData, 0, 2);
%     s_wplot(seismic);
%     title('²â¾®µþºó¼ÇÂ¼');

    %%
    fclose(fin);                                        % ¶ÁÈ¡Íê±ÏÖ®ºóÐèÒª¹Ø±Õfin
end