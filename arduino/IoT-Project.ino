#include <Servo.h> 
#include <FirebaseESP8266.h>
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <Keypad.h>   

//set ket noi Internaet
#define WIFI_SSID  "Abc"
#define WIFI_PASS "271Th103"


//setup Realtime data
#define FIREBASE_HOST "iot-esp8266-d1fde-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "QJQHLiLqYi73ufn0BohbBhThkDF5KWcsernhjnaC"
FirebaseData firebaseData;
String path = "/";
bool x = true;
FirebaseJson json;
int laserPin = A0;

// define device
const byte ROWS = 4; 
const byte COLS = 3; 
char keys[ROWS][COLS] = {
    {'1', '2', '3'}, {'4', '5', '6'}, {'7', '8', '9'}, {'*', '0', '#'}};
byte rowPins[ROWS] = {D0,D1,D2,D3};
byte colPins[COLS] = {D5,D6,D7};
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

Servo myServo;

// define pass

String STR = "****"; // Cài đặt mật khẩu tùy ý
String str = "++++";
bool stateDoor = true;
bool command = true;
int failTimes = 0;
int i, j, count = 0;
String Temp = "";
String Pass = "";
unsigned long Past=0;
unsigned long Current = 0;

// define path
void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID,WIFI_PASS);
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  Serial.println("IP address :");
  Serial.println(WiFi.localIP());
  // Offline
  myServo.attach(D4);
  keypad.begin(makeKeymap(keys));
  pinMode(laserPin, OUTPUT);
}

void loop() {
  //day du lieu
  char key = keypad.getKey();
    if(i==0){
    if(Firebase.getBool(firebaseData, path + "/stateDoor")) command = firebaseData.boolData();
  
      if(Firebase.getString(firebaseData, path + "/password")) {
        Pass = firebaseData.stringData();
        STR[0]=Pass[0];
        STR[1]=Pass[1];
        STR[2]=Pass[2];
        STR[3]=Pass[3];
      }
    if(Firebase.getString(firebaseData, path + "/tempPassword")) Temp=firebaseData.stringData();
    if(failTimes >= 3)  {Firebase.setString(firebaseData, path + "/warning","Co Nguoi dang co mo cua"+(String)failTimes+"lan");failTimes=0;
      digitalWrite(laserPin, HIGH);
      delay(3000);
      digitalWrite(laserPin, LOW);
    }

    if(command!=stateDoor){
        myServo.write(180);
        delay(1000);
        Serial.println("Door Open");
        Past = millis();
        stateDoor = 0;
        failTimes = 0;
        Firebase.setBool(firebaseData, path + "/stateDoor", stateDoor );
    }
  }
  if(stateDoor){
    if (key && key!='*') // Nhập mật khẩu
    { 
      if (i == 0) {
        str[0] = key;
        Serial.print(str[0]);
      }
      if (i == 1) {
        str[1] = key;
        Serial.print(str[1]);
      }
      if (i == 2) {
        str[2] = key;
        Serial.print(str[2]);
      }
      if (i == 3) {
        str[3] = key;
        Serial.print(str[3]);
        count = 1;
      }
      i = i + 1;
    }
    if (count == 1) {
      int wrongKey = 4 ;
      for ( int i=0; i<4;i++){
        if(str[i]==STR[i]||str[i]==Temp[i]) 
          wrongKey=wrongKey-1;
        }
      if (wrongKey==0){
        myServo.write(180);
        delay(1000);
        Serial.println("Door Open");
        stateDoor = 0;
        Firebase.setString(firebaseData, path + "/notification", str );
        Firebase.setBool(firebaseData, path + "/stateDoor", stateDoor );
        delay(1000);
        i = 0;
        count = 0;
        failTimes = 0;
      } 
      else {
        Serial.println("   Incorrect!");
        failTimes = failTimes +1;
        delay(1000);
        Serial.println(" Enter Password");
        i = 0;
        count = 0;
      }
    }
  } 
  else{
      i=0;
    if (key == '#') {
      myServo.write(0);
      delay(1000);
      Serial.println(" Door closed");
      stateDoor = 1;
      Firebase.setBool(firebaseData, path + "/stateDoor", stateDoor );
      Serial.println(" Enter Password");
      i = 0;
    }
    Current=millis();
    if(Current-Past>3000){
      myServo.write(0);
      delay(1000);
      Serial.println(" Door closed");
      stateDoor = 1;
      Firebase.setBool(firebaseData, path + "/stateDoor", stateDoor );
      Serial.println(" Enter Password");
      Past = Current;
      i = 0;
    }
    if (key == '*') {
      i=0;
      Serial.println("clear");
      delay(1000);
    }
  }
}


  