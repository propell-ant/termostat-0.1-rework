
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
;      52 bit Updating;         //служебная переменная
;      53 bit Minus;            //равна "1" если температура отрицательная
;      54 bit LoadOn;           //равна "1" если включена нагрузка
;      55 bit Initialising;        //равна "1" до получения первого значения температуры с датчика
;      56 
;      57 BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;      58 BYTE View = 0;            //определяет в каком режиме отображения находится устройство:
;      59                           //0 - основной - Текущая температура
;      60                           //1 - Установленная температура
;      61                           //2 - Дэльта
;      62 union SettingsU Settings;
_Settings:
	.BYTE 0x8
;      63 // struct SVars
;      64 // {
;      65 //   WORD _Tnew;
;      66 //   WORD _T_LoadOn;
;      67 //   WORD _DeltaT;
;      68 // };
;      69 //
;      70 // union SettingsU {
;      71 //             WORD data[4];
;      72 //             struct SVars vars;
;      73 //             } Settings;
;      74 //
;      75 //
;      76 // //WORD Tnew;                //для хранения нового значения измеренной температуры
;      77 // #define Tnew Settings.vars._Tnew
;      78 // //WORD T_LoadOn;            //для хранения значения Установленной температуры
;      79 // #define T_LoadOn Settings.vars._T_LoadOn
;      80 // //WORD DeltaT;              //для хранения значения Дэльты
;      81 // #define DeltaT Settings.vars._DeltaT
;      82 #ifdef CorCode //  *** Grey4ip  ***
;      83 WORD CorT;                //для хранения коррекции
;      84 #endif
;      85 //WORD* curMenuValue;
;      86 
;      87 // flash WORD MinMenu[3]={10,20,30};
;      88 //flash WORD MaxMenu[3]={11,21,31};
;      89 bit NeedResetLoad = 0;
;      90 eeprom WORD eeT_LoadOn = 1280;   //1280 = +28°C 1140 = +14°C

	.ESEG
_eeT_LoadOn:
	.DW  0x500
;      91 eeprom WORD eeDeltaT = 10;       //1°C
_eeDeltaT:
	.DW  0xA
;      92 #ifdef CorCode //  *** Grey4ip  ***
;      93 eeprom WORD eeCorT = 1000; //0°C
_eeCorT:
	.DW  0x3E8
;      94 #endif
;      95 
;      96 //температура для удобства представлена так:
;      97 // - до 1000 = отрицательная
;      98 // - 1000 = 0
;      99 // - больше 1000 = положительная
;     100 // - 0,1°С = 1
;     101 //---------------------------------
;     102 //-55°C = 450
;     103 //-25°C = 750
;     104 //-10.1°C = 899
;     105 //0°C = 1000
;     106 //10.1°C = 1101
;     107 //25°C = 1250
;     108 //85°C = 1850
;     109 //125°C = 2250
;     110 
;     111 
;     112 BYTE byCharacter[15] = {0xFA,     //0

	.DSEG
_byCharacter:
;     113                 0x82,   //1
;     114  	        0xB9,   //2
;     115 	        0xAB,	//3
;     116 	        0xC3,     //4
;     117 	        0x6B,     //5
;     118 	        0x7B,     //6
;     119                 0xA2,    //7
;     120                 0xFB,      //8
;     121                 0xEB,      //9
;     122                 0x00,      //blank
;     123                 0x01,     //-
;     124                 0x78,     //C
;     125                 0x9B,     //d
;     126                 0x58      //L
;     127                 };
	.BYTE 0xF
