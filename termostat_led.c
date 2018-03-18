/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.5 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
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

#define Cathode           //раскоментировать, если индикатор с ОК
//#define Anode           //раскоментировать, если индикатор с ОА

#define heat              //точка отображается если T < Tуст.
//#define cold            //точка отображается если T > Tуст.
     
BYTE byDisplay[4];        // буфер данных, для вывода на экран     

BOOLEAN Updating;         //служебная переменная
BOOLEAN Minus;            //равна "1" если температура отрицательная
BOOLEAN LoadOn;           //равна "1" если включена нагрузка

BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
BYTE View = 0;            //определяет в каком режиме отображения находится устройство:
                          //0 - основной - Текущая температура
                          //1 - Установленная температура
                          //2 - Дэльта

WORD Tnew;                //для хранения нового значения измеренной температуры
WORD T_LoadOn;            //для хранения значения Установленной температуры
WORD DeltaT;              //для хранения значения Дэльты

eeprom WORD eeT_LoadOn = 1280;   //1280 = +28°C 1140 = +14°C 
eeprom WORD eeDeltaT = 10;       //1°C

//температура для удобства представлена так:
// - до 1000 = отрицательная
// - 1000 = 0
// - больше 1000 = положительная
// - 0,1°С = 1
//---------------------------------
//-55°C = 450
//-25°C = 750
//-10.1°C = 899
//0°C = 1000
//10.1°C = 1101
//25°C = 1250
//85°C = 1850
//125°C = 2250       


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
    
    if (D >= 1000) //если Температура больше нуля
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
    
    //Преобразуем в десятичное представление
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
  Вывод экранного буфера на дисплей.
      Вход:  -
      Выход: -
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
  Обновление дисплея.
      Вход:  -
      Выход: -
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

w1_init();              //инициализация шины 1-wire

for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
  {
    ShowDisplayData();
  }

w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"     
 
for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
  {
    ShowDisplayData();
  }

Updating = !Updating;   //это шоб читать температуру через раз

if (Updating)           //если в этот раз читаем температуру, то 
{
  w1_write(0xBE);       //выдаём в шину 1-wire код 0xCC, что значит "Read Scratchpad"
  
  for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
  {
    ShowDisplayData();
  }                      
  
  t1=w1_read();   //LSB //читаем младший байт данных
  
  for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
  {
    ShowDisplayData();
  }
  t2=w1_read();   //MSB //читаем старший байт данных     
  
  // значения из даташита (для проверки раскоментировать нужное значение)

  //+125°C
  //t2 = 0b00000111; //MSB
  //t1 = 0b11010000; //LSB
  
  //+85°C
  //t2 = 0b00000101; //MSB
  //t1 = 0b01010000; //LSB
  
  //+25.0625°C
  //t2 = 0b00000001; //MSB
  //t1 = 0b10010001; //LSB
  
  //+10.125°C
  //t2 = 0b00000000; //MSB
  //t1 = 0b10100010; //LSB
  
  //+0.5°C
  //t2 = 0b00000000; //MSB
  //t1 = 0b00001000; //LSB
  
  //0°C
  //t2 = 0b00000000; //MSB
  //t1 = 0b00000000; //LSB
  
  //-0.5°C
  //t2 = 0b11111111; //MSB
  //t1 = 0b11111000; //LSB
  
  //-10.125°C
  //t2 = 0b11111111; //MSB
  //t1 = 0b01011110; //LSB
  
  //-25.0625°C
  //t2 = 0b11111110; //MSB
  //t1 = 0b01101111; //LSB
  
  //-55°C
  //t2 = 0b11111100; //MSB
  //t1 = 0b10010000; //LSB

  
  
  
  Ff = (t1 & 0x0F);           //из LSB выделяем дробную часть значения температуры
  t2 = t2 << 4; 
  t1 = t1 >> 4;
  T = (t2 & 0xF0) | (t1 & 0x0F);    //после объедининия смещённых частей LSB и MSB объединяем 
                                    //их и получаем целую часть значения температуры.
                                    //подробней - смотри даташит.
  
  if (T & 0b10000000) //если отрицательная температура
  { 
    Ff = ~Ff + 1;         //инвертируем значение дробной части и добавляем адын.
    Ff = Ff & 0b00001111; //убираем лишние биты
    
    if (!Ff)              //если дробная часть равна "0"
    {
      T--;                //значение температуры уменьшаем на адын
    }   
    
    Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //вычисляем значение температуры если T < 0. 
                                                          //Формат хранения - смотри строку 58 этого файла.
  }
  else
  { 
    Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0. 
                                                          //Формат хранения - смотри строку 58 этого файла.
  }    
  Tnew = Tnew + 0; 
}
else
{
  w1_write(0x44);          //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
} 


Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.

if ((Tnew >= Temp) && (LoadOn)) //Если температура выше (установленной + Дэльта) и нагрузка включена,
{                              //то выключаем нагрузку
  PORTD.3 = 1;
  PORTD.2 = 0;              
  LoadOn = 0;
}             

Temp = T_LoadOn;                //Temp - временная переменная.

if ((Tnew <= Temp) && (!LoadOn)) //Если температура ниже (установленной) и нагрузка выключена,
{                               //то включаем нагрузку
  PORTD.3 = 0;
  PORTD.2 = 1;
  LoadOn = 1;  
} 

if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
{                               
  Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
}                               //присвоил ей значение отличное от "0". Значит надо екрементировать, 
else                            //пока не станет равной "0".
{
  View = 0;                     //если она =0, то сбрасываем текущий режим на "0"
}                                                           

RefreshDisplay();               //Обновление данных на индикаторе.

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

        //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
        //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
        //         если установлена 1 - то на выводе устанавливается лог. 1
        //         если установлена 0 - то на выводе устанавливается лог. 0
        //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
        //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
        
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

Tnew = 1000;                //Это чтобы на экране был "0.0" при включении питания

if ((eeT_LoadOn > 2250) | (eeT_LoadOn < 450))    //если в EEPROM значение > 2250 или < 450 значит он не прошился, или 
  eeT_LoadOn = 1280;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
if (eeDeltaT > 900)
  eeDeltaT = 10; 
  
T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM

RefreshDisplay();       //Обновление данных на индикаторе.

w1_init();              //инициализация шины 1-wire
w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
w1_write(0x44);         //выдаём в шину 1-wire код 0xCC, что значит "Convert T"

                        
KbdInit();              //инициализация клавиатуры :)

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      #asm("cli");               //запрещаем прерывания
      ShowDisplayData();         //обновляем экран
      #asm("sei");               //разрешаем прерывания
      };  
                          
}
