/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.5 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 15.10.2008
Author  : Yurik                           
Company : Hardlock                        
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 8,000000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>
#include <kbd.h>

// 1 Wire Bus functions
#asm
   .equ __w1_port=0x12 ;PORTD
   .equ __w1_bit=6
#endasm
#include <1wire.h>
#include <delay.h>

#define LED_delay 150    

#define Cathode           //����������������, ���� ��������� � ��
//#define Anode           //����������������, ���� ��������� � ��

#define heat              //����� ������������ ���� T < T���.
//#define cold            //����� ������������ ���� T > T���.
     
BYTE byDisplay[4];        // ����� ������, ��� ������ �� �����     

BOOLEAN Updating;         //��������� ����������
BOOLEAN Minus;            //����� "1" ���� ����������� �������������
BOOLEAN LoadOn;           //����� "1" ���� �������� ��������

BYTE Counter = 0;         //��������� ����������, ��� �������� ������� �������� � �������� ����� �����������
BYTE View = 0;            //���������� � ����� ������ ����������� ��������� ����������:
                          //0 - �������� - ������� �����������
                          //1 - ������������� �����������
                          //2 - ������

WORD Tnew;                //��� �������� ������ �������� ���������� �����������
WORD T_LoadOn;            //��� �������� �������� ������������� �����������
WORD DeltaT;              //��� �������� �������� ������

eeprom WORD eeT_LoadOn = 1280;   //1280 = +28�C 1140 = +14�C 
eeprom WORD eeDeltaT = 10;       //1�C

//����������� ��� �������� ������������ ���:
// - �� 1000 = �������������
// - 1000 = 0
// - ������ 1000 = �������������
// - 0,1�� = 1
//---------------------------------
//-55�C = 450
//-25�C = 750
//-10.1�C = 899
//0�C = 1000
//10.1�C = 1101
//25�C = 1250
//85�C = 1850
//125�C = 2250       


BYTE byCharacter[15] = {0xFA,     //0
                0x82,   //1
 	        0xB9,   //2
	        0xAB,	//3 
	        0xC3,     //4 
	        0x6B,     //5 
	        0x7B,     //6
                0xA2,    //7 
                0xFB,      //8
                0xEB,      //9 
                0x00,      //blank   
                0x01,     //-
                0x70,     //t
                0x9B,     //d
                0x58      //L
                }; 



/************************************************************************\
\************************************************************************/
void PrepareData(unsigned int Data)
{
    BYTE i;
    unsigned int D, D1;        
    D = Data;                           
    
    if (D >= 1000) //���� ����������� ������ ����
    {
      D = D - 1000;  
      Minus = 0;
    }
    else
    {
      D = 1000 - D; 
      Minus = 1;
    }          
    D1 = D;
    
    //����������� � ���������� �������������
    for(i=0; i<4; i++)
    {
       byDisplay[3-i] = D % 10;
       D /= 10;
    }
    
    if (D1 < 100)
    {
      byDisplay[0] = 10;
      byDisplay[1] = 10;

      goto exit;
    }   
    if ((D1 >= 100) & (D1 <1000))
    {
      byDisplay[0] = 10;
      goto exit;
    }
                    
exit:  
  if (View == 2)
  {
    byDisplay[0] = 13;     
  }
    
}

/************************************************************************\
  ����� ��������� ������ �� �������.
      ����:  -
      �����: -
\************************************************************************/
void ShowDisplayData(void)
{                      
 #ifdef Cathode                     
 
  PORTB = byCharacter[byDisplay[0]];
  if (Minus)
  {
    PORTB = PINB | 0b00000001;
  }                           
  #ifdef heat
  if (LoadOn)
  #endif
  
  #ifdef cold
  if (!LoadOn)
  #endif
  {
    PORTB = PINB | 0b00000100;
  }           
  if (View == 1)
  {
    PORTB = PINB | 0b00001000;
  }
  PORTD.5 = 0;
  delay_us(LED_delay);
  PORTD.5 = 1;    
     
  PORTB = byCharacter[byDisplay[1]];
  PORTD.1 = 0;
  delay_us(LED_delay);
  PORTD.1 = 1;
      
  PORTB = byCharacter[byDisplay[2]] | 0b00000100;
  PORTD.0 = 0;
  delay_us(LED_delay);
  PORTD.0 = 1;
      
  PORTB = byCharacter[byDisplay[3]];
  PORTD.4 = 0;
  delay_us(LED_delay);
  PORTD.4 = 1;
#endif

#ifdef Anode
  PORTB = ~byCharacter[byDisplay[0]];  
  if (Minus)
  {
    PORTB = PINB & 0b11111110;
  }                           
  #ifdef heat
  if (LoadOn)
  #endif
  
  #ifdef cold
  if (!LoadOn)
  #endif
  {
    PORTB = PINB & 0b11111011;
  }           
  if (View == 1)
  {
    PORTB = PINB & 0b11110111;
  } 
  PORTD.5 = 1;
  delay_us(LED_delay);
  PORTD.5 = 0;    
     
  PORTB = ~byCharacter[byDisplay[1]];
  PORTD.1 = 1;
  delay_us(LED_delay);
  PORTD.1 = 0;
      
  PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
  PORTD.0 = 1;
  delay_us(LED_delay);
  PORTD.0 = 0;
      
  PORTB = ~byCharacter[byDisplay[3]];
  PORTD.4 = 1;
  delay_us(LED_delay);
  PORTD.4 = 0;
#endif
 
  
  }


