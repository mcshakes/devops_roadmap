#!/bin/bash
yum update -y  

cat <<'EOF' > /home/ec2-user/server-stats.sh
#!/bin/bash
echo "Gathering server stats..."

echo "CPU Usage:"
top -bn1 | grep "Cpu(s)"

echo "Memory Usage (Free vs Used):"
free -h

echo "Disk Usage (Free vs Used):"
df -h

echo "Top 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6

echo "Top 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
EOF

chmod +x /home/ec2-user/server-stats.sh

/home/ec2-user/server-stats.sh > /home/ec2-user/server_stats_output.txt
