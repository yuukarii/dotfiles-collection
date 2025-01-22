#!/usr/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check if OpenVPN is running
ps -ef | grep openvpn | grep tryhackme > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  echo "OpenVPN is running"
  echo "Trying to kill OpenVPN session"
  OPENVPN_PID=$(ps -ef | grep openvpn | grep tryhackme | awk '{print $2}')
  echo "Got PID $OPENVPN_PID"
  kill $OPENVPN_PID
  sleep 2
  echo "Starting Tailscale"
  tailscale up --accept-dns
else
  echo "OpenVPN is not running"
  echo "Turn off Tailscale"
  tailscale down
  sleep 2
  echo "Spawn OpenVPN session"
  openvpn --config /home/yuukarii/THM/dont_delete/undertak3r.ovpn --daemon tryhackme
fi
