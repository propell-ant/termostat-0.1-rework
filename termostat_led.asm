
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
;char is unsigned       : No
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
;      10 Date    : 22.12.2014
;      11 Author  : propellant
;      12 Company : Hardlock
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATtiny2313
;      17 Clock frequency     : 8,000000 MHz
;      18 Memory model        : Tiny
;      19 External SRAM size  : 0
;      20 Data Stack size     : 40
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
;      33 #include "termostat_led.h"
;      34 
;      35 // 1 Wire Bus functions
;      36 #asm
;      37    .equ __w1_port=0x12 ;PORTD
   .equ __w1_port=0x12 ;PORTD
;      38    .equ __w1_bit=6
   .equ __w1_bit=6
;      39 #endasm
;      40 #include <1wire.h>
;      41 #include <delay.h>
;      42 
;      43 #ifndef EliminateFlicker
;      44 #define LED_delay 150U
;      45 #else
;      46 #define LED_delay 600U
;      47 #define LED_delay_add 800U
;      48 bit skipDelay = 1;
;      49 #endif
;      50 
;      51 #ifdef heat
;      52 #define ShowDotAtStartup 0
;      53 #endif
;      54 #ifdef cold
;      55 #define ShowDotAtStartup 1
;      56 #endif
;      57 #ifndef ShowDotAtStartup
;      58 #define ShowDotAtStartup 0
;      59 #endif
;      60 
;      61 // буфер данных, для вывода на экран
;      62 BYTE byDisplay[4]
;      63 #ifdef ShowWelcomeScreen
;      64 ={11,11,11,11}
_byDisplay:
	.BYTE 0x4
;      65 #endif
;      66 ;
;      67 
;      68 bit Updating;         //служебная переменная
;      69 //bit Minus;            //равна "1" если температура отрицательная
;      70 bit LoadOn;           //равна "1" если включена нагрузка
;      71 bit Initializing;        //равна "1" до получения первого значения температуры с датчика
;      72 
;      73 #ifdef ShowDataErrors
;      74 bit AllDataFF;
;      75 bit NonZero;
;      76 #endif
;      77 
;      78 BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;      79 BYTE View = SHOW_Normal;  //определяет в каком режиме отображения находится устройство:
;      80                           //SHOW_Normal  - основной - Текущая температура
;      81                           //SHOW_TLoadOn - Установленная температура
;      82                           //SHOW_DeltaT  - Дэльта
;      83                           //SHOW_CorT    - Поправка к показаниям датчика (если включена опция CorCode)
;      84                           //SHOW_Error   - Код ошибки при наличии ошибки (если включена опция ShowDataErrors)
;      85 
;      86 int Tnew;                //для хранения нового значения измеренной температуры
;      87 int T_LoadOn;            //для хранения значения Установленной температуры
;      88 int DeltaT;              //для хранения значения Дэльты
;      89 #ifdef CorCode
;      90 INT8 CorT;
;      91 #endif
;      92 
;      93 #ifdef ShowDataErrors
;      94 #define W1_BUFFER_LEN 9
;      95 #else
;      96 #define W1_BUFFER_LEN 2
;      97 #endif
;      98 BYTE w1buffer[W1_BUFFER_LEN];//для хранения принятых с датчика данных
_w1buffer:
	.BYTE 0x9
;      99 
;     100 bit NeedResetLoad = 1;   //флаг для правильного возвращения состояния реле после исчезновения ошибки
;     101 #ifdef ShowDataErrors
;     102 BYTE ErrorLevel;         //для хранения номера последней обнаруженной ошибки передачи данных
;     103 BYTE ErrorCounter;       //для хранения количества обнаруженных ПОДРЯД ошибок, первая же удачная передача сбрасывает этот счетчик
;     104 #define MaxDataErrors 4  //количество игнорируемых ПОДРЯД-ошибок, по умолчанию 1, максимум 255
;     105 #endif
;     106 #ifdef Blinking
;     107 bit GoBlinking = 0;   //флаг для мигания (отображения информации об ошибке)
;     108 #endif
;     109 #ifdef heat
;     110 #define ShowDotWhenError 0
;     111 #endif
;     112 #ifdef cold
;     113 #define ShowDotWhenError 1
;     114 #endif
;     115 #ifndef ShowDotWhenError
;     116 #define ShowDotWhenError 0
;     117 #endif
;     118 
;     119 #ifdef Blinking
;     120 BYTE BlinkCounter;                      //Счетчик моргания
;     121 #define BlinkCounterMask 0b00111111     //примерно 2 моргания в секунду
;     122 #define BlinkCounterHalfMask 0b00100000 //примерно 2 моргания в секунду
;     123 BYTE DimmerCounter;                     //Счетчик яркости, моргание будет с неполным отключением индикатора
;     124 bit DigitsActive = 0;
;     125 #define DimmerDivider 1 //Это регулировка яркости: 4 соответствует 60%, 2 - примерно 35%, 1 - 0%
;     126 #else
;     127   #ifdef Cathode
;     128     #define DigitsActive 0
;     129   #endif
;     130   #ifdef Anode
;     131     #define DigitsActive 1
;     132   #endif
;     133 #endif
;     134 
;     135 //Это две переменные для "занимания места"
;     136 //чтобы данные, записанные предыдущей версией прошивки не влияли на новую версию
;     137 //(тип и формат хранения изменился)
;     138 eeprom WORD eeT_LoadOn0 = 1280;   //тут значение, которое не влияет ни на что

	.ESEG
