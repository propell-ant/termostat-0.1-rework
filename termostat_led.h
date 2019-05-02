#ifndef TERMOSTAT_LED_INCLUDED
#define TERMOSTAT_LED_INCLUDED

/*
Здесь задаются все константы, названия портов, включаются и выключаются опциональные блоки и т.п.
*/

#define Cathode           //раскоментировать, если индикатор с ОК
//#define Anode           //раскоментировать, если индикатор с ОА

#define heat            //точка отображается если T < Tуст.
//#define cold            //точка отображается если T > Tуст.

/*
 * Различные отключаемые опции
 * для включения опции нужно "раскомментировать", т.е. удалить 
 * символы "//" перед словом #define
 *
 */

// Опция отображения ошибок шины 1-wire
#define ShowDataErrors

// Опция отображения заставки (----) при включении термостата
#define ShowWelcomeScreen

// Опция подавления мерцания индикатора
#define EliminateFlicker

// Опция моргающей индикации при обнаружении ошибки
#define Blinking

// Опция настройки поправки к показаниям датчика
//#define CorCode

// Опция управления вентилятором отопительного котла
#define Vent

// Опция ненастраиваемой поправки (не забываем про формат записи значений, см. ниже), скобки не убираем
//#define CorT_Static (0)

// Опция входа в настройки нажатием на одну кнопку
#define ENTER_SETTINGS_BY_ONE_KEY

// Опция повышения точности измерений за счет более редкого опроса датчика
//#define PREVENT_SENSOR_SELF_HEATING

#ifndef PREVENT_SENSOR_SELF_HEATING
#define T1_PRESCALER 0x04
#define T1_OFFSET 0x85EE
#else
#define T1_PRESCALER 0x05
#define T1_OFFSET 0x39A5
#define T1_OFFSET_LONG 0xE17B
#endif
                 
enum{ //здесь хитрый способ расставить идентификаторы режимов отображения по порядку, не указывая явно номера
 SHOW_Normal  = 0
,SHOW_TLoadOn = 1
,SHOW_DeltaT  = 2
#ifdef CorCode
,SHOW_CorT
#endif
#ifdef Clock
,SHOW_Time
#endif
#ifdef Vent
,SHOW_DelayVent
#endif

//это должно оставаться последними строчками
#ifdef ShowDataErrors
,SHOW_Error
#endif
,View_Top
};
#define View_Max (View_Top-1)

//разряды индикатора
#define DISPLAY_PORT PORTD
#define DISPLAY_PINS PIND
#define DISPLAY_DDR  DDRD

#define MINUS_PIN_MASK_BASE 0b00000001
#define DOT_PIN_MASK_BASE 0b00000100
#define UNDERSCORE_PIN_MASK_BASE 0b00001000

#define DIGIT1 PORTC.2
#define DIGIT2 PORTC.1
#define DIGIT3 PORTC.0
#define DIGIT4 PORTC.3

#define OUTPIN_NO PORTB.3 // Нормально открытый выход
#define OUTPIN_NC PORTB.2 // Нормально закрытый выход
//таблица символов
#define SYMBOLS_LEN 16
#define SymbolsArray {\
0xFA,/*0*/\
0x82,/*1*/\
0xD9,/*2*/\
0xCB,/*3*/\
0xA3,/*4*/\
0x6B,/*5*/\
0x7B,/*6*/\
0xC2,/*7*/\
0xFB,/*8*/\
0xEB,/*9*/\
0x00,/*blank*/\
0x01,/*-*/\
0x9B,/*d*/\
/*0x79,//L*/\
0x78,/*C*/\
0x79,/*E*/\
0x39/*t*/\
/*0xB3,//H*/\
/*0x30,//I*/\
}; 
                
//температура представлена так:
//-55°C = -550
//-25°C = -250
//-10.1°C = -101
//0°C = 0
//10.1°C = 101
//25°C = 250
//85°C = 850
//125°C = 1250       

// Шаг изменения температуры при настройке
#define T_STEP 1
// Диапазоны допустимых значений настроек
#define TLoadOn_Default 280
#define TLoadOn_Min -550
#define TLoadOn_Max 1250

#define DeltaT_Default 10
#define DeltaT_Min 1
#define DeltaT_Max 250

#define CorT_Default 0
#define CorT_Min -99
#define CorT_Max 99      

#define DelayVent_Default 60
#define DelayVent_Min 0
#define DelayVent_Max 250      

#endif
