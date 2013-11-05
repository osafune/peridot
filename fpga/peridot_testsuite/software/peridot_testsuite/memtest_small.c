/**************************************************************************
 * This is a test program which tests RAM memory. 
 **************************************************************************/

#include <system.h>
#include <alt_types.h>
#include <io.h>
#include <altera_avalon_spi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sys/alt_stdio.h"
#include "system.h"


static int TestRam(void);

static int TestPio(void) {
	const int pionum = 13;	// D15とD14は省略 
	const int portoutbit[14] = {0, 27, 2, 25, 4, 23, 6, 21, 9, 19, 11, 17, 13, 15};
	const int portinbit[14] =  {7, 1, 26, 3, 24, 5, 22, 8, 20, 10, 18, 12, 16, 14};

	alt_u32 readbitmask = 0;
	alt_u32 portdir = 0;
	alt_u32 pattern, check;
	int i,j,a,b;

	for(i=0 ; i<pionum ; i++) portdir |= (1<<portoutbit[i]);
	IOWR(GPIO_0_BASE, 0, 0x00000000);	// 全ビット0出力 
	IOWR(GPIO_0_BASE, 1, portdir);		// PIO入出力方向設定 

	for(i=0 ; i<pionum ; i++) readbitmask |= (1<<portinbit[i]);

	printf("\nPIO test ");

	// '1'シフト 

	for(i=0 ; i<pionum ; i++) {
		pattern = (1<<portoutbit[i]);
		IOWR(GPIO_0_BASE, 0, pattern);
		IORD(GPIO_0_BASE, 0);	// ダミーリード 
		check = IORD(GPIO_0_BASE, 0) & readbitmask;

		for(j=0 ; j<pionum ; j++) {
			a = ((pattern & (1<<portoutbit[j])) != 0);
			b = ((check & (1<<portinbit[j])) != 0);

			if (a != b) {
				printf("\n[!] D%d - D%d path 1-shift error.\n\n",portoutbit[j],portinbit[j]);
				return -1;
			}
		}

		printf(".");
	}

	// '0'シフト 

	for(i=0 ; i<pionum ; i++) {
		pattern = ~(1<<portoutbit[i]);
		IOWR(GPIO_0_BASE, 0, pattern);
		IORD(GPIO_0_BASE, 0);	// ダミーリード 
		check = IORD(GPIO_0_BASE, 0) & readbitmask;

		for(j=0 ; j<pionum ; j++) {
			a = ((pattern & (1<<portoutbit[j])) == 0);
			b = ((check & (1<<portinbit[j])) == 0);

			if (a != b) {
				printf("\n[!] D%d - D%d path 0-shift error.\n\n",portoutbit[j],portinbit[j]);
				return -2;
			}
		}

		printf(".");
	}

	printf(" passed\n");
	printf("PIO at Okay\n");

	return 0;
}


static int TestEpcs(void) {
	alt_u8 writebuf[8];
	alt_u8 readbuf[8];

	writebuf[0] = 0xab;		// OPCODE 
	writebuf[1] = 0xff;		// dummy byte 
	writebuf[2] = 0xff;		// dummy byte 
	writebuf[3] = 0xff;		// dummy byte 

	alt_avalon_spi_command(
			EPCS_SPI_BASE, 0,
			4, writebuf,
			1, readbuf,
			0);

	printf("EPCS Silicon ID = 0x%02X\n", readbuf[0]);

	return 0;
}


int main(void)
{
	IOWR(LED_BASE, 0, 0);	// LED消灯 

	TestRam();

	TestPio();

	TestEpcs();

	IOWR(LED_BASE, 0, 1);	// LED点灯 
	while(1){}
}


/******************************************************************
*  Function: MemTestDataBus
*
*  Purpose: Tests that the data bus is connected with no 
*           stuck-at's, shorts, or open circuits.
*
******************************************************************/
static int MemTestDataBus(unsigned int address)
{
  unsigned int pattern;
  unsigned int ret_code = 0x0;

  /* Perform a walking 1's test at the given address. */
  for (pattern = 1; pattern != 0; pattern <<= 1)
  {
    /* Write the test pattern. */
    IOWR_32DIRECT(address, 0, pattern);

    /* Read it back (immediately is okay for this test). */
    if (IORD_32DIRECT(address, 0) != pattern)
    {
      ret_code = pattern;
      break;
    }
  }
  return ret_code;
}


