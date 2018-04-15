
;CodeVisionAVR C Compiler V3.12 Evaluation
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 40 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0028
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Counter=R3
	.DEF _View=R2
	.DEF _Tnew=R4
	.DEF _Tnew_msb=R5
	.DEF _T_LoadOn=R6
	.DEF _T_LoadOn_msb=R7
	.DEF _DeltaT=R8
	.DEF _DeltaT_msb=R9
	.DEF _ErrorLevel=R11
	.DEF _ErrorCounter=R10
	.DEF _BlinkCounter=R13
	.DEF _DimmerCounter=R12

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x82
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0xB,0xB,0xB,0xB
_0x4:
	.DB  0xFA,0x82,0xB9,0xAB,0xC3,0x6B,0x7B,0xA2
	.DB  0xFB,0xEB,0x0,0x1,0x9B,0x78,0x79
_0x20003:
	.DB  0x28

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _byDisplay
	.DW  _0x3*2

	.DW  0x0F
	.DW  _byCharacter
	.DW  _0x4*2

	.DW  0x01
	.DW  _byIterationCounter
	.DW  _0x20003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR1_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x88

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.5 Professional
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 22.12.2014
;Author  : propellant
;Company : Hardlock
;Comments:
;
;
;Chip type           : ATtiny2313
;Clock frequency     : 8,000000 MHz
;Memory model        : Tiny
;External SRAM size  : 0
;Data Stack size     : 40
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <kbd.h>
;#include "termostat_led.h"
;
;// 1 Wire Bus functions
;#asm
   .equ __w1_port=0x12 ;PORTD
   .equ __w1_bit=6
; 0000 001F #endasm
;#include <1wire.h>
;#include <delay.h>
;
;#ifndef EliminateFlicker
;#define LED_delay 150U
;#else
;#define LED_delay 600U
;#define LED_delay_add 800U
;bit skipDelay = 1;
;#endif
;
;#ifdef heat
;#define ShowDotAtStartup 0
;#endif
;#ifdef cold
;#define ShowDotAtStartup 1
;#endif
;#ifndef ShowDotAtStartup
;#define ShowDotAtStartup 0
;#endif
;
;// буфер данных, для вывода на экран
;BYTE byDisplay[4]
; 0000 0037 #ifdef ShowWelcomeScreen
; 0000 0038 ={11,11,11,11}

	.DSEG