_eeT_LoadOn0:
	.DW  0x500
;     139 eeprom WORD eeDeltaT0 = 10;       //тут значение, которое не влияет ни на что
_eeDeltaT0:
	.DW  0xA
;     140 
;     141 eeprom int eeT_LoadOn = TLoadOn_Default;
_eeT_LoadOn:
	.DW  0x118
;     142 eeprom int eeDeltaT = DeltaT_Default;
_eeDeltaT:
	.DW  0xA
;     143 #ifdef CorCode
;     144 eeprom INT8 eeCorT = CorT_Default;
;     145 #endif
;     146 BYTE byCharacter[SYMBOLS_LEN] = SymbolsArray;

	.DSEG
_byCharacter:
	.BYTE 0xF
;     147 
;     148 /************************************************************************\
;     149 \************************************************************************/
;     150 void PrepareData(int Data)
;     151 {

	.CSEG
_PrepareData:
;     152     BYTE i;
;     153     int D;
;     154     if (Initializing)
	RCALL __SAVELOCR4
;	Data -> Y+4
;	i -> R17
;	D -> R18,R19
	SBIC 0x13,4
;     155     {
;     156       return;
	RJMP _0xBD
;     157     }
;     158     if (Data < 0)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0x6
;     159     {
;     160       D = -Data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __ANEGW1
	MOVW R18,R30
;     161     }
;     162     else
	RJMP _0x7
_0x6:
;     163     {
;     164       D = Data;
	__GETWRS 18,19,4
;     165     }
_0x7:
;     166 
;     167     //Преобразуем в десятичное представление
;     168     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
;     169     {
;     170        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21
	MOV  R26,R16
	ST   X,R30
;     171        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21
	MOVW R18,R30
;     172     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
;     173 
;     174     if (byDisplay[0] == 0)
	LDS  R30,_byDisplay
	CPI  R30,0
	BRNE _0xB
;     175     {
;     176       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     177       if (byDisplay[1] == 0)
	__GETB1MN _byDisplay,1
	CPI  R30,0
	BRNE _0xC
;     178       {
;     179         byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
;     180       }
;     181     }
_0xC:
;     182     if (Data < 0)
_0xB:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0xD
;     183     {
;     184       byDisplay[0] = 11;
	LDI  R30,LOW(11)
	STS  _byDisplay,R30
;     185     }
;     186     switch (View)
_0xD:
	MOV  R30,R2
;     187     {
;     188         case SHOW_DeltaT:
	CPI  R30,LOW(0x2)
	BRNE _0x11
;     189           byDisplay[0] = 12;
	LDI  R30,LOW(12)
	RJMP _0xBE
;     190           break;
;     191         #ifdef CorCode
;     192         case SHOW_CorT:
;     193           byDisplay[0] = 13;
;     194           if (Data < 0)
;     195           {
;     196             byDisplay[1] = 11;
;     197           }
;     198           break;
;     199         #endif
;     200         #ifdef ShowDataErrors
;     201         case SHOW_Error:
_0x11:
	CPI  R30,LOW(0x3)
	BREQ _0xBF
;     202           byDisplay[0] = 14;
;     203           break;
;     204         case SHOW_Normal:
	CPI  R30,0
	BRNE _0x10
;     205           if (ErrorCounter == 0)
	TST  R10
	BRNE _0x14
;     206           {
;     207             byDisplay[0] = 14;
_0xBF:
	LDI  R30,LOW(14)
_0xBE:
	STS  _byDisplay,R30
;     208           }
;     209           break;
_0x14:
;     210         #endif
;     211     }
_0x10:
;     212 
;     213 }
_0xBD:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     214 
;     215 /************************************************************************\
;     216   Обновление дисплея.
;     217       Вход:  -
;     218       Выход: -
;     219 \************************************************************************/
;     220 void RefreshDisplay(void)
;     221 {
_RefreshDisplay:
;     222   int Data;
;     223   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R2
;     224   {
;     225     case SHOW_Normal:
	CPI  R30,0
	BRNE _0x18
;     226       #ifdef ShowDataErrors
;     227       if (ErrorCounter == 0)
	TST  R10
	BRNE _0x19
;     228       {
;     229         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
;     230       }
;     231       else
	RJMP _0x1A
_0x19:
;     232       #endif
;     233       {
;     234         Data = Tnew;
	MOVW R16,R4
;     235       }
_0x1A:
;     236       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x1
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x1B
;     237         eeT_LoadOn = T_LoadOn;
	MOVW R30,R6
	RCALL SUBOPT_0x2
;     238       if (DeltaT != eeDeltaT)
_0x1B:
	RCALL SUBOPT_0x3
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1C
;     239         eeDeltaT = DeltaT;
	MOVW R30,R8
	RCALL SUBOPT_0x4
;     240       #ifdef CorCode
;     241       if (CorT != eeCorT)
;     242         eeCorT = CorT;
;     243       #endif
;     244     break;
_0x1C:
	RJMP _0x17
;     245     case SHOW_TLoadOn:
_0x18:
	CPI  R30,LOW(0x1)
	BRNE _0x1D
;     246       Data = T_LoadOn;
	MOVW R16,R6
;     247     break;
	RJMP _0x17
;     248 
;     249     case SHOW_DeltaT:
_0x1D:
	CPI  R30,LOW(0x2)
	BRNE _0x1E
;     250       Data = DeltaT;
	MOVW R16,R8
;     251     break;
	RJMP _0x17
;     252 #ifdef CorCode
;     253     case SHOW_CorT:
;     254         Data = CorT;
;     255     break;
;     256 #endif
;     257 #ifdef ShowDataErrors
;     258     case SHOW_Error:
_0x1E:
	CPI  R30,LOW(0x3)
	BRNE _0x17
;     259         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
;     260     break;
;     261 #endif
;     262   }
_0x17:
;     263 
;     264   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     265 }
	RCALL __LOADLOCR2P
	RET
;     266 
;     267 // Timer 0 overflow interrupt service routine
;     268 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     269 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x5
;     270 // Reinitialize Timer 0 value
;     271 TCNT0=0xB5;
	LDI  R30,LOW(181)
	OUT  0x32,R30
;     272 // if (BlinkCounter < 2 * BlinkHalfPeriod)
;     273 // {
;     274 #ifdef Blinking
;     275   BlinkCounter++;
;     276   BlinkCounter &= BlinkCounterMask;
;     277 #endif
;     278 //}
;     279 // else
;     280 // {
;     281 //   BlinkCounter = 0;
;     282 // }
;     283 
;     284 ScanKbd();
	RCALL _ScanKbd
;     285 }
	RCALL SUBOPT_0x6
	RETI
