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
  double x = (((double)value1) - 503) / 520;
  double y = (((double)value2) - 510) / 515;
  Serial.print(x/3);
  Serial.print(",");
  Serial.print(y/3);
  Serial.print(",");
  Serial.println(digitalRead(digital));
  delay(50);

}
