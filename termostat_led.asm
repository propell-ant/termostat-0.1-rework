
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
;      50 #ifdef heat
;      51 #define ShowDotAtStartup 0
;      52 #endif
;      53 #ifdef cold
;      54 #define ShowDotAtStartup 1
;      55 #endif
;      56 
;      57 BYTE byDisplay[4]={11,11,11,11};    // буфер данных, для вывода на экран
_byDisplay:
	.BYTE 0x4
;      58 //BYTE byDisplay[4]={0,0,0,0};      // так потратит немножко меньше памяти, но покажет рпи старте 000.0
;      59 
;      60 bit Updating;         //служебная переменная
;      61 //bit Minus;            //равна "1" если температура отрицательная
;      62 bit LoadOn;           //равна "1" если включена нагрузка
;      63 bit Initialising;        //равна "1" до получения первого значения температуры с датчика
;      64 
;      65   bit AllDataFF;
;      66   bit NonZero;
;      67 
;      68 BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;      69 BYTE View = 0;            //определяет в каком режиме отображения находится устройство:
;      70                           //0 - основной - Текущая температура
;      71                           //1 - Установленная температура
;      72                           //2 - Дэльта
;      73 
;      74 int Tnew;                //для хранения нового значения измеренной температуры
;      75 int T_LoadOn;            //для хранения значения Установленной температуры
;      76 int DeltaT;              //для хранения значения Дэльты
;      77 
;      78 BYTE w1buffer[9];
_w1buffer:
	.BYTE 0x9
;      79 BYTE ErrorLevel;
;      80 BYTE ErrorCounter;
;      81 #define MaxDataErrors 1
;      82 bit NeedResetLoad = 0;
;      83 bit ErrorDetected = 0;
;      84 #ifdef heat
;      85 #define ShowDotWhenError 0
;      86 #endif
;      87 #ifdef cold
;      88 #define ShowDotWhenError 1
;      89 #endif
;      90 #define Blinking
;      91 #ifdef Blinking
;      92 #define BlinkHalfPeriod   48 //примерно 4 моргания в секунду
;      93 BYTE BlinkCounter;        //Счетчик мигания
;      94 BYTE DimmerCounter;        //Счетчик мигания
;      95 bit DigitsActive = 0;
;      96 #define DimmerDivider 4 //Это регулировка яркости: 4 соответствует 60%, 2 - примерно 35%
;      97 #else
;      98   #ifdef Cathode
;      99     #define DigitsActive 0
;     100   #endif
;     101   #ifdef Anode
;     102     #define DigitsActive 1
;     103   #endif
;     104 #endif
;     105 
;     106 eeprom int eeT_LoadOn = 1280;   //1280 = +28°C 1140 = +14°C

	.ESEG
_eeT_LoadOn:
	.DW  0x500
;     107 eeprom int eeDeltaT = 10;       //1°C
_eeDeltaT:
	.DW  0xA
;     108 
;     109 //температура для удобства представлена так:
;     110 // - до 1000 = отрицательная
;     111 // - 1000 = 0
;     112 // - больше 1000 = положительная
;     113 // - 0,1°С = 1
;     114 //---------------------------------
;     115 //-55°C = 450
;     116 //-25°C = 750
;     117 //-10.1°C = 899
;     118 //0°C = 1000
;     119 //10.1°C = 1101
;     120 //25°C = 1250
;     121 //85°C = 1850
;     122 //125°C = 2250
;     123 
;     124 
;     125 BYTE byCharacter[14] = {0xFA,     //0

	.DSEG
_byCharacter:
;     126                 0x82,   //1
;     127  	        0xB9,   //2
;     128 	        0xAB,	//3
;     129 	        0xC3,     //4
;     130 	        0x6B,     //5
;     131 	        0x7B,     //6
;     132                 0xA2,    //7
;     133                 0xFB,      //8
;     134                 0xEB,      //9
;     135                 0x00,      //blank
;     136                 0x01,     //-
;     137 //                0x70,     //t
;     138                 0x9B,     //d
;     139 //                0x58,     //L
;     140                 0x79      //E
;     141                 };
	.BYTE 0xE
