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
#include <mega8.h>
#include "termostat_led.h"

#if __CODEVISIONAVR__ > 2000
//проверка версии только для полной гарантии того, что 
//оригинальная версия исходника не затрагивается
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

#define     KEY_1      0x01    // Код клавиши 1
#define     KEY_2      0x02    // Код клавиши 2
#define     KEY_3      0x03    // Код клавиши 3

bit btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
BYTE    byKeyCode;      // Код нажатой клавиши

BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
BYTE    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши  
BYTE    byIterationCounter =  40;//Счётчик до повторения


#ifdef ORIG_PORT_MAP 
#define KeyCode     ((PINC & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
#endif
 
#ifdef DIP_COMPACT_PORT_MAP 
#define KeyCode     (((PINC >> 2) & 0b00000011) ^ 0b00000011)  
// Клавиши назначены на PORTC.2 и .3, поэтому достаточно сделать сдвиг на 2 бита
// Получилось единообразно с исходным вариантом, но на сколько-то тактов дольше
#endif 
#ifdef TQFP_PORT_MAP 
#define KeyCode     (((PINB >> 4) & 0b00000011) ^ 0b00000011)  
// Клавиши назначены на PORTB.4 и .5, поэтому достаточно сделать сдвиг на 4 бита
// Получилось единообразно с исходным вариантом, но на сколько-то тактов дольше
#endif 
#define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
#define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым

/**************************************************************************\
    Инициализация модуля (переменных и железа)
      Вход:  -
      Выход: -
\**************************************************************************/
// inline void KbdInit(void)
// {
//     btKeyUpdate = FALSE;
//     byScanState = ST_WAIT_KEY;
// }

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
//               case 0:               //если был режим "Текущая температура", то
//                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
//                 Counter = 5;        //и взводим счётчик на 5 секунд.
//               break;
              case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то 
                if (T_LoadOn > TLoadOn_Min) //если "Установленная температура" > Min, то 
                {
                  T_LoadOn -=5;      //уменьшаем значение на 0,1°
//                  RefreshDisplay(); //обновляем данные на экране     
                }
//                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
//                Counter = 5;        //и взводим счётчик на 5 секунд.
              break;
              case 2:               //если мы в режиме "Дэльта", то 
                if (DeltaT > DeltaT_Min)     //если "Дэльта" больше Min, то 
                {
                  DeltaT --;        //уменьшаем Дэльту на 0,1°
//                  RefreshDisplay(); //обновляем данные на экране
                }
//                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
              #ifdef CorCode
              case 3:                   //если мы в режиме "Коррекции", то
                if (CorT > CorT_Min)
                {
                    CorT--;         //уменьшаем значение на 0,1°
                }
                break;
              #endif
            }
        break;
            
        case KEY_2:                 // Была нажата клавиша Плюс 
            switch (View)
            {                       
//               case 0:               //если был режим "Текущая температура", то
//                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
//                 Counter = 5;        //и взводим счётчик на 5 секунд.
//               break;
              case 1:               //если мы в режиме "Установленная температура", то
                if (T_LoadOn < (TLoadOn_Max - DeltaT))    //если температура ниже Max - Дельта
                {
                  T_LoadOn +=5;      //то увеличиваем Установленную температуру на 0,1° 
//                  RefreshDisplay(); //обновляем данные на экране    
                }             
//                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
//                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
              case 2:
                if (DeltaT < DeltaT_Max)   //если Дельта меньше Max, то
                {
                  DeltaT ++;        //то увеличиваем Дэльту на 0,1°
//                  RefreshDisplay(); //обновляем данные на экране
                }
//                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
              break;
              #ifdef CorCode
              case 3:                   //если мы в режиме "Коррекции", то
                if (CorT < CorT_Max)
                {
                    CorT++;
                }
              break;
              #endif
            }
        break;  
        
        case KEY_3:               // Была нажаты обе кноки вместе.
          View++;
          if (View > View_Max) 
          {
            View = SHOW_TLoadOn;
          }       
//             switch (View)
//             {                       
//               case 0:               //если был режим "Текущая температура", то
//                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
//               break;
//               case 1:               //если мы в режиме "Установленная температура", то
//                 View = SHOW_DeltaT;           //удерживаем в режиме "Дэльта"
//               break;
//               case 2:
//                 View = SHOW_Error;           //переходим в режим "Последняя обнаруженная ошибка"
//               break;
//               case 3:
//                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
//               break;
//             }
//             Counter = 5;        //и взводим счётчик на 5 секунд.
//             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
//             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
//            Counter = 5;        //и взводим счётчик ещё на 5 секунд.
        break;
                      
        default:
        break;
	
    }
    Counter = 5;        //и взводим счётчик ещё на 5 секунд.
    #ifdef Blinking                    
    GoBlinking = 0;
    #endif
    RefreshDisplay(); //обновляем данные на экране
    
}
