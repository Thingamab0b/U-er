%% 连接API
function Hello_U(obj, event)
if contains(fscanf(s,'%s'),'Y') 
cl=clock;
cl=cl(4);
if mod(count,4)==0
if (4<cl)&&(cl<12)
     [y, F] = audioread('主人早上好.mp3'); 
elseif (11<cl)&&(cl<15)
    [y, F] = audioread('主人中午好.mp3'); 
elseif (14<cl)&&(cl<19)
    [y, F] = audioread('主人下午好.mp3'); 
else
    [y, F] = audioread('主人晚上好.mp3');
end
else
    [y, F] = audioread('小悠一直都在.mp3');
end
   sound(y, F);
   count=count+1;
%% 录音
recordblocking(recObj,Time);
Voice = getaudiodata(recObj);
%% voice2txt
wavFilename = 'TemporalFile.wav';
audiowrite(wavFilename,Voice(:,1),Fs);
fid = fopen(wavFilename,'rb');
bytes = fread(fid);
fclose(fid);
base64string_len = size(bytes,1);
base64string = matlab.net.base64encode(bytes);
options = weboptions('RequestMethod', 'post','HeaderFields',{ 'Content-Type','application/json'});
options.Timeout =5;
m = struct;
m.format = 'wav';%Format
m.lan = 'zh';%Language
m.token = url_use;
m.len = base64string_len;
m.rate = 16000;
m.speech = base64string;
m.cuid = '2a:c6:3f:c419:44';
m.channel = 1;
Content = webwrite(url,m,options);
if isfield(Content,'result')
    txt = Content.result{:};
else
    txt = '';
end

%% Get_response
if strcmp(txt,'')
     [y, F] = audioread('小悠没听清主人讲什么.mp3'); %% y是音频数据m*n的矩阵，Fs是采样率。n是通道数。
elseif contains(txt,'叫什么')||contains(txt,'名字')
     [y, F] = audioread('我叫小U.mp3'); 
     fprintf(s,'%c','7');
elseif contains(txt,'几点')||contains(txt,'时钟')||contains(txt,'时间')
    [y, F] = audioread('给你看看我的时钟脸.mp3');
    fprintf(s,'%c','0'); 
elseif contains(txt,'音乐')||contains(txt,'歌')
     [y, F] = audioread('听好啦.mp3');
     sound(y, F);
     Music_song=['D:\硬设\Song\',num2str(unidrnd(7)),'.mp3'];
     [y, F] = audioread(Music_song);
    fprintf(s,'%c','8');
else
   Response=GetResponse(txt);
   fid=fopen("temp.txt",'wt');
   fprintf(fid,'%s',Response);
   fclose(fid);
   system('python D:\硬设\小U\tts.py');
   [y, F] = audioread('result.mp3'); %% y是音频数据m*n的矩阵，Fs是采样率。n是通道数。
   ff=fopen("emotion.txt",'rt');
   system('python D:\硬设\小U\Emotion-analysis.py');
   tempch=fgets(ff)
   fprintf(s,'%c',tempch);
   fclose(ff);
end
    start(timer_t);
    sound(y, F);
    stop(timer_t);
 end
 end