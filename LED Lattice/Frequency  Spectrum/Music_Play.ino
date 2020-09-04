#include <arduinoFFT.h>
#include <SPI.h>
#define count 12 
#define SAMPLES 64            //Must be a power of 2
#define MAX_DEVICES  4   // Total number display modules
int Max7219_pinCLK = 5;
int Max7219_pinCS = 6;
int Max7219_pinDIN = 7 ;
#define  xres 32      // Total number of  columns in the display, must be <= SAMPLES/2
#define  yres 8        // Total number of  rows in the display


unsigned char MY_ARRAY[]={0x00, 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff}; // default = standard pattern
unsigned char MODE[10]={0x08,0x00,0x0a,0x01,0x0b,0x07,0x0c,0x01,0x0f,0x00};
unsigned char temp[xres];
double vReal[SAMPLES];
double vImag[SAMPLES];
char data_avgs[xres];

int yvalue;
int peaks[xres];

arduinoFFT FFT = arduinoFFT();                                    // FFT object
 void Init_MAX7219(void)
{
unsigned char i,j;
for(j=0;j<9;j+=2)
{digitalWrite(Max7219_pinCS,LOW);
 for(i=0;i<count;i++)
 Write_Max7219(MODE[j],MODE[j+1]);
 digitalWrite(Max7219_pinCS,HIGH);
 delay(50);
 }
}

void Write_Max7219_byte(unsigned char DATA)
{   
unsigned char i;            
for(i=8;i>=1;i--)
{                  
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,DATA&0x80);// Extracting a bit data
DATA = DATA<<1;
digitalWrite(Max7219_pinCLK,HIGH);
}                                 
}

void Write_Max7219(unsigned char address,unsigned char dat)
{
digitalWrite(Max7219_pinCS,LOW);
Write_Max7219_byte(address);           //写入地址，即数码管编号
Write_Max7219_byte(dat);               //写入数据，即数码管显示数字
digitalWrite(Max7219_pinCS,HIGH); 
}
void setup() {
pinMode(Max7219_pinCLK,OUTPUT); 
  pinMode(Max7219_pinCS,OUTPUT);
  pinMode(Max7219_pinDIN,OUTPUT);
  delay(50);
  Init_MAX7219();   
}
 
void loop() {
   // ++ Sampling
   for(int i=0; i<SAMPLES; i++)
    {
      int value = analogRead(0)- 330;//512 ;                 // Read from ADC and subtract DC offset caused value
      vReal[i]= value/8;                      // Copy to bins after compressing
      vImag[i] = 0;                         
    }
    // -- Sampling

 
    // ++ FFT
    FFT.Windowing(vReal, SAMPLES, FFT_WIN_TYP_HAMMING, FFT_FORWARD);
    FFT.Compute(vReal, vImag, SAMPLES, FFT_FORWARD);
    FFT.ComplexToMagnitude(vReal, vImag, SAMPLES);
    // -- FFT

    
    // ++ re-arrange FFT result to match with no. of columns on display ( xres )
    int step = (SAMPLES/2)/xres; 
    int c=0;
    for(int i=0; i<(SAMPLES/2); i+=step)  
    {
      data_avgs[c] = 0;
      for (int k=0 ; k< step ; k++) 
      data_avgs[c]+=vReal[i+k];
      data_avgs[c] = data_avgs[c]/step; 
      c++;
    }
    // -- re-arrange FFT result to match with no. of columns on display ( xres )

    
    // ++ send to display according measured value 
    for(int i=0; i<xres; i++)
    {
      data_avgs[i] = constrain(data_avgs[i],0,80);            // set max & min values for buckets
      data_avgs[i] = map(data_avgs[i], 0, 80, 0, yres);        // remap averaged values to yres
      yvalue=data_avgs[i];
      peaks[i] = peaks[i]-1;    // decay by one light
      if (yvalue > peaks[i]) 
          peaks[i] = yvalue ;
      yvalue = peaks[i];    
      temp[i]=MY_ARRAY[yvalue];
     } 
     ShowFFT(temp);
     // -- send to display according measured value 
     
} 

void ShowFFT(unsigned char temp[])
{
unsigned char i,j,k,num,pre=1;
unsigned char assistnum=0x80;
for(i=1;i<9;i++)
{

digitalWrite(Max7219_pinCS,LOW);
for(num=0;num<3;num++)
{ assistnum>>=(num*8+i-1)/3+1-pre;
  pre=(num*8+i-1)/3+1;
  for(j=0;j<MAX_DEVICES;j++)
{Write_Max7219_byte(i);           //写入地址，即数码管编号
for(k=0;k<8;k++)
{
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,temp[j*8+k]&assistnum);// Extracting a bit data
digitalWrite(Max7219_pinCLK,HIGH);
}}}
digitalWrite(Max7219_pinCS,HIGH);
assistnum<<=5;
}
}