/************************************************************************\
  ���������� �������.
      ����:  -
      �����: -
\************************************************************************/
void RefreshDisplay(void)
{                                
  WORD Data; 
  switch (View)
  {
    case 0:
      Data = Tnew; 
      if (T_LoadOn != eeT_LoadOn)
        eeT_LoadOn = T_LoadOn;
      if (DeltaT != eeDeltaT)
        eeDeltaT = DeltaT;
    break;
    case 1:
      Data = T_LoadOn;
    break;
        
    case 2:
      Data = DeltaT + 1000; 
    break;
  }
      
  PrepareData(Data);      
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{                
// Reinitialize Timer 0 value
TCNT0=0xBF;

ScanKbd();
}

// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  BYTE t1;
  BYTE t2;
  BYTE i; 
  WORD Temp;
  WORD T;
  BYTE Ff;
// Reinitialize Timer 1 value
TCNT1H=0x8F;
TCNT1L=0xD1;

w1_init();              //������������� ���� 1-wire

for (i=0; i<11; i++)    //��� �� ������� ����������� ������ ���������� ����� 10 ���
  {
    ShowDisplayData();
  }

w1_write(0xCC);         //����� � ���� 1-wire ��� 0xCC, ��� ������ "Skip ROM"     
 
for (i=0; i<11; i++)    //��� �� ������� ����������� ������ ���������� ����� 10 ���
  {
    ShowDisplayData();
  }

Updating = !Updating;   //��� ��� ������ ����������� ����� ���

if (Updating)           //���� � ���� ��� ������ �����������, �� 
{
  w1_write(0xBE);       //����� � ���� 1-wire ��� 0xCC, ��� ������ "Read Scratchpad"
  
  for (i=0; i<11; i++)  //��� �� ������� ����������� ������ ���������� ����� 10 ���
  {
    ShowDisplayData();
  }                      
  
  t1=w1_read();   //LSB //������ ������� ���� ������
  
  for (i=0; i<11; i++)  //��� �� ������� ����������� ������ ���������� ����� 10 ���
  {
    ShowDisplayData();
  }
  t2=w1_read();   //MSB //������ ������� ���� ������     
  
  // �������� �� �������� (��� �������� ���������������� ������ ��������)

  //+125�C
  //t2 = 0b00000111; //MSB
  //t1 = 0b11010000; //LSB
  
  //+85�C
  //t2 = 0b00000101; //MSB
  //t1 = 0b01010000; //LSB
  
  //+25.0625�C
  //t2 = 0b00000001; //MSB
  //t1 = 0b10010001; //LSB
  
  //+10.125�C
  //t2 = 0b00000000; //MSB
  //t1 = 0b10100010; //LSB
  
  //+0.5�C
  //t2 = 0b00000000; //MSB
  //t1 = 0b00001000; //LSB
  
  //0�C
  //t2 = 0b00000000; //MSB
  //t1 = 0b00000000; //LSB
  
  //-0.5�C
  //t2 = 0b11111111; //MSB
  //t1 = 0b11111000; //LSB
  
  //-10.125�C
  //t2 = 0b11111111; //MSB
  //t1 = 0b01011110; //LSB
  
  //-25.0625�C
  //t2 = 0b11111110; //MSB
  //t1 = 0b01101111; //LSB
  
  //-55�C
  //t2 = 0b11111100; //MSB
  //t1 = 0b10010000; //LSB

  
  
  
  Ff = (t1 & 0x0F);           //�� LSB �������� ������� ����� �������� �����������
  t2 = t2 << 4; 
  t1 = t1 >> 4;
  T = (t2 & 0xF0) | (t1 & 0x0F);    //����� ����������� ��������� ������ LSB � MSB ���������� 
                                    //�� � �������� ����� ����� �������� �����������.
                                    //��������� - ������ �������.
  
  if (T & 0b10000000) //���� ������������� �����������
  { 
    Ff = ~Ff + 1;         //����������� �������� ������� ����� � ��������� ����.
    Ff = Ff & 0b00001111; //������� ������ ����
    
    if (!Ff)              //���� ������� ����� ����� "0"
    {
      T--;                //�������� ����������� ��������� �� ����
    }   
    
    Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //��������� �������� ����������� ���� T < 0. 
                                                          //������ �������� - ������ ������ 58 ����� �����.
  }
  else
  { 
    Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //��������� �������� ����������� ���� � > 0. 
                                                          //������ �������� - ������ ������ 58 ����� �����.
  }    
  Tnew = Tnew + 0; 
}
else
{
  w1_write(0x44);          //����� � ���� 1-wire ��� 0xCC, ��� ������ "Convert T"
} 


Temp = T_LoadOn + DeltaT;      //Temp - ��������� ����������.

if ((Tnew >= Temp) && (LoadOn)) //���� ����������� ���� (������������� + ������) � �������� ��������,
{                              //�� ��������� ��������
  PORTD.3 = 1;
  PORTD.2 = 0;              
  LoadOn = 0;
}             

Temp = T_LoadOn;                //Temp - ��������� ����������.

if ((Tnew <= Temp) && (!LoadOn)) //���� ����������� ���� (�������������) � �������� ���������,
{                               //�� �������� ��������
  PORTD.3 = 0;
  PORTD.2 = 1;
  LoadOn = 1;  
} 

if (Counter > 0)                //Counter - ���������� ��� �������� ������� ����������� ��������� �������
{                               
  Counter --;                   //���� ��� ������ "0", �� ������ ���-�� ���������� ����� ����������� �
}                               //�������� �� �������� �������� �� "0". ������ ���� ���������������, 
else                            //���� �� ������ ������ "0".
{
  View = 0;                     //���� ��� =0, �� ���������� ������� ����� �� "0"
}                                                           

RefreshDisplay();               //���������� ������ �� ����������.

}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

        //������ DDRx - ���������� ����������� �������� ������ (0 - ����, 1 - �����).
        //������ PORTx - ���� ����� ��������� ������� (DDRx = 1), ��:
        //         ���� ����������� 1 - �� �� ������ ��������������� ���. 1
        //         ���� ����������� 0 - �� �� ������ ��������������� ���. 0
        //    ���� ����� ��������� ������ (DDRx = 0), �� PORTx - ���������� ��������� �������������� ��������� (��� PORTx = 1 �������� ���������)
        //������ PINx - �������� ������ ��� ������ � �������� ���������� �������� ������ �����
        
        PORTA=0b00000011;
        DDRA= 0b00000000;
        
        PORTB=0b00000000;
        DDRB= 0b11111111;
        
         
        #ifdef Cathode  
          PORTD=0b01110111;
          DDRD= 0b00111111;
        #endif
        
        #ifdef Anode  
          PORTD=0b01000100;
          DDRD= 0b00111111;
        #endif


