#!/bin/bash
architecture=$(uname -a);
# CPU
pCPU=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l);
vCPU=$(grep "^processor" /proc/cpuinfo | wc -l);
# RAM
total_ram=$(free -m | awk '$1 == "Mem:" {print $2}');
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}');
pourcent_ram=$(awk "BEGIN {printf \"%.2f\", ($used_ram / $total_ram) * 100}");
# DISK
total_disk=$(df -BG | grep "^/dev/" | grep -v "/boot$" | awk '{size_total += $2} END {print size_total}');
used_disk=$(df -BM | grep "^/dev/" | grep -v "/boot$" | awk '{size_used += $3} END {print size_used}');
pourcent_disk=$(df -BM | grep "^/dev/" | grep -v "/boot$" | awk '{size_total += $2} {size_used += $3} END {printf("%d"), (size_used/size_total)*100}');
# CPU LOAD
cpu_load=$(top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%"), $2 + $4}');

last_reboot=$(who -b | awk '$1 == "system" {print $3 " " $4}');
established_connections=$(ss -neopt state ESTABLISHED | wc -l);
lvm=$(if [ $(lsblk | grep "lvm" | wc -l )]; then echo "no"; else echo "yes"; fi);
users_logged=$(users | wc -w);
ipv4=$(sudo ifconfig enp0s3 | grep "inet " | awk '{print $2}');
mac_address=$(sudo ifconfig enp0s3 | grep "ether " | awk '{print $2}');
sudo_cmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l);

clear;
wall "

  ██████ ▓██   ██▓  ██████ ▄▄▄█████▓▓█████  ███▄ ▄███▓
▒██    ▒  ▒██  ██▒▒██    ▒ ▓  ██▒ ▓▒▓█   ▀ ▓██▒▀█▀ ██▒
░ ▓██▄     ▒██ ██░░ ▓██▄   ▒ ▓██░ ▒░▒███   ▓██    ▓██░
  ▒   ██▒  ░ ▐██▓░  ▒   ██▒░ ▓██▓ ░ ▒▓█  ▄ ▒██    ▒██ 
▒██████▒▒  ░ ██▒▓░▒██████▒▒  ▒██▒ ░ ░▒████▒▒██▒   ░██▒
▒ ▒▓▒ ▒ ░   ██▒▒▒ ▒ ▒▓▒ ▒ ░  ▒ ░░   ░░ ▒░ ░░ ▒░   ░  ░
░ ░▒  ░ ░ ▓██ ░▒░ ░ ░▒  ░ ░    ░     ░ ░  ░░  ░      ░
░  ░  ░   ▒ ▒ ░░  ░  ░  ░    ░         ░   ░      ░   
      ░   ░ ░           ░              ░  ░       ░   
          ░ ░                                         

					       by loup
╔════════════════════════•⊱✦⊰•════════════════════════╗
#Architecture: $architecture
#CPU physical : $pCPU
#vCPU : $vCPU
#Memory Usage: ${used_ram}/${total_ram}MB (${pourcent_ram}%)
#Disk Usage: ${used_disk}/${total_disk}Gb (${pourcent_disk}%)
#CPU load: $cpu_load
#Last boot: $last_reboot
#LVM use: $lvm
#Connections TCP : $established_connections ESTABLISHED
#User log: $users_logged
#Network: IP $ip ($mac_address)
#Sudo: $sudo_cmd cmd
╚════════════════════════•⊱✦⊰•════════════════════════╝
"