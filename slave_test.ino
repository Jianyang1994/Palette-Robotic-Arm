
#include <Wire.h>
#define ENPIN 10
#define DIRPIN 11
#define STPPIN 12
#define MICROSTP 1
#define DEBUG 1
#define THIS_ADDRESS 0x02

//volatile boolean dir=HIGH;
volatile boolean EN = LOW;
volatile int curStp=0;

volatile int stpCont=0;
volatile int microSecDelay=0; //timeToComplete;
bool isFirstEvent =1;

void setEn(boolean en){
  EN = en;
  digitalWrite(ENPIN, en);
}

void setDir(boolean dir){
  //forward: HIGH 1; backward: LOW 0 
  dir=dir;
  digitalWrite(DIRPIN, dir);
}

void moveNStep(int stpCont, int microSecDelay){
  if(stpCont==0) return;
  setEn(LOW);
  setDir(stpCont>0);
  int increment = (stpCont>0 ? 1:-1);
  for(int i=0; i<abs(stpCont); i++){
    digitalWrite(STPPIN, HIGH);
    delay(1);
    digitalWrite(STPPIN, LOW);
    delay(microSecDelay);
    curStp += increment;
  }
}


void receiveEvent(int howMany) {
  isFirstEvent=!isFirstEvent;
  String mystr="";
  while (0 < Wire.available()) { // loop through all but the last
    char c = Wire.read(); // receive byte as a character
    mystr+=c;
  }

  if(isFirstEvent){
    stpCont = mystr.toFloat()/1.8*MICROSTP - curStp;
    Serial.println(mystr.toFloat());
  }else{
    microSecDelay = mystr.toFloat()*1e6 / stpCont;
  }
//  if(1 < Wire.available()){
//    stpCont = Wire.read() * MICROSTP - curStp;    // receive byte as an integer
//    microSecDelay = (unsigned long)(Wire.read()*1e3/40/stpCont);
//    Serial.print("stpCont: ");
//    Serial.println(stpCont);
//    Serial.print("microSecDelay: ");
//    Serial.println(microSecDelay);
//  }
}

void setup() {
  Wire.begin(0x02);                // join i2c bus with address #2
  //TWAR = (8 << 1) | 1;  // enable broadcasts to be received
  Wire.onReceive(receiveEvent); // register event
  Serial.begin(9600);           // start serial for output
  
  for(int i=0; i<13; i++){
    pinMode(i, OUTPUT);
  }
}

void loop() {

  
  // put your main code here, to run repeatedly:
  if(DEBUG) {
    Serial.print("stpCont: ");
    Serial.println(stpCont);
  }
  if(stpCont>MICROSTP){
    Serial.println("check");
    moveNStep(MICROSTP, microSecDelay);
  }else{
      //  Serial.println("check2");
    moveNStep(stpCont, microSecDelay);
  }
}
