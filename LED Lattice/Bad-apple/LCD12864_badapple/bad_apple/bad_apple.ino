#include "LCD12864R.h"
unsigned char img_buffer[1024]={0};

void setup()
{
    LCDA.Initialise(); // 屏幕初始化
    delay(100);
    Serial.begin(115200);
}

void loop()
{
      while (Serial.available() > 0)
      {
          Serial.readBytes(img_buffer,1024);
          LCDA.DrawFullScreen(img_buffer);
          delay(1);
          Serial.print('1');
      }
}
