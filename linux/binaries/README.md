These are binaries to use in the hivestorm competition, either statically compiled, or generated with tools like nix-bundle. 


After trying many, many tools to create portable binaries, I gave up and eventually settled on [nix-portable](https://github.com/DavHau/nix-portable/). It just worked, and it is very easy to clean up. 


# Installation

To install nix-portable:

`curl https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable -o /bin/nix-portable`

Or use wget, since sometimes curl isn't installed by default.

`chmod +x /bin/nix-portable`

Since nix-portable sets up flakes, my goal is for there to be a preconfigured shell with all the tools we could use. 


# Usage


To run any tool from the nix repo, for example, zellij you can simply do:

`nix-portable nix shell nixpkgs#zellij`

Simply replace `zellij` with the tool you want.


# Uninstallation

To uninstall, simply remove the `/bin/nix-portable` and delete $HOME/.nix-portable


# Useful tools:

## Zellij

Zellij: a terminal multiplexer which is very easy to use.


# Fd

I like this better than find.

`nix-portable nix shell nixpkgs#fd`

The basic syntax is `fd [OPTIONS] [pattern] [path]...`

For more info, see `fd --help`

To find any executables:

`find /path/ --type executable --hidden --follow --no-ignore`

A shorter version:

`find /path --type x -u`

We can use this to find any executable files, like any shell scripts that should not be there.

You can also search using regexes (defalt), or glob pattern paths:

`fd --glob *.sh /path/`



## Fsearch

`nix-portable nix shell nixpkgs#fsearch`

Fsearch: A full filessytem search utility, which is very easy to use, and uses indexing, so it's wicked fast. 

Fsearch store's it's database in `~/.local/share/fsearch.db` and it's config file in `~/.config/fsearch`


Ansible, for running playbooks locally. 



