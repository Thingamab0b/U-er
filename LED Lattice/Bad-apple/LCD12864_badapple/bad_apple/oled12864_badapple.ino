#include <Adafruit_SSD1306.h>
#include <Arduino.h>
#include <SPI.h>

#define imgbuffer 704

uint8_t img_buffer[imgbuffer]={0};

#define OLED_DC     9
#define OLED_CS     10
#define OLED_RESET  8
Adafruit_SSD1306 display(OLED_DC, OLED_RESET, OLED_CS); //D0 = 13, D1 = 11, DC = 9, CS = 10

void setup() {
    display.begin();
    display.clearDisplay();
    display.display();
    Serial.begin(115200);
}

void loop() {
    while (Serial.available() > 0){
        Serial.readBytes(img_buffer, imgbuffer);
        display.drawBitmap(20, 0, img_buffer, 88, 64, WHITE, BLACK);
        display.display();
        Serial.print('1');
    }
}
