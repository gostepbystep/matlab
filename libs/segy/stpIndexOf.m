function [index] = stpIndexOf(array, value)
% �˺������ڲ���array������value��λ��
%
% ���
% index         ���ص�����,����ֵΪ-1��ʱ���ʾû���ҵ�
%
% ����
% array         һά���飬���ڱ���ѯ������
% value         ��Ҫ�ҵ���ֵ

    [row, col] = size(array);       % ��ȡarray�Ĵ�С

    % ʹ�ö��ַ�����
    startPos = 1;
    endPos = col;
    index = floor((startPos+endPos) / 2);
    maxError = 0.00001;

    while(startPos~=index && index~=endPos)
        index = floor((startPos+endPos) / 2);

        if( array(index) - value > maxError)
            % �����ǰ���ݱ�value��˵��Ҫ���ҵ���������߲��֣��޸�endPos
            endPos = index-1;
        elseif( value - array(index) > maxError)
            % �����ǰ���ݱ�valueС��˵��Ҫ���ҵ��������ұ߲��֣��޸�startPos
            startPos = index+1;
        else
            break;
        end;
    end

end