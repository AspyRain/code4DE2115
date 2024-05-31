#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
const alt_u8
led_data[4]={0x01,0x03,0x07,0x0F};
int main (void) {
 int count=0;
 alt_u8 led;
 volatile int i;
 while (1)
  {
 	 if (count==4)
 	 {
 		 count=0;
 	 }
 	 else
 	 {
 		 count++;
 	 }
 	 led=led_data[count];
 	 IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, led);
 	 //—” ±µƒ…Ë÷√
 	 i = 0;
 	 while (i<5000000)
 		 i++;
   }
 return 0;
}
