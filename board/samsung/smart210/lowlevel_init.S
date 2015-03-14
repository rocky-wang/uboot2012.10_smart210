/*
 * Memory Setup stuff - taken from blob memsetup.S
 *
 * Copyright (C) 2009 Samsung Electronics
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
#include <version.h>
#include <asm/arch/cpu.h>
#include <asm/arch/clock.h>
#include <asm/arch/power.h>

/*
 * Register usages:
 *
 * r5 has zero always
 * r7 has S5PC100 GPIO base, 0xE0300000
 * r8 has real GPIO base, 0xE0300000, 0xE0200000 at S5PC100, S5PC110 repectively
 * r9 has Mobile DDR size, 1 means 1GiB, 2 means 2GiB and so on
 */

_TEXT_BASE:
	.word	CONFIG_SYS_TEXT_BASE

	.globl lowlevel_init
	.globl mem_ctrl_asm_init
lowlevel_init:
	mov	r11, lr

	/* r5 has always zero ; r8 has always GPIO_BASE */
	mov	r5, #0
	ldr	r8, =S5PC110_GPIO_BASE

	ldr	r0, =S5PC110_RST_STAT
	ldr	r1, [r0]
	and	r1, r1, #0x000D0000
	cmp	r1, #(0x1 << 19)			@ DEEPIDLE_WAKEUP
	beq	didle_wakeup

	/*
	 * Initialize Async Register Setting for EVT1
	 * Because we are setting EVT1 as the default value of EVT0,
	 * setting EVT0 as well does not make things worse.
	 * Thus, for the simplicity, we set for EVT0, too
	 *
	 * The "Async Registers" are:
	 *	0xE0F0_0000
	 *	0xE1F0_0000
	 *	0xF180_0000
	 *	0xF190_0000
	 *	0xF1A0_0000
	 *	0xF1B0_0000
	 *	0xF1C0_0000
	 *	0xF1D0_0000
	 *	0xF1E0_0000
	 *	0xF1F0_0000
	 *	0xFAF0_0000
	 */
	ldr     r0, =0xe0f00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xe1f00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1800000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1900000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1a00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1b00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1c00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1d00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1e00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xf1f00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	ldr     r0, =0xfaf00000
	ldr     r1, [r0]
	bic     r1, r1, #0x1
	str     r1, [r0]

	/*
	 * Diable ABB block to reduce sleep current at low temperature
	 * Note that it's hidden register setup don't modify it
	 */
	ldr	r0, =0xE010C300
	ldr	r1, =0x00800000
	str	r1, [r0]

	/* Disable Watchdog */
	ldr	r0, =S5PC110_WATCHDOG_BASE		@ 0xE2700000
	str	r5, [r0]

	/* setting SRAM */
	ldr	r0, =S5PC110_SROMC_BASE
	/* modify by rocky */
    ldr r1,=0x0         @ r1,=0x9
	str	r1, [r0]

	/* S5PV210 has 4 groups of interrupt sources */
	ldr	r0, =S5PC110_VIC0_BASE			@ 0xF2000000
	add	r1, r0, #0x00100000
	add	r2, r0, #0x00200000
	add r3, r0, #0x00300000

	/* Disable all interrupts (VIC0, VIC1 and VIC2) */
	mvn	r4, #0x0
	str	r4, [r0, #0x14]				@ INTENCLEAR
	str	r4, [r1, #0x14]				@ INTENCLEAR
	str	r4, [r2, #0x14]				@ INTENCLEAR
	str	r4, [r3, #0x14]				@ INTENCLEAR

	/* Set all interrupts as IRQ */
	str	r5, [r0, #0xc]				@ INTSELECT
	str	r5, [r1, #0xc]				@ INTSELECT
	str	r5, [r2, #0xc]				@ INTSELECT
	str	r5, [r3, #0xc]				@ INTSELECT

	/* Pending Interrupt Clear */
	str	r5, [r0, #0xf00]			@ INTADDRESS
	str	r5, [r1, #0xf00]			@ INTADDRESS
	str	r5, [r2, #0xf00]			@ INTADDRESS
	str	r5, [r3, #0xf00]			@ INTADDRESS

	/* for UART */
	bl	uart_asm_init

#ifdef CONFIG_LOWLEVEL_SERIAL_DEBUG
    ldr r0, =0xE0000000
    bl  display_hex_word
#endif

	bl	internal_ram_init

    /* DDR2 Memory Setup */
	bl  mem_ctrl_asm_init

#ifdef CONFIG_LOWLEVEL_SERIAL_DEBUG
	ldr r1,=0xabcdef12
	ldr r0,=0x30000000
	str r1,[r0]

	bl  display_hex_word
#endif

	/* Clear wakeup status register */
	ldr	r0, =S5PC110_WAKEUP_STAT
	ldr	r1, [r0]
	str	r1, [r0]

	/* IO retension release */
	ldr	r0, =S5PC110_OTHERS			@ 0xE010E000
	ldr	r1, [r0]
	ldr	r2, =((1 << 31) | (1 << 30) | (1 << 29) | (1 << 28))    @ IO_RET_REL
	orr	r1, r1, r2
	str	r1, [r0]

    /* LED2 Testing add for rocky */
#ifdef CONFIG_LED_ASM_TEST
    bl  led2_asm
#endif

	b	1f

didle_wakeup:
	/* Wait when APLL is locked */
	ldr	r0, =0xE0100100			@ S5PC110_APLL_CON
lockloop:
	ldr	r1, [r0]
	and	r1, r1, #(1 << 29)
	cmp	r1, #(1 << 29)
	bne	lockloop

	ldr	r0, =S5PC110_INFORM0
	ldr	r1, [r0]
	mov	pc, r1
	nop
	nop
	nop
	nop
	nop

1:
	mov	lr, r11
	mov	pc, lr

#if 0
/*
 * system_clock_init: Initialize core clock and bus clock.
 * void system_clock_init(void)
 */
system_clock_init:
	ldr	r0, =0xE010C000			@ S5PC110_PWR_CFG

	/* Set OSC_FREQ value */
	ldr	r1, =0xf
	str	r1, [r0, #0x100]		@ S5PC110_OSC_FREQ

	/* Set MTC_STABLE value */
	ldr	r1, =0xffffffff
	str	r1, [r0, #0x110]		@ S5PC110_MTC_STABLE

	/* Set CLAMP_STABLE value */
	ldr	r1, =0x3ff03ff
	str	r1, [r0, #0x114]		@ S5PC110_CLAMP_STABLE

	ldr	r0, =S5PC110_CLOCK_BASE		@ 0xE0100000

	/* Set Clock divider */
	ldr	r1, =0x14131330			@ 1:1:4:4, 1:4:5
	str	r1, [r0, #0x300]
	ldr	r1, =0x11110111			@ UART[3210]: MMC[3210]
	str	r1, [r0, #0x310]

	/* Set Lock Time */
	ldr	r1, =0x2cf			@ Locktime : 30us
	str	r1, [r0, #0x000]		@ S5PC110_APLL_LOCK
	ldr	r1, =0xe10			@ Locktime : 0xe10 = 3600
	str	r1, [r0, #0x008]		@ S5PC110_MPLL_LOCK
	str	r1, [r0, #0x010]		@ S5PC110_EPLL_LOCK
	str	r1, [r0, #0x020]		@ S5PC110_VPLL_LOCK

	/* S5PC110_APLL_CON */
	ldr	r1, =0x80C80601			@ 800MHz
	str	r1, [r0, #0x100]
	/* S5PC110_MPLL_CON */
	ldr	r1, =0x829B0C01			@ 667MHz
	str	r1, [r0, #0x108]
	/* S5PC110_EPLL_CON */
	ldr	r1, =0x80600602			@  96MHz VSEL 0 P 6 M 96 S 2
	str	r1, [r0, #0x110]
	/* S5PC110_VPLL_CON */
	ldr	r1, =0x806C0603			@  54MHz
	str	r1, [r0, #0x120]

	/* Set Source Clock */
	ldr	r1, =0x10001111			@ A, M, E, VPLL Muxing
	str	r1, [r0, #0x200]		@ S5PC1XX_CLK_SRC0

	/* OneDRAM(DMC0) clock setting */
	ldr	r1, =0x01000000			@ ONEDRAM_SEL[25:24] 1 SCLKMPLL
	str	r1, [r0, #0x218]		@ S5PC110_CLK_SRC6
	ldr	r1, =0x30000000			@ ONEDRAM_RATIO[31:28] 3 + 1
	str	r1, [r0, #0x318]		@ S5PC110_CLK_DIV6

	/* XCLKOUT = XUSBXTI 24MHz */
	add	r2, r0, #0xE000			@ S5PC110_OTHERS
	ldr     r1, [r2]
	orr	r1, r1, #(0x3 << 8)		@ CLKOUT[9:8] 3 XUSBXTI
	str	r1, [r2]

	/* CLK_IP0 */
	ldr	r1, =0x8fefeeb			@ DMC[1:0] PDMA0[3] IMEM[5]
	str	r1, [r0, #0x460]		@ S5PC110_CLK_IP0

	/* CLK_IP1 */
	ldr	r1, =0xe9fdf0f9			@ FIMD[0] USBOTG[16]
						@ NANDXL[24]
	str	r1, [r0, #0x464]		@ S5PC110_CLK_IP1

	/* CLK_IP2 */
	ldr	r1, =0xf75f7fc			@ CORESIGHT[8] MODEM[9]
						@ HOSTIF[10] HSMMC0[16]
						@ HSMMC2[18] VIC[27:24]
	str	r1, [r0, #0x468]		@ S5PC110_CLK_IP2

	/* CLK_IP3 */
	ldr	r1, =0x8eff038c			@ I2C[8:6]
						@ SYSTIMER[16] UART0[17]
						@ UART1[18] UART2[19]
						@ UART3[20] WDT[22]
						@ PWM[23] GPIO[26] SYSCON[27]
	str	r1, [r0, #0x46c]		@ S5PC110_CLK_IP3

	/* CLK_IP4 */
	ldr	r1, =0xfffffff1			@ CHIP_ID[0] TZPC[8:5]
	str	r1, [r0, #0x470]		@ S5PC110_CLK_IP3

200:
	/* wait at least 200us to stablize all clock */
	mov	r2, #0x10000
1:	subs	r2, r2, #1
	bne	1b

	mov	pc, lr
#endif

internal_ram_init:
	ldr	r0, =0xF1500000
	ldr	r1, =0x0
	str	r1, [r0]

	mov	pc, lr

/*
 * uart_asm_init: Initialize UART's pins
 */
uart_asm_init:
	/* set GPIO to enable UART0-UART4 */
	mov	r0, r8
	ldr	r1, =0x22222222
	str	r1, [r0, #0x0]			@ S5PV210_GPIO_A0_OFFSET
	ldr	r1, =0x00002222
	str	r1, [r0, #0x20]			@ S5PV210_GPIO_A1_OFFSET

#ifdef CONFIG_LOWLEVEL_SERIAL_DEBUG
    ldr r0, =0xE2900000         @ ULCON0
    ldr r1, =0x3
    str r1,[r0]

    ldr r1, =0x305
    str r1,[r0,#0x4]              @ UCON0

    ldr r1, =1
    str r1,[r0,#0x8]
    
    str r5,[r0,#0xc]

    ldr r1, =34
    str r1,[r0,#0x28]           @ UBRDIV

    ldr r1, =0xdfdd
    str r1,[r0,#0x2c]           @ UDIVSLOT

    ldr r0, =0xE2900020         @ UTH0
    ldr r1, =0x55
    str r1,[r0]           @ 'U'
    
    ldr r1, =0x61
    str r1,[r0]           @ 'a'
    
    ldr r1, =0x72
    str r1,[r0]           @ 'r'
    
    ldr r1, =0x74
    str r1,[r0]           @ 't'
    
    ldr r1, =0xa
    str r1,[r0]
    ldr r1, =0xd
    str r1,[r0]         
#endif

	mov	pc, lr
	
