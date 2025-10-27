# lxc-for-class
Sometimes in class students wont have access to a vm. 
Heres a way to configure a single digital ocean machine so that students can login and use it.
I could alternatively set up a droplet for each student, but this can take a long time in class if there are 20-30 students.
Thisway, I create one droplet and every student can use it.

## add user
on the droplet 
```
root@droplet$ apt install lxd
root@droplet$ adduser student
root@droplet$ usermod -aG lxd student
rootdroplet$ passwd student #set the student password
```

Then 
1. copy `ssh-into-lxd.sh` to `/usr/local/bin`
1. `chmod 777 /usr/local/bin/ssh-into-lxd.sh`
1. add the line to the bottom of `/root/.bashrc`
1. `source $HOME/.bashrc`
1. copy `01-lxc.conf` to `/etc/ssh/sshd_config.d`
1. `lxc profile create teaching`
1. `lxd init`
1. `lxc profile edit teaching < teaching.yaml`
1. `systemctl restart sshd`

## teaching.yaml
This sets up an lxd profile 

## 01-lxc.conf
This is named with 01, so it should be used before any of the other digital ocean ssh conf scripts.
When the student tries to login as student over ssh, it allows password auth and then runs the `ssh-into-lxd.sh` script.

## ssh-into-lxd.sh
launches an ephemeral linux vm using the teaching profile we created before, and gives the student a login shell.

Note! Have seen some crashing when using debian as the vm image probably because its a) too big and I'm b) create a droplet that was too small.
Consider using a lighter distro like alpine for the container along with a beefier droplet for better performance.