;     128 
;     129 
;     130 
;     131 /************************************************************************\
;     132 \************************************************************************/
;     133 void PrepareData(unsigned int Data)
;     134 {

	.CSEG
_PrepareData:
;     135     BYTE i;
;     136     unsigned int D, D1;
;     137     if (Initialising)
	RCALL __SAVELOCR6
;	Data -> Y+6
;	i -> R17
;	D -> R18,R19
;	D1 -> R20,R21
	SBIC 0x13,3
;     138     {
;     139       return;
	RJMP _0x9F
;     140     }
;     141     D = Data;
	__GETWRS 18,19,6
;     142 
;     143     if (D >= 1000) //если Температура больше нуля
	__CPWRN 18,19,1000
	BRLO _0x6
;     144     {
;     145       D = D - 1000;
	__SUBWRN 18,19,1000
;     146       Minus = 0;
	CBI  0x13,1
;     147     }
;     148     else
	RJMP _0x9
_0x6:
;     149     {
;     150       D = 1000 - D;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	SUB  R30,R18
	SBC  R31,R19
	MOVW R18,R30
;     151       Minus = 1;
	SBI  0x13,1
;     152     }
_0x9:
;     153     D1 = D;
	MOVW R20,R18
;     154 
;     155     //Преобразуем в десятичное представление
;     156     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0xD:
	CPI  R17,4
	BRSH _0xE
;     157     {
;     158        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21U
	MOV  R26,R16
	ST   X,R30
;     159        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21U
	MOVW R18,R30
;     160     }
	SUBI R17,-1
	RJMP _0xD
_0xE:
;     161 
;     162     if (D1 < 100)
	__CPWRN 20,21,100
	BRSH _0xF
;     163     {
;     164       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     165       byDisplay[1] = 10;
	__PUTB1MN _byDisplay,1
;     166 
;     167       goto exit;
	RJMP _0x10
;     168     }
;     169     if ((D1 >= 100) & (D1 <1000))
_0xF:
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __GEW12U
	MOV  R0,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __LTW12U
	AND  R30,R0
	BREQ _0x11
;     170     {
;     171       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     172       goto exit;
;     173     }
;     174 
;     175 exit:
_0x11:
_0x10:
;     176   if (View == 2)
	LDI  R30,LOW(2)
	CP   R30,R2
	BRNE _0x12
;     177   {
;     178     byDisplay[0] = 13;
	LDI  R30,LOW(13)
	RJMP _0xA0
;     179   }
;     180 #ifdef CorCode          //  *** Grey4ip  ***
;     181     else if (View == 4) // Если режим настройки коррекции, то
_0x12:
	LDI  R30,LOW(4)
	CP   R30,R2
	BRNE _0x14
;     182     {
;     183       byDisplay[0] = 12; // выводим букву "С" в первом разряде
	LDI  R30,LOW(12)
_0xA0:
	STS  _byDisplay,R30
;     184     }
;     185 #endif
;     186 }
_0x14:
_0x9F:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     187 
;     188 /************************************************************************\
;     189   Вывод экранного буфера на дисплей.
;     190       Вход:  -
;     191       Выход: -
;     192 \************************************************************************/
;     193 void ShowDisplayData(void)
;     194 {
_ShowDisplayData:
;     195  #ifdef Cathode
;     196 
;     197   PORTB = byCharacter[byDisplay[0]];
;     198   if (Minus)
;     199   {
;     200     PORTB = PINB | 0b00000001;
;     201   }
;     202   #ifdef heat
;     203   if (LoadOn)
;     204   #endif
;     205 
;     206   #ifdef cold
;     207   if (!LoadOn)
;     208   #endif
;     209   {
;     210     PORTB = PINB | 0b00000100;
;     211   }
;     212   if (View == 1)
;     213   {
;     214     PORTB = PINB | 0b00001000;
;     215   }
;     216   PORTD.5 = 0;
;     217   delay_us(LED_delay);
;     218   PORTD.5 = 1;
;     219 
;     220   PORTB = byCharacter[byDisplay[1]];
;     221   PORTD.1 = 0;
;     222   delay_us(LED_delay);
;     223   PORTD.1 = 1;
;     224 
;     225   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     226   PORTD.0 = 0;
;     227   delay_us(LED_delay);
;     228   PORTD.0 = 1;
;     229 
;     230   PORTB = byCharacter[byDisplay[3]];
;     231   PORTD.4 = 0;
;     232   delay_us(LED_delay);
;     233   PORTD.4 = 1;
;     234 #endif
;     235 
;     236 #ifdef Anode
;     237   PORTB = ~byCharacter[byDisplay[0]];
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x1
;     238   if (Minus)
	SBIS 0x13,1
	RJMP _0x15
;     239   {
;     240     PORTB = PINB & 0b11111110;
	IN   R30,0x16
	ANDI R30,0xFE
	OUT  0x18,R30
;     241   }
;     242   #ifdef heat
;     243   if (LoadOn)
_0x15:
	SBIS 0x13,2
	RJMP _0x16
;     244   #endif
;     245 
;     246   #ifdef cold
;     247   if (!LoadOn)
;     248   #endif
;     249   {
;     250     PORTB = PINB & 0b11111011;
	IN   R30,0x16
	ANDI R30,0xFB
	OUT  0x18,R30
;     251   }
;     252   if (View == 1)
_0x16:
	LDI  R30,LOW(1)
	CP   R30,R2
	BRNE _0x17
;     253   {
;     254     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     255   }
;     256   PORTD.5 = 1;
_0x17:
	SBI  0x12,5
;     257   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     258   PORTD.5 = 0;
	CBI  0x12,5
;     259 
;     260   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x1
;     261   PORTD.1 = 1;
	SBI  0x12,1
;     262   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     263   PORTD.1 = 0;
	CBI  0x12,1
;     264 
;     265   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     266   PORTD.0 = 1;
	SBI  0x12,0
;     267   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     268   PORTD.0 = 0;
	CBI  0x12,0
;     269 
;     270   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x1
;     271   PORTD.4 = 1;
	SBI  0x12,4
;     272   delay_us(LED_delay);
	RCALL SUBOPT_0x2
;     273   PORTD.4 = 0;
	CBI  0x12,4
;     274 #endif
;     275 
;     276 
;     277   }
	RET
