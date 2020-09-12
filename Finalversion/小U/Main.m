%function Main
    global song;
    global Not_Play;
    Not_Play=true;
    Time=3.5 ;
    Fs=16000 ;
    nBits= 16 ;
    nChannels= 2 ;
    ID= 1;
    recObj = audiorecorder(Fs,nBits,nChannels,ID);
    count=0;
%    timer_t= timer('TimerFcn', @Timer, 'Period', 2.5, 'ExecutionMode', 'fixedRate')
    %% 设置串口
    global s;
    s=serial('COM5');
    set(s,'BaudRate',9600);
    set(s,'Timeout',0.3);
    % set(s, 'BytesAvailableFcnMode','byte');
    % set(s, 'BytesAvailableFcn', @Hello_U);
    % set(s, 'BytesAvailableFcnCount',1);

    fopen(s);

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
    global url;
    url= 'http://vop.baidu.com/server_api';
    
while true
    Is_Start=fscanf(s,'%s')
    if contains(Is_Start,'Y')
        cl=clock;
        cl=cl(4);
        if mod(count,2)==0
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
        sound(y,F);
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
            txt = Content.result{:}
        else
            txt = '';
        end
        %% Get_response
        if strcmp(txt,'')
            [y, F] = audioread('小悠没听清主人讲什么.mp3'); %% y是音频数据m*n的矩阵，Fs是采样率。n是通道数。
            player=audioplayer(y,F);
            playblocking(player); 
        elseif contains(txt,'叫什么')||contains(txt,'名字')
            [y, F] = audioread('我叫小U.mp3');
            fprintf(s,'%c','7');
            player=audioplayer(y,F);
            playblocking(player); 
%         elseif contains(txt,'几点')||contains(txt,'时钟')||contains(txt,'时间')
%         [y, F] = audioread('给你看看我的时钟脸.mp3');
%         fprintf(s,'%c','0');
        elseif contains(txt,'音乐')||contains(txt,'歌')
            [y, F] = audioread('听好啦.mp3');
            sound(y, F);
            fprintf(s,'%c','8'); 
           [y, F] = audioread(['D:\硬设\Song\',num2str(unidrnd(7)),'.mp3']);
            song=audioplayer(y, F);
            play(song);
            temp=fscanf(s,'%s')
            while ~contains(temp,'S')
            temp=fscanf(s,'%s')
            pause(0.3);
            end
            pause(song)
            clear y;
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
            player=audioplayer(y,F);
            playblocking(player); 
        end
        pause(0.3);
    end
end


