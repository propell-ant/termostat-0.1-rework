
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
;      57 
;      58 // буфер данных, для вывода на экран
;      59 BYTE byDisplay[4]
;      60 #ifdef ShowWelcomeScreen
;      61 ={11,11,11,11}
_byDisplay:
	.BYTE 0x4
;      62 #endif
;      63 ;
;      64 
;      65 bit Updating;         //служебная переменная
;      66 //bit Minus;            //равна "1" если температура отрицательная
;      67 bit LoadOn;           //равна "1" если включена нагрузка
;      68 bit Initializing;        //равна "1" до получения первого значения температуры с датчика
;      69 
;      70 #ifdef ShowDataErrors
;      71 bit AllDataFF;
;      72 bit NonZero;
;      73 #endif
;      74 
;      75 BYTE Counter = 0;         //служебная переменная, для подсчёта времени возврата в основной режим отображения
;      76 BYTE View = SHOW_Normal;  //определяет в каком режиме отображения находится устройство:
;      77                           //SHOW_Normal  - основной - Текущая температура
;      78                           //SHOW_TLoadOn - Установленная температура
;      79                           //SHOW_DeltaT  - Дэльта
;      80                           //SHOW_CorT    - Поправка к показаниям датчика (если включена опция CorCode)
;      81                           //SHOW_Error   - Код ошибки при наличии ошибки (если включена опция ShowDataErrors)
;      82 
;      83 int Tnew;                //для хранения нового значения измеренной температуры
;      84 int T_LoadOn;            //для хранения значения Установленной температуры
;      85 int DeltaT;              //для хранения значения Дэльты
;      86 #ifdef CorCode
;      87 INT8 CorT;
;      88 #endif
;      89 
;      90 #ifdef ShowDataErrors
;      91 #define W1_BUFFER_LEN 9
;      92 #else
;      93 #define W1_BUFFER_LEN 2
;      94 #endif
;      95 BYTE w1buffer[W1_BUFFER_LEN];//для хранения принятых с датчика данных
_w1buffer:
	.BYTE 0x9
;      96 
;      97 bit NeedResetLoad = 1;   //флаг для правильного возвращения состояния реле после исчезновения ошибки
;      98 #ifdef ShowDataErrors
;      99 BYTE ErrorLevel;         //для хранения номера последней обнаруженной ошибки передачи данных
;     100 BYTE ErrorCounter;       //для хранения количества обнаруженных ПОДРЯД ошибок, первая же удачная передача сбрасывает этот счетчик
;     101 #define MaxDataErrors 1  //количество игнорируемых ПОДРЯД-ошибок, по умолчанию 1, максимум 255
;     102 #endif
;     103 #ifdef Blinking
;     104 bit GoBlinking = 0;   //флаг для мигания (отображения информации об ошибке)
;     105 #endif
;     106 #ifdef heat
;     107 #define ShowDotWhenError 0
;     108 #endif
;     109 #ifdef cold
;     110 #define ShowDotWhenError 1
;     111 #endif
;     112 
;     113 #ifdef Blinking
;     114 BYTE BlinkCounter;                      //Счетчик моргания
;     115 #define BlinkCounterMask 0b00111111     //примерно 2 моргания в секунду
;     116 #define BlinkCounterHalfMask 0b00100000 //примерно 2 моргания в секунду
;     117 BYTE DimmerCounter;                     //Счетчик яркости, моргание будет с неполным отключением индикатора
;     118 bit DigitsActive = 0;
;     119 #define DimmerDivider 4 //Это регулировка яркости: 4 соответствует 60%, 2 - примерно 35%
;     120 #else
;     121   #ifdef Cathode
;     122     #define DigitsActive 0
;     123   #endif
;     124   #ifdef Anode
;     125     #define DigitsActive 1
;     126   #endif
;     127 #endif
;     128 
;     129 //Это две переменные для "занимания места"
;     130 //чтобы данные, записанные предыдущей версией прошивки не влияли на новую версию
;     131 //(тип и формат хранения изменился)
;     132 eeprom WORD eeT_LoadOn0 = 1280;   //тут значение, которое не влияет ни на что

	.ESEG
_eeT_LoadOn0:
	.DW  0x500
;     133 eeprom WORD eeDeltaT0 = 10;       //тут значение, которое не влияет ни на что
_eeDeltaT0:
	.DW  0xA
;     134 
;     135 eeprom int eeT_LoadOn = TLoadOn_Default;
_eeT_LoadOn:
	.DW  0x118
;     136 eeprom int eeDeltaT = DeltaT_Default;
_eeDeltaT:
	.DW  0xA
;     137 #ifdef CorCode
;     138 eeprom INT8 eeCorT = CorT_Default;
;     139 #endif
;     140 BYTE byCharacter[SYMBOLS_LEN] = SymbolsArray;

	.DSEG
_byCharacter:
	.BYTE 0xF
