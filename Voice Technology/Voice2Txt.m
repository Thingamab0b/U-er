function txt = Voice2Txt(Time,varargin)
%Modified by Zilong Gao 
%ibpgaozilong@163.com
%语音 短语音识别（每一段，时间少于59秒）
%%
Fs = 16000 ; 
nBits = 16 ; 
nChannels = 2 ; 
ID = 1; % default audio input device 
switch nargin
    case 1
recObj = audiorecorder(Fs,nBits,nChannels,ID);
recordblocking(recObj,Time);
Voice = getaudiodata(recObj);
    case 2
[filename,pathname] = uigetfile({'*.wav';'*.mp3';'*.flac';'*.*'},...
                                 'File Selector');  
[y,Fs] = audioread([pathname filename]);
[P,Q] = rat(16000/Fs);
Voice = resample(y,P,Q);
end
global url_use
if isempty(url_use)==1
    api_id = ''; % Replace the api key
    secret_key = ''; % Replace the secret key
    url_0 = ['https://aip.baidubce.com/oauth/2.0/token?',...
             'grant_type=client_credentials&client_id=',...
             api_id,'&client_secret=',secret_key];
    url_cont = webread(url_0);
    url_use = url_cont.access_token;
end
url= 'http://vop.baidu.com/server_api';
wavFilename = 'TemporalFile.wav';
audiowrite(wavFilename,Voice(:,1),Fs);
fid = fopen(wavFilename,'rb');
bytes = fread(fid);
fclose(fid);
base64string_len = size(bytes,1);
base64string = matlab.net.base64encode(bytes);
options = weboptions('RequestMethod', 'post','HeaderFields',{ 'Content-Type','application/json'});
options.Timeout =20;
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
if contains(txt,'关闭程序')
    exit
end
%%
end