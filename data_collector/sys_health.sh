#! /bin/bash

## CPU INFO ##
--------------
#total_cpu=$(cat /proc/cpuinfo | tail -50 | grep proc | awk '{ print $3 }')
#total_cpu=$(( total_cpu + 1 ))

# Get system values
total_cpu=$(grep -c ^processor /proc/cpuinfo)
current_sys_load=$(uptime | awk -F 'load average: ' '{ print $2 }' | cut -d ',' -f1)

# Print values 
echo "Total CPU = $total_cpu"
echo "Current System Load = $current_sys_load"

# Alert check
double_cpu=$((2*$total_cpu)) ## Use this to give headroom on load check
echo "Alert if ($double_cpu < $current_sys_load)"
alert_check=$( echo "$double_cpu < $current_sys_load" | bc)

# Test Alert Logic
if [ "$alert_check" -eq 1 ] ; then  ## -eq 1 tests if (1) True or (0) False
	echo "Alert showing high CPU / system utilization"
else
	echo "System performance is normal"
fi