;     278 
;     279 
;     280 /************************************************************************\
;     281   Обновление дисплея.
;     282       Вход:  -
;     283       Выход: -
;     284 \************************************************************************/
;     285 void RefreshDisplay(void)
;     286 {
_RefreshDisplay:
;     287   WORD Data;
;     288   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R2
;     289   {
;     290     case 0:
	CPI  R30,0
	BRNE _0x2B
;     291       Data = Tnew;
	__GETWRMN 16,17,0,_Settings
;     292       if (T_LoadOn != eeT_LoadOn)
	__POINTB2MN _Settings,2
	LD   R0,X+
	LD   R1,X
	RCALL SUBOPT_0x3
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x2C
;     293         eeT_LoadOn = T_LoadOn;
	__GETW1MN _Settings,2
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     294       if (DeltaT != eeDeltaT)
_0x2C:
	__POINTB2MN _Settings,4
	LD   R0,X+
	LD   R1,X
	RCALL SUBOPT_0x4
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x2D
;     295         eeDeltaT = DeltaT;
	RCALL SUBOPT_0x5
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     296       if (CorT != eeCorT)
_0x2D:
	RCALL SUBOPT_0x6
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x2E
;     297         eeCorT = CorT;
	MOVW R30,R4
	LDI  R26,LOW(_eeCorT)
	LDI  R27,HIGH(_eeCorT)
	RCALL __EEPROMWRW
;     298     break;
_0x2E:
	RJMP _0x2A
;     299     case 1:
_0x2B:
	CPI  R30,LOW(0x1)
	BRNE _0x2F
;     300       Data = T_LoadOn;
	__GETWRMN 16,17,_Settings,2
;     301     break;
	RJMP _0x2A
;     302 
;     303     case 2:
_0x2F:
	CPI  R30,LOW(0x2)
	BRNE _0x30
;     304       Data = DeltaT + 1000;
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	MOVW R16,R30
;     305     break;
	RJMP _0x2A
;     306     #ifdef CorCode //  *** Grey4ip  ***
;     307     case 4: // Выводим сдвиг температуры датчика
_0x30:
	CPI  R30,LOW(0x4)
	BRNE _0x2A
;     308       Data = CorT;
	MOVW R16,R4
;     309     break;
;     310     #endif
;     311   }
_0x2A:
;     312 
;     313   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     314 }
	RCALL __LOADLOCR2P
	RET
;     315 
;     316 // Timer 0 overflow interrupt service routine
;     317 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     318 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x7
;     319 // Reinitialize Timer 0 value
;     320 TCNT0=0xBF;
	LDI  R30,LOW(191)
	OUT  0x32,R30
;     321 
;     322 ScanKbd();
	RCALL _ScanKbd
;     323 }
	RCALL SUBOPT_0x8
	RETI
;     324 
;     325 // Timer 1 overflow interrupt service routine
;     326 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     327 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x7
;     328   BYTE t1;
;     329   BYTE t2;
;     330   BYTE i;
;     331   WORD Temp;
;     332   WORD T;
;     333   BYTE Ff;
;     334 // Reinitialize Timer 1 value
;     335 TCNT1H=0x8F;
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
;     336 TCNT1L=0xD1;
	LDI  R30,LOW(209)
	OUT  0x2C,R30
;     337 
;     338 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     339 
;     340 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x33:
	CPI  R19,11
	BRSH _0x34
;     341   {
;     342     ShowDisplayData();
	RCALL _ShowDisplayData
;     343   }
	SUBI R19,-1
	RJMP _0x33
_0x34:
;     344 
;     345 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     346 
;     347 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x36:
	CPI  R19,11
	BRSH _0x37
;     348   {
;     349     ShowDisplayData();
	RCALL _ShowDisplayData
;     350   }
	SUBI R19,-1
	RJMP _0x36
_0x37:
;     351 
;     352 Updating = !Updating;   //это шоб читать температуру через раз
	SBIS 0x13,0
	RJMP _0x38
	CBI  0x13,0
	RJMP _0x39
_0x38:
	SBI  0x13,0
_0x39:
;     353 
;     354 if (Updating)           //если в этот раз читаем температуру, то
	SBIS 0x13,0
	RJMP _0x3A
