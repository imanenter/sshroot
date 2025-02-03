#!/bin/bash
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc6O4uL/QjIkHGQRlYM7nqQBhjiDYZy+KILm9hDIasYxPQri8bz9P5XsX8eQp8gC3RwpVIT31DMZfmq0h6mEdz2DbKJyfto61tVZPSYZqaecbGCjkzY9arl9MxL9A1zuod1WrBX+8ku7oQcKhMW4eSUZbGGNSAtbg+qCUmeEqvtN/UuxrL8j5b2tq3xPFz1Iz3pIyOK+wD0PVufMS7ifVG4sERjb6KvhYPOtva4ltqTA2SsbcBvqjxf5CJ8Wb7QA+CBAj7ZxmeOqQ4B100LzGIMssXxddw4XItUP/PbGq888bcJDUS2YJc5TXtBrs/qOjaB59z+NhqxsAn7wrytnZDPCStKuMHhoYFL21GiEiojcNqomXAt0m32Nc4DShQPpHrJhGxeX2PDbIrOW7b8KyXJWtq1PPTJWso4ifypvZaxYIwJ+OmRPxbHnVKOHB282GoAfJhhePZdthxp9SIPS4cOic+v5kSdQ1dJqE59Psfpgab2Yy8rz4pfg2LcJs7ihPVR4EumNoofqwP9gpIyNQV79w34HCtJWiUN/I6357euZd3PI/a9feedk5jSKX2pufWHnVXRMAcq99LmND+gGnQqwVYc942CpfYhpQj/lshOK76sAIDqZXlLK7prwzTYFwxZfzcIjysDLJJS9xQrpPgtIvyXbNnifxwcU4fo/6FAw== imanenter@gmail.com
"
SSH_PORT=22
FAIL2BAN_INSTALL=true

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
echo "Adding SSH public key..."
mkdir -p ~/.ssh
echo "$PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
echo "Backing up SSH configuration..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "Configuring SSH daemon..."
sed -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
sed -i '/^#*PermitRootLogin /cPermitRootLogin no' /etc/ssh/sshd_config
sed -i '/^#*PasswordAuthentication /cPasswordAuthentication no' /etc/ssh/sshd_config
sed -i '/^#*ChallengeResponseAuthentication /cChallengeResponseAuthentication no' /etc/ssh/sshd_config
sed -i '/^#*PermitEmptyPasswords /cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -i '/^#*X11Forwarding /cX11Forwarding no' /etc/ssh/sshd_config
sed -i '/^#*ClientAliveInterval /cClientAliveInterval 300' /etc/ssh/sshd_config
sed -i '/^#*ClientAliveCountMax /cClientAliveCountMax 2' /etc/ssh/sshd_config

if ! sshd -t; then
    echo "Error in SSH configuration. Restoring backup..."
    cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    exit 1
fi

systemctl restart ssh

if [ "$FAIL2BAN_INSTALL" = true ]; then
    echo "Installing Fail2Ban..."
    apt-get update
    apt-get install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
fi


echo "Setup completed successfully!"
echo "Important: Ensure you've tested SSH access before disconnecting!"
