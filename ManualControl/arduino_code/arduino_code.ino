int joyPin1 = 0;                 // slider variable connecetd to analog pin 0
int joyPin2 = 1;                 // slider variable connecetd to analog pin 1
int digital = 4;


void setup() {
  Serial.begin(9600);
  pinMode(digital, INPUT);
}

void loop() {
  int x = analogRead(joyPin1);
  int y = analogRead(joyPin2);
  Serial.println(String(x) + "," + String(y) + ","+String(digitalRead(digital), BIN));
  delay(50);

}
