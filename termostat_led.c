/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.5 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.12.2014
Author  : propellant                           
Company : Hardlock                        
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 8,000000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 40
*****************************************************/

#include <tiny2313.h>
#include <kbd.h>
#include "termostat_led.h"

// 1 Wire Bus functions
#asm
   .equ __w1_port=0x12 ;PORTD
   .equ __w1_bit=6
#endasm
#include <1wire.h>
#include <delay.h>

#ifndef EliminateFlicker
#define LED_delay 150U    
#else
#define LED_delay 600U    
#define LED_delay_add 800U    
bit skipDelay = 1;
#endif

#ifdef heat
#define ShowDotAtStartup 0
#endif
#ifdef cold
#define ShowDotAtStartup 1
#endif
#ifndef ShowDotAtStartup
#define ShowDotAtStartup 0
#endif

// ����� ������, ��� ������ �� �����
BYTE byDisplay[4]
#ifdef ShowWelcomeScreen
={11,11,11,11}
#endif
;
  
bit Updating;         //��������� ����������
//bit Minus;            //����� "1" ���� ����������� �������������
bit LoadOn;           //����� "1" ���� �������� ��������
bit Initializing;        //����� "1" �� ��������� ������� �������� ����������� � �������

#ifdef ShowDataErrors
bit AllDataFF;        
bit NonZero;
#endif

BYTE Counter = 0;         //��������� ����������, ��� �������� ������� �������� � �������� ����� �����������
BYTE View = SHOW_Normal;  //���������� � ����� ������ ����������� ��������� ����������:
                          //SHOW_Normal  - �������� - ������� �����������
                          //SHOW_TLoadOn - ������������� �����������
                          //SHOW_DeltaT  - ������
                          //SHOW_CorT    - �������� � ���������� ������� (���� �������� ����� CorCode)
                          //SHOW_Error   - ��� ������ ��� ������� ������ (���� �������� ����� ShowDataErrors)

int Tnew;                //��� �������� ������ �������� ���������� �����������
int T_LoadOn;            //��� �������� �������� ������������� �����������
int DeltaT;              //��� �������� �������� ������
#ifdef CorCode
INT8 CorT;
#endif

#ifdef ShowDataErrors
#define W1_BUFFER_LEN 9
#else
#define W1_BUFFER_LEN 2
#endif
BYTE w1buffer[W1_BUFFER_LEN];//��� �������� �������� � ������� ������

bit NeedResetLoad = 1;   //���� ��� ����������� ����������� ��������� ���� ����� ������������ ������
#ifdef ShowDataErrors
BYTE ErrorLevel;         //��� �������� ������ ��������� ������������ ������ �������� ������
BYTE ErrorCounter;       //��� �������� ���������� ������������ ������ ������, ������ �� ������� �������� ���������� ���� �������
#define MaxDataErrors 1  //���������� ������������ ������-������, �� ��������� 1, �������� 255
#endif 
#ifdef Blinking
bit GoBlinking = 0;   //���� ��� ������� (����������� ���������� �� ������)
#endif 
#ifdef heat
#define ShowDotWhenError 0
#endif
#ifdef cold
#define ShowDotWhenError 1
#endif
#ifndef ShowDotWhenError
#define ShowDotWhenError 0
#endif

#ifdef Blinking
BYTE BlinkCounter;                      //������� ��������
#define BlinkCounterMask 0b00111111     //�������� 2 �������� � �������
#define BlinkCounterHalfMask 0b00100000 //�������� 2 �������� � �������
BYTE DimmerCounter;                     //������� �������, �������� ����� � �������� ����������� ����������
bit DigitsActive = 0;                       
#define DimmerDivider 1 //��� ����������� �������: 4 ������������� 60%, 2 - �������� 35%, 1 - 0%
#else
  #ifdef Cathode 
    #define DigitsActive 0
  #endif
  #ifdef Anode 
    #define DigitsActive 1
  #endif
#endif

//��� ��� ���������� ��� "��������� �����"
//����� ������, ���������� ���������� ������� �������� �� ������ �� ����� ������
//(��� � ������ �������� ���������)
eeprom WORD eeT_LoadOn0 = 1280;   //��� ��������, ������� �� ������ �� �� ���
eeprom WORD eeDeltaT0 = 10;       //��� ��������, ������� �� ������ �� �� ���

eeprom int eeT_LoadOn = TLoadOn_Default; 
eeprom int eeDeltaT = DeltaT_Default;
#ifdef CorCode
eeprom INT8 eeCorT = CorT_Default;
#endif
BYTE byCharacter[SYMBOLS_LEN] = SymbolsArray;