;#endif
;;
;
;bit Updating;         //служебная переменная
;//bit Minus;            //равна "1" если температура отрицательная
;bit LoadOn;           //равна "1" если включена нагрузка
;bit Initializing;        //равна "1" до получения первого значения температуры с датчика
;
;#ifdef ShowDataErrors
;bit AllDataFF;
;bit NonZero;
;#endif
;
;BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;BYTE View = SHOW_Normal;  //определяет в каком режиме отображения находится устройство:
;                          //SHOW_Normal  - основной - Текущая температура
;                          //SHOW_TLoadOn - Установленная температура
;                          //SHOW_DeltaT  - Дэльта
;                          //SHOW_CorT    - Поправка к показаниям датчика (если включена опция CorCode)
;                          //SHOW_Error   - Код ошибки при наличии ошибки (если включена опция ShowDataErrors)
;
;int Tnew;                //для хранения нового значения измеренной температуры
;int T_LoadOn;            //для хранения значения Установленной температуры
;int DeltaT;              //для хранения значения Дэльты
;#ifdef CorCode
;INT8 CorT;
;#endif
;
;#ifdef ShowDataErrors
;#define W1_BUFFER_LEN 9
;#else
;#define W1_BUFFER_LEN 2
;#endif
;BYTE w1buffer[W1_BUFFER_LEN];//для хранения принятых с датчика данных
;
;bit NeedResetLoad = 1;   //флаг для правильного возвращения состояния реле после исчезновения ошибки
;#ifdef ShowDataErrors
;BYTE ErrorLevel;         //для хранения номера последней обнаруженной ошибки передачи данных
;BYTE ErrorCounter;       //для хранения количества обнаруженных ПОДРЯД ошибок, первая же удачная передача сбрасывает это ...
;#define MaxDataErrors 1  //количество игнорируемых ПОДРЯД-ошибок, по умолчанию 1, максимум 255
;#endif
;#ifdef Blinking
;bit GoBlinking = 0;   //флаг для мигания (отображения информации об ошибке)
;#endif
;#ifdef heat
;#define ShowDotWhenError 0
;#endif
;#ifdef cold
;#define ShowDotWhenError 1
;#endif
;#ifndef ShowDotWhenError
;#define ShowDotWhenError 0
;#endif
;
;#ifdef Blinking
;BYTE BlinkCounter;                      //Счетчик моргания
;#define BlinkCounterMask 0b00111111     //примерно 2 моргания в секунду
;#define BlinkCounterHalfMask 0b00100000 //примерно 2 моргания в секунду
;BYTE DimmerCounter;                     //Счетчик яркости, моргание будет с неполным отключением индикатора
;bit DigitsActive = 0;
;#define DimmerDivider 1 //Это регулировка яркости: 4 соответствует 60%, 2 - примерно 35%, 1 - 0%
;#else
;  #ifdef Cathode
;    #define DigitsActive 0
;  #endif
;  #ifdef Anode
;    #define DigitsActive 1
;  #endif
;#endif
;
;#ifdef Anode
;#define MINUS_PIN_MASK (~MINUS_PIN_MASK_BASE)
;#define DOT_PIN_MASK (~DOT_PIN_MASK_BASE)
;#define UNDERSCORE_PIN_MASK (~UNDERSCORE_PIN_MASK_BASE)
;#endif
;#ifdef Cathode
;#define MINUS_PIN_MASK (MINUS_PIN_MASK_BASE)
;#define DOT_PIN_MASK (DOT_PIN_MASK_BASE)
;#define UNDERSCORE_PIN_MASK (UNDERSCORE_PIN_MASK_BASE)
;#endif
;
;//Это две переменные для "занимания места"
;//чтобы данные, записанные предыдущей версией прошивки не влияли на новую версию
;//(тип и формат хранения изменился)
;eeprom WORD eeT_LoadOn0 = 1280;   //тут значение, которое не влияет ни на что
;eeprom WORD eeDeltaT0 = 10;       //тут значение, которое не влияет ни на что
;
;eeprom int eeT_LoadOn = TLoadOn_Default;
;eeprom int eeDeltaT = DeltaT_Default;
;#ifdef CorCode
;eeprom INT8 eeCorT = CorT_Default;
;#endif
;BYTE byCharacter[SYMBOLS_LEN] = SymbolsArray;
;
;/************************************************************************\
;\************************************************************************/
;void PrepareData(int Data)
; 0000 009A {

	.CSEG
_PrepareData:
; .FSTART _PrepareData
; 0000 009B     BYTE i;
; 0000 009C     int D;
; 0000 009D     if (Initializing)
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR4
;	Data -> Y+4
;	i -> R17
;	D -> R18,R19
	SBIC 0x13,4
; 0000 009E     {
; 0000 009F       return;
	RJMP _0x2000001
; 0000 00A0     }
; 0000 00A1     if (Data < 0)
	LDD  R26,Y+5
	TST  R26
	BRPL _0x6
; 0000 00A2     {
; 0000 00A3       D = -Data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __ANEGW1
	MOVW R18,R30
; 0000 00A4     }
; 0000 00A5     else
	RJMP _0x7
_0x6:
; 0000 00A6     {
; 0000 00A7       D = Data;
	__GETWRS 18,19,4
; 0000 00A8     }
_0x7:
; 0000 00A9 
; 0000 00AA     //Преобразуем в десятичное представление
; 0000 00AB     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
; 0000 00AC     {
; 0000 00AD        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21
	MOV  R26,R16
	ST   X,R30
; 0000 00AE        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21
	MOVW R18,R30
; 0000 00AF     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 00B0 
; 0000 00B1     if (byDisplay[0] == 0)
	LDS  R30,_byDisplay
	CPI  R30,0
	BRNE _0xB
; 0000 00B2     {
; 0000 00B3       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
; 0000 00B4       if (byDisplay[1] == 0)
	__GETB1MN _byDisplay,1
	CPI  R30,0
	BRNE _0xC
; 0000 00B5       {
; 0000 00B6         byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
; 0000 00B7       }
; 0000 00B8     }
_0xC:
; 0000 00B9     if (Data < 0)
_0xB:
	LDD  R26,Y+5
	TST  R26
	BRPL _0xD
; 0000 00BA     {
; 0000 00BB       byDisplay[0] = 11;
	LDI  R30,LOW(11)
	STS  _byDisplay,R30
; 0000 00BC     }
; 0000 00BD     switch (View)
_0xD:
	MOV  R30,R2
; 0000 00BE     {
; 0000 00BF         case SHOW_DeltaT:
	CPI  R30,LOW(0x2)
	BRNE _0x11
; 0000 00C0           byDisplay[0] = 12;
	LDI  R30,LOW(12)
	RJMP _0x9E
; 0000 00C1           break;
; 0000 00C2         #ifdef CorCode
; 0000 00C3         case SHOW_CorT:
; 0000 00C4           byDisplay[0] = 13;
; 0000 00C5           if (Data < 0)
; 0000 00C6           {
; 0000 00C7             byDisplay[1] = 11;
; 0000 00C8           }
; 0000 00C9           break;
; 0000 00CA         #endif
; 0000 00CB         #ifdef ShowDataErrors
; 0000 00CC         case SHOW_Error:
_0x11:
	CPI  R30,LOW(0x3)
	BREQ _0x9F
; 0000 00CD           byDisplay[0] = 14;
; 0000 00CE           break;
; 0000 00CF         case SHOW_Normal:
	CPI  R30,0
	BRNE _0x10
; 0000 00D0           if (ErrorCounter == 0)
	TST  R10
	BRNE _0x14
; 0000 00D1           {
; 0000 00D2             byDisplay[0] = 14;
_0x9F:
	LDI  R30,LOW(14)
_0x9E:
	STS  _byDisplay,R30
; 0000 00D3           }
; 0000 00D4           break;
_0x14:
; 0000 00D5         #endif
; 0000 00D6     }
_0x10:
; 0000 00D7 
; 0000 00D8 }
_0x2000001:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;/************************************************************************\
;  Обновление дисплея.
;      Вход:  -
;      Выход: -
;\************************************************************************/
;void RefreshDisplay(void)
; 0000 00E0 {
_RefreshDisplay:
; .FSTART _RefreshDisplay
; 0000 00E1   int Data;
; 0000 00E2   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R2
; 0000 00E3   {
; 0000 00E4     case SHOW_Normal:
	CPI  R30,0
	BRNE _0x18
; 0000 00E5       #ifdef ShowDataErrors
; 0000 00E6       if (ErrorCounter == 0)
	TST  R10
	BRNE _0x19
; 0000 00E7       {
; 0000 00E8         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
; 0000 00E9       }
; 0000 00EA       else
	RJMP _0x1A
_0x19:
; 0000 00EB       #endif
; 0000 00EC       {
; 0000 00ED         Data = Tnew;
	MOVW R16,R4
; 0000 00EE       }
_0x1A:
; 0000 00EF       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x1B
; 0000 00F0         eeT_LoadOn = T_LoadOn;
	MOVW R30,R6
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRW
; 0000 00F1       if (DeltaT != eeDeltaT)
_0x1B:
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1C
; 0000 00F2         eeDeltaT = DeltaT;
	MOVW R30,R8
	RCALL SUBOPT_0x2
	RCALL __EEPROMWRW
; 0000 00F3       #ifdef CorCode
; 0000 00F4       if (CorT != eeCorT)
; 0000 00F5         eeCorT = CorT;
; 0000 00F6       #endif
; 0000 00F7     break;
_0x1C:
	RJMP _0x17
; 0000 00F8     case SHOW_TLoadOn:
_0x18:
	CPI  R30,LOW(0x1)
	BRNE _0x1D
; 0000 00F9       Data = T_LoadOn;
	MOVW R16,R6
; 0000 00FA     break;
	RJMP _0x17
; 0000 00FB 
; 0000 00FC     case SHOW_DeltaT:
_0x1D:
	CPI  R30,LOW(0x2)
	BRNE _0x1E
; 0000 00FD       Data = DeltaT;
	MOVW R16,R8
; 0000 00FE     break;
	RJMP _0x17
; 0000 00FF #ifdef CorCode
; 0000 0100     case SHOW_CorT:
; 0000 0101         Data = CorT;
; 0000 0102     break;
; 0000 0103 #endif
; 0000 0104 #ifdef ShowDataErrors
; 0000 0105     case SHOW_Error:
_0x1E:
	CPI  R30,LOW(0x3)
	BRNE _0x17
; 0000 0106         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
; 0000 0107     break;
; 0000 0108 #endif
; 0000 0109   }
_0x17:
; 0000 010A 
; 0000 010B   PrepareData(Data);
	MOVW R26,R16
	RCALL _PrepareData
; 0000 010C }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0110 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x3
; 0000 0111 // Reinitialize Timer 0 value
; 0000 0112 TCNT0=0xB5;
	LDI  R30,LOW(181)
	OUT  0x32,R30
; 0000 0113 // if (BlinkCounter < 2 * BlinkHalfPeriod)
; 0000 0114 // {
; 0000 0115 #ifdef Blinking
; 0000 0116   BlinkCounter++;
	INC  R13
; 0000 0117   BlinkCounter &= BlinkCounterMask;
	LDI  R30,LOW(63)
	AND  R13,R30
; 0000 0118 #endif
; 0000 0119 //}
; 0000 011A // else
; 0000 011B // {
; 0000 011C //   BlinkCounter = 0;
; 0000 011D // }
; 0000 011E 
; 0000 011F ScanKbd();
	RCALL _ScanKbd
; 0000 0120 }
	RJMP _0xA1
