/*
LCD12864R

LCD  Arduino
RS = 17; Analog Pin3
RW = 16; Analog Pin2
EN = 18; Analog Pin4
D0  = 4; 
D1  = 5;
D2  = 6; 
D3  = 7; 
D4  = 8;
D5  = 9; 
D6  = 10; 
D7  = 11;
PSB = 5V;
RST = 5V;
*/

#include <Arduino.h>
#ifndef LCD12864R_h
#define LCD12864R_h
#include <avr/pgmspace.h>
#include <inttypes.h>


class LCD12864R {
typedef unsigned char uchar;


public:

LCD12864R();

void Initialise(void);
void setPins(uint8_t tRS, uint8_t tRW, uint8_t tD7, uint8_t tD6, uint8_t tD5, uint8_t tD4, uint8_t tD3, uint8_t tD2, uint8_t tD1, uint8_t tD0);
void delayns(void);
void VectorConverter(int vector);

void WriteCommand(int CMD);
void WriteData(int CMD);

void CLEAR(void);
void DisplayString(int X,int Y,uchar *ptr,int dat);
void DisplaySig(int M,int N,int sig);
void DrawFullScreen(uchar *p);


//int ScreenBuffer[16][32];

int delaytime;
int DEFAULTTIME;


static const int RS = 17; 
static const int RW = 16;  
static const int EN = 18;  
static const int D0  = 4;  
static const int D1  = 5; 
static const int D2  = 6;  
static const int D3  = 7;  
static const int D4  = 8; 
static const int D5  = 9;  
static const int D6  = 10;  
static const int D7  = 11; 


int temp[8];


};
extern LCD12864R LCDA;    
#endif
