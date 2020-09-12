function response=GetResponse(txt)
url_2=['https://api.ownthink.com/bot?appid=xiaosi&userid=user&spoken=',txt];
options = weboptions('RequestMethod', 'get','Timeout',10,'HeaderFields',{ 'Content-Type','application/json'});
Content=webread(url_2,options);
if strfind(Content.message,'success')
   response=Content.data.info.text;
else
   response='小悠不知道怎么回答呢';
end
