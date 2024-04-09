#!/bin/bash
node=""
function nodeoption {
    NODE_OPTION=$(whiptail --title "Svxlink" --menu "Please enter the type of node you want to use" 12 78 5 \
            "1" " Simplex Node without SvxReflector" \
            "2" " Simplex Node with SvxReflector" \
            "3" "Repeater Node without SvxReflector" \
            "4" "Repeater Node with SvxReflector" 3>&1 1>&2 2>&3)

    if [ "$NODE_OPTION" -eq 1 ]; then
        echo "You chose Simplex Node without SvxReflector"
    elif [ "$NODE_OPTION" -eq 2 ]; then
        echo "You chose Simplex Node with SvxReflector"
    elif [ "$NODE_OPTION" -eq 3 ]; then
        echo "You chose Repeater Node without SvxReflector"
    elif [ "$NODE_OPTION" -eq 4 ]; then
        echo "You chose Repeater Node with SvxReflector"
    else 
        echo "You did not choose anything"
fi
echo Node Option $NODE_OPTION
sleep 2
}
            
