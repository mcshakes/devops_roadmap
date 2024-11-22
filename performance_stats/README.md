## Requirements

For the project [Server Performace Stats](https://roadmap.sh/projects/server-stats), I need to write a script `server-stats.sh` that can analyze basic server performance stats. Should be able to run the script on any Linux server and it should provide the following stats:

- Total CPU usage
- Total memory usage (Free vs Used including percentage)
- Total disk usage (Free vs Used including percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

**My goals**: I will be using Terraform to create, configure, and destroy an AWS EC2 instance and satisfy this goal.

---

## Working Steps

1) Create `aws_keys.tfvars` and add your AWS Access and Secret Keys.

2) `terraform init` and `terraform validate`. 
The first downloads required provider plugins, while the latter checks syntax/structure and is useful for catching errors.

3) Apply the configuration with `terraform apply -var-file="aws_keys.tfvars"` 

4) Log into AWS console to confirm the EC2 is up and running. Make sure the status checks pass.

5) Now run this to extract the raw value of `terraform output` redirect this output into a file named *ephemeral_key.pem*.

`terraform output -raw private_key_pem > ephemeral_key.pem`

6) Set file permissions for that ephemeral file to be readable/writable by owner

`chmod 600 ephemeral_key.pem`

7) Grab the IP address using this `terraform output -raw instance_public_ip`

8) SSH into this EC2 instance to check it out, using this:

`ssh -i ./ephemeral_key.pem ec2-user@<EC2-IP-FROM-ABOVE>`

9) Check to see if the init script ran properly with this `cat /home/ec2-user/server_stats_output.txt`. What I see:

```
Gathering server stats...
CPU Usage:
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni, 60.0 id,  0.0 wa,  0.0 hi,  0.0 si, 40.0 st
Memory Usage (Free vs Used):
              total        used        free      shared  buff/cache   available
Mem:           952M         91M        289M        360K        571M        727M
Swap:            0B          0B          0B
Disk Usage (Free vs Used):
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        468M     0  468M   0% /dev
tmpfs           477M     0  477M   0% /dev/shm
tmpfs           477M  360K  476M   1% /run
tmpfs           477M     0  477M   0% /sys/fs/cgroup
/dev/xvda1      8.0G  1.9G  6.2G  23% /
Top 5 Processes by CPU Usage:
  PID  PPID CMD                         %MEM %CPU
 3255     1 /usr/bin/python2 /usr/bin/c  3.3  3.5
    1     0 /usr/lib/systemd/systemd --  0.5  2.3
 3139     1 /usr/bin/amazon-ssm-agent    2.0  1.2
   11     2 [ksoftirqd/0]                0.0  0.7
 1782     1 /usr/lib/systemd/systemd-jo  0.6  0.3
Top 5 Processes by Memory Usage:
  PID  PPID CMD                         %MEM %CPU
 3255     1 /usr/bin/python2 /usr/bin/c  3.3  3.5
 3139     1 /usr/bin/amazon-ssm-agent    2.0  1.2
 3231     1 /usr/sbin/sshd -D            0.7  0.0
 3095  3091 pickup -l -t unix -u         0.6  0.0
 3096  3091 qmgr -l -t unix -u           0.6  0.0
[ec2-user@ip-172-31-91-124 ~]$ logout
Connection to 54.157.40.13 closed.

```
10) When finished, I do `terraform destroy -var-file="aws_keys.tfvars"` and then `rm ephemeral_key.pem`. Destroy EC2 instance and delete the ephemeral key.

---

## Notes & Reflection:

User Data is allows you to pass scripts to your EC2 instance at launch. When you specify a user_data script in your Terraform configuration, AWS executes this script (as root user) during the first boot cycle. Lets you configure instace exactly how you want it from the moment it starts.

Initially, I wanted to use Ansible to make the configuration, but that seemed like more work. More pieces that I would need to glue together. This is good for now.

