# What?


Here is where I am trying to experiment with something very interesting: Replacing pieces of non-nixos systems with pieces of nix system.



Using something like [system-manager](https://github.com/numtide/system-manager), it is possible to run nix systemd services and binaries on non nix systems.

In some discussions of this tool, people mentioned that before this tool they were generating nix stores, and then using saltstack to link the results into a normal system. Since I don't think it is practical to do the same thing with more than one tool, I want to that, but all with ansible.

# Why?

If this works (and the machines have enough storage), then it is feasible to replace the possibly outdated, net facing pieces of a system, like the firewall or important services. Rather than using an outdated ssh, we simply edit that system service so that the command is the nix systemd service instead. This let's us "patch" services with minimal downtime.


# How?

Still working on it. Based on the system-manager page, there is a way to get the path of a nix binary, something like: `${lib.getBin pkgs.hello}/bin/hello` (in a string, the $() evaluates in nix).

Based on some research, you can also do it with nix-build. I like this method, since it downloads the packages if you need them.

```
[moonpie@cachyos-x8664 linux]$ nix-build --quiet --no-out-link '<nixpkgs>' -A nginx
/nix/store/sy0nqq88gnmk6z0frh5m1az3yri85xrk-nginx-1.24.0
```

So you can probably plug the output of this comamnd into an ansible variable, and then use it to replace the systemd service or something like that.


Right now, I simply have an ansible playbook that runs this command, and saves it to a variable, which will be used for other things.

The goal is to be able to either use a jinja2 template to create a systemd service, or simple line replacement to edit an existing one (although some services don't go in /etc/)