;     142 
;     143 
;     144 
;     145 /************************************************************************\
;     146 \************************************************************************/
;     147 void PrepareData(int Data)
;     148 {

	.CSEG
_PrepareData:
;     149     BYTE i;
;     150     int D;
;     151     if (Initialising)
	RCALL __SAVELOCR4
;	Data -> Y+4
;	i -> R17
;	D -> R18,R19
	SBIC 0x13,3
;     152     {
;     153       return;
	RJMP _0xC3
;     154     }
;     155     if (Data < 0)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0x6
;     156     {
;     157       D = -Data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __ANEGW1
	MOVW R18,R30
;     158     }
;     159     else
	RJMP _0x7
_0x6:
;     160     {
;     161       D = Data;
	__GETWRS 18,19,4
;     162     }
_0x7:
;     163 
;     164     //Преобразуем в десятичное представление
;     165     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
;     166     {
;     167        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R16
	ST   X,R30
;     168        D /= 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOVW R18,R30
;     169     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
;     170 
;     171     if (byDisplay[0] == 0)
	LDS  R30,_byDisplay
	CPI  R30,0
	BRNE _0xB
;     172     {
;     173       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     174       if (byDisplay[1] == 0)
	__GETB1MN _byDisplay,1
	CPI  R30,0
	BRNE _0xC
;     175       {
;     176         byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
;     177       }
;     178     }
_0xC:
;     179     if (Data < 0)
_0xB:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0xD
;     180     {
;     181       byDisplay[0] = 11;
	LDI  R30,LOW(11)
	STS  _byDisplay,R30
;     182     }
;     183 
;     184     if (View == 2)
_0xD:
	LDI  R30,LOW(2)
	CP   R30,R2
	BRNE _0xE
;     185     {
;     186       byDisplay[0] = 12;
	LDI  R30,LOW(12)
	RJMP _0xC4
;     187     }
;     188     else
_0xE:
;     189     {
;     190       if (View == 3)
	LDI  R30,LOW(3)
	CP   R30,R2
	BREQ _0xC5
;     191       {
;     192         byDisplay[0] = 13;
;     193       }
;     194       else if (View == 0) if (ErrorCounter == 0)
	TST  R2
	BRNE _0x12
	TST  R10
	BRNE _0x13
;     195       {
;     196         byDisplay[0] = 13;
_0xC5:
	LDI  R30,LOW(13)
_0xC4:
	STS  _byDisplay,R30
;     197       }
;     198     }
_0x13:
_0x12:
;     199 
;     200 }
_0xC3:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     201 
;     202 /************************************************************************\
;     203   Вывод экранного буфера на дисплей.
;     204       Вход:  -
;     205       Выход: -
;     206 \************************************************************************/
;     207 // inline void ShowDisplayData(void)
;     208 // {
;     209 //  #ifdef Cathode
;     210 //   #ifdef Blinking
;     211 //   //BYTE
;     212 //   DigitsActive = 0;
;     213 //   DimmerCounter++;
;     214 //   if (BlinkCounter < BlinkHalfPeriod)
;     215 //   if (View == 0) if (ErrorDetected) if (DimmerCounter % 4 == 0)
;     216 //   {
;     217 //     DigitsActive = 1;
;     218 //   }
;     219 //   #endif
;     220 //
;     221 //   PORTB = byCharacter[byDisplay[0]];
;     222 //   if (Minus)
;     223 //   {
;     224 //     PORTB = PINB | 0b00000001;
;     225 //   }
;     226 //   #ifdef heat
;     227 //   if (LoadOn)
;     228 //   #endif
;     229 //
;     230 //   #ifdef cold
;     231 //   if (!LoadOn)
;     232 //   #endif
;     233 //   {
;     234 //     PORTB = PINB | 0b00000100;
;     235 //   }
;     236 //   if (View == 1)
;     237 //   {
;     238 //     PORTB = PINB | 0b00001000;
;     239 //   }
;     240 //   PORTD.5 = DigitsActive;
;     241 //   delay_us(LED_delay);
;     242 //   PORTD.5 = 1;
;     243 //
;     244 //   PORTB = byCharacter[byDisplay[1]];
;     245 //   PORTD.1 = DigitsActive;
;     246 //   delay_us(LED_delay);
;     247 //   PORTD.1 = 1;
;     248 //
;     249 //   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     250 //   PORTD.0 = DigitsActive;
;     251 //   delay_us(LED_delay);
;     252 //   PORTD.0 = 1;
;     253 //
;     254 //   PORTB = byCharacter[byDisplay[3]];
;     255 //   PORTD.4 = DigitsActive;
;     256 //   delay_us(LED_delay);
;     257 //   PORTD.4 = 1;
;     258 // #endif
;     259 //
;     260 // #ifdef Anode
;     261 //   #ifdef Blinking
;     262 //   //BYTE
;     263 //   DigitsActive = 1;
;     264 //   DimmerCounter++;
;     265 //   if (BlinkCounter < BlinkHalfPeriod)
;     266 //   if (View == 0) if (ErrorDetected) if (DimmerCounter % 4 == 0)
;     267 //   {
;     268 //     DigitsActive = 0;
;     269 //   }
;     270 //   #endif
;     271 //   PORTB = ~byCharacter[byDisplay[0]];
;     272 //   if (Minus)
;     273 //   {
;     274 //     PORTB = PINB & 0b11111110;
;     275 //   }
;     276 //   #ifdef heat
;     277 //   if (LoadOn)
;     278 //   #endif
;     279 //
;     280 //   #ifdef cold
;     281 //   if (!LoadOn)
;     282 //   #endif
;     283 //   {
;     284 //     PORTB = PINB & 0b11111011;
;     285 //   }
;     286 //   if (View == 1)
;     287 //   {
;     288 //     PORTB = PINB & 0b11110111;
;     289 //   }
;     290 //   PORTD.5 = DigitsActive;
;     291 //   delay_us(LED_delay);
;     292 //   PORTD.5 = 0;
;     293 //
;     294 //   PORTB = ~byCharacter[byDisplay[1]];
;     295 //   PORTD.1 = DigitsActive;
;     296 //   delay_us(LED_delay);
;     297 //   PORTD.1 = 0;
;     298 //
;     299 //   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
;     300 //   PORTD.0 = DigitsActive;
;     301 //   delay_us(LED_delay);
;     302 //   PORTD.0 = 0;
;     303 //
;     304 //   PORTB = ~byCharacter[byDisplay[3]];
;     305 //   PORTD.4 = DigitsActive;
;     306 //   delay_us(LED_delay);
;     307 //   PORTD.4 = 0;
;     308 // #endif
;     309 //
;     310 //
;     311 //   }
;     312 
;     313 
;     314 /************************************************************************\
;     315   Обновление дисплея.
;     316       Вход:  -
;     317       Выход: -
;     318 \************************************************************************/
;     319 void RefreshDisplay(void)
;     320 {
_RefreshDisplay:
;     321   int Data;
;     322   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R2
;     323   {
;     324     case 0:
	CPI  R30,0
	BRNE _0x17
;     325       if (ErrorCounter == 0)
	TST  R10
	BRNE _0x18
;     326       {
;     327         Data = ErrorLevel;// + 1000;
	MOV  R16,R11
	CLR  R17
;     328       }
;     329       else
	RJMP _0x19
_0x18:
;     330       {
;     331         Data = Tnew;
	MOVW R16,R4
;     332       }
_0x19:
;     333       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x0
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x1A
;     334         eeT_LoadOn = T_LoadOn;
	MOVW R30,R6
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     335       if (DeltaT != eeDeltaT)
_0x1A:
	RCALL SUBOPT_0x1
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1B
;     336         eeDeltaT = DeltaT;
	MOVW R30,R8
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     337     break;
_0x1B:
	RJMP _0x16
;     338     case 1:
_0x17:
	CPI  R30,LOW(0x1)
	BRNE _0x1C
;     339       Data = T_LoadOn;
	MOVW R16,R6
;     340     break;
	RJMP _0x16
;     341 
;     342     case 2:
_0x1C:
	CPI  R30,LOW(0x2)
	BRNE _0x1D
;     343       Data = DeltaT;// + 1000;
	MOVW R16,R8
;     344     break;
	RJMP _0x16
;     345     case 3:
_0x1D:
	CPI  R30,LOW(0x3)
	BRNE _0x16
;     346         Data = ErrorLevel;// + 1000;
	MOV  R16,R11
	CLR  R17
;     347     break;
;     348   }
_0x16:
;     349 
;     350   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     351 }
	RCALL __LOADLOCR2P
	RET
;     352 
;     353 // Timer 0 overflow interrupt service routine
;     354 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     355 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x2
;     356 // Reinitialize Timer 0 value
;     357 TCNT0=0xB5;
	LDI  R30,LOW(181)
	OUT  0x32,R30
;     358 if (BlinkCounter < 2 * BlinkHalfPeriod)
	LDI  R30,LOW(96)
	CP   R13,R30
	BRSH _0x1F
;     359 {
;     360   BlinkCounter++;
	INC  R13
;     361 }
;     362 else
	RJMP _0x20
_0x1F:
;     363 {
;     364   BlinkCounter = 0;
	CLR  R13
;     365 }
_0x20:
;     366 
;     367 ScanKbd();
	RCALL _ScanKbd
;     368 }
	RCALL SUBOPT_0x3
	RETI