;     141 
;     142 /************************************************************************\
;     143 \************************************************************************/
;     144 void PrepareData(int Data)
;     145 {

	.CSEG
_PrepareData:
;     146     BYTE i;
;     147     int D;
;     148     if (Initializing)
	RCALL __SAVELOCR4
;	Data -> Y+4
;	i -> R17
;	D -> R18,R19
	SBIC 0x13,4
;     149     {
;     150       return;
	RJMP _0xCC
;     151     }
;     152     if (Data < 0)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0x6
;     153     {
;     154       D = -Data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __ANEGW1
	MOVW R18,R30
;     155     }
;     156     else
	RJMP _0x7
_0x6:
;     157     {
;     158       D = Data;
	__GETWRS 18,19,4
;     159     }
_0x7:
;     160 
;     161     //Преобразуем в десятичное представление
;     162     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
;     163     {
;     164        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	SUBI R30,-LOW(_byDisplay)
	MOV  R16,R30
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __MODW21
	MOV  R26,R16
	ST   X,R30
;     165        D /= 10;
	MOVW R26,R18
	RCALL SUBOPT_0x0
	RCALL __DIVW21
	MOVW R18,R30
;     166     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
;     167 
;     168     if (byDisplay[0] == 0)
	LDS  R30,_byDisplay
	CPI  R30,0
	BRNE _0xB
;     169     {
;     170       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
;     171       if (byDisplay[1] == 0)
	__GETB1MN _byDisplay,1
	CPI  R30,0
	BRNE _0xC
;     172       {
;     173         byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
;     174       }
;     175     }
_0xC:
;     176     if (Data < 0)
_0xB:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,0
	BRGE _0xD
;     177     {
;     178       byDisplay[0] = 11;
	LDI  R30,LOW(11)
	STS  _byDisplay,R30
;     179     }
;     180     switch (View)
_0xD:
	MOV  R30,R2
;     181     {
;     182         case SHOW_DeltaT:
	CPI  R30,LOW(0x2)
	BRNE _0x11
;     183           byDisplay[0] = 12;
	LDI  R30,LOW(12)
	RJMP _0xCD
;     184           break;
;     185         #ifdef CorCode
;     186         case SHOW_CorT:
;     187           byDisplay[0] = 13;
;     188           if (Data < 0)
;     189           {
;     190             byDisplay[1] = 11;
;     191           }
;     192           break;
;     193         #endif
;     194         #ifdef ShowDataErrors
;     195         case SHOW_Error:
_0x11:
	CPI  R30,LOW(0x3)
	BREQ _0xCE
;     196           byDisplay[0] = 14;
;     197           break;
;     198         case SHOW_Normal:
	CPI  R30,0
	BRNE _0x10
;     199           if (ErrorCounter == 0)
	TST  R10
	BRNE _0x14
;     200           {
;     201             byDisplay[0] = 14;
_0xCE:
	LDI  R30,LOW(14)
_0xCD:
	STS  _byDisplay,R30
;     202           }
;     203           break;
_0x14:
;     204         #endif
;     205     }
_0x10:
;     206 
;     207 }
_0xCC:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     208 
;     209 /************************************************************************\
;     210   Обновление дисплея.
;     211       Вход:  -
;     212       Выход: -
;     213 \************************************************************************/
;     214 void RefreshDisplay(void)
;     215 {
_RefreshDisplay:
;     216   int Data;
;     217   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R2
;     218   {
;     219     case SHOW_Normal:
	CPI  R30,0
	BRNE _0x18
;     220       #ifdef ShowDataErrors
;     221       if (ErrorCounter == 0)
	TST  R10
	BRNE _0x19
;     222       {
;     223         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
;     224       }
;     225       else
	RJMP _0x1A
_0x19:
;     226       #endif
;     227       {
;     228         Data = Tnew;
	MOVW R16,R4
;     229       }
_0x1A:
;     230       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x1
	CP   R30,R6
	CPC  R31,R7
	BREQ _0x1B
;     231         eeT_LoadOn = T_LoadOn;
	MOVW R30,R6
	RCALL SUBOPT_0x2
;     232       if (DeltaT != eeDeltaT)
_0x1B:
	RCALL SUBOPT_0x3
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1C
;     233         eeDeltaT = DeltaT;
	MOVW R30,R8
	RCALL SUBOPT_0x4
;     234       #ifdef CorCode
;     235       if (CorT != eeCorT)
;     236         eeCorT = CorT;
;     237       #endif
;     238     break;
_0x1C:
	RJMP _0x17
;     239     case SHOW_TLoadOn:
_0x18:
	CPI  R30,LOW(0x1)
	BRNE _0x1D
;     240       Data = T_LoadOn;
	MOVW R16,R6
;     241     break;
	RJMP _0x17
;     242 
;     243     case SHOW_DeltaT:
_0x1D:
	CPI  R30,LOW(0x2)
	BRNE _0x1E
;     244       Data = DeltaT;
	MOVW R16,R8
;     245     break;
	RJMP _0x17
;     246 #ifdef CorCode
;     247     case SHOW_CorT:
;     248         Data = CorT;
;     249     break;
;     250 #endif
;     251 #ifdef ShowDataErrors
;     252     case SHOW_Error:
_0x1E:
	CPI  R30,LOW(0x3)
	BRNE _0x17
;     253         Data = ErrorLevel;
	MOV  R16,R11
	CLR  R17
;     254     break;
;     255 #endif
;     256   }
_0x17:
;     257 
;     258   PrepareData(Data);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _PrepareData
;     259 }
	RCALL __LOADLOCR2P
	RET
;     260 
;     261 // Timer 0 overflow interrupt service routine
;     262 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     263 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x5
;     264 // Reinitialize Timer 0 value
;     265 TCNT0=0xB5;
	LDI  R30,LOW(181)
	OUT  0x32,R30
;     266 // if (BlinkCounter < 2 * BlinkHalfPeriod)
;     267 // {
;     268 #ifdef Blinking
;     269   BlinkCounter++;
	INC  R13
;     270   BlinkCounter &= BlinkCounterMask;
	LDI  R30,LOW(63)
	AND  R13,R30
;     271 #endif
;     272 //}
;     273 // else
;     274 // {
;     275 //   BlinkCounter = 0;
;     276 // }
;     277 
;     278 ScanKbd();
	RCALL _ScanKbd
;     279 }
	RCALL SUBOPT_0x6
	RETI
