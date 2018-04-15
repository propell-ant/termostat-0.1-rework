#ifndef TERMOSTAT_LED_INCLUDED
#define TERMOSTAT_LED_INCLUDED

/*
Здесь задаются все константы, названия портов, включаются и выключаются опциональные блоки и т.п.
*/

//#define Cathode           //раскоментировать, если индикатор с ОК
#define Anode           //раскоментировать, если индикатор с ОА

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

// Опция ненастраиваемой поправки (не забываем про формат записи значений, см. ниже), скобки не убираем
//#define CorT_Static (0)

#define PREVENT_SENSOR_SELF_HEATING

#ifndef PREVENT_SENSOR_SELF_HEATING
#define T1_PRESCALER 0x04
#define T1_OFFSET 0x85EE
#else
#define T1_PRESCALER 0x05
#define T1_OFFSET 0x39A5
#define T1_OFFSET_LONG 0xE17B
#endif
                 
#define View_Max 2
#define SHOW_Normal 0
#define SHOW_TLoadOn 1
#define SHOW_DeltaT 2


#ifdef CorCode
#define SHOW_CorT 3   
#undef View_Max
#define View_Max 3
#endif
#ifdef ShowDataErrors
#ifdef CorCode
#define SHOW_Error 4
#undef View_Max
#define View_Max 4
#else
#define SHOW_Error 3
#undef View_Max
#define View_Max 3
#endif
#endif

//#define ORIG_PORT_MAP 
//#define DIP_COMPACT_PORT_MAP  
#define TQFP_PORT_MAP // при использовании TQFP корпуса

//разряды индикатора
#ifdef ORIG_PORT_MAP  
#define DISPLAY_PORT PORTD
#define DISPLAY_PINS PIND

#define MINUS_PIN_MASK_BASE 0b00000001
#define DOT_PIN_MASK_BASE 0b00000100
#define UNDERSCORE_PIN_MASK_BASE 0b00001000

#define DIGIT1 PORTD.5
#define DIGIT2 PORTD.1
#define DIGIT3 PORTD.0
#define DIGIT4 PORTD.4

#define OUTPIN_NO PORTD.2 // Нормально открытый выход
//#define OUTPIN_NC PORTD.3 // Нормально закрытый выход
#endif
#ifdef DIP_COMPACT_PORT_MAP  
#define DISPLAY_PORT PORTD
#define DISPLAY_PINS PIND

#define MINUS_PIN_MASK_BASE 0b00000001
#define DOT_PIN_MASK_BASE 0b00000100
#define UNDERSCORE_PIN_MASK_BASE 0b00001000

#define DIGIT1 PORTD.5
#define DIGIT2 PORTD.7
#define DIGIT3 PORTD.6
#define DIGIT4 PORTD.4

#define OUTPIN_NO PORTC.1 // Нормально открытый выход
//#define OUTPIN_NC PORTC.4 // Нормально закрытый выход (не используется)
#endif
#ifdef TQFP_PORT_MAP
#define DISPLAY_PORT PORTD
#define DISPLAY_PINS PIND

#define MINUS_PIN_MASK_BASE 0b00000001
#define DOT_PIN_MASK_BASE 0b00000100
#define UNDERSCORE_PIN_MASK_BASE 0b00001000

#define DIGIT1 PORTC.2
#define DIGIT2 PORTC.1
#define DIGIT3 PORTC.0
#define DIGIT4 PORTC.3

#define OUTPIN_NO PORTB.3 // Нормально открытый выход
//#define OUTPIN_NC PORTB.4 // Нормально закрытый выход (не используется)
#endif

//таблица символов
#ifdef ORIG_PORT_MAP 
#define SYMBOLS_LEN 15
#define SymbolsArray {\
0b11111010,/*0xFA,   //0 */ \
0b10000010,/*0x82,   //1 */ \
0b10111001,/*0xB9,   //2 */ \
0b10101011,/*0xAB,	 //3 */ \
0b11000011,/*0xC3,   //4 */ \
0b01101011,/*0x6B,   //5 */ \
0b01111011,/*0x7B,   //6 */ \
0b10100010,/*0xA2,   //7 */ \
0b11111011,/*0xFB,   //8 */ \
0b11101011,/*0xEB,   //9 */ \
0b00000000,/*0x00,   //blank */ \
0b00000001,/*0x01,   //- */ \
/*0b01110000,//0x70,   //t */ \
0b10011011,/*0x9B,   //d */ \
/*0b01011000,//0x58,   //L */ \
0b01111000, /*0x78   //C  */ \
0b01111001 /*0x79    //E  */ \
}
#endif
#ifdef DIP_COMPACT_PORT_MAP 
#define SYMBOLS_LEN 15
#define SymbolsArray {\
0xFA,/*0*/\
0x22,/*1*/\
0xB9,/*2*/\
0xAB,/*3*/\ 
0x63,/*4*/\ 
0xCB,/*5*/\ 
0xDB,/*6*/\
0xA2,/*7*/\ 
0xFB,/*8*/\
0xEB,/*9*/\ 
0x00,/*blank*/\   
0x01,/*-*/\
/*0xD0,//t*/\
0x3B,/*d*/\
/*0x58,//L*/\
0xD0,/*C ??*/\
0x3B/*E ??*/\
}; 
#endif
#ifdef TQFP_PORT_MAP
#define SYMBOLS_LEN 15
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
/*0x39,//t*/\
0x9B,/*d*/\
/*0x79,//L*/\
0x78,/*C*/\
0x79/*E*/\
/*0xB3,//H*/\
/*0x30,//I*/\
}; 
#endif
                
//температура представлена так:
//-55°C = -550
//-25°C = -250
//-10.1°C = -101
//0°C = 0
//10.1°C = 101
//25°C = 250
//85°C = 850
//125°C = 1250       

// Диапазоны допустимых значений настроек
#define TLoadOn_Default 230
#define TLoadOn_Min -550
#define TLoadOn_Max 1250

#define DeltaT_Default 20
#define DeltaT_Min 1
#define DeltaT_Max 250

#define CorT_Default 0
#define CorT_Min -99
#define CorT_Max 99      

#endif
