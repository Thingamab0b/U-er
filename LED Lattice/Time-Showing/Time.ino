unsigned char i;
unsigned char j;

#define count 12           //级联个数
int Max7219_pinCLK = 10;
int Max7219_pinCS = 11;
int Max7219_pinDIN = 12 ;
int dot=0;
unsigned char num[10][8][5]
{
{{0,1,1,1,0},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
{{0,0,1,0,0},{0,1,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,1,1,1,0},},
{{0,1,1,1,0},{1,0,0,0,1},{0,0,0,0,1},{0,0,0,1,0},{0,0,1,0,0},{0,1,0,0,0},{1,0,0,0,0},{1,1,1,1,1},},
{{0,1,1,1,0},{1,0,0,0,1},{0,0,0,0,1},{0,0,1,1,0},{0,0,0,0,1},{0,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
{{0,0,0,1,0},{0,0,1,1,0},{0,1,0,1,0},{1,0,0,1,0},{1,1,1,1,1},{0,0,0,1,0},{0,0,0,1,0},{0,0,0,1,0},},
{{1,1,1,1,1},{1,0,0,0,0},{1,0,0,0,0},{0,1,1,1,0},{0,0,0,0,1},{0,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
{{0,1,1,1,0},{1,0,0,0,1},{1,0,0,0,0},{1,0,0,0,0},{1,1,1,1,0},{1,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
{{1,1,1,1,1},{1,0,0,0,1},{0,0,0,0,1},{0,0,0,1,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},},
{{0,1,1,1,0},{1,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
{{0,1,1,1,0},{1,0,0,0,1},{1,0,0,0,1},{0,1,1,1,1},{0,0,0,0,1},{0,0,0,0,1},{1,0,0,0,1},{0,1,1,1,0},},
};


unsigned char MODE[10]={0x08,0x00,0x0a,0x01,0x0b,0x07,0x0c,0x01,0x0f,0x00};


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
void Init_MAX7219(void)
{
for(j=0;j<9;j+=2)
{digitalWrite(Max7219_pinCS,LOW);
 for(i=0;i<count;i++)
 Write_Max7219(MODE[j],MODE[j+1]);
 digitalWrite(Max7219_pinCS,HIGH);
 delay(50);
}
};


void DrawNum(unsigned char DATA[])
{unsigned char i;
for(i=0;i<5;i++)
{
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,DATA[i]);// Extracting a bit data
digitalWrite(Max7219_pinCLK,HIGH);
}
}

void Part1(unsigned char address,unsigned char DATA[][5])
{
unsigned char i;
for(i=0;i<3;i++)
{   
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,0);
digitalWrite(Max7219_pinCLK,HIGH);
}
DrawNum(DATA[address-1]);

}

void Part2(unsigned char address,unsigned char DATA[][5])
{
unsigned char i;       
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,LOW);
digitalWrite(Max7219_pinCLK,HIGH);
              
DrawNum(DATA[address-1]);

digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,LOW);
digitalWrite(Max7219_pinCLK,HIGH);

digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,((address==3||address==6)&&(dot&1))?HIGH:LOW);
digitalWrite(Max7219_pinCLK,HIGH);

}

void Part3(unsigned char address,unsigned char DATA[][5])
{
unsigned char i; 
  
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,((address==3||address==6)&&(dot&1))?HIGH:LOW);
digitalWrite(Max7219_pinCLK,HIGH);

digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,LOW);
digitalWrite(Max7219_pinCLK,HIGH);

DrawNum(DATA[address-1]);

digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,LOW);
digitalWrite(Max7219_pinCLK,HIGH);
}

void Part4(unsigned char address,unsigned char DATA[][5])
{
unsigned char i;
DrawNum(DATA[address-1]);
for(i=0;i<3;i++)
{   
digitalWrite(Max7219_pinCLK,LOW);
digitalWrite(Max7219_pinDIN,LOW);
digitalWrite(Max7219_pinCLK,HIGH);
} 
}

void setup() {

  pinMode(Max7219_pinCLK,OUTPUT);
  pinMode(Max7219_pinCS,OUTPUT);
  pinMode(Max7219_pinDIN,OUTPUT);
  delay(50);
  Init_MAX7219();
}


void loop() {

int hour1=6;
int hour2=9;
int min1=0;
int min2=8;
unsigned char i,j;
for(i=1;i<9;i++)
{
digitalWrite(Max7219_pinCS,LOW);
for(j=0;j<count;j++)
{
  Write_Max7219_byte(i);  
if(!(j>3&&j<8))
Write_Max7219_byte(0x00);
else if(j==4)Part1(i,num[hour1]);
else if(j==5)Part2(i,num[hour2]);
else if (j==6)Part3(i,num[min1]);
else Part4(i,num[min2]);
}
digitalWrite(Max7219_pinCS,HIGH);
}
dot++;
delay(800);      

}
