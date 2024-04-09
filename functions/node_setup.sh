#!/bin/bash
#### Recall options
function nodeset {
    if [ $NODE_OPTION  == "1" ] 
    then 
    node="Simplex without Svxreflector"
    #* sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=SimplexLogic/g' /etc/svxlink/svxlink.conf
    #* sed -i 's/LINKS=/#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [ $NODE_OPTION  == "2" ] 
    then
    node="Simplex with Svxreflector"
    auth_key=$(whiptail --passwordbox "Please enter your SvxReflector Key" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
    #* sed -i 's/AUTH_KEY="GET YOUR OWN KEY"/AUTH_KEY="$auth_key"/g' /etc/svxlink/svxlink.conf 
    elif [ $NODE_OPTION  == "3" ] 
    then
    node="Repeater without Svxreflector"
    #* sed -i 's/set for SimplexLogic/set for RepeaterLogic/g' /etc/svxlink/svxlink.conf
    #* sed -i 's/LOGICS=SimplexLogic,ReflectorLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
    #* sed -i 's/LINKS=/#LINKS=/g' /etc/svxlink/svxlink.conf
    elif [ $NODE_OPTION  == "4" ] 
    then
    node="Repeater with Svxreflector"
    auth_key=$(whiptail --passwordbox "Please enter your SvxReflector Key" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
    
    #* sed -i 's/set for SimplexLogic/set for RepeaterLogic/g' /etc/svxlink/svxlink.conf
    #* sed -i 's/LOGICS=SimplexLogic/LOGICS=RepeaterLogic/g' /etc/svxlink/svxlink.conf
    #* sed -i 's/AUTH_KEY="GET YOUR OWN KEY"/AUTH_KEY="$auth_key"/g' /etc/svxlink/svxlink.conf 
    else    
    node="unset"
    fi
whiptail --title "Node" --msgbox "You have select node-type $node" 8 78 --defaultyes
## Time to change the node

##That's the Logics taken care of now we need to change the sound card settings 
output=$(aplay -l)

## Use grep to find the line containing the desired sound card
line=$(echo "$output" | grep "USB Audio")

## Extract the card number from the line
card_number=$(echo "$line" | awk '{print $2}' | tr -d ':')
whiptail --title "Sound Card" --msgbox "The USB soundcard is located at card $card_number." 8 78

## Use sed to replace the line with the new one even if there is no change

#* sed -i 's/AUDIO_DEV=alsa:plughw:0/AUDIO_DEV=alsa:plughw:$card_number/g' /etc/svxlink/svxlink.conf
## so even if it is '0' it is still '0'
## now we need to change the settings for COS and Squelch.
## We need to check if the Squelch is set to '1' or '0'
    ## if it is '1' then we need to change it to '0'
    ## if it is '0' then we need to change it to '1'
## we need to do this for both the Simplex and Repeater
## We need to check if the COS is set to '0' or '1'
    ## if it is '0' then we need to change it to '1'
    ## if it is '1' then we need to change it to '0'
    ## WE have three options
        ## 1. GPIOD on Transmit and Receive determined by $HID=false $GPIOD=true $card=false
        ## 2. HID on Transmit and GPIOD on Receive determined by $HID=true $GPIOD=true $card=true
        ## 3. HID on Transmit and Receive determined by $HID=true $GPIOD=false $card=true

if [ "$HID" == "false"] && [ "$GPIOD" == "true"] && [ "$card" == "false"]
    then
        ptt_direction=$(whiptail --title "PTT" --radiolist "Please select PTT direction" 8 78 3 \
        "High" "Transmit PTT is active-High" OFF \
        "Low" "Transmit PTT is active-Low" OFF 3>&1 1>&2 2>&3)
        ptt_pin=$(whiptail --title "PTT Pin" --radiolist "Please enter PTT Pin (gpio #)" 8 78 3\
            "gpio 23" "as PTT Pin" ON \
            "gpio 18" "as PTT Pin" OFF \
            "gpio 7" "as PTT Pin" OFF 3>&1 1>&2 2>&3)
        ptt_pin="${ptt_pin#"gpio "}"
            if [ "$ptt_direction" == "High" ] 
            then
            echo making changes
            #*     sed -i's/#PTT_TYPE=Hidraw/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
            #*     sed -i's/#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
            #*     sed -i's/#PTT_GPIOD_LINE=!24/PTT_GPIOD_LINE=$ptt_pin/g' /etc/svxlink/svxlink.conf
            
            elif [ "$ptt_direction" == "Low" ] 
            then
            echo making changes
            #*    sed -i's/#PTT_TYPE=Hidraw/PTT_TYPE=GPIOD/g' /etc/svxlink/svxlink.conf
            #*    sed -i's/#PTT_GPIOD_CHIP/PTT_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
            #*    sed -i's/#PTT_GPIOD_LINE=!24/PTT_GPIOD_LINE=!$ptt_pin/g' /etc/svxlink/svxlink.conf
            
            else 
            echo
            #noaction
            fi   
        cos_direction=$(whiptail --title "COS" --radiolist "Please select COS direction" 8 78 2 \
        "High" "Receive COS is active-High" OFF \
        "Low" "Receive COS is active-Low" OFF 3>&1 1>&2 2>&3)
        cos_pin=$(whiptail --title "COS Pin" --radiolist "Please enter COS Pin (gpio #)" 8 78 3 \
            "gpio 23" "as COS Pin" ON \
            "gpio 17" "as COS Pin" OFF \
            "gpio 8" "as COS Pin" OFF 3>&1 1>&2 2>&3)
            cos_pin="${cos_pin#"gpio "}"

            if [ "$cos_direction" == "High" ] 
            then
            echo making changes
            #*     sed -i's/#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
            #*     sed -i's/#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g' /etc/svxlink/svxlink.conf
            
            elif [ "$cos_direction" == "Low" ] 
            then
            echo making changes
            #*    sed -i's/#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
            #*    sed -i's/#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g' /etc/svxlink/svxlink.conf
        
            else 
             echo no action
            fi

##need to change the PTT and COS to GPIOD and all the statements to reflect this Unmodified SOundCard Unit - ask for GPIOD pins
elif [ "$HID" == "true"] && [ "$GPIOD" == "true" ] && [ "$card" == "true"]
then
    #*    sed -i's/#PTT_TYPE=Hidraw/PTT_TYPE=HID/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#HID_DEVICE=/HID_DEVICE=/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf


        cos_direction=$(whiptail --title "COS" --radiolist "Please select COS direction" 10 78 3 \
        "High" "Receive COS is active-High" OFF \
        "Low" "Receive COS is active-Low" OFF 3>&1 1>&2 2>&3)
        cos_pin=$(whiptail --title "COS Pin" --radiolist "Please enter COS Pin (gpio #)" 8 78 3\
            "gpio 23" "as COS Pin" ON \
            "gpio 17" "as COS Pin" OFF \
            "gpio 8" "as COS Pin" OFF 3>&1 1>&2 2>&3)
            cos_pin="${cos_pin#"gpio "}"
        ##need to change the PTT to HID and COS to GPIOD and all the statements to reflect this modified SoundCard Unit - ask for GPIOD pins
        if [ "$cos_direction" == "High"] 
        then
        echo making changes
    #*    sed -i's/#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=$cos_pin/g' /etc/svxlink/svxlink.conf
        
        elif [ "$cos_direction" == "Low"] 
        then
        echo making changes
    #*    sed -i's/#SQL_GPIOD_CHIP/SQL_GPIOD_CHIP/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#SQL_GPIOD_LINE=!23/SQL_GPIOD_LINE=!$cos_pin/g' /etc/svxlink/svxlink.conf
        
        fi
elif [ "$HID" == "true"] && [ "$GPIOD" == "false"] && [ "$card" == "true"] 
then
    #*    sed -i's/#PTT_TYPE=Hidraw/PTT_TYPE=HID/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#HID_DEVICE=/HID_DEVICE=/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#HID_PTT_PIN=GPIO3/HID_PTT_PIN=GPIO3/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#SQL_DET=GPIOD/SQL_TYPE=HIDRAW/g' /etc/svxlink/svxlink.conf
    #*    sed -i's/#HID_SQL_DET/HID_SQL_DET/g' /etc/svxlink/svxlink.conf
        if [ "$cos_direction" == "High" ] 
        then
        echo making changes
    #*    sed -i's/=VOL_DN/=VOL_UP/g' /etc/svxlink/svxlink.conf
        
        elif [ "$cos_direction" == "Low"]
        then
        echo no changes
        ##leave it as it is.
        else
        echo nothing done
        #no operations
        fi
fi
##need to change the PTT and COS to HID and all the statements to reflect this modified SoundCard Unit - ask for GPIOD pins




}

