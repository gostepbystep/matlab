function [error, ricker, synthRecord] = stpIterationRicker(ricker, postSeisData, welllogData, sampNum)

    global global_ricker global_d global_sampNum global_waveRef threshold;

    global_ricker = ricker;
    global_d = postSeisData;
    global_sampNum = sampNum;
    threshold = max(postSeisData) / 100;

    iterNum = 200;

     % ���㲨�迹 Vp*Pho
    waveImp = welllogData(:, 2) .* welllogData(:, 4);
    waveRef = Reflection(waveImp);                              % ���㷴��ϵ��
    
    global_waveRef = waveRef;
    
    [out] = stpMinBFGS(@stpRickerFun, global_ricker, iterNum);

    [~, index] = max(out);
    wMatrix = convmtx(out, global_sampNum);                         % ʹ�þ�����ɾ���, ���ɺ�����С�� 
    wMatrix = wMatrix(index : index+global_sampNum-1, :);              % ��ȡ��Ҫ�Ĳ��֣���С��sampNum*sampNum
    synthRecord = wMatrix * global_waveRef;                               % �ϳ���һ���Ӳ�������ʵ�������Ӳ��ͷ���ϵ���������

    figure;
    plot(ricker, 'r');
    hold on;
    plot(out, 'g');

    [error, ~] = stpRickerFun(out);
    ricker = out;
end