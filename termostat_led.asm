
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
;      50 BYTE byDisplay[4];        // буфер данных, для вывода на экран
_byDisplay:
	.BYTE 0x4
;      51 
;      52 BOOLEAN Updating;         //служебная переменная
;      53 BOOLEAN Minus;            //равна "1" если температура отрицательная
;      54 BOOLEAN LoadOn;           //равна "1" если включена нагрузка
;      55 bit Initiaslizing;        //равна "1" до получения первого значения температуры с датчика
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
;      67 eeprom WORD eeT_LoadOn = 1280;   //1280 = +28°C 1140 = +14°C

	.ESEG
_eeT_LoadOn:
	.DW  0x500
;      68 eeprom WORD eeDeltaT = 10;       //1°C
_eeDeltaT:
	.DW  0xA
;      69 
;      70 //температура для удобства представлена так:
;      71 // - до 1000 = отрицательная
;      72 // - 1000 = 0
;      73 // - больше 1000 = положительная
;      74 // - 0,1°С = 1
;      75 //---------------------------------
;      76 //-55°C = 450
;      77 //-25°C = 750
;      78 //-10.1°C = 899
;      79 //0°C = 1000
;      80 //10.1°C = 1101
;      81 //25°C = 1250
;      82 //85°C = 1850
;      83 //125°C = 2250
;      84 
;      85 
;      86 BYTE byCharacter[15] = {0xFA,     //0

	.DSEG
_byCharacter:
;      87                 0x82,   //1
;      88  	        0xB9,   //2
;      89 	        0xAB,	//3
;      90 	        0xC3,     //4
;      91 	        0x6B,     //5
;      92 	        0x7B,     //6
;      93                 0xA2,    //7
;      94                 0xFB,      //8
;      95                 0xEB,      //9
;      96                 0x00,      //blank
;      97                 0x01,     //-
;      98                 0x70,     //t
;      99                 0x9B,     //d
;     100                 0x58      //L
;     101                 };
	.BYTE 0xF
