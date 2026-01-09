/********************************************************************/ 
/* Name:           Praktikum Temperaturmessung, Sprungversuch       */
/* Version:        04.11.2022                                       */
/********************************************************************/ 

/********************************************************************/ 
/* Importierte Bibliotheken                                         */
/* Fehlende Biliotheken bitte nachinstallieren ueber:               */
/* Menu --> Werkzeuge --> Bilbiotheken verwalten                    */
/********************************************************************/
#include <Adafruit_MAX31865.h> // ggf. kein Syntaxhighlighting (schwarz)

/********************************************************************/ 
/* Pins festlegen                                                   */
/********************************************************************/ 
// Pin fuer den Taster:
const int Button = 2;
// Variable fuer Tasterzustand
int ButtonStatus = 0;
// Verwende Software SPI fuer zu kalibrierende Messung: 
int CS_PIN  = 10;
int DI_PIN  = 11;
int DO_PIN  = 12;
int CLK_PIN = 13;

/********************************************************************/ 
/* Initialisieren der Messwertaufnahme:                             */
/********************************************************************/ 
Adafruit_MAX31865 thermo = Adafruit_MAX31865(CS_PIN, DI_PIN, DO_PIN, CLK_PIN);


/********************************************************************/ 
/* Einrichtten der Referenzwerte fuer den PT100                     */
/********************************************************************/ 
// The value of the Rref resistor. Use 430.0 for PT100 and 4300.0 for PT1000
#define RREF      430.0
// The 'nominal' 0-degrees-C resistance of the sensor
// 100.0 for PT100, 1000.0 for PT1000
#define RNOMINAL  100.0

/********************************************************************/ 
/* Festlegen der Abtastrate und initialisieren der Messzeit         */
/********************************************************************/
float zeit = 0.0;
float intervall = 0.1; // in Sekunden

/********************************************************************/ 
/* Intialisierung des Arduino-Programms                             */
/********************************************************************/ 
void setup() {
  Serial.begin(9600);
  /*
  Serial.println("Mess- und Automatisierungstechnik");
  Serial.println("Praktikum Messkette und Fehlerrechnung");
  Serial.println();
  Serial.println("Hinweis:");
  Serial.println("Um die Darstellung im seriellen Monitor zu optimieren,\nist im nachfolgenden die Einheit [digit] als [dig.] abgekürzt!");
  Serial.println("Bitte beachten Sie dies bei der korrekten Darstellung Ihrer Ergebnisse!");
  Serial.println();
  Serial.print("Zeit \t");          // vergangene Zeit seit Betaetigung des Tasters
  Serial.print("u \t");      // Digitalwert
  Serial.println("T_nenn \t");    // Temperatur des unkalibrierten Pt100

  Serial.print("[s] \t");
  Serial.print("[dig.] \t");
  Serial.println("[°C] \t");
  */

  thermo.begin(MAX31865_2WIRE);
  // delay(1000);
  pinMode(Button, INPUT);
}

/********************************************************************/ 
/* Schleife des Arduino-Programms                                   */
/********************************************************************/ 
/*
void loop() {
  //Schaltzustand lesen
  ButtonStatus = digitalRead(Button);
  if (ButtonStatus == HIGH) {
      //start der Datenerfassung wenn Schalter gedrueckt wird
      while(1) {
      // Ausgabe der Messzeit:
      Serial.print(zeit); Serial.print(" \t");
      
      // PT100:
      uint16_t rtd = thermo.readRTD();
      float ratio = rtd;
      ratio /= 32768;
      Serial.print(rtd);
      Serial.print(" \t");
      Serial.println(thermo.temperature(RNOMINAL, RREF)); 
    
      // Messintervall:
      delay(intervall*1000);
      zeit = zeit + intervall;
      }
  }
}
*/

void loop() {
  ButtonStatus = digitalRead(Button);

  // Start der Datenerfassung bei Tastendruck
  if (ButtonStatus == HIGH) {

    // optional: kleine Entprellpause
    delay(200);

    while (1) {
      // Zeit
      Serial.print(zeit);
      Serial.print(",");

      // PT100 Rohwert
      uint16_t rtd = thermo.readRTD();
      Serial.print(rtd);
      Serial.print(",");

      // PT100 Temperatur
      Serial.println(thermo.temperature(RNOMINAL, RREF));

      // Messintervall
      delay(intervall * 1000);
      zeit += intervall;
    }
  }
}
