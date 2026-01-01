#include <mega16a.h>
#include <alcd.h>
#include <delay.h>

int i=0 , xy=0 , k=0;
int Temp_Pass_1=0 , Temp_Pass_2=0 ,  Temp_Pass_3=0 ,  Temp_Pass_4=0 ;
#define Buzzer_Pin            PORTC.7
#define LED_Green_ON          PORTA.0=1
#define LED_Green_OFF         PORTA.0=0 
#define LED_Red_ON            PORTA.1=1
#define LED_Red_OFF           PORTA.1=0 
#define LED_Yellow_ON         PORTA.2=1
#define LED_Yellow_OFF        PORTA.2=0 
#define LED_Blue_ON           PORTA.3=1
#define LED_Blue_OFF          PORTA.3=0 
#define Relay_ON              PORTD.5=1
#define Relay_OFF             PORTD.5=0 

int Check = 0 ;
int Check_Pin_Last = 0 ; 
int key_pad(void)     
{
PORTC.3=1;PORTC.4=1;PORTC.5=1;PORTC.6=0;   
if(!PINC.0) return 3;
if(!PINC.1) return 2;
if(!PINC.2) return 1;
PORTC.3=1;PORTC.4=1;PORTC.5=0;PORTC.6=1;   
if(!PINC.0) return 6;
if(!PINC.1) return 5;
if(!PINC.2) return 4;
PORTC.3=1;PORTC.4=0;PORTC.5=1;PORTC.6=1;   
if(!PINC.0) return 9;
if(!PINC.1) return 8;
if(!PINC.2) return 7;
PORTC.3=0;PORTC.4=1;PORTC.5=1;PORTC.6=1;   
if(!PINC.1) return 0;
if(!PINC.2) return 10;
return 12;
}
 
void lcd(int key)
{
if(key==1) lcd_putsf("1");
if(key==2) lcd_putsf("2");
if(key==3) lcd_putsf("3");
if(key==4) lcd_putsf("4");
if(key==5) lcd_putsf("5");
if(key==6) lcd_putsf("6");
if(key==7) lcd_putsf("7");
if(key==8) lcd_putsf("8");
if(key==9) lcd_putsf("9");
if(key==0) lcd_putsf("0");
if(key==10) 
{
    xy=0;
    lcd_clear();
}
 
}
void Beep (int N , int d1 , int d2 );
void LED_Light (int numbers);
void Beep (int N , int d1 , int d2 )
{
for ( i=1 ; i<=N ; i++ ) 
{
Buzzer_Pin=1;
delay_ms(d1);
Buzzer_Pin=0;
delay_ms(d2);
}


}
void LED_Light (int numbers)
{
for ( i=0 ; i<=numbers ; i++ )
{
LED_Green_ON;
delay_ms(50);
LED_Red_ON;
delay_ms(50);
LED_Yellow_ON;
delay_ms(50);
LED_Blue_ON;
delay_ms(50);
LED_Green_OFF;
delay_ms(50);
LED_Red_OFF;
delay_ms(50);
LED_Yellow_OFF;
delay_ms(50);
LED_Blue_OFF;
delay_ms(50);
}

}
void Effect_name_Start (void);
void Effect_name_Start (void)
{

Beep(10,30,30);
lcd_gotoxy(0,0);
lcd_puts("  Final Project ");
lcd_gotoxy(0,1);
lcd_puts("Hamian Ghazipoor");
delay_ms(2000);
lcd_clear();
delay_ms(500);
lcd_gotoxy(0,0);
lcd_puts("  Final Project ");
lcd_gotoxy(0,1);
lcd_puts("Hamian|Ghazipoor");
delay_ms(2000);
}

void main(void)
{
int key=13 ;
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);


lcd_init(16);
xy=0;
lcd_clear();
Effect_name_Start();
LED_Light(4);
lcd_clear();
 

     while (1) {           
        if (PIND.3 == 0) {    
        Check = 0 ;         
        }     
        if (PIND.3 == 1) {    
        Check = 1 ;         
        }   
        if ( Check != Check_Pin_Last )   
        {
        lcd_clear();    
        Check_Pin_Last = Check ;   
        }
        if (PIND.3 == 0) {     
          lcd_gotoxy(0,0);
          lcd_puts("   attention!   ");    
          lcd_gotoxy(0,1);
          lcd_puts("Message received");    
          Beep(3,300,300); 
          LED_Light(4);        
          delay_ms(1000);
          lcd_clear(); 
          while(1)
          {  
          lcd_gotoxy(0,0);
          lcd_puts("Press the key 1");    
          key=key_pad();
          if ( key == 1 ) 
          {           
            Beep(10,50,50);
            break;            
          }               
          if ( key != 1 && key != 12 ) 
          {     
            lcd_clear();      
            lcd_gotoxy(0,0);
            lcd_puts("Button 1 has not");        
            lcd_gotoxy(0,1);
            lcd_puts("been pressed");               
            Beep(3,100,100);    
            delay_ms(3000);     
            lcd_clear();
           }          
          }
        } 
        if (PIND.3 == 1) {
          lcd_gotoxy(0,0);
          lcd_puts("  Waiting for  ");       
          lcd_gotoxy(0,1);
          lcd_puts("    message!    ");          
        }                
        
    }