;     286 
;     287 void ShowDisplayData11Times(void)
;     288 {
_ShowDisplayData11Times:
;     289   BYTE i;
;     290   #ifdef EliminateFlicker
;     291   if (!skipDelay)
	ST   -Y,R17
;	i -> R17
	SBIC 0x13,1
	RJMP _0x20
;     292   {
;     293     delay_us(LED_delay_add);
	__DELAY_USW 1600
;     294   }
;     295   #endif
;     296 
;     297   for (i=0; i<4; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
_0x20:
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRSH _0x23
;     298   {
;     299 //    ShowDisplayData();
;     300  #ifdef Cathode
;     301   #ifdef Blinking
;     302   //BYTE
;     303   DigitsActive = 0;
;     304   DimmerCounter++;
;     305 //  if (BlinkCounter > BlinkHalfPeriod)
;     306   if (BlinkCounter & BlinkCounterHalfMask)
;     307   if (View == SHOW_Normal)
;     308   #ifdef Blinking
;     309   if (GoBlinking)
;     310   #endif
;     311   if (DimmerCounter % DimmerDivider == 0)
;     312   {
;     313     DigitsActive = 1;
;     314   }
;     315   #endif
;     316 
;     317   PORTB = byCharacter[byDisplay[0]];
;     318 //   if (Minus)
;     319 //   {
;     320 //     PORTB = PINB | 0b00000001;
;     321 //   }
;     322   #ifdef heat
;     323   if (LoadOn)
;     324   {
;     325     PORTB = PINB | 0b00000100;
;     326   }
;     327   #endif
;     328 
;     329   #ifdef cold
;     330   if (!LoadOn)
;     331   {
;     332     PORTB = PINB | 0b00000100;
;     333   }
;     334   #endif
;     335   if (View == SHOW_TLoadOn)
;     336   {
;     337     PORTB = PINB | 0b00001000;
;     338   }
;     339   DIGIT1 = DigitsActive;
;     340   delay_us(LED_delay);
;     341   DIGIT1 = 1;
;     342 
;     343   PORTB = byCharacter[byDisplay[1]];
;     344   DIGIT2 = DigitsActive;
;     345   delay_us(LED_delay);
;     346   DIGIT2 = 1;
;     347 
;     348   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     349   DIGIT3 = DigitsActive;
;     350   delay_us(LED_delay);
;     351   DIGIT3 = 1;
;     352 
;     353   PORTB = byCharacter[byDisplay[3]];
;     354   DIGIT4 = DigitsActive;
;     355   delay_us(LED_delay);
;     356   DIGIT4 = 1;
;     357 #endif
;     358 
;     359 #ifdef Anode
;     360   #ifdef Blinking
;     361   //BYTE
;     362   DigitsActive = 1;
;     363   DimmerCounter++;
;     364 //  if (BlinkCounter > BlinkHalfPeriod)
;     365   if (BlinkCounter & BlinkCounterHalfMask)
;     366   if (View == SHOW_Normal)
;     367   #ifdef Blinking
;     368   if (GoBlinking)
;     369   #endif
;     370   if (DimmerCounter % DimmerDivider == 0)
;     371   {
;     372     DigitsActive = 0;
;     373   }
;     374   #endif
;     375   PORTB = ~byCharacter[byDisplay[0]];
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x7
;     376 //   if (Minus)
;     377 //   {
;     378 //     PORTB = PINB & 0b11111110;
;     379 //   }
;     380   #ifdef heat
;     381   if (LoadOn)
;     382   {
;     383     PORTB = PINB & 0b11111011;
;     384   }
;     385   #endif
;     386 
;     387   #ifdef cold
;     388   if (!LoadOn)
;     389   {
;     390     PORTB = PINB & 0b11111011;
;     391   }
;     392   #endif
;     393   if (View == SHOW_TLoadOn)
	LDI  R30,LOW(1)
	CP   R30,R2
	BRNE _0x24
;     394   {
;     395     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     396   }
;     397   DIGIT1 = DigitsActive;
_0x24:
	SBI  0x12,5
;     398   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     399   DIGIT1 = 0;
	CBI  0x12,5
;     400 
;     401   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x7
;     402   DIGIT2 = DigitsActive;
	SBI  0x12,1
;     403   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     404   DIGIT2 = 0;
	CBI  0x12,1
;     405 
;     406   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     407   DIGIT3 = DigitsActive;
	SBI  0x12,0
;     408   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     409   DIGIT3 = 0;
	CBI  0x12,0
;     410 
;     411   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x7
;     412   DIGIT4 = DigitsActive;
	SBI  0x12,4
;     413   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     414   DIGIT4 = 0;
	CBI  0x12,4
;     415 #endif
;     416 
;     417   }
	SUBI R17,-1
	RJMP _0x22
_0x23:
;     418 }
	LD   R17,Y+
	RET
;     419 
;     420 // Timer 1 overflow interrupt service routine
;     421 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     422 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x5
;     423   BYTE i;
;     424   int Temp;
;     425   int *val;
;     426 // Reinitialize Timer 1 value
;     427 TCNT1=0x85EE;
	RCALL __SAVELOCR4
;	i -> R17
;	Temp -> R18,R19
;	*val -> R16
	LDI  R30,LOW(34286)
	LDI  R31,HIGH(34286)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     428 //TCNT1L=0xD1;
;     429 #ifdef EliminateFlicker
;     430 skipDelay = 1;
	SBI  0x13,1
;     431 #endif
;     432 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     433 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     434 
;     435 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     436 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     437 
;     438 Updating = !Updating;   //это шоб читать температуру через раз
	SBIS 0x13,2
	RJMP _0x37
	CBI  0x13,2
	RJMP _0x38
_0x37:
	SBI  0x13,2
_0x38:
;     439 if (Updating)           //если в этот раз читаем температуру, то
	SBIS 0x13,2
	RJMP _0x39
;     440 {
;     441   w1_write(0xBE);       //выдаём в шину 1-wire код 0xBE, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
;     442   ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     443 
;     444 #ifdef ShowDataErrors
;     445   AllDataFF = 1;
	SBI  0x13,5
;     446   NonZero = 0;
	CBI  0x13,6
;     447   for (i=0; i<W1_BUFFER_LEN; i++)
	LDI  R17,LOW(0)
_0x3F:
	CPI  R17,9
	BRSH _0x40
;     448   {
;     449     w1buffer[i]=w1_read();
	MOV  R30,R17
	SUBI R30,-LOW(_w1buffer)
	PUSH R30
	RCALL _w1_read
	POP  R26
	ST   X,R30
;     450     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     451     if (w1buffer[i] != 0xFF)
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BREQ _0x41
;     452     {
;     453       AllDataFF = 0;
	CBI  0x13,5
;     454     }
;     455     if (w1buffer[i] != 0x00)
_0x41:
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x44
;     456     {
;     457       NonZero = 1;
	SBI  0x13,6
;     458     }
;     459   }
_0x44:
	SUBI R17,-1
	RJMP _0x3F
_0x40:
;     460 #else
;     461   for (i=0; i<W1_BUFFER_LEN; i++)
;     462   {
;     463     w1buffer[i]=w1_read();
;     464   }
;     465 #endif
;     466   Initializing = 0;//хватит показывать заставку
	CBI  0x13,4
;     467 #ifdef ShowDataErrors
;     468   i=w1_dow_crc8(w1buffer,8);
	LDI  R30,LOW(_w1buffer)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	MOV  R17,R30
;     469   if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	TST  R10
	BRNE _0x49
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x4A
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x4B
;     470   {
;     471     //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
;     472     //то это просто некорректно закончилось измерение температуры
;     473     i--;
	SUBI R17,1
;     474   }
;     475   if (NonZero == 0)
_0x4B:
_0x4A:
_0x49:
	SBIS 0x13,6
;     476   {
;     477     //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
;     478     i--;
	SUBI R17,1
;     479   }
;     480   if (i != w1buffer[8])
	__GETB1MN _w1buffer,8
	CP   R30,R17
	BREQ _0x4D
;     481   {
;     482       //ошибка при передаче
;     483       ErrorLevel = 1;//это просто сбой
	LDI  R30,LOW(1)
	MOV  R11,R30
;     484       if (AllDataFF)
	SBIS 0x13,5
	RJMP _0x4E
;     485       {
;     486       //это обрыв
;     487         ErrorLevel = 2;
	LDI  R30,LOW(2)
	RJMP _0xC0
;     488       }
;     489       else
_0x4E:
;     490       {
;     491         if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x50
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x51
;     492         {
;     493           ErrorLevel = 3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;     494         }
;     495         if (NonZero == 0)
_0x51:
_0x50:
	SBIC 0x13,6
	RJMP _0x52
;     496         {
;     497           ErrorLevel = 4;
	LDI  R30,LOW(4)
_0xC0:
	MOV  R11,R30
;     498         }
;     499       }
_0x52:
;     500       if (ErrorCounter > 0)
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x53
;     501       {
;     502         ErrorCounter--;
	DEC  R10
;     503       }
;     504       if (ErrorCounter == 0)
_0x53:
	TST  R10
	BRNE _0x54
;     505       {
;     506         #ifdef Blinking
;     507         GoBlinking = 1;
;     508         #endif
;     509       }
;     510   }
_0x54:
;     511   else
	RJMP _0x55
_0x4D:
;     512   {
;     513   #endif
;     514   val = (int*)&w1buffer[0];
	__POINTBRM 16,_w1buffer
;     515   Tnew =
;     516   (*val) * 10 / 16
;     517   #ifdef CorCode
;     518   + CorT
;     519   #endif
;     520   #ifdef CorT_Static
;     521   + CorT_Static
;     522   #endif
;     523   ;
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
;     524   RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     525   #ifdef ShowDataErrors
;     526   ErrorCounter = MaxDataErrors + 1;
	LDI  R30,LOW(5)
	MOV  R10,R30
;     527   #endif
;     528   #ifdef ShowDataErrors
;     529   }
_0x55:
;     530   #endif
;     531 }
;     532 else
	RJMP _0x56
_0x39:
;     533 {
;     534   w1_write(0x44);          //выдаём в шину 1-wire код 0x44, что значит "Convert T"
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
;     535 }
_0x56:
;     536 
;     537 #ifdef ShowDataErrors
;     538 if (ErrorCounter == 0)
	TST  R10
	BRNE _0x57
;     539 {
;     540   PORTD.3 = 0;
	CBI  0x12,3
;     541   PORTD.2 = 0;
	CBI  0x12,2
;     542   NeedResetLoad = 1;
	SBI  0x13,7
;     543   LoadOn = ShowDotWhenError;
	CBI  0x13,3
;     544 }
;     545 else
	RJMP _0x60
_0x57:
;     546 #endif
;     547 if (!Initializing)
	SBIC 0x13,4
	RJMP _0x61
;     548 {
;     549 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R8
	ADD  R30,R6
	ADC  R31,R7
	MOVW R18,R30
;     550 
;     551 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 4,5,18,19
	BRLT _0x62
	SBIC 0x13,3
	RJMP _0x64
	SBIS 0x13,7
	RJMP _0x63
_0x64:
;     552 {                              //то выключаем нагрузку
;     553   PORTD.2 = 0;
	CBI  0x12,2
;     554   PORTD.3 = 1;
	SBI  0x12,3
;     555   LoadOn = 0;
	CBI  0x13,3
;     556   NeedResetLoad = 0;
	CBI  0x13,7
;     557 }
;     558 
;     559 Temp = T_LoadOn;                //Temp - временная переменная.
_0x63:
_0x62:
	MOVW R18,R6
;     560 
;     561 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 18,19,4,5
	BRLT _0x6E
	SBIS 0x13,3
	RJMP _0x70
	SBIS 0x13,7
	RJMP _0x6F
_0x70:
;     562 {                               //то включаем нагрузку
;     563   PORTD.3 = 0;
	CBI  0x12,3
;     564   PORTD.2 = 1;
	SBI  0x12,2
;     565   LoadOn = 1;
	SBI  0x13,3
;     566   NeedResetLoad = 0;
	CBI  0x13,7
;     567 }
;     568 }//if errorCounter
_0x6F:
_0x6E:
;     569 
;     570 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x61:
_0x60:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x7A
;     571 {
;     572   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R3
;     573 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     574 else                            //пока не станет равной "0".
	RJMP _0x7B
_0x7A:
;     575 {
;     576   View = SHOW_Normal;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R2
;     577 }
_0x7B:
;     578 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     579 #ifdef EliminateFlicker
;     580 skipDelay = 0;
	CBI  0x13,1
;     581 #endif
;     582 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RCALL SUBOPT_0x6
	RETI
;     583 
;     584 // Declare your global variables here
;     585 
;     586 void main(void)
;     587 {
_main:
;     588 // Declare your local variables here
;     589 
;     590 // Crystal Oscillator division factor: 1
;     591 #pragma optsize-
;     592 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     593 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     594 #ifdef _OPTIMIZE_SIZE_
;     595 #pragma optsize+
;     596 #endif
;     597 
;     598         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
;     599         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
;     600         //         если установлена 1 - то на выводе устанавливается лог. 1
;     601         //         если установлена 0 - то на выводе устанавливается лог. 0
;     602         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
;     603         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
;     604 
;     605         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     606         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     607 
;     608         PORTB=0b00000000;
	OUT  0x18,R30
;     609         DDRB= 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     610 
;     611 
;     612         #ifdef Cathode
;     613           PORTD=0b01110011;
;     614           DDRD= 0b00111111;
;     615         #endif
;     616 
;     617         #ifdef Anode
;     618           PORTD=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
;     619           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     620         #endif
;     621 
;     622 //выше уже проинициализировали
;     623 //PORTD.3 = 0;
;     624 //PORTD.2 = 0;
;     625 
;     626 // Timer/Counter 0 initialization
;     627 // Clock source: System Clock
;     628 // Clock value: 8000,000 kHz
;     629 // Mode: Normal top=FFh
;     630 // OC0A output: Disconnected
;     631 // OC0B output: Disconnected
;     632 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     633 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     634 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     635 // OCR0A=0x00;
;     636 // OCR0B=0x00;
;     637 
;     638 // Timer/Counter 1 initialization
;     639 // Clock source: System Clock
;     640 // Clock value: 7,813 kHz
;     641 // Mode: Normal top=FFFFh
;     642 // OC1A output: Discon.
;     643 // OC1B output: Discon.
;     644 // Noise Canceler: Off
;     645 // Input Capture on Falling Edge
;     646 // Timer 1 Overflow Interrupt: On
;     647 // Input Capture Interrupt: Off
;     648 // Compare A Match Interrupt: Off
;     649 // Compare B Match Interrupt: Off
;     650 TCCR1A=0x00;
	OUT  0x2F,R30
;     651 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     652 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
;     653 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
;     654 // ICR1H=0x00;
;     655 // ICR1L=0x00;
;     656 // OCR1AH=0x00;
;     657 // OCR1AL=0x00;
;     658 // OCR1BH=0x00;
;     659 // OCR1BL=0x00;
;     660 
;     661 // External Interrupt(s) initialization
;     662 // INT0: Off
;     663 // INT1: Off
;     664 // Interrupt on any change on pins PCINT0-7: Off
;     665 GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;     666 MCUCR=0x00;
	OUT  0x35,R30
;     667 
;     668 // Timer(s)/Counter(s) Interrupt(s) initialization
;     669 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
;     670 
;     671 // Universal Serial Interface initialization
;     672 // Mode: Disabled
;     673 // Clock source: Register & Counter=no clk.
;     674 // USI Counter Overflow Interrupt: Off
;     675 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     676 
;     677 // Analog Comparator initialization
;     678 // Analog Comparator: Off
;     679 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     680 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     681 
;     682 #ifdef Blinking
;     683 DimmerCounter = 0;
;     684 #endif
;     685 //Tnew = 0;                //Просто обнуляем, тыща больше не нужна
;     686 
;     687 if (!(eeDeltaT + 1))//проверка на FFFF - значение после стирания EEPROM
	RCALL SUBOPT_0x3
	ADIW R30,1
	BRNE _0x7E
;     688 {
;     689   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL SUBOPT_0x2
;     690   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;     691   #ifdef CorCode
;     692   eeCorT = CorT_Default;
;     693   #endif
;     694 }
;     695 
;     696 if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //если в EEPROM значение > Max или < Min значит он не прошился, или
_0x7E:
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x4E3)
	LDI  R26,HIGH(0x4E3)
	CPC  R31,R26
	BRGE _0x80
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0xFDDA)
	LDI  R26,HIGH(0xFDDA)
	CPC  R31,R26
	BRGE _0x7F
_0x80:
;     697   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL SUBOPT_0x2
;     698 if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
_0x7F:
	RCALL SUBOPT_0x3
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRGE _0x83
	RCALL SUBOPT_0x3
	SBIW R30,1
	BRGE _0x82
_0x83:
;     699   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;     700 #ifdef CorCode
;     701 if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не прошился, // mod by Grey4ip
;     702   eeCorT = CorT_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod by Grey4ip
;     703 CorT = eeCorT;
;     704 #endif
;     705 
;     706 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x82:
	RCALL SUBOPT_0x1
	MOVW R6,R30
;     707 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x3
	MOVW R8,R30
;     708 
;     709 #ifdef ShowDataErrors
;     710 ErrorLevel = 0;
	CLR  R11
;     711 ErrorCounter = 1;       //При включении обязательно показываем даже первую ошибку
	LDI  R30,LOW(1)
	MOV  R10,R30
;     712 #endif
;     713 #ifdef Blinking
;     714 GoBlinking = 0;
;     715 #endif
;     716 Initializing = 1;
	SBI  0x13,4
;     717 LoadOn = ShowDotAtStartup;//Точка включения нагрузки не должна гореть при старте, но для cold и heat это разные значения
	CBI  0x13,3
;     718 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     719 
;     720 Updating = 1; // Теперь первое обращение к датчику будет ConvertT
	SBI  0x13,2
;     721 
;     722 KbdInit();              //инициализация клавиатуры
	CBI  0x13,0
	RCALL SUBOPT_0x9
;     723 
;     724 // Global enable interrupts
;     725 #asm("sei")
	sei
;     726 
;     727 while (1)
_0x8D:
;     728       {
;     729       // Place your code here
;     730       #asm("cli");               //запрещаем прерывания
	cli
;     731       ShowDisplayData11Times();         //обновляем экран
	RCALL _ShowDisplayData11Times
;     732       #asm("sei");               //разрешаем прерывания
	sei
;     733       };
	RJMP _0x8D
;     734 
;     735 }
_0x90:
	RJMP _0x90
