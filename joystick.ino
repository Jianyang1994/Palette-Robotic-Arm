
int joyX = 0;
int joyY = 1;
int joyVal1;
int joyVal2;


void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
joyVal1 = analogRead(joyX);
joyVal2 = analogRead(joyY);
joyVal1= map(joyVal1,0,1023,-10,11);
joyVal2= map(joyVal2,0,1023,-10,11);

Serial.print(joyVal1);
Serial.print('|');
Serial.println(joyVal2);

delay(15);
}
