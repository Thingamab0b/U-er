Time=3.5;
Fs = 16000 ; 
nBits = 16 ; 
nChannels = 2 ; 
ID = 1; 
recObj = audiorecorder(Fs,nBits,nChannels,ID);
count=0;
%% ���ô���
s=serial('COM5');
set(s,'BaudRate',9600);
fopen(s);
%% ����API
global url_use
if isempty(url_use)==1
    api_id = 'PMyOPjHwIqTZSVSydZedR4Rt'; % Replace the api key
    secret_key = 'URm4EbSoP8ZxTm0zUwNFmTdnH6rh0EP9'; % Replace the secret key
    url_0 = ['https://aip.baidubce.com/oauth/2.0/token?',...
             'grant_type=client_credentials&client_id=',...
             api_id,'&client_secret=',secret_key];
    url_cont = webread(url_0);
    url_use = url_cont.access_token;
end
url= 'http://vop.baidu.com/server_api';

%  while true
% if contains(fscanf(s,'%s'),'Y') 
    
cl=clock;
cl=cl(4);
if mod(count,4)==0
if (4<cl)&&(cl<12)
     [y, F] = audioread('�������Ϻ�.mp3'); 
elseif (11<cl)&&(cl<15)
    [y, F] = audioread('���������.mp3'); 
elseif (14<cl)&&(cl<19)
    [y, F] = audioread('���������.mp3'); 
else
    [y, F] = audioread('�������Ϻ�.mp3');
end
else
    [y, F] = audioread('С��һֱ����.mp3');
end
   sound(y, F);
   count=count+1;
%% ¼��
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
     [y, F] = audioread('С��û�������˽�ʲô.mp3'); %% y����Ƶ����m*n�ľ���Fs�ǲ����ʡ�n��ͨ������
elseif contains(txt,'��ʲô')||contains(txt,'����')
     [y, F] = audioread('�ҽ�СU.mp3'); 
     fprintf(s,'%c','7');
elseif contains(txt,'����')||contains(txt,'ʱ��')||contains(txt,'ʱ��')
    [y, F] = audioread('���㿴���ҵ�ʱ����.mp3');
    fprintf(s,'%c','0'); 
elseif contains(txt,'����')||contains(txt,'��')
     [y, F] = audioread('������.mp3');
    fprintf(s,'%c','8');
else
   Response=GetResponse(txt);
   fid=fopen("temp.txt",'wt');
   fprintf(fid,'%s',Response);
   fclose(fid);
   system('python D:\Ӳ��\СU\tts.py');
   [y, F] = audioread('result.mp3'); %% y����Ƶ����m*n�ľ���Fs�ǲ����ʡ�n��ͨ������
   ff=fopen("emotion.txt",'rt');
   system('python D:\Ӳ��\СU\Emotion-analysis.py');
   tempch=fgets(ff)
   fprintf(s,'%c',tempch);
   fclose(ff);
end
    sound(y, F);
% else
%     "Not yet received the signal"
%     pause(0.5)
% end
%  end