;     369 
;     370 void ShowDisplayData11Times(void)
;     371 {
_ShowDisplayData11Times:
;     372   BYTE i;
;     373   for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,11
	BRLO PC+2
	RJMP _0x23
;     374   {
;     375 //    ShowDisplayData();
;     376  #ifdef Cathode
;     377   #ifdef Blinking
;     378   //BYTE
;     379   DigitsActive = 0;
;     380   DimmerCounter++;
;     381   if (BlinkCounter < BlinkHalfPeriod)
;     382   if (View == 0) if (ErrorDetected) if (DimmerCounter % DimmerDivider == 0)
;     383   {
;     384     DigitsActive = 1;
;     385   }
;     386   #endif
;     387 
;     388   PORTB = byCharacter[byDisplay[0]];
;     389 //   if (Minus)
;     390 //   {
;     391 //     PORTB = PINB | 0b00000001;
;     392 //   }
;     393   #ifdef heat
;     394   if (LoadOn)
;     395   #endif
;     396 
;     397   #ifdef cold
;     398   if (!LoadOn)
;     399   #endif
;     400   {
;     401     PORTB = PINB | 0b00000100;
;     402   }
;     403   if (View == 1)
;     404   {
;     405     PORTB = PINB | 0b00001000;
;     406   }
;     407   PORTD.5 = DigitsActive;
;     408   delay_us(LED_delay);
;     409   PORTD.5 = 1;
;     410 
;     411   PORTB = byCharacter[byDisplay[1]];
;     412   PORTD.1 = DigitsActive;
;     413   delay_us(LED_delay);
;     414   PORTD.1 = 1;
;     415 
;     416   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     417   PORTD.0 = DigitsActive;
;     418   delay_us(LED_delay);
;     419   PORTD.0 = 1;
;     420 
;     421   PORTB = byCharacter[byDisplay[3]];
;     422   PORTD.4 = DigitsActive;
;     423   delay_us(LED_delay);
;     424   PORTD.4 = 1;
;     425 #endif
;     426 
;     427 #ifdef Anode
;     428   #ifdef Blinking
;     429   //BYTE
;     430   DigitsActive = 1;
	SBI  0x14,0
;     431   DimmerCounter++;
	INC  R12
;     432   if (BlinkCounter < BlinkHalfPeriod)
	LDI  R30,LOW(48)
	CP   R13,R30
	BRSH _0x26
;     433   if (View == 0) if (ErrorDetected) if (DimmerCounter % DimmerDivider == 0)
	TST  R2
	BRNE _0x27
	SBIS 0x13,7
	RJMP _0x28
	MOV  R30,R12
	ANDI R30,LOW(0x3)
	BRNE _0x29
;     434   {
;     435     DigitsActive = 0;
	CBI  0x14,0
;     436   }
;     437   #endif
;     438   PORTB = ~byCharacter[byDisplay[0]];
_0x29:
_0x28:
_0x27:
_0x26:
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x4
;     439 //   if (Minus)
;     440 //   {
;     441 //     PORTB = PINB & 0b11111110;
;     442 //   }
;     443   #ifdef heat
;     444   if (LoadOn)
	SBIS 0x13,2
	RJMP _0x2C
;     445   #endif
;     446 
;     447   #ifdef cold
;     448   if (!LoadOn)
;     449   #endif
;     450   {
;     451     PORTB = PINB & 0b11111011;
	IN   R30,0x16
	ANDI R30,0xFB
	OUT  0x18,R30
;     452   }
;     453   if (View == 1)
_0x2C:
	LDI  R30,LOW(1)
	CP   R30,R2
	BRNE _0x2D
;     454   {
;     455     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     456   }
;     457   PORTD.5 = DigitsActive;
_0x2D:
	SBIC 0x14,0
	RJMP _0x2E
	CBI  0x12,5
	RJMP _0x2F
_0x2E:
	SBI  0x12,5
_0x2F:
;     458   delay_us(LED_delay);
	RCALL SUBOPT_0x5
;     459   PORTD.5 = 0;
	CBI  0x12,5
;     460 
;     461   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x4
;     462   PORTD.1 = DigitsActive;
	SBIC 0x14,0
	RJMP _0x32
	CBI  0x12,1
	RJMP _0x33
_0x32:
	SBI  0x12,1
_0x33:
;     463   delay_us(LED_delay);
	RCALL SUBOPT_0x5
;     464   PORTD.1 = 0;
	CBI  0x12,1
;     465 
;     466   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     467   PORTD.0 = DigitsActive;
	SBIC 0x14,0
	RJMP _0x36
	CBI  0x12,0
	RJMP _0x37
_0x36:
	SBI  0x12,0
_0x37:
;     468   delay_us(LED_delay);
	RCALL SUBOPT_0x5
;     469   PORTD.0 = 0;
	CBI  0x12,0
;     470 
;     471   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x4
;     472   PORTD.4 = DigitsActive;
	SBIC 0x14,0
	RJMP _0x3A
	CBI  0x12,4
	RJMP _0x3B
_0x3A:
	SBI  0x12,4
_0x3B:
;     473   delay_us(LED_delay);
	RCALL SUBOPT_0x5
;     474   PORTD.4 = 0;
	CBI  0x12,4
;     475 #endif
;     476 
;     477   }
	SUBI R17,-1
	RJMP _0x22
_0x23:
;     478 }
	LD   R17,Y+
	RET
