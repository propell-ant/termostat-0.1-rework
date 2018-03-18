/**************************************************************************\
 FILE ..........: KBD.C
 AUTHOR ........: Vitaly Puzrin
 DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
 NOTES .........:
 COPYRIGHT .....: Vitaly Puzrin, 1999
 HISTORY .......: DATE        COMMENT                    
                  ---------------------------------------------------
                  25.06.1999  Первая версия
\**************************************************************************/

#include    "kbd.h"
#include <tiny2313.h>

#if __CODEVISIONAVR__ > 2000
//проверка версии только для полной гарантии того, что 
//оригинальная версия исходника не затрагивается
extern BYTE View;
extern BYTE Counter;
extern WORD T_LoadOn;
extern WORD DeltaT;
extern void RefreshDisplay(void);
#endif

#define     ST_WAIT_KEY     0
#define     ST_CHECK_KEY    1
#define     ST_RELEASE_WAIT 2

#define     KEY_1      0x01    // Код клавиши 1
#define     KEY_2      0x02    // Код клавиши 2
#define     KEY_3      0x03    // Код клавиши 3

BOOLEAN btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
BYTE    byKeyCode;      // Код нажатой клавиши

BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
WORD    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши  
BYTE    byIterationCounter =  40;//Счётчик до повторения


#define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
#define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
#define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым

/**************************************************************************\
    Инициализация модуля (переменных и железа)
      Вход:  -
      Выход: -
\**************************************************************************/
void KbdInit(void)
{
    btKeyUpdate = FALSE;
    byScanState = ST_WAIT_KEY;
}

/**************************************************************************\
    Сканирование клавиатуры
      Вход:  -
      Выход: -
\**************************************************************************/
void ScanKbd(void)
{
    switch (byScanState)
    {
        case ST_WAIT_KEY:
            // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
            if (KeyCode != 0)
            {
                byCheckedKey = KeyCode;
                
                byCheckKeyCnt = PRESS_CNT;

                byScanState = ST_CHECK_KEY;
            }
            break;
            
        case ST_CHECK_KEY:
            // Если клавиша удердивалась достаточно долго, то
            // генерируем событие с кодом клавиши, и переходим к
            // ожиданию отпускания клавиши
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
            // Если данные неустойчитывы, то возвращается назад,
            // к ожиданию нажатия клавиши
            else
                byScanState = ST_WAIT_KEY;
            break;
            
        case ST_RELEASE_WAIT:
            // Пока клавиша не будет отпущена на достаточный интервал
            // времени, будем оставаться в этом состоянии
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
    Обработка нажатой клавиши.
      Вход:  -
      Выход: -
\**************************************************************************/
void ProcessKey(void)
{   
    switch (byKeyCode)
    {
        case KEY_1:                 // Была нажата клавиша Минус 
            switch (View)
            {
              case 0:               //если был режим "Текущая температура", то
                View = 1;           //переходим в режим "Установленная температура"
                Counter = 5;        //и взводим счётчик на 5 секунд.
              break;
              case 1:               //если мы в режиме "Установленная температура", то 
                if (T_LoadOn > 450) //если "Установленная температура" > -55°C, то 
                {
                  T_LoadOn --;      //уменьшаем значение на 0,1°
                  RefreshDisplay(); //обновляем данные на экране     
                }
                View = 1;           //удерживаем в режиме "Установленная температура"
                Counter = 5;        //и взводим счётчик на 5 секунд.
              break;
              case 2:               //если мы в режиме "Дэльта", то 
                if (DeltaT > 1)     //если "Дэльта" больше 0,1°, то 
                {
                  DeltaT --;        //уменьшаем Дэльту на 0,1°
                  RefreshDisplay(); //обновляем данные на экране
                }
                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
            }
            
        break;
            
        case KEY_2:                 // Была нажата клавиша Плюс 
            switch (View)
            {                       
              case 0:               //если был режим "Текущая температура", то
                View = 1;           //переходим в режим "Установленная температура"
                Counter = 5;        //и взводим счётчик на 5 секунд.
              break;
              case 1:               //если мы в режиме "Установленная температура", то
                if (T_LoadOn < (2250 - DeltaT))    //если температура ниже 125,0° - Дэельта
                {
                  T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1° 
                  RefreshDisplay(); //обновляем данные на экране    
                }             
                View = 1;           //удерживаем в режиме "Установленная температура"
                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
              case 2:
                if (DeltaT < 900) if ((T_LoadOn + DeltaT) < 2250)   //если Дельта меньше 90,0°, то
                {
                  DeltaT ++;        //то увеличиваем Дэльту на 0,1°
                  RefreshDisplay(); //обновляем данные на экране
                }
                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
            }
        break;  
        
        case KEY_3:               // Была нажаты обе кноки вместе.
            View = 2;              //переходим в режим "Дэльта"
            Counter = 5;           //и взводим счётчик ещё на 5 секунд.
        break;
                      
        default:
        break;
	
    }
    
}
