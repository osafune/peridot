/* ILI9325 Driver */
#ifndef __egl_lcd_driver_
#define __egl_lcd_driver_

#include <alt_types.h>

void Trans_Dat(unsigned int , unsigned int );
void ILI9325_init(void);
void ILI9325_updatefb(const alt_u16 *);

#endif
