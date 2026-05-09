#!/bin/bash

VM_NAME="KaliLinux"
SSH_USER="kali"
SSH_HOST="kali"  # Replace with your Kali Linux VM's IP address

# Check if the VM is running
if sudo virsh list --name | grep -q "^${VM_NAME}$"; then
    echo "$VM_NAME is already running."
else
    echo "$VM_NAME is not running. Starting..."
    sudo virsh start "$VM_NAME"

    # Wait for the VM to boot up
    echo "Waiting for $VM_NAME to boot..."
    sleep 10  # You may adjust this depending on your VM's boot time
fi

# Try to SSH until successful
echo "Trying to connect via SSH..."
until ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" 'echo "Connected to Kali!"'; do
    echo "Waiting for SSH to become available..."
    sleep 5
done

# Start an interactive SSH session
ssh "${SSH_USER}@${SSH_HOST}" -X
