#!/usr/bin/bash

set -e

if [[ -f /var/init_script_over ]]; then
  exit 0
fi

# Sysctl

cat >/etc/sysctl.conf<<EOF
# Increases system file descriptor limit, inode cache & restricts core dumps
fs.file-max = 65535
fs.suid_dumpable = 0

############# VM Settings ###############

# Minimizing the amount of swapping
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 80
vm.dirty_background_ratio = 5

############# VM Settings ###############

########## Network Settings #############

# Change the amount of incoming connections and incoming connections backlog
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 5000

# Increase Linux auto tuning TCP buffer limits maximum number of bytes to use.
# Set max to at least 4MB, or higher if you use very high BDP paths
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608

# Tcp Windows etc
net.ipv4.tcp_window_scaling = 1

# Increase the maximum amount of memory buffers
net.core.optmem_max = 25165824

# Turn on syncookies for SYN flood attack protection
net.ipv4.tcp_syncookies = 1

# Turn on reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Turn on and log spoofed, source routed, and redirect packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# No source routed packets here
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Make sure no one can alter the routing tables
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

# Turn on protection for bad icmp error messages
net.ipv4.icmp_ignore_bogus_error_responses = 1
 
# Don't act as a router
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Optionally want to increase the size of the SYN backlog queue as well, from a default of 1024, to 2048
net.ipv4.tcp_max_syn_backlog = 2048

# TCP Fast Open
net.ipv4.tcp_fastopen = 3

# Set the congestion control to htcp
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Increase system IP port limits
net.ipv4.ip_local_port_range = 2000 65000
 
# Increase TCP max buffer size setable using setsockopt()
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 87380 8388608

# Force gc to clean-up quickly
net.ipv4.neigh.default.gc_interval = 5
 
# Set ARP cache entry timeout
net.ipv4.neigh.default.gc_stale_time = 120
 
# Setup DNS threshold for arp 
net.ipv4.neigh.default.gc_thresh1 = 4096 
net.ipv4.neigh.default.gc_thresh2 = 8192 
net.ipv4.neigh.default.gc_thresh3 = 16384

########## Network Settings #############


########## Kernel settings ##############

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Stop low-level messages on console
kernel.printk = 3 4 1 3

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

# Controls the default maximum size of a message queue
kernel.msgmnb = 65536

# Controls the maximum size of a message, in bytes
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296

# Allow for more PIDs (to reduce rollover problems); may break some programs 32768
kernel.pid_max = 65536

# Turn on execshild
kernel.randomize_va_space = 1

########## Kernel settings ############


########## IPv6 settings ##############

# Number of Router Solicitations to send until assuming no routers are present.
# This is host and not router
net.ipv6.conf.default.router_solicitations = 0

# Accept Router Preference in RA?
net.ipv6.conf.default.accept_ra_rtr_pref = 0

# Learn Prefix Information in Router Advertisement
net.ipv6.conf.default.accept_ra_pinfo = 0

# Setting controls whether the system will accept Hop Limit settings from a router advertisement
net.ipv6.conf.default.accept_ra_defrtr = 0

# Router advertisements can cause the system to assign a global unicast address to an interface
net.ipv6.conf.default.autoconf = 0

# How many neighbor solicitations to send out per address?
net.ipv6.conf.default.dad_transmits = 0

# How many global unicast IPv6 addresses can be assigned to each interface?
net.ipv6.conf.default.max_addresses = 1

########## IPv6 settings ##############
EOF

sysctl -p

# Increase Number Of Open Files
cat > /etc/security/limits.conf <<EOF
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
EOF

# over
touch /var/init_script_over

# reboot
reboot
