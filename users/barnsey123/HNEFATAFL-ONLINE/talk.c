#include "stdlib.h"
#include "oric.h"

unsigned char* ACIA = (unsigned char*)0x31c;
unsigned char* VIA = (unsigned char*)0x300;

extern void irq_handler(void);
extern char* clockptr;
extern char started;

unsigned char buffer[256];
unsigned char hundredths=100;
unsigned char put_ptr, get_ptr;

my_handler() {
  if (ACIA[1]&0x80) {
    if (ACIA[1]&8) buffer[put_ptr++]=ACIA[0];
  } else if ((VIA[13]&0x40) && started) {
    hundredths--;
    if (hundredths==0) {
      hundredths=100;
      if (clockptr[3]-- == '0') {
        clockptr[3]='9';
        if (clockptr[2]-- == '0') {
          clockptr[2]='5';
          if (clockptr[0]-- == '0') {
            clockptr[0]='9';
            ping();
          }
        }
      }
    }
  }
}


char receive_char(void) {
  if (put_ptr!=get_ptr) return buffer[get_ptr++];
  else return -1;
}

char wait_char(void) {
  while (put_ptr==get_ptr);
  return buffer[get_ptr++];
}

void send_char(char c) {
  while(!(ACIA[1]&0x10));
  ACIA[0]=c;
}

int carrier_detect() {
  return (ACIA[1]&0x20)==0;
}

void set_dtr() {
  ACIA[2]=ACIA[2]&0xFE | 1;
}

void init_comm() {
  chain_irq_handler(my_handler);
  ACIA[3]=0x3E; /* 9600 baud, 1 stop bit, 7 data bits */
  ACIA[2]=0x68; /* even parity, DTR=0, RTS=1 */
}

void end_comm() {
  ACIA[2]=0x60;
}
