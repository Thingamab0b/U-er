# U-er
## Introduction 

  It's my first time to have a try on hardware. And I'm developing a robot named U-er who is capable of chatting with people (dull reaction, though), showing its feeling and frequency spectrum of a song with its LED face in a size of 32*24.   
  第一次接触硬件设计....做了一个蠢蠢的机器人，取了个名字叫**小U**,名字来源于驱动它的板子Arduino **U**no...   
    
  **功能**：  
  1) 聊天（有丰富表情和傲娇声音，就是反应有点迟钝orz)  
  2) 显示时间  
  3) 播放音乐，显示频谱  
  4) 播放视频  
  
  **材料**  
  1) Arduino Uno *1   
  2) MAX7219 4*1 (LED点阵模块) *3   
  3) DS1307 时钟模块 *1  
  4) SD卡读写模块 *1
  5) 公母杜邦线若干 
  6) 3D打印外壳一个  
 
## Module&Function
### 1. Voice Technology
  要实现和小U对话，要完成的主要是三个部分：语音识别、得到相应的对话回应、把回应的文本转为语音。主要思路是用matlab处理 
#### 1.1 Voice Recognition(Voice to Text)
  使用的是百度爸爸[百度智能云](https://console.bce.baidu.com/ai/?_=1596870294331#/ai/speech/app/list)的接口（白嫖是因为毕竟从什么提取音频特征、MFCC、神经网络之类的底层做起来时间不够啊TAT)。一个账号有一个月的试用时间，5w条免费试用(百度爸爸果然慷慨×)。 
  具体过程就是注册一个百度智能云账号，创建一个项目，然后把自己的API Key和Secret Key放进代码，就可以愉快地得到语音转文字的结果啦。   
  Ref：Bilibili_用MATLAB实现语音识别_by matlab与神经科学 [Voice2Txt.m](https://github.com/Thingamab0b/U-er/blob/master/Voice%20Technology/Voice2Txt.m)   
      [API相关](https://www.bilibili.com/video/BV1rJ411j7cc?p=1)  
      [matlab登录API接口](https://blog.csdn.net/qq_38122800/article/details/88693228)

#### 1.2 Chatbots
  怎么回答问题呢？一开始想自己做一个简单的回答库，但是觉得好干焦，而且这是个硬件设计，如果我还要去建个库什么的就已经偏离比赛的本质了吧....所以找了很多聊天机器人。终于发现了一个宝藏开源项目：[思知机器人](https://www.ownthink.com/)。Author是人工智能领域的dalao，这个网站主要有两个功能：知识图谱、对话机器人。作者给它取了一个名字叫“小思”，有一句话打动我了： 
```
思知是作者的一个理想国，作者在人工智能方面不断努力着，希望有一天能够出现独立思考的人工智能机器人，虽然明知道短期内不可能实现，但却一直向着他的梦执着前行着
``` 
  多少被程序员的这种执念打动了....也让我对这个职业的距离感减小了很多。  
  调用起来也很简单，甚至不需要API Key,直接向author提供的url+文本内容，用get的方法就能得到response了。  
  经测试，回答很丰富.....一个“你好”有不下十种回答方式（果然不建库是正确选择吗）。   
  以及情感分析，author提供的jiagu模块对于情感只有一个维度：negative和positive,然后跟着一个数值。这个就很麻烦....人的情感怎么能用一个维度表达完全....所以正在考虑入一下Deep learning的坑，做个简单的神经网络什么的....(没填成我就回来删掉这一段，再把一个维度简单粗暴地换成区间，再映射.....)   
  [python代码](https://github.com/Thingamab0b/U-er/blob/master/Voice%20Technology/Emotion-analysis.py) 
  使用之前要先pip install jiagu   
  Ref：[ownthink](https://github.com/ownthink/robot/)    

#### 1.3 Text to Speech (TTS)
  此处白嫖的仍然是慷慨赠送5k免费额度的百度爸爸，毕竟我自己不能在短时间内造一个语音库....接API的方式基本和1.1相似。就是把从Chatbots那里得到的回答传过去，传回音频来。参考资料类似，就不赘述了。  
  [Text to Speech](https://github.com/Thingamab0b/U-er/blob/master/Voice%20Technology/tts.py)
  
### 2. LED Lattice （MAX7219）
#### 2.1 Kaomoji
  Kaomoji是颜文字对应日语的罗马音，因为屏幕是32*24的，所以只能用手点出来....   
  具体步骤： 
  Step1：Pick一些颜文字   
  Step2：下载一个取字模的软件 (此处用的是[PCtoLCD2002](https://github.com/Thingamab0b/U-er/tree/master/LED%20Lattice/%E5%AD%97%E6%A8%A1)，某校毕业生2002的毕设作品orz)   
  Step3: 用手把表情点进去，生成32*24位图.... 最后用了[八个表情](https://github.com/Thingamab0b/U-er/tree/master/LED%20Lattice/%E5%AD%97%E6%A8%A1/My_kaomoji)
  Step4: 转换成数组，然后编个程序使灯变亮
#### 2.2 Frequency Spectrum   
  呜呜呜还没做出来（我的声音传感器模块还没到，等填坑）  
#### 2.3 Time-Showing   
  用到了DS1307时钟模块（还没到货），但是已经把显示部分做好了。基本步骤和Kaomoji差不多，首先把几个数字的字模取了，然后变成数组，然后再读入(因为我的4*3点阵没有对应的库可以用，用了也是乱码....所以所有代码都是纯手写的，了解了底层原理以后写的。通用性不是很强）   
  [Time-Showing](https://github.com/Thingamab0b/U-er/tree/master/LED%20Lattice/Time-Showing)  
  Ref:[Arduino IeC+DS1307](https://www.cnblogs.com/zlbg/p/4227428.html)   
  [DS1307模块使用](https://www.arduino.cn/thread-23595-1-1.html)
#### 2.4 Video-Showing
  俗话说有屏幕的地方就有badapple....为了致敬经典（×，我决定赋予这块32*24的屏幕以精髓...当然也可以放一些GIF图之类的   
  Step1：视频取帧，导成数组[取帧程序](https://github.com/Thingamab0b/U-er/tree/master/LED%20Lattice/Video-Showing)  
  Step2: 存进SD卡，等待程序读取   
### 3. 3D打印外壳


## 关键技术 
### 1. matlab与arduino串口通信
未完待续
