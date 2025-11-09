import CoolProp.CoolProp as CP

import CoolProp.CoolProp as CP

def get_saturation_properties(T=None, p=None, fluid="Water", display=False, return_value=None):
    """
    Sättigungseigenschaften (Flüssig ' / Dampf '') für Wasser nach IF97 mittels CoolProp.
    Eingabe:
      - T [°C]
      - p [Pa]
    Rückgabe:
      - Dictionary mit den Sättigungseigenschaften oder einzelner Wert, wenn 'return_value' angegeben ist.
      - display=True: Ausgabe der Werte in tabellarischer Form.
    """

    props = {}

    if T is None and p is None:
        raise ValueError("Bitte entweder Temperatur (T) oder Druck (p) angeben.")

    # --- Wenn T gegeben ist ---
    if T is not None:
        T_K = T + 273.15
        ps = CP.PropsSI("P", "T", T_K, "Q", 0, fluid)

        props["T [°C]"] = T
        props["ps [Pa]"] = ps

        for phase, Q in [("'", 0), ("''", 1)]:
            props[f"v{phase} [m³/kg]"] = 1 / CP.PropsSI("D", "T", T_K, "Q", Q, fluid)
            props[f"u{phase} [kJ/kg]"] = CP.PropsSI("U", "T", T_K, "Q", Q, fluid) / 1000
            props[f"h{phase} [kJ/kg]"] = CP.PropsSI("H", "T", T_K, "Q", Q, fluid) / 1000
            props[f"s{phase} [kJ/(kgK)]"] = CP.PropsSI("S", "T", T_K, "Q", Q, fluid) / 1000

    # --- Wenn p gegeben ist ---
    elif p is not None:
        Ts = CP.PropsSI("T", "P", p, "Q", 0, fluid)
        props["p [Pa]"] = p
        props["Ts [°C]"] = Ts - 273.15

        for phase, Q in [("'", 0), ("''", 1)]:
            props[f"v{phase} [m³/kg]"] = 1 / CP.PropsSI("D", "P", p, "Q", Q, fluid)
            props[f"u{phase} [kJ/kg]"] = CP.PropsSI("U", "P", p, "Q", Q, fluid) / 1000
            props[f"h{phase} [kJ/kg]"] = CP.PropsSI("H", "P", p, "Q", Q, fluid) / 1000
            props[f"s{phase} [kJ/(kgK)]"] = CP.PropsSI("S", "P", p, "Q", Q, fluid) / 1000

    # --- Ausgabe formatieren ---
    if display:
      if T is not None:
        order = [
            "T [°C]", "ps [Pa]",
            "v' [m³/kg]", "v'' [m³/kg]",
            "u' [kJ/kg]", "u'' [kJ/kg]",
            "h' [kJ/kg]", "h'' [kJ/kg]",
            "s' [kJ/(kgK)]", "s'' [kJ/(kgK)]"
        ]
      elif p is not None:
        order = [
            "p [Pa]", "Ts [°C]",
            "v' [m³/kg]", "v'' [m³/kg]",
            "u' [kJ/kg]", "u'' [kJ/kg]",
            "h' [kJ/kg]", "h'' [kJ/kg]",
            "s' [kJ/(kgK)]", "s'' [kJ/(kgK)]"
        ]

      headers = [h for h in order if h in props]
      values = [props[h] for h in headers]

      col_width = 13  # feste Breite für Spalten

      # --- Header ---
      print(" | ".join(f"{h:>{col_width}s}" for h in headers))
      print("-" * (len(headers) * (col_width + 3)))

      # --- Werte ---
      line = []
      for h, v in zip(headers, values):
          if "MPa" in h:
              line.append(f"{v:{col_width}.5f}")
          elif "v''" in h:
              line.append(f"{v:{col_width}.5f}")
          elif "v'" in h:
              line.append(f"{v:{col_width}.7f}")
          elif "u" in h or "h" in h:
              line.append(f"{v:{col_width}.2f}")
          elif "s" in h:
              line.append(f"{v:{col_width}.4f}")
          else:
              line.append(f"{v:{col_width}.2f}")

      print(" | ".join(line))

    # --- Einzelwert zurückgeben ---
    if return_value is not None:
      # Versuche exakten Key zuerst
      if return_value in props:
          return props[return_value]
      # Falls nicht vorhanden, suche nach Teilstring (z. B. "v'" in "v' [m³/kg]")
      for key in props.keys():
          if return_value in key:
              return props[key]
      # Wenn nichts gefunden wurde:
      raise KeyError(f"'{return_value}' wurde in den berechneten Werten nicht gefunden.")