;     479 
;     480 // Timer 1 overflow interrupt service routine
;     481 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     482 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x2
;     483   //BYTE t1;
;     484   //BYTE t2;
;     485   BYTE i;
;     486   int Temp;
;     487   //WORD T;
;     488 //   BYTE Ff;
;     489 //   BYTE NonZero;
;     490   int *val;
;     491 // Reinitialize Timer 1 value
;     492 TCNT1=0x85EE;
	RCALL __SAVELOCR4
;	i -> R17
;	Temp -> R18,R19
;	*val -> R16
	LDI  R30,LOW(34286)
	LDI  R31,HIGH(34286)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     493 //TCNT1L=0xD1;
;     494 
;     495 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     496 
;     497 //for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
;     498 //  {
;     499     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     500 //  }
;     501 
;     502 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     503 
;     504 //for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
;     505 //  {
;     506     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     507 //  }
;     508 
;     509 Updating = !Updating;   //это шоб читать температуру через раз
	SBIS 0x13,1
	RJMP _0x3E
	CBI  0x13,1
	RJMP _0x3F
_0x3E:
	SBI  0x13,1
_0x3F:
;     510 
;     511 if (Updating)           //если в этот раз читаем температуру, то
	SBIS 0x13,1
	RJMP _0x40
;     512 {
;     513   w1_write(0xBE);       //выдаём в шину 1-wire код 0xCC, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
;     514 
;     515 //  for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
;     516 //  {
;     517     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     518 //  }
;     519 
;     520   AllDataFF = 1;
	SBI  0x13,4
;     521   NonZero = 0;
	CBI  0x13,5
;     522   for (i=0; i<9; i++)
	LDI  R17,LOW(0)
_0x46:
	CPI  R17,9
	BRSH _0x47
;     523   {
;     524     w1buffer[i]=w1_read();
	MOV  R30,R17
	SUBI R30,-LOW(_w1buffer)
	PUSH R30
	RCALL _w1_read
	POP  R26
	ST   X,R30
;     525     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     526     if (w1buffer[i] != 0xFF)
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BREQ _0x48
;     527     {
;     528       AllDataFF = 0;
	CBI  0x13,4
;     529     }
;     530     if (w1buffer[i] != 0x00)
_0x48:
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x4B
;     531     {
;     532       NonZero = 1;
	SBI  0x13,5
;     533     }
;     534   }
_0x4B:
	SUBI R17,-1
	RJMP _0x46
_0x47:
;     535   Initialising = 0;//хватит показывать заставку
	CBI  0x13,3
;     536   i=w1_dow_crc8(w1buffer,8);
	LDI  R30,LOW(_w1buffer)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	MOV  R17,R30
;     537   if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	TST  R10
	BRNE _0x50
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x51
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x52
;     538   {
;     539     //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
;     540     //то это просто некорректно закончилось измерение температуры
;     541     i--;
	SUBI R17,1
;     542   }
;     543   if (NonZero == 0)
_0x52:
_0x51:
_0x50:
	SBIS 0x13,5
;     544   {
;     545     //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
;     546     i--;
	SUBI R17,1
;     547   }
;     548   if (i != w1buffer[8])
	__GETB1MN _w1buffer,8
	CP   R30,R17
	BREQ _0x54
;     549   {
;     550       //ошибка при передаче
;     551       ErrorLevel = 1;//это просто сбой
	LDI  R30,LOW(1)
	MOV  R11,R30
;     552       if (AllDataFF)
	SBIS 0x13,4
	RJMP _0x55
;     553       {
;     554       //это обрыв
;     555         ErrorLevel = 2;
	LDI  R30,LOW(2)
	RJMP _0xC6
;     556       }
;     557       else
_0x55:
;     558       {
;     559         if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x57
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x58
;     560         {
;     561           ErrorLevel = 3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;     562         }
;     563         if (NonZero == 0)
_0x58:
_0x57:
	SBIC 0x13,5
	RJMP _0x59
;     564         {
;     565           ErrorLevel = 4;
	LDI  R30,LOW(4)
_0xC6:
	MOV  R11,R30
;     566         }
;     567       }
_0x59:
;     568       if (ErrorCounter > 0)
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x5A
;     569       {
;     570         ErrorCounter--;
	DEC  R10
;     571       }
;     572       if (ErrorCounter == 0)
_0x5A:
	TST  R10
	BRNE _0x5B
;     573       {
;     574         ErrorDetected = 1;
	SBI  0x13,7
;     575       }
;     576   }
_0x5B:
;     577   else
	RJMP _0x5E
_0x54:
;     578   {
;     579     //ErrorLevel = 0;
;     580   //t1=w1buffer[0];   //LSB //читаем младший байт данных
;     581   //t2=w1buffer[1];   //MSB //читаем старший байт данных
;     582   val = (int*)&w1buffer[0];
	__POINTBRM 16,_w1buffer
;     583   //*val = *val;
;     584   Tnew = //1000 +
;     585   (*val) * 10 / 16;
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
;     586   RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     587   ErrorCounter = MaxDataErrors + 1;
	LDI  R30,LOW(2)
	MOV  R10,R30
;     588   // значения из даташита (для проверки раскоментировать нужное значение)
;     589 
;     590   //+125°C
;     591   //t2 = 0b00000111; //MSB
;     592   //t1 = 0b11010000; //LSB
;     593 
;     594   //+85°C
;     595   //t2 = 0b00000101; //MSB
;     596   //t1 = 0b01010000; //LSB
;     597 
;     598   //+25.0625°C
;     599   //t2 = 0b00000001; //MSB
;     600   //t1 = 0b10010001; //LSB
;     601 
;     602   //+10.125°C
;     603   //t2 = 0b00000000; //MSB
;     604   //t1 = 0b10100010; //LSB
;     605 
;     606   //+0.5°C
;     607   //t2 = 0b00000000; //MSB
;     608   //t1 = 0b00001000; //LSB
;     609 
;     610   //0°C
;     611   //t2 = 0b00000000; //MSB
;     612   //t1 = 0b00000000; //LSB
;     613 
;     614   //-0.5°C
;     615   //t2 = 0b11111111; //MSB
;     616   //t1 = 0b11111000; //LSB
;     617 
;     618   //-10.125°C
;     619   //t2 = 0b11111111; //MSB
;     620   //t1 = 0b01011110; //LSB
;     621 
;     622   //-25.0625°C
;     623   //t2 = 0b11111110; //MSB
;     624   //t1 = 0b01101111; //LSB
;     625 
;     626   //-55°C
;     627   //t2 = 0b11111100; //MSB
;     628   //t1 = 0b10010000; //LSB
;     629 
;     630 
;     631 
;     632 
;     633 //   Ff = (t1 & 0x0F);           //из LSB выделяем дробную часть значения температуры
;     634 //   t2 = t2 << 4;
;     635 //   t1 = t1 >> 4;
;     636 //   T = (t2 & 0xF0) | (t1 & 0x0F);    //после объедининия смещённых частей LSB и MSB объединяем
;     637 //                                     //их и получаем целую часть значения температуры.
;     638 //                                     //подробней - смотри даташит.
;     639 //
;     640 //   if (T & 0b10000000) //если отрицательная температура
;     641 //   {
;     642 //     Ff = ~Ff + 1;         //инвертируем значение дробной части и добавляем адын.
;     643 //     Ff = Ff & 0b00001111; //убираем лишние биты
;     644 //
;     645 //     if (!Ff)              //если дробная часть равна "0"
;     646 //     {
;     647 //       T--;                //значение температуры уменьшаем на адын
;     648 //     }
;     649 //
;     650 //     Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //вычисляем значение температуры если T < 0.
;     651 //                                                           //Формат хранения - смотри строку 58 этого файла.
;     652 //   }
;     653 //   else
;     654 //   {
;     655 //     Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0.
;     656 //                                                           //Формат хранения - смотри строку 58 этого файла.
;     657 //   }
;     658   //Tnew = Tnew + 0;
;     659   }
_0x5E:
;     660 }
;     661 else
	RJMP _0x5F
