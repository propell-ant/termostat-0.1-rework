#ifndef KBD_H
#define KBD_H           

#define    TRUE    (!FALSE)
#define    FALSE   0
#define    BYTE    unsigned char
#define    WORD    unsigned short int
#define    BOOLEAN char
#define    CARDINAL unsigned long int

#define     ST_WAIT_KEY     0
#define     ST_CHECK_KEY    1
#define     ST_RELEASE_WAIT 2

extern BYTE    byScanState;    // ��������� ��������� �������� ������ ����������

extern bit btKeyUpdate;     // = 1, ����� ���������� ������� �� �������

/**************************************************************************\
    ������������� ������ (���������� � ������)
      ����:  -
      �����: -
\**************************************************************************/
//extern void KbdInit(void);
#define KbdInit(dummy) btKeyUpdate = FALSE; byScanState = ST_WAIT_KEY;
/**************************************************************************\
    ������������ ����������
      ����:  -
      �����: -
\**************************************************************************/
extern void ScanKbd(void);

/**************************************************************************\
    ��������� ������� �������.
      ����:  -
      �����: -
\**************************************************************************/
extern void ProcessKey(void);

#endif // KBD_H