/******************************************************************
*  Function: MemTestAddressBus
*
*  Purpose: Tests that the address bus is connected with no 
*           stuck-at's, shorts, or open circuits.
*
******************************************************************/
static int MemTestAddressBus(unsigned int memory_base, unsigned int nBytes)
{
  unsigned int address_mask = (nBytes - 1);
  unsigned int offset;
  unsigned int test_offset;

  unsigned int pattern     = 0xAAAAAAAA;
  unsigned int antipattern  = 0x55555555;

  unsigned int ret_code = 0x0;

  /* Write the default pattern at each of the power-of-two offsets. */
  for (offset = sizeof(unsigned int); (offset & address_mask) != 0; offset <<= 1)
  {
    IOWR_32DIRECT(memory_base, offset, pattern);
  }

  /* Check for address bits stuck high. */
  test_offset = 0;
  IOWR_32DIRECT(memory_base, test_offset, antipattern);
  for (offset = sizeof(unsigned int); (offset & address_mask) != 0; offset <<= 1)
  {
     if (IORD_32DIRECT(memory_base, offset) != pattern)
     {
        ret_code = (memory_base+offset);
        break;
     }
  }

  /* Check for address bits stuck low or shorted. */
  IOWR_32DIRECT(memory_base, test_offset, pattern);
  for (test_offset = sizeof(unsigned int); (test_offset & address_mask) != 0; test_offset <<= 1)
  {
    if (!ret_code)
    {
      IOWR_32DIRECT(memory_base, test_offset, antipattern);
      for (offset = sizeof(unsigned int); (offset & address_mask) != 0; offset <<= 1)
      {
        if ((IORD_32DIRECT(memory_base, offset) != pattern) && (offset != test_offset))
        {
          ret_code = (memory_base + test_offset);
          break;
        }
      }
      IOWR_32DIRECT(memory_base, test_offset, pattern);
    }
  }

  return ret_code;
}


/******************************************************************
*  Function: MemTest8_16BitAccess
*
*  Purpose: Tests that the memory at the specified base address
*           can be read and written in both byte and half-word 
*           modes.
*
******************************************************************/
static int MemTest8_16BitAccess(unsigned int memory_base)
{
  int ret_code = 0x0;

  /* Write 4 bytes */
  IOWR_8DIRECT(memory_base, 0, 0x0A);
  IOWR_8DIRECT(memory_base, 1, 0x05);
  IOWR_8DIRECT(memory_base, 2, 0xA0);
  IOWR_8DIRECT(memory_base, 3, 0x50);

  /* Read it back as one word */
  if(IORD_32DIRECT(memory_base, 0) != 0x50A0050A)
  {
    ret_code = memory_base;
  }

  /* Read it back as two half-words */
  if (!ret_code)
  {
    if ((IORD_16DIRECT(memory_base, 2) != 0x50A0) ||
        (IORD_16DIRECT(memory_base, 0) != 0x050A))
    {
      ret_code = memory_base;
    }
  }

  /* Read it back as 4 bytes */
  if (!ret_code)
  {
    if ((IORD_8DIRECT(memory_base, 3) != 0x50) ||
        (IORD_8DIRECT(memory_base, 2) != 0xA0) ||
        (IORD_8DIRECT(memory_base, 1) != 0x05) ||
        (IORD_8DIRECT(memory_base, 0) != 0x0A))
    {
    ret_code = memory_base;
    }
  }

  /* Write 2 half-words */
  if (!ret_code)
  {
    IOWR_16DIRECT(memory_base, 0, 0x50A0);
    IOWR_16DIRECT(memory_base, 2, 0x050A);

    /* Read it back as one word */
    if(IORD_32DIRECT(memory_base, 0) != 0x050A50A0)
    {
      ret_code = memory_base;
    }
  }

  /* Read it back as two half-words */
  if (!ret_code)
  {
    if ((IORD_16DIRECT(memory_base, 2) != 0x050A) ||
        (IORD_16DIRECT(memory_base, 0) != 0x50A0))
    {
      ret_code = memory_base;
    }
  }

  /* Read it back as 4 bytes */
  if (!ret_code)
  {
    if ((IORD_8DIRECT(memory_base, 3) != 0x05) ||
        (IORD_8DIRECT(memory_base, 2) != 0x0A) ||
        (IORD_8DIRECT(memory_base, 1) != 0x50) ||
        (IORD_8DIRECT(memory_base, 0) != 0xA0))
    {
      ret_code = memory_base;
    }
  }

  return(ret_code);
}