_0x40:
;     662 {
;     663   w1_write(0x44);          //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
;     664 }
_0x5F:
;     665 
;     666 if (ErrorCounter == 0)
	TST  R10
	BRNE _0x60
;     667 {
;     668   PORTD.3 = 0;
	CBI  0x12,3
;     669   PORTD.2 = 0;
	CBI  0x12,2
;     670   NeedResetLoad = 1;
	SBI  0x13,6
;     671   LoadOn = ShowDotWhenError;
	CBI  0x13,2
;     672 }
;     673 else if (!Initialising)
	RJMP _0x69
_0x60:
	SBIC 0x13,3
	RJMP _0x6A
;     674 {
;     675 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R8
	ADD  R30,R6
	ADC  R31,R7
	MOVW R18,R30
;     676 
;     677 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 4,5,18,19
	BRLT _0x6B
	SBIC 0x13,2
	RJMP _0x6D
	SBIS 0x13,6
	RJMP _0x6C
_0x6D:
;     678 {                              //то выключаем нагрузку
;     679   PORTD.2 = 0;
	CBI  0x12,2
;     680   PORTD.3 = 1;
	SBI  0x12,3
;     681   LoadOn = 0;
	CBI  0x13,2
;     682   NeedResetLoad = 0;
	CBI  0x13,6
;     683 }
;     684 
;     685 Temp = T_LoadOn;                //Temp - временная переменная.
_0x6C:
_0x6B:
	MOVW R18,R6
;     686 
;     687 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 18,19,4,5
	BRLT _0x77
	SBIS 0x13,2
	RJMP _0x79
	SBIS 0x13,6
	RJMP _0x78
_0x79:
;     688 {                               //то включаем нагрузку
;     689   PORTD.3 = 0;
	CBI  0x12,3
;     690   PORTD.2 = 1;
	SBI  0x12,2
;     691   LoadOn = 1;
	SBI  0x13,2
;     692   NeedResetLoad = 0;
	CBI  0x13,6
;     693 }
;     694 }//if errorCounter
_0x78:
_0x77:
;     695 
;     696 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x6A:
_0x69:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x83
;     697 {
;     698   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R3
;     699 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     700 else                            //пока не станет равной "0".
	RJMP _0x84
_0x83:
;     701 {
;     702   View = 0;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R2
;     703 }
_0x84:
;     704 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     705 
;     706 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RCALL SUBOPT_0x3
	RETI
;     707 
;     708 // Declare your global variables here
;     709 
;     710 void main(void)
;     711 {
_main:
;     712 // Declare your local variables here
;     713 
;     714 // Crystal Oscillator division factor: 1
;     715 #pragma optsize-
;     716 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     717 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     718 #ifdef _OPTIMIZE_SIZE_
;     719 #pragma optsize+
;     720 #endif
;     721 
;     722         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
;     723         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
;     724         //         если установлена 1 - то на выводе устанавливается лог. 1
;     725         //         если установлена 0 - то на выводе устанавливается лог. 0
;     726         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
;     727         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
;     728 
;     729         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     730         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     731 
;     732         PORTB=0b00000000;
	OUT  0x18,R30
;     733         DDRB= 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     734 
;     735 
;     736         #ifdef Cathode
;     737           PORTD=0b01110011;
;     738           DDRD= 0b00111111;
;     739         #endif
;     740 
;     741         #ifdef Anode
;     742           PORTD=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
;     743           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     744         #endif
;     745 
;     746 //выше уже проинициализировали
;     747 //PORTD.3 = 0;
;     748 //PORTD.2 = 0;
;     749 
;     750 // Timer/Counter 0 initialization
;     751 // Clock source: System Clock
;     752 // Clock value: 8000,000 kHz
;     753 // Mode: Normal top=FFh
;     754 // OC0A output: Disconnected
;     755 // OC0B output: Disconnected
;     756 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     757 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     758 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     759 // OCR0A=0x00;
;     760 // OCR0B=0x00;
;     761 
;     762 // Timer/Counter 1 initialization
;     763 // Clock source: System Clock
;     764 // Clock value: 7,813 kHz
;     765 // Mode: Normal top=FFFFh
;     766 // OC1A output: Discon.
;     767 // OC1B output: Discon.
;     768 // Noise Canceler: Off
;     769 // Input Capture on Falling Edge
;     770 // Timer 1 Overflow Interrupt: On
;     771 // Input Capture Interrupt: Off
;     772 // Compare A Match Interrupt: Off
;     773 // Compare B Match Interrupt: Off
;     774 TCCR1A=0x00;
	OUT  0x2F,R30
;     775 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     776 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
;     777 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
;     778 // ICR1H=0x00;
;     779 // ICR1L=0x00;
;     780 // OCR1AH=0x00;
;     781 // OCR1AL=0x00;
;     782 // OCR1BH=0x00;
;     783 // OCR1BL=0x00;
;     784 
;     785 // External Interrupt(s) initialization
;     786 // INT0: Off
;     787 // INT1: Off
;     788 // Interrupt on any change on pins PCINT0-7: Off
;     789 GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;     790 MCUCR=0x00;
	OUT  0x35,R30
;     791 
;     792 // Timer(s)/Counter(s) Interrupt(s) initialization
;     793 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
;     794 
;     795 // Universal Serial Interface initialization
;     796 // Mode: Disabled
;     797 // Clock source: Register & Counter=no clk.
;     798 // USI Counter Overflow Interrupt: Off
;     799 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     800 
;     801 // Analog Comparator initialization
;     802 // Analog Comparator: Off
;     803 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     804 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     805 
;     806 #ifdef Blinking
;     807 DimmerCounter = 0;
	CLR  R12
;     808 #endif
;     809 //Tnew = 0;                //Просто обнуляем, тыща больше не нужна
;     810 
;     811 if ((eeT_LoadOn > 1250) || (eeT_LoadOn < -550))    //если в EEPROM значение > 2250 или < 450 значит он не прошился, или
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x4E3)
	LDI  R26,HIGH(0x4E3)
	CPC  R31,R26
	BRGE _0x86
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0xFDDA)
	LDI  R26,HIGH(0xFDDA)
	CPC  R31,R26
	BRGE _0x85
