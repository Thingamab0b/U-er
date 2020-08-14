import jiagu

FILE_OBJECT= open('D:\\硬设\\小U\\temp.txt','r', encoding='UTF-8')            
text =FILE_OBJECT.read() #the sentence to be tested
sentiment = jiagu.sentiment(text)

if sentiment[0]=='positive':
    if 0.8<sentiment[1]<=1: 
        m='1'
    elif 0.6<sentiment[1]<=0.8:
        m='2'
    else:
        m='3'
else:
    if 0.9<sentiment[1]<=1: 
        m='6'
    elif 0.8<sentiment[1]<=0.9:
        m='5'
    elif 0.7<sentiment[1]<=0.8:
        m='4'
    else:
        m='3' 
    
FILE= open('D:\\硬设\\小U\\emotion.txt','w') 
FILE.write(m)
