/********************************************************************/
/* Name:           Praktikum Temperaturmessung, Kalibration         */
/* Version:        04.11.2022                                       */
/********************************************************************/

/********************************************************************/
/* Importierte Bibliotheken                                         */
/* Fehlende Biliotheken bitte nachinstallieren ueber:               */
/* Menu --> Werkzeuge --> Bilbiotheken verwalten                    */
/********************************************************************/
#include <Adafruit_MAX31865.h> // ggf. kein Syntaxhighlighting (schwarz)
#include <OneWire.h>
#include <DallasTemperature.h>

/********************************************************************/
/* Pins festlegen                                                   */
/********************************************************************/
// Pin fuer die Referenztemperatur:
int ONE_WIRE_BUS = 2;
// Verwende Software SPI fuer zu kalibrierende Messung:
int CS_PIN  = 10;
int DI_PIN  = 11;
int DO_PIN  = 12;
int CLK_PIN = 13;

/********************************************************************/
/* Initialisieren der Messwertaufnahme:                             */
/********************************************************************/
Adafruit_MAX31865 thermo = Adafruit_MAX31865(CS_PIN, DI_PIN, DO_PIN, CLK_PIN);
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

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
float intervall = 5; // in Sekunden

/********************************************************************/
/* Intialisierung des Arduino-Programms                             */
/********************************************************************/
void setup() {
  Serial.begin(9600);
  sensors.begin();
  /*
  Serial.println("Mess- und Automatisierungstechnik");
  Serial.println("Praktikum Messkette und Fehlerrechnung");
  Serial.println();
  Serial.println("Hinweis:");
  Serial.println("Um die Darstellung im seriellen Monitor zu optimieren,\nist im nachfolgenden die Einheit [digit] als [dig.] abgekürzt!");
  Serial.println("Bitte beachten Sie dies bei der korrekten Darstellung Ihrer Ergebnisse!");
  Serial.println();
  Serial.print("Zeit \t");              // Messzeit
  Serial.print("T_ref \t");             // Temperatur des Referenzthermistors
  Serial.print("u \t");                 // Digitalwert
  Serial.println("T_nenn \t");            // Temperatur des unkalibrierten Pt100

  Serial.print("[s] \t");
  Serial.print("[°C] \t");
  Serial.print("[dig.] \t");
  Serial.println("[°C]");
  */

  thermo.begin(MAX31865_2WIRE);
  // delay(1000);
}

/********************************************************************/
/* Schleife des Arduino-Programms                                   */
/********************************************************************/
/*
void loop() {
  // Ausgabe der Messzeit:
  Serial.print(zeit); Serial.print(" \t");

  // Referenzthermistor:
  sensors.requestTemperatures();
  Serial.print (sensors.getTempCByIndex(0)); Serial.print(" \t");

  // PT100:
  uint16_t rtd = thermo.readRTD();
  float ratio = rtd;
  ratio /= 32768;                           //Zusatzinformation heir nicht benötigt
  
  Serial.print(rtd);
  //Serial.print(" \t");
  Serial.print(" \t");
  Serial.println(thermo.temperature(RNOMINAL, RREF)); 


  // Messintervall:
  delay(intervall * 1000);
  zeit = zeit + intervall;
}
*/

void loop() {
  // Ausgabe der Messzeit
  Serial.print(zeit);
  Serial.print(",");

  // Referenzthermistor
  sensors.requestTemperatures();
  Serial.print(sensors.getTempCByIndex(0));
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
