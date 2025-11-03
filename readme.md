# INFO

For a Dell Poweredge r420 using ipmitool and crontab  - changes fans based on sensor temperatures
----

THIS IS STATIC TEST SCRIPT, WITH AUTO FAILOVER AT ONE TEMPERATURE OF 75.  Testing if a static fan speed can maintain temps, and revert to auto, if it cant. 

# INFO

For a Dell Poweredge r420 using ipmitool and crontab  - changes fans based on sensor temperatures
----

#1 These commands work on a Dell r420 (different than the r710) I bet they work on most 12 gen Dell servers, not tested.

#2 I run this commands on a local machine, as opposed to it being remote.  Remote is more secure, but I have not exposed it to the internet at this time.

I would first find the codes that can set your fan speeds and modify this to suit your needs.

I used this to get Hex codes  
https://www.hexadecimaldictionary.com/hexadecimal/0xf/

This is the redit with info
https://www.reddit.com/r/homelab/comments/7xqb11/dell_fan_noise_control_silence_your_poweredge/


This one had some good advice
https://www.spxlabs.com/blog/2019/3/16/silence-your-dell-poweredge-server

Personal script. Feel free to modify and improve.

They are provided "as is", and I take no responsibility if they break something on your end. 
