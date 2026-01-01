
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _xy=R6
	.DEF _xy_msb=R7
	.DEF _k=R8
	.DEF _k_msb=R9
	.DEF _Temp_Pass_1=R10
	.DEF _Temp_Pass_1_msb=R11
	.DEF _Temp_Pass_2=R12
	.DEF _Temp_Pass_2_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x31,0x0,0x32,0x0,0x33,0x0,0x34,0x0
	.DB  0x35,0x0,0x36,0x0,0x37,0x0,0x38,0x0
	.DB  0x39,0x0,0x30,0x0,0x20,0x20,0x46,0x69
	.DB  0x6E,0x61,0x6C,0x20,0x50,0x72,0x6F,0x6A
	.DB  0x65,0x63,0x74,0x20,0x0,0x48,0x61,0x6D
	.DB  0x69,0x61,0x6E,0x20,0x47,0x68,0x61,0x7A
	.DB  0x69,0x70,0x6F,0x6F,0x72,0x0,0x48,0x61
	.DB  0x6D,0x69,0x61,0x6E,0x7C,0x47,0x68,0x61
	.DB  0x7A,0x69,0x70,0x6F,0x6F,0x72,0x0,0x20
	.DB  0x20,0x20,0x61,0x74,0x74,0x65,0x6E,0x74
	.DB  0x69,0x6F,0x6E,0x21,0x20,0x20,0x20,0x0
	.DB  0x4D,0x65,0x73,0x73,0x61,0x67,0x65,0x20
	.DB  0x72,0x65,0x63,0x65,0x69,0x76,0x65,0x64
	.DB  0x0,0x50,0x72,0x65,0x73,0x73,0x20,0x74
	.DB  0x68,0x65,0x20,0x6B,0x65,0x79,0x20,0x31
	.DB  0x0,0x42,0x75,0x74,0x74,0x6F,0x6E,0x20
	.DB  0x31,0x20,0x68,0x61,0x73,0x20,0x6E,0x6F
	.DB  0x74,0x0,0x62,0x65,0x65,0x6E,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x65,0x64,0x0,0x20
	.DB  0x20,0x57,0x61,0x69,0x74,0x69,0x6E,0x67
	.DB  0x20,0x66,0x6F,0x72,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x6D,0x65,0x73,0x73,0x61
	.DB  0x67,0x65,0x21,0x20,0x20,0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x11
	.DW  _0x53
	.DW  _0x0*2+20

	.DW  0x11
	.DW  _0x53+17
	.DW  _0x0*2+37

	.DW  0x11
	.DW  _0x53+34
	.DW  _0x0*2+20

	.DW  0x11
	.DW  _0x53+51
	.DW  _0x0*2+54

	.DW  0x11
	.DW  _0x5B
	.DW  _0x0*2+71

	.DW  0x11
	.DW  _0x5B+17
	.DW  _0x0*2+88

	.DW  0x10
	.DW  _0x5B+34
	.DW  _0x0*2+105

	.DW  0x11
	.DW  _0x5B+50
	.DW  _0x0*2+121

	.DW  0x0D
	.DW  _0x5B+67
	.DW  _0x0*2+138

	.DW  0x10
	.DW  _0x5B+80
	.DW  _0x0*2+151

	.DW  0x11
	.DW  _0x5B+96
	.DW  _0x0*2+167

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 8/22/2025
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <delay.h>
;// Declare your global variables here
;int i=0 , xy=0 , k=0;
;int Temp_Pass_1=0 , Temp_Pass_2=0 ,  Temp_Pass_3=0 ,  Temp_Pass_4=0 ;
;#define Buzzer_Pin            PORTC.7
;#define LED_Green_ON          PORTA.0=1
;#define LED_Green_OFF         PORTA.0=0
;#define LED_Red_ON            PORTA.1=1
;#define LED_Red_OFF           PORTA.1=0
;#define LED_Yellow_ON         PORTA.2=1
;#define LED_Yellow_OFF        PORTA.2=0
;#define LED_Blue_ON           PORTA.3=1
;#define LED_Blue_OFF          PORTA.3=0
;#define Relay_ON              PORTD.5=1
;#define Relay_OFF             PORTD.5=0
;
;int Check = 0 ;
;int Check_Pin_Last = 0 ;
;int key_pad(void)
; 0000 002F {

	.CSEG
_key_pad:
; .FSTART _key_pad
; 0000 0030 PORTC.3=1;PORTC.4=1;PORTC.5=1;PORTC.6=0;
	SBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	CBI  0x15,6
; 0000 0031 if(!PINC.0) return 3;
	SBIC 0x13,0
	RJMP _0xB
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 0032 if(!PINC.1) return 2;
_0xB:
	SBIC 0x13,1
	RJMP _0xC
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 0033 if(!PINC.2) return 1;
_0xC:
	SBIC 0x13,2
	RJMP _0xD
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0034 PORTC.3=1;PORTC.4=1;PORTC.5=0;PORTC.6=1;
_0xD:
	SBI  0x15,3
	SBI  0x15,4
	CBI  0x15,5
	SBI  0x15,6
; 0000 0035 if(!PINC.0) return 6;
	SBIC 0x13,0
	RJMP _0x16
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RET
; 0000 0036 if(!PINC.1) return 5;
_0x16:
	SBIC 0x13,1
	RJMP _0x17
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET
; 0000 0037 if(!PINC.2) return 4;
_0x17:
	SBIC 0x13,2
	RJMP _0x18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 0038 PORTC.3=1;PORTC.4=0;PORTC.5=1;PORTC.6=1;
_0x18:
	SBI  0x15,3
	CBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 0039 if(!PINC.0) return 9;
	SBIC 0x13,0
	RJMP _0x21
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RET
; 0000 003A if(!PINC.1) return 8;
_0x21:
	SBIC 0x13,1
	RJMP _0x22
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET
; 0000 003B if(!PINC.2) return 7;
_0x22:
	SBIC 0x13,2
	RJMP _0x23
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RET
; 0000 003C PORTC.3=0;PORTC.4=1;PORTC.5=1;PORTC.6=1;
_0x23:
	CBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 003D if(!PINC.1) return 0;
	SBIC 0x13,1
	RJMP _0x2C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 003E if(!PINC.2) return 10;
_0x2C:
	SBIC 0x13,2
	RJMP _0x2D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET
; 0000 003F return 12;
_0x2D:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RET
; 0000 0040 }
; .FEND
;
;void lcd(int key)
; 0000 0043 {
; 0000 0044 if(key==1) lcd_putsf("1");
;	key -> Y+0
; 0000 0045 if(key==2) lcd_putsf("2");
; 0000 0046 if(key==3) lcd_putsf("3");
; 0000 0047 if(key==4) lcd_putsf("4");
; 0000 0048 if(key==5) lcd_putsf("5");
; 0000 0049 if(key==6) lcd_putsf("6");
; 0000 004A if(key==7) lcd_putsf("7");
; 0000 004B if(key==8) lcd_putsf("8");
; 0000 004C if(key==9) lcd_putsf("9");
; 0000 004D if(key==0) lcd_putsf("0");
; 0000 004E if(key==10)
; 0000 004F {
; 0000 0050     xy=0;
; 0000 0051     lcd_clear();
; 0000 0052 }
; 0000 0053 
; 0000 0054 }
;void Beep (int N , int d1 , int d2 );
;void LED_Light (int numbers);
;void Beep (int N , int d1 , int d2 )
; 0000 0058 {
_Beep:
; .FSTART _Beep
; 0000 0059 for ( i=1 ; i<=N ; i++ )
	ST   -Y,R27
	ST   -Y,R26
;	N -> Y+4
;	d1 -> Y+2
;	d2 -> Y+0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
_0x3A:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R4
	CPC  R31,R5
	BRLT _0x3B
; 0000 005A {
; 0000 005B Buzzer_Pin=1;
	SBI  0x15,7
; 0000 005C delay_ms(d1);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _delay_ms
; 0000 005D Buzzer_Pin=0;
	CBI  0x15,7
; 0000 005E delay_ms(d2);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
; 0000 005F }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x3A
_0x3B:
; 0000 0060 
; 0000 0061 
; 0000 0062 }
	ADIW R28,6
	RET
