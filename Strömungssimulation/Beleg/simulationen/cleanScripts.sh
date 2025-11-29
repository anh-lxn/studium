#!/bin/bash

for d in wärmeübertrager_1 wärmeübertrager_2 wärmeübertrager_3; do
  echo "Starte $d ..."
  (cd "$d" && chmod +x Allclean && ./Allclean)
done
