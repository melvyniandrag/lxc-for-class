# add this to the root .bashrc
# then you can easily kill all the containers.
alias kill-containers="lxc list -c n --format=csv | xargs -n1 -I{} sh -c 'lxc stop {} --force;'"