_0x86:
;     812   eeT_LoadOn = 280;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     813 if (eeDeltaT > 900)
_0x85:
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLT _0x88
;     814   eeDeltaT = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     815 
;     816 
;     817 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x88:
	RCALL SUBOPT_0x0
	MOVW R6,R30
;     818 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x1
	MOVW R8,R30
;     819 
;     820 ErrorLevel = 0;
	CLR  R11
;     821 ErrorCounter = 1;//0;//MaxDataErrors;
	LDI  R30,LOW(1)
	MOV  R10,R30
;     822 Initialising = 1;
	SBI  0x13,3
;     823 LoadOn = ShowDotAtStartup;
	CBI  0x13,2
;     824 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     825 
;     826 // w1_init();              //инициализация шины 1-wire
;     827 // w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
;     828 // w1_write(0x44);         //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
;     829 Updating = 1;
	SBI  0x13,1
;     830 
;     831 KbdInit();              //инициализация клавиатуры :)
	RCALL _KbdInit
;     832 
;     833 // Global enable interrupts
;     834 #asm("sei")
	sei
;     835 
;     836 while (1)
_0x8F:
;     837       {
;     838       // Place your code here
;     839       #asm("cli");               //запрещаем прерывания
	cli
;     840       ShowDisplayData11Times();         //обновляем экран
	RCALL _ShowDisplayData11Times
;     841       #asm("sei");               //разрешаем прерывания
	sei
;     842       };
	RJMP _0x8F