; .FEND
;void LED_Light (int numbers)
; 0000 0064 {
_LED_Light:
; .FSTART _LED_Light
; 0000 0065 for ( i=0 ; i<=numbers ; i++ )
	ST   -Y,R27
	ST   -Y,R26
;	numbers -> Y+0
	CLR  R4
	CLR  R5
_0x41:
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R4
	CPC  R31,R5
	BRLT _0x42
; 0000 0066 {
; 0000 0067 LED_Green_ON;
	SBI  0x1B,0
; 0000 0068 delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 0069 LED_Red_ON;
	SBI  0x1B,1
; 0000 006A delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 006B LED_Yellow_ON;
	SBI  0x1B,2
; 0000 006C delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 006D LED_Blue_ON;
	SBI  0x1B,3
; 0000 006E delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 006F LED_Green_OFF;
	CBI  0x1B,0
; 0000 0070 delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 0071 LED_Red_OFF;
	CBI  0x1B,1
; 0000 0072 delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 0073 LED_Yellow_OFF;
	CBI  0x1B,2
; 0000 0074 delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 0075 LED_Blue_OFF;
	CBI  0x1B,3
; 0000 0076 delay_ms(50);
	RCALL SUBOPT_0x0
; 0000 0077 }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x41
_0x42:
; 0000 0078 
; 0000 0079 }
	RJMP _0x2020002
