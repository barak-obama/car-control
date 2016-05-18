int joyPin1 = 0;                 // slider variable connecetd to analog pin 0
int joyPin2 = 1;                 // slider variable connecetd to analog pin 1
int digital = 4;


void setup() {
  Serial.begin(9600);
  pinMode(digital, INPUT);
}

void loop() {
  int value1 = analogRead(joyPin1);
  int value2 = analogRead(joyPin2);
  Serial.print(value1);
  Serial.print(",");
  Serial.print(value2);
  Serial.print(",");
  Serial.println(digitalRead(digital));
  delay(1000);

}