;     355 {
;     356   w1_write(0xBE);       //выдаём в шину 1-wire код 0xCC, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
;     357 
;     358   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x3C:
	CPI  R19,11
	BRSH _0x3D
;     359   {
;     360     ShowDisplayData();
	RCALL _ShowDisplayData
;     361   }
	SUBI R19,-1
	RJMP _0x3C
_0x3D:
;     362 
;     363   t1=w1_read();   //LSB //читаем младший байт данных
	RCALL _w1_read
	MOV  R17,R30
;     364 
;     365   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x3F:
	CPI  R19,11
	BRSH _0x40
;     366   {
;     367     ShowDisplayData();
	RCALL _ShowDisplayData
;     368   }
	SUBI R19,-1
	RJMP _0x3F
_0x40:
;     369   t2=w1_read();   //MSB //читаем старший байт данных
	RCALL _w1_read
	MOV  R16,R30
;     370 
;     371   // значения из даташита (для проверки раскоментировать нужное значение)
;     372 
;     373   //+125°C
;     374   //t2 = 0b00000111; //MSB
;     375   //t1 = 0b11010000; //LSB
;     376 
;     377   //+85°C
;     378   //t2 = 0b00000101; //MSB
;     379   //t1 = 0b01010000; //LSB
;     380 
;     381   //+25.0625°C
;     382   //t2 = 0b00000001; //MSB
;     383   //t1 = 0b10010001; //LSB
;     384 
;     385   //+10.125°C
;     386   //t2 = 0b00000000; //MSB
;     387   //t1 = 0b10100010; //LSB
;     388 
;     389   //+0.5°C
;     390   //t2 = 0b00000000; //MSB
;     391   //t1 = 0b00001000; //LSB
;     392 
;     393   //0°C
;     394   //t2 = 0b00000000; //MSB
;     395   //t1 = 0b00000000; //LSB
;     396 
;     397   //-0.5°C
;     398   //t2 = 0b11111111; //MSB
;     399   //t1 = 0b11111000; //LSB
;     400 
;     401   //-10.125°C
;     402   //t2 = 0b11111111; //MSB
;     403   //t1 = 0b01011110; //LSB
;     404 
;     405   //-25.0625°C
;     406   //t2 = 0b11111110; //MSB
;     407   //t1 = 0b01101111; //LSB
;     408 
;     409   //-55°C
;     410   //t2 = 0b11111100; //MSB
;     411   //t1 = 0b10010000; //LSB
;     412 
;     413 
;     414 
;     415 
;     416   Ff = (t1 & 0x0F);           //из LSB выделяем дробную часть значения температуры
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R18,R30
;     417   t2 = t2 << 4;
	SWAP R16
	ANDI R16,0xF0
;     418   t1 = t1 >> 4;
	SWAP R17
	ANDI R17,0xF
;     419   T = (t2 & 0xF0) | (t1 & 0x0F);    //после объедининия смещённых частей LSB и MSB объединяем
	MOV  R30,R16
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	OR   R30,R26
	LDI  R31,0
	STD  Y+6,R30
	STD  Y+6+1,R31
;     420                                     //их и получаем целую часть значения температуры.
;     421                                     //подробней - смотри даташит.
;     422 
;     423   if (T & 0b10000000) //если отрицательная температура
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x41
;     424   {
;     425     Ff = ~Ff + 1;         //инвертируем значение дробной части и добавляем адын.
	MOV  R30,R18
	COM  R30
	SUBI R30,-LOW(1)
	MOV  R18,R30
;     426     Ff = Ff & 0b00001111; //убираем лишние биты
	ANDI R18,LOW(15)
;     427 
;     428     if (!Ff)              //если дробная часть равна "0"
	CPI  R18,0
	BRNE _0x42
;     429     {
;     430       T--;                //значение температуры уменьшаем на адын
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
;     431     }
;     432 
;     433     #ifndef CorCode //  *** Grey4ip  ***
;     434     Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //вычисляем значение температуры если T < 0.
;     435                                                           //Формат хранения - смотри строку 58 этого файла.
;     436     #else
;     437     Tnew = CorT - (((~T & 0xFF) * 10U) + ((Ff * 10U) / 16));  //вычисляем значение температуры если T < 0. с коррекцией
_0x42:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	COM  R30
	COM  R31
	ANDI R31,HIGH(0xFF)
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	RCALL SUBOPT_0x9
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R4
	SUB  R30,R26
	SBC  R31,R27
	RJMP _0xA1
;     438     #endif
;     439   }
;     440   else
_0x41:
;     441   {
;     442    #ifndef CorCode //  *** Grey4ip  ***
;     443    Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0.
;     444                                                           //Формат хранения - смотри строку 58 этого файла.
;     445    #else
;     446    Tnew = CorT + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0.
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x0
	RCALL __MULW12U
	ADD  R30,R4
	ADC  R31,R5
	RCALL SUBOPT_0x9
	ADD  R30,R22
	ADC  R31,R23
_0xA1:
	LDI  R26,LOW(_Settings)
	ST   X+,R30
	ST   X,R31
;     447    #endif
;     448   }
;     449   Tnew = Tnew + 0;
	LDS  R30,_Settings
	LDS  R31,_Settings+1
	ADIW R30,0
	LDI  R26,LOW(_Settings)
	ST   X+,R30
	ST   X,R31
;     450   Initialising = 0;//хватит показывать заставку
	CBI  0x13,3
;     451 }
;     452 else
	RJMP _0x46
_0x3A:
;     453 {
;     454   w1_write(0x44);          //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
;     455 }
_0x46:
;     456 
;     457 
;     458 if (!Initialising)
	SBIC 0x13,3
	RJMP _0x47
