function fun=savetxtfile(filename,data,m,n)

fid=fopen(filename,'wt');%д���ļ�·��  
%��ȡ����Ĵ�С��welldatasΪҪ����ľ���
for i=1:1:m
    for j=1:1:n
        fprintf(fid,'%20.5f ',data(i,j)); 
    end
    fprintf(fid,'\n');
end
fclose(fid); 