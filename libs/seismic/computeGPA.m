function computeGPA(p)
%p=1;%,���Ƴɼ�
p=2;%�о����ɼ�
%p=3;%��ʿ�ɼ�
if p==1
    grade = load('C:\Users\Administrator\Desktop\GPA\���Ƴɼ�.txt');
elseif p==2
    grade = load('C:\Users\Administrator\Desktop\GPA\�о����ɼ�.txt');
elseif p==3
    grade = load('C:\Users\Administrator\Desktop\GPA\��ʿ�ɼ�.txt');
end
num_class = size(grade,1);
gpaGrade = zeros(num_class,1);
for i=1:num_class
    if 85<=grade(i,2)
        gpaGrade(i) = 4;
    elseif 70<=grade(i,2)
        gpaGrade(i) = 3;
    elseif 60<=grade(i,2)
        gpaGrade(i) = 2;
    else
        gpaGrade(i) = 1;
    end
end
GPA4 = sum(grade(:,1).*gpaGrade)/sum(grade(:,1))
GPA100 = sum(grade(:,1).*grade(:,2))/sum(grade(:,1));
end