#! /bin/bash

# Auflistung aller Datei, die mit TODO gekennzeichnete Einträge enthalten:
echo "--------------------"
echo "Liste aller ToDos"
echo "--------------------"
grep --color=auto -r --exclude=${0##*/} TODO * 
echo "--------------------"
echo ""
echo "--------------------"
echo "Liste aller Infos"
echo "--------------------"
grep --color=auto -r --exclude=${0##*/} INFO * 
echo "--------------------"
echo ""
echo "--------------------"
echo "Wenn ein TODO bearbetet wurde, kann der entsprechende Eintrag umbenannt werden und wird dann nicht mehr gelistet."
echo "Ersetzen Sie in einer bearbeiteten Datei z.B. TODO durch DONE."
echo "--------------------"
echo ""
echo "--------------------"
echo "Erledigt"
echo "--------------------"
grep --color=auto -r --exclude=${0##*/} DONE * 
echo "--------------------"

