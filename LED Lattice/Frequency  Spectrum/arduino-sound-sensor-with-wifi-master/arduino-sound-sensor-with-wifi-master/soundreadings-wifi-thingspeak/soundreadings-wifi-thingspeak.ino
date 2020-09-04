
const int sampleWindow = 50; // Sample window width in mS (50 mS = 20Hz)
unsigned int sample;
int soundValue;

void getSoundLevelReading() {
   unsigned long startMillis= millis();  // Start of sample window
   unsigned int peakToPeak = 0;   // peak-to-peak level
 
   unsigned int signalMax = 0;
   unsigned int signalMin = 1024;
 
   // collect data for 50 mS
   while (millis() - startMillis < sampleWindow)
   {
      sample = analogRead(0);
      if (sample < 1024)  // toss out spurious readings
      {
         if (sample > signalMax)
         {
            signalMax = sample;  // save just the max levels
         }
         else if (sample < signalMin)
         {
            signalMin = sample;  // save just the min levels
         }
      }
   }
   peakToPeak = signalMax - signalMin;  // max - min = peak-peak amplitude
   // Source to below code: https://forum.arduino.cc/index.php?topic=432991.0
   double volts = ((peakToPeak * 3.3) / 1024) * 0.707;  // convert to volts
   double first = log10(volts/0.00631)*20; // The microphone sensitivity is -44 ±2 so V RMS / PA is 0.00631
   double second = first + 10; // Adjusted value to microphone sensitivity
   soundValue = (int)second;

  Serial.println("SOUND VALUE:    ");
   Serial.print(soundValue);
   Serial.println("");
  }


void setup() {
  Serial.begin(115200);
}

void loop() {
sample = analogRead(0);
Serial.println(sample);
// getSoundLevelReading();
 delay(200);
}
