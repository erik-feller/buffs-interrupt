.include "key_codes.s"				/* defines values for KEY1, KEY2, KEY3 */
.extern	KEY_PRESSED					/* externally defined variable */
/***************************************************************************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 * This routine checks which KEY has been pressed. If it is KEY1 or KEY2, it writes this 
 * value to the global variable KEY_PRESSED. 
****************************************************************************************/
	.global	PUSHBUTTON_ISR
PUSHBUTTON_ISR:
	subi		sp, sp, 32					/* reserve space on the stack */
   stw		ra, 0(sp)
   stw		r10, 4(sp)
   stw		r11, 8(sp)
   /*stw		r12, 12(sp)*/
   stw		r13, 16(sp)
   stw		r14, 20(sp)
   stw		r15, 24(sp)
   /*stw		r17, 28(sp)*/
   stw		r16, 32(sp)

	movia		r16, 0x10002000 		/* Base Addr of timer...*/
	movia		r10, 0x10000050			/* base address of pushbutton KEY parallel port */
	movia		r14, 0x00000200			/*Max speed LED used to stop the speed incrimenting*/
	movia		r15, 0x00000008			/*Min speed LED used to stop the speed incrimenting*/
	ldwio		r11, 0xC(r10)				/* read edge capture register */
	stwio		r0,  0xC(r10)				/* clear the interrupt */                  
	movia		r10, SPEED			/* global variable to return the result */
	ldw			r12, 0(r10)
CHECK_KEY1:
	andi		r13, r11, 0b0010			/* check KEY1 */
	beq			r13, zero, CHECK_KEY2
	beq			r15, r23, END_PUSHBUTTON_ISR
	addi 		r17, r17, 0x0004
	srli		r23, r23, 1
	stwio		r23, 0(r9)
	ldw			r12, 0(r17)
	sthio		r12, 8(r16)				/* store the low half word of counter start value */ 
	srli		r12, r12, 16
	sthio		r12, 0xC(r16)
	movi		r15, 0b0111				/* START = 1, CONT = 1, ITO = 1 */
	sthio		r15, 4(r16)
	br			END_PUSHBUTTON_ISR

CHECK_KEY2:
	andi		r13, r11, 0b0100			/* check KEY2 */
	beq			r13, zero, END_PUSHBUTTON_ISR 
	beq			r14, r23, END_PUSHBUTTON_ISR
	addi		r17, r17, -4
	slli		r23, r23,1
	stwio		r23, 0(r9)
	ldw			r12, 0(r17)
	sthio		r12, 8(r16)				/* store the low half word of counter start value */ 
	srli		r12, r12, 16
	sthio		r12, 0xC(r16)
	movi		r15, 0b0111				/* START = 1, CONT = 1, ITO = 1 */
	sthio		r15, 4(r16)
	br 			END_PUSHBUTTON_ISR


END_PUSHBUTTON_ISR:
   ldw		ra,  0(sp)					/* Restore all used register to previous */
   ldw		r10, 4(sp)
   ldw		r11, 8(sp)
   /*ldw		r12, 12(sp)*/
   ldw		r13, 16(sp)
   ldw		r14, 20(sp)
   ldw		r15, 24(sp)
   /*ldw		r17, 28(sp)*/
   ldw		r16, 32(sp)
   addi		sp,  sp, 32

	ret
	.end
	
