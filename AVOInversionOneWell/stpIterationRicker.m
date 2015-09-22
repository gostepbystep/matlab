function [error, ricker, synthRecord] = stpIterationRicker(ricker, postSeisData, welllogData, sampNum)

    global global_ricker global_d global_sampNum global_waveRef threshold;

    global_ricker = ricker;
    global_d = postSeisData;
    global_sampNum = sampNum;
    threshold = max(postSeisData) / 100;

    iterNum = 200;

     % 计算波阻抗 Vp*Pho
    waveImp = welllogData(:, 2) .* welllogData(:, 4);
    waveRef = Reflection(waveImp);                              % 计算反射系数
    
    global_waveRef = waveRef;
    
    [out] = stpMinBFGS(@stpRickerFun, global_ricker, iterNum);

    [~, index] = max(out);
    wMatrix = convmtx(out, global_sampNum);                         % 使用卷积生成矩阵, 生成后矩阵大小是 
    wMatrix = wMatrix(index : index+global_sampNum-1, :);              % 截取需要的部分，大小是sampNum*sampNum
    synthRecord = wMatrix * global_waveRef;                               % 合成了一个子波（这里实际上是子波和反射系数做卷积）

    figure;
    plot(ricker, 'r');
    hold on;
    plot(out, 'g');

    [error, ~] = stpRickerFun(out);
    ricker = out;
end