;     843 
;     844 }
_0x92:
	RJMP _0x92
;     845 /**************************************************************************\
;     846  FILE ..........: KBD.C
;     847  AUTHOR ........: Vitaly Puzrin
;     848  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     849  NOTES .........:
;     850  COPYRIGHT .....: Vitaly Puzrin, 1999
;     851  HISTORY .......: DATE        COMMENT
;     852                   ---------------------------------------------------
;     853                   25.06.1999  Первая версия
;     854 \**************************************************************************/
;     855 
;     856 #include    "kbd.h"
;     857 #include <tiny2313.h>
;     858 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     859 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     860 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     861 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     862 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     863 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     864 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     865 	#endif
	#endif
;     866 
;     867 #define     ST_WAIT_KEY     0
;     868 #define     ST_CHECK_KEY    1
;     869 #define     ST_RELEASE_WAIT 2
;     870 
;     871 #define     KEY_1      0x01    // Код клавиши 1
;     872 #define     KEY_2      0x02    // Код клавиши 2
;     873 #define     KEY_3      0x03    // Код клавиши 3
;     874 
;     875 bit btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
;     876 BYTE    byKeyCode;      // Код нажатой клавиши

	.DSEG
_byKeyCode:
	.BYTE 0x1
;     877 
;     878 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
_byScanState:
	.BYTE 0x1
;     879 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
_byCheckedKey:
	.BYTE 0x1
;     880 BYTE    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
_byCheckKeyCnt:
	.BYTE 0x1
;     881 BYTE    byIterationCounter =  40;//Счётчик до повторения
_byIterationCounter:
	.BYTE 0x1
;     882 
;     883 
;     884 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     885 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     886 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     887 
;     888 /**************************************************************************\
;     889     Инициализация модуля (переменных и железа)
;     890       Вход:  -
;     891       Выход: -
;     892 \**************************************************************************/
;     893 void KbdInit(void)
;     894 {

	.CSEG
_KbdInit:
;     895     btKeyUpdate = FALSE;
	CBI  0x13,0
;     896     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x6
;     897 }
	RET
;     898 
;     899 /**************************************************************************\
;     900     Сканирование клавиатуры
;     901       Вход:  -
;     902       Выход: -
;     903 \**************************************************************************/
;     904 void ScanKbd(void)
;     905 {
_ScanKbd:
;     906     switch (byScanState)
	LDS  R30,_byScanState
;     907     {
;     908         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x99
;     909             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     910             if (KeyCode != 0)
	RCALL SUBOPT_0x7
	BREQ _0x9A
;     911             {
;     912                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0x7
	STS  _byCheckedKey,R30
;     913 
;     914                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0x8
;     915 
;     916                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
;     917             }
;     918             break;
_0x9A:
	RJMP _0x98
;     919 
;     920         case ST_CHECK_KEY:
_0x99:
	CPI  R30,LOW(0x1)
	BRNE _0x9B
;     921             // Если клавиша удердивалась достаточно долго, то
;     922             // генерируем событие с кодом клавиши, и переходим к
;     923             // ожиданию отпускания клавиши
;     924             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0x7
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0x9C
;     925             {
;     926                 byCheckKeyCnt--;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
;     927                 if (!byCheckKeyCnt)
	BRNE _0x9D
;     928                 {
;     929                     btKeyUpdate = TRUE;
	SBI  0x13,0
;     930                     byKeyCode = byCheckedKey;
	LDS  R30,_byCheckedKey
	STS  _byKeyCode,R30
;     931                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
;     932                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0x8
;     933                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	STS  _byIterationCounter,R30
;     934                 }
;     935             }
_0x9D:
;     936             // Если данные неустойчитывы, то возвращается назад,
;     937             // к ожиданию нажатия клавиши
;     938             else
	RJMP _0xA0
_0x9C:
;     939                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x6
;     940             break;
_0xA0:
	RJMP _0x98
;     941 
;     942         case ST_RELEASE_WAIT:
_0x9B:
	CPI  R30,LOW(0x2)
	BRNE _0x98
;     943             // Пока клавиша не будет отпущена на достаточный интервал
;     944             // времени, будем оставаться в этом состоянии
;     945             if (KeyCode != 0)
	RCALL SUBOPT_0x7
	BREQ _0xA2
;     946             {
;     947                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0x8
;     948                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0xA3
;     949                 {
;     950                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	STS  _byIterationCounter,R30
;     951                   btKeyUpdate = TRUE;
	SBI  0x13,0
;     952                 }
;     953                 byIterationCounter--;
_0xA3:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RJMP _0xC7
;     954             }
;     955             else
_0xA2:
;     956             {
;     957                 byCheckKeyCnt--;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
;     958                 if (!byCheckKeyCnt)
	BRNE _0xA7
;     959                 {
;     960                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x6
;     961                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
_0xC7:
	STS  _byIterationCounter,R30
;     962                 }
;     963             }
_0xA7:
;     964             break;
;     965     }
_0x98:
;     966     if( btKeyUpdate )
	SBIS 0x13,0
	RJMP _0xA8
;     967     {
;     968       btKeyUpdate = FALSE;
	CBI  0x13,0
;     969       ProcessKey();
	RCALL _ProcessKey
;     970     }
;     971 }
_0xA8:
	RET
