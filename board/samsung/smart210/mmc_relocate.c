/*
 *@Author:	Rocky
 *@Date:	2015-07-30
 *@Desc:	Use System copy sd to mem
*/

typedef unsigned char (*copy_sd_to_mem)(int channel,\
                unsigned int start_block,unsigned short block_num,\
                unsigned int *mem_ptr,unsigned int init);

void copy_code_to_dram(unsigned int dest,unsigned int src_sector,unsigned int size)
{
    unsigned int channel;
    copy_sd_to_mem BL2copy;
    unsigned int num;
    
    channel = *(volatile unsigned int *)(0xD0037488);
    BL2copy = (copy_sd_to_mem)(*(volatile unsigned int *)(0xD0037F98));
 #if 0
    if(channel == 0xEB000000){
        BL2copy(0,src_sector + 0  ,128,(unsigned char *)dest,0);
        BL2copy(0,src_sector + 128,128,(unsigned char *)dest + 0x10000,0);
        BL2copy(0,src_sector + 256,128,(unsigned char *)dest + 0x20000,0);
    }
 #endif

    if( (size>>9) < 65535){
        num = (int)(size>>9) + 1;
        BL2copy(0,src_sector,num,(unsigned char *)dest,0);
    }
 
}

