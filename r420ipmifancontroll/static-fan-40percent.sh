#!/bin/bash


#OBJECTIVE - Use ipmitool to deterine temperatures
#If temperature over variable set fan controll accordingly
#or enable/disable fan controll

# be sure IpmiTool is installed on your device

### commands to acess crontab and link to script
#notes nano /etc/crontab
#notes  crontab -u root -e



#### part one - SET VARIABLES 

# set CPU1 & CPU2 MAX TEMP
CPU1MAX=75
CPU2MAX=75



#### Part 2B
#I only used 2 temps for  both CPU's just as a safety mechanism in case
#somehow a CPU was running hotter than the inlet air tem, for some reason.
echo CPU1MAX "$CPU1MAX"
echo CPU2MAX "$CPU2MAX"



####Part 3

#this sets your fan speed, you may want to select different Hexadecimal codes
#based on your needs FS=FAN SPEED. My auto controll is

# Static fan speed - change this to test different speeds
# Start with 40% and adjust up/down based on temps and noise
# FS40 is 40% and so on.  FS60 is 60% etc
STATICFAN=$FS40

#Hex conversion https://www.mathsisfun.com/binary-decimal-hexadecimal-converter.html  
# type 40% as "40" into "decimal" box amd then add prefix of "0x"

FS60=0x3c
FS58=0x3a
FS56=0x38
FS54=0x36
FS52=0x34
FS50=0x32
FS48=0x30
FS46=0x2e
FS44=0x2c
FS42=0x2a
FS40=0x28
FS38=0x26
FS36=0x24
FS34=0x22
FS32=0x20
FS30=0x1e
FS28=0x1c
FS26=0x1a
FS24=0x18
FS22=0x16
FS20=0x14
FS18=0x12
FS16=0x10
FS14=0xe
FS12=0xc
FS10=0xa


#####Part 4

# This gets your temp numbers from IPMITOOL and sets them as a variable.
#Three temps.   ICPU1 & CPU2


TEMPCPU1=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 2p`
TEMPCPU2=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 3p`

echo " -- current temperature --"
echo CPU 1 TEMP     "$TEMPCPU1"  C
echo CPU 2 TEMP     "$TEMPCPU2"  C


# part 5 - FINALE - this pulls it all together. IF temp over X then issue fan controll to AUTO

echo "=== Setting fans to static 40% and starting monitoring ==="
# Set static fan speed first
ipmitool raw 0x30 0x30 0x01 0x00
ipmitool raw 0x30 0x30 0x02 0xff "$STATICFAN"
echo "Static fan set to 40%. Starting temperature monitoring..."

# Monitoring loop
while true; do
    # Get current temperatures
    TEMPCPU1=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 2p`
    TEMPCPU2=`ipmitool sdr type temperature | grep "Temp" | cut -d"|" -f5 | cut -d" " -f2 | sed -n 3p`

    echo "$(date): CPU1: ${TEMPCPU1}°C, CPU2: ${TEMPCPU2}°C"

    # Check if either CPU is over safety limit  
    if [[ "$TEMPCPU1" -gt "$CPU1MAX" || "$TEMPCPU2" -gt "$CPU2MAX" ]]; then
        ipmitool raw 0x30 0x30 0x01 0x01
        echo "SAFETY: CPU temp exceeded ${CPU1MAX}°C - reverted to auto fan control"
        echo "CPU1: ${TEMPCPU1}°C, CPU2: ${TEMPCPU2}°C"
        exit 1
    fi
    
    # Wait 30 seconds before next check
    sleep 30
done
