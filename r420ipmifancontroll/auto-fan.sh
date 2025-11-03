#!/bin/bash
# Simple auto fan control for Dell R420
echo "Setting fans to automatic control..."
ipmitool raw 0x30 0x30 0x01 0x01
echo "Fans set to auto - system will control speed based on temperature"