;     102 
;     103 
;     104 
;     105 /************************************************************************\
;     106 \************************************************************************/
;     107 void PrepareData(unsigned int Data)
;     108 {

	.CSEG
_PrepareData:
;     109     BYTE i;
;     110     unsigned int D, D1;
;     111     D = Data;
	RCALL __SAVELOCR6
;	Data -> Y+6
;	i -> R17
;	D -> R18,R19
;	D1 -> R20,R21
	__GETWRS 18,19,6
;     112 
;     113     if (D >= 1000) //если Температура больше нуля
	__CPWRN 18,19,1000
	BRLO _0x4
;     114     {
;     115       D = D - 1000;
	__SUBWRN 18,19,1000
;     116       Minus = 0;
	CLR  R2
;     117     }
;     118     else
	RJMP _0x5
_0x4:
;     119     {
;     120       D = 1000 - D;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	SUB  R30,R18
	SBC  R31,R19
	MOVW R18,R30
;     121       Minus = 1;
	LDI  R30,LOW(1)
	MOV  R2,R30
;     122     }
_0x5:
;     123     D1 = D;
	MOVW R20,R18
;     124 
;     125     //Преобразуем в десятичное представление
;     126     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x7:
	CPI  R17,4
	BRSH _0x8
;     127     {
;     128        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21U
	MOV  R26,R16
	ST   X,R30
;     129        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21U
	MOVW R18,R30
;     130     }
	SUBI R17,-1
	RJMP _0x7
_0x8:
;     131 
;     132     if (D1 < 100)
	__CPWRN 20,21,100
	BRSH _0x9
;     133     {
;     134       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1
;     135       byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
;     136 
;     137       goto exit;
	RJMP _0xA
;     138     }
;     139     if ((D1 >= 100) & (D1 <1000))
_0x9:
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __GEW12U
	MOV  R0,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __LTW12U
	AND  R30,R0
	BREQ _0xB
;     140     {
;     141       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1
;     142       goto exit;
;     143     }
;     144 
;     145 exit:
_0xB:
_0xA:
;     146   if (Initiaslizing)
	SBIS 0x13,0
	RJMP _0xC
;     147   {
;     148     byDisplay[0] = 11;
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x1
;     149     byDisplay[1] = 11;
	LDI  R30,LOW(11)
	__PUTB1MN _byDisplay,1
;     150     byDisplay[2] = 11;
	__PUTB1MN _byDisplay,2
;     151     byDisplay[3] = 11;
	__PUTB1MN _byDisplay,3
;     152   }
;     153   else
	RJMP _0xD
_0xC:
;     154   {
;     155   if (View == 2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xE
;     156   {
;     157     byDisplay[0] = 13;
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
;     158   }
;     159   }
_0xE:
_0xD:
;     160 
;     161 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     162 
;     163 /************************************************************************\
;     164   Вывод экранного буфера на дисплей.
;     165       Вход:  -
;     166       Выход: -
;     167 \************************************************************************/
;     168 void ShowDisplayData(void)
;     169 {
_ShowDisplayData:
;     170  #ifdef Cathode
;     171 
;     172   PORTB = byCharacter[byDisplay[0]];
;     173   if (Minus)
;     174   {
;     175     PORTB = PINB | 0b00000001;
;     176   }
;     177   #ifdef heat
;     178   if (LoadOn)
;     179   #endif
;     180 
;     181   #ifdef cold
;     182   if (!LoadOn)
;     183   #endif
;     184   {
;     185     PORTB = PINB | 0b00000100;
;     186   }
;     187   if (View == 1)
;     188   {
;     189     PORTB = PINB | 0b00001000;
;     190   }
;     191   PORTD.5 = 0;
;     192   delay_us(LED_delay);
;     193   PORTD.5 = 1;
;     194 
;     195   PORTB = byCharacter[byDisplay[1]];
;     196   PORTD.1 = 0;
;     197   delay_us(LED_delay);
;     198   PORTD.1 = 1;
;     199 
;     200   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     201   PORTD.0 = 0;
;     202   delay_us(LED_delay);
;     203   PORTD.0 = 1;
;     204 
;     205   PORTB = byCharacter[byDisplay[3]];
;     206   PORTD.4 = 0;
;     207   delay_us(LED_delay);
;     208   PORTD.4 = 1;
;     209 #endif
;     210 
;     211 #ifdef Anode
;     212   PORTB = ~byCharacter[byDisplay[0]];
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x2
;     213   if (Minus)
	TST  R2
	BREQ _0xF
;     214   {
;     215     PORTB = PINB & 0b11111110;
	IN   R30,0x16
	ANDI R30,0xFE
	OUT  0x18,R30
;     216   }
;     217   #ifdef heat
;     218   if (LoadOn)
_0xF:
	TST  R5
	BREQ _0x10
;     219   #endif
;     220 
;     221   #ifdef cold
;     222   if (!LoadOn)
;     223   #endif
;     224   {
;     225     PORTB = PINB & 0b11111011;
	IN   R30,0x16
	ANDI R30,0xFB
	OUT  0x18,R30
;     226   }
;     227   if (View == 1)
_0x10:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x11
;     228   {
;     229     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     230   }
;     231   PORTD.5 = 1;
_0x11:
	SBI  0x12,5
;     232   delay_us(LED_delay);
	RCALL SUBOPT_0x3
;     233   PORTD.5 = 0;
	CBI  0x12,5
;     234 
;     235   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x2
;     236   PORTD.1 = 1;
	SBI  0x12,1
;     237   delay_us(LED_delay);
	RCALL SUBOPT_0x3
;     238   PORTD.1 = 0;
	CBI  0x12,1
;     239 
;     240   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     241   PORTD.0 = 1;
	SBI  0x12,0
;     242   delay_us(LED_delay);
	RCALL SUBOPT_0x3
;     243   PORTD.0 = 0;
	CBI  0x12,0
;     244 
;     245   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x2
;     246   PORTD.4 = 1;
	SBI  0x12,4
;     247   delay_us(LED_delay);
	RCALL SUBOPT_0x3
;     248   PORTD.4 = 0;
	CBI  0x12,4
;     249 #endif
;     250 
;     251 
;     252   }
	RET
;     253 
;     254 
;     255 /************************************************************************\
;     256   Обновление дисплея.
;     257       Вход:  -
;     258       Выход: -
;     259 \************************************************************************/
;     260 void RefreshDisplay(void)
;     261 {
_RefreshDisplay:
;     262   WORD Data;
;     263   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R7
;     264   {
;     265     case 0:
	CPI  R30,0
	BRNE _0x25
;     266       Data = Tnew;
	MOVW R16,R8
;     267       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x4
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x26
;     268         eeT_LoadOn = T_LoadOn;
	MOVW R30,R10
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     269       if (DeltaT != eeDeltaT)
_0x26:
	RCALL SUBOPT_0x5
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x27
;     270         eeDeltaT = DeltaT;
	MOVW R30,R12
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     271     break;
_0x27:
	RJMP _0x24
;     272     case 1:
_0x25:
	CPI  R30,LOW(0x1)
	BRNE _0x28
;     273       Data = T_LoadOn;
	MOVW R16,R10
;     274     break;
	RJMP _0x24
;     275 
;     276     case 2:
_0x28:
	CPI  R30,LOW(0x2)
	BRNE _0x24
;     277       Data = DeltaT + 1000;
	MOVW R30,R12
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	MOVW R16,R30
;     278     break;
;     279   }
_0x24:
;     280 
;     281   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     282 }
	RCALL __LOADLOCR2P
	RET
;     283 
;     284 // Timer 0 overflow interrupt service routine
;     285 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     286 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x6
;     287 // Reinitialize Timer 0 value
;     288 TCNT0=0xBF;
	LDI  R30,LOW(191)
	OUT  0x32,R30
;     289 
;     290 ScanKbd();
	RCALL _ScanKbd
;     291 }
	RCALL SUBOPT_0x7
	RETI
;     292 
;     293 // Timer 1 overflow interrupt service routine
;     294 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     295 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x6
;     296   BYTE t1;
;     297   BYTE t2;
;     298   BYTE i;
;     299   WORD Temp;
;     300   WORD T;
;     301   BYTE Ff;
;     302 // Reinitialize Timer 1 value
;     303 TCNT1H=0x8F;
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
;     304 TCNT1L=0xD1;
	LDI  R30,LOW(209)
	OUT  0x2C,R30
;     305 
;     306 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     307 
;     308 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x2B:
	CPI  R19,11
	BRSH _0x2C
;     309   {
;     310     ShowDisplayData();
	RCALL _ShowDisplayData
;     311   }
	SUBI R19,-1
	RJMP _0x2B
_0x2C:
;     312 
;     313 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     314 
;     315 for (i=0; i<11; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x2E:
	CPI  R19,11
	BRSH _0x2F
;     316   {
;     317     ShowDisplayData();
	RCALL _ShowDisplayData
;     318   }
	SUBI R19,-1
	RJMP _0x2E
_0x2F:
;     319 
;     320 Updating = !Updating;   //это шоб читать температуру через раз
	MOV  R30,R3
	RCALL __LNEGB1
	MOV  R3,R30
;     321 
;     322 if (Updating)           //если в этот раз читаем температуру, то
	TST  R3
	BRNE PC+2
	RJMP _0x30
;     323 {
;     324   w1_write(0xBE);       //выдаём в шину 1-wire код 0xCC, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	RCALL SUBOPT_0x8
;     325 
;     326   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x32:
	CPI  R19,11
	BRSH _0x33
;     327   {
;     328     ShowDisplayData();
	RCALL _ShowDisplayData
;     329   }
	SUBI R19,-1
	RJMP _0x32
_0x33:
;     330 
;     331   t1=w1_read();   //LSB //читаем младший байт данных
	RCALL _w1_read
	MOV  R17,R30
;     332 
;     333   for (i=0; i<11; i++)  //шоб не моргало изображение делаем обновление эрана 10 раз
	LDI  R19,LOW(0)
_0x35:
	CPI  R19,11
	BRSH _0x36
;     334   {
;     335     ShowDisplayData();
	RCALL _ShowDisplayData
;     336   }
	SUBI R19,-1
	RJMP _0x35
_0x36:
;     337   t2=w1_read();   //MSB //читаем старший байт данных
	RCALL _w1_read
	MOV  R16,R30
;     338 
;     339   // значения из даташита (для проверки раскоментировать нужное значение)
;     340 
;     341   //+125°C
;     342   //t2 = 0b00000111; //MSB
;     343   //t1 = 0b11010000; //LSB
;     344 
;     345   //+85°C
;     346   //t2 = 0b00000101; //MSB
;     347   //t1 = 0b01010000; //LSB
;     348 
;     349   //+25.0625°C
;     350   //t2 = 0b00000001; //MSB
;     351   //t1 = 0b10010001; //LSB
;     352 
;     353   //+10.125°C
;     354   //t2 = 0b00000000; //MSB
;     355   //t1 = 0b10100010; //LSB
;     356 
;     357   //+0.5°C
;     358   //t2 = 0b00000000; //MSB
;     359   //t1 = 0b00001000; //LSB
;     360 
;     361   //0°C
;     362   //t2 = 0b00000000; //MSB
;     363   //t1 = 0b00000000; //LSB
;     364 
;     365   //-0.5°C
;     366   //t2 = 0b11111111; //MSB
;     367   //t1 = 0b11111000; //LSB
;     368 
;     369   //-10.125°C
;     370   //t2 = 0b11111111; //MSB
;     371   //t1 = 0b01011110; //LSB
;     372 
;     373   //-25.0625°C
;     374   //t2 = 0b11111110; //MSB
;     375   //t1 = 0b01101111; //LSB
;     376 
;     377   //-55°C
;     378   //t2 = 0b11111100; //MSB
;     379   //t1 = 0b10010000; //LSB
;     380 
;     381 
;     382 
;     383 
;     384   Ff = (t1 & 0x0F);           //из LSB выделяем дробную часть значения температуры
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R18,R30
;     385   t2 = t2 << 4;
	SWAP R16
	ANDI R16,0xF0
;     386   t1 = t1 >> 4;
	SWAP R17
	ANDI R17,0xF
;     387   T = (t2 & 0xF0) | (t1 & 0x0F);    //после объедининия смещённых частей LSB и MSB объединяем
	MOV  R30,R16
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	OR   R30,R26
	LDI  R31,0
	STD  Y+6,R30
	STD  Y+6+1,R31
;     388                                     //их и получаем целую часть значения температуры.
;     389                                     //подробней - смотри даташит.
;     390 
;     391   if (T & 0b10000000) //если отрицательная температура
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x37
;     392   {
;     393     Ff = ~Ff + 1;         //инвертируем значение дробной части и добавляем адын.
	MOV  R30,R18
	COM  R30
	SUBI R30,-LOW(1)
	MOV  R18,R30
;     394     Ff = Ff & 0b00001111; //убираем лишние биты
	ANDI R18,LOW(15)
;     395 
;     396     if (!Ff)              //если дробная часть равна "0"
	CPI  R18,0
	BRNE _0x38
;     397     {
;     398       T--;                //значение температуры уменьшаем на адын
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
;     399     }
;     400 
;     401     Tnew = 1000 - (((~T & 0xFF) * 10U) + (Ff * 10U / 16));  //вычисляем значение температуры если T < 0.
_0x38:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	COM  R30
	COM  R31
	ANDI R31,HIGH(0xFF)
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	RCALL SUBOPT_0x9
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R8,R26
;     402                                                           //Формат хранения - смотри строку 58 этого файла.
;     403   }
;     404   else
	RJMP _0x39
_0x37:
;     405   {
;     406     Tnew = 1000 + (T * 10U) + ((Ff * 10U) / 16);            //вычисляем значение температуры если Т > 0.
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x0
	RCALL __MULW12U
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	RCALL SUBOPT_0x9
	MOVW R8,R30
;     407                                                           //Формат хранения - смотри строку 58 этого файла.
;     408   }
_0x39:
;     409   Tnew = Tnew + 0;
	MOVW R30,R8
	ADIW R30,0
	MOVW R8,R30
;     410   Initiaslizing = 0;
	CBI  0x13,0
;     411 }
;     412 else
	RJMP _0x3C
_0x30:
;     413 {
;     414   w1_write(0x44);          //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
;     415 }
_0x3C:
;     416 
;     417 
;     418 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R12
	ADD  R30,R10
	ADC  R31,R11
	MOVW R20,R30
;     419 
;     420 if ((Tnew >= Temp) && (LoadOn)) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 8,9,20,21
	BRLO _0x3E
	TST  R5
	BRNE _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
;     421 {                              //то выключаем нагрузку
;     422   PORTD.3 = 1;
	SBI  0x12,3
;     423   PORTD.2 = 0;
	CBI  0x12,2
;     424   LoadOn = 0;
	CLR  R5
;     425 }
;     426 
;     427 Temp = T_LoadOn;                //Temp - временная переменная.
_0x3D:
	MOVW R20,R10
;     428 
;     429 if ((Tnew <= Temp) && (!LoadOn)) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 20,21,8,9
	BRLO _0x45
	TST  R5
	BREQ _0x46
_0x45:
	RJMP _0x44
_0x46:
;     430 {                               //то включаем нагрузку
;     431   PORTD.3 = 0;
	CBI  0x12,3
;     432   PORTD.2 = 1;
	SBI  0x12,2
;     433   LoadOn = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;     434 }
;     435 
;     436 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x44:
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x4B
;     437 {
;     438   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R4
;     439 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     440 else                            //пока не станет равной "0".
	RJMP _0x4C
_0x4B:
;     441 {
;     442   View = 0;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R7
;     443 }
_0x4C:
;     444 
;     445 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     446 
;     447 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RCALL SUBOPT_0x7
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
;     478           PORTD=0b01110111;
;     479           DDRD= 0b00111111;
;     480         #endif
;     481 
;     482         #ifdef Anode
;     483           PORTD=0b01000100;
	LDI  R30,LOW(68)
	OUT  0x12,R30
;     484           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     485         #endif
;     486 
;     487 
;     488 PORTD.3 = 1;
	SBI  0x12,3
;     489 PORTD.2 = 0;
	CBI  0x12,2
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
;     517 TCNT1H=0x03;
	LDI  R30,LOW(3)
	OUT  0x2D,R30
;     518 TCNT1L=0xD1;
	LDI  R30,LOW(209)
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
;     547 Tnew = 1000;                //Это чтобы на экране был "0.0" при включении питания
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	MOVW R8,R30
;     548 
;     549 if ((eeT_LoadOn > 2250) | (eeT_LoadOn < 450))    //если в EEPROM значение > 2250 или < 450 значит он не прошился, или
	RCALL SUBOPT_0x4
	MOVW R26,R30
	LDI  R30,LOW(2250)
	LDI  R31,HIGH(2250)
	RCALL __GTW12U
	MOV  R0,R30
	RCALL SUBOPT_0x4
	MOVW R26,R30
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	RCALL __LTW12U
	OR   R30,R0
	BREQ _0x51
;     550   eeT_LoadOn = 1280;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(1280)
	LDI  R31,HIGH(1280)
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
;     551 if (eeDeltaT > 900)
_0x51:
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x385)
	LDI  R26,HIGH(0x385)
	CPC  R31,R26
	BRLO _0x52
;     552   eeDeltaT = 10;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
;     553 
;     554 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x52:
	RCALL SUBOPT_0x4
	MOVW R10,R30
;     555 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x5
	MOVW R12,R30
;     556 Initiaslizing = 1;
	SBI  0x13,0
;     557 
;     558 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     559 
;     560 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     561 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	RCALL SUBOPT_0x8
;     562 w1_write(0x44);         //выдаём в шину 1-wire код 0xCC, что значит "Convert T"
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x8
;     563 
;     564 
;     565 KbdInit();              //инициализация клавиатуры :)
	RCALL _KbdInit
;     566 
;     567 // Global enable interrupts
;     568 #asm("sei")
	sei
;     569 
;     570 while (1)
_0x55:
;     571       {
;     572       // Place your code here
;     573       #asm("cli");               //запрещаем прерывания
	cli
;     574       ShowDisplayData();         //обновляем экран
	RCALL _ShowDisplayData
;     575       #asm("sei");               //разрешаем прерывания
	sei
;     576       };
	RJMP _0x55
;     577 
;     578 }
_0x58:
	RJMP _0x58
;     579 /**************************************************************************\
;     580  FILE ..........: KBD.C
;     581  AUTHOR ........: Vitaly Puzrin
;     582  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     583  NOTES .........:
;     584  COPYRIGHT .....: Vitaly Puzrin, 1999
;     585  HISTORY .......: DATE        COMMENT
;     586                   ---------------------------------------------------
;     587                   25.06.1999  Первая версия
;     588 \**************************************************************************/
;     589 
;     590 #include    "kbd.h"
;     591 #include <tiny2313.h>
;     592 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     593 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     594 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     595 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     596 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     597 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     598 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     599 	#endif
	#endif
;     600 
;     601 #define     ST_WAIT_KEY     0
;     602 #define     ST_CHECK_KEY    1
;     603 #define     ST_RELEASE_WAIT 2
;     604 
;     605 #define     KEY_1      0x01    // Код клавиши 1
;     606 #define     KEY_2      0x02    // Код клавиши 2
;     607 #define     KEY_3      0x03    // Код клавиши 3
;     608 
;     609 BOOLEAN btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу

	.DSEG
_btKeyUpdate:
	.BYTE 0x1
;     610 BYTE    byKeyCode;      // Код нажатой клавиши
;     611 
;     612 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
_byScanState:
	.BYTE 0x1
;     613 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
_byCheckedKey:
	.BYTE 0x1
;     614 WORD    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
_byCheckKeyCnt:
	.BYTE 0x2
;     615 BYTE    byIterationCounter =  40;//Счётчик до повторения
_byIterationCounter:
	.BYTE 0x1
;     616 
;     617 
;     618 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     619 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     620 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     621 
;     622 /**************************************************************************\
;     623     Инициализация модуля (переменных и железа)
;     624       Вход:  -
;     625       Выход: -
;     626 \**************************************************************************/
;     627 void KbdInit(void)
;     628 {

	.CSEG
_KbdInit:
;     629     btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xA
;     630     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0xB
;     631 }
	RET
;     632 
;     633 /**************************************************************************\
;     634     Сканирование клавиатуры
;     635       Вход:  -
;     636       Выход: -
;     637 \**************************************************************************/
;     638 void ScanKbd(void)
;     639 {
_ScanKbd:
;     640     switch (byScanState)
	LDS  R30,_byScanState
;     641     {
;     642         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x5D
;     643             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     644             if (KeyCode != 0)
	RCALL SUBOPT_0xC
	BREQ _0x5E
;     645             {
;     646                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0xC
	STS  _byCheckedKey,R30
;     647 
;     648                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xD
;     649 
;     650                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
;     651             }
;     652             break;
_0x5E:
	RJMP _0x5C
;     653 
;     654         case ST_CHECK_KEY:
_0x5D:
	CPI  R30,LOW(0x1)
	BRNE _0x5F
;     655             // Если клавиша удердивалась достаточно долго, то
;     656             // генерируем событие с кодом клавиши, и переходим к
;     657             // ожиданию отпускания клавиши
;     658             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0xC
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0x60
;     659             {
;     660                 byCheckKeyCnt--;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
;     661                 if (!byCheckKeyCnt)
	RCALL SUBOPT_0xE
	SBIW R30,0
	BRNE _0x61
;     662                 {
;     663                     btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
;     664                     byKeyCode = byCheckedKey;
	LDS  R6,_byCheckedKey
;     665                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
;     666                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xD
;     667                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	RCALL SUBOPT_0x10
;     668                 }
;     669             }
_0x61:
;     670             // Если данные неустойчитывы, то возвращается назад,
;     671             // к ожиданию нажатия клавиши
;     672             else
	RJMP _0x62
_0x60:
;     673                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0xB
;     674             break;
_0x62:
	RJMP _0x5C
;     675 
;     676         case ST_RELEASE_WAIT:
_0x5F:
	CPI  R30,LOW(0x2)
	BRNE _0x5C
;     677             // Пока клавиша не будет отпущена на достаточный интервал
;     678             // времени, будем оставаться в этом состоянии
;     679             if (KeyCode != 0)
	RCALL SUBOPT_0xC
	BREQ _0x64
;     680             {
;     681                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xD
;     682                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0x65
;     683                 {
;     684                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x10
;     685                   btKeyUpdate = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xA
;     686                 }
;     687                 byIterationCounter--;
_0x65:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x10
	SUBI R30,-LOW(1)
;     688             }
;     689             else
	RJMP _0x66
_0x64:
;     690             {
;     691                 byCheckKeyCnt--;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	ADIW R30,1
;     692                 if (!byCheckKeyCnt)
	RCALL SUBOPT_0xE
	SBIW R30,0
	BRNE _0x67
;     693                 {
;     694                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0xB
;     695                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	RCALL SUBOPT_0x10
;     696                 }
;     697             }
_0x67:
_0x66:
;     698             break;
;     699     }
_0x5C:
;     700     if( btKeyUpdate )
	LDS  R30,_btKeyUpdate
	CPI  R30,0
	BREQ _0x68
;     701     {
;     702       btKeyUpdate = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xA
;     703       ProcessKey();
	RCALL _ProcessKey
;     704     }
;     705 }
_0x68:
	RET
;     706 
;     707 /**************************************************************************\
;     708     Обработка нажатой клавиши.
;     709       Вход:  -
;     710       Выход: -
;     711 \**************************************************************************/
;     712 void ProcessKey(void)
;     713 {
_ProcessKey:
;     714     switch (byKeyCode)
	MOV  R30,R6
;     715     {
;     716         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0x6C
;     717             switch (View)
	MOV  R30,R7
;     718             {
;     719               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x70
;     720                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0x11
;     721                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x80
;     722               break;
;     723               case 1:               //если мы в режиме "Установленная температура", то
_0x70:
	CPI  R30,LOW(0x1)
	BRNE _0x71
;     724                 if (T_LoadOn > 450) //если "Установленная температура" > -55°C, то
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x72
;     725                 {
;     726                   T_LoadOn --;      //уменьшаем значение на 0,1°
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
;     727                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     728                 }
;     729                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x72:
	RCALL SUBOPT_0x11
;     730                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x80
;     731               break;
;     732               case 2:               //если мы в режиме "Дэльта", то
_0x71:
	CPI  R30,LOW(0x2)
	BRNE _0x6F
;     733                 if (DeltaT > 1)     //если "Дэльта" больше 0,1°, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x74
;     734                 {
;     735                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
;     736                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     737                 }
;     738                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0x74:
_0x80:
	LDI  R30,LOW(5)
	MOV  R4,R30
;     739               break;
;     740             }
_0x6F:
;     741 
;     742         break;
	RJMP _0x6B
;     743 
;     744         case KEY_2:                 // Была нажата клавиша Плюс
_0x6C:
	CPI  R30,LOW(0x2)
	BRNE _0x75
;     745             switch (View)
	MOV  R30,R7
;     746             {
;     747               case 0:               //если был режим "Текущая температура", то
	CPI  R30,0
	BRNE _0x79
;     748                 View = 1;           //переходим в режим "Установленная температура"
	RCALL SUBOPT_0x11
;     749                 Counter = 5;        //и взводим счётчик на 5 секунд.
	RJMP _0x81
;     750               break;
;     751               case 1:               //если мы в режиме "Установленная температура", то
_0x79:
	CPI  R30,LOW(0x1)
	BRNE _0x7A
;     752                 if (T_LoadOn < (2250 - DeltaT))    //если температура ниже 125,0° - Дэельта
	LDI  R30,LOW(2250)
	LDI  R31,HIGH(2250)
	SUB  R30,R12
	SBC  R31,R13
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x7B
;     753                 {
;     754                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
;     755                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     756                 }
;     757                 View = 1;           //удерживаем в режиме "Установленная температура"
_0x7B:
	RCALL SUBOPT_0x11
;     758                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	RJMP _0x81
;     759               break;
;     760               case 2:
_0x7A:
	CPI  R30,LOW(0x2)
	BRNE _0x78
;     761                 if (DeltaT < 900)   //если Дельта меньше 90,0°, то
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R12,R30
	CPC  R13,R31
	BRSH _0x7D
;     762                 {
;     763                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
;     764                   RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     765                 }
;     766                 Counter = 5;        //и взводим счётчик ещё на 5 секунд.
_0x7D:
_0x81:
	LDI  R30,LOW(5)
	MOV  R4,R30
;     767               break;
;     768             }
_0x78:
;     769         break;
	RJMP _0x6B
;     770 
;     771         case KEY_3:               // Была нажаты обе кноки вместе.
_0x75:
	CPI  R30,LOW(0x3)
	BRNE _0x7F
;     772             View = 2;              //переходим в режим "Дэльта"
	LDI  R30,LOW(2)
	MOV  R7,R30
;     773             Counter = 5;           //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R4,R30
;     774         break;
;     775 
;     776         default:
_0x7F:
;     777         break;
;     778 
;     779     }
_0x6B:
;     780 
;     781 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	STS  _byDisplay,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	__DELAY_USW 300
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
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
SUBOPT_0x7:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	RJMP _w1_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
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
SUBOPT_0xA:
	STS  _btKeyUpdate,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _byScanState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	IN   R30,0x19
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _byCheckKeyCnt,R30
	STS  _byCheckKeyCnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_byCheckKeyCnt
	LDS  R31,_byCheckKeyCnt+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	SBIW R30,1
	STS  _byCheckKeyCnt,R30
	STS  _byCheckKeyCnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	STS  _byIterationCounter,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
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
