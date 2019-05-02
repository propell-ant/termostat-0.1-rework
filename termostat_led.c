/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.5 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.12.2014
Author  : propellant                           
Company : Hardlock                        
Comments: 


Chip type           : AMega8
Clock frequency     : 8,000000 MHz
*****************************************************/

#include <mega8.h>
#include <kbd.h>
#include "termostat_led.h" // поддержка нескольких вариантов печатной платы
#include <ds1820.h>
// 1 Wire Bus interface functions
#include <1wire.h>
                                                                                      
#define ONE_WIRE_PORTNAME PORTC
#define ONE_WIRE_PORTNUM 4
// 1 Wire Bus functions
#asm
   .equ __w1_port=0x15 ;PORTC
   .equ __w1_bit=4
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

// буфер данных, для вывода на экран
BYTE byDisplay[4]
#ifdef ShowWelcomeScreen
={11,11,11,11}
#endif
;
  
bit Updating;         //служебная переменная
//bit Minus;            //равна "1" если температура отрицательная
bit LoadOn;           //равна "1" если включена нагрузка
bit Initializing;        //равна "1" до получения первого значения температуры с датчика

#ifdef ShowDataErrors
bit AllDataFF;        
bit NonZero;
#endif

BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
BYTE View = SHOW_Normal;  //определяет в каком режиме отображения находится устройство:
                          //SHOW_Normal  - основной - Текущая температура
                          //SHOW_TLoadOn - Установленная температура
                          //SHOW_DeltaT  - Дэльта
                          //SHOW_CorT    - Поправка к показаниям датчика (если включена опция CorCode)
                          //SHOW_Error   - Код ошибки при наличии ошибки (если включена опция ShowDataErrors)

#define SwitchDelay DelayVent
BYTE LastSwitch;  
BYTE SwitchCommand;
#define COMMAND_EMPTY 0
#define COMMAND_ON 1
#define COMMAND_HOLD_ON 3
#define COMMAND_OFF 2
#define COMMAND_HOLD_OFF 4        

int Tnew;                //для хранения нового значения измеренной температуры
int T_LoadOn;            //для хранения значения Установленной температуры
int DeltaT;              //для хранения значения Дэльты
#ifdef CorCode
INT8 CorT;
#endif
#ifdef Vent
unsigned INT8 DelayVent;
#endif

#ifdef ShowDataErrors
#define W1_BUFFER_LEN 9
#else
#define W1_BUFFER_LEN 2
#endif
BYTE w1buffer[W1_BUFFER_LEN];//для хранения принятых с датчика данных

bit NeedResetLoad = 1;   //флаг для правильного возвращения состояния реле после исчезновения ошибки
#ifdef ShowDataErrors
BYTE ErrorLevel;         //для хранения номера последней обнаруженной ошибки передачи данных
BYTE ErrorCounter;       //для хранения количества обнаруженных ПОДРЯД ошибок, первая же удачная передача сбрасывает этот счетчик
#define MaxDataErrors 1  //количество игнорируемых ПОДРЯД-ошибок, по умолчанию 1, максимум 255
#endif 
#ifdef Blinking
bit GoBlinking = 0;   //флаг для мигания (отображения информации об ошибке)
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
BYTE BlinkCounter;                      //Счетчик моргания
#define BlinkCounterMask 0b00111111     //примерно 2 моргания в секунду
#define BlinkCounterHalfMask 0b00100000 //примерно 2 моргания в секунду
BYTE DimmerCounter;                     //Счетчик яркости, моргание будет с неполным отключением индикатора
bit DigitsActive = 0;                       
#define DimmerDivider 1 //Это регулировка яркости: 4 соответствует 60%, 2 - примерно 35%, 1 - 0%
#else
  #ifdef Cathode 
    #define DigitsActive 0
  #endif
  #ifdef Anode 
    #define DigitsActive 1
  #endif
#endif

