#include <Wire.h>
const int I2C_slave_address[] = {0x02, 0x03,0x04,0x05};
#define I2C_master_address 0x01
#define I2C_broadcast_address 0x00
#define DEBUG 0


String cmd[]={"","","","","",""};// theta1, theta2, theta3, theta4, t, suction

void serialPrintCommand(){
  for(int i=0; i<6; i++){
    Serial.print(cmd[i]);
    Serial.print(',');
  }
  Serial.println();
}
///

void serialReceiveCommand(){
  String mystr = Serial.readString();
  int lastIndex=0;
  int cmdIndex=0;
  int strLen = mystr.length();
  
  for(int i=0; i<strLen; i++){
    if(mystr.charAt(i)==',' || mystr.charAt(i)=='\n'){
      String subStr = mystr.substring(lastIndex, i);
      cmd[cmdIndex] = subStr;
      Serial.print("received str: ");
      Serial.println(cmd[cmdIndex]);
      lastIndex = i+1;
      cmdIndex++;
    }
  }
}
///

//String DegToPulse(float angle){
//  return (int)(angle/1.8+0.5);
//}


void scan_I2C_address(){
  byte error, address;
  int nDevices;

  Serial.println("Scanning...");

  nDevices = 0;
  for(address = 2; address < 6; address++ ) 
  {
    // The i2c_scanner uses the return value of
    // the Write.endTransmisstion to see if
    // a device did acknowledge to the address.
    Wire.beginTransmission(address);
    error = Wire.endTransmission();
    Serial.print("error: ");
    Serial.println(error);

    if (error == 0)
    {
      Serial.print("I2C device found at address 0x");
      if (address<16) 
        Serial.print("0");
      Serial.print(address,HEX);
      Serial.println("  !");

      nDevices++;
    }
    else if (error==4) 
    {
      Serial.print("Unknown error at address 0x");
      if (address<16) 
        Serial.print("0");
      Serial.println(address,HEX);
    }    
  }
  if (nDevices == 0)
    Serial.println("No I2C devices found\n");
  else
    Serial.println("done\n");

  delay(5000);           // wait 5 seconds for next scan
}




void I2C_SendToSlave(){
  byte error, address;
  int i=0;
  for(address =2; address < 6; address++){
    Wire.beginTransmission(address);
    
    if(DEBUG) Serial.println(address);
    
    error = Wire.endTransmission();
    
    if(DEBUG) Serial.println(error);
    
    if(error==0){ 
      Wire.beginTransmission(I2C_slave_address[i]);
      Wire.write(cmd[i].c_str());//angle  
      Wire.write(",");//sepration mark 
      if(DEBUG){
        Serial.print("serial test!!: ");
        Serial.println(cmd[i].c_str());
      }
      
      Wire.write(cmd[4].c_str());//time in millisec
      Wire.endTransmission();
      
    }else if(error==2){
      Serial.print("cannot connect to ");
      Serial.println(address);
    }
    i++;
  }
}

void setup() {
  Wire.begin();
  Serial.begin(9600);
  while(!Serial);
}
///


void loop() {
  if(Serial.available()) {
    serialReceiveCommand();
    //delay(100);
    if(DEBUG) serialPrintCommand();
    delay(100);
    I2C_SendToSlave();
  //  scan_I2C_address();  
  }
}
