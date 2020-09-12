% s=serial('COM5');
% set(s,'BaudRate',9600);
% fopen(s);
% %fprintf(s,'%c','1');
% while(true)
% x=fscanf(s,'%c')
% end
 clc; clear;

scom5 = instrfind('Type', 'serial', 'Port', 'com5', 'Tag', ''); % 查找串口对象
if isempty(scom5)               % 如果串口对象不存在则建立
    scom5 = serial('COM5');
else                            % 否则使用已存在的对象
    fclose(scom5);
    scom5 = scom5(1);
end

scom5.baudrate=115200;          % 波特率115200（Arduino支持的最高波特率）
scom5.OutputBufferSize = 1024;  % 修改输出缓冲区
fopen(scom5);

filename = 'D:\硬设\小U\FOX.bin';

fid = fopen(filename,'r'); 
pause(1);                       % 以只读方式打开文件，暂停1s等待单片机复位
receiveData = 0;
for i = 1:51                % 总帧数为2191
    tic;                        % 计时开始
    C = fread(fid, 96, 'uint8');   % 以uint8格式发送704字节（一帧数据）
    fwrite(scom5, C);
    while(~receiveData)
        receiveData = fread(scom5, 1, 'char');  % 等待串口返回数据
    end
    receiveData = 0;
    time1 = toc;                % 计时结束，time1为显示图像用的时间
    if time1 < 0.1              % 若显示图像用时不到0.1s 则延时至0.1s（10FPS）
        pause(0.1 - time1);
    end
    time2 = toc                 % 再次计时，查看当前帧用时
end 

fclose(fid);        % 关闭文件
fclose(scom5);      % 关闭串口                                                    
delete(scom5);      % 删除串口对象
clear scom5 ;       % 清除变量
