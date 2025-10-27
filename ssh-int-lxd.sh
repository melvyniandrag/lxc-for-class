#!/usr/bin/env bash
# This script will launch a container and login the user as root
# Modify the variables below to change the image, the container name, etc.

set -euo pipefail

TIMESTAMP=$(date +%s%N)
CTNAME="teaching-$TIMESTAMP"
IMAGE="images:debian/13"
CONTAINER_USER="root"
CONTAINER_PASSWORD="root-njcu"

# Ensure cleanup on script exit
# we just lxc stop instead of lxc delete because the containers are --ephemeral, they delete themselves.
cleanup() {
    echo "Stopping container $CTNAME..." >> "$HOME/lxc-ssh.log"
    lxc stop "$CTNAME" --force >/dev/null 2>&1 || true
    echo "Container $CTNAME stopped? $0" >> "$HOME/lxc-ssh.log"
}

# catch the EXIT signal
trap cleanup EXIT

# Launch ephemeral container
lxc launch "$IMAGE" "$CTNAME" --ephemeral --profile=teaching >/dev/null

# Wait for container to be ready
for i in $(seq 1 30); do
  lxc exec "$CTNAME" -- true && break
  sleep 0.2
done

# change root password. Prob not necessary to do this, but making
# sure there is a password in case some command asks a student to provide one.
lxc exec "$CTNAME" -- bash -c "echo \"$CONTAINER_USER:$CONTAINER_PASSWORD\" | chpasswd"

# finally, get a login shell
lxc exec -t "$CTNAME" -- /bin/bash --login
#lxc exec -t "$CTNAME" -- su - "$CONTAINER_USER" -c "/bin/bash --login"
