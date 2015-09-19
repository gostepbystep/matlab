function [index] = stpIndexOf(array, value)
% 此函数用于查找array数组中value的位置
%
% 输出
% index         返回的索引,当其值为-1的时候表示没有找到
%
% 输入
% array         一维数组，用于被查询的数据
% value         需要找到的值

    [row, col] = size(array);       % 获取array的大小

    % 使用二分法查找
    startPos = 1;
    endPos = col;
    index = floor((startPos+endPos) / 2);
    maxError = 0.00001;

    while(startPos~=index && index~=endPos)
        index = floor((startPos+endPos) / 2);

        if( array(index) - value > maxError)
            % 如果当前数据比value大，说明要查找的数据在左边部分，修改endPos
            endPos = index-1;
        elseif( value - array(index) > maxError)
            % 如果当前数据比value小，说明要查找的数据在右边部分，修改startPos
            startPos = index+1;
        else
            break;
        end;
    end

end