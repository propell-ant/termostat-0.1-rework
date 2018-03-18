
;CodeVisionAVR C Compiler V1.25.8 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny2313
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 40 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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

	.CSEG
	.ORG 0

	.INCLUDE "termostat_led.vec"
	.INCLUDE "termostat_led.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
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
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x88)
	LDI  R29,HIGH(0x88)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x88
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.5 Professional
;       4 Automatic Program Generator
;       5 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 15.10.2008
;      11 Author  : Yurik
;      12 Company : Hardlock
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATtiny2313
;      17 Clock frequency     : 8,000000 MHz
;      18 Memory model        : Tiny
;      19 External SRAM size  : 0
;      20 Data Stack size     : 32
;      21 *****************************************************/
;      22 
;      23 #include <tiny2313.h>
;      24 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      25 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      26 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;      27 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;      28 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;      29 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;      30 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      31 	#endif
	#endif
;      32 #include <kbd.h>
;      33 
;      34 // 1 Wire Bus functions
;      35 #asm
;      36    .equ __w1_port=0x12 ;PORTD
   .equ __w1_port=0x12 ;PORTD
;      37    .equ __w1_bit=6
   .equ __w1_bit=6
;      38 #endasm
;      39 #include <1wire.h>
;      40 #include <delay.h>
;      41 
;      42 #define LED_delay 150
;      43 
;      44 //#define Cathode           //раскоментировать, если индикатор с ОК
;      45 #define Anode           //раскоментировать, если индикатор с ОА
;      46 
;      47 #define heat              //точка отображается если T < Tуст.
;      48 //#define cold            //точка отображается если T > Tуст.
;      49 
;      50 BYTE byDisplay[4]={11,11,11,11};        // буфер данных, для вывода на экран
_byDisplay:
	.BYTE 0x4
;      51 
;      52 BOOLEAN Updating;         //служебная переменная
;      53 BOOLEAN Minus;            //равна "1" если температура отрицательная
;      54 BOOLEAN LoadOn;           //равна "1" если включена нагрузка
;      55 bit Initialising;        //равна "1" до получения первого значения температуры с датчика
;      56 
;      57 BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;      58 BYTE View = 0;            //определяет в каком режиме отображения находится устройство:
;      59                           //0 - основной - Текущая температура
;      60                           //1 - Установленная температура
;      61                           //2 - Дэльта
;      62 
;      63 WORD Tnew;                //для хранения нового значения измеренной температуры
;      64 WORD T_LoadOn;            //для хранения значения Установленной температуры
;      65 WORD DeltaT;              //для хранения значения Дэльты
;      66 
;      67 bit NeedResetLoad = 0;
;      68 eeprom WORD eeT_LoadOn = 1280;   //1280 = +28°C 1140 = +14°C

	.ESEG
_eeT_LoadOn:
	.DW  0x500
;      69 eeprom WORD eeDeltaT = 10;       //1°C
_eeDeltaT:
	.DW  0xA
;      70 
;      71 //температура для удобства представлена так:
;      72 // - до 1000 = отрицательная
;      73 // - 1000 = 0
;      74 // - больше 1000 = положительная
;      75 // - 0,1°С = 1
;      76 //---------------------------------
;      77 //-55°C = 450
;      78 //-25°C = 750
;      79 //-10.1°C = 899
;      80 //0°C = 1000
;      81 //10.1°C = 1101
;      82 //25°C = 1250
;      83 //85°C = 1850
;      84 //125°C = 2250
;      85 
;      86 
;      87 BYTE byCharacter[15] = {0xFA,     //0

	.DSEG
_byCharacter:
;      88                 0x82,   //1
;      89  	        0xB9,   //2
;      90 	        0xAB,	//3
;      91 	        0xC3,     //4
;      92 	        0x6B,     //5
;      93 	        0x7B,     //6
;      94                 0xA2,    //7
;      95                 0xFB,      //8
;      96                 0xEB,      //9
;      97                 0x00,      //blank
;      98                 0x01,     //-
;      99                 0x70,     //t
;     100                 0x9B,     //d
;     101                 0x58      //L
;     102                 };
	.BYTE 0xF
;     103 
;     104 
;     105 
;     106 /************************************************************************\
;     107 \************************************************************************/
;     108 void PrepareData(unsigned int Data)
;     109 {

	.CSEG
_PrepareData:
;     110     BYTE i;
;     111     unsigned int D, D1;
;     112     if (Initialising)
	RCALL __SAVELOCR6
;	Data -> Y+6
;	i -> R17
;	D -> R18,R19
;	D1 -> R20,R21
	SBIC 0x13,0
;     113     {
;     114       return;
	RJMP _0x86
;     115     }
;     116     D = Data;
	__GETWRS 18,19,6
;     117 
;     118     if (D >= 1000) //если Температура больше нуля
	__CPWRN 18,19,1000
	BRLO _0x6
;     119     {
;     120       D = D - 1000;
	__SUBWRN 18,19,1000
;     121       Minus = 0;
	CLR  R2
;     122     }
;     123     else
	RJMP _0x7
_0x6:
;     124     {
;     125       D = 1000 - D;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	SUB  R30,R18
	SBC  R31,R19
	MOVW R18,R30
;     126       Minus = 1;
	LDI  R30,LOW(1)
	MOV  R2,R30
;     127     }
_0x7:
;     128     D1 = D;
	MOVW R20,R18
;     129 
;     130     //Преобразуем в десятичное представление
;     131     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
;     132     {
;     133        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21U
	MOV  R26,R16
	ST   X,R30
;     134        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21U
	MOVW R18,R30
;     135     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
;     136 
;     137     if (D1 < 100)
	__CPWRN 20,21,100
	BRSH _0xB
;     138     {
;     139       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     140       byDisplay[1] = 10;
	__PUTB1MN _byDisplay,1
;     141 
;     142       goto exit;
	RJMP _0xC
;     143     }
;     144     if ((D1 >= 100) & (D1 <1000))
_0xB:
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __GEW12U
	MOV  R0,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __LTW12U
	AND  R30,R0
	BREQ _0xD
;     145     {
;     146       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     147       goto exit;
;     148     }
;     149 
;     150 exit:
_0xD:
_0xC:
;     151   if (View == 2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xE
;     152   {
;     153     byDisplay[0] = 13;
	LDI  R30,LOW(13)
	STS  _byDisplay,R30
;     154   }
;     155 
;     156 }
_0xE:
_0x86:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     157 
;     158 /************************************************************************\
;     159   Вывод экранного буфера на дисплей.
;     160       Вход:  -
;     161       Выход: -
;     162 \************************************************************************/
;     163 void ShowDisplayData(void)
;     164 {
_ShowDisplayData:
;     165  #ifdef Cathode
;     166 
;     167   PORTB = byCharacter[byDisplay[0]];
;     168   if (Minus)
;     169   {
;     170     PORTB = PINB | 0b00000001;
;     171   }
;     172   #ifdef heat
;     173   if (LoadOn)
;     174   #endif
;     175 
;     176   #ifdef cold
;     177   if (!LoadOn)
;     178   #endif
;     179   {
;     180     PORTB = PINB | 0b00000100;
;     181   }
;     182   if (View == 1)
;     183   {
;     184     PORTB = PINB | 0b00001000;
;     185   }
;     186   PORTD.5 = 0;
;     187   delay_us(LED_delay);
;     188   PORTD.5 = 1;
;     189 
;     190   PORTB = byCharacter[byDisplay[1]];
;     191   PORTD.1 = 0;
;     192   delay_us(LED_delay);
;     193   PORTD.1 = 1;
;     194 
;     195   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     196   PORTD.0 = 0;
;     197   delay_us(LED_delay);
;     198   PORTD.0 = 1;
;     199 
;     200   PORTB = byCharacter[byDisplay[3]];
;     201   PORTD.4 = 0;
;     202   delay_us(LED_delay);
;     203   PORTD.4 = 1;
;     204 #endif
;     205 
;     206 #ifdef Anode
;     207   PORTB = ~byCharacter[byDisplay[0]];
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x1
;     208   if (Minus)
	TST  R2
	BREQ _0xF
;     209   {
;     210     PORTB = PINB & 0b11111110;
	IN   R30,0x16
	ANDI R30,0xFE
	OUT  0x18,R30
;     211   }
;     212   #ifdef heat
;     213   if (LoadOn)
_0xF:
	TST  R5
	BREQ _0x10
;     214   #endif
;     215 
;     216   #ifdef cold
;     217   if (!LoadOn)
;     218   #endif
;     219   {
;     220     PORTB = PINB & 0b11111011;
	IN   R30,0x16
	ANDI R30,0xFB
	OUT  0x18,R30
;     221   }
;     222   if (View == 1)
_0x10:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x11
;     223   {
;     224     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     225   }
;     226   PORTD.5 = 1;
_0x11:
	SBI  0x12,5
;     227   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     228   PORTD.5 = 0;
	CBI  0x12,5
;     229 
;     230   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x1
;     231   PORTD.1 = 1;
	SBI  0x12,1
;     232   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     233   PORTD.1 = 0;
	CBI  0x12,1
;     234 
;     235   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     236   PORTD.0 = 1;
	SBI  0x12,0
;     237   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     238   PORTD.0 = 0;
	CBI  0x12,0
;     239 
;     240   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x1
;     241   PORTD.4 = 1;
	SBI  0x12,4
;     242   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     243   PORTD.4 = 0;
	CBI  0x12,4
;     244 #endif
;     245 
;     246 
;     247   }
	RET
;     248 
;     249 
;     250 /************************************************************************\
;     251   Обновление дисплея.
;     252       Вход:  -
;     253       Выход: -
;     254 \************************************************************************/
;     255 void RefreshDisplay(void)
;     256 {
_RefreshDisplay:
;     257   WORD Data;
;     258   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R7
;     259   {
;     260     case 0:
	CPI  R30,0
	BRNE _0x25
;     261       Data = Tnew;
	MOVW R16,R8
;     262       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x3
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x26
;     263         eeT_LoadOn = T_LoadOn;
	MOVW R30,R10
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     264       if (DeltaT != eeDeltaT)
_0x26:
	RCALL SUBOPT_0x4
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x27
;     265         eeDeltaT = DeltaT;
	MOVW R30,R12
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     266     break;
_0x27:
	RJMP _0x24
;     267     case 1:
_0x25:
	CPI  R30,LOW(0x1)
	BRNE _0x28
;     268       Data = T_LoadOn;
	MOVW R16,R10
;     269     break;
	RJMP _0x24
;     270 
;     271     case 2:
_0x28:
	CPI  R30,LOW(0x2)
	BRNE _0x24
;     272       Data = DeltaT + 1000;
	MOVW R30,R12
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	MOVW R16,R30
;     273     break;
;     274   }
_0x24:
;     275 
;     276   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     277 }
	RCALL __LOADLOCR2P
	RET
;     278 
;     279 // Timer 0 overflow interrupt service routine
;     280 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     281 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x5
;     282 // Reinitialize Timer 0 value
;     283 TCNT0=0xBF;
	LDI  R30,LOW(191)
	OUT  0x32,R30
;     284 
;     285 ScanKbd();
	RCALL _ScanKbd
;     286 }
	RCALL SUBOPT_0x6
	RETI
;     287 
;     288 // Timer 1 overflow interrupt service routine
;     289 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     290 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x5
;     291   BYTE t1;
;     292   BYTE t2;
;     293   BYTE i;
;     294   WORD Temp;
;     295   WORD T;
;     296   BYTE Ff;
;     297 // Reinitialize Timer 1 value
;     298 TCNT1H=0x8F;
	SBIW R28,2
	RCALL __SAVELOCR6
;	t1 -> R17
;	t2 -> R16
;	i -> R19
;	Temp -> R20,R21
;	T -> Y+6
;	Ff -> R18
	LDI  R30,LOW(143)
	OUT  0x2D,R30
;     299 TCNT1L=0xD1;
	LDI  R30,LOW(209)
	OUT  0x2C,R30
;     300 
;     301 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     302 
;     303 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x2B:
	CPI  R19,11
	BRSH _0x2C
;     304   {
;     305     ShowDisplayData();
	RCALL _ShowDisplayData
;     306   }
	SUBI R19,-1
	RJMP _0x2B
_0x2C:
;     307 
;     308 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     309 
;     310 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x2E:
	CPI  R19,11
	BRSH _0x2F
;     311   {
;     312     ShowDisplayData();
	RCALL _ShowDisplayData
;     313   }
	SUBI R19,-1
	RJMP _0x2E
_0x2F:
;     314 
;     315 Updating = !Updating;   //это шоб читать температуру через раз
	MOV  R30,R3
	RCALL __LNEGB1
	MOV  R3,R30
;     316 
;     317 if (Updating)           //если в этот раз читаем температуру, то
	TST  R3
	BRNE PC+2
	RJMP _0x30
;     318 {
;     319   w1_write(0xBE);       //выдаём в шину 1-wire код 0xCC, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
;     320 
;     321   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x32:
	CPI  R19,11
	BRSH _0x33
;     322   {
;     323     ShowDisplayData();
	RCALL _ShowDisplayData
;     324   }
	SUBI R19,-1
	RJMP _0x32
_0x33:
;     325 
;     326   t1=w1_read();   //LSB //читаем младший байт данных
	RCALL _w1_read
	MOV  R17,R30
;     327 
;     328   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x35:
	CPI  R19,11
	BRSH _0x36
;     329   {
;     330     ShowDisplayData();
	RCALL _ShowDisplayData
;     331   }
	SUBI R19,-1
	RJMP _0x35
_0x36:
;     332   t2=w1_read();   //MSB //читаем старший байт данных
	RCALL _w1_read
	MOV  R16,R30
;     333 
;     334   // значения из даташита (для проверки раскоментировать нужное значение)
;     335 
;     336   //+125°C
;     337   //t2 = 0b00000111; //MSB
;     338   //t1 = 0b11010000; //LSB
;     339 
;     340   //+85°C
;     341   //t2 = 0b00000101; //MSB
;     342   //t1 = 0b01010000; //LSB
;     343 
;     344   //+25.0625°C
;     345   //t2 = 0b00000001; //MSB
;     346   //t1 = 0b10010001; //LSB
;     347 
;     348   //+10.125°C
;     349   //t2 = 0b00000000; //MSB
;     350   //t1 = 0b10100010; //LSB
;     351 
;     352   //+0.5°C
;     353   //t2 = 0b00000000; //MSB
;     354   //t1 = 0b00001000; //LSB
;     355 
;     356   //0°C
;     357   //t2 = 0b00000000; //MSB
;     358   //t1 = 0b00000000; //LSB
;     359 
;     360   //-0.5°C
;     361   //t2 = 0b11111111; //MSB
;     362   //t1 = 0b11111000; //LSB
;     363 
;     364   //-10.125°C
;     365   //t2 = 0b11111111; //MSB
;     366   //t1 = 0b01011110; //LSB
;     367 
;     368   //-25.0625°C
;     369   //t2 = 0b11111110; //MSB
;     370   //t1 = 0b01101111; //LSB
;     371 
;     372   //-55°C
;     373   //t2 = 0b11111100; //MSB
;     374   //t1 = 0b10010000; //LSB
;     375 
;     376 
;     377 
;     378 
;     379   Ff = (t1 & 0x0F);           //из LSB выделяем дробную часть значения температуры
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R18,R30
;     380   t2 = t2 << 4;
	SWAP R16
	ANDI R16,0xF0
;     381   t1 = t1 >> 4;
	SWAP R17
	ANDI R17,0xF
;     382   T = (t2 & 0xF0) | (t1 & 0x0F);    //после объедининия смещённых частей LSB и MSB объединяем
	MOV  R30,R16
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	OR   R30,R26
	LDI  R31,0
	STD  Y+6,R30
	STD  Y+6+1,R31
;     383                                     //их и получаем целую часть значения температуры.
;     384                                     //подробней - смотри даташит.
;     385 
;     386   if (T & 0b10000000) //если отрицательная температура
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x37
;     387   {
;     388     Ff = ~Ff + 1;         //инвертируем значение дробной части и добавляем адын.
	MOV  R30,R18
	COM  R30
	SUBI R30,-LOW(1)
	MOV  R18,R30
;     389     Ff = Ff & 0b00001111; //убираем лишние биты
	ANDI R18,LOW(15)
;     390 
;     391     if (!Ff)              //если дробная часть равна "0"
	CPI  R18,0
	BRNE _0x38
;     392     {
;     393       T--;                //значение температуры уменьшаем на адын
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
;     394     }
;     395 
;     396     Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //вычисляем значение температуры если T < 0.
_0x38:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	COM  R30
	COM  R31
	ANDI R31,HIGH(0xFF)
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	RCALL SUBOPT_0x7
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R8,R26
;     397                                                           //Формат хранения - смотри строку 58 этого файла.
;     398   }
;     399   else
	RJMP _0x39
_0x37:
;     400   {
;     401     Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0.
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x0
	RCALL __MULW12U
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	RCALL SUBOPT_0x7
	MOVW R8,R30
;     402                                                           //Формат хранения - смотри строку 58 этого файла.
;     403   }
_0x39:
;     404   Tnew = Tnew + 0;
	MOVW R30,R8
	ADIW R30,0
	MOVW R8,R30
;     405   Initialising = 0;//хватит показывать заставку
	CBI  0x13,0
;     406 }
;     407 else
	RJMP _0x3C
_0x30:
;     408 {
;     409   w1_write(0x44);          //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
;     410 }
_0x3C:
;     411 
;     412 
;     413 if (!Initialising)
	SBIC 0x13,0
	RJMP _0x3D
;     414 {
;     415 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R12
	ADD  R30,R10
	ADC  R31,R11
	MOVW R20,R30
;     416 
;     417 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 8,9,20,21
	BRLO _0x3E
	TST  R5
	BRNE _0x40
	SBIS 0x13,1
	RJMP _0x3F
_0x40:
;     418 {                              //то выключаем нагрузку
;     419   PORTD.3 = 1;
	SBI  0x12,3
;     420   PORTD.2 = 0;
	CBI  0x12,2
;     421   LoadOn = 0;
	CLR  R5
;     422   NeedResetLoad = 0;
	CBI  0x13,1
;     423 }
;     424 
;     425 Temp = T_LoadOn;                //Temp - временная переменная.
_0x3F:
_0x3E:
	MOVW R20,R10
;     426 
;     427 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 20,21,8,9
	BRLO _0x48
	TST  R5
	BREQ _0x4A
	SBIS 0x13,1
	RJMP _0x49
_0x4A:
;     428 {                               //то включаем нагрузку
;     429   PORTD.3 = 0;
	CBI  0x12,3
;     430   PORTD.2 = 1;
	SBI  0x12,2
;     431   LoadOn = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;     432   NeedResetLoad = 0;
	CBI  0x13,1
;     433 }
;     434 }
_0x49:
_0x48:
;     435 
;     436 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x3D:
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x52
;     437 {
;     438   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R4
;     439 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     440 else                            //пока не станет равной "0".
	RJMP _0x53
_0x52:
;     441 {
;     442   View = 0;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R7
;     443 }
_0x53:
;     444 
;     445 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     446 
;     447 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RCALL SUBOPT_0x6
	RETI
;     448 
;     449 // Declare your global variables here
;     450 
;     451 void main(void)
;     452 {
_main:
;     453 // Declare your local variables here
;     454 
;     455 // Crystal Oscillator division factor: 1
;     456 #pragma optsize-
;     457 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     458 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     459 #ifdef _OPTIMIZE_SIZE_
;     460 #pragma optsize+
;     461 #endif
;     462 
;     463         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
;     464         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
;     465         //         если установлена 1 - то на выводе устанавливается лог. 1
;     466         //         если установлена 0 - то на выводе устанавливается лог. 0
;     467         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
;     468         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
;     469 
;     470         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     471         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     472 
;     473         PORTB=0b00000000;
	OUT  0x18,R30
;     474         DDRB= 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     475 
;     476 
;     477         #ifdef Cathode
;     478           PORTD=0b01110011;
;     479           DDRD= 0b00111111;
;     480         #endif
;     481 
;     482         #ifdef Anode
;     483           PORTD=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
;     484           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     485         #endif
;     486 
;     487 //выше уже проинициализировали
;     488 //PORTD.3 = 0;
;     489 //PORTD.2 = 0;
;     490 
;     491 // Timer/Counter 0 initialization
;     492 // Clock source: System Clock
;     493 // Clock value: 8000,000 kHz
;     494 // Mode: Normal top=FFh
;     495 // OC0A output: Disconnected
;     496 // OC0B output: Disconnected
;     497 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     498 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     499 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     500 OCR0A=0x00;
	OUT  0x36,R30
;     501 OCR0B=0x00;
	OUT  0x3C,R30
;     502 
;     503 // Timer/Counter 1 initialization
;     504 // Clock source: System Clock
;     505 // Clock value: 7,813 kHz
;     506 // Mode: Normal top=FFFFh
;     507 // OC1A output: Discon.
;     508 // OC1B output: Discon.
;     509 // Noise Canceler: Off
;     510 // Input Capture on Falling Edge
;     511 // Timer 1 Overflow Interrupt: On
;     512 // Input Capture Interrupt: Off
;     513 // Compare A Match Interrupt: Off
;     514 // Compare B Match Interrupt: Off
;     515 TCCR1A=0x00;
	OUT  0x2F,R30
;     516 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     517 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
;     518 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
;     519 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
;     520 ICR1L=0x00;
	OUT  0x24,R30
;     521 OCR1AH=0x00;
	OUT  0x2B,R30
;     522 OCR1AL=0x00;
	OUT  0x2A,R30
;     523 OCR1BH=0x00;
	OUT  0x29,R30
;     524 OCR1BL=0x00;
	OUT  0x28,R30
;     525 
;     526 // External Interrupt(s) initialization
;     527 // INT0: Off
;     528 // INT1: Off
;     529 // Interrupt on any change on pins PCINT0-7: Off
;     530 GIMSK=0x00;
	OUT  0x3B,R30
;     531 MCUCR=0x00;
	OUT  0x35,R30
;     532 
;     533 // Timer(s)/Counter(s) Interrupt(s) initialization
;     534 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
;     535 
;     536 // Universal Serial Interface initialization
;     537 // Mode: Disabled
;     538 // Clock source: Register & Counter=no clk.
;     539 // USI Counter Overflow Interrupt: Off
;     540 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     541 
;     542 // Analog Comparator initialization
;     543 // Analog Comparator: Off
;     544 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     545 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     546 
;     547 //Tnew = 1000;                //Это чтобы на экране был "0.0" при включении питания
;     548 
;     549 if ((eeT_LoadOn > 2250) | (eeT_LoadOn < 450))    //если в EEPROM значение > 2250 или < 450 значит он не прошился, или
	RCALL SUBOPT_0x3
	MOVW R26,R30
	LDI  R30,LOW(2250)
	LDI  R31,HIGH(2250)
	RCALL __GTW12U
	MOV  R0,R30
	RCALL SUBOPT_0x3
	MOVW R26,R30
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	RCALL __LTW12U
	OR   R30,R0
	BREQ _0x54
;     550   eeT_LoadOn = 1280;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(1280)
	LDI  R31,HIGH(1280)
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     551 if (eeDeltaT > 900)
_0x54:
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLO _0x55
;     552   eeDeltaT = 10;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     553 
;     554 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x55:
	RCALL SUBOPT_0x3
	MOVW R10,R30
;     555 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x4
	MOVW R12,R30
;     556 
;     557 Initialising = 1;
	SBI  0x13,0
;     558 NeedResetLoad = 1;
	SBI  0x13,1
;     559 
;     560 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     561 
;     562 // w1_init();              //инициализация шины 1-wire
;     563 // w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
;     564 // w1_write(0x44);         //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
;     565 Updating = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
;     566 
;     567 
;     568 KbdInit();              //инициализация клавиатуры :)
	RCALL _KbdInit
;     569 
;     570 // Global enable interrupts
;     571 #asm("sei")
	sei
;     572 
;     573 while (1)
_0x5A:
;     574       {
;     575       // Place your code here
;     576       #asm("cli");               //запрещаем прерывания
	cli
;     577       ShowDisplayData();         //обновляем экран
	RCALL _ShowDisplayData
;     578       #asm("sei");               //разрешаем прерывания
	sei
;     579       };
	RJMP _0x5A
;     580 
;     581 }
_0x5D:
	RJMP _0x5D
;     582 /**************************************************************************\
;     583  FILE ..........: KBD.C
;     584  AUTHOR ........: Vitaly Puzrin
;     585  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     586  NOTES .........:
;     587  COPYRIGHT .....: Vitaly Puzrin, 1999
;     588  HISTORY .......: DATE        COMMENT
;     589                   ---------------------------------------------------
;     590                   25.06.1999  Первая версия
;     591 \**************************************************************************/
;     592 
;     593 #include    "kbd.h"
;     594 #include <tiny2313.h>
;     595 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     596 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     597 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     598 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     599 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     600 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     601 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     602 	#endif
	#endif
;     603 
;     604 #if __CODEVISIONAVR__ > 2000
;     605 //проверка версии только для полной гарантии того, что
;     606 //оригинальная версия исходника не затрагивается
;     607 extern BYTE View;
;     608 extern BYTE Counter;
;     609 extern WORD T_LoadOn;
;     610 extern WORD DeltaT;
;     611 extern void RefreshDisplay(void);
;     612 #endif
;     613 
;     614 #define     ST_WAIT_KEY     0
;     615 #define     ST_CHECK_KEY    1
;     616 #define     ST_RELEASE_WAIT 2
;     617 
;     618 #define     KEY_1      0x01    // Код клавиши 1
;     619 #define     KEY_2      0x02    // Код клавиши 2
;     620 #define     KEY_3      0x03    // Код клавиши 3
;     621 
;     622 BOOLEAN btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу

	.DSEG
_btKeyUpdate:
	.BYTE 0x1
;     623 BYTE    byKeyCode;      // Код нажатой клавиши
;     624 
;     625 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
_byScanState:
	.BYTE 0x1
;     626 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
_byCheckedKey:
	.BYTE 0x1
;     627 WORD    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
_byCheckKeyCnt:
	.BYTE 0x2
;     628 BYTE    byIterationCounter =  40;//Счётчик до повторения
_byIterationCounter:
	.BYTE 0x1
;     629 
;     630 
;     631 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     632 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     633 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     634 
;     635 /**************************************************************************\
;     636     Инициализация модуля (переменных и железа)
;     637       Вход:  -
;     638       Выход: -
;     639 \**************************************************************************/
;     640 void KbdInit(void)
;     641 {

	.CSEG
_KbdInit:
;     642     btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x8
;     643     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     644 }
	RET
;     645 
;     646 /**************************************************************************\
;     647     Сканирование клавиатуры
;     648       Вход:  -
;     649       Выход: -
;     650 \**************************************************************************/
;     651 void ScanKbd(void)
;     652 {
_ScanKbd:
;     653     switch (byScanState)
	LDS  R30,_byScanState
;     654     {
;     655         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x62
;     656             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     657             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0x63
;     658             {
;     659                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0xA
	STS  _byCheckedKey,R30
;     660 
;     661                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xB
;     662 
;     663                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
;     664             }
;     665             break;
_0x63:
	RJMP _0x61
;     666 
;     667         case ST_CHECK_KEY:
_0x62:
	CPI  R30,LOW(0x1)
	BRNE _0x64
;     668             // Если клавиша удердивалась достаточно долго, то
;     669             // генерируем событие с кодом клавиши, и переходим к
;     670             // ожиданию отпускания клавиши
;     671             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0xA
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0x65
;     672             {
;     673                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
;     674                 if (!byCheckKeyCnt)
	RCALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x66
;     675                 {
;     676                     btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x8
;     677                     byKeyCode = byCheckedKey;
	LDS  R6,_byCheckedKey
;     678                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
;     679                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     680                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	RCALL SUBOPT_0xE
;     681                 }
;     682             }
_0x66:
;     683             // Если данные неустойчитывы, то возвращается назад,
;     684             // к ожиданию нажатия клавиши
;     685             else
	RJMP _0x67
_0x65:
;     686                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     687             break;
_0x67:
	RJMP _0x61
;     688 
;     689         case ST_RELEASE_WAIT:
_0x64:
	CPI  R30,LOW(0x2)
	BRNE _0x61
;     690             // Пока клавиша не будет отпущена на достаточный интервал
;     691             // времени, будем оставаться в этом состоянии
;     692             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0x69
;     693             {
;     694                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     695                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0x6A
;     696                 {
;     697                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xE
;     698                   btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x8
;     699                 }
;     700                 byIterationCounter--;
_0x6A:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RCALL SUBOPT_0xE
	SUBI R30,-LOW(1)
;     701             }
;     702             else
	RJMP _0x6B
_0x69:
;     703             {
;     704                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	ADIW R30,1
;     705                 if (!byCheckKeyCnt)
	RCALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x6C
;     706                 {
;     707                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     708                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	RCALL SUBOPT_0xE
;     709                 }
;     710             }
_0x6C:
_0x6B:
;     711             break;
;     712     }
_0x61:
;     713     if( btKeyUpdate )
	LDS  R30,_btKeyUpdate
	CPI  R30,0
	BREQ _0x6D
;     714     {
;     715       btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x8
;     716       ProcessKey();
	RCALL _ProcessKey
;     717     }
;     718 }
_0x6D:
	RET
;     719 
;     720 /**************************************************************************\
;     721     Обработка нажатой клавиши.
;     722       Вход:  -
;     723       Выход: -
;     724 \**************************************************************************/
;     725 void ProcessKey(void)
;     726 {
_ProcessKey:
;     727     switch (byKeyCode)
	MOV  R30,R6
;     728     {
;     729         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0x71
;     730             switch (View)
	MOV  R30,R7
;     731             {
;     732               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x75
;     733                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0xF
;     734                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x87
;     735               break;
;     736               case 1:               //если мы в режиме "Установленная температура", то
_0x75:
	CPI  R30,LOW(0x1)
	BRNE _0x76
;     737                 if (T_LoadOn > 450) //если "Установленная температура" > -55°C, то
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x77
;     738                 {
;     739                   T_LoadOn --;      //уменьшаем значение на 0,1°
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
;     740                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     741                 }
;     742                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x77:
	RCALL SUBOPT_0xF
;     743                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x87
;     744               break;
;     745               case 2:               //если мы в режиме "Дэльта", то
_0x76:
	CPI  R30,LOW(0x2)
	BRNE _0x74
;     746                 if (DeltaT > 1)     //если "Дэльта" больше 0,1°, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x79
;     747                 {
;     748                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
;     749                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     750                 }
;     751                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0x79:
_0x87:
	LDI  R30,LOW(5)
	MOV  R4,R30
;     752               break;
;     753             }
_0x74:
;     754 
;     755         break;
	RJMP _0x70
;     756 
;     757         case KEY_2:                 // Была нажата клавиша Плюс
_0x71:
	CPI  R30,LOW(0x2)
	BRNE _0x7A
;     758             switch (View)
	MOV  R30,R7
;     759             {
;     760               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x7E
;     761                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0xF
;     762                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x88
;     763               break;
;     764               case 1:               //если мы в режиме "Установленная температура", то
_0x7E:
	CPI  R30,LOW(0x1)
	BRNE _0x7F
;     765                 if (T_LoadOn < (2250 - DeltaT))    //если температура ниже 125,0° - Дэельта
	LDI  R30,LOW(2250)
	LDI  R31,HIGH(2250)
	SUB  R30,R12
	SBC  R31,R13
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x80
;     766                 {
;     767                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
;     768                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     769                 }
;     770                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x80:
	RCALL SUBOPT_0xF
;     771                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	RJMP _0x88
;     772               break;
;     773               case 2:
_0x7F:
	CPI  R30,LOW(0x2)
	BRNE _0x7D
;     774                 if (DeltaT < 900) if ((T_LoadOn + DeltaT) < 2250)   //если Дельта меньше 90,0°, то
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R12,R30
	CPC  R13,R31
	BRSH _0x82
	MOVW R26,R12
	ADD  R26,R10
	ADC  R27,R11
	CPI  R26,LOW(0x8CA)
	LDI  R30,HIGH(0x8CA)
	CPC  R27,R30
	BRSH _0x83
;     775                 {
;     776                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
;     777                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     778                 }
;     779                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0x83:
_0x82:
_0x88:
	LDI  R30,LOW(5)
	MOV  R4,R30
;     780               break;
;     781             }
_0x7D:
;     782         break;
	RJMP _0x70
;     783 
;     784         case KEY_3:               // Была нажаты обе кноки вместе.
_0x7A:
	CPI  R30,LOW(0x3)
	BRNE _0x85
;     785             View = 2;              //переходим в режим "Дэльта"
	LDI  R30,LOW(2)
	MOV  R7,R30
;     786             Counter = 5;           //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R4,R30
;     787         break;
;     788 
;     789         default:
_0x85:
;     790         break;
;     791 
;     792     }
_0x70:
;     793 
;     794 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	__DELAY_USW 300
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	MOVW R22,R30
	MOV  R26,R18
	LDI  R27,0
	RCALL SUBOPT_0x0
	RCALL __MULW12U
	RCALL __LSRW4
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _btKeyUpdate,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _byScanState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _byCheckKeyCnt,R30
	STS  _byCheckKeyCnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDS  R30,_byCheckKeyCnt
	LDS  R31,_byCheckKeyCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	SBIW R30,1
	STS  _byCheckKeyCnt,R30
	STS  _byCheckKeyCnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	STS  _byIterationCounter,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	MOV  R7,R30
	RET

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
	inc  r30
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
	ldi  r22,8
	ld   r23,y+
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

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__GEW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRSH __GEW12UT
	CLR  R30
__GEW12UT:
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
