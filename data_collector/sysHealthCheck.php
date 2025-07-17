<?php

$data = [];

// ## DISK SPACE CHECK ##
echo "## DISK SPACE CHECK ## \n";
$remainingDiskSpace = shell_exec("df -h / | awk {'print $5'} | grep -vi 'use' | sed 's/%//g'");
//Remove New Line
$remainingDiskSpace = trim($remainingDiskSpace);

echo "Root Disk Space Used: " . $remainingDiskSpace . "% \n";
$data['rootDiskSpaceUsedPercent'] = intval($remainingDiskSpace);

// ## FREE MEM CHECK ##
echo "## FREE MEM CHECK ## \n";
// $totalMem = shell_exec("free -mh | grep -i mem | awk {' print $2 '} | sed 's/Gi//g'");
$totalMem = shell_exec("awk '/MemTotal/ {printf \"%.f \\n\", $2/1024/1024}' /proc/meminfo");
$totalMem = trim($totalMem);

//$freeMem = shell_exec("free -mh | grep -i mem | awk {' print $7 '} | sed 's/Gi//g'");
$freeMem = shell_exec("awk '/MemAvailable/ {printf \"%.f \\n\", $2/1024/1024}' /proc/meminfo");
$freeMem = trim($freeMem);

$memRatio = intval(($freeMem / $totalMem)*100);

echo "Total Mem: " . $totalMem . "GB \n";
echo "Free Mem: " . $freeMem . "GB \n";
echo "Mem Utilization: " . $memRatio . "%\n";
$data['memTotalGB'] = intval($totalMem);
$data['memFreeGB'] = intval($freeMem);
$data['memUtilization'] = $memRatio;


// ## CPU UTILIZATION ##
echo "## CPU UTILIZATION ## \n";
$cpuCores = shell_exec("nproc");
$cpuCores = trim($cpuCores);
$cpuUtilization = shell_exec("cut -d ' ' -f1 /proc/loadavg");
$cpuUtilization = trim($cpuUtilization);

echo "CPU Cores: " . $cpuCores . "\n";
echo "CPU Utilization(1min): " . $cpuUtilization . "\n";
$data['cpuCores'] = intval($cpuCores);
$data['cpuUtilization'] = floatval($cpuUtilization);

// ## SAVE ALL VALUES IN JSON ##
//var_dump($data);
echo "## SAVE ALL VALUES IN JSON ## \n";
file_put_contents("/tmp/healthcheck.json", json_encode($data, JSON_PRETTY_PRINT) . "\n");