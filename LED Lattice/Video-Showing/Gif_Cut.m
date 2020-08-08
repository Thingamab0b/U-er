info = imfinfo('C:\Users\彳亍\Documents\Tencent Files\1287582961\FileRecv\小狐狸跳舞.gif');%第一次读取，用于获取属性值
len = length(info);

fid=fopen('FOX.txt','wt');

fprintf(fid,'unsigned char Fox[18][96][8]{\n');
for i = 1 :3:len 
    str=sprintf('photo%d.bmp',i);
    [Ii, map] = imread('C:\Users\彳亍\Documents\Tencent Files\1287582961\FileRecv\小狐狸跳舞.gif', 'frames', i);   
      Ii=imresize(Ii,[24 32]);
    Ii=imbinarize(Ii,0.5);
    imwrite(Ii,str,'bmp');   %在此输出的为unint8格式，不具有RGB色彩！！！！
    Ii=~Ii;
    Ii=mat2cell(Ii,[8 8 8],[8 8 8 8]);
    A=logical(zeros(96,8));
i=1;
fprintf(fid,'{');
while i<=96 
   for c=1:8
       for a=1:3 
           for b=1:4    
    A(i,:)=Ii{a,b}(c,:);
    fprintf(fid,'{%d,%d,%d,%d,%d,%d,%d,%d},',A(i,:));
    i=i+1;
            end 
       end
   fprintf(fid,'\n');
    end    
end  
fprintf(fid,'},\n');
end
fprintf(fid,'};\n');
fclose(fid);
close;


