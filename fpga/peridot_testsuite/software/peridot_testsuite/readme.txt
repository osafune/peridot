/**************************************************************************
 * Copyright (c) 2009 Altera Corporation, San Jose, California, USA.      *
 * All rights reserved. All use of this software and documentation is     *
 * subject to the License Agreement located at the end of this file below.*
 *************************************************************************/
/**************************************************************************
 *
 * 
 * Description
 *************** 
 * This is a test program which tests RAM memory with small footprint. 
 *
 * 
 * Requirements
 ****************
 * This is a "Hosted" application. According to the ANSI C standard, hosted 
 * applications can rely on numerous system-services (including properly-
 * initialized device drivers and, in this case, STDOUT).  
 * 
 * When this program is compiled, code is added before main(), so that all 
 * devices are properly-initialized and all system-services (e.g. the <stdio>
 * library) are ready-to-use. In this hosted environment, all standard C 
 * programs will run.
 * 
 * A hosted application (like this example) does not need to concern itself 
 * with initializing devices. As long as it only calls C Standard Library 
 * functions, a hosted application can run "as if on a workstation."
 * 
 * An application runs in a hosted environment if it declares the function 
 * main(), which this application does.
 * 
 * This software example requires a STDOUT component such as a UART or 
 * JTAG UART and 2 RAM components (one for running
 * the program, and one for testing)
 *
 * Note: This example will not run on the Nios II Instruction Set Simulator
 
The memory footprint of this example has been reduced by making the
following changes to the normal "Memtest" example.
Check in the Nios II Software Developers Handbook for a more complete 
description.
 
In the SW Application project:
 - In the C/C++ Build page
    - Set the Optimization Level to -Os

In BSP project:
 - In the C/C++ Build page

    - Set the Optimization Level to -Os
 
    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
      This removes software exception handling, which means that you cannot 
      run code compiled for Nios II cpu with a hardware multiplier on a core 
      without a the multiply unit. Check the Nios II Software Developers 
      Manual for more details.

  - In the BSP:
    - Set Periodic system timer and Timestamp timer to none
      This prevents the automatic inclusion of the timer driver.

    - Set Max file descriptors to 4
      This reduces the size of the file handle pool.

    - Uncheck Clean exit (flush buffers)
      This removes the call to exit, and when main is exitted instead of 
      calling exit the software will just spin in a loop.

    - Check Small C library
      This uses a reduced functionality C library, which lacks  
      support for buffering, file IO, floating point and getch(), etc. 
      Check the Nios II Software Developers Manual for a complete list.

    - Check Reduced device drivers
      This uses reduced functionality drivers if they're available. For the
      standard design this means you get polled UART and JTAG UART drivers,
      no support for the LCD driver and you lose the ability to program 
      CFI compliant flash devices.
 * 
 * Peripherals Exercised by SW
 *******************************
 * The example's purpose is to test RAM.
 * 
 * The RAM test routine performs the following operations:
 * 1.) Tests the address and data lines for shorts and opens. 
 * 2.) Tests byte and half-word access.
 * 3.) Tests every bit in the memory to store both '1' and '0'. 
 *
 * IMPORTANT: The RAM test is destructive to the contents of the RAM.  For this
 * reason, you MUST assure that none of the software sections are located in 
 * the RAM being tested.  This requires that code, data, and exception 
 * locations must all be in a memory seperate from the one being tested.
 * These locations can be adjusted in Nios II Software Build Tools and SOPC Builder.
 *
 *  
 * During the test, status and error information is passed to the user via 
 * printf's.
 * 
 * Software Files
 ******************
 * memtest_small.c - Main C file that contains all memory testing code in this 
 *             example.
 * 
 **************************************************************************/