;     736 /**************************************************************************\
;     737  FILE ..........: KBD.C
;     738  AUTHOR ........: Vitaly Puzrin
;     739  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     740  NOTES .........:
;     741  COPYRIGHT .....: Vitaly Puzrin, 1999
;     742  HISTORY .......: DATE        COMMENT
;     743                   ---------------------------------------------------
;     744                   25.06.1999  Первая версия
;     745 \**************************************************************************/
;     746 
;     747 #include    "kbd.h"
;     748 #include <tiny2313.h>
;     749 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     750 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     751 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     752 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     753 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     754 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     755 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     756 	#endif
	#endif
;     757 #include "termostat_led.h"
;     758 
;     759 #if __CODEVISIONAVR__ > 2000
;     760 //проверка версии только для полной гарантии того, что
;     761 //оригинальная версия исходника не затрагивается
;     762 extern BYTE View;
;     763 extern BYTE Counter;
;     764 extern int T_LoadOn;
;     765 extern int DeltaT;
;     766 #ifdef CorCode
;     767 extern INT8 CorT;
;     768 #endif
;     769 extern void RefreshDisplay(void);
;     770 #endif
;     771 #ifdef Blinking
;     772 extern bit GoBlinking;
;     773 #endif
;     774 
;     775 #define     KEY_1      0x01    // Код клавиши 1
;     776 #define     KEY_2      0x02    // Код клавиши 2
;     777 #define     KEY_3      0x03    // Код клавиши 3
;     778 
;     779 bit btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
;     780 BYTE    byKeyCode;      // Код нажатой клавиши
;     781 
;     782 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры

	.DSEG
