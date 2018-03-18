#ifndef KBD_H
#define KBD_H           

#define    TRUE    (!FALSE)
#define    FALSE   0
#define    BYTE    unsigned char
#define    WORD    unsigned short int
#define    BOOLEAN char
#define    CARDINAL unsigned long int

extern bit btKeyUpdate;     // = 1, ����� ���������� ������� �� �������

/**************************************************************************\
    ������������� ������ (���������� � ������)
      ����:  -
      �����: -
\**************************************************************************/
extern void KbdInit(void);

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