;     972 
;     973 /**************************************************************************\
;     974     Обработка нажатой клавиши.
;     975       Вход:  -
;     976       Выход: -
;     977 \**************************************************************************/
;     978 void ProcessKey(void)
;     979 {
_ProcessKey:
;     980     switch (byKeyCode)
	LDS  R30,_byKeyCode
;     981     {
;     982         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0xAE
;     983             switch (View)
	MOV  R30,R2
;     984             {
;     985 //               case 0:               //если был режим "Текущая температура", то
;     986 //                 View = 1;           //переходим в режим "Установленная температура"
;     987 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;     988 //               break;
;     989               case 1:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xB2
;     990                 if (T_LoadOn > -550) //если "Установленная температура" > -55°C, то
	LDI  R30,LOW(64986)
	LDI  R31,HIGH(64986)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xB3
;     991                 {
;     992                   T_LoadOn --;      //уменьшаем значение на 0,1°
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
;     993                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     994                 }
;     995                 View = 1;           //удерживаем в режиме "Установленная температура"
_0xB3:
	LDI  R30,LOW(1)
	MOV  R2,R30
;     996                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0xC8
;     997               break;
;     998               case 2:               //если мы в режиме "Дэльта", то
_0xB2:
	CPI  R30,LOW(0x2)
	BRNE _0xB1
;     999                 if (DeltaT > 1)     //если "Дэльта" больше 0,1°, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0xB5
;    1000                 {
;    1001                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
;    1002                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;    1003                 }
;    1004                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0xB5:
_0xC8:
	LDI  R30,LOW(5)
	MOV  R3,R30
;    1005               break;
;    1006             }
_0xB1:
;    1007         break;
	RJMP _0xAD
;    1008 
;    1009         case KEY_2:                 // Была нажата клавиша Плюс
_0xAE:
	CPI  R30,LOW(0x2)
	BRNE _0xB6
;    1010             switch (View)
	MOV  R30,R2
;    1011             {
;    1012 //               case 0:               //если был режим "Текущая температура", то
;    1013 //                 View = 1;           //переходим в режим "Установленная температура"
;    1014 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;    1015 //               break;
;    1016               case 1:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xBA
;    1017                 if (T_LoadOn < (1250 - DeltaT))    //если температура ниже 125,0° - Дэельта
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	SUB  R30,R8
	SBC  R31,R9
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xBB
;    1018                 {
;    1019                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
;    1020                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;    1021                 }
;    1022                 View = 1;           //удерживаем в режиме "Установленная температура"
_0xBB:
	LDI  R30,LOW(1)
	MOV  R2,R30
;    1023                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	RJMP _0xC9
;    1024               break;
;    1025               case 2:
_0xBA:
	CPI  R30,LOW(0x2)
	BRNE _0xB9
;    1026                 if (DeltaT < 900)   //если Дельта меньше 90,0°, то
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0xBD
;    1027                 {
;    1028                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;    1029                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;    1030                 }
;    1031                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0xBD:
_0xC9:
	LDI  R30,LOW(5)
	MOV  R3,R30
;    1032               break;
;    1033             }
_0xB9:
;    1034         break;
	RJMP _0xAD
;    1035 
;    1036         case KEY_3:               // Была нажаты обе кноки вместе.
_0xB6:
	CPI  R30,LOW(0x3)
	BRNE _0xC0
;    1037           View++;
	INC  R2
;    1038           //View &= 0b00000011;    // Если максимальное значение кратно 2, то это экономит 2 слова
;    1039           if (View > 3)
	LDI  R30,LOW(3)
	CP   R30,R2
	BRSH _0xBF
;    1040           {
;    1041             View = 1;
	LDI  R30,LOW(1)
	MOV  R2,R30
;    1042           }
;    1043 //             switch (View)
;    1044 //             {
;    1045 //               case 0:               //если был режим "Текущая температура", то
;    1046 //                 View = 1;           //переходим в режим "Установленная температура"
;    1047 //               break;
;    1048 //               case 1:               //если мы в режиме "Установленная температура", то
;    1049 //                 View = 2;           //удерживаем в режиме "Дэльта"
;    1050 //               break;
;    1051 //               case 2:
;    1052 //                 View = 3;           //переходим в режим "Последняя обнаруженная ошибка"
;    1053 //               break;
;    1054 //               case 3:
;    1055 //                 View = 1;           //переходим в режим "Установленная температура"
;    1056 //               break;
;    1057 //             }
;    1058 //             Counter = 5;        //и взводим счётчик на 5 секунд.
;    1059 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;    1060 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;    1061             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0xBF:
	LDI  R30,LOW(5)
	MOV  R3,R30
;    1062         break;
;    1063 
;    1064         default:
_0xC0:
;    1065         break;
;    1066 
;    1067     }
_0xAD:
;    1068     ErrorDetected = 0;
	CBI  0x13,7
;    1069 
;    1070 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
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
SUBOPT_0x3:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	__DELAY_USW 300
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _byScanState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(4)
	STS  _byCheckKeyCnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R30,_byCheckKeyCnt
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	SUBI R30,LOW(1)
	STS  _byCheckKeyCnt,R30
	RCALL SUBOPT_0x9
	CPI  R30,0
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

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
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
	adiw r28,2
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
