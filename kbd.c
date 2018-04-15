/**************************************************************************\
 FILE ..........: KBD.C
 AUTHOR ........: Vitaly Puzrin
 DESCRIPTION ...: ��������� ���������� (������������ � ������� �� �������)
 NOTES .........:
 COPYRIGHT .....: Vitaly Puzrin, 1999
 HISTORY .......: DATE        COMMENT                    
                  ---------------------------------------------------
                  25.06.1999  ������ ������
\**************************************************************************/

#include    "kbd.h"
#include <mega8.h>
#include "termostat_led.h"

#if __CODEVISIONAVR__ > 2000
//�������� ������ ������ ��� ������ �������� ����, ��� 
//������������ ������ ��������� �� �������������
extern BYTE View;
extern BYTE Counter;
extern int T_LoadOn;
extern int DeltaT; 
#ifdef CorCode
extern INT8 CorT;
#endif
extern void RefreshDisplay(void);
#endif
#ifdef Blinking                    
extern bit GoBlinking;
#endif

#define     KEY_1      0x01    // ��� ������� 1
#define     KEY_2      0x02    // ��� ������� 2
#define     KEY_3      0x03    // ��� ������� 3

bit btKeyUpdate;    // = 1, ����� ���������� ������� �� �������
BYTE    byKeyCode;      // ��� ������� �������

BYTE    byScanState;    // ��������� ��������� �������� ������ ����������
BYTE    byCheckedKey;   // �����. �����. ��� ����������� �������
BYTE    byCheckKeyCnt;  // �����. �����. ������� ������� �������/������� �������  
BYTE    byIterationCounter =  40;//������� �� ����������


#ifdef ORIG_PORT_MAP 
#define KeyCode     ((PINC & 0b00000011) ^ 0b00000011)  // ������, ������� ���������� ��� ������� �������
#endif
 
#ifdef DIP_COMPACT_PORT_MAP 
#define KeyCode     (((PINC >> 2) & 0b00000011) ^ 0b00000011)  
// ������� ��������� �� PORTC.2 � .3, ������� ���������� ������� ����� �� 2 ����
// ���������� ������������ � �������� ���������, �� �� �������-�� ������ ������
#endif 
#ifdef TQFP_PORT_MAP 
#define KeyCode     (((PINB >> 4) & 0b00000011) ^ 0b00000011)  
// ������� ��������� �� PORTB.4 � .5, ������� ���������� ������� ����� �� 4 ����
// ���������� ������������ � �������� ���������, �� �� �������-�� ������ ������
#endif 
#define PRESS_CNT   4   // �����, ������� ������� ������ ������������
#define RELEASE_CNT 4   // �����, ����� �������� ������� ��������� �������

/**************************************************************************\
    ������������� ������ (���������� � ������)
      ����:  -
      �����: -
\**************************************************************************/
// inline void KbdInit(void)
// {
//     btKeyUpdate = FALSE;
//     byScanState = ST_WAIT_KEY;
// }

/**************************************************************************\
    ������������ ����������
      ����:  -
      �����: -
\**************************************************************************/
void ScanKbd(void)
{
    switch (byScanState)
    {
        case ST_WAIT_KEY:
            // ���� ���������� ������� �� �������, �� ��������� � �� ��������.
            if (KeyCode != 0)
            {
                byCheckedKey = KeyCode;
                
                byCheckKeyCnt = PRESS_CNT;

                byScanState = ST_CHECK_KEY;
            }
            break;
            
        case ST_CHECK_KEY:
            // ���� ������� ������������ ���������� �����, ��
            // ���������� ������� � ����� �������, � ��������� �
            // �������� ���������� �������
            if (byCheckedKey == KeyCode)
            {
                byCheckKeyCnt--;
                if (!byCheckKeyCnt)
                {
                    btKeyUpdate = TRUE;
                    byKeyCode = byCheckedKey;
                    byScanState = ST_RELEASE_WAIT;
                    byCheckKeyCnt = RELEASE_CNT;   
                    byIterationCounter = PRESS_CNT * 20;
                }
            }
            // ���� ������ �������������, �� ������������ �����,
            // � �������� ������� �������
            else
                byScanState = ST_WAIT_KEY;
            break;
            
        case ST_RELEASE_WAIT:
            // ���� ������� �� ����� �������� �� ����������� ��������
            // �������, ����� ���������� � ���� ���������
            if (KeyCode != 0)
            {
                byCheckKeyCnt = RELEASE_CNT;                
                if (!byIterationCounter)
                {
                  byIterationCounter = PRESS_CNT * 2;   
                  btKeyUpdate = TRUE;               
                }                           
                byIterationCounter--;
            }
            else
            {
                byCheckKeyCnt--;    
                if (!byCheckKeyCnt)
                {
                    byScanState = ST_WAIT_KEY;
                    byIterationCounter = PRESS_CNT * 20;
                }
            }
            break;
    }        
    if( btKeyUpdate )
    {
      btKeyUpdate = FALSE;
      ProcessKey();            
    }
}

