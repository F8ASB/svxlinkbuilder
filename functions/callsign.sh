#!/bin/bash
function callsign {
get_CallVar() {
    call=$(whiptail --inputbox "Enter the node callsign:" 14 78 3>&1 1>&2 2>&3)
    echo "$call"
}


while true; do
    user_input=$(get_CallVar)
    
    # Check if input is empty
    if [ -z "$user_input" ]; then
        whiptail --msgbox "Node Callsign cannot be empty. Please try again." 14 78
    else
        # If input is not empty, break the loop
        break
    fi
done
CALL=${user_input^^}
# Use the non-empty name

	echo $(date) ${GREEN} *** Creating Node " $CALL " *** ${NORMAL} >> /var/log/install.log    
}