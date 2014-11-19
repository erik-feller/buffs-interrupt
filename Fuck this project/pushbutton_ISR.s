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
	subi		sp, sp, 28					/* reserve space on the stack */
   stw		ra, 0(sp)
   stw		r10, 4(sp)
   stw		r11, 8(sp)
   stw		r12, 12(sp)
   stw		r13, 16(sp)
   stw		r14, 20(sp)
   stw		r15, 24(sp)
   stw		r17, 28(sp)

	movia		r10, 0x10000050			/* base address of pushbutton KEY parallel port */
	movia		r14, 0x00000200			/*Max speed LED used to stop the speed incrimenting*/
	movia		r15, 0x00000008			/*Min speed LED used to stop the speed incrimenting*/
	ldwio		r11, 0xC(r10)				/* read edge capture register */
	stwio		r0,  0xC(r10)				/* clear the interrupt */                  

	movia		r10, KEY_PRESSED			/* global variable to return the result */
CHECK_KEY1:
	andi		r13, r11, 0b0010			/* check KEY1 */
	beq			r13, zero, CHECK_KEY2
	beq			r15, r23, END_PUSHBUTTON_ISR
	srli		r23, r23, 1
	stwio		r23, 0(r9)
	movi		r12, KEY1
	stw			r12, 0(r10)					/* return KEY1 value */
	br			END_PUSHBUTTON_ISR

CHECK_KEY2:
	andi		r13, r11, 0b0100			/* check KEY2 */
	beq		r13, zero, END_PUSHBUTTON_ISR 
	/*beq			r14, r23, END_PUSHBUTTON_ISR*/
	movi		r12, KEY2
	stw		r12, 0(r10)					/* return KEY2 value */

END_PUSHBUTTON_ISR:
   ldw		ra,  0(sp)					/* Restore all used register to previous */
   ldw		r10, 4(sp)
   ldw		r11, 8(sp)
   ldw		r12, 12(sp)
   ldw		r13, 16(sp)
   ldw		r14, 20(sp)
   ldw		r15, 24(sp)
   addi		sp,  sp, 28

	ret
	.end
	
