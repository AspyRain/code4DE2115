#include <stdio.h>
#include "unistd.h"
#include "system.h"
#include "alt_types.h"
#include "altera_avalon_uart_regs.h"
#include "sys\alt_irq.h"

alt_u8 txdata=0;
alt_u8 rxdata=0;

//UART�жϷ�����
void IRQ_UART_Interrupts(){
	rxdata = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);//��rxdata�Ĵ����д洢��ֵ�������rxdata��
	txdata = rxdata;//�������շ���������rxdata��ֵ����txdata
	while(!(IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE)& ALTERA_AVALON_UART_STATUS_TRDY_MSK));
	//��ѯ����׼�������źţ����û��׼���ã���ȴ�
	IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE,txdata);//����׼���ã�����txdata
}

//�жϳ�ʼ������
void IRQ_init()
{
	//���״̬�Ĵ���
	IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0);
	//ʹ�ܽ���׼���жϣ������ƼĴ�����Ӧλд1
	IORD_ALTERA_AVALON_UART_CONTROL(UART_0_BASE);

	alt_ic_isr_register(
			UART_0_IRQ_INTERRUPT_CONTROLLER_ID,//ע��ISR
			UART_0_IRQ,//�жϿ�������ţ���system.h����
			IRQ_UART_Interrupts,//UART�жϷ�����
			0x0,//ָ�����豸����ʵ����ص����ݽṹ��
			0x0);//flags������δ��
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