;     280 
;     281 void ShowDisplayData11Times(void)
;     282 {
_ShowDisplayData11Times:
;     283   BYTE i;
;     284   #ifdef EliminateFlicker
;     285   if (!skipDelay)
	ST   -Y,R17
;	i -> R17
	SBIC 0x13,1
	RJMP _0x20
;     286   {
;     287     delay_us(LED_delay_add);
	__DELAY_USW 1600
;     288   }
;     289   #endif
;     290 
;     291   for (i=0; i<4; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
_0x20:
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x23
;     292   {
;     293 //    ShowDisplayData();
;     294  #ifdef Cathode
;     295   #ifdef Blinking
;     296   //BYTE
;     297   DigitsActive = 0;
;     298   DimmerCounter++;
;     299 //  if (BlinkCounter > BlinkHalfPeriod)
;     300   if (BlinkCounter & BlinkCounterHalfMask)
;     301   if (View == SHOW_Normal)
;     302   #ifdef Blinking
;     303   if (GoBlinking)
;     304   #endif
;     305   if (DimmerCounter % DimmerDivider == 0)
;     306   {
;     307     DigitsActive = 1;
;     308   }
;     309   #endif
;     310 
;     311   PORTB = byCharacter[byDisplay[0]];
;     312 //   if (Minus)
;     313 //   {
;     314 //     PORTB = PINB | 0b00000001;
;     315 //   }
;     316   #ifdef heat
;     317   if (LoadOn)
;     318   #endif
;     319 
;     320   #ifdef cold
;     321   if (!LoadOn)
;     322   #endif
;     323   {
;     324     PORTB = PINB | 0b00000100;
;     325   }
;     326   if (View == SHOW_TLoadOn)
;     327   {
;     328     PORTB = PINB | 0b00001000;
;     329   }
;     330   DIGIT1 = DigitsActive;
;     331   delay_us(LED_delay);
;     332   DIGIT1 = 1;
;     333 
;     334   PORTB = byCharacter[byDisplay[1]];
;     335   DIGIT2 = DigitsActive;
;     336   delay_us(LED_delay);
;     337   DIGIT2 = 1;
;     338 
;     339   PORTB = byCharacter[byDisplay[2]] | 0b00000100;
;     340   DIGIT3 = DigitsActive;
;     341   delay_us(LED_delay);
;     342   DIGIT3 = 1;
;     343 
;     344   PORTB = byCharacter[byDisplay[3]];
;     345   DIGIT4 = DigitsActive;
;     346   delay_us(LED_delay);
;     347   DIGIT4 = 1;
;     348 #endif
;     349 
;     350 #ifdef Anode
;     351   #ifdef Blinking
;     352   //BYTE
;     353   DigitsActive = 1;
	SBI  0x14,1
;     354   DimmerCounter++;
	INC  R12
;     355 //  if (BlinkCounter > BlinkHalfPeriod)
;     356   if (BlinkCounter & BlinkCounterHalfMask)
	SBRS R13,5
	RJMP _0x26
;     357   if (View == SHOW_Normal)
	TST  R2
	BRNE _0x27
;     358   #ifdef Blinking
;     359   if (GoBlinking)
	SBIS 0x14,0
	RJMP _0x28
;     360   #endif
;     361   if (DimmerCounter % DimmerDivider == 0)
	MOV  R30,R12
	ANDI R30,LOW(0x3)
	BRNE _0x29
;     362   {
;     363     DigitsActive = 0;
	CBI  0x14,1
;     364   }
;     365   #endif
;     366   PORTB = ~byCharacter[byDisplay[0]];
_0x29:
_0x28:
_0x27:
_0x26:
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x7
;     367 //   if (Minus)
;     368 //   {
;     369 //     PORTB = PINB & 0b11111110;
;     370 //   }
;     371   #ifdef heat
;     372   if (LoadOn)
	SBIS 0x13,3
	RJMP _0x2C
;     373   #endif
;     374 
;     375   #ifdef cold
;     376   if (!LoadOn)
;     377   #endif
;     378   {
;     379     PORTB = PINB & 0b11111011;
	IN   R30,0x16
	ANDI R30,0xFB
	OUT  0x18,R30
;     380   }
;     381   if (View == SHOW_TLoadOn)
_0x2C:
	LDI  R30,LOW(1)
	CP   R30,R2
	BRNE _0x2D
;     382   {
;     383     PORTB = PINB & 0b11110111;
	IN   R30,0x16
	ANDI R30,0XF7
	OUT  0x18,R30
;     384   }
;     385   DIGIT1 = DigitsActive;
_0x2D:
	SBIC 0x14,1
	RJMP _0x2E
	CBI  0x12,5
	RJMP _0x2F
_0x2E:
	SBI  0x12,5
_0x2F:
;     386   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     387   DIGIT1 = 0;
	CBI  0x12,5
;     388 
;     389   PORTB = ~byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x7
;     390   DIGIT2 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x32
	CBI  0x12,1
	RJMP _0x33
_0x32:
	SBI  0x12,1
_0x33:
;     391   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     392   DIGIT2 = 0;
	CBI  0x12,1
;     393 
;     394   PORTB = ~byCharacter[byDisplay[2]] & 0b11111011;
	__GETB1MN _byDisplay,2
	SUBI R30,-LOW(_byCharacter)
	LD   R30,Z
	COM  R30
	ANDI R30,0xFB
	OUT  0x18,R30
;     395   DIGIT3 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x36
	CBI  0x12,0
	RJMP _0x37
_0x36:
	SBI  0x12,0
_0x37:
;     396   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     397   DIGIT3 = 0;
	CBI  0x12,0
;     398 
;     399   PORTB = ~byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x7
;     400   DIGIT4 = DigitsActive;
	SBIC 0x14,1
	RJMP _0x3A
	CBI  0x12,4
	RJMP _0x3B
_0x3A:
	SBI  0x12,4
_0x3B:
;     401   delay_us(LED_delay);
	RCALL SUBOPT_0x8
;     402   DIGIT4 = 0;
	CBI  0x12,4
;     403 #endif
;     404 
;     405   }
	SUBI R17,-1
	RJMP _0x22
_0x23:
;     406 }
	LD   R17,Y+
	RET
;     407 
;     408 // Timer 1 overflow interrupt service routine
;     409 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     410 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x5
;     411   BYTE i;
;     412   int Temp;
;     413   int *val;
;     414 // Reinitialize Timer 1 value
;     415 TCNT1=0x85EE;
	RCALL __SAVELOCR4
;	i -> R17
;	Temp -> R18,R19
;	*val -> R16
	LDI  R30,LOW(34286)
	LDI  R31,HIGH(34286)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     416 //TCNT1L=0xD1;
;     417 #ifdef EliminateFlicker
;     418 skipDelay = 1;
	SBI  0x13,1
;     419 #endif
;     420 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
;     421 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     422 
;     423 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R30,LOW(204)
	ST   -Y,R30
	RCALL _w1_write
;     424 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     425 
;     426 Updating = !Updating;   //это шоб читать температуру через раз
	SBIS 0x13,2
	RJMP _0x40
	CBI  0x13,2
	RJMP _0x41
_0x40:
	SBI  0x13,2
_0x41:
;     427 if (Updating)           //если в этот раз читаем температуру, то
	SBIS 0x13,2
	RJMP _0x42
;     428 {
;     429   w1_write(0xBE);       //выдаём в шину 1-wire код 0xBE, что значит "Read Scratchpad"
	LDI  R30,LOW(190)
	ST   -Y,R30
	RCALL _w1_write
;     430   ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     431 
;     432 #ifdef ShowDataErrors
;     433   AllDataFF = 1;
	SBI  0x13,5
;     434   NonZero = 0;
	CBI  0x13,6
;     435   for (i=0; i<W1_BUFFER_LEN; i++)
	LDI  R17,LOW(0)
_0x48:
	CPI  R17,9
	BRSH _0x49
;     436   {
;     437     w1buffer[i]=w1_read();
	MOV  R30,R17
	SUBI R30,-LOW(_w1buffer)
	PUSH R30
	RCALL _w1_read
	POP  R26
	ST   X,R30
;     438     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
;     439     if (w1buffer[i] != 0xFF)
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R26,X
	CPI  R26,LOW(0xFF)
	BREQ _0x4A
;     440     {
;     441       AllDataFF = 0;
	CBI  0x13,5
;     442     }
;     443     if (w1buffer[i] != 0x00)
_0x4A:
	LDI  R26,LOW(_w1buffer)
	ADD  R26,R17
	LD   R30,X
	CPI  R30,0
	BREQ _0x4D
;     444     {
;     445       NonZero = 1;
	SBI  0x13,6
;     446     }
;     447   }
_0x4D:
	SUBI R17,-1
	RJMP _0x48
_0x49:
;     448 #else
;     449   for (i=0; i<W1_BUFFER_LEN; i++)
;     450   {
;     451     w1buffer[i]=w1_read();
;     452   }
;     453 #endif
;     454   Initializing = 0;//хватит показывать заставку
	CBI  0x13,4
;     455 #ifdef ShowDataErrors
;     456   i=w1_dow_crc8(w1buffer,8);
	LDI  R30,LOW(_w1buffer)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	MOV  R17,R30
;     457   if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	TST  R10
	BRNE _0x52
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x53
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x54
;     458   {
;     459     //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
;     460     //то это просто некорректно закончилось измерение температуры
;     461     i--;
	SUBI R17,1
;     462   }
;     463   if (NonZero == 0)
_0x54:
_0x53:
_0x52:
	SBIS 0x13,6
;     464   {
;     465     //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
;     466     i--;
	SUBI R17,1
;     467   }
;     468   if (i != w1buffer[8])
	__GETB1MN _w1buffer,8
	CP   R30,R17
	BREQ _0x56
;     469   {
;     470       //ошибка при передаче
;     471       ErrorLevel = 1;//это просто сбой
	LDI  R30,LOW(1)
	MOV  R11,R30
;     472       if (AllDataFF)
	SBIS 0x13,5
	RJMP _0x57
;     473       {
;     474       //это обрыв
;     475         ErrorLevel = 2;
	LDI  R30,LOW(2)
	RJMP _0xCF
;     476       }
;     477       else
_0x57:
;     478       {
;     479         if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x59
	__GETB1MN _w1buffer,1
	CPI  R30,LOW(0x5)
	BRNE _0x5A
;     480         {
;     481           ErrorLevel = 3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;     482         }
;     483         if (NonZero == 0)
_0x5A:
_0x59:
	SBIC 0x13,6
	RJMP _0x5B
;     484         {
;     485           ErrorLevel = 4;
	LDI  R30,LOW(4)
_0xCF:
	MOV  R11,R30
;     486         }
;     487       }
_0x5B:
;     488       if (ErrorCounter > 0)
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x5C
;     489       {
;     490         ErrorCounter--;
	DEC  R10
;     491       }
;     492       if (ErrorCounter == 0)
_0x5C:
	TST  R10
	BRNE _0x5D
;     493       {
;     494         #ifdef Blinking
;     495         GoBlinking = 1;
	SBI  0x14,0
;     496         #endif
;     497       }
;     498   }
_0x5D:
;     499   else
	RJMP _0x60
_0x56:
;     500   {
;     501   #endif
;     502   val = (int*)&w1buffer[0];
	__POINTBRM 16,_w1buffer
;     503   Tnew =
;     504   (*val) * 10 / 16
;     505   #ifdef CorCode
;     506   + CorT
;     507   #endif
;     508   #ifdef CorT_Static
;     509   + CorT_Static
;     510   #endif
;     511   ;
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
;     512   RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     513   #ifdef ShowDataErrors
;     514   ErrorCounter = MaxDataErrors + 1;
	LDI  R30,LOW(2)
	MOV  R10,R30
;     515   #endif
;     516   #ifdef ShowDataErrors
;     517   }
_0x60:
;     518   #endif
;     519 }
;     520 else
	RJMP _0x61
_0x42:
;     521 {
;     522   w1_write(0x44);          //выдаём в шину 1-wire код 0x44, что значит "Convert T"
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _w1_write
;     523 }
_0x61:
;     524 
;     525 #ifdef ShowDataErrors
;     526 if (ErrorCounter == 0)
	TST  R10
	BRNE _0x62
;     527 {
;     528   PORTD.3 = 0;
	CBI  0x12,3
;     529   PORTD.2 = 0;
	CBI  0x12,2
;     530   NeedResetLoad = 1;
	SBI  0x13,7
;     531   LoadOn = ShowDotWhenError;
	CBI  0x13,3
;     532 }
;     533 else
	RJMP _0x6B
_0x62:
;     534 #endif
;     535 if (!Initializing)
	SBIC 0x13,4
	RJMP _0x6C
;     536 {
;     537 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R8
	ADD  R30,R6
	ADC  R31,R7
	MOVW R18,R30
;     538 
;     539 if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 4,5,18,19
	BRLT _0x6D
	SBIC 0x13,3
	RJMP _0x6F
	SBIS 0x13,7
	RJMP _0x6E
_0x6F:
;     540 {                              //то выключаем нагрузку
;     541   PORTD.2 = 0;
	CBI  0x12,2
;     542   PORTD.3 = 1;
	SBI  0x12,3
;     543   LoadOn = 0;
	CBI  0x13,3
;     544   NeedResetLoad = 0;
	CBI  0x13,7
;     545 }
;     546 
;     547 Temp = T_LoadOn;                //Temp - временная переменная.
_0x6E:
_0x6D:
	MOVW R18,R6
;     548 
;     549 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 18,19,4,5
	BRLT _0x79
	SBIS 0x13,3
	RJMP _0x7B
	SBIS 0x13,7
	RJMP _0x7A
_0x7B:
;     550 {                               //то включаем нагрузку
;     551   PORTD.3 = 0;
	CBI  0x12,3
;     552   PORTD.2 = 1;
	SBI  0x12,2
;     553   LoadOn = 1;
	SBI  0x13,3
;     554   NeedResetLoad = 0;
	CBI  0x13,7
;     555 }
;     556 }//if errorCounter
_0x7A:
_0x79:
;     557 
;     558 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x6C:
_0x6B:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x85
;     559 {
;     560   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R3
;     561 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
;     562 else                            //пока не станет равной "0".
	RJMP _0x86
_0x85:
;     563 {
;     564   View = SHOW_Normal;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R2
;     565 }
_0x86:
;     566 RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     567 #ifdef EliminateFlicker
;     568 skipDelay = 0;
	CBI  0x13,1
;     569 #endif
;     570 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RCALL SUBOPT_0x6
	RETI
;     571 
;     572 // Declare your global variables here
;     573 
;     574 void main(void)
;     575 {
_main:
;     576 // Declare your local variables here
;     577 
;     578 // Crystal Oscillator division factor: 1
;     579 #pragma optsize-
;     580 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     581 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     582 #ifdef _OPTIMIZE_SIZE_
;     583 #pragma optsize+
;     584 #endif
;     585 
;     586         //Разряд DDRx - определяет направление передачи данных (0 - вход, 1 - выход).
;     587         //Разряд PORTx - если вывод определен выходом (DDRx = 1), то:
;     588         //         если установлена 1 - то на выводе устанавливается лог. 1
;     589         //         если установлена 0 - то на выводе устанавливается лог. 0
;     590         //    если вывод определен входом (DDRx = 0), то PORTx - определяет состояние подтягивающего резистора (при PORTx = 1 резистор подключен)
;     591         //Разряд PINx - доступен только для чтения и содержит физическое значение вывода порта
;     592 
;     593         PORTA=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x1B,R30
;     594         DDRA= 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     595 
;     596         PORTB=0b00000000;
	OUT  0x18,R30
;     597         DDRB= 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     598 
;     599 
;     600         #ifdef Cathode
;     601           PORTD=0b01110011;
;     602           DDRD= 0b00111111;
;     603         #endif
;     604 
;     605         #ifdef Anode
;     606           PORTD=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x12,R30
;     607           DDRD= 0b00111111;
	LDI  R30,LOW(63)
	OUT  0x11,R30
;     608         #endif
;     609 
;     610 //выше уже проинициализировали
;     611 //PORTD.3 = 0;
;     612 //PORTD.2 = 0;
;     613 
;     614 // Timer/Counter 0 initialization
;     615 // Clock source: System Clock
;     616 // Clock value: 8000,000 kHz
;     617 // Mode: Normal top=FFh
;     618 // OC0A output: Disconnected
;     619 // OC0B output: Disconnected
;     620 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     621 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     622 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     623 // OCR0A=0x00;
;     624 // OCR0B=0x00;
;     625 
;     626 // Timer/Counter 1 initialization
;     627 // Clock source: System Clock
;     628 // Clock value: 7,813 kHz
;     629 // Mode: Normal top=FFFFh
;     630 // OC1A output: Discon.
;     631 // OC1B output: Discon.
;     632 // Noise Canceler: Off
;     633 // Input Capture on Falling Edge
;     634 // Timer 1 Overflow Interrupt: On
;     635 // Input Capture Interrupt: Off
;     636 // Compare A Match Interrupt: Off
;     637 // Compare B Match Interrupt: Off
;     638 TCCR1A=0x00;
	OUT  0x2F,R30
;     639 TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;     640 TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
;     641 TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
;     642 // ICR1H=0x00;
;     643 // ICR1L=0x00;
;     644 // OCR1AH=0x00;
;     645 // OCR1AL=0x00;
;     646 // OCR1BH=0x00;
;     647 // OCR1BL=0x00;
;     648 
;     649 // External Interrupt(s) initialization
;     650 // INT0: Off
;     651 // INT1: Off
;     652 // Interrupt on any change on pins PCINT0-7: Off
;     653 GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;     654 MCUCR=0x00;
	OUT  0x35,R30
;     655 
;     656 // Timer(s)/Counter(s) Interrupt(s) initialization
;     657 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
;     658 
;     659 // Universal Serial Interface initialization
;     660 // Mode: Disabled
;     661 // Clock source: Register & Counter=no clk.
;     662 // USI Counter Overflow Interrupt: Off
;     663 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     664 
;     665 // Analog Comparator initialization
;     666 // Analog Comparator: Off
;     667 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     668 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     669 
;     670 #ifdef Blinking
;     671 DimmerCounter = 0;
	CLR  R12
;     672 #endif
;     673 //Tnew = 0;                //Просто обнуляем, тыща больше не нужна
;     674 
;     675 if (!(eeDeltaT + 1))//проверка на FFFF - значение после стирания EEPROM
	RCALL SUBOPT_0x3
	ADIW R30,1
	BRNE _0x89
;     676 {
;     677   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL SUBOPT_0x2
;     678   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;     679   #ifdef CorCode
;     680   eeCorT = CorT_Default;
;     681   #endif
;     682 }
;     683 
;     684 if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //если в EEPROM значение > Max или < Min значит он не прошился, или
_0x89:
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x4E3)
	LDI  R26,HIGH(0x4E3)
	CPC  R31,R26
	BRGE _0x8B
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0xFDDA)
	LDI  R26,HIGH(0xFDDA)
	CPC  R31,R26
	BRGE _0x8A
_0x8B:
;     685   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL SUBOPT_0x2
;     686 if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
_0x8A:
	RCALL SUBOPT_0x3
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRGE _0x8E
	RCALL SUBOPT_0x3
	SBIW R30,1
	BRGE _0x8D
_0x8E:
;     687   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;     688 #ifdef CorCode
;     689 if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не прошился, // mod by Grey4ip
;     690   eeCorT = CorT_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod by Grey4ip
;     691 CorT = eeCorT;
;     692 #endif
;     693 
;     694 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x8D:
	RCALL SUBOPT_0x1
	MOVW R6,R30
;     695 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x3
	MOVW R8,R30
;     696 
;     697 #ifdef ShowDataErrors
;     698 ErrorLevel = 0;
	CLR  R11
;     699 ErrorCounter = 1;       //При включении обязательно показываем даже первую ошибку
	LDI  R30,LOW(1)
	MOV  R10,R30
;     700 #endif
;     701 #ifdef Blinking
;     702 GoBlinking = 0;
	CBI  0x14,0
;     703 #endif
;     704 Initializing = 1;
	SBI  0x13,4
;     705 LoadOn = ShowDotAtStartup;//Точка включения нагрузки не должна гореть при старте, но для cold и heat это разные значения
	CBI  0x13,3
;     706 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
;     707 
;     708 Updating = 1; // Теперь первое обращение к датчику будет ConvertT
	SBI  0x13,2
;     709 
;     710 KbdInit();              //инициализация клавиатуры
	CBI  0x13,0
	RCALL SUBOPT_0x9
;     711 
;     712 // Global enable interrupts
;     713 #asm("sei")
	sei
;     714 
;     715 while (1)
_0x9A:
;     716       {
;     717       // Place your code here
;     718       #asm("cli");               //запрещаем прерывания
	cli
;     719       ShowDisplayData11Times();         //обновляем экран
	RCALL _ShowDisplayData11Times
;     720       #asm("sei");               //разрешаем прерывания
	sei
;     721       };
	RJMP _0x9A
;     722 
;     723 }
_0x9D:
	RJMP _0x9D
