#ifndef TERMOSTAT_LED_INCLUDED
#define TERMOSTAT_LED_INCLUDED

/*
����� �������� ��� ���������, �������� ������, ���������� � ����������� ������������ ����� � �.�.
*/

//#define Cathode           //����������������, ���� ��������� � ��
#define Anode           //����������������, ���� ��������� � ��

#define heat            //����� ������������ ���� T < T���.
//#define cold            //����� ������������ ���� T > T���.

/*
 * ��������� ����������� �����
 * ��� ��������� ����� ����� "�����������������", �.�. ������� 
 * ������� "//" ����� ������ #define
 *
 */

// ����� ����������� ������ ���� 1-wire
#define ShowDataErrors

// ����� ����������� �������� (----) ��� ��������� ����������
#define ShowWelcomeScreen

// ����� ���������� �������� ����������
#define EliminateFlicker

// ����� ��������� ��������� ��� ����������� ������
#define Blinking

// ����� ��������� �������� � ���������� �������
//#define CorCode

// ����� ��������������� �������� (�� �������� ��� ������ ������ ��������, ��. ����), ������ �� �������
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

//������� ����������
#define DISPLAY_PORT PORTD
#define DISPLAY_PINS PIND

#define MINUS_PIN_MASK_BASE 0b00000001
#define DOT_PIN_MASK_BASE 0b00000100
#define UNDERSCORE_PIN_MASK_BASE 0b00001000

#define DIGIT1 PORTC.2
#define DIGIT2 PORTC.1
#define DIGIT3 PORTC.0
#define DIGIT4 PORTC.3

#define OUTPIN_NO PORTB.3 // ��������� �������� �����
//#define OUTPIN_NC PORTB.4 // ��������� �������� ����� (�� ������������)

//������� ��������
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
                
//����������� ������������ ���:
//-55�C = -550
//-25�C = -250
//-10.1�C = -101
//0�C = 0
//10.1�C = 101
//25�C = 250
//85�C = 850
//125�C = 1250       

// ��������� ���������� �������� ��������
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