; .FEND
;void Effect_name_Start (void);
;void Effect_name_Start (void)
; 0000 007C {
_Effect_name_Start:
; .FSTART _Effect_name_Start
; 0000 007D 
; 0000 007E Beep(10,30,30);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _Beep
; 0000 007F lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 0080 lcd_puts("  Final Project ");
	__POINTW2MN _0x53,0
	RCALL SUBOPT_0x2
; 0000 0081 lcd_gotoxy(0,1);
; 0000 0082 lcd_puts("Hamian Ghazipoor");
	__POINTW2MN _0x53,17
	RCALL SUBOPT_0x3
; 0000 0083 delay_ms(2000);
; 0000 0084 lcd_clear();
	RCALL _lcd_clear
; 0000 0085 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0086 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 0087 lcd_puts("  Final Project ");
	__POINTW2MN _0x53,34
	RCALL SUBOPT_0x2
; 0000 0088 lcd_gotoxy(0,1);
; 0000 0089 lcd_puts("Hamian|Ghazipoor");
	__POINTW2MN _0x53,51
	RCALL SUBOPT_0x3
; 0000 008A delay_ms(2000);
; 0000 008B }
	RET
; .FEND

	.DSEG
_0x53:
	.BYTE 0x44
;
;void main(void)
; 0000 008E {

	.CSEG
_main:
; .FSTART _main
; 0000 008F // Declare your local variables here
; 0000 0090 int key=13 ;
; 0000 0091 // Input/Output Ports initialization
; 0000 0092 // Port A initialization
; 0000 0093 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0094 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
;	key -> R16,R17
	__GETWRN 16,17,13
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 0095 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0096 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0097 
; 0000 0098 // Port B initialization
; 0000 0099 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 009A DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 009B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 009C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 009D 
; 0000 009E // Port C initialization
; 0000 009F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00A0 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(248)
	OUT  0x14,R30
; 0000 00A1 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00A2 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(7)
	OUT  0x15,R30
; 0000 00A3 
; 0000 00A4 // Port D initialization
; 0000 00A5 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A6 DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 00A7 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A8 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00A9 
; 0000 00AA // Timer/Counter 0 initialization
; 0000 00AB // Clock source: System Clock
; 0000 00AC // Clock value: Timer 0 Stopped
; 0000 00AD // Mode: Normal top=0xFF
; 0000 00AE // OC0 output: Disconnected
; 0000 00AF TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00B0 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00B1 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00B2 
; 0000 00B3 // Timer/Counter 1 initialization
; 0000 00B4 // Clock source: System Clock
; 0000 00B5 // Clock value: Timer1 Stopped
; 0000 00B6 // Mode: Normal top=0xFFFF
; 0000 00B7 // OC1A output: Disconnected
; 0000 00B8 // OC1B output: Disconnected
; 0000 00B9 // Noise Canceler: Off
; 0000 00BA // Input Capture on Falling Edge
; 0000 00BB // Timer1 Overflow Interrupt: Off
; 0000 00BC // Input Capture Interrupt: Off
; 0000 00BD // Compare A Match Interrupt: Off
; 0000 00BE // Compare B Match Interrupt: Off
; 0000 00BF TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00C0 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00C1 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00C2 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00C3 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00C4 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C5 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C6 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C7 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C8 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C9 
; 0000 00CA // Timer/Counter 2 initialization
; 0000 00CB // Clock source: System Clock
; 0000 00CC // Clock value: Timer2 Stopped
; 0000 00CD // Mode: Normal top=0xFF
; 0000 00CE // OC2 output: Disconnected
; 0000 00CF ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00D0 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00D1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00D2 OCR2=0x00;
	OUT  0x23,R30
; 0000 00D3 
; 0000 00D4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D5 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00D6 
; 0000 00D7 // External Interrupt(s) initialization
; 0000 00D8 // INT0: Off
; 0000 00D9 // INT1: Off
; 0000 00DA // INT2: Off
; 0000 00DB MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00DC MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00DD 
; 0000 00DE // USART initialization
; 0000 00DF // USART disabled
; 0000 00E0 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00E1 
; 0000 00E2 // Analog Comparator initialization
; 0000 00E3 // Analog Comparator: Off
; 0000 00E4 // The Analog Comparator's positive input is
; 0000 00E5 // connected to the AIN0 pin
; 0000 00E6 // The Analog Comparator's negative input is
; 0000 00E7 // connected to the AIN1 pin
; 0000 00E8 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E9 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EA 
; 0000 00EB // ADC initialization
; 0000 00EC // ADC disabled
; 0000 00ED ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00EE 
; 0000 00EF // SPI initialization
; 0000 00F0 // SPI disabled
; 0000 00F1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00F2 
; 0000 00F3 // TWI initialization
; 0000 00F4 // TWI disabled
; 0000 00F5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00F9 xy=0;
	CLR  R6
	CLR  R7
; 0000 00FA lcd_clear();
	RCALL _lcd_clear
; 0000 00FB Effect_name_Start();
	RCALL _Effect_name_Start
; 0000 00FC LED_Light(4);
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LED_Light
; 0000 00FD lcd_clear();
	RCALL _lcd_clear
; 0000 00FE 
; 0000 00FF 
; 0000 0100      while (1) {
_0x54:
; 0000 0101         if (PIND.3 == 0) {
	SBIC 0x10,3
	RJMP _0x57
; 0000 0102         Check = 0 ;
	LDI  R30,LOW(0)
	STS  _Check,R30
	STS  _Check+1,R30
; 0000 0103         }
; 0000 0104         if (PIND.3 == 1) {
_0x57:
	SBIS 0x10,3
	RJMP _0x58
; 0000 0105         Check = 1 ;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _Check,R30
	STS  _Check+1,R31
; 0000 0106         }
; 0000 0107         if ( Check != Check_Pin_Last )
_0x58:
	LDS  R30,_Check_Pin_Last
	LDS  R31,_Check_Pin_Last+1
	LDS  R26,_Check
	LDS  R27,_Check+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x59
; 0000 0108         {
; 0000 0109         lcd_clear();
	RCALL _lcd_clear
; 0000 010A         Check_Pin_Last = Check ;
	LDS  R30,_Check
	LDS  R31,_Check+1
	STS  _Check_Pin_Last,R30
	STS  _Check_Pin_Last+1,R31
; 0000 010B         }
; 0000 010C         if (PIND.3 == 0) {
_0x59:
	SBIC 0x10,3
	RJMP _0x5A
; 0000 010D           lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 010E           lcd_puts("   attention!   ");
	__POINTW2MN _0x5B,0
	RCALL SUBOPT_0x2
; 0000 010F           lcd_gotoxy(0,1);
; 0000 0110           lcd_puts("Message received");
	__POINTW2MN _0x5B,17
	RCALL SUBOPT_0x4
; 0000 0111           Beep(3,300,300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _Beep
; 0000 0112           LED_Light(4);
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _LED_Light
; 0000 0113           delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0114           lcd_clear();
	RCALL _lcd_clear
; 0000 0115           while(1)
_0x5C:
; 0000 0116           {
; 0000 0117           lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 0118           lcd_puts("Press the key 1");
	__POINTW2MN _0x5B,34
	RCALL _lcd_puts
; 0000 0119           key=key_pad();
	RCALL _key_pad
	MOVW R16,R30
; 0000 011A           if ( key == 1 )
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x5F
; 0000 011B           {
; 0000 011C             Beep(10,50,50);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _Beep
; 0000 011D             break;
	RJMP _0x5E
; 0000 011E           }
; 0000 011F           if ( key != 1 && key != 12 )
_0x5F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x61
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0120           {
; 0000 0121             lcd_clear();
	RCALL _lcd_clear
; 0000 0122             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 0123             lcd_puts("Button 1 has not");
	__POINTW2MN _0x5B,50
	RCALL SUBOPT_0x2
; 0000 0124             lcd_gotoxy(0,1);
; 0000 0125             lcd_puts("been pressed");
	__POINTW2MN _0x5B,67
	RCALL SUBOPT_0x4
; 0000 0126             Beep(3,100,100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _Beep
; 0000 0127             delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0128             lcd_clear();
	RCALL _lcd_clear
; 0000 0129            }
; 0000 012A           }
_0x60:
	RJMP _0x5C
_0x5E:
; 0000 012B         }
; 0000 012C         if (PIND.3 == 1) {
_0x5A:
	SBIS 0x10,3
	RJMP _0x63
; 0000 012D           lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 012E           lcd_puts("  Waiting for  ");
	__POINTW2MN _0x5B,80
	RCALL SUBOPT_0x2
; 0000 012F           lcd_gotoxy(0,1);
; 0000 0130           lcd_puts("    message!    ");
	__POINTW2MN _0x5B,96
	RCALL _lcd_puts
; 0000 0131         }
; 0000 0132 
; 0000 0133     }
_0x63:
	RJMP _0x54
; 0000 0134 //while (1)
; 0000 0135 //{
; 0000 0136 //    Relay_OFF;
; 0000 0137 //    LED_Yellow_ON;
; 0000 0138 //    LED_Green_OFF;
; 0000 0139 //    LED_Red_OFF;
; 0000 013A //    LED_Blue_OFF;
; 0000 013B //    key=key_pad();
; 0000 013C //    lcd_gotoxy(0,0);
; 0000 013D //    lcd_puts(" Enter Pasword ");
; 0000 013E //    if ( key == 12 )
; 0000 013F //    {
; 0000 0140 //       key=key_pad();
; 0000 0141 //    }
; 0000 0142 //    else
; 0000 0143 //    {
; 0000 0144 //        xy++;
; 0000 0145 //        lcd_gotoxy(xy,1);
; 0000 0146 //        lcd(key);
; 0000 0147 //        if(xy==1)
; 0000 0148 //        Temp_Pass_1=key;
; 0000 0149 //        if(xy==2)
; 0000 014A //        Temp_Pass_2=key;
; 0000 014B //        if(xy==3)
; 0000 014C //        Temp_Pass_3=key;
; 0000 014D //        if(xy==4)
; 0000 014E //        Temp_Pass_4=key;
; 0000 014F //
; 0000 0150 //        Beep(1,100,100);
; 0000 0151 //        delay_ms(550);
; 0000 0152 //        if(xy>=4)
; 0000 0153 //        {
; 0000 0154 //            xy=0;
; 0000 0155 //            if ( Temp_Pass_1==0 &&Temp_Pass_2==0 & Temp_Pass_3==0 && Temp_Pass_4==0 )
; 0000 0156 //            {
; 0000 0157 //                LED_Yellow_OFF;
; 0000 0158 //                LED_Green_ON;
; 0000 0159 //                Relay_ON;
; 0000 015A //                LED_Red_OFF;
; 0000 015B //                LED_Blue_OFF;
; 0000 015C //                lcd_clear();
; 0000 015D //                lcd_gotoxy(0,0);
; 0000 015E //                lcd_puts("   Pasword OK   ");
; 0000 015F //                delay_ms(2500);
; 0000 0160 //                lcd_clear();
; 0000 0161 //            }
; 0000 0162 //            else
; 0000 0163 //            {
; 0000 0164 //                LED_Yellow_OFF;
; 0000 0165 //                LED_Green_OFF;
; 0000 0166 //                LED_Red_ON;
; 0000 0167 //                LED_Blue_OFF;
; 0000 0168 //                Relay_OFF;
; 0000 0169 //                lcd_clear();
; 0000 016A //                lcd_gotoxy(0,0);
; 0000 016B //                lcd_puts(" Pasword NOT OK  ");
; 0000 016C //                delay_ms(2500);
; 0000 016D //                Temp_Pass_1 = 0;
; 0000 016E //                Temp_Pass_2 = 0;
; 0000 016F //                Temp_Pass_3 = 0;
; 0000 0170 //                Temp_Pass_4 = 0;
; 0000 0171 //                lcd_clear();
; 0000 0172 //            }
; 0000 0173 //        }
; 0000 0174 //    }
; 0000 0175 //}
; 0000 0176 }
_0x64:
	RJMP _0x64
; .FEND

	.DSEG
_0x5B:
	.BYTE 0x71
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_Check:
	.BYTE 0x2
_Check_Pin_Last:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL _lcd_puts
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL _lcd_puts
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