;     724 /**************************************************************************\
;     725  FILE ..........: KBD.C
;     726  AUTHOR ........: Vitaly Puzrin
;     727  DESCRIPTION ...: Обработка клавиатуры (сканирование и реакция на клавиши)
;     728  NOTES .........:
;     729  COPYRIGHT .....: Vitaly Puzrin, 1999
;     730  HISTORY .......: DATE        COMMENT
;     731                   ---------------------------------------------------
;     732                   25.06.1999  Первая версия
;     733 \**************************************************************************/
;     734 
;     735 #include    "kbd.h"
;     736 #include <tiny2313.h>
;     737 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     738 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     739 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;     740 	.EQU __sm_mask=0x50
	.EQU __sm_mask=0x50
;     741 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;     742 	.EQU __sm_standby=0x40
	.EQU __sm_standby=0x40
;     743 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     744 	#endif
	#endif
;     745 #include "termostat_led.h"
;     746 
;     747 #if __CODEVISIONAVR__ > 2000
;     748 //проверка версии только для полной гарантии того, что
;     749 //оригинальная версия исходника не затрагивается
;     750 extern BYTE View;
;     751 extern BYTE Counter;
;     752 extern int T_LoadOn;
;     753 extern int DeltaT;
;     754 #ifdef CorCode
;     755 extern INT8 CorT;
;     756 #endif
;     757 extern void RefreshDisplay(void);
;     758 #endif
;     759 #ifdef Blinking
;     760 extern bit GoBlinking;
;     761 #endif
;     762 
;     763 #define     KEY_1      0x01    // Код клавиши 1
;     764 #define     KEY_2      0x02    // Код клавиши 2
;     765 #define     KEY_3      0x03    // Код клавиши 3
;     766 
;     767 bit btKeyUpdate;    // = 1, когда обнаружено нажание на клавишу
;     768 BYTE    byKeyCode;      // Код нажатой клавиши

	.DSEG
