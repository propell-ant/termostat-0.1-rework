#ifndef KBD_H
#define KBD_H           

#define    TRUE    (!FALSE)
#define    FALSE   0
#define    BYTE    unsigned char
#define    WORD    unsigned short int
#define    BOOLEAN char
#define    CARDINAL unsigned long int

struct SVars
{
  WORD _Tnew;
  WORD _T_LoadOn;
  WORD _DeltaT;
};

union SettingsU {
            WORD data[4];
            struct SVars vars;
            };

extern union SettingsU Settings;

//WORD Tnew;                //для хранения нового значения измеренной температуры
#define Tnew Settings.vars._Tnew
//WORD T_LoadOn;            //для хранения значения Установленной температуры
#define T_LoadOn Settings.vars._T_LoadOn
//WORD DeltaT;              //для хранения значения Дэльты
#define DeltaT Settings.vars._DeltaT

#define CorCode
#define MaxCorT 1100
#define MinCorT 900

extern BOOLEAN btKeyUpdate;     // = 1, когда обнаружено нажание на клавишу

/**************************************************************************\
    Инициализация модуля (переменных и железа)
      Вход:  -
      Выход: -
\**************************************************************************/
extern void KbdInit(void);

/**************************************************************************\
    Сканирование клавиатуры
      Вход:  -
      Выход: -
\**************************************************************************/
extern void ScanKbd(void);

/**************************************************************************\
    Обработка нажатой клавиши.
      Вход:  -
      Выход: -
\**************************************************************************/
extern void ProcessKey(void);

#endif // KBD_H