PORTD.3 = 1;
PORTD.2 = 0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x04;
TCNT1H=0x03;
TCNT1L=0xD1;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x82;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

Tnew = 1000;                //��� ����� �� ������ ��� "0.0" ��� ��������� �������

if ((eeT_LoadOn > 2250) | (eeT_LoadOn < 450))    //���� � EEPROM �������� > 2250 ��� < 450 ������ �� �� ��������, ��� 
  eeT_LoadOn = 1280;                             //��-�� ���������, ������� ������� ���� ��������� ��������.
if (eeDeltaT > 900)
  eeDeltaT = 10; 
  
T_LoadOn = eeT_LoadOn;  //������ �������� ������������� ����������� �� EEPROM � RAM
DeltaT = eeDeltaT;      //������ �������� ������ �� EEPROM � RAM

RefreshDisplay();       //���������� ������ �� ����������.

w1_init();              //������������� ���� 1-wire
w1_write(0xCC);         //����� � ���� 1-wire ��� 0xCC, ��� ������ "Skip ROM"
w1_write(0x44);         //����� � ���� 1-wire ��� 0xCC, ��� ������ "Convert T"

                        
KbdInit();              //������������� ���������� :)

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      #asm("cli");               //��������� ����������
      ShowDisplayData();         //��������� �����
      #asm("sei");               //��������� ����������
      };  
                          
}
