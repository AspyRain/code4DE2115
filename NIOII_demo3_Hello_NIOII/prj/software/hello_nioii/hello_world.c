#include <stdio.h>
#include "unistd.h"
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys\alt_irq.h"

alt_u8 txdata=0;
alt_u8 rxdata=0;

//UART中断服务函数
void IRQ_UART_Interrupts(){
	rxdata = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);//将rxdata寄存器中存储的值读入变量rxdata中
	txdata = rxdata;//串口自收发，将变量rxdata的值赋给txdata
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	//查询发送准备接收信号，如果没有准备好，则等待
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,txdata);//发送准备好，发送txdata
}

//中断初始化函数
void IRQ_init()
{
	//清除状态寄存器
	IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0);
	//使能接收准备中断，给控制寄存器相应位写1
	IORD_ALTERA_AVALON_UART_CONTROL(UART_0_BASE);

	alt_ic_isr_register(
			UART_0_IRQ_INTERRUPT_CONTROLLER_ID,//注册ISR
			UART_0_IRQ,//中断控制器标号，从system.h复制
			IRQ_UART_Interrupts,//UART中断服务函数
			0x0,//指向与设备驱动实例相关的数据结构体
			0x0);//flags，保留未用
}

int main()
{
  while(1){
	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, "hello world!\n");
	  int i=0;
	  while(i<5000)
	  {
		  i++;
	  }
  }
  IRQ_init();
  while(1);
  return 0;
}
