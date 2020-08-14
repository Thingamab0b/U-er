info = imfinfo('C:\Users\彳亍\Documents\Tencent Files\1287582961\FileRecv\小狐狸跳舞.gif');%第一次读取，用于获取属性值
len = length(info);

fid=fopen('FOX.bin','wb');
for j = 1 :len 
    str=sprintf('photo%d.bmp',j);
    [Ii, map] = imread('C:\Users\彳亍\Documents\Tencent Files\1287582961\FileRecv\小狐狸跳舞.gif', j);   
      Ii=imresize(Ii,[24 32]);
   Ii=imbinarize(Ii,0.5);
 %   imwrite(Ii,str,'bmp');   %在此输出的为unint8格式，不具有RGB色彩！！！！
    Ii=~Ii;
    Ii=mat2cell(Ii,[8 8 8],[8 8 8 8]);
    A=logical(zeros(96,8));
 i=1;
 while i<=96 
    for c=1:8
      for a=1:3           
          for b=1:4    
    A(i,:)=Ii{a,b}(c,:);
    fwrite(fid,A(i,:),'int');
%  fprintf(fid,"%d%d%d%d%d%d%d%d",A(i,:));
%  str=sprintf("%d%d%d%d",A(i,1:4));
%   if strcmp(str,'0000')
%      str='0';
%   elseif strcmp(str,'0001')
%      str='1';
%   elseif strcmp(str,'0010')
%      str='2';
%   elseif strcmp(str,'0011')
%       str='3';
%   elseif strcmp(str,'0100')
%        str='4';
%  elseif strcmp(str,'0101')
%        str='5';
%   elseif strcmp(str,'0110')
%        str='6';
%   elseif strcmp(str,'0111')
%         str='7';
%  elseif strcmp(str,'1000') 
%         str='8';
%  elseif strcmp(str,'1001') 
%         str='9';
%  elseif strcmp(str,'1010') 
%      str='A';
%  elseif strcmp(str,'1011') 
%         str='B';
%   elseif strcmp(str,'1100') 
%         str='C';
%  elseif strcmp(str,'1101') 
%         str='D';
%  elseif strcmp(str,'1110') 
%         str='E';
%  elseif strcmp(str,'1111') 
%         str='F';
%   end
%   fprintf(fid,"%s",str);
% str=sprintf("%d%d%d%d",A(i,5:8));
%  if strcmp(str,'0000')
%      str='0';
%   elseif strcmp(str,'0001')
%      str='1';
%   elseif strcmp(str,'0010')
%      str='2';
%   elseif strcmp(str,'0011')
%       str='3';
%   elseif strcmp(str,'0100')
%        str='4';
%  elseif strcmp(str,'0101')
%        str='5';
%   elseif strcmp(str,'0110')
%        str='6';
%   elseif strcmp(str,'0111')
%         str='7';
%  elseif strcmp(str,'1000') 
%         str='8';
%  elseif strcmp(str,'1001') 
%         str='9';
%  elseif strcmp(str,'1010') 
%      str='A';
%  elseif strcmp(str,'1011') 
%         str='B';
%   elseif strcmp(str,'1100') 
%         str='C';
%  elseif strcmp(str,'1101') 
%         str='D';
%  elseif strcmp(str,'1110') 
%         str='E';
%  elseif strcmp(str,'1111') 
%         str='F';
%  end
%     fprintf(fid,"%s",str);
     i=i+1;
         end
      end      
    end 
 end
end   

fclose(fid);
close;