_byKeyCode:
	.BYTE 0x1
;     769 
;     770 BYTE    byScanState;    // Состояние конечного автомата опроса клавиатуры
_byScanState:
	.BYTE 0x1
;     771 BYTE    byCheckedKey;   // Внутр. перем. Код проверяемой клавиши
_byCheckedKey:
	.BYTE 0x1
;     772 BYTE    byCheckKeyCnt;  // Внутр. перем. Счетчик времени нажатия/отжатия клавиши
_byCheckKeyCnt:
	.BYTE 0x1
;     773 BYTE    byIterationCounter =  40;//Счётчик до повторения
_byIterationCounter:
	.BYTE 0x1
;     774 
;     775 
;     776 #define KeyCode     ((PINA & 0b00000011) ^ 0b00000011)  // Макрос, который возвращает код нажатой клавиши
;     777 #define PRESS_CNT   4   // Время, которое клавиша должна удерживаться
;     778 #define RELEASE_CNT 4   // Время, после которого клавиша считается отжатым
;     779 
;     780 /**************************************************************************\
;     781     Инициализация модуля (переменных и железа)
;     782       Вход:  -
;     783       Выход: -
;     784 \**************************************************************************/
;     785 // inline void KbdInit(void)
;     786 // {
;     787 //     btKeyUpdate = FALSE;
;     788 //     byScanState = ST_WAIT_KEY;
;     789 // }
;     790 
;     791 /**************************************************************************\
;     792     Сканирование клавиатуры
;     793       Вход:  -
;     794       Выход: -
;     795 \**************************************************************************/
;     796 void ScanKbd(void)
;     797 {

	.CSEG
_ScanKbd:
;     798     switch (byScanState)
	LDS  R30,_byScanState
;     799     {
;     800         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0xA2
;     801             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
;     802             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0xA3
;     803             {
;     804                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0xA
	STS  _byCheckedKey,R30
;     805 
;     806                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xB
;     807 
;     808                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
;     809             }
;     810             break;
_0xA3:
	RJMP _0xA1
;     811 
;     812         case ST_CHECK_KEY:
_0xA2:
	CPI  R30,LOW(0x1)
	BRNE _0xA4
;     813             // Если клавиша удердивалась достаточно долго, то
;     814             // генерируем событие с кодом клавиши, и переходим к
;     815             // ожиданию отпускания клавиши
;     816             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0xA
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0xA5
;     817             {
;     818                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
;     819                 if (!byCheckKeyCnt)
	BRNE _0xA6
;     820                 {
;     821                     btKeyUpdate = TRUE;
	SBI  0x13,0
;     822                     byKeyCode = byCheckedKey;
	LDS  R30,_byCheckedKey
	STS  _byKeyCode,R30
;     823                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
;     824                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     825                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	STS  _byIterationCounter,R30
;     826                 }
;     827             }
_0xA6:
;     828             // Если данные неустойчитывы, то возвращается назад,
;     829             // к ожиданию нажатия клавиши
;     830             else
	RJMP _0xA9
_0xA5:
;     831                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     832             break;
_0xA9:
	RJMP _0xA1
;     833 
;     834         case ST_RELEASE_WAIT:
_0xA4:
	CPI  R30,LOW(0x2)
	BRNE _0xA1
;     835             // Пока клавиша не будет отпущена на достаточный интервал
;     836             // времени, будем оставаться в этом состоянии
;     837             if (KeyCode != 0)
	RCALL SUBOPT_0xA
	BREQ _0xAB
;     838             {
;     839                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xB
;     840                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0xAC
;     841                 {
;     842                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	STS  _byIterationCounter,R30
;     843                   btKeyUpdate = TRUE;
	SBI  0x13,0
;     844                 }
;     845                 byIterationCounter--;
_0xAC:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RJMP _0xD0
;     846             }
;     847             else
_0xAB:
;     848             {
;     849                 byCheckKeyCnt--;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
;     850                 if (!byCheckKeyCnt)
	BRNE _0xB0
;     851                 {
;     852                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x9
;     853                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
_0xD0:
	STS  _byIterationCounter,R30
;     854                 }
;     855             }
_0xB0:
;     856             break;
;     857     }
_0xA1:
;     858     if( btKeyUpdate )
	SBIS 0x13,0
	RJMP _0xB1
;     859     {
;     860       btKeyUpdate = FALSE;
	CBI  0x13,0
;     861       ProcessKey();
	RCALL _ProcessKey
;     862     }
;     863 }
_0xB1:
	RET
