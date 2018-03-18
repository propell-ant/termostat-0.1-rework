#ifndef TERMOSTAT_LED_INCLUDED
#define TERMOSTAT_LED_INCLUDED

/*
����� �������� ��� ���������, �������� ������, ���������� � ����������� ������������ ����� � �.�.
*/

/*
 * ��������� ����������� �����
 * ��� ��������� ����� ����� ������� 
 * ������� "//" ����� ������ #define
 *
 */

// ����� ����������� ������ ���� 1-wire
#define ShowDataErrors

// ����� ����������� �������� (----) ��� ��������� ����������
//#define ShowWelcomeScreen

// ����� ���������� �������� ����������
//#define NO_BLINK

// ����� ��������� ��������� � ������������ �������
//#define Blinking

// ����� ��������� �������� � ���������� �������
#define CorCode

// ����� ��������������� �������� (�� �������� ��� ������ ������ ��������, ��. ����), ������ �� �������
//#define CorT_Static (0)
                 
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
#define DIGIT1 PORTD.5
#define DIGIT2 PORTD.1
#define DIGIT3 PORTD.0
#define DIGIT4 PORTD.4

//������� ��������
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
#define TLoadOn_Default 280
#define TLoadOn_Min -550
#define TLoadOn_Max 1250

#define DeltaT_Default 10
#define DeltaT_Min 1
#define DeltaT_Max 250

#define CorT_Default 0
#define CorT_Min -99
#define CorT_Max 99      

#endif
