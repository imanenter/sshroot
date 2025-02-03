#!/bin/bash


SSH_PORT=2065
SSHD_CONFIG="/etc/ssh/sshd_config"


echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc6O4uL/QjIkHGQRlYM7nqQBhjiDYZy+KILm9hDIasYxPQri8bz9P5XsX8eQp8gC3RwpVIT31DMZfmq0h6mEdz2DbKJyfto61tVZPSYZqaecbGCjkzY9arl9MxL9A1zuod1WrBX+8ku7oQcKhMW4eSUZbGGNSAtbg+qCUmeEqvtN/UuxrL8j5b2tq3xPFz1Iz3pIyOK+wD0PVufMS7ifVG4sERjb6KvhYPOtva4ltqTA2SsbcBvqjxf5CJ8Wb7QA+CBAj7ZxmeOqQ4B100LzGIMssXxddw4XItUP/PbGq888bcJDUS2YJc5TXtBrs/qOjaB59z+NhqxsAn7wrytnZDPCStKuMHhoYFL21GiEiojcNqomXAt0m32Nc4DShQPpHrJhGxeX2PDbIrOW7b8KyXJWtq1PPTJWso4ifypvZaxYIwJ+OmRPxbHnVKOHB282GoAfJhhePZdthxp9SIPS4cOic+v5kSdQ1dJqE59Psfpgab2Yy8rz4pfg2LcJs7ihPVR4EumNoofqwP9gpIyNQV79w34HCtJWiUN/I6357euZd3PI/a9feedk5jSKX2pufWHnVXRMAcq99LmND+gGnQqwVYc942CpfYhpQj/lshOK76sAIDqZXlLK7prwzTYFwxZfzcIjysDLJJS9xQrpPgtIvyXbNnifxwcU4fo/6FAw== imanenter@gmail.com" >> ~/.ssh/authorized_keys
echo "Adding SSH public key..."
mkdir -p ~/.ssh
echo "$PUBLIC_KEY" > ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

echo "Configuring SSH daemon..."
sed -i 's/^#*Port .*/Port '"$SSH_PORT"'/' $SSHD_CONFIG
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $SSHD_CONFIG
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $SSHD_CONFIG



systemctl restart ssh