; .FEND
;
;void ShowDisplayData11Times(void)
; 0000 0123 {
_ShowDisplayData11Times:
; .FSTART _ShowDisplayData11Times
; 0000 0124   BYTE i;
; 0000 0125   #ifdef EliminateFlicker
; 0000 0126   if (!skipDelay)
	ST   -Y,R17
;	i -> R17
	SBIC 0x13,1
	RJMP _0x20
; 0000 0127   {
; 0000 0128     delay_us(LED_delay_add);
	__DELAY_USW 1600
; 0000 0129   }
; 0000 012A   #endif
; 0000 012B 
; 0000 012C   for (i=0; i<4; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
_0x20:
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x23
; 0000 012D   {
; 0000 012E //    ShowDisplayData();
; 0000 012F  #ifdef Cathode
; 0000 0130   #ifdef Blinking
; 0000 0131   //BYTE
; 0000 0132   DigitsActive = 0;
	CBI  0x14,1
; 0000 0133   DimmerCounter++;
	INC  R12
; 0000 0134 //  if (BlinkCounter > BlinkHalfPeriod)
; 0000 0135   if (BlinkCounter & BlinkCounterHalfMask)
	SBRS R13,5
	RJMP _0x26
; 0000 0136   if (View == SHOW_Normal)
	TST  R2
	BRNE _0x27
; 0000 0137   #ifdef Blinking
; 0000 0138   if (GoBlinking)
	SBIS 0x14,0
	RJMP _0x28
; 0000 0139   #endif
; 0000 013A   if (DimmerCounter % DimmerDivider == 0)
	MOV  R26,R12
	LDI  R30,LOW(0)
	CPI  R30,0
	BRNE _0x29
; 0000 013B   {
; 0000 013C     DigitsActive = 1;
	SBI  0x14,1
; 0000 013D   }
; 0000 013E   #endif
; 0000 013F 
; 0000 0140   DISPLAY_PORT = byCharacter[byDisplay[0]];
_0x29:
_0x28:
_0x27:
_0x26:
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x4
; 0000 0141 //   if (Minus)
; 0000 0142 //   {
; 0000 0143 //     PORTB = PINB | 0b00000001;
; 0000 0144 //   }
; 0000 0145   #ifdef heat
; 0000 0146   if (LoadOn)
; 0000 0147   {
; 0000 0148     DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
; 0000 0149   }
; 0000 014A   #endif
; 0000 014B 
; 0000 014C   #ifdef cold
; 0000 014D   if (!LoadOn)
	SBIC 0x13,3
	RJMP _0x2C
; 0000 014E   {
; 0000 014F     DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
	IN   R30,0x16
	ORI  R30,4
	OUT  0x18,R30
; 0000 0150   }
; 0000 0151   #endif
; 0000 0152   if (View == SHOW_TLoadOn)
_0x2C:
	LDI  R30,LOW(1)
	CP   R30,R2
	BRNE _0x2D
; 0000 0153   {
; 0000 0154     DISPLAY_PORT = DISPLAY_PINS | UNDERSCORE_PIN_MASK;
	IN   R30,0x16
	ORI  R30,8
	OUT  0x18,R30
; 0000 0155   }
; 0000 0156   DIGIT1 = DigitsActive;
_0x2D:
	SBIC 0x14,1
	RJMP _0x2E
	CBI  0x12,5
	RJMP _0x2F
_0x2E:
	SBI  0x12,5
_0x2F:
; 0000 0157   delay_us(LED_delay);
	RCALL SUBOPT_0x5
; 0000 0158   DIGIT1 = 1;
	SBI  0x12,5
; 0000 0159 
; 0000 015A   DISPLAY_PORT = byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x4
; 0000 015B   DIGIT2 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x32
	CBI  0x12,1
	RJMP _0x33
_0x32:
	SBI  0x12,1
_0x33:
; 0000 015C   delay_us(LED_delay);
	RCALL SUBOPT_0x5
; 0000 015D   DIGIT2 = 1;
	SBI  0x12,1
; 0000 015E 
; 0000 015F   DISPLAY_PORT = byCharacter[byDisplay[2]] | DOT_PIN_MASK;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	ORI  R30,4
	OUT  0x18,R30
; 0000 0160   DIGIT3 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x36
	CBI  0x12,0
	RJMP _0x37
_0x36:
	SBI  0x12,0
_0x37:
; 0000 0161   delay_us(LED_delay);
	RCALL SUBOPT_0x5
; 0000 0162   DIGIT3 = 1;
	SBI  0x12,0
; 0000 0163 
; 0000 0164   DISPLAY_PORT = byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x4
; 0000 0165   DIGIT4 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x3A
	CBI  0x12,4
	RJMP _0x3B
_0x3A:
	SBI  0x12,4
_0x3B:
; 0000 0166   delay_us(LED_delay);
	RCALL SUBOPT_0x5
; 0000 0167   DIGIT4 = 1;
	SBI  0x12,4
; 0000 0168 #endif
; 0000 0169 
; 0000 016A #ifdef Anode
; 0000 016B   #ifdef Blinking
; 0000 016C   //BYTE
; 0000 016D   DigitsActive = 1;
; 0000 016E   DimmerCounter++;
; 0000 016F //  if (BlinkCounter > BlinkHalfPeriod)
; 0000 0170   if (BlinkCounter & BlinkCounterHalfMask)
; 0000 0171   if (View == SHOW_Normal)
; 0000 0172   #ifdef Blinking
; 0000 0173   if (GoBlinking)
; 0000 0174   #endif
; 0000 0175   if (DimmerCounter % DimmerDivider == 0)
; 0000 0176   {
; 0000 0177     DigitsActive = 0;
; 0000 0178   }
; 0000 0179   #endif
; 0000 017A   DISPLAY_PORT = ~byCharacter[byDisplay[0]];
; 0000 017B //   if (Minus)
; 0000 017C //   {
; 0000 017D //     PORTB = PINB & 0b11111110;
; 0000 017E //   }
; 0000 017F   #ifdef heat
; 0000 0180   if (LoadOn)
; 0000 0181   {
; 0000 0182     DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
; 0000 0183   }
; 0000 0184   #endif
; 0000 0185 
; 0000 0186   #ifdef cold
; 0000 0187   if (!LoadOn)
; 0000 0188   {
; 0000 0189     DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
; 0000 018A   }
; 0000 018B   #endif
; 0000 018C   if (View == SHOW_TLoadOn)
; 0000 018D   {
; 0000 018E     DISPLAY_PORT = DISPLAY_PINS & UNDERSCORE_PIN_MASK;
; 0000 018F   }
; 0000 0190   DIGIT1 = DigitsActive;
; 0000 0191   delay_us(LED_delay);
; 0000 0192   DIGIT1 = 0;
; 0000 0193 
; 0000 0194   DISPLAY_PORT = ~byCharacter[byDisplay[1]];
; 0000 0195   DIGIT2 = DigitsActive;
; 0000 0196   delay_us(LED_delay);
; 0000 0197   DIGIT2 = 0;
; 0000 0198 
; 0000 0199   DISPLAY_PORT = ~byCharacter[byDisplay[2]] & DOT_PIN_MASK;
; 0000 019A   DIGIT3 = DigitsActive;
; 0000 019B   delay_us(LED_delay);
; 0000 019C   DIGIT3 = 0;
; 0000 019D 
; 0000 019E   DISPLAY_PORT = ~byCharacter[byDisplay[3]];
; 0000 019F   DIGIT4 = DigitsActive;
; 0000 01A0   delay_us(LED_delay);
; 0000 01A1   DIGIT4 = 0;
; 0000 01A2 #endif
; 0000 01A3 
; 0000 01A4   }
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 01A5 }
	LD   R17,Y+
	RET
; .FEND
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 01A9 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x3
; 0000 01AA   BYTE i;
; 0000 01AB   int Temp;
; 0000 01AC   int *val;
; 0000 01AD // Reinitialize Timer 1 value
; 0000 01AE #ifdef PREVENT_SENSOR_SELF_HEATING
; 0000 01AF if (Updating)           //если в этот раз читаем температуру, то
; 0000 01B0 {
; 0000 01B1 TCNT1=T1_OFFSET_LONG;
; 0000 01B2 }
; 0000 01B3 else
; 0000 01B4 {
; 0000 01B5 TCNT1=T1_OFFSET;
; 0000 01B6 }
; 0000 01B7 #else
; 0000 01B8 TCNT1=T1_OFFSET;
	RCALL __SAVELOCR4
;	i -> R17
;	Temp -> R18,R19
;	*val -> R16
	LDI  R30,LOW(34286)
	LDI  R31,HIGH(34286)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 01B9 #endif
; 0000 01BA //TCNT1L=0xD1;
; 0000 01BB #ifdef EliminateFlicker
; 0000 01BC skipDelay = 1;
	SBI  0x13,1
; 0000 01BD #endif
; 0000 01BE w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
; 0000 01BF ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01C0 
; 0000 01C1 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 01C2 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01C3 
; 0000 01C4 Updating = !Updating;   //это шоб читать температуру через раз
	SBIS 0x13,2
	RJMP _0x40
	CBI  0x13,2
	RJMP _0x41
_0x40:
	SBI  0x13,2
_0x41:
; 0000 01C5 if (Updating)           //если в этот раз читаем температуру, то
	SBIS 0x13,2
	RJMP _0x42
; 0000 01C6 {
; 0000 01C7   w1_write(0xBE);       //выдаём в шину 1-wire код 0xBE, что значит "Read Scratchpad"
	LDI  R26,LOW(190)
	RCALL _w1_write
; 0000 01C8   ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01C9 
; 0000 01CA #ifdef ShowDataErrors
; 0000 01CB   AllDataFF = 1;
	SBI  0x13,5
; 0000 01CC   NonZero = 0;
	CBI  0x13,6
; 0000 01CD   for (i=0; i<W1_BUFFER_LEN; i++)
	LDI  R17,LOW(0)
_0x48:
	CPI  R17,9
	BRSH _0x49
; 0000 01CE   {
; 0000 01CF     w1buffer[i]=w1_read();
	MOV  R30,R17
	SUBI R30,-LOW(_w1buffer)
	PUSH R30
	RCALL _w1_read
	POP  R26
	ST   X,R30
; 0000 01D0     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01D1     if (w1buffer[i] != 0xFF)
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BREQ _0x4A
; 0000 01D2     {
; 0000 01D3       AllDataFF = 0;
	CBI  0x13,5
; 0000 01D4     }
; 0000 01D5     if (w1buffer[i] != 0x00)
_0x4A:
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x4D
; 0000 01D6     {
; 0000 01D7       NonZero = 1;
	SBI  0x13,6
; 0000 01D8     }
; 0000 01D9   }
_0x4D:
	SUBI R17,-1
	RJMP _0x48
_0x49:
; 0000 01DA #else
; 0000 01DB   for (i=0; i<W1_BUFFER_LEN; i++)
; 0000 01DC   {
; 0000 01DD     w1buffer[i]=w1_read();
; 0000 01DE   }
; 0000 01DF #endif
; 0000 01E0   Initializing = 0;//хватит показывать заставку
	CBI  0x13,4
; 0000 01E1 #ifdef ShowDataErrors
; 0000 01E2   i=w1_dow_crc8(w1buffer,8);
	LDI  R30,LOW(_w1buffer)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _w1_dow_crc8
	MOV  R17,R30
; 0000 01E3   if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	TST  R10
	BRNE _0x52
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x53
	__GETB2MN _w1buffer,1
	CPI  R26,LOW(0x5)
	BRNE _0x54
; 0000 01E4   {
; 0000 01E5     //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
; 0000 01E6     //то это просто некорректно закончилось измерение температуры
; 0000 01E7     i--;
	SUBI R17,1
; 0000 01E8   }
; 0000 01E9   if (NonZero == 0)
_0x54:
_0x53:
_0x52:
	SBIS 0x13,6
; 0000 01EA   {
; 0000 01EB     //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
; 0000 01EC     i--;
	SUBI R17,1
; 0000 01ED   }
; 0000 01EE   if (i != w1buffer[8])
	__GETB1MN _w1buffer,8
	CP   R30,R17
	BREQ _0x56
; 0000 01EF   {
; 0000 01F0       //ошибка при передаче
; 0000 01F1       ErrorLevel = 1;//это просто сбой
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 01F2       if (AllDataFF)
	SBIS 0x13,5
	RJMP _0x57
; 0000 01F3       {
; 0000 01F4       //это обрыв
; 0000 01F5         ErrorLevel = 2;
	LDI  R30,LOW(2)
	RJMP _0xA0
; 0000 01F6       }
; 0000 01F7       else
_0x57:
; 0000 01F8       {
; 0000 01F9         if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x59
	__GETB2MN _w1buffer,1
	CPI  R26,LOW(0x5)
	BRNE _0x5A
; 0000 01FA         {
; 0000 01FB           ErrorLevel = 3;
	LDI  R30,LOW(3)
	MOV  R11,R30
; 0000 01FC         }
; 0000 01FD         if (NonZero == 0)
_0x5A:
_0x59:
	SBIC 0x13,6
	RJMP _0x5B
; 0000 01FE         {
; 0000 01FF           ErrorLevel = 4;
	LDI  R30,LOW(4)
_0xA0:
	MOV  R11,R30
; 0000 0200         }
; 0000 0201       }
_0x5B:
; 0000 0202       if (ErrorCounter > 0)
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x5C
; 0000 0203       {
; 0000 0204         ErrorCounter--;
	DEC  R10
; 0000 0205       }
; 0000 0206       if (ErrorCounter == 0)
_0x5C:
	TST  R10
	BRNE _0x5D
; 0000 0207       {
; 0000 0208         #ifdef Blinking
; 0000 0209         GoBlinking = 1;
	SBI  0x14,0
; 0000 020A         #endif
; 0000 020B       }
; 0000 020C   }
_0x5D:
; 0000 020D   else
	RJMP _0x60
_0x56:
; 0000 020E   {
; 0000 020F   #endif
; 0000 0210   val = (int*)&w1buffer[0];
	__POINTBRM 16,_w1buffer
; 0000 0211   Tnew =
; 0000 0212   (*val) * 10 / 16
; 0000 0213   #ifdef CorCode
; 0000 0214   + CorT
; 0000 0215   #endif
; 0000 0216   #ifdef CorT_Static
; 0000 0217   + CorT_Static
; 0000 0218   #endif
; 0000 0219   ;
	MOV  R26,R16
	RCALL __GETW1P
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __DIVW21
	MOVW R4,R30
; 0000 021A   RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 021B   #ifdef ShowDataErrors
; 0000 021C   ErrorCounter = MaxDataErrors + 1;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 021D   #endif
; 0000 021E   #ifdef ShowDataErrors
; 0000 021F   }
_0x60:
; 0000 0220   #endif
; 0000 0221 }
; 0000 0222 else
	RJMP _0x61
_0x42:
; 0000 0223 {
; 0000 0224   w1_write(0x44);          //выдаём в шину 1-wire код 0x44, что значит "Convert T"
	LDI  R26,LOW(68)
	RCALL _w1_write
; 0000 0225 }
_0x61:
; 0000 0226 
; 0000 0227 #ifdef ShowDataErrors
; 0000 0228 if (ErrorCounter == 0)
	TST  R10
	BRNE _0x62
; 0000 0229 {
; 0000 022A   #ifdef OUTPIN_NC
; 0000 022B   OUTPIN_NC = 0;
	CBI  0x12,3
; 0000 022C   #endif
; 0000 022D   OUTPIN_NO = 0;
	CBI  0x12,2
; 0000 022E   NeedResetLoad = 1;
	SBI  0x13,7
; 0000 022F   LoadOn = ShowDotWhenError;
	SBI  0x13,3
; 0000 0230 }
; 0000 0231 else
	RJMP _0x6B
_0x62:
; 0000 0232 #endif
; 0000 0233 if (!Initializing)
	SBIC 0x13,4
	RJMP _0x6C
; 0000 0234 {
; 0000 0235 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R8
	ADD  R30,R6
	ADC  R31,R7
	MOVW R18,R30
; 0000 0236 
; 0000 0237 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 4,5,18,19
	BRLT _0x6D
	SBIC 0x13,3
	RJMP _0x6F
	SBIS 0x13,7
	RJMP _0x6E
_0x6F:
; 0000 0238 {                              //то выключаем нагрузку
; 0000 0239   OUTPIN_NO = 0;
	CBI  0x12,2
; 0000 023A   #ifdef OUTPIN_NC
; 0000 023B   OUTPIN_NC = 1;
	SBI  0x12,3
; 0000 023C   #endif
; 0000 023D   LoadOn = 0;
	CBI  0x13,3
; 0000 023E   NeedResetLoad = 0;
	CBI  0x13,7
; 0000 023F }
; 0000 0240 
; 0000 0241 Temp = T_LoadOn;                //Temp - временная переменная.
_0x6E:
_0x6D:
	MOVW R18,R6
; 0000 0242 
; 0000 0243 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 18,19,4,5
	BRLT _0x79
	SBIS 0x13,3
	RJMP _0x7B
	SBIS 0x13,7
	RJMP _0x7A
_0x7B:
; 0000 0244 {                               //то включаем нагрузку
; 0000 0245   #ifdef OUTPIN_NC
; 0000 0246   OUTPIN_NC = 0;
	CBI  0x12,3
; 0000 0247   #endif
; 0000 0248   OUTPIN_NO = 1;
	SBI  0x12,2
; 0000 0249   LoadOn = 1;
	SBI  0x13,3
; 0000 024A   NeedResetLoad = 0;
	CBI  0x13,7
; 0000 024B }
; 0000 024C }//if errorCounter
_0x7A:
_0x79:
; 0000 024D 
; 0000 024E if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x6C:
_0x6B:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x85
; 0000 024F {
; 0000 0250   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R3
; 0000 0251 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
; 0000 0252 else                            //пока не станет равной "0".
	RJMP _0x86
_0x85:
; 0000 0253 {
; 0000 0254   View = SHOW_Normal;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R2
; 0000 0255 }
_0x86:
; 0000 0256 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 0257 #ifdef EliminateFlicker
; 0000 0258 skipDelay = 0;
	CBI  0x13,1
; 0000 0259 #endif
; 0000 025A }
	RCALL __LOADLOCR4
	ADIW R28,4
_0xA1:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Declare your global variables here
;
;void main(void)
; 0000 025F {
_main:
; .FSTART _main
; 0000 0260 // Declare your local variables here
; 0000 0261 
; 0000 0262 // Crystal Oscillator division factor: 1
; 0000 0263 #pragma optsize-
; 0000 0264 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0265 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0266 #ifdef _OPTIMIZE_SIZE_
; 0000 0267 #pragma optsize+
; 0000 0268 #endif
; 0000 0269 
; 0000 026A         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
; 0000 026B         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
; 0000 026C         //         если установлена 1 - то на выводе устанавливается лог. 1
; 0000 026D         //         если установлена 0 - то на выводе устанавливается лог. 0
; 0000 026E         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORT ...
; 0000 026F         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
; 0000 0270 
; 0000 0271         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
; 0000 0272         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0273 
; 0000 0274         DISPLAY_PORT=0b00000000;
	OUT  0x18,R30
; 0000 0275         DISPLAY_DDR =0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0276 
; 0000 0277 
; 0000 0278         #ifdef Cathode
; 0000 0279           PORTD=0b01110011;
	LDI  R30,LOW(115)
	OUT  0x12,R30
; 0000 027A           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
; 0000 027B         #endif
; 0000 027C 
; 0000 027D         #ifdef Anode
; 0000 027E           PORTD=0b01000000;
; 0000 027F           DDRD= 0b00111111;
; 0000 0280         #endif
; 0000 0281 
; 0000 0282 //выше уже проинициализировали
; 0000 0283 //#ifdef OUTPIN_NC
; 0000 0284 //OUTPIN_NC = 1;
; 0000 0285 //#endif
; 0000 0286 //OUTPIN_NO = 0;
; 0000 0287 
; 0000 0288 // Timer/Counter 0 initialization
; 0000 0289 // Clock source: System Clock
; 0000 028A // Clock value: 8000,000 kHz
; 0000 028B // Mode: Normal top=FFh
; 0000 028C // OC0A output: Disconnected
; 0000 028D // OC0B output: Disconnected
; 0000 028E TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 028F TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0290 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0291 // OCR0A=0x00;
; 0000 0292 // OCR0B=0x00;
; 0000 0293 
; 0000 0294 // Timer/Counter 1 initialization
; 0000 0295 // Clock source: System Clock
; 0000 0296 // Clock value: 7,813 kHz
; 0000 0297 // Mode: Normal top=FFFFh
; 0000 0298 // OC1A output: Discon.
; 0000 0299 // OC1B output: Discon.
; 0000 029A // Noise Canceler: Off
; 0000 029B // Input Capture on Falling Edge
; 0000 029C // Timer 1 Overflow Interrupt: On
; 0000 029D // Input Capture Interrupt: Off
; 0000 029E // Compare A Match Interrupt: Off
; 0000 029F // Compare B Match Interrupt: Off
; 0000 02A0 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02A1 TCCR1B=T1_PRESCALER;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 02A2 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 02A3 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
; 0000 02A4 // ICR1H=0x00;
; 0000 02A5 // ICR1L=0x00;
; 0000 02A6 // OCR1AH=0x00;
; 0000 02A7 // OCR1AL=0x00;
; 0000 02A8 // OCR1BH=0x00;
; 0000 02A9 // OCR1BL=0x00;
; 0000 02AA 
; 0000 02AB // External Interrupt(s) initialization
; 0000 02AC // INT0: Off
; 0000 02AD // INT1: Off
; 0000 02AE // Interrupt on any change on pins PCINT0-7: Off
; 0000 02AF GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 02B0 MCUCR=0x00;
	OUT  0x35,R30
; 0000 02B1 
; 0000 02B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02B3 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
; 0000 02B4 
; 0000 02B5 // Universal Serial Interface initialization
; 0000 02B6 // Mode: Disabled
; 0000 02B7 // Clock source: Register & Counter=no clk.
; 0000 02B8 // USI Counter Overflow Interrupt: Off
; 0000 02B9 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 02BA 
; 0000 02BB // Analog Comparator initialization
; 0000 02BC // Analog Comparator: Off
; 0000 02BD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02BE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02BF 
; 0000 02C0 #ifdef Blinking
; 0000 02C1 DimmerCounter = 0;
	CLR  R12
; 0000 02C2 #endif
; 0000 02C3 //Tnew = 0;                //Просто обнуляем, тыща больше не нужна
; 0000 02C4 
; 0000 02C5 if (!(eeDeltaT + 1))//проверка на FFFF - значение после стирания EEPROM
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDW
	ADIW R30,1
	BRNE _0x89
; 0000 02C6 {
; 0000 02C7   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	RCALL SUBOPT_0x6
; 0000 02C8   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x0
	RCALL __EEPROMWRW
; 0000 02C9   #ifdef CorCode
; 0000 02CA   eeCorT = CorT_Default;
; 0000 02CB   #endif
; 0000 02CC }
; 0000 02CD 
; 0000 02CE if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //если в EEPROM значение > Max или < Min значит он не прош ...
_0x89:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x4E3)
	LDI  R26,HIGH(0x4E3)
	CPC  R31,R26
	BRGE _0x8B
	CPI  R30,LOW(0xFDDA)
	LDI  R26,HIGH(0xFDDA)
	CPC  R31,R26
	BRGE _0x8A
_0x8B:
; 0000 02CF   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	RCALL SUBOPT_0x6
; 0000 02D0 if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
_0x8A:
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDW
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRGE _0x8E
	SBIW R30,1
	BRGE _0x8D
_0x8E:
; 0000 02D1   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x0
	RCALL __EEPROMWRW
; 0000 02D2 #ifdef CorCode
; 0000 02D3 if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не пр ...
; 0000 02D4   eeCorT = CorT_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod  ...
; 0000 02D5 CorT = eeCorT;
; 0000 02D6 #endif
; 0000 02D7 
; 0000 02D8 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x8D:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	MOVW R6,R30
; 0000 02D9 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDW
	MOVW R8,R30
; 0000 02DA 
; 0000 02DB #ifdef ShowDataErrors
; 0000 02DC ErrorLevel = 0;
	CLR  R11
; 0000 02DD ErrorCounter = 1;       //При включении обязательно показываем даже первую ошибку
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 02DE #endif
; 0000 02DF #ifdef Blinking
; 0000 02E0 GoBlinking = 0;
	CBI  0x14,0
; 0000 02E1 #endif
; 0000 02E2 Initializing = 1;
	SBI  0x13,4
; 0000 02E3 LoadOn = ShowDotAtStartup;//Точка включения нагрузки не должна гореть при старте, но для cold и heat это разные значения
	SBI  0x13,3
; 0000 02E4 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 02E5 
; 0000 02E6 Updating = 1; // Теперь первое обращение к датчику будет ConvertT
	SBI  0x13,2
; 0000 02E7 
; 0000 02E8 KbdInit();              //инициализация клавиатуры
	CBI  0x13,0
	RCALL SUBOPT_0x7
; 0000 02E9 
; 0000 02EA // Global enable interrupts
; 0000 02EB #asm("sei")
	sei
; 0000 02EC 
; 0000 02ED while (1)
_0x9A:
; 0000 02EE       {
; 0000 02EF       // Place your code here
; 0000 02F0       #asm("cli");               //запрещаем прерывания
	cli
; 0000 02F1       ShowDisplayData11Times();         //обновляем экран
	RCALL _ShowDisplayData11Times
; 0000 02F2       #asm("sei");               //разрешаем прерывания
	sei
; 0000 02F3       };
	RJMP _0x9A
; 0000 02F4 
; 0000 02F5 }
_0x9D:
	RJMP _0x9D
