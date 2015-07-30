/*
 * Copyright (C) 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 * Kyungmin Park <kyungmin.park@samsung.com>
 *
 * Configuation settings for the SAMSUNG Universal (s5pc100) board.
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

#ifndef __CONFIG_H
#define __CONFIG_H

/* High Level Configuration Options */
#define CONFIG_SAMSUNG		1	/* in a SAMSUNG core */
#define CONFIG_S5P		1	/* which is in a S5P Family */
#define CONFIG_S5PC110		1	/* which is in a S5PC110 */
#define CONFIG_MACH_SMART210	1	/* working with SMART210 */

#include <asm/arch/cpu.h>		/* get chip and board defs */

#define CONFIG_ARCH_CPU_INIT
#define CONFIG_DISPLAY_CPUINFO
#define CONFIG_DISPLAY_BOARDINFO

/*Add test function for rocky */
//#define CONFIG_LED_ASM_TEST
#define CONFIG_LOWLEVEL_SERIAL_DEBUG
//#define CONFIG_LOWLEVEL_INFO_SHOW
#define CONFIG_IDENT_STRING " For Rocky"
/*************************/

/* input clock of PLL: has 24MHz input clock at S5PC110 */
#define CONFIG_SYS_CLK_FREQ_C110	24000000

/* PWM init */
#define CONFIG_PWM    1

/* DRAM Base */
#define CONFIG_SYS_SDRAM_BASE		0x20000000

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/*
 * Size of malloc() pool
 * 1MB = 0x100000, 0x100000 = 1024 * 1024
 */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20))
/*
 * select serial console configuration
 */
#define CONFIG_SERIAL0			1
#define CONFIG_SERIAL_MULTI		1
#define CONFIG_BAUDRATE			115200

/* It should define before config_cmd_default.h */
#define CONFIG_SYS_NO_FLASH		1

/* Command definition */
#include <config_cmd_default.h>

/* Undef Command */
#undef CONFIG_CMD_BOOTD
#undef CONFIG_CMD_CONSOLE
#undef CONFIG_CMD_ECHO
#undef CONFIG_CMD_IMI
#undef CONFIG_CMD_ITEST
#undef CONFIG_CMD_LOADB
#undef CONFIG_CMD_LOADS
#undef CONFIG_CMD_RUN
#undef CONFIG_CMD_SETGETDCR
#undef CONFIG_CMD_SOURCE

#undef CONFIG_CMD_FPGA
#undef CONFIG_CMD_MISC
#undef CONFIG_CMD_NET
#undef CONFIG_CMD_NFS
#undef CONFIG_CMD_XIMG
#define CONFIG_CMD_CACHE

#define CONFIG_CMD_NET

#define CONFIG_BOOTDELAY		3
#define CONFIG_ZERO_BOOTDELAY_CHECK

#define CONFIG_BOOTCOMMAND	"bootm 20008000"

#define CONFIG_BOOTARGS	"root=/dev/ram initrd=0x20800000,8M init=/linuxrc console=ttySAC0,115200"
#define CONFIG_BAKBOOTARGS "root=/dev/nfs nfsroot=192.168.10.110:/home/rocky/work/rootfs ip=192.168.10.119 init=/linuxrc console=ttySAC0,115200"

#define CONFIG_ENV_OVERWRITE
#define CONFIG_SYS_CONSOLE_IS_IN_ENV

/* Miscellaneous configurable options */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
//#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT	"Smart210 # "
#define CONFIG_SYS_CBSIZE	256	/* Console I/O Buffer Size */
#define CONFIG_SYS_PBSIZE	384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS	16	/* max number of command args */
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
/* memtest works on */
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x5000000)
#define CONFIG_SYS_LOAD_ADDR		(CONFIG_SYS_SDRAM_BASE + 0x4000000)

#define CONFIG_SYS_HZ			1000

/* Smart210 has 1 banks of DRAM */
#define CONFIG_NR_DRAM_BANKS	1
#define PHYS_SDRAM_1		CONFIG_SYS_SDRAM_BASE	/* mDDR DMC1 Bank #0 */
#define PHYS_SDRAM_1_SIZE	(512 << 20)		/* 512 MB in Bank #0 */

#define CONFIG_SYS_MONITOR_BASE		0x00000000
#define CONFIG_SYS_MONITOR_LEN		(256 << 10)	/* 256 KiB */

/* FLASH and environment organization */
//#define CONFIG_ENV_IS_IN_ONENAND	1
#define CONFIG_ENV_IS_NOWHERE	1
#define CONFIG_ENV_SIZE			(256 << 10)	/* 256 KiB, 0x40000 */
#define CONFIG_ENV_ADDR			(1 << 20)	/* 1 MB, 0x100000 */

#define CONFIG_DOS_PARTITION		1

#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_SYS_LOAD_ADDR - 0x1000000)

#define CONFIG_SYS_CACHELINE_SIZE       64

#include <asm/arch/gpio.h>

/* dm9000 configure */
#define CONFIG_DRIVER_DM9000  1
#define CONFIG_DM9000_NO_SROM
#define CONFIG_DM9000_BASE		(0x88000000)
#define DM9000_IO			(CONFIG_DM9000_BASE)
#define DM9000_DATA			(CONFIG_DM9000_BASE+0x0004)

#define CONFIG_ETHADDR		00:40:5c:26:0a:5b
#define CONFIG_NETMASK      255.255.255.0
#define CONFIG_IPADDR		192.168.10.119
#define CONFIG_SERVERIP		192.168.10.110
#define CONFIG_GATEWAYIP	192.168.10.3

#define CONFIG_CMD_PING

/* MACH_TYPE_MINI210 macro will be removed once added to mach-types */
#define MACH_TYPE_SMART210		2458	/*SMDKV210*/
#define CONFIG_MACH_TYPE		MACH_TYPE_SMART210

#endif	/* __CONFIG_H */