;     864 
;     865 /**************************************************************************\
;     866     Обработка нажатой клавиши.
;     867       Вход:  -
;     868       Выход: -
;     869 \**************************************************************************/
;     870 void ProcessKey(void)
;     871 {
_ProcessKey:
;     872     switch (byKeyCode)
	LDS  R30,_byKeyCode
;     873     {
;     874         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0xB7
;     875             switch (View)
	MOV  R30,R2
;     876             {
;     877 //               case 0:               //если был режим "Текущая температура", то
;     878 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     879 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;     880 //               break;
;     881               case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xBB
;     882                 if (T_LoadOn > TLoadOn_Min) //если "Установленная температура" > Min, то
	LDI  R30,LOW(64986)
	LDI  R31,HIGH(64986)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xBC
;     883                 {
;     884                   T_LoadOn --;      //уменьшаем значение на 0,1°
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
;     885 //                  RefreshDisplay(); //обновляем данные на экране
;     886                 }
;     887 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
;     888 //                Counter = 5;        //и взводим счётчик на 5 секунд.
;     889               break;
_0xBC:
	RJMP _0xBA
;     890               case 2:               //если мы в режиме "Дэльта", то
_0xBB:
	CPI  R30,LOW(0x2)
	BRNE _0xBA
;     891                 if (DeltaT > DeltaT_Min)     //если "Дэльта" больше Min, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0xBE
;     892                 {
;     893                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
;     894 //                  RefreshDisplay(); //обновляем данные на экране
;     895                 }
;     896 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     897               break;
_0xBE:
;     898               #ifdef CorCode
;     899               case 3:                   //если мы в режиме "Коррекции", то
;     900                 if (CorT > CorT_Min)
;     901                 {
;     902                     CorT--;         //уменьшаем значение на 0,1°
;     903                 }
;     904                 break;
;     905               #endif
;     906             }
_0xBA:
;     907         break;
	RJMP _0xB6
;     908 
;     909         case KEY_2:                 // Была нажата клавиша Плюс
_0xB7:
	CPI  R30,LOW(0x2)
	BRNE _0xBF
;     910             switch (View)
	MOV  R30,R2
;     911             {
;     912 //               case 0:               //если был режим "Текущая температура", то
;     913 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     914 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
;     915 //               break;
;     916               case 1:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0xC3
;     917                 if (T_LoadOn < (TLoadOn_Max - DeltaT))    //если температура ниже Max - Дельта
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	SUB  R30,R8
	SBC  R31,R9
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xC4
;     918                 {
;     919                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
;     920 //                  RefreshDisplay(); //обновляем данные на экране
;     921                 }
;     922 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
;     923 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     924               break;
_0xC4:
	RJMP _0xC2
;     925               case 2:
_0xC3:
	CPI  R30,LOW(0x2)
	BRNE _0xC2
;     926                 if (DeltaT < DeltaT_Max)   //если Дельта меньше Max, то
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0xC6
;     927                 {
;     928                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;     929 //                  RefreshDisplay(); //обновляем данные на экране
;     930                 }
;     931 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     932               break;
_0xC6:
;     933               #ifdef CorCode
;     934               case 3:                   //если мы в режиме "Коррекции", то
;     935                 if (CorT < CorT_Max)
;     936                 {
;     937                     CorT++;
;     938                 }
;     939               break;
;     940               #endif
;     941             }
_0xC2:
;     942         break;
	RJMP _0xB6
;     943 
;     944         case KEY_3:               // Была нажаты обе кноки вместе.
_0xBF:
	CPI  R30,LOW(0x3)
	BRNE _0xC9
;     945           View++;
	INC  R2
;     946           if (View > View_Max)
	LDI  R30,LOW(3)
	CP   R30,R2
	BRSH _0xC8
;     947           {
;     948             View = SHOW_TLoadOn;
	LDI  R30,LOW(1)
	MOV  R2,R30
;     949           }
;     950 //             switch (View)
;     951 //             {
;     952 //               case 0:               //если был режим "Текущая температура", то
;     953 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     954 //               break;
;     955 //               case 1:               //если мы в режиме "Установленная температура", то
;     956 //                 View = SHOW_DeltaT;           //удерживаем в режиме "Дэльта"
;     957 //               break;
;     958 //               case 2:
;     959 //                 View = SHOW_Error;           //переходим в режим "Последняя обнаруженная ошибка"
;     960 //               break;
;     961 //               case 3:
;     962 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
;     963 //               break;
;     964 //             }
;     965 //             Counter = 5;        //и взводим счётчик на 5 секунд.
;     966 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     967 //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     968 //            Counter = 5;        //и взводим счётчик ещё на 5 секунд.
;     969         break;
_0xC8:
;     970 
;     971         default:
_0xC9:
;     972         break;
;     973 
;     974     }
_0xB6:
;     975     Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R3,R30
;     976     #ifdef Blinking
;     977     GoBlinking = 0;
	CBI  0x14,0
;     978     #endif
;     979     RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
;     980 
;     981 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
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