#ifdef Anode
#define MINUS_PIN_MASK (~MINUS_PIN_MASK_BASE)
#define DOT_PIN_MASK (~DOT_PIN_MASK_BASE)
#define UNDERSCORE_PIN_MASK (~UNDERSCORE_PIN_MASK_BASE)
#endif
#ifdef Cathode
#define MINUS_PIN_MASK (MINUS_PIN_MASK_BASE)
#define DOT_PIN_MASK (DOT_PIN_MASK_BASE)
#define UNDERSCORE_PIN_MASK (UNDERSCORE_PIN_MASK_BASE)
#endif

//Это две переменные для "занимания места"
//чтобы данные, записанные предыдущей версией прошивки не влияли на новую версию
//(тип и формат хранения изменился)
eeprom WORD eeT_LoadOn0 = 1280;   //тут значение, которое не влияет ни на что
eeprom WORD eeDeltaT0 = 10;       //тут значение, которое не влияет ни на что

eeprom int eeT_LoadOn = TLoadOn_Default; 
eeprom int eeDeltaT = DeltaT_Default;
#ifdef CorCode
eeprom INT8 eeCorT = CorT_Default;
#endif
#ifdef Vent
eeprom unsigned INT8 eeDelayVent = DelayVent_Default;
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
        
    //Преобразуем в десятичное представление
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
        #ifdef Vent          
        case SHOW_DelayVent:
          byDisplay[0] = 15;//t     
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
  Обновление дисплея.
      Вход:  -
      Выход: -
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
      #ifdef Vent
      if (DelayVent != eeDelayVent)
        eeDelayVent = DelayVent;
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
#ifdef Vent
    case SHOW_DelayVent:
        Data = DelayVent;
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

  for (i=0; i<4; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
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
 
  DISPLAY_PORT = byCharacter[byDisplay[0]];
//   if (Minus)
//   {
//     PORTB = PINB | 0b00000001;
//   }                           
  #ifdef heat
  if (LoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
  }
  #endif
 
  #ifdef cold
  if (!LoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
  }
  #endif          
  if (View == SHOW_TLoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS | UNDERSCORE_PIN_MASK;
  }
  DIGIT1 = DigitsActive;
  delay_us(LED_delay);
  DIGIT1 = 1;    
     
  DISPLAY_PORT = byCharacter[byDisplay[1]];
  DIGIT2 = DigitsActive;
  delay_us(LED_delay);
  DIGIT2 = 1;
      
  DISPLAY_PORT = byCharacter[byDisplay[2]];
  if (View != SHOW_DelayVent)
  {
    DISPLAY_PORT |= DOT_PIN_MASK;
  }
  DIGIT3 = DigitsActive;
  delay_us(LED_delay);
  DIGIT3 = 1;
      
  DISPLAY_PORT = byCharacter[byDisplay[3]];
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
  DISPLAY_PORT = ~byCharacter[byDisplay[0]];  
//   if (Minus)
//   {
//     PORTB = PINB & 0b11111110;
//   }                           
  #ifdef heat
  if (LoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
  }           
  #endif
  
  #ifdef cold
  if (!LoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
  }           
  #endif
  if (View == SHOW_TLoadOn)
  {
    DISPLAY_PORT = DISPLAY_PINS & UNDERSCORE_PIN_MASK;
  } 
  DIGIT1 = DigitsActive;
  delay_us(LED_delay);
  DIGIT1 = 0;    
     
  DISPLAY_PORT = ~byCharacter[byDisplay[1]];
  DIGIT2 = DigitsActive;
  delay_us(LED_delay);
  DIGIT2 = 0;
      
  DISPLAY_PORT = ~byCharacter[byDisplay[2]];
  if (View != SHOW_DelayVent)
  {
    DISPLAY_PORT &= DOT_PIN_MASK;
  }
  DIGIT3 = DigitsActive;
  delay_us(LED_delay);
  DIGIT3 = 0;
      
  DISPLAY_PORT = ~byCharacter[byDisplay[3]];
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
#ifdef PREVENT_SENSOR_SELF_HEATING
if (Updating)           //если в этот раз читаем температуру, то 
{
TCNT1=T1_OFFSET_LONG;
}
else
{
TCNT1=T1_OFFSET;
}
#else
TCNT1=T1_OFFSET;
#endif
//TCNT1L=0xD1;
#ifdef EliminateFlicker
skipDelay = 1;
#endif
w1_init();              //инициализация шины 1-wire
ShowDisplayData11Times();

w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"     
ShowDisplayData11Times();

Updating = !Updating;   //это шоб читать температуру через раз
if (Updating)           //если в этот раз читаем температуру, то 
{
  w1_write(0xBE);       //выдаём в шину 1-wire код 0xBE, что значит "Read Scratchpad"
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
  Initializing = 0;//хватит показывать заставку
#ifdef ShowDataErrors
  i=w1_dow_crc8(w1buffer,8);
  if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
  {
    //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
    //то это просто некорректно закончилось измерение температуры
    i--;
  }
  if (NonZero == 0)
  {
    //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
    i--;
  }
  if (i != w1buffer[8])
  {
      //ошибка при передаче
      ErrorLevel = 1;//это просто сбой
      if (AllDataFF)
      {
      //это обрыв
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
//        Updating = 1;//на следующем шаге нужно послать команду ReadT
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
  RefreshDisplay();               //Обновление данных на индикаторе.
  #ifdef ShowDataErrors
  ErrorCounter = MaxDataErrors + 1;
  #endif                   
  #ifdef ShowDataErrors
  }
  #endif
}
else
{
  w1_write(0x44);          //выдаём в шину 1-wire код 0x44, что значит "Convert T"
} 

#ifdef ShowDataErrors
if (ErrorCounter == 0)
{
  #ifdef OUTPIN_NC
  //OUTPIN_NC = 0;
  if (OUTPIN_NC == 1 && SwitchCommand != COMMAND_OFF)
  {
    SwitchCommand = COMMAND_OFF; //запоминаем получение команды на выключение вентилятора, 
    LastSwitch = SwitchDelay;    //перезапускаем отсчет задержки
  }
  #endif
  OUTPIN_NO = 0;
  NeedResetLoad = 1;
  LoadOn = ShowDotWhenError;              
}
else
#endif 
//if (Updating)           //если в этот раз читаем температуру, то 
if (!Initializing)
{
Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.

if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
{                              //то выключаем нагрузку
  OUTPIN_NO = 0;              
  LoadOn = 0;
  SwitchCommand = COMMAND_OFF; //запоминаем получение команды на выключение вентилятора, 
//   if (NeedResetLoad)
//   {
//     LastSwitch = 0;    //после первого измерения выключаем вентилятор без задержки
//   }
//   else
//   {
    LastSwitch = SwitchDelay;    //перезапускаем отсчет задержки, при старте задержка будет отсчитываться при выключенном вентиляторе
//   }
  NeedResetLoad = 0;              
}             
Temp = T_LoadOn;                //Temp - временная переменная.

if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
{                               //то включаем нагрузку
  OUTPIN_NO = 1;
  LoadOn = 1;  
  NeedResetLoad = 0;              
  SwitchCommand = COMMAND_ON; //запоминаем получение команды на включение вентилятора, 
  LastSwitch = 0; // выполняем немедленно
} 
}//if errorCounter
switch (SwitchCommand ) 
{                              
  case COMMAND_OFF:    //Если прошла команда на выключение вентилятора
  if (LastSwitch == 0) //и отсчет задержки окончен,
  {                    //то выключаем вентилятор
    #ifdef OUTPIN_NC
    OUTPIN_NC = 0;
    #endif
    SwitchCommand = COMMAND_EMPTY;
  }
  break;
  case COMMAND_ON: //Если получена команда на включение вентилятора,                             
  #ifdef OUTPIN_NC //то включаем вентилятор
  OUTPIN_NC = 1;
  #endif
  SwitchCommand = COMMAND_EMPTY;            
  break;
}

if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
{                               
  Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
}                               //присвоил ей значение отличное от "0". Значит надо екрементировать, 
else                            //пока не станет равной "0".
{
  View = SHOW_Normal;                     //если она =0, то сбрасываем текущий режим на "0"
}                                                           
// обратный отсчет задержки                                                           
if (LastSwitch>0)
{
  LastSwitch--;
}                          
RefreshDisplay();               //Обновление данных на индикаторе.
#ifdef EliminateFlicker
skipDelay = 0;
#endif
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here


        //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
        //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
        //         если установлена 1 - то на выводе устанавливается лог. 1
        //         если установлена 0 - то на выводе устанавливается лог. 0
        //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
        //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
        
        PORTB=0b00110000; // нагрузку-выключить
        DDRB= 0b00111100; // весь порт кроме PORTC.1 (нагрузка) работает на вход (клавиши управления)
        
        DISPLAY_PORT=0b00000000;
        DISPLAY_DDR =0b11111111;
        
         
        #ifdef Cathode  
          PORTC=0b00001111; // разряды индикатора (PORTD.7,.6,.5,.4) поднять, клавиши (PORTD.2 и .3) - поднять
          DDRC= 0b00001111; // все регистры кроме 2 и 3 (две клавиши) работают на выход
          //PORTA=0b00000011; // разряд индикатора 4 (PORTA.0) поднять, 1wire (PORTA.1) - поднять
        #endif       
        #ifdef Anode  
          PORTC=0b00000000; // разряды индикатора (PORTD.7,.6,.5,.4) опустить, клавиши (PORTD.2 и .3) - поднять
          DDRC= 0b00001111; // все регистры кроме 2 и 3 (две клавиши) работают на выход
          //PORTA=0b00000010; // разряд индикатора 4 (PORTA.0) опустить, 1wire (PORTA.1) - поднять
        #endif
        //DDRA= 0b00000001; // PORTA.0 используется для управления индикатором, PORTA.1 - для 1wire

//выше уже проинициализировали
//#ifdef OUTPIN_NC
//OUTPIN_NC = 0;
//#endif             
//OUTPIN_NO = 0; 

SwitchCommand = COMMAND_EMPTY;
LastSwitch = 0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0=0x05;
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
TCCR1B=T1_PRESCALER;
TCNT1H=0xFF;
TCNT1L=0xFE;
// ICR1H=0x00;
// ICR1L=0x00;
// OCR1AH=0x00;
// OCR1AL=0x00;
// OCR1BH=0x00;
// OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x05;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

#ifdef Blinking
DimmerCounter = 0;
#endif
//Tnew = 0;                //Просто обнуляем, тыща больше не нужна

if (!(eeDeltaT + 1))//проверка на FFFF - значение после стирания EEPROM
{
  eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
  eeDeltaT = DeltaT_Default;  
  #ifdef CorCode
  eeCorT = CorT_Default;
  #endif
}

if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //если в EEPROM значение > Max или < Min значит он не прошился, или
  eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
  eeDeltaT = DeltaT_Default;  
#ifdef CorCode
if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не прошился, // mod by Grey4ip
  eeCorT = CorT_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod by Grey4ip
CorT = eeCorT;
#endif
#ifdef Vent
if ((eeDelayVent > DelayVent_Max) /*|| (eeDelayVent < DelayVent_Min)*/)    // если в EEPROM значение > MaxDelayVent или < MinDelayVent значит он не прошился, 
  eeDelayVent = DelayVent_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения.
DelayVent = eeDelayVent;
#endif
  
T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM

#ifdef ShowDataErrors
ErrorLevel = 0; 
ErrorCounter = 1;       //При включении обязательно показываем даже первую ошибку
#endif
#ifdef Blinking                    
GoBlinking = 0;
#endif
Initializing = 1;
LoadOn = ShowDotAtStartup;//Точка включения нагрузки не должна гореть при старте, но для cold и heat это разные значения 
RefreshDisplay();       //Обновление данных на индикаторе.

Updating = 1; // Теперь первое обращение к датчику будет ConvertT

KbdInit();              //инициализация клавиатуры

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      #asm("cli");               //запрещаем прерывания
      ShowDisplayData11Times();         //обновляем экран
      #asm("sei");               //разрешаем прерывания
      };  
                          
}
