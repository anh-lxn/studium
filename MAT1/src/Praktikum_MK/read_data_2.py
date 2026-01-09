import serial
import csv
import time

ser = serial.Serial("COM3", 9600, timeout=1)  # COM-Port anpassen
time.sleep(2)  # Arduino Reset abwarten

with open("messung2.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Zeit_s", "RTD_dig", "T_Pt100_C"])
    f.flush()  # Header sofort schreiben

    print("Messung läuft – STRG+C zum Beenden")

    try:
        while True:
            line = ser.readline().decode(errors="ignore").strip()
            if not line:
                continue

            data = line.split(",")
            if len(data) == 3:
                writer.writerow(data)
                f.flush()          
                print(data)

    except KeyboardInterrupt:
        print("\nMessung beendet")

ser.close()
