
;CodeVisionAVR C Compiler V3.12 Evaluation
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Counter=R5
	.DEF _View=R4
	.DEF _Tnew=R6
	.DEF _Tnew_msb=R7
	.DEF _T_LoadOn=R8
	.DEF _T_LoadOn_msb=R9
	.DEF _DeltaT=R10
	.DEF _DeltaT_msb=R11
	.DEF _ErrorLevel=R13
	.DEF _ErrorCounter=R12

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0082

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0xB,0xB,0xB,0xB
_0x4:
	.DB  0xFA,0x82,0xD9,0xCB,0xA3,0x6B,0x7B,0xC2
	.DB  0xFB,0xEB,0x0,0x1,0x9B,0x78,0x79
_0x20003:
	.DB  0x28

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
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

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

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
;Chip type           : AMega8
;Clock frequency     : 8,000000 MHz
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <kbd.h>
;#include "termostat_led.h" // поддержка нескольких вариантов печатной платы
;#include <ds1820.h>
;// 1 Wire Bus interface functions
;#include <1wire.h>
;
;#define ONE_WIRE_PORTNAME PORTC
;#define ONE_WIRE_PORTNUM 4
;// 1 Wire Bus functions
;#asm
   .equ __w1_port=0x15 ;PORTC
   .equ __w1_bit=4
