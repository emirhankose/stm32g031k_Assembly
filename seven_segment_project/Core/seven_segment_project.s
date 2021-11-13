/*
 * asm.s
 *
 * authors: Emirhan KÖSE
 *
 * description: Added the necessary stuff for turning on the green LED on the
 *   G031K8 Nucleo board. Mostly for teaching.
 */


.syntax unified
.cpu cortex-m0plus
.fpu softvfp
.thumb


/* make linker see this */
.global Reset_Handler

/* get these from linker script */
.word _sdata
.word _edata
.word _sbss
.word _ebss


/* define peripheral addresses from RM0444 page 57, Tables 3-4 */
.equ RCC_BASE,         (0x40021000)          // RCC base address
.equ RCC_IOPENR,       (RCC_BASE   + (0x34)) // RCC IOPENR register offset

.equ GPIOB_BASE,       (0x50000400)          // GPIOC base address
.equ GPIOB_MODER,      (GPIOB_BASE + (0x00)) // GPIOC MODER register offset
.equ GPIOB_ODR,        (GPIOB_BASE + (0x14)) // GPIOC ODR register offset
.equ GPIOB_IDR, 	   (GPIOB_BASE +(0x10))

/* vector table, +1 thumb mode */
.section .vectors
vector_table:
	.word _estack             /*     Stack pointer */
	.word Reset_Handler +1    /*     Reset handler */
	.word Default_Handler +1  /*       NMI handler */
	.word Default_Handler +1  /* HardFault handler */
	/* add rest of them here if needed */


/* reset handler */
.section .text
Reset_Handler:
	/* set stack pointer */
	ldr r0, =_estack
	mov sp, r0

	/* initialize data and bss
	 * not necessary for rom only code
	 * */
	bl init_data
	/* call main */
	bl main
	/* trap if returned */
	b .


/* initialize data and bss sections */
.section .text
init_data:

	/* copy rom to ram */
	ldr r0, =_sdata
	ldr r1, =_edata
	ldr r2, =_sidata
	movs r3, #0
	b LoopCopyDataInit

	CopyDataInit:
		ldr r4, [r2, r3]
		str r4, [r0, r3]
		adds r3, r3, #4

	LoopCopyDataInit:
		adds r4, r0, r3
		cmp r4, r1
		bcc CopyDataInit

	/* zero bss */
	ldr r2, =_sbss
	ldr r4, =_ebss
	movs r3, #0
	b LoopFillZerobss

	FillZerobss:
		str  r3, [r2]
		adds r2, r2, #4

	LoopFillZerobss:
		cmp r2, r4
		bcc FillZerobss

	bx lr


/* default handler */
.section .text
Default_Handler:
	b Default_Handler


/* main function */
.section .text
main:
/* PORT B is enabled*/
	ldr r6, =RCC_IOPENR
	ldr r5, [r6]
	ldr r4,=#2
	orrs r5,r5,r4
	str r5,[r6]

	ldr r6,=GPIOB_MODER
	ldr r5,[r6]
	ldr r4,=0xFFFFF
	mvns r4,r4
	ands r5,r5,r4
	ldr r4,=0x50555
	orrs r5,r5,r4
	str r5,[r6]

	emirhan:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x135
	orrs r5,r5,r4
	str r5,[r6]
	b switch_button_control_1


	alperen:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x22
	orrs r5,r5,r4
	str r5,[r6]
	b switch_button_control_2

	ruveyda:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x26
	orrs r5,r5,r4
	str r5,[r6]
	b switch_button_control_3

	switch_button_control_1:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0x175
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq alperen
	bne countdown_button_1

	switch_button_control_2:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0x62
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq ruveyda
	bne countdown_button_2

	switch_button_control_3:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0x66
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq emirhan
	bne countdown_button_3

	countdown_button_1:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0x1B5
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq countdown_emirhan
	bne switch_button_control_1

	countdown_button_2:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0xA2
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq countdown_alperen
	bne switch_button_control_2

	countdown_button_3:
	ldr r6,=GPIOB_IDR
	ldr r5,[r6]
	ldr r4,=0xA6
	ldr r7,=0xf4240
	bl delay
	cmp r5,r4
	beq countdown_ruveyda
	bne switch_button_control_3


	countdown_emirhan:
	bl number_5
	ldr r7,=0xf4240
	bl delay
	bl number_4
	ldr r7,=0xf4240
	bl delay
	bl number_3
	ldr r7,=0xf4240
	bl delay
	bl number_2
	ldr r7,=0xf4240
	bl delay
	bl number_1
	ldr r7,=0xf4240
	bl delay
	bl number_0
	ldr r7,=0xf4240
	bl delay
	b emirhan

	countdown_alperen:
	bl number_1
	ldr r7,=0xf4240
	bl delay
	bl number_0
	ldr r7,=0xf4240
	bl delay
	b alperen

	countdown_ruveyda:
	bl number_7
	ldr r7,=0xf4240
	bl delay
	bl number_6
	ldr r7,=0xf4240
	bl delay
	bl number_5
	ldr r7,=0xf4240
	bl delay
	bl number_4
	ldr r7,=0xf4240
	bl delay
	bl number_3
	ldr r7,=0xf4240
	bl delay
	bl number_2
	ldr r7,=0xf4240
	bl delay
	bl number_1
	ldr r7,=0xf4240
	bl delay
	bl number_0
	ldr r7,=0xf4240
	bl delay
	b ruveyda


	number_7:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x2E
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_6:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x33D
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_5:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x13D
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_4:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x3B
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_3:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x13E
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_2:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x31E
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_1:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x2A
	orrs r5,r5,r4
	str r5,[r6]
	bx lr

	number_0:
	ldr r6,=GPIOB_ODR
	ldr r5,[r6]
	ldr r4,=0x0
	ands r5,r5,r4
	ldr r4,=0x32F
	orrs r5,r5,r4
	str r5,[r6]
	bx lr


	delay:
	subs r7,#1
	cmp r7,0x0
	bne delay
	bx lr

	/* for(;;); */
	b .

	/* this should never get executed */
	nop