/************************************************************************\
\************************************************************************/
void PrepareData(int Data)
{
    BYTE i;
    int D;        
    if (Initializing)
    {
      return;
    }
    if (Data < 0)        
    {
      D = -Data;
    }
    else
    {
      D = Data;
    }
        
    //����������� � ���������� �������������
    for(i=0; i<4; i++)
    {
       byDisplay[3-i] = D % 10;
       D /= 10;
    }
    
    if (byDisplay[0] == 0)
    {
      byDisplay[0] = 10;
      if (byDisplay[1] == 0)
      {
        byDisplay[1] = 10;
      } 
    }   
    if (Data < 0)
    {
      byDisplay[0] = 11;
    }
    switch (View)
    {
        case SHOW_DeltaT:
          byDisplay[0] = 12;     
          break;
        #ifdef CorCode          
        case SHOW_CorT:
          byDisplay[0] = 13;     
          if (Data < 0)
          {
            byDisplay[1] = 11;
          }
          break;
        #endif
        #ifdef ShowDataErrors
        case SHOW_Error:
          byDisplay[0] = 14;     
          break;
        case SHOW_Normal:
          if (ErrorCounter == 0)
          {
            byDisplay[0] = 14;     
          }
          break;
        #endif
    }        

}

/************************************************************************\
  ���������� �������.
      ����:  -
      �����: -
\************************************************************************/
void RefreshDisplay(void)
{                                
  int Data; 
  switch (View)
  {
    case SHOW_Normal:
      #ifdef ShowDataErrors
      if (ErrorCounter == 0)
      {
        Data = ErrorLevel;
      }
      else
      #endif
      {
        Data = Tnew;
      } 
      if (T_LoadOn != eeT_LoadOn)
        eeT_LoadOn = T_LoadOn;
      if (DeltaT != eeDeltaT)
        eeDeltaT = DeltaT;
      #ifdef CorCode
      if (CorT != eeCorT)
        eeCorT = CorT;
      #endif
    break;
    case SHOW_TLoadOn:
      Data = T_LoadOn;
    break;
        
    case SHOW_DeltaT:
      Data = DeltaT;
    break;
#ifdef CorCode
    case SHOW_CorT:
        Data = CorT;
    break;
#endif
#ifdef ShowDataErrors
    case SHOW_Error:
        Data = ErrorLevel;
    break;
#endif
  }
      
  PrepareData(Data);      
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{                
// Reinitialize Timer 0 value
TCNT0=0xB5;
// if (BlinkCounter < 2 * BlinkHalfPeriod)
// {
#ifdef Blinking
  BlinkCounter++;
  BlinkCounter &= BlinkCounterMask;
#endif
//}
// else
// {
//   BlinkCounter = 0;
// }

ScanKbd();
}

void ShowDisplayData11Times(void)
{
  BYTE i; 
  #ifdef EliminateFlicker
  if (!skipDelay)
  {
    delay_us(LED_delay_add);
  }
  #endif

  for (i=0; i<4; i++)    //��� �� ������� ����������� ������ ���������� ����� 10 ���
  {
//    ShowDisplayData(); 
 #ifdef Cathode                     
  #ifdef Blinking                    
  //BYTE 
  DigitsActive = 0;
  DimmerCounter++;
//  if (BlinkCounter > BlinkHalfPeriod)
  if (BlinkCounter & BlinkCounterHalfMask)
  if (View == SHOW_Normal) 
  #ifdef Blinking 
  if (GoBlinking)
  #endif
  if (DimmerCounter % DimmerDivider == 0)
  {
    DigitsActive = 1;
  }              
  #endif        
 
  PORTB = byCharacter[byDisplay[0]];
//   if (Minus)
//   {
//     PORTB = PINB | 0b00000001;
//   }                           
  #ifdef heat
  if (LoadOn)
  {
    PORTB = PINB | 0b00000100;
  }
  #endif
 
  #ifdef cold
  if (!LoadOn)
  {
    PORTB = PINB | 0b00000100;
  }
  #endif          
  if (View == SHOW_TLoadOn)
  {
    PORTB = PINB | 0b00001000;
  }
  DIGIT1 = DigitsActive;
  delay_us(LED_delay);
  DIGIT1 = 1;    
     
  PORTB = byCharacter[byDisplay[1]];
  DIGIT2 = DigitsActive;
  delay_us(LED_delay);
  DIGIT2 = 1;
      
  PORTB = byCharacter[byDisplay[2]] | 0b00000100;
  DIGIT3 = DigitsActive;
  delay_us(LED_delay);
  DIGIT3 = 1;
      
  PORTB = byCharacter[byDisplay[3]];
  DIGIT4 = DigitsActive;
  delay_us(LED_delay);
  DIGIT4 = 1;
#endif

#ifdef Anode
  #ifdef Blinking                    
  //BYTE 
  DigitsActive = 1;
  DimmerCounter++;
//  if (BlinkCounter > BlinkHalfPeriod)
  if (BlinkCounter & BlinkCounterHalfMask)
  if (View == SHOW_Normal)
  #ifdef Blinking 
  if (GoBlinking)
  #endif
  if (DimmerCounter % DimmerDivider == 0)
  {
    DigitsActive = 0;
  }                      
  #endif        
  PORTB = ~byCharacter[byDisplay[0]];  
//   if (Minus)
//   {
//     PORTB = PINB & 0b11111110;
//   }                           
  #ifdef heat
  if (LoadOn)
  {
    PORTB = PINB & 0b11111011;
  }           
  #endif
  
  #ifdef cold
  if (!LoadOn)
  {
    PORTB = PINB & 0b11111011;
  }           
  #endif
  if (View == SHOW_TLoadOn)
  {
    PORTB = PINB & 0b11110111;
  } 
  DIGIT1 = DigitsActive;
  delay_us(LED_delay);
  DIGIT1 = 0;    
     
  PORTB = ~byCharacter[byDisplay[1]];
  DIGIT2 = DigitsActive;
  delay_us(LED_delay);
  DIGIT2 = 0;
      
  PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
  DIGIT3 = DigitsActive;
  delay_us(LED_delay);
  DIGIT3 = 0;
      
  PORTB = ~byCharacter[byDisplay[3]];
  DIGIT4 = DigitsActive;
  delay_us(LED_delay);
  DIGIT4 = 0;
#endif

  }
}

// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  BYTE i; 
  int Temp;
  int *val;
// Reinitialize Timer 1 value
TCNT1=0x85EE;
//TCNT1L=0xD1;
#ifdef EliminateFlicker
skipDelay = 1;
#endif
w1_init();              //������������� ���� 1-wire
ShowDisplayData11Times();

w1_write(0xCC);         //����� � ���� 1-wire ��� 0xCC, ��� ������ "Skip ROM"     
ShowDisplayData11Times();

Updating = !Updating;   //��� ��� ������ ����������� ����� ���
if (Updating)           //���� � ���� ��� ������ �����������, �� 
{
  w1_write(0xBE);       //����� � ���� 1-wire ��� 0xBE, ��� ������ "Read Scratchpad"
  ShowDisplayData11Times();
  
#ifdef ShowDataErrors
  AllDataFF = 1;
  NonZero = 0;
  for (i=0; i<W1_BUFFER_LEN; i++)
  {
    w1buffer[i]=w1_read();
    ShowDisplayData11Times();
    if (w1buffer[i] != 0xFF)
    {
      AllDataFF = 0;
    }
    if (w1buffer[i] != 0x00)
    {
      NonZero = 1;
    }
  }
#else
  for (i=0; i<W1_BUFFER_LEN; i++)
  {
    w1buffer[i]=w1_read();
  }
#endif                       
  Initializing = 0;//������ ���������� ��������
#ifdef ShowDataErrors
  i=w1_dow_crc8(w1buffer,8);
  if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
  {
    //��������� ������ ��������, �.�. ���� ����� ���������� ������ ������ �������� 85
    //�� ��� ������ ����������� ����������� ��������� �����������
    i--;
  }
  if (NonZero == 0)
  {
    //��������� ������ ��������, �.�. ������ �� ����� �������� ��� ����
    i--;
  }
  if (i != w1buffer[8])
  {
      //������ ��� ��������
      ErrorLevel = 1;//��� ������ ����
      if (AllDataFF)
      {
      //��� �����
        ErrorLevel = 2;
      }
      else
      {
        if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
        {
          ErrorLevel = 3;
        }
        if (NonZero == 0)
        {
          ErrorLevel = 4;
        }
      }
      if (ErrorCounter > 0)
      {
        ErrorCounter--;
      }
      if (ErrorCounter == 0)
      {
        #ifdef Blinking                    
        GoBlinking = 1;
        #endif
      }
  }
  else
  {
  #endif
  val = (int*)&w1buffer[0];
  Tnew =
  (*val) * 10 / 16
  #ifdef CorCode
  + CorT
  #endif
  #ifdef CorT_Static
  + CorT_Static
  #endif
  ;
  RefreshDisplay();               //���������� ������ �� ����������.
  #ifdef ShowDataErrors
  ErrorCounter = MaxDataErrors + 1;
  #endif                   
  #ifdef ShowDataErrors
  }
  #endif
}
else
{
  w1_write(0x44);          //����� � ���� 1-wire ��� 0x44, ��� ������ "Convert T"
} 

#ifdef ShowDataErrors
if (ErrorCounter == 0)
{
  PORTD.3 = 0;
  PORTD.2 = 0;
  NeedResetLoad = 1;
  LoadOn = ShowDotWhenError;              
}
else
#endif 
if (!Initializing)
{
Temp = T_LoadOn + DeltaT;      //Temp - ��������� ����������.

if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //���� ����������� ���� (������������� + ������) � �������� ��������,
{                              //�� ��������� ��������
  PORTD.2 = 0;              
  PORTD.3 = 1;
  LoadOn = 0;
  NeedResetLoad = 0;              
}             

Temp = T_LoadOn;                //Temp - ��������� ����������.

if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //���� ����������� ���� (�������������) � �������� ���������,
{                               //�� �������� ��������
  PORTD.3 = 0;
  PORTD.2 = 1;
  LoadOn = 1;  
  NeedResetLoad = 0;              
} 
}//if errorCounter

if (Counter > 0)                //Counter - ���������� ��� �������� ������� ����������� ��������� �������
{                               
  Counter --;                   //���� ��� ������ "0", �� ������ ���-�� ���������� ����� ����������� �
}                               //�������� �� �������� �������� �� "0". ������ ���� ���������������, 
else                            //���� �� ������ ������ "0".
{
  View = SHOW_Normal;                     //���� ��� =0, �� ���������� ������� ����� �� "0"
}                                                           
RefreshDisplay();               //���������� ������ �� ����������.
#ifdef EliminateFlicker
skipDelay = 0;
#endif
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
          PORTD=0b01110011;
          DDRD= 0b00111111;
        #endif
        
        #ifdef Anode  
          PORTD=0b01000000;
          DDRD= 0b00111111;
        #endif

//���� ��� �������������������
//PORTD.3 = 0;
//PORTD.2 = 0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=0x00;
// OCR0A=0x00;
// OCR0B=0x00;

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
TCNT1H=0xFF;
TCNT1L=0xFE;
// ICR1H=0x00;
// ICR1L=0x00;
// OCR1AH=0x00;
// OCR1AL=0x00;
// OCR1BH=0x00;
// OCR1BL=0x00;

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

#ifdef Blinking
DimmerCounter = 0;
#endif
//Tnew = 0;                //������ ��������, ���� ������ �� �����

if (!(eeDeltaT + 1))//�������� �� FFFF - �������� ����� �������� EEPROM
{
  eeT_LoadOn = TLoadOn_Default;                             //��-�� ���������, ������� ������� ���� ��������� ��������.
  eeDeltaT = DeltaT_Default;  
  #ifdef CorCode
  eeCorT = CorT_Default;
  #endif
}

if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //���� � EEPROM �������� > Max ��� < Min ������ �� �� ��������, ���
  eeT_LoadOn = TLoadOn_Default;                             //��-�� ���������, ������� ������� ���� ��������� ��������.
if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
  eeDeltaT = DeltaT_Default;  
#ifdef CorCode
if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // ���� � EEPROM �������� > MaxCorT�C ��� < MinCorT�C ������ �� �� ��������, // mod by Grey4ip
  eeCorT = CorT_Default;                        // ��� ��-�� ���������, ������� ������� ���� ��������� ��������. // mod by Grey4ip
CorT = eeCorT;
#endif
  
T_LoadOn = eeT_LoadOn;  //������ �������� ������������� ����������� �� EEPROM � RAM
DeltaT = eeDeltaT;      //������ �������� ������ �� EEPROM � RAM

#ifdef ShowDataErrors
ErrorLevel = 0; 
ErrorCounter = 1;       //��� ��������� ����������� ���������� ���� ������ ������
#endif
#ifdef Blinking                    
GoBlinking = 0;
#endif
Initializing = 1;
LoadOn = ShowDotAtStartup;//����� ��������� �������� �� ������ ������ ��� ������, �� ��� cold � heat ��� ������ �������� 
RefreshDisplay();       //���������� ������ �� ����������.

Updating = 1; // ������ ������ ��������� � ������� ����� ConvertT

KbdInit();              //������������� ����������

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      #asm("cli");               //��������� ����������
      ShowDisplayData11Times();         //��������� �����
      #asm("sei");               //��������� ����������
      };  
                          
}
