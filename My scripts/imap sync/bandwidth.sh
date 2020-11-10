 A=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'} `  ; sleep 1 ; B=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'}` ; C=` expr $B - $A` ;echo $(($(($C / 1024 )) / 1024 )) "MB"
 A=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'} `  ; sleep 1 ; B=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'}` ; C=` expr $B - $A` ;echo $(($C / 1024 )) "KB"

A=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'} `  ; sleep 1 ; B=`netstat --interface=eth0 -e | grep 'TX b' | awk -F : {'print $3'} | awk {'print $1'}` ; C=` expr $B - $A` ;echo $C  "B"