;     459 {
;     460 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     461 
;     462 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	RCALL SUBOPT_0xB
	CP   R26,R20
	CPC  R27,R21
	BRLO _0x48
	SBIC 0x13,2
	RJMP _0x4A
	SBIS 0x13,4
	RJMP _0x49
_0x4A:
;     463 {                              //то выключаем нагрузку
;     464   PORTD.3 = 1;
	SBI  0x12,3
;     465   PORTD.2 = 0;
	CBI  0x12,2
;     466   LoadOn = 0;
	CBI  0x13,2
;     467   NeedResetLoad = 0;
	CBI  0x13,4
;     468 }
;     469 
;     470 Temp = T_LoadOn;                //Temp - временная переменная.
_0x49:
_0x48:
	__GETWRMN 20,21,_Settings,2
;     471 
;     472 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	RCALL SUBOPT_0xB
	CP   R20,R26
	CPC  R21,R27
	BRLO _0x54
	SBIS 0x13,2
	RJMP _0x56
	SBIS 0x13,4
	RJMP _0x55
_0x56:
;     473 {                               //то включаем нагрузку
;     474   PORTD.3 = 0;
	CBI  0x12,3
;     475   PORTD.2 = 1;
	SBI  0x12,2
;     476   LoadOn = 1;
	SBI  0x13,2
;     477   NeedResetLoad = 0;
	CBI  0x13,4
;     478 }
;     479 }
_0x55:
_0x54:
;     480 
;     481 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x47:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x60
;     482 {
;     483   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R3
;     484 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     485 else                            //пока не станет равной "0".
	RJMP _0x61
_0x60:
;     486 {
;     487   View = 0;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R2
;     488 }
_0x61:
;     489 
;     490 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     491 
;     492 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RCALL SUBOPT_0x8
	RETI
;     493 
;     494 // Declare your global variables here
;     495 
;     496 void main(void)
;     497 {
_main:
;     498 // Declare your local variables here
;     499 
;     500 // Crystal Oscillator division factor: 1
;     501 #pragma optsize-
;     502 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     503 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     504 #ifdef _OPTIMIZE_SIZE_
;     505 #pragma optsize+
;     506 #endif
;     507 
;     508         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
;     509         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
;     510         //         если установлена 1 - то на выводе устанавливается лог. 1
;     511         //         если установлена 0 - то на выводе устанавливается лог. 0
;     512         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
;     513         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
;     514 
;     515         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     516         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     517 
;     518         PORTB=0b00000000;
	OUT  0x18,R30
;     519         DDRB= 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     520 
;     521 
;     522         #ifdef Cathode
;     523           PORTD=0b01110011;
;     524           DDRD= 0b00111111;
;     525         #endif
;     526 
;     527         #ifdef Anode
;     528           PORTD=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
;     529           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     530         #endif
;     531 
;     532 //выше уже проинициализировали
;     533 //PORTD.3 = 0;
;     534 //PORTD.2 = 0;
;     535 
;     536 // Timer/Counter 0 initialization
;     537 // Clock source: System Clock
;     538 // Clock value: 8000,000 kHz
;     539 // Mode: Normal top=FFh
;     540 // OC0A output: Disconnected
;     541 // OC0B output: Disconnected
;     542 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     543 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     544 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     545 OCR0A=0x00;
	OUT  0x36,R30
;     546 OCR0B=0x00;
	OUT  0x3C,R30
;     547 
;     548 // Timer/Counter 1 initialization
;     549 // Clock source: System Clock
;     550 // Clock value: 7,813 kHz
;     551 // Mode: Normal top=FFFFh
;     552 // OC1A output: Discon.
;     553 // OC1B output: Discon.
;     554 // Noise Canceler: Off
;     555 // Input Capture on Falling Edge
;     556 // Timer 1 Overflow Interrupt: On
;     557 // Input Capture Interrupt: Off
;     558 // Compare A Match Interrupt: Off
;     559 // Compare B Match Interrupt: Off
;     560 TCCR1A=0x00;
	OUT  0x2F,R30
;     561 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     562 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
;     563 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
;     564 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
;     565 ICR1L=0x00;
	OUT  0x24,R30
;     566 OCR1AH=0x00;
	OUT  0x2B,R30
;     567 OCR1AL=0x00;
	OUT  0x2A,R30
;     568 OCR1BH=0x00;
	OUT  0x29,R30
;     569 OCR1BL=0x00;
	OUT  0x28,R30
;     570 
;     571 // External Interrupt(s) initialization
;     572 // INT0: Off
;     573 // INT1: Off
;     574 // Interrupt on any change on pins PCINT0-7: Off
;     575 GIMSK=0x00;
	OUT  0x3B,R30
;     576 MCUCR=0x00;
	OUT  0x35,R30
;     577 
;     578 // Timer(s)/Counter(s) Interrupt(s) initialization
;     579 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
;     580 
;     581 // Universal Serial Interface initialization
;     582 // Mode: Disabled
;     583 // Clock source: Register & Counter=no clk.
;     584 // USI Counter Overflow Interrupt: Off
;     585 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     586 
;     587 // Analog Comparator initialization
;     588 // Analog Comparator: Off
;     589 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     590 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     591 
;     592 //Tnew = 1000;                //Это чтобы на экране был "0.0" при включении питания
;     593 
;     594 if ((eeT_LoadOn > 2250) | (eeT_LoadOn < 450))    //если в EEPROM значение > 2250 или < 450 значит он не прошился, или
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
	BREQ _0x62
;     595   eeT_LoadOn = 1280;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(1280)
	LDI  R31,HIGH(1280)
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     596 if (eeDeltaT > 900)
_0x62:
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLO _0x63
;     597   eeDeltaT = 10;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     598 #ifdef CorCode //  *** Grey4ip  ***
;     599 if ((eeCorT > MaxCorT) || (eeCorT < MinCorT))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не прошился, // mod by Grey4ip
_0x63:
	RCALL SUBOPT_0x6
	CPI  R30,LOW(0x44D)
	LDI  R26,HIGH(0x44D)
	CPC  R31,R26
	BRSH _0x65
	RCALL SUBOPT_0x6
	CPI  R30,LOW(0x384)
	LDI  R26,HIGH(0x384)
	CPC  R31,R26
	BRSH _0x64
_0x65:
;     600   eeCorT = 1000;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod by Grey4ip
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	LDI  R26,LOW(_eeCorT)
	LDI  R27,HIGH(_eeCorT)
	RCALL __EEPROMWRW
;     601 #endif
;     602 
;     603 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x64:
	RCALL SUBOPT_0x3
	__PUTW1MN _Settings,2
;     604 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x4
	__PUTW1MN _Settings,4
;     605 #ifdef CorCode //  *** Grey4ip  ***
;     606 CorT = eeCorT;      // читаем значение Коррекции из EEPROM в RAM
	RCALL SUBOPT_0x6
	MOVW R4,R30
;     607 #endif
;     608 
;     609 Initialising = 1;
	SBI  0x13,3
;     610 NeedResetLoad = 1;
	SBI  0x13,4
;     611 
;     612 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     613 
;     614 // w1_init();              //инициализация шины 1-wire
;     615 // w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
;     616 // w1_write(0x44);         //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
;     617 Updating = 1;
	SBI  0x13,0
;     618 
;     619 
;     620 KbdInit();              //инициализация клавиатуры :)
	RCALL _KbdInit
;     621 
;     622 // Global enable interrupts
;     623 #asm("sei")
	sei
;     624 
;     625 while (1)
_0x6D:
;     626       {
;     627       // Place your code here
;     628       #asm("cli");               //запрещаем прерывания
	cli
;     629       ShowDisplayData();         //обновляем экран
	RCALL _ShowDisplayData
;     630       #asm("sei");               //разрешаем прерывания
	sei
;     631       };
	RJMP _0x6D
;     632 
;     633 }
_0x70:
	RJMP _0x70
;     634 /**************************************************************************\
;     635  FILE ..........: KBD.C
;     636  AUTHOR ........: Vitaly Puzrin
;     637  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     638  NOTES .........:
;     639  COPYRIGHT .....: Vitaly Puzrin, 1999
;     640  HISTORY .......: DATE        COMMENT
;     641                   ---------------------------------------------------
;     642                   25.06.1999  Первая версия
;     643 \**************************************************************************/
;     644 
;     645 #include    "kbd.h"
;     646 #include <tiny2313.h>
;     647 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     648 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     649 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     650 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     651 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     652 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     653 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     654 	#endif
	#endif
;     655 
;     656 #if __CODEVISIONAVR__ > 2000
;     657 //проверка версии только для полной гарантии того, что
;     658 //оригинальная версия исходника не затрагивается
;     659 extern BYTE View;
;     660 extern BYTE Counter;
;     661 extern WORD T_LoadOn;
;     662 extern WORD DeltaT;
;     663 extern WORD* curMenuValue;
;     664 extern WORD* curMenuMin;
;     665 extern WORD* curMenuMax;
;     666 extern void RefreshDisplay(void);
;     667 #endif
;     668 
;     669 #define     ST_WAIT_KEY     0
;     670 #define     ST_CHECK_KEY    1
;     671 #define     ST_RELEASE_WAIT 2
;     672 
;     673 #define     KEY_1      0x01    // Код клавиши 1
;     674 #define     KEY_2      0x02    // Код клавиши 2
;     675 #define     KEY_3      0x03    // Код клавиши 3
;     676 
;     677 BOOLEAN btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу

	.DSEG
_btKeyUpdate:
	.BYTE 0x1
;     678 BYTE    byKeyCode;      // Код нажатой клавиши
;     679 
;     680 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
;     681 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
;     682 WORD    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
;     683 BYTE    byIterationCounter =  40;//Счётчик до повторения
;     684 
;     685 
;     686 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     687 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     688 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     689 
;     690 /**************************************************************************\
;     691     Инициализация модуля (переменных и железа)
;     692       Вход:  -
;     693       Выход: -
;     694 \**************************************************************************/
;     695 void KbdInit(void)
;     696 {

	.CSEG
_KbdInit:
;     697     btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xC
;     698     byScanState = ST_WAIT_KEY;
	CLR  R6
;     699 }
	RET
;     700 
;     701 /**************************************************************************\
;     702     Сканирование клавиатуры
;     703       Вход:  -
;     704       Выход: -
;     705 \**************************************************************************/
;     706 void ScanKbd(void)
;     707 {
_ScanKbd:
;     708     switch (byScanState)
	MOV  R30,R6
;     709     {
;     710         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x75
;     711             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     712             if (KeyCode != 0)
	RCALL SUBOPT_0xD
	BREQ _0x76
;     713             {
;     714                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0xD
	MOV  R9,R30
;     715 
;     716                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xE
;     717 
;     718                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	MOV  R6,R30
;     719             }
;     720             break;
_0x76:
	RJMP _0x74
;     721 
;     722         case ST_CHECK_KEY:
_0x75:
	CPI  R30,LOW(0x1)
	BRNE _0x77
;     723             // Если клавиша удердивалась достаточно долго, то
;     724             // генерируем событие с кодом клавиши, и переходим к
;     725             // ожиданию отпускания клавиши
;     726             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0xD
	CP   R30,R9
	BRNE _0x78
;     727             {
;     728                 byCheckKeyCnt--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
;     729                 if (!byCheckKeyCnt)
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x79
;     730                 {
;     731                     btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xC
;     732                     byKeyCode = byCheckedKey;
	MOV  R7,R9
;     733                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	MOV  R6,R30
;     734                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xE
;     735                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	MOV  R8,R30
;     736                 }
;     737             }
_0x79:
;     738             // Если данные неустойчитывы, то возвращается назад,
;     739             // к ожиданию нажатия клавиши
;     740             else
	RJMP _0x7A
_0x78:
;     741                 byScanState = ST_WAIT_KEY;
	CLR  R6
;     742             break;
_0x7A:
	RJMP _0x74
;     743 
;     744         case ST_RELEASE_WAIT:
_0x77:
	CPI  R30,LOW(0x2)
	BRNE _0x74
;     745             // Пока клавиша не будет отпущена на достаточный интервал
;     746             // времени, будем оставаться в этом состоянии
;     747             if (KeyCode != 0)
	RCALL SUBOPT_0xD
	BREQ _0x7C
;     748             {
;     749                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xE
;     750                 if (!byIterationCounter)
	TST  R8
	BRNE _0x7D
;     751                 {
;     752                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	MOV  R8,R30
;     753                   btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xC
;     754                 }
;     755                 byIterationCounter--;
_0x7D:
	DEC  R8
;     756             }
;     757             else
	RJMP _0x7E
_0x7C:
;     758             {
;     759                 byCheckKeyCnt--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	ADIW R30,1
;     760                 if (!byCheckKeyCnt)
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x7F
;     761                 {
;     762                     byScanState = ST_WAIT_KEY;
	CLR  R6
;     763                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	MOV  R8,R30
;     764                 }
;     765             }
_0x7F:
_0x7E:
;     766             break;
;     767     }
_0x74:
;     768     if( btKeyUpdate )
	LDS  R30,_btKeyUpdate
	CPI  R30,0
	BREQ _0x80
;     769     {
;     770       btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xC
;     771       ProcessKey();
	RCALL _ProcessKey
;     772     }
;     773 }
_0x80:
	RET
;     774 
;     775 /**************************************************************************\
;     776     Обработка нажатой клавиши.
;     777       Вход:  -
;     778       Выход: -
;     779 \**************************************************************************/
;     780 void ProcessKey(void)
;     781 {
_ProcessKey:
;     782     switch (byKeyCode)
	MOV  R30,R7
;     783     {
;     784         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0x84
;     785             switch (View)
	MOV  R30,R2
;     786             {
;     787               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x88
;     788                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0xF
;     789               break;
	RJMP _0x87
;     790               case 1:               //если мы в режиме "Установленная температура", то
_0x88:
	CPI  R30,LOW(0x1)
	BRNE _0x89
;     791                 if (T_LoadOn > 450) //если "Установленная температура" > -55°C, то
	RCALL SUBOPT_0xA
	CPI  R26,LOW(0x1C3)
	LDI  R30,HIGH(0x1C3)
	CPC  R27,R30
	BRLO _0x8A
;     792                 {
;     793                   T_LoadOn --;      //уменьшаем значение на 0,1°
	__POINTB2MN _Settings,2
	RCALL SUBOPT_0x10
;     794                   RefreshDisplay(); //обновляем данные на экране
;     795                 }
;     796                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x8A:
	RCALL SUBOPT_0xF
;     797               break;
	RJMP _0x87
;     798               case 2:               //если мы в режиме "Дэльта", то
_0x89:
	CPI  R30,LOW(0x2)
	BRNE _0x8B
;     799                 if (DeltaT > 1)     //если "Дэльта" больше 0,1°, то
	RCALL SUBOPT_0x11
	SBIW R26,2
	BRLO _0x8C
;     800                 {
;     801                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	__POINTB2MN _Settings,4
	RCALL SUBOPT_0x10
;     802                   RefreshDisplay(); //обновляем данные на экране
;     803                 }
;     804               break;
_0x8C:
	RJMP _0x87
;     805               #ifdef CorCode
;     806               case 4:                   //если мы в режиме "Коррекции", то
_0x8B:
	CPI  R30,LOW(0x4)
	BRNE _0x87
;     807                 if (CorT > MinCorT)
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x8E
;     808                 {
;     809                     CorT--;         //уменьшаем значение на 0,1°
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
;     810                 }
;     811                 break;
_0x8E:
;     812               #endif
;     813             }
_0x87:
;     814         break;
	RJMP _0x83
;     815 
;     816         case KEY_2:                 // Была нажата клавиша Плюс
_0x84:
	CPI  R30,LOW(0x2)
	BRNE _0x8F
;     817             switch (View)
	MOV  R30,R2
;     818             {
;     819               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x93
;     820                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0xF
;     821               break;
	RJMP _0x92
;     822               case 1:               //если мы в режиме "Установленная температура", то
_0x93:
	CPI  R30,LOW(0x1)
	BRNE _0x94
;     823                 if (T_LoadOn < (2250 - DeltaT))    //если температура ниже 125,0° - Дэельта
	__GETWRMN 22,23,_Settings,2
	RCALL SUBOPT_0x5
	LDI  R26,LOW(2250)
	LDI  R27,HIGH(2250)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CP   R22,R30
	CPC  R23,R31
	BRSH _0x95
;     824                 {
;     825                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	__POINTB2MN _Settings,2
	RCALL SUBOPT_0x12
;     826                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     827                 }
;     828                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x95:
	RCALL SUBOPT_0xF
;     829               break;
	RJMP _0x92
;     830               case 2:
_0x94:
	CPI  R30,LOW(0x2)
	BRNE _0x96
;     831                 if (DeltaT < 900) if ((T_LoadOn + DeltaT) < 2250)   //если Дельта меньше 90,0°, то
	RCALL SUBOPT_0x11
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRSH _0x97
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x8CA)
	LDI  R30,HIGH(0x8CA)
	CPC  R27,R30
	BRSH _0x98
;     832                 {
;     833                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	__POINTB2MN _Settings,4
	RCALL SUBOPT_0x12
	SBIW R30,1
;     834                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     835                 }
;     836               break;
_0x98:
_0x97:
	RJMP _0x92
;     837               #ifdef CorCode
;     838               case 4:                   //если мы в режиме "Коррекции", то
_0x96:
	CPI  R30,LOW(0x4)
	BRNE _0x92
;     839                 if (CorT < MaxCorT)
	LDI  R30,LOW(1100)
	LDI  R31,HIGH(1100)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x9A
;     840                 {
;     841                     CorT++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
;     842                 }
;     843               break;
_0x9A:
;     844               #endif
;     845             }
_0x92:
;     846        break;
	RJMP _0x83
;     847 
;     848         case KEY_3:               // Была нажаты обе кноки вместе.
_0x8F:
	CPI  R30,LOW(0x3)
	BRNE _0x9E
;     849         #ifdef CorCode
;     850             if (View == 2)      // Если режим "Дэльта",
	LDI  R30,LOW(2)
	CP   R30,R2
	BRNE _0x9C
;     851             {
;     852                 View = 4;         // то переходим в режим "Коррекции"
	LDI  R30,LOW(4)
	RJMP _0xA2
;     853             }
;     854             else                // иначе
_0x9C:
;     855         #endif
;     856             View = 2;              //переходим в режим "Дэльта"
	LDI  R30,LOW(2)
_0xA2:
	MOV  R2,R30
;     857         break;
;     858 
;     859         default:
_0x9E:
;     860         break;
;     861 
;     862     }
_0x83:
;     863     Counter = 5;           //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R3,R30
;     864 }
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	__GETW1MN _Settings,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_eeCorT)
	LDI  R27,HIGH(_eeCorT)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
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
SUBOPT_0x8:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	MOVW R22,R30
	MOV  R26,R18
	LDI  R27,0
	RCALL SUBOPT_0x0
	RCALL __MULW12U
	RCALL __LSRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	__GETW2MN _Settings,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R26,_Settings
	LDS  R27,_Settings+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	STS  _btKeyUpdate,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	MOV  R2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _RefreshDisplay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETW2MN _Settings,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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