_byScanState:
	.BYTE 0x1
;     783 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
;     784 BYTE    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
_byCheckKeyCnt:
	.BYTE 0x1
;     785 BYTE    byIterationCounter =  40;//Счётчик до повторения
_byIterationCounter:
	.BYTE 0x1
;     786 
;     787 
;     788 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     789 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     790 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     791 
;     792 /**************************************************************************\
;     793     Инициализация модуля (переменных и железа)
;     794       Вход:  -
;     795       Выход: -
;     796 \**************************************************************************/
;     797 // inline void KbdInit(void)
;     798 // {
;     799 //     btKeyUpdate = FALSE;
;     800 //     byScanState = ST_WAIT_KEY;
;     801 // }
;     802 
;     803 /**************************************************************************\
;     804     Сканирование клавиатуры
;     805       Вход:  -
;     806       Выход: -
;     807 \**************************************************************************/
;     808 void ScanKbd(void)
;     809 {

	.CSEG
_ScanKbd:
;     810     switch (byScanState)
	LDS  R30,_byScanState
;     811     {
;     812         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x95
;     813             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     814             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0x96
;     815             {
;     816                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0xA
	MOV  R12,R30
;     817 
;     818                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xB
;     819 
;     820                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
;     821             }
;     822             break;
_0x96:
	RJMP _0x94
;     823 
;     824         case ST_CHECK_KEY:
_0x95:
	CPI  R30,LOW(0x1)
	BRNE _0x97
;     825             // Если клавиша удердивалась достаточно долго, то
;     826             // генерируем событие с кодом клавиши, и переходим к
;     827             // ожиданию отпускания клавиши
;     828             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0xA
	CP   R30,R12
	BRNE _0x98
;     829             {
;     830                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
;     831                 if (!byCheckKeyCnt)
	BRNE _0x99
;     832                 {
;     833                     btKeyUpdate = TRUE;
	SBI  0x13,0
;     834                     byKeyCode = byCheckedKey;
	MOV  R13,R12
;     835                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
;     836                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     837                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	STS  _byIterationCounter,R30
;     838                 }
;     839             }
_0x99:
;     840             // Если данные неустойчитывы, то возвращается назад,
;     841             // к ожиданию нажатия клавиши
;     842             else
	RJMP _0x9C
_0x98:
;     843                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     844             break;
_0x9C:
	RJMP _0x94
;     845 
;     846         case ST_RELEASE_WAIT:
_0x97:
	CPI  R30,LOW(0x2)
	BRNE _0x94
;     847             // Пока клавиша не будет отпущена на достаточный интервал
;     848             // времени, будем оставаться в этом состоянии
;     849             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0x9E
;     850             {
;     851                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     852                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0x9F
;     853                 {
;     854                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	STS  _byIterationCounter,R30
;     855                   btKeyUpdate = TRUE;
	SBI  0x13,0
;     856                 }
;     857                 byIterationCounter--;
_0x9F:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RJMP _0xC1
;     858             }
;     859             else
_0x9E:
;     860             {
;     861                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
;     862                 if (!byCheckKeyCnt)
	BRNE _0xA3
;     863                 {
;     864                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     865                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
_0xC1:
	STS  _byIterationCounter,R30
;     866                 }
;     867             }
_0xA3:
;     868             break;
;     869     }
_0x94:
;     870     if( btKeyUpdate )
	SBIS 0x13,0
	RJMP _0xA4
;     871     {
;     872       btKeyUpdate = FALSE;
	CBI  0x13,0
;     873       ProcessKey();
	RCALL _ProcessKey
;     874     }
;     875 }
_0xA4:
	RET
;     876 
;     877 /**************************************************************************\
;     878     Обработка нажатой клавиши.
;     879       Вход:  -
;     880       Выход: -
;     881 \**************************************************************************/
;     882 void ProcessKey(void)
;     883 {
_ProcessKey:
;     884     switch (byKeyCode)
	MOV  R30,R13
;     885     {
;     886         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0xAA
;     887             switch (View)
	MOV  R30,R2
;     888             {
;     889 //               case 0:               //если был режим "Текущая температура", то
;     890 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     891 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;     892 //               break;
;     893               case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xAE
;     894                 if (T_LoadOn > TLoadOn_Min) //если "Установленная температура" > Min, то
	LDI  R30,LOW(64986)
	LDI  R31,HIGH(64986)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xAF
;     895                 {
;     896                   T_LoadOn -=10;      //уменьшаем значение на 0,1°
	RCALL SUBOPT_0x0
	__SUBWRR 6,7,30,31
;     897 //                  RefreshDisplay(); //обновляем данные на экране
;     898                 }
;     899 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
;     900 //                Counter = 5;        //и взводим счётчик на 5 секунд.
;     901               break;
_0xAF:
	RJMP _0xAD
;     902               case 2:               //если мы в режиме "Дэльта", то
_0xAE:
	CPI  R30,LOW(0x2)
	BRNE _0xAD
;     903                 if (DeltaT > DeltaT_Min)     //если "Дэльта" больше Min, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0xB1
;     904                 {
;     905                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
;     906 //                  RefreshDisplay(); //обновляем данные на экране
;     907                 }
;     908 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     909               break;
_0xB1:
;     910               #ifdef CorCode
;     911               case 3:                   //если мы в режиме "Коррекции", то
;     912                 if (CorT > CorT_Min)
;     913                 {
;     914                     CorT--;         //уменьшаем значение на 0,1°
;     915                 }
;     916                 break;
;     917               #endif
;     918             }
_0xAD:
;     919         break;
	RJMP _0xA9
;     920 
;     921         case KEY_2:                 // Была нажата клавиша Плюс
_0xAA:
	CPI  R30,LOW(0x2)
	BRNE _0xB2
;     922             switch (View)
	MOV  R30,R2
;     923             {
;     924 //               case 0:               //если был режим "Текущая температура", то
;     925 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     926 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;     927 //               break;
;     928               case 1:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xB6
;     929                 if (T_LoadOn < (TLoadOn_Max - DeltaT))    //если температура ниже Max - Дельта
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	SUB  R30,R8
	SBC  R31,R9
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xB7
;     930                 {
;     931                   T_LoadOn +=10;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R6
	ADIW R30,10
	MOVW R6,R30
;     932 //                  RefreshDisplay(); //обновляем данные на экране
;     933                 }
;     934 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
;     935 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     936               break;
_0xB7:
	RJMP _0xB5
;     937               case 2:
_0xB6:
	CPI  R30,LOW(0x2)
	BRNE _0xB5
;     938                 if (DeltaT < DeltaT_Max)   //если Дельта меньше Max, то
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0xB9
;     939                 {
;     940                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;     941 //                  RefreshDisplay(); //обновляем данные на экране
;     942                 }
;     943 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     944               break;
_0xB9:
;     945               #ifdef CorCode
;     946               case 3:                   //если мы в режиме "Коррекции", то
;     947                 if (CorT < CorT_Max)
;     948                 {
;     949                     CorT++;
;     950                 }
;     951               break;
;     952               #endif
;     953             }
_0xB5:
;     954         break;
	RJMP _0xA9
;     955 
;     956         case KEY_3:               // Была нажаты обе кноки вместе.
_0xB2:
	CPI  R30,LOW(0x3)
	BRNE _0xBC
;     957           View++;
	INC  R2
;     958           if (View > View_Max)
	LDI  R30,LOW(3)
	CP   R30,R2
	BRSH _0xBB
;     959           {
;     960             View = SHOW_TLoadOn;
	LDI  R30,LOW(1)
	MOV  R2,R30
;     961           }
;     962 //             switch (View)
;     963 //             {
;     964 //               case 0:               //если был режим "Текущая температура", то
;     965 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     966 //               break;
;     967 //               case 1:               //если мы в режиме "Установленная температура", то
;     968 //                 View = SHOW_DeltaT;           //удерживаем в режиме "Дэльта"
;     969 //               break;
;     970 //               case 2:
;     971 //                 View = SHOW_Error;           //переходим в режим "Последняя обнаруженная ошибка"
;     972 //               break;
;     973 //               case 3:
;     974 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     975 //               break;
;     976 //             }
;     977 //             Counter = 5;        //и взводим счётчик на 5 секунд.
;     978 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     979 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     980 //            Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     981         break;
_0xBB:
;     982 
;     983         default:
_0xBC:
;     984         break;
;     985 
;     986     }
_0xA9:
;     987     Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R3,R30
;     988     #ifdef Blinking
;     989     GoBlinking = 0;
;     990     #endif
;     991     RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     992 
;     993 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
	RCALL __EEPROMWRW
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	__DELAY_USW 1200
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(4)
	STS  _byCheckKeyCnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R30,_byCheckKeyCnt
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	SUBI R30,LOW(1)
	STS  _byCheckKeyCnt,R30
	RCALL SUBOPT_0xC
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