/******************************************************************
*  Function: MemTestDevice
*
*  Purpose: Tests that every bit in the memory device within the 
*           specified address range can store both a '1' and a '0'.
*
******************************************************************/
static int MemTestDevice(unsigned int memory_base, unsigned int nBytes)
{
  unsigned int offset;
  unsigned int pattern;
  unsigned int antipattern;
  unsigned int ret_code = 0x0;

  /* Fill memory with a known pattern. */
  for (pattern = 1, offset = 0; offset < nBytes; pattern++, offset+=4)
  {
    IOWR_32DIRECT(memory_base, offset, pattern);
  }

  printf(" .");

  /* Check each location and invert it for the second pass. */
  for (pattern = 1, offset = 0; offset < nBytes; pattern++, offset+=4)
  {
    if (IORD_32DIRECT(memory_base, offset) != pattern)
    {
      ret_code = (memory_base + offset);
      break;
    }
    antipattern = ~pattern;
    IOWR_32DIRECT(memory_base, offset, antipattern);
  }

  printf(" .");

  /* Check each location for the inverted pattern and zero it. */
  for (pattern = 1, offset = 0; offset < nBytes; pattern++, offset+=4)
  {
    antipattern = ~pattern;
    if (IORD_32DIRECT(memory_base, offset) != antipattern)
    {
      ret_code = (memory_base + offset);
      break;
    }
    IOWR_32DIRECT(memory_base, offset, 0x0);
  }
  return ret_code;
}

/******************************************************************
*  Function: TestRam
*
*  Purpose: Performs a full-test on the RAM specified.  The tests
*           run are:
*             - MemTestDataBus
*             - MemTestAddressBus
*             - MemTest8_16BitAccess
*             - MemTestDevice
*
******************************************************************/
static int TestRam(void)
{
  
  int memory_base, memory_end, memory_size;
  int ret_code = 0x0;

  /* Find out what range of memory we are testing */
	memory_base = SDRAM_BASE;
	memory_end = SDRAM_BASE + SDRAM_SPAN - 1;

  memory_size = (memory_end - memory_base);

  printf("\n");
  printf("Testing RAM from 0x%X to 0x%X\n", memory_base, (memory_base + memory_size));

  /* Test Data Bus. */
  ret_code = MemTestDataBus(memory_base);

  if (ret_code)
   printf(" -Data bus test failed at bit 0x%X", (int)ret_code);
  else
    printf(" -Data bus test passed\n");

  /* Test Address Bus. */
  if (!ret_code)
  {
    ret_code  = MemTestAddressBus(memory_base, memory_size);
    if  (ret_code)
      printf(" -Address bus test failed at address 0x%X", (int)ret_code);
    else
      printf(" -Address bus test passed\n");
  }

  /* Test byte and half-word access. */
  if (!ret_code)
  {
    ret_code = MemTest8_16BitAccess(memory_base);
    if  (ret_code)
      printf(" -Byte and half-word access test failed at address 0x%X", (int)ret_code);
    else
      printf(" -Byte and half-word access test passed\n");
  }

  /* Test that each bit in the device can store both 1 and 0. */
  if (!ret_code)
  {
    printf(" -Testing each bit in memory device.");
    ret_code = MemTestDevice(memory_base, memory_size);
    if  (ret_code)
      printf("  failed at address 0x%X", (int)ret_code);
    else
      printf("  passed\n");
  }


	if (!ret_code) {
		printf("Memory at 0x%X Okay\n", memory_base);
		return 0;
	} else {
		return -1;
	}
}