; 0000 0021 #endasm
;
;
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
; 0000 003B #ifdef ShowWelcomeScreen
; 0000 003C ={11,11,11,11}

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
; 0000 009E {

	.CSEG
_PrepareData:
; .FSTART _PrepareData
; 0000 009F     BYTE i;
; 0000 00A0     int D;
; 0000 00A1     if (Initializing)
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR4
;	Data -> Y+4
;	i -> R17
;	D -> R18,R19
	SBRC R2,4
; 0000 00A2     {
; 0000 00A3       return;
	RJMP _0x2020001
; 0000 00A4     }
; 0000 00A5     if (Data < 0)
	LDD  R26,Y+5
	TST  R26
	BRPL _0x6
; 0000 00A6     {
; 0000 00A7       D = -Data;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __ANEGW1
	MOVW R18,R30
; 0000 00A8     }
; 0000 00A9     else
	RJMP _0x7
_0x6:
; 0000 00AA     {
; 0000 00AB       D = Data;
	__GETWRS 18,19,4
; 0000 00AC     }
_0x7:
; 0000 00AD 
; 0000 00AE     //Преобразуем в десятичное представление
; 0000 00AF     for(i=0; i<4; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,4
	BRSH _0xA
; 0000 00B0     {
; 0000 00B1        byDisplay[3-i] = D % 10;
	LDI  R30,LOW(3)
	SUB  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_byDisplay)
	SBCI R31,HIGH(-_byDisplay)
	MOVW R22,R30
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOVW R26,R22
	ST   X,R30
; 0000 00B2        D /= 10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOVW R18,R30
; 0000 00B3     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 00B4 
; 0000 00B5     if (byDisplay[0] == 0)
	LDS  R30,_byDisplay
	CPI  R30,0
	BRNE _0xB
; 0000 00B6     {
; 0000 00B7       byDisplay[0] = 10;
	LDI  R30,LOW(10)
	STS  _byDisplay,R30
; 0000 00B8       if (byDisplay[1] == 0)
	__GETB1MN _byDisplay,1
	CPI  R30,0
	BRNE _0xC
; 0000 00B9       {
; 0000 00BA         byDisplay[1] = 10;
	LDI  R30,LOW(10)
	__PUTB1MN _byDisplay,1
; 0000 00BB       }
; 0000 00BC     }
_0xC:
; 0000 00BD     if (Data < 0)
_0xB:
	LDD  R26,Y+5
	TST  R26
	BRPL _0xD
; 0000 00BE     {
; 0000 00BF       byDisplay[0] = 11;
	LDI  R30,LOW(11)
	STS  _byDisplay,R30
; 0000 00C0     }
; 0000 00C1     switch (View)
_0xD:
	MOV  R30,R4
; 0000 00C2     {
; 0000 00C3         case SHOW_DeltaT:
	CPI  R30,LOW(0x2)
	BRNE _0x11
; 0000 00C4           byDisplay[0] = 12;
	LDI  R30,LOW(12)
	RJMP _0x6E
; 0000 00C5           break;
; 0000 00C6         #ifdef CorCode
; 0000 00C7         case SHOW_CorT:
; 0000 00C8           byDisplay[0] = 13;
; 0000 00C9           if (Data < 0)
; 0000 00CA           {
; 0000 00CB             byDisplay[1] = 11;
; 0000 00CC           }
; 0000 00CD           break;
; 0000 00CE         #endif
; 0000 00CF         #ifdef ShowDataErrors
; 0000 00D0         case SHOW_Error:
_0x11:
	CPI  R30,LOW(0x3)
	BREQ _0x6F
; 0000 00D1           byDisplay[0] = 14;
; 0000 00D2           break;
; 0000 00D3         case SHOW_Normal:
	CPI  R30,0
	BRNE _0x10
; 0000 00D4           if (ErrorCounter == 0)
	TST  R12
	BRNE _0x14
; 0000 00D5           {
; 0000 00D6             byDisplay[0] = 14;
_0x6F:
	LDI  R30,LOW(14)
_0x6E:
	STS  _byDisplay,R30
; 0000 00D7           }
; 0000 00D8           break;
_0x14:
; 0000 00D9         #endif
; 0000 00DA     }
_0x10:
; 0000 00DB 
; 0000 00DC }
_0x2020001:
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
; 0000 00E4 {
_RefreshDisplay:
; .FSTART _RefreshDisplay
; 0000 00E5   int Data;
; 0000 00E6   switch (View)
	RCALL __SAVELOCR2
;	Data -> R16,R17
	MOV  R30,R4
; 0000 00E7   {
; 0000 00E8     case SHOW_Normal:
	CPI  R30,0
	BRNE _0x18
; 0000 00E9       #ifdef ShowDataErrors
; 0000 00EA       if (ErrorCounter == 0)
	TST  R12
	BRNE _0x19
; 0000 00EB       {
; 0000 00EC         Data = ErrorLevel;
	MOV  R16,R13
	CLR  R17
; 0000 00ED       }
; 0000 00EE       else
	RJMP _0x1A
_0x19:
; 0000 00EF       #endif
; 0000 00F0       {
; 0000 00F1         Data = Tnew;
	MOVW R16,R6
; 0000 00F2       }
_0x1A:
; 0000 00F3       if (T_LoadOn != eeT_LoadOn)
	RCALL SUBOPT_0x0
	RCALL __EEPROMRDW
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x1B
; 0000 00F4         eeT_LoadOn = T_LoadOn;
	MOVW R30,R8
	RCALL SUBOPT_0x0
	RCALL __EEPROMWRW
; 0000 00F5       if (DeltaT != eeDeltaT)
_0x1B:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x1C
; 0000 00F6         eeDeltaT = DeltaT;
	MOVW R30,R10
	RCALL SUBOPT_0x1
	RCALL __EEPROMWRW
; 0000 00F7       #ifdef CorCode
; 0000 00F8       if (CorT != eeCorT)
; 0000 00F9         eeCorT = CorT;
; 0000 00FA       #endif
; 0000 00FB     break;
_0x1C:
	RJMP _0x17
; 0000 00FC     case SHOW_TLoadOn:
_0x18:
	CPI  R30,LOW(0x1)
	BRNE _0x1D
; 0000 00FD       Data = T_LoadOn;
	MOVW R16,R8
; 0000 00FE     break;
	RJMP _0x17
; 0000 00FF 
; 0000 0100     case SHOW_DeltaT:
_0x1D:
	CPI  R30,LOW(0x2)
	BRNE _0x1E
; 0000 0101       Data = DeltaT;
	MOVW R16,R10
; 0000 0102     break;
	RJMP _0x17
; 0000 0103 #ifdef CorCode
; 0000 0104     case SHOW_CorT:
; 0000 0105         Data = CorT;
; 0000 0106     break;
; 0000 0107 #endif
; 0000 0108 #ifdef ShowDataErrors
; 0000 0109     case SHOW_Error:
_0x1E:
	CPI  R30,LOW(0x3)
	BRNE _0x17
; 0000 010A         Data = ErrorLevel;
	MOV  R16,R13
	CLR  R17
; 0000 010B     break;
; 0000 010C #endif
; 0000 010D   }
_0x17:
; 0000 010E 
; 0000 010F   PrepareData(Data);
	MOVW R26,R16
	RCALL _PrepareData
; 0000 0110 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0114 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x2
; 0000 0115 // Reinitialize Timer 0 value
; 0000 0116 TCNT0=0xB5;
	LDI  R30,LOW(181)
	OUT  0x32,R30
; 0000 0117 // if (BlinkCounter < 2 * BlinkHalfPeriod)
; 0000 0118 // {
; 0000 0119 #ifdef Blinking
; 0000 011A   BlinkCounter++;
	LDS  R30,_BlinkCounter
	SUBI R30,-LOW(1)
	STS  _BlinkCounter,R30
; 0000 011B   BlinkCounter &= BlinkCounterMask;
	ANDI R30,LOW(0x3F)
	STS  _BlinkCounter,R30
; 0000 011C #endif
; 0000 011D //}
; 0000 011E // else
; 0000 011F // {
; 0000 0120 //   BlinkCounter = 0;
; 0000 0121 // }
; 0000 0122 
; 0000 0123 ScanKbd();
	RCALL _ScanKbd
; 0000 0124 }
	RJMP _0x71
; .FEND
;
;void ShowDisplayData11Times(void)
; 0000 0127 {
_ShowDisplayData11Times:
; .FSTART _ShowDisplayData11Times
; 0000 0128   BYTE i;
; 0000 0129   #ifdef EliminateFlicker
; 0000 012A   if (!skipDelay)
	ST   -Y,R17
;	i -> R17
	SBRC R2,1
	RJMP _0x20
; 0000 012B   {
; 0000 012C     delay_us(LED_delay_add);
	__DELAY_USW 1600
; 0000 012D   }
; 0000 012E   #endif
; 0000 012F 
; 0000 0130   for (i=0; i<4; i++)    //шоб не моргало изображение делаем обновление эрана 10 раз
_0x20:
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x23
; 0000 0131   {
; 0000 0132 //    ShowDisplayData();
; 0000 0133  #ifdef Cathode
; 0000 0134   #ifdef Blinking
; 0000 0135   //BYTE
; 0000 0136   DigitsActive = 0;
	CLT
	BLD  R3,1
; 0000 0137   DimmerCounter++;
	LDS  R30,_DimmerCounter
	SUBI R30,-LOW(1)
	STS  _DimmerCounter,R30
; 0000 0138 //  if (BlinkCounter > BlinkHalfPeriod)
; 0000 0139   if (BlinkCounter & BlinkCounterHalfMask)
	LDS  R30,_BlinkCounter
	ANDI R30,LOW(0x20)
	BREQ _0x24
; 0000 013A   if (View == SHOW_Normal)
	TST  R4
	BRNE _0x25
; 0000 013B   #ifdef Blinking
; 0000 013C   if (GoBlinking)
	SBRS R3,0
	RJMP _0x26
; 0000 013D   #endif
; 0000 013E   if (DimmerCounter % DimmerDivider == 0)
	LDS  R26,_DimmerCounter
	LDI  R30,LOW(0)
	CPI  R30,0
	BRNE _0x27
; 0000 013F   {
; 0000 0140     DigitsActive = 1;
	SET
	BLD  R3,1
; 0000 0141   }
; 0000 0142   #endif
; 0000 0143 
; 0000 0144   DISPLAY_PORT = byCharacter[byDisplay[0]];
_0x27:
_0x26:
_0x25:
_0x24:
	LDS  R30,_byDisplay
	RCALL SUBOPT_0x3
; 0000 0145 //   if (Minus)
; 0000 0146 //   {
; 0000 0147 //     PORTB = PINB | 0b00000001;
; 0000 0148 //   }
; 0000 0149   #ifdef heat
; 0000 014A   if (LoadOn)
; 0000 014B   {
; 0000 014C     DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
; 0000 014D   }
; 0000 014E   #endif
; 0000 014F 
; 0000 0150   #ifdef cold
; 0000 0151   if (!LoadOn)
	SBRC R2,3
	RJMP _0x28
; 0000 0152   {
; 0000 0153     DISPLAY_PORT = DISPLAY_PINS | DOT_PIN_MASK;
	IN   R30,0x10
	ORI  R30,4
	OUT  0x12,R30
; 0000 0154   }
; 0000 0155   #endif
; 0000 0156   if (View == SHOW_TLoadOn)
_0x28:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x29
; 0000 0157   {
; 0000 0158     DISPLAY_PORT = DISPLAY_PINS | UNDERSCORE_PIN_MASK;
	IN   R30,0x10
	ORI  R30,8
	OUT  0x12,R30
; 0000 0159   }
; 0000 015A   DIGIT1 = DigitsActive;
_0x29:
	SBRC R3,1
	RJMP _0x2A
	CBI  0x15,2
	RJMP _0x2B
_0x2A:
	SBI  0x15,2
_0x2B:
; 0000 015B   delay_us(LED_delay);
	RCALL SUBOPT_0x4
; 0000 015C   DIGIT1 = 1;
	SBI  0x15,2
; 0000 015D 
; 0000 015E   DISPLAY_PORT = byCharacter[byDisplay[1]];
	__GETB1MN _byDisplay,1
	RCALL SUBOPT_0x3
; 0000 015F   DIGIT2 = DigitsActive;
	SBRC R3,1
	RJMP _0x2E
	CBI  0x15,1
	RJMP _0x2F
_0x2E:
	SBI  0x15,1
_0x2F:
; 0000 0160   delay_us(LED_delay);
	RCALL SUBOPT_0x4
; 0000 0161   DIGIT2 = 1;
	SBI  0x15,1
; 0000 0162 
; 0000 0163   DISPLAY_PORT = byCharacter[byDisplay[2]] | DOT_PIN_MASK;
	__GETB1MN _byDisplay,2
	LDI  R31,0
	SUBI R30,LOW(-_byCharacter)
	SBCI R31,HIGH(-_byCharacter)
	LD   R30,Z
	ORI  R30,4
	OUT  0x12,R30
; 0000 0164   DIGIT3 = DigitsActive;
	SBRC R3,1
	RJMP _0x32
	CBI  0x15,0
	RJMP _0x33
_0x32:
	SBI  0x15,0
_0x33:
; 0000 0165   delay_us(LED_delay);
	RCALL SUBOPT_0x4
; 0000 0166   DIGIT3 = 1;
	SBI  0x15,0
; 0000 0167 
; 0000 0168   DISPLAY_PORT = byCharacter[byDisplay[3]];
	__GETB1MN _byDisplay,3
	RCALL SUBOPT_0x3
; 0000 0169   DIGIT4 = DigitsActive;
	SBRC R3,1
	RJMP _0x36
	CBI  0x15,3
	RJMP _0x37
_0x36:
	SBI  0x15,3
_0x37:
; 0000 016A   delay_us(LED_delay);
	RCALL SUBOPT_0x4
; 0000 016B   DIGIT4 = 1;
	SBI  0x15,3
; 0000 016C #endif
; 0000 016D 
; 0000 016E #ifdef Anode
; 0000 016F   #ifdef Blinking
; 0000 0170   //BYTE
; 0000 0171   DigitsActive = 1;
; 0000 0172   DimmerCounter++;
; 0000 0173 //  if (BlinkCounter > BlinkHalfPeriod)
; 0000 0174   if (BlinkCounter & BlinkCounterHalfMask)
; 0000 0175   if (View == SHOW_Normal)
; 0000 0176   #ifdef Blinking
; 0000 0177   if (GoBlinking)
; 0000 0178   #endif
; 0000 0179   if (DimmerCounter % DimmerDivider == 0)
; 0000 017A   {
; 0000 017B     DigitsActive = 0;
; 0000 017C   }
; 0000 017D   #endif
; 0000 017E   DISPLAY_PORT = ~byCharacter[byDisplay[0]];
; 0000 017F //   if (Minus)
; 0000 0180 //   {
; 0000 0181 //     PORTB = PINB & 0b11111110;
; 0000 0182 //   }
; 0000 0183   #ifdef heat
; 0000 0184   if (LoadOn)
; 0000 0185   {
; 0000 0186     DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
; 0000 0187   }
; 0000 0188   #endif
; 0000 0189 
; 0000 018A   #ifdef cold
; 0000 018B   if (!LoadOn)
; 0000 018C   {
; 0000 018D     DISPLAY_PORT = DISPLAY_PINS & DOT_PIN_MASK;
; 0000 018E   }
; 0000 018F   #endif
; 0000 0190   if (View == SHOW_TLoadOn)
; 0000 0191   {
; 0000 0192     DISPLAY_PORT = DISPLAY_PINS & UNDERSCORE_PIN_MASK;
; 0000 0193   }
; 0000 0194   DIGIT1 = DigitsActive;
; 0000 0195   delay_us(LED_delay);
; 0000 0196   DIGIT1 = 0;
; 0000 0197 
; 0000 0198   DISPLAY_PORT = ~byCharacter[byDisplay[1]];
; 0000 0199   DIGIT2 = DigitsActive;
; 0000 019A   delay_us(LED_delay);
; 0000 019B   DIGIT2 = 0;
; 0000 019C 
; 0000 019D   DISPLAY_PORT = ~byCharacter[byDisplay[2]] & DOT_PIN_MASK;
; 0000 019E   DIGIT3 = DigitsActive;
; 0000 019F   delay_us(LED_delay);
; 0000 01A0   DIGIT3 = 0;
; 0000 01A1 
; 0000 01A2   DISPLAY_PORT = ~byCharacter[byDisplay[3]];
; 0000 01A3   DIGIT4 = DigitsActive;
; 0000 01A4   delay_us(LED_delay);
; 0000 01A5   DIGIT4 = 0;
; 0000 01A6 #endif
; 0000 01A7 
; 0000 01A8   }
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 01A9 }
	LD   R17,Y+
	RET
; .FEND
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 01AD {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	RCALL SUBOPT_0x2
; 0000 01AE   BYTE i;
; 0000 01AF   int Temp;
; 0000 01B0   int *val;
; 0000 01B1 // Reinitialize Timer 1 value
; 0000 01B2 #ifdef PREVENT_SENSOR_SELF_HEATING
; 0000 01B3 if (Updating)           //если в этот раз читаем температуру, то
; 0000 01B4 {
; 0000 01B5 TCNT1=T1_OFFSET_LONG;
; 0000 01B6 }
; 0000 01B7 else
; 0000 01B8 {
; 0000 01B9 TCNT1=T1_OFFSET;
; 0000 01BA }
; 0000 01BB #else
; 0000 01BC TCNT1=T1_OFFSET;
	RCALL __SAVELOCR6
;	i -> R17
;	Temp -> R18,R19
;	*val -> R20,R21
	LDI  R30,LOW(34286)
	LDI  R31,HIGH(34286)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 01BD #endif
; 0000 01BE //TCNT1L=0xD1;
; 0000 01BF #ifdef EliminateFlicker
; 0000 01C0 skipDelay = 1;
	SET
	BLD  R2,1
; 0000 01C1 #endif
; 0000 01C2 w1_init();              //инициализация шины 1-wire
	RCALL _w1_init
; 0000 01C3 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01C4 
; 0000 01C5 w1_write(0xCC);         //выдаём в шину 1-wire код 0xCC, что значит "Skip ROM"
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 01C6 ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01C7 
; 0000 01C8 Updating = !Updating;   //это шоб читать температуру через раз
	LDI  R30,LOW(4)
	EOR  R2,R30
; 0000 01C9 if (Updating)           //если в этот раз читаем температуру, то
	SBRS R2,2
	RJMP _0x3A
; 0000 01CA {
; 0000 01CB   w1_write(0xBE);       //выдаём в шину 1-wire код 0xBE, что значит "Read Scratchpad"
	LDI  R26,LOW(190)
	RCALL _w1_write
; 0000 01CC   ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01CD 
; 0000 01CE #ifdef ShowDataErrors
; 0000 01CF   AllDataFF = 1;
	SET
	BLD  R2,5
; 0000 01D0   NonZero = 0;
	CLT
	BLD  R2,6
; 0000 01D1   for (i=0; i<W1_BUFFER_LEN; i++)
	LDI  R17,LOW(0)
_0x3C:
	CPI  R17,9
	BRSH _0x3D
; 0000 01D2   {
; 0000 01D3     w1buffer[i]=w1_read();
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	RCALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01D4     ShowDisplayData11Times();
	RCALL _ShowDisplayData11Times
; 0000 01D5     if (w1buffer[i] != 0xFF)
	RCALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BREQ _0x3E
; 0000 01D6     {
; 0000 01D7       AllDataFF = 0;
	CLT
	BLD  R2,5
; 0000 01D8     }
; 0000 01D9     if (w1buffer[i] != 0x00)
_0x3E:
	RCALL SUBOPT_0x5
	LD   R30,Z
	CPI  R30,0
	BREQ _0x3F
; 0000 01DA     {
; 0000 01DB       NonZero = 1;
	SET
	BLD  R2,6
; 0000 01DC     }
; 0000 01DD   }
_0x3F:
	SUBI R17,-1
	RJMP _0x3C
_0x3D:
; 0000 01DE #else
; 0000 01DF   for (i=0; i<W1_BUFFER_LEN; i++)
; 0000 01E0   {
; 0000 01E1     w1buffer[i]=w1_read();
; 0000 01E2   }
; 0000 01E3 #endif
; 0000 01E4   Initializing = 0;//хватит показывать заставку
	CLT
	BLD  R2,4
; 0000 01E5 #ifdef ShowDataErrors
; 0000 01E6   i=w1_dow_crc8(w1buffer,8);
	LDI  R30,LOW(_w1buffer)
	LDI  R31,HIGH(_w1buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _w1_dow_crc8
	MOV  R17,R30
; 0000 01E7   if (ErrorCounter == 0) if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	TST  R12
	BRNE _0x40
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x41
	__GETB2MN _w1buffer,1
	CPI  R26,LOW(0x5)
	BRNE _0x42
; 0000 01E8   {
; 0000 01E9     //Имитируем ошибку передачи, т.к. если после нескольких ошибок пришло значение 85
; 0000 01EA     //то это просто некорректно закончилось измерение температуры
; 0000 01EB     i--;
	SUBI R17,1
; 0000 01EC   }
; 0000 01ED   if (NonZero == 0)
_0x42:
_0x41:
_0x40:
	SBRS R2,6
; 0000 01EE   {
; 0000 01EF     //Имитируем ошибку передачи, т.к. датчик не может прислать все нули
; 0000 01F0     i--;
	SUBI R17,1
; 0000 01F1   }
; 0000 01F2   if (i != w1buffer[8])
	__GETB1MN _w1buffer,8
	CP   R30,R17
	BREQ _0x44
; 0000 01F3   {
; 0000 01F4       //ошибка при передаче
; 0000 01F5       ErrorLevel = 1;//это просто сбой
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 01F6       if (AllDataFF)
	SBRS R2,5
	RJMP _0x45
; 0000 01F7       {
; 0000 01F8       //это обрыв
; 0000 01F9         ErrorLevel = 2;
	LDI  R30,LOW(2)
	RJMP _0x70
; 0000 01FA       }
; 0000 01FB       else
_0x45:
; 0000 01FC       {
; 0000 01FD         if (w1buffer[0] == 0x50) if (w1buffer[1] == 0x05)
	LDS  R26,_w1buffer
	CPI  R26,LOW(0x50)
	BRNE _0x47
	__GETB2MN _w1buffer,1
	CPI  R26,LOW(0x5)
	BRNE _0x48
; 0000 01FE         {
; 0000 01FF           ErrorLevel = 3;
	LDI  R30,LOW(3)
	MOV  R13,R30
; 0000 0200         }
; 0000 0201         if (NonZero == 0)
_0x48:
_0x47:
	SBRC R2,6
	RJMP _0x49
; 0000 0202         {
; 0000 0203           ErrorLevel = 4;
	LDI  R30,LOW(4)
_0x70:
	MOV  R13,R30
; 0000 0204         }
; 0000 0205       }
_0x49:
; 0000 0206       if (ErrorCounter > 0)
	LDI  R30,LOW(0)
	CP   R30,R12
	BRSH _0x4A
; 0000 0207       {
; 0000 0208         ErrorCounter--;
	DEC  R12
; 0000 0209       }
; 0000 020A       if (ErrorCounter == 0)
_0x4A:
	TST  R12
	BRNE _0x4B
; 0000 020B       {
; 0000 020C         #ifdef Blinking
; 0000 020D         GoBlinking = 1;
	SET
	BLD  R3,0
; 0000 020E         #endif
; 0000 020F       }
; 0000 0210   }
_0x4B:
; 0000 0211   else
	RJMP _0x4C
_0x44:
; 0000 0212   {
; 0000 0213   #endif
; 0000 0214   val = (int*)&w1buffer[0];
	__POINTWRM 20,21,_w1buffer
; 0000 0215   Tnew =
; 0000 0216   (*val) * 10 / 16
; 0000 0217   #ifdef CorCode
; 0000 0218   + CorT
; 0000 0219   #endif
; 0000 021A   #ifdef CorT_Static
; 0000 021B   + CorT_Static
; 0000 021C   #endif
; 0000 021D   ;
	MOVW R26,R20
	RCALL __GETW1P
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL __DIVW21
	MOVW R6,R30
; 0000 021E   RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 021F   #ifdef ShowDataErrors
; 0000 0220   ErrorCounter = MaxDataErrors + 1;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 0221   #endif
; 0000 0222   #ifdef ShowDataErrors
; 0000 0223   }
_0x4C:
; 0000 0224   #endif
; 0000 0225 }
; 0000 0226 else
	RJMP _0x4D
_0x3A:
; 0000 0227 {
; 0000 0228   w1_write(0x44);          //выдаём в шину 1-wire код 0x44, что значит "Convert T"
	LDI  R26,LOW(68)
	RCALL _w1_write
; 0000 0229 }
_0x4D:
; 0000 022A 
; 0000 022B #ifdef ShowDataErrors
; 0000 022C if (ErrorCounter == 0)
	TST  R12
	BRNE _0x4E
; 0000 022D {
; 0000 022E   #ifdef OUTPIN_NC
; 0000 022F   OUTPIN_NC = 0;
; 0000 0230   #endif
; 0000 0231   OUTPIN_NO = 0;
	CBI  0x18,3
; 0000 0232   NeedResetLoad = 1;
	SET
	BLD  R2,7
; 0000 0233   LoadOn = ShowDotWhenError;
	BLD  R2,3
; 0000 0234 }
; 0000 0235 else
	RJMP _0x51
_0x4E:
; 0000 0236 #endif
; 0000 0237 if (!Initializing)
	SBRC R2,4
	RJMP _0x52
; 0000 0238 {
; 0000 0239 Temp = T_LoadOn + DeltaT;      //Temp - временная переменная.
	MOVW R30,R10
	ADD  R30,R8
	ADC  R31,R9
	MOVW R18,R30
; 0000 023A 
; 0000 023B if (Tnew >= Temp) if (LoadOn || NeedResetLoad) //Если температура выше (установленной + Дэльта) и нагрузка включена,
	__CPWRR 6,7,18,19
	BRLT _0x53
	SBRC R2,3
	RJMP _0x55
	SBRS R2,7
	RJMP _0x54
_0x55:
; 0000 023C {                              //то выключаем нагрузку
; 0000 023D   OUTPIN_NO = 0;
	CBI  0x18,3
; 0000 023E   #ifdef OUTPIN_NC
; 0000 023F   OUTPIN_NC = 1;
; 0000 0240   #endif
; 0000 0241   LoadOn = 0;
	CLT
	BLD  R2,3
; 0000 0242   NeedResetLoad = 0;
	BLD  R2,7
; 0000 0243 }
; 0000 0244 
; 0000 0245 Temp = T_LoadOn;                //Temp - временная переменная.
_0x54:
_0x53:
	MOVW R18,R8
; 0000 0246 
; 0000 0247 if (Tnew <= Temp) if (!LoadOn  || NeedResetLoad) //Если температура ниже (установленной) и нагрузка выключена,
	__CPWRR 18,19,6,7
	BRLT _0x59
	SBRS R2,3
	RJMP _0x5B
	SBRS R2,7
	RJMP _0x5A
_0x5B:
; 0000 0248 {                               //то включаем нагрузку
; 0000 0249   #ifdef OUTPIN_NC
; 0000 024A   OUTPIN_NC = 0;
; 0000 024B   #endif
; 0000 024C   OUTPIN_NO = 1;
	SBI  0x18,3
; 0000 024D   LoadOn = 1;
	SET
	BLD  R2,3
; 0000 024E   NeedResetLoad = 0;
	CLT
	BLD  R2,7
; 0000 024F }
; 0000 0250 }//if errorCounter
_0x5A:
_0x59:
; 0000 0251 
; 0000 0252 if (Counter > 0)                //Counter - переменная для подсчёта времени отображения различных режимов
_0x52:
_0x51:
	LDI  R30,LOW(0)
	CP   R30,R5
	BRSH _0x5F
; 0000 0253 {
; 0000 0254   Counter --;                   //если она больше "0", то значит кто-то переключил режим отображения и
	DEC  R5
; 0000 0255 }                               //присвоил ей значение отличное от "0". Значит надо екрементировать,
; 0000 0256 else                            //пока не станет равной "0".
	RJMP _0x60
_0x5F:
; 0000 0257 {
; 0000 0258   View = SHOW_Normal;                     //если она =0, то сбрасываем текущий режим на "0"
	CLR  R4
; 0000 0259 }
_0x60:
; 0000 025A RefreshDisplay();               //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 025B #ifdef EliminateFlicker
; 0000 025C skipDelay = 0;
	CLT
	BLD  R2,1
; 0000 025D #endif
; 0000 025E }
	RCALL __LOADLOCR6
	ADIW R28,6
_0x71:
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
; 0000 0263 {
_main:
; .FSTART _main
; 0000 0264 // Declare your local variables here
; 0000 0265 
; 0000 0266 #ifdef ORIG_PORT_MAP
; 0000 0267         PORTC=0b00000011;
; 0000 0268         DDRC= 0b00000000; // весь порт работает на вход (клавиши управления)
; 0000 0269 
; 0000 026A         PORTB=0b00000000;
; 0000 026B         DDRB= 0b11111111; // весь порт работает на выход, управляет сегментами индикатора
; 0000 026C 
; 0000 026D 
; 0000 026E         #ifdef Cathode
; 0000 026F           PORTD=0b01110111; // все разряды индикатора (PORTD.4,.0,.1,.5) поднять, 1wire - поднять, нагрузку - включить ( ...
; 0000 0270           DDRD= 0b00111111; // все регистры кроме 6 (1wire) и 7 работают на выход
; 0000 0271         #endif
; 0000 0272 
; 0000 0273         #ifdef Anode
; 0000 0274           PORTD=0b01000100; // все разряды индикатора (PORTD.4,.0,.1,.5) опустить, 1wire - поднять, нагрузку - включить  ...
; 0000 0275           DDRD= 0b00111111;
; 0000 0276         #endif
; 0000 0277 #endif
; 0000 0278 #ifdef DIP_COMPACT_PORT_MAP
; 0000 0279         PORTC=0b00001100; // нагрузку-выключить
; 0000 027A         DDRC= 0b00000010; // весь порт кроме PORTC.1 (нагрузка) работает на вход (клавиши управления)
; 0000 027B 
; 0000 027C         PORTB=0b00000000;
; 0000 027D         DDRB= 0b11111111; // весь порт работает на выход, управляет сегментами индикатора
; 0000 027E 
; 0000 027F         #ifdef Cathode
; 0000 0280           PORTD=0b11110000; // разряды индикатора (PORTD.7,.6,.5,.4) поднять, клавиши (PORTD.2 и .3) - поднять
; 0000 0281           DDRD= 0b11110000; // все регистры кроме 2 и 3 (две клавиши) работают на выход
; 0000 0282           //PORTA=0b00000011; // разряд индикатора 4 (PORTA.0) поднять, 1wire (PORTA.1) - поднять
; 0000 0283         #endif
; 0000 0284         #ifdef Anode
; 0000 0285           PORTD=0b00000000; // разряды индикатора (PORTD.7,.6,.5,.4) опустить, клавиши (PORTD.2 и .3) - поднять
; 0000 0286           DDRD= 0b11110000; // все регистры кроме 2 и 3 (две клавиши) работают на выход
; 0000 0287           //PORTA=0b00000010; // разряд индикатора 4 (PORTA.0) опустить, 1wire (PORTA.1) - поднять
; 0000 0288         #endif
; 0000 0289         //DDRA= 0b00000001; // PORTA.0 используется для управления индикатором, PORTA.1 - для 1wire
; 0000 028A #endif
; 0000 028B #ifdef TQFP_PORT_MAP
; 0000 028C         PORTB=0b00110000; // нагрузку-выключить
; 0000 028D         DDRB= 0b00111000; // весь порт кроме PORTC.1 (нагрузка) работает на вход (клавиши управления)
; 0000 028E 
; 0000 028F         PORTD=0b00000000;
; 0000 0290         DDRD= 0b11111111; // весь порт работает на выход, управляет сегментами индикатора
; 0000 0291 
; 0000 0292         #ifdef Cathode
; 0000 0293           PORTC=0b00001111; // разряды индикатора (PORTD.7,.6,.5,.4) поднять, клавиши (PORTD.2 и .3) - поднять
; 0000 0294           DDRC= 0b00001111; // все регистры кроме 2 и 3 (две клавиши) работают на выход
; 0000 0295           //PORTA=0b00000011; // разряд индикатора 4 (PORTA.0) поднять, 1wire (PORTA.1) - поднять
; 0000 0296         #endif
; 0000 0297         #ifdef Anode
; 0000 0298           PORTC=0b00000000; // разряды индикатора (PORTD.7,.6,.5,.4) опустить, клавиши (PORTD.2 и .3) - поднять
; 0000 0299           DDRC= 0b00001111; // все регистры кроме 2 и 3 (две клавиши) работают на выход
; 0000 029A           //PORTA=0b00000010; // разряд индикатора 4 (PORTA.0) опустить, 1wire (PORTA.1) - поднять
; 0000 029B         #endif
; 0000 029C         //DDRA= 0b00000001; // PORTA.0 используется для управления индикатором, PORTA.1 - для 1wire
; 0000 029D #endif
; 0000 029E 
; 0000 029F #ifdef OUTPIN_NC
; 0000 02A0 OUTPIN_NC = 1;
; 0000 02A1 #endif
; 0000 02A2 OUTPIN_NO = 0;
	CBI  0x18,3
; 0000 02A3 
; 0000 02A4 // Timer/Counter 0 initialization
; 0000 02A5 // Clock source: System Clock
; 0000 02A6 // Clock value: 8000,000 kHz
; 0000 02A7 // Mode: Normal top=FFh
; 0000 02A8 // OC0A output: Disconnected
; 0000 02A9 // OC0B output: Disconnected
; 0000 02AA TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 02AB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02AC // OCR0A=0x00;
; 0000 02AD // OCR0B=0x00;
; 0000 02AE 
; 0000 02AF // Timer/Counter 1 initialization
; 0000 02B0 // Clock source: System Clock
; 0000 02B1 // Clock value: 7,813 kHz
; 0000 02B2 // Mode: Normal top=FFFFh
; 0000 02B3 // OC1A output: Discon.
; 0000 02B4 // OC1B output: Discon.
; 0000 02B5 // Noise Canceler: Off
; 0000 02B6 // Input Capture on Falling Edge
; 0000 02B7 // Timer 1 Overflow Interrupt: On
; 0000 02B8 // Input Capture Interrupt: Off
; 0000 02B9 // Compare A Match Interrupt: Off
; 0000 02BA // Compare B Match Interrupt: Off
; 0000 02BB TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02BC TCCR1B=T1_PRESCALER;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 02BD TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 02BE TCNT1L=0xFE;
	LDI  R30,LOW(254)
	OUT  0x2C,R30
; 0000 02BF // ICR1H=0x00;
; 0000 02C0 // ICR1L=0x00;
; 0000 02C1 // OCR1AH=0x00;
; 0000 02C2 // OCR1AL=0x00;
; 0000 02C3 // OCR1BH=0x00;
; 0000 02C4 // OCR1BL=0x00;
; 0000 02C5 
; 0000 02C6 // Timer/Counter 2 initialization
; 0000 02C7 // Clock source: System Clock
; 0000 02C8 // Clock value: Timer2 Stopped
; 0000 02C9 // Mode: Normal top=0xFF
; 0000 02CA // OC2 output: Disconnected
; 0000 02CB ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 02CC TCCR2=0x00;
	OUT  0x25,R30
; 0000 02CD TCNT2=0x00;
	OUT  0x24,R30
; 0000 02CE OCR2=0x00;
	OUT  0x23,R30
; 0000 02CF 
; 0000 02D0 // External Interrupt(s) initialization
; 0000 02D1 // INT0: Off
; 0000 02D2 // INT1: Off
; 0000 02D3 // Interrupt on any change on pins PCINT0-7: Off
; 0000 02D4 MCUCR=0x00;
	OUT  0x35,R30
; 0000 02D5 
; 0000 02D6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02D7 TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 02D8 
; 0000 02D9 // USART initialization
; 0000 02DA // USART disabled
; 0000 02DB UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 02DC 
; 0000 02DD // Analog Comparator initialization
; 0000 02DE // Analog Comparator: Off
; 0000 02DF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02E0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02E1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02E2 
; 0000 02E3 // ADC initialization
; 0000 02E4 // ADC disabled
; 0000 02E5 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 02E6 
; 0000 02E7 // SPI initialization
; 0000 02E8 // SPI disabled
; 0000 02E9 SPCR=0x00;
	OUT  0xD,R30
; 0000 02EA 
; 0000 02EB // TWI initialization
; 0000 02EC // TWI disabled
; 0000 02ED TWCR=0x00;
	OUT  0x36,R30
; 0000 02EE 
; 0000 02EF #ifdef Blinking
; 0000 02F0 DimmerCounter = 0;
	STS  _DimmerCounter,R30
; 0000 02F1 #endif
; 0000 02F2 //Tnew = 0;                //Просто обнуляем, тыща больше не нужна
; 0000 02F3 
; 0000 02F4 if (!(eeDeltaT + 1))//проверка на FFFF - значение после стирания EEPROM
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	ADIW R30,1
	BRNE _0x63
; 0000 02F5 {
; 0000 02F6   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	RCALL SUBOPT_0x6
; 0000 02F7   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x7
; 0000 02F8   #ifdef CorCode
; 0000 02F9   eeCorT = CorT_Default;
; 0000 02FA   #endif
; 0000 02FB }
; 0000 02FC 
; 0000 02FD if ((eeT_LoadOn > TLoadOn_Max) || (eeT_LoadOn < TLoadOn_Min)) //если в EEPROM значение > Max или < Min значит он не прош ...
_0x63:
	RCALL SUBOPT_0x0
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x4E3)
	LDI  R26,HIGH(0x4E3)
	CPC  R31,R26
	BRGE _0x65
	CPI  R30,LOW(0xFDDA)
	LDI  R26,HIGH(0xFDDA)
	CPC  R31,R26
	BRGE _0x64
_0x65:
; 0000 02FE   eeT_LoadOn = TLoadOn_Default;                             //чё-то глюкануло, поэтому запишем туда начальные значения.
	RCALL SUBOPT_0x6
; 0000 02FF if (eeDeltaT > DeltaT_Max || eeDeltaT < DeltaT_Min)
_0x64:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRGE _0x68
	SBIW R30,1
	BRGE _0x67
_0x68:
; 0000 0300   eeDeltaT = DeltaT_Default;
	RCALL SUBOPT_0x7
; 0000 0301 #ifdef CorCode
; 0000 0302 if ((eeCorT > CorT_Max) || (eeCorT < CorT_Min))    // если в EEPROM значение > MaxCorT°C или < MinCorT°C значит он не пр ...
; 0000 0303   eeCorT = CorT_Default;                        // или чё-то глюкануло, поэтому запишем туда начальные значения. // mod  ...
; 0000 0304 CorT = eeCorT;
; 0000 0305 #endif
; 0000 0306 
; 0000 0307 T_LoadOn = eeT_LoadOn;  //читаем значение Установленной температуры из EEPROM в RAM
_0x67:
	RCALL SUBOPT_0x0
	RCALL __EEPROMRDW
	MOVW R8,R30
; 0000 0308 DeltaT = eeDeltaT;      //читаем значение Дэльты из EEPROM в RAM
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	MOVW R10,R30
; 0000 0309 
; 0000 030A #ifdef ShowDataErrors
; 0000 030B ErrorLevel = 0;
	CLR  R13
; 0000 030C ErrorCounter = 1;       //При включении обязательно показываем даже первую ошибку
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 030D #endif
; 0000 030E #ifdef Blinking
; 0000 030F GoBlinking = 0;
	CLT
	BLD  R3,0
; 0000 0310 #endif
; 0000 0311 Initializing = 1;
	SET
	BLD  R2,4
; 0000 0312 LoadOn = ShowDotAtStartup;//Точка включения нагрузки не должна гореть при старте, но для cold и heat это разные значения
	BLD  R2,3
; 0000 0313 RefreshDisplay();       //Обновление данных на индикаторе.
	RCALL _RefreshDisplay
; 0000 0314 
; 0000 0315 Updating = 1; // Теперь первое обращение к датчику будет ConvertT
	SET
	BLD  R2,2
; 0000 0316 
; 0000 0317 KbdInit();              //инициализация клавиатуры
	CLT
	BLD  R2,0
	RCALL SUBOPT_0x8
; 0000 0318 
; 0000 0319 // Global enable interrupts
; 0000 031A #asm("sei")
	sei
; 0000 031B 
; 0000 031C while (1)
_0x6A:
; 0000 031D       {
; 0000 031E       // Place your code here
; 0000 031F       #asm("cli");               //запрещаем прерывания
	cli
; 0000 0320       ShowDisplayData11Times();         //обновляем экран
	RCALL _ShowDisplayData11Times
; 0000 0321       #asm("sei");               //разрешаем прерывания
	sei
; 0000 0322       };
	RJMP _0x6A
; 0000 0323 
; 0000 0324 }
_0x6D:
	RJMP _0x6D
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
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
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
;
;#define KeyCode     (((PINB >> 4) & 0b00000011) ^ 0b00000011)
;// Клавиши назначены на PORTB.4 и .5, поэтому достаточно сделать сдвиг на 4 бита
;// Получилось единообразно с исходным вариантом, но на сколько-то тактов дольше
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
; 0001 0045 {

	.CSEG
_ScanKbd:
; .FSTART _ScanKbd
; 0001 0046     switch (byScanState)
	LDS  R30,_byScanState
; 0001 0047     {
; 0001 0048         case ST_WAIT_KEY:
	CPI  R30,0
	BRNE _0x20007
; 0001 0049             // Если обнаружено нажатие на клавишу, то переходим к ее проверке.
; 0001 004A             if (KeyCode != 0)
	RCALL SUBOPT_0x9
	BREQ _0x20008
; 0001 004B             {
; 0001 004C                 byCheckedKey = KeyCode;
	RCALL SUBOPT_0x9
	STS  _byCheckedKey,R30
; 0001 004D 
; 0001 004E                 byCheckKeyCnt = PRESS_CNT;
	RCALL SUBOPT_0xA
; 0001 004F 
; 0001 0050                 byScanState = ST_CHECK_KEY;
	LDI  R30,LOW(1)
	STS  _byScanState,R30
; 0001 0051             }
; 0001 0052             break;
_0x20008:
	RJMP _0x20006
; 0001 0053 
; 0001 0054         case ST_CHECK_KEY:
_0x20007:
	CPI  R30,LOW(0x1)
	BRNE _0x20009
; 0001 0055             // Если клавиша удердивалась достаточно долго, то
; 0001 0056             // генерируем событие с кодом клавиши, и переходим к
; 0001 0057             // ожиданию отпускания клавиши
; 0001 0058             if (byCheckedKey == KeyCode)
	RCALL SUBOPT_0x9
	LDS  R26,_byCheckedKey
	CP   R30,R26
	BRNE _0x2000A
; 0001 0059             {
; 0001 005A                 byCheckKeyCnt--;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0001 005B                 if (!byCheckKeyCnt)
	BRNE _0x2000B
; 0001 005C                 {
; 0001 005D                     btKeyUpdate = TRUE;
	SET
	BLD  R2,0
; 0001 005E                     byKeyCode = byCheckedKey;
	LDS  R30,_byCheckedKey
	STS  _byKeyCode,R30
; 0001 005F                     byScanState = ST_RELEASE_WAIT;
	LDI  R30,LOW(2)
	STS  _byScanState,R30
; 0001 0060                     byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xA
; 0001 0061                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
	STS  _byIterationCounter,R30
; 0001 0062                 }
; 0001 0063             }
_0x2000B:
; 0001 0064             // Если данные неустойчитывы, то возвращается назад,
; 0001 0065             // к ожиданию нажатия клавиши
; 0001 0066             else
	RJMP _0x2000C
_0x2000A:
; 0001 0067                 byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x8
; 0001 0068             break;
_0x2000C:
	RJMP _0x20006
; 0001 0069 
; 0001 006A         case ST_RELEASE_WAIT:
_0x20009:
	CPI  R30,LOW(0x2)
	BRNE _0x20006
; 0001 006B             // Пока клавиша не будет отпущена на достаточный интервал
; 0001 006C             // времени, будем оставаться в этом состоянии
; 0001 006D             if (KeyCode != 0)
	RCALL SUBOPT_0x9
	BREQ _0x2000E
; 0001 006E             {
; 0001 006F                 byCheckKeyCnt = RELEASE_CNT;
	RCALL SUBOPT_0xA
; 0001 0070                 if (!byIterationCounter)
	LDS  R30,_byIterationCounter
	CPI  R30,0
	BRNE _0x2000F
; 0001 0071                 {
; 0001 0072                   byIterationCounter = PRESS_CNT * 2;
	LDI  R30,LOW(8)
	STS  _byIterationCounter,R30
; 0001 0073                   btKeyUpdate = TRUE;
	SET
	BLD  R2,0
; 0001 0074                 }
; 0001 0075                 byIterationCounter--;
_0x2000F:
	LDS  R30,_byIterationCounter
	SUBI R30,LOW(1)
	RJMP _0x20029
; 0001 0076             }
; 0001 0077             else
_0x2000E:
; 0001 0078             {
; 0001 0079                 byCheckKeyCnt--;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0001 007A                 if (!byCheckKeyCnt)
	BRNE _0x20011
; 0001 007B                 {
; 0001 007C                     byScanState = ST_WAIT_KEY;
	RCALL SUBOPT_0x8
; 0001 007D                     byIterationCounter = PRESS_CNT * 20;
	LDI  R30,LOW(80)
_0x20029:
	STS  _byIterationCounter,R30
; 0001 007E                 }
; 0001 007F             }
_0x20011:
; 0001 0080             break;
; 0001 0081     }
_0x20006:
; 0001 0082     if( btKeyUpdate )
	SBRS R2,0
	RJMP _0x20012
; 0001 0083     {
; 0001 0084       btKeyUpdate = FALSE;
	CLT
	BLD  R2,0
; 0001 0085       ProcessKey();
	RCALL _ProcessKey
; 0001 0086     }
; 0001 0087 }
_0x20012:
	RET
; .FEND
;
;/**************************************************************************\
;    Обработка нажатой клавиши.
;      Вход:  -
;      Выход: -
;\**************************************************************************/
;void ProcessKey(void)
; 0001 008F {
_ProcessKey:
; .FSTART _ProcessKey
; 0001 0090     switch (byKeyCode)
	LDS  R30,_byKeyCode
; 0001 0091     {
; 0001 0092         case KEY_1:                 // Была нажата клавиша Минус
	CPI  R30,LOW(0x1)
	BRNE _0x20016
; 0001 0093             switch (View)
	MOV  R30,R4
; 0001 0094             {
; 0001 0095 //               case 0:               //если был режим "Текущая температура", то
; 0001 0096 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 0097 //                 Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 0098 //               break;
; 0001 0099               case SHOW_TLoadOn:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0x2001A
; 0001 009A                 if (T_LoadOn > TLoadOn_Min) //если "Установленная температура" > Min, то
	LDI  R30,LOW(64986)
	LDI  R31,HIGH(64986)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x2001B
; 0001 009B                 {
; 0001 009C                   T_LoadOn --;      //уменьшаем значение на 0,1°
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0001 009D //                  RefreshDisplay(); //обновляем данные на экране
; 0001 009E                 }
; 0001 009F //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
; 0001 00A0 //                Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 00A1               break;
_0x2001B:
	RJMP _0x20019
; 0001 00A2               case 2:               //если мы в режиме "Дэльта", то
_0x2001A:
	CPI  R30,LOW(0x2)
	BRNE _0x20019
; 0001 00A3                 if (DeltaT > DeltaT_Min)     //если "Дэльта" больше Min, то
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2001D
; 0001 00A4                 {
; 0001 00A5                   DeltaT --;        //уменьшаем Дэльту на 0,1°
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0001 00A6 //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00A7                 }
; 0001 00A8 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00A9               break;
_0x2001D:
; 0001 00AA               #ifdef CorCode
; 0001 00AB               case 3:                   //если мы в режиме "Коррекции", то
; 0001 00AC                 if (CorT > CorT_Min)
; 0001 00AD                 {
; 0001 00AE                     CorT--;         //уменьшаем значение на 0,1°
; 0001 00AF                 }
; 0001 00B0                 break;
; 0001 00B1               #endif
; 0001 00B2             }
_0x20019:
; 0001 00B3         break;
	RJMP _0x20015
; 0001 00B4 
; 0001 00B5         case KEY_2:                 // Была нажата клавиша Плюс
_0x20016:
	CPI  R30,LOW(0x2)
	BRNE _0x2001E
; 0001 00B6             switch (View)
	MOV  R30,R4
; 0001 00B7             {
; 0001 00B8 //               case 0:               //если был режим "Текущая температура", то
; 0001 00B9 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00BA //                 Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 00BB //               break;
; 0001 00BC               case 1:               //если мы в режиме "Установленная температура", то
	CPI  R30,LOW(0x1)
	BRNE _0x20022
; 0001 00BD                 if (T_LoadOn < (TLoadOn_Max - DeltaT))    //если температура ниже Max - Дельта
	LDI  R30,LOW(1250)
	LDI  R31,HIGH(1250)
	SUB  R30,R10
	SBC  R31,R11
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x20023
; 0001 00BE                 {
; 0001 00BF                   T_LoadOn ++;      //то увеличиваем Установленную температуру на 0,1°
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	SBIW R30,1
; 0001 00C0 //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00C1                 }
; 0001 00C2 //                View = SHOW_TLoadOn;           //удерживаем в режиме "Установленная температура"
; 0001 00C3 //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00C4               break;
_0x20023:
	RJMP _0x20021
; 0001 00C5               case 2:
_0x20022:
	CPI  R30,LOW(0x2)
	BRNE _0x20021
; 0001 00C6                 if (DeltaT < DeltaT_Max)   //если Дельта меньше Max, то
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x20025
; 0001 00C7                 {
; 0001 00C8                   DeltaT ++;        //то увеличиваем Дэльту на 0,1°
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0001 00C9 //                  RefreshDisplay(); //обновляем данные на экране
; 0001 00CA                 }
; 0001 00CB //                Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00CC               break;
_0x20025:
; 0001 00CD               #ifdef CorCode
; 0001 00CE               case 3:                   //если мы в режиме "Коррекции", то
; 0001 00CF                 if (CorT < CorT_Max)
; 0001 00D0                 {
; 0001 00D1                     CorT++;
; 0001 00D2                 }
; 0001 00D3               break;
; 0001 00D4               #endif
; 0001 00D5             }
_0x20021:
; 0001 00D6         break;
	RJMP _0x20015
; 0001 00D7 
; 0001 00D8         case KEY_3:               // Была нажаты обе кноки вместе.
_0x2001E:
	CPI  R30,LOW(0x3)
	BRNE _0x20028
; 0001 00D9           View++;
	INC  R4
; 0001 00DA           if (View > View_Max)
	LDI  R30,LOW(3)
	CP   R30,R4
	BRSH _0x20027
; 0001 00DB           {
; 0001 00DC             View = SHOW_TLoadOn;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0001 00DD           }
; 0001 00DE //             switch (View)
; 0001 00DF //             {
; 0001 00E0 //               case 0:               //если был режим "Текущая температура", то
; 0001 00E1 //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00E2 //               break;
; 0001 00E3 //               case 1:               //если мы в режиме "Установленная температура", то
; 0001 00E4 //                 View = SHOW_DeltaT;           //удерживаем в режиме "Дэльта"
; 0001 00E5 //               break;
; 0001 00E6 //               case 2:
; 0001 00E7 //                 View = SHOW_Error;           //переходим в режим "Последняя обнаруженная ошибка"
; 0001 00E8 //               break;
; 0001 00E9 //               case 3:
; 0001 00EA //                 View = SHOW_TLoadOn;           //переходим в режим "Установленная температура"
; 0001 00EB //               break;
; 0001 00EC //             }
; 0001 00ED //             Counter = 5;        //и взводим счётчик на 5 секунд.
; 0001 00EE //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00EF //             Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00F0 //            Counter = 5;        //и взводим счётчик ещё на 5 секунд.
; 0001 00F1         break;
_0x20027:
; 0001 00F2 
; 0001 00F3         default:
_0x20028:
; 0001 00F4         break;
; 0001 00F5 
; 0001 00F6     }
_0x20015:
; 0001 00F7     Counter = 5;        //и взводим счётчик ещё на 5 секунд.
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0001 00F8     #ifdef Blinking
; 0001 00F9     GoBlinking = 0;
	CLT
	BLD  R3,0
; 0001 00FA     #endif
; 0001 00FB     RefreshDisplay(); //обновляем данные на экране
	RCALL _RefreshDisplay
; 0001 00FC 
; 0001 00FD }
	RET
; .FEND

	.CSEG

	.DSEG
_byScanState:
	.BYTE 0x1
___ds1820_scratch_pad:
	.BYTE 0x9
_byDisplay:
	.BYTE 0x4
_w1buffer:
	.BYTE 0x9
_BlinkCounter:
	.BYTE 0x1
_DimmerCounter:
	.BYTE 0x1

	.ESEG
_eeT_LoadOn:
	.DB  0xE6,0x0
_eeDeltaT:
	.DB  0x14,0x0

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
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_eeT_LoadOn)
	LDI  R27,HIGH(_eeT_LoadOn)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_eeDeltaT)
	LDI  R27,HIGH(_eeDeltaT)
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R31,0
	SUBI R30,LOW(-_byCharacter)
	SBCI R31,HIGH(-_byCharacter)
	LD   R30,Z
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	__DELAY_USW 1200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_w1buffer)
	SBCI R31,HIGH(-_w1buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x0
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _byScanState,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	IN   R30,0x16
	SWAP R30
	ANDI R30,LOW(0x3)
	LDI  R26,LOW(3)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(4)
	STS  _byCheckKeyCnt,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R30,_byCheckKeyCnt
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	SUBI R30,LOW(1)
	STS  _byCheckKeyCnt,R30
	RCALL SUBOPT_0xB
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
	ldd  r27,y+1
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
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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
	SBIW R26,1
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
	OUT  EEARH,R27
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
	OUT  EEARH,R27
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

;END OF CODE MARKER
__END_OF_CODE:
