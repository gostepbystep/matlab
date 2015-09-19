function [AngleTrace AngleScale_interval] = Offset2Angle(Angle,N0,SemicTrace)

AngleScale = min(min(Angle)):(max(max(Angle))-min(min(Angle)))/(N0):max(max(Angle));
%AngleScale = min(Angle(1,:)):(max(Angle(1,:))-min(Angle(1,:)))/(N0):max(Angle(1,:));

for i = 1:1:(length(AngleScale)-1)
   AngleScale_interval(i) = (AngleScale(i)+AngleScale(i+1))/2;
end

for j = 1:1:size(SemicTrace,1)
    for i = 1:1:length(AngleScale_interval)
        index0 = find(Angle(j,:)<AngleScale_interval(i));
        index1 = find(Angle(j,:)>AngleScale_interval(i));
        
        if length(index0)==0
            bb{j}{i} =[index1(1)];
            tt{j}{i} =1;
        end
        if length(index1)==0
            bb{j}{i} =[index0(length(index0))];
            tt{j}{i} =1;
        end
        if length(index0)==1 || length(index1)==1
            bb{j}{i} = [index0(length(index0)),index1(1)];
            tt{j}{i} = [Angle(j,index0(length(index0))),Angle(j,index1(1))]/sum([Angle(j,index0(length(index0))),Angle(j,index1(1))]);
        end
        if length(index0)>=2 && length(index1)>=2
            bb{j}{i} = [index0(length(index0)-1:length(index0)),index1(1:2)];
            tt{j}{i} = [Angle(j,index0(length(index0)-1:length(index0))),Angle(j,index1(1:2))]/sum([Angle(j,index0(length(index0)-1:length(index0))),Angle(j,index1(1:2))]);
        end
%         if length(index0)<2 || length(index1)<2
%             bb{j}{i} =0;
%             tt{j}{i} =0;
%         else
%             bb{j}{i} = [index0(length(index0)-1:length(index0)),index1(1:2)];
%             tt{j}{i} = [Angle(j,index0(length(index0)-1:length(index0))),Angle(j,index1(1:2))]/sum([Angle(j,index0(length(index0)-1:length(index0))),Angle(j,index1(1:2))]);
%         end
    end
end

AngleIndex = bb;
AngleTrace = zeros(size(SemicTrace));

for i = 1:1:size(SemicTrace,1)
    for j = 1:1:N0 
        if AngleIndex{i}{j} == 0
            AngleTrace(i,j) = 0;
        else    
            AngleTrace(i,j) = SemicTrace(i,AngleIndex{i}{j})*tt{i}{j}';
        end
    end
end