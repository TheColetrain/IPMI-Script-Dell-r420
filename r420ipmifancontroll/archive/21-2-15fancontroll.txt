#!/bin/bash


#OBJECTIVE - If temperature over variable enable/disable fan controll
# be sure IpmiTool is installed on your device


#notes nano /etc/crontab
#notes  crontab -u root -e


#### part one - only need to set HIGHTEMP to your choice - kicks in manual mode
#all other temps auto set
HIGHTEMP=26
# you may set #INC = Increment to other than 1 if you want a step-down by more than 1
INC=1
# set CPU1 & CPU2 MAX TEMP
CPU1MAX=50
CPU2MAX=49

###part 2A
echo HIGHTEMP "$HIGHTEMP"

HIGHTEMP2=$((HIGHTEMP - INC))
echo HIGHTEMP2 "$HIGHTEMP2"

HIGHTEMP3=$((HIGHTEMP2 - INC))
echo HIGHTEMP3 "$HIGHTEMP3"

HIGHTEMP4=$((HIGHTEMP3 - INC))
echo HIGHTEMP4 "$HIGHTEMP4"

HIGHTEMP5=$((HIGHTEMP4 - INC))
echo HIGHTEMP5 "$HIGHTEMP5"

HIGHTEMP6=$((HIGHTEMP5 - INC))
echo HIGHTEMP6 "$HIGHTEMP6"


#### Part 2B
#I only used 2 temps for  both CPU's just as a safety mechanism in case
#somehow a CPU was running hotter than the inlet air tem, for some reason.
echo CPU1MAX "$CPU1MAX"
echo CPU2MAX "$CPU2MAX"

#you can change the last# if you want a different CPU threshold for step 2 of CPUTEMP
#didnt do the math like above

CPU1MAX2=$((CPU1MAX - 1))
CPU2MAX2=$((CPU2MAX - 1))
CPU1MAX3=$((CPU2MAX - 2))
CPU2MAX3=$((CPU2MAX - 2))

echo CPU1MAX2 "$CPU1MAX2"
echo CPU2MAX2 "$CPU2MAX2"
echo CPU1MAX3 "$CPU1MAX3"
echo CPU2MAX3 "$CPU2MAX3"

####Part 3

#this sets your fan speed, you may want to select different Hexadecimal codes
#based on your needs FS=FAN SPEED. My auto controll is
#set to 30% min, this works for me.

FS22=0x16
FS20=0x14
FS18=0x12
FS16=0x10
FS14=0xe
FS12=oxc
FS10=0xa

#####Part 4

# This gets your temp numbers from IPMITOOL and sets them as a variable.
#Three temps.   INLET TEMP, CPU1 & CPU2

TEMPINLET=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 1p`
TEMPCPU1=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 2p`
TEMPCPU2=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 3p`

echo " -- current temperature --"
echo INLET AIR TEMP "$TEMPINLET" C
echo CPU 1 TEMP     "$TEMPCPU1"  C
echo CPU 2 TEMP     "$TEMPCPU2"  C


# part 5 - FINALE - this pulls it all together. IF temp over X then issue fan controll

if [[ "$TEMPINLET" > "$HIGHTEMP" ||
      "$TEMPCPU1" > "$CPU1MAX" ||
      "$TEMPCPU2" > "$CPU2MAX" ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x01
    echo "enable dynamic fan control"


#22
elif [[ "$TEMPINLET" > "$HIGHTEMP2"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS22"
    echo "-->Set fan's to 22%"

#20
elif [[ "$TEMPINLET" > "$HIGHTEMP3" ||
        "$TEMPCPU1" > "$CPU1MAX2" ||
        "$TEMPCPU1" > "$CPU2MAX2"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS20"
    echo "--> Set fan's to 20%"


#18
elif [[ "$TEMPINLET" > "$HIGHTEMP4"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS18"
    echo "--> Set fan's to 18%"

#16
elif [[ "$TEMPINLET" > "$HIGHTEMP5"  ||
        "$TEMPCPU1" > "$CPU1MAX3" ||
        "$TEMPCPU1" > "$CPU2MAX3"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS16"
    echo "--> Set fan's to 16%"


#14
elif [[ "$TEMPINLET" > "$HIGHTEMP5"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "FS14"
    echo "--> Set fan's to 14%"

#12
elif [[ "$TEMPINLET" > "$HIGHTEMP5"  ]]
  then
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS12"
    echo "--> Set fan's to 12%"


#anything less is 10
  else
    ipmitool raw 0x30 0x30 0x01 0x00
    ipmitool raw 0x30 0x30 0x02 0xff "$FS10"
    echo "--> Set fan's to 10%"

fi