; .FEND
;/**************************************************************************\
; FILE ..........: KBD.C
; AUTHOR ........: Vitaly Puzrin
; DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
; NOTES .........:
; COPYRIGHT .....: Vitaly Puzrin, 1999
; HISTORY .......: DATE        COMMENT
;                  ---------------------------------------------------
;                  25.06.1999  Первая версия
;\**************************************************************************/
;
;#include    "kbd.h"
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include "termostat_led.h"
;
;#if __CODEVISIONAVR__ > 2000
;//проверка версии только для полной гарантии того, что
;//оригинальная версия исходника не затрагивается
;extern BYTE View;
;extern BYTE Counter;
;extern int T_LoadOn;
;extern int DeltaT;
;#ifdef CorCode
;extern INT8 CorT;
;#endif
;extern void RefreshDisplay(void);
;#endif
;#ifdef Blinking
;extern bit GoBlinking;
;#endif
;
;#define     KEY_1      0x01    // Код клавиши 1
;#define     KEY_2      0x02    // Код клавиши 2
;#define     KEY_3      0x03    // Код клавиши 3
;
;bit btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
;BYTE    byKeyCode;      // Код нажатой клавиши
;
;BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
;BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
;BYTE    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
;BYTE    byIterationCounter =  40;//Счётчик до повторения

	.DSEG
;
;
;#define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;#define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;#define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;
;/**************************************************************************\
;    Инициализация модуля (переменных и железа)
;      Вход:  -
;      Выход: -
;\**************************************************************************/
;// inline void KbdInit(void)
;// {
;//     btKeyUpdate = FALSE;
;//     byScanState = ST_WAIT_KEY;
;// }
;
;/**************************************************************************\
;    Сканирование клавиатуры
;      Вход:  -
;      Выход: -
;\**************************************************************************/
;void ScanKbd(void)
; 0001 0042 {

	.CSEG
_ScanKbd:
; .FSTART _ScanKbd
; 0001 0043     switch (byScanState)
	LDS  R30,_byScanState
; 0001 0044     {
; 0001 0045         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x20007
; 0001 0046             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
; 0001 0047             if (KeyCode != 0)
	RCALL SUBOPT_0x8
	BREQ _0x20008
; 0001 0048             {
; 0001 0049                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0x8
	STS  _byCheckedKey,R30
; 0001 004A 
; 0001 004B                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0x9
; 0001 004C 
; 0001 004D                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
; 0001 004E             }
; 0001 004F             break;
_0x20008:
	RJMP _0x20006
; 0001 0050 
; 0001 0051         case ST_CHECK_KEY:
_0x20007:
	CPI  R30,LOW(0x1)
	BRNE _0x20009
; 0001 0052             // Если клавиша удердивалась достаточно долго, то
; 0001 0053             // генерируем событие с кодом клавиши, и переходим к
; 0001 0054             // ожиданию отпускания клавиши
; 0001 0055             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0x8
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0x2000A
; 0001 0056             {
; 0001 0057                 byCheckKeyCnt--;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0001 0058                 if (!byCheckKeyCnt)
	BRNE _0x2000B
; 0001 0059                 {
; 0001 005A                     btKeyUpdate = TRUE;
	SBI  0x13,0
; 0001 005B                     byKeyCode = byCheckedKey;
	LDS  R30,_byCheckedKey
	STS  _byKeyCode,R30
; 0001 005C                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
; 0001 005D                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0x9
; 0001 005E                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	STS  _byIterationCounter,R30
; 0001 005F                 }
; 0001 0060             }
_0x2000B:
; 0001 0061             // Если данные неустойчитывы, то возвращается назад,
; 0001 0062             // к ожиданию нажатия клавиши
; 0001 0063             else
	RJMP _0x2000E
_0x2000A:
; 0001 0064                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x7
; 0001 0065             break;
_0x2000E:
	RJMP _0x20006
; 0001 0066 
; 0001 0067         case ST_RELEASE_WAIT:
_0x20009:
	CPI  R30,LOW(0x2)
	BRNE _0x20006
; 0001 0068             // Пока клавиша не будет отпущена на достаточный интервал
; 0001 0069             // времени, будем оставаться в этом состоянии
; 0001 006A             if (KeyCode != 0)
	RCALL SUBOPT_0x8
	BREQ _0x20010
; 0001 006B             {
; 0001 006C                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0x9
; 0001 006D                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0x20011
; 0001 006E                 {
; 0001 006F                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	STS  _byIterationCounter,R30
; 0001 0070                   btKeyUpdate = TRUE;
	SBI  0x13,0
; 0001 0071                 }
; 0001 0072                 byIterationCounter--;
_0x20011:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RJMP _0x20031
; 0001 0073             }
; 0001 0074             else
_0x20010:
; 0001 0075             {
; 0001 0076                 byCheckKeyCnt--;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0001 0077                 if (!byCheckKeyCnt)
	BRNE _0x20015
; 0001 0078                 {
; 0001 0079                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x7
; 0001 007A                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
_0x20031:
	STS  _byIterationCounter,R30
; 0001 007B                 }
; 0001 007C             }
_0x20015:
; 0001 007D             break;
; 0001 007E     }
_0x20006:
; 0001 007F     if( btKeyUpdate )
	SBIS 0x13,0
	RJMP _0x20016
; 0001 0080     {
; 0001 0081       btKeyUpdate = FALSE;
	CBI  0x13,0
; 0001 0082       ProcessKey();
	RCALL _ProcessKey
; 0001 0083     }
; 0001 0084 }
_0x20016:
	RET