/**************************************************************************\
    ��������� ������� �������.
      ����:  -
      �����: -
\**************************************************************************/
void ProcessKey(void)
{   
    switch (byKeyCode)
    {
        case KEY_1:                 // ���� ������ ������� ����� 
            switch (View)
            {
//               case 0:               //���� ��� ����� "������� �����������", ��
//                 View = SHOW_TLoadOn;           //��������� � ����� "������������� �����������"
//                 Counter = 5;        //� ������� ������� �� 5 ������.
//               break;
              case SHOW_TLoadOn:               //���� �� � ������ "������������� �����������", �� 
                if (T_LoadOn > TLoadOn_Min) //���� "������������� �����������" > Min, �� 
                {
                  T_LoadOn -=5;      //��������� �������� �� 0,1�
//                  RefreshDisplay(); //��������� ������ �� ������     
                }
//                View = SHOW_TLoadOn;           //���������� � ������ "������������� �����������"
//                Counter = 5;        //� ������� ������� �� 5 ������.
              break;
              case 2:               //���� �� � ������ "������", �� 
                if (DeltaT > DeltaT_Min)     //���� "������" ������ Min, �� 
                {
                  DeltaT --;        //��������� ������ �� 0,1�
//                  RefreshDisplay(); //��������� ������ �� ������
                }
//                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
              #ifdef CorCode
              case 3:                   //���� �� � ������ "���������", ��
                if (CorT > CorT_Min)
                {
                    CorT--;         //��������� �������� �� 0,1�
                }
                break;
              #endif
            }
        break;
            
        case KEY_2:                 // ���� ������ ������� ���� 
            switch (View)
            {                       
//               case 0:               //���� ��� ����� "������� �����������", ��
//                 View = SHOW_TLoadOn;           //��������� � ����� "������������� �����������"
//                 Counter = 5;        //� ������� ������� �� 5 ������.
//               break;
              case 1:               //���� �� � ������ "������������� �����������", ��
                if (T_LoadOn < (TLoadOn_Max - DeltaT))    //���� ����������� ���� Max - ������
                {
                  T_LoadOn +=5;      //�� ����������� ������������� ����������� �� 0,1� 
//                  RefreshDisplay(); //��������� ������ �� ������    
                }             
//                View = SHOW_TLoadOn;           //���������� � ������ "������������� �����������"
//                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
              case 2:
                if (DeltaT < DeltaT_Max)   //���� ������ ������ Max, ��
                {
                  DeltaT ++;        //�� ����������� ������ �� 0,1�
//                  RefreshDisplay(); //��������� ������ �� ������
                }
//                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
              #ifdef CorCode
              case 3:                   //���� �� � ������ "���������", ��
                if (CorT < CorT_Max)
                {
                    CorT++;
                }
              break;
              #endif
            }
        break;  
        
        case KEY_3:               // ���� ������ ��� ����� ������.
          View++;
          if (View > View_Max) 
          {
            View = SHOW_TLoadOn;
          }       
//             switch (View)
//             {                       
//               case 0:               //���� ��� ����� "������� �����������", ��
//                 View = SHOW_TLoadOn;           //��������� � ����� "������������� �����������"
//               break;
//               case 1:               //���� �� � ������ "������������� �����������", ��
//                 View = SHOW_DeltaT;           //���������� � ������ "������"
//               break;
//               case 2:
//                 View = SHOW_Error;           //��������� � ����� "��������� ������������ ������"
//               break;
//               case 3:
//                 View = SHOW_TLoadOn;           //��������� � ����� "������������� �����������"
//               break;
//             }
//             Counter = 5;        //� ������� ������� �� 5 ������.
//             Counter = 5;        //� ������� ������� ��� �� 5 ������.
//             Counter = 5;        //� ������� ������� ��� �� 5 ������.
//            Counter = 5;        //� ������� ������� ��� �� 5 ������.
        break;
                      
        default:
        break;
	
    }
    Counter = 5;        //� ������� ������� ��� �� 5 ������.
    #ifdef Blinking                    
    GoBlinking = 0;
    #endif
    RefreshDisplay(); //��������� ������ �� ������
    
}
