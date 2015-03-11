/*
 * Copyright (C) 2009 Samsung Electrnoics
 * Minkyu Kang <mk7.kang@samsung.com>
 * Kyungmin Park <kyungmin.park@samsung.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>

	.globl mem_ctrl_asm_init
mem_ctrl_asm_init:
	ldr	    r0, =S5PC110_DMC0_BASE			@ 0xF0000000
	ldr 	r6, =S5PC110_DMC1_BASE			@ 0xF1400000

	/* DLL parameter setting */
	ldr	r1, =0x0010100A
	str	r1, [r0, #0x018]			    @ PHYCONTROL0_OFFSET
	
	ldr	r1, =0x00000086
	str	r1, [r0, #0x01C]			    @ PHYCONTROL1_OFFSET
	
	ldr	r1, =0x0010100B
	str	r1, [r0, #0x018]			    @ PHYCONTROL0_OFFSET
	
find_lock_val:
    ldr r1, [r0, #0x40]                 @ DMC_PHYSTATUS_OFFSET    
    and r2, r1, #0x7
    cmp r2, #0x7                    
    bne find_lock_val

	and	r1, #0x3fc0
	mov	r2, r1, LSL #18
	orr	r2, r2, #0x100000
	orr	r2 ,r2, #0x1000
	orr	r1, r2, #0xB					
	str	r1, [r0, #0x18]                 @ DMC_PHYCONTROL0_OFFSET

	ldr	r1, =0x0FFF1010					
	str	r1, [r0, #0x00]                 @ DMC_CONCONTROL_OFFSET
	//step 6: MemControl BL=4, 1 chip, DDR2 type, dynamic power down off
	ldr	r1, =0x00202400				
	str	r1, [r0, #0x04]                 @ DMC_MEMCONTROL_OFFSET
	//step 7: MemConfig0 512MB config, 8 banks,Mapping Method[12:15]0:linear 
	ldr	r1, =0x20E00323				    @ 256M:0x20F00313  512M:0x20E00323
	str	r1, [r0, #0x08]                 @ DMC_MEMCONFIG0_OFFSET
	//step 8:PrechConfig
	ldr	r1, =0xFF000000					
	str	r1, [r0, #0x14]                 @ DMC_PRECHCONFIG_OFFSET
	ldr	r1, =0xFFFF00FF					
	str	r1, [r0, #0x28]                 @ DMC_PWRDNCONFIG_OFFSET

	//step 9:TimingAref	7.8us//133MHz=1038(0x40E), 100MHz=780(0x30C), 20MHz=156(0x9C), 10MHz=78(0x4E)
	ldr	r1, =0x0000040E				
	str	r1, [r0, #0x30]                 @ DMC_TIMINGAREF_OFFSET
	//TimingRow
	ldr	r1, =0x11122206				
	str	r1, [r0, #0x34]                 @ DMC_TIMINGROW_OFFSET
	//TimingData
	ldr	r1, =0x12240000				
	str	r1, [r0, #0x38]                 @ DMC_TIMINGDATA_OFFSET
	//TimingPower
	ldr	r1, =0x05DC0343				
	str	r1, [r0, #0x3C]                 @ DMC_TIMINGPOWER_OFFSET

	//step 14:DirectCmd	chip0 NOP
	ldr	r1, =0x07000000					
	str	r1, [r0, #0x10]                 @ DMC_DIRECTCMD_OFFSET
	//step 16:DirectCmd	chip0 PALL
	ldr	r1, =0x01000000					
	str	r1, [r0, #0x10]
	//step 17:DirectCmd	chip0 EMRS2
	ldr	r1, =0x00020000					
	str	r1, [r0, #0x10]
	//step 18:DirectCmd	chip0 EMRS3
	ldr	r1, =0x00030000					
	str	r1, [r0, #0x10]
	//step 19:DirectCmd	chip0 EMRS1 (MEM DLL on, DQS# disable)
	ldr	r1, =0x00010000					
	str	r1, [r0, #0x10]
	//step 20:DirectCmd	chip0 MRS (MEM DLL reset) CL=4, BL=4
	ldr	r1, =0x00000542					
	str	r1, [r0, #0x10]
	//step 21:DirectCmd	chip0 PALL
	ldr	r1, =0x01000000					
	str	r1, [r0, #0x10]
	//step 22:DirectCmd	chip0 REFA
	ldr	r1, =0x05000000					
	str	r1, [r0, #0x10]
	//DirectCmd	chip0 REFA
	ldr	r1, =0x05000000					
	str	r1, [r0, #0x10]
	//step 23:DirectCmd	chip0 MRS (MEM DLL unreset)
	ldr	r1, =0x00000442					
	str	r1, [r0, #0x10]
	//step 25(1):DirectCmd	chip0 EMRS1 (OCD default)
	ldr	r1, =0x00010380					
	str	r1, [r0, #0x10]
	//step 25(2)DirectCmd	chip0 EMRS1 (OCD exit)
	ldr	r1, =0x00010000					
	str	r1, [r0, #0x10]

	//step 27:ConControl	auto refresh on
	ldr	r1, =0x0FF01030					
	str	r1, [r0, #0x00]                 @ DMC_CONCONTROL_OFFSET
	//step 28:MemControl	BL=4, 1 chip, DDR2 type, dynamic self refresh, force precharge, dynamic power down off
	ldr	r1, =0x00202400					
	str	r1, [r0, #0x04]                 @ DMC_MEMCONTROL_OFFSET

#ifdef CONFIG_LOWLEVEL_SERIAL_DEBUG
	ldr	r0,=0xE2900020
	ldr	r1,=0x44			@UTH0='D'
	str	r1,[r0]

	ldr	r1,=0x44			
	str	r1,[r0]				@UTH0='D'

	ldr	r1,=0x52			
	str	r1,[r0]				@UTH0='R'

	ldr	r1,=0xA
	str	r1,[r0]				@UTH0='\r'

	ldr	r1,=0xD
	str	r1,[r0]				@UTH0='\n'
#endif
	mov	pc, lr    

