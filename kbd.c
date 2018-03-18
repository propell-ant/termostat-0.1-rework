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
#include <tiny2313.h>

#if __CODEVISIONAVR__ > 2000
//�������� ������ ������ ��� ������ �������� ����, ��� 
//������������ ������ ��������� �� �������������
extern BYTE View;
extern BYTE Counter;
extern WORD T_LoadOn;
extern WORD DeltaT;
extern void RefreshDisplay(void);
#endif

#define     ST_WAIT_KEY     0
#define     ST_CHECK_KEY    1
#define     ST_RELEASE_WAIT 2

#define     KEY_1      0x01    // ��� ������� 1
#define     KEY_2      0x02    // ��� ������� 2
#define     KEY_3      0x03    // ��� ������� 3

BOOLEAN btKeyUpdate;    // = 1, ����� ���������� ������� �� �������
BYTE    byKeyCode;      // ��� ������� �������

BYTE    byScanState;    // ��������� ��������� �������� ������ ����������
BYTE    byCheckedKey;   // �����. �����. ��� ����������� �������
WORD    byCheckKeyCnt;  // �����. �����. ������� ������� �������/������� �������  
BYTE    byIterationCounter =  40;//������� �� ����������


#define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // ������, ������� ���������� ��� ������� �������
#define PRESS_CNT   4   // �����, ������� ������� ������ ������������
#define RELEASE_CNT 4   // �����, ����� �������� ������� ��������� �������

/**************************************************************************\
    ������������� ������ (���������� � ������)
      ����:  -
      �����: -
\**************************************************************************/
void KbdInit(void)
{
    btKeyUpdate = FALSE;
    byScanState = ST_WAIT_KEY;
}

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
              case 0:               //���� ��� ����� "������� �����������", ��
                View = 1;           //��������� � ����� "������������� �����������"
                Counter = 5;        //� ������� ������� �� 5 ������.
              break;
              case 1:               //���� �� � ������ "������������� �����������", �� 
                if (T_LoadOn > 450) //���� "������������� �����������" > -55�C, �� 
                {
                  T_LoadOn --;      //��������� �������� �� 0,1�
                  RefreshDisplay(); //��������� ������ �� ������     
                }
                View = 1;           //���������� � ������ "������������� �����������"
                Counter = 5;        //� ������� ������� �� 5 ������.
              break;
              case 2:               //���� �� � ������ "������", �� 
                if (DeltaT > 1)     //���� "������" ������ 0,1�, �� 
                {
                  DeltaT --;        //��������� ������ �� 0,1�
                  RefreshDisplay(); //��������� ������ �� ������
                }
                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
            }
            
        break;
            
        case KEY_2:                 // ���� ������ ������� ���� 
            switch (View)
            {                       
              case 0:               //���� ��� ����� "������� �����������", ��
                View = 1;           //��������� � ����� "������������� �����������"
                Counter = 5;        //� ������� ������� �� 5 ������.
              break;
              case 1:               //���� �� � ������ "������������� �����������", ��
                if (T_LoadOn < (2250 - DeltaT))    //���� ����������� ���� 125,0� - �������
                {
                  T_LoadOn ++;      //�� ����������� ������������� ����������� �� 0,1� 
                  RefreshDisplay(); //��������� ������ �� ������    
                }             
                View = 1;           //���������� � ������ "������������� �����������"
                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
              case 2:
                if (DeltaT < 900) if ((T_LoadOn + DeltaT) < 2250)   //���� ������ ������ 90,0�, ��
                {
                  DeltaT ++;        //�� ����������� ������ �� 0,1�
                  RefreshDisplay(); //��������� ������ �� ������
                }
                Counter = 5;        //� ������� ������� ��� �� 5 ������.
              break;
            }
        break;  
        
        case KEY_3:               // ���� ������ ��� ����� ������.
            View = 2;              //��������� � ����� "������"
            Counter = 5;           //� ������� ������� ��� �� 5 ������.
        break;
                      
        default:
        break;
	
    }
    
}