; .FEND
;
;/**************************************************************************\
;    Обработка нажатой клавиши.
;      Вход:  -
;      Выход: -
;\**************************************************************************/
;void ProcessKey(void)
; 0001 008C {
_ProcessKey:
; .FSTART _ProcessKey
; 0001 008D     switch (byKeyCode)
	LDS  R30,_byKeyCode
; 0001 008E     {
; 0001 008F         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0x2001C
; 0001 0090             switch (View)
	MOV  R30,R2
; 0001 0091             {
; 0001 0092               #ifdef ENTER_SETTINGS_BY_ONE_KEY
; 0001 0093               case 0:               //если был режим "Текущая температура", то
; 0001 0094                  View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 0095               break;
; 0001 0096               #endif
; 0001 0097               case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0x20020
; 0001 0098                 if (T_LoadOn > TLoadOn_Min) //если "Установленная температура" > Min, то
	LDI  R30,LOW(64986)
	LDI  R31,HIGH(64986)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x20021
; 0001 0099                 {
; 0001 009A                   T_LoadOn -= T_STEP;      //уменьшаем значение на 0,1°
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0001 009B //                  RefreshDisplay(); //обновляем данные на экране
; 0001 009C                 }
; 0001 009D //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
; 0001 009E //                Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 009F               break;
_0x20021:
	RJMP _0x2001F
; 0001 00A0               case 2:               //если мы в режиме "Дэльта", то
_0x20020:
	CPI  R30,LOW(0x2)
	BRNE _0x2001F
; 0001 00A1                 if (DeltaT > DeltaT_Min)     //если "Дэльта" больше Min, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x20023
; 0001 00A2                 {
; 0001 00A3                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0001 00A4 //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00A5                 }
; 0001 00A6 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00A7               break;
_0x20023:
; 0001 00A8               #ifdef CorCode
; 0001 00A9               case 3:                   //если мы в режиме "Коррекции", то
; 0001 00AA                 if (CorT > CorT_Min)
; 0001 00AB                 {
; 0001 00AC                     CorT--;         //уменьшаем значение на 0,1°
; 0001 00AD                 }
; 0001 00AE                 break;
; 0001 00AF               #endif
; 0001 00B0             }
_0x2001F:
; 0001 00B1         break;
	RJMP _0x2001B
; 0001 00B2 
; 0001 00B3         case KEY_2:                 // Была нажата клавиша Плюс
_0x2001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20024
; 0001 00B4             switch (View)
	MOV  R30,R2
; 0001 00B5             {
; 0001 00B6               #ifdef ENTER_SETTINGS_BY_ONE_KEY
; 0001 00B7               case 0:               //если был режим "Текущая температура", то
; 0001 00B8                  View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00B9               break;
; 0001 00BA               #endif
; 0001 00BB               case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0x20028
; 0001 00BC                 if (T_LoadOn < (TLoadOn_Max - DeltaT))    //если температура ниже Max - Дельта
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	SUB  R30,R8
	SBC  R31,R9
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x20029
; 0001 00BD                 {
; 0001 00BE                   T_LoadOn += T_STEP;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0001 00BF //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00C0                 }
; 0001 00C1 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
; 0001 00C2 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00C3               break;
_0x20029:
	RJMP _0x20027
; 0001 00C4               case 2:
_0x20028:
	CPI  R30,LOW(0x2)
	BRNE _0x20027
; 0001 00C5                 if (DeltaT < DeltaT_Max)   //если Дельта меньше Max, то
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x2002B
; 0001 00C6                 {
; 0001 00C7                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0001 00C8 //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00C9                 }
; 0001 00CA //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00CB               break;
_0x2002B:
; 0001 00CC               #ifdef CorCode
; 0001 00CD               case 3:                   //если мы в режиме "Коррекции", то
; 0001 00CE                 if (CorT < CorT_Max)
; 0001 00CF                 {
; 0001 00D0                     CorT++;
; 0001 00D1                 }
; 0001 00D2               break;
; 0001 00D3               #endif
; 0001 00D4             }
_0x20027:
; 0001 00D5         break;
	RJMP _0x2001B
; 0001 00D6 
; 0001 00D7         case KEY_3:               // Была нажаты обе кноки вместе.
_0x20024:
	CPI  R30,LOW(0x3)
	BRNE _0x2002E
; 0001 00D8           View++;
	INC  R2
; 0001 00D9           if (View > View_Max)
	LDI  R30,LOW(3)
	CP   R30,R2
	BRSH _0x2002D
; 0001 00DA           {
; 0001 00DB             View = SHOW_TLoadOn;
	LDI  R30,LOW(1)
	MOV  R2,R30
; 0001 00DC           }
; 0001 00DD //             switch (View)
; 0001 00DE //             {
; 0001 00DF //               case 0:               //если был режим "Текущая температура", то
; 0001 00E0 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00E1 //               break;
; 0001 00E2 //               case 1:               //если мы в режиме "Установленная температура", то
; 0001 00E3 //                 View = SHOW_DeltaT;           //удерживаем в режиме "Дэльта"
; 0001 00E4 //               break;
; 0001 00E5 //               case 2:
; 0001 00E6 //                 View = SHOW_Error;           //переходим в режим "Последняя обнаруженная ошибка"
; 0001 00E7 //               break;
; 0001 00E8 //               case 3:
; 0001 00E9 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00EA //               break;
; 0001 00EB //             }
; 0001 00EC //             Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 00ED //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00EE //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00EF //            Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00F0         break;
_0x2002D:
; 0001 00F1 
; 0001 00F2         default:
_0x2002E:
; 0001 00F3         break;
; 0001 00F4 
; 0001 00F5     }
_0x2001B:
; 0001 00F6     Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R3,R30
; 0001 00F7     #ifdef Blinking
; 0001 00F8     GoBlinking = 0;
	CBI  0x14,0
; 0001 00F9     #endif
; 0001 00FA     RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
; 0001 00FB 
; 0001 00FC }
	RET
; .FEND

	.DSEG
_byScanState:
	.BYTE 0x1
_byDisplay:
	.BYTE 0x4
_w1buffer:
	.BYTE 0x9

	.ESEG
_eeT_LoadOn:
	.DB  0x18,0x1
_eeDeltaT:
	.DB  0xA,0x0

	.DSEG
_byCharacter:
	.BYTE 0xF
_byKeyCode:
	.BYTE 0x1
_byCheckedKey:
	.BYTE 0x1
_byCheckKeyCnt:
	.BYTE 0x1
_byIterationCounter:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	__DELAY_USW 1200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _byScanState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(4)
	STS  _byCheckKeyCnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDS  R30,_byCheckKeyCnt
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	SUBI R30,LOW(1)
	STS  _byCheckKeyCnt,R30
	RCALL SUBOPT_0xA
	CPI  R30,0
	RET


	.CSEG
_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	clr  r27
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,1
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
