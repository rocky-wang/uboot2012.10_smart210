/*
 * (C) Copyright 2000-2003
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
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

/*
 * Misc boot support
 */
#include <common.h>
#include <command.h>
#include <net.h>

#ifdef CONFIG_CMD_GO
DECLARE_GLOBAL_DATA_PTR;

/* Allow ports to override the default behavior */
__attribute__((weak))
unsigned long do_go_exec (ulong (*entry)(int, char * const []), int argc, char * const argv[])
{
	return entry (argc, argv);
}

int do_go (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	ulong	addr, rc;
	int     rcode = 0;

	if (argc < 2)
		return CMD_RET_USAGE;

	addr = simple_strtoul(argv[1], NULL, 16);

	printf ("## Starting application at 0x%08lX ...\n", addr);

	/*
	 * pass address parameter as argv[0] (aka command name),
	 * and all remaining args
	 */
	rc = do_go_exec ((void *)addr, argc - 1, argv + 1);
	if (rc != 0) rcode = 1;

	printf ("## Application terminated, rc = 0x%lX\n", rc);
	return rcode;
}

/* -------------------------------------------------------------------- */

U_BOOT_CMD(
	go, CONFIG_SYS_MAXARGS, 1,	do_go,
	"start application at address 'addr'",
	"addr [arg ...]\n    - start application at address 'addr'\n"
	"      passing 'arg' as arguments"
);

/*---------------------------------------------------------------------*/
static void setup_linux_tag(ulong param_base){
	struct tag *params = (struct tag *)param_base;
  	char *p; 

	p = getenv("bootargs");
	if(p == NULL){
		printf("bootargs Not Found!\n");
		return ;
	}
   	memset(params, 0, sizeof(struct tag)); 

	/* step1: setup start tag */ 
    	params->hdr.tag = ATAG_CORE;
   	params->hdr.size = tag_size(tag_core); 
   	params->u.core.flags = 0; 
   	params->u.core.pagesize = 0;
   	params->u.core.rootdev = 0; 
    	params = tag_next(params); 

	/* setp2: setup meminfo */
	params->hdr.tag = ATAG_MEM;
	params->hdr.size = tag_size (tag_mem32);

	params->u.mem.start = 0x20000000;
	params->u.mem.size = 0x20000000;

	params = tag_next (params);

	/* setp3: setup cmdline */
	params->hdr.tag = ATAG_CMDLINE;
	params->hdr.size =
		(sizeof (struct tag_header) + strlen (p) + 1 + 4) >> 2;
	strcpy (params->u.cmdline.cmdline, p);
	params = tag_next (params);

	/* setp4: setup end */
	params->hdr.tag = ATAG_NONE;
   	params->hdr.size = 0; 
}

int do_goimage (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	ulong	addr, rc;
	int     rcode = 0;
	
	if (argc < 2)
		return CMD_RET_USAGE;

	addr = simple_strtoul(argv[1], NULL, 16);
	
	printf("setup linux parameters at 0x20000100\n");
	setup_linux_tag(0x20000100);

	printf ("## Starting application at 0x%08lX ...args is 0x%081X\n", addr,gd->bd->bi_boot_params);

	rc = ((ulong(*)(int,int,uint))addr) (0,gd->bd->bi_arch_number,gd->bd->bi_boot_params);

	return rc;
}

U_BOOT_CMD(
	goimage, CONFIG_SYS_MAXARGS, 1,	do_goimage,
	"run linux kernel at address 'addr'",
	"addr [arg ...]\n    - linux kernel at address 'addr'\n"
	"      passing 'arg' as arguments"
);

#endif

U_BOOT_CMD(
	reset, 1, 0,	do_reset,
	"Perform RESET of the CPU",
	""
);
