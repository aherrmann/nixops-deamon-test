# Simple Daemon -- NixOps Test

Generates a VirtualBox machine that runs a very simple daemon process as a
NixOS service module.

That daemon repeatedly writes the current time and date into a file. A cron-job
will remove that file regularly.

## How to Deploy

Execute the following commands in order to create and deploy the machine.

    nixops create machine.nix virtualbox.nix -d daemon
    nixops deploy daemon

You can test that it works by executing the following commands

    nixops ssh -d daemon runner
    # Inside the VM
    tail -F /var/mydaemon.out

After a while your terminal should look like this:

    Tue Jul 22 22:34:53 CEST 2014
    Tue Jul 22 22:34:58 CEST 2014
    tail: ‘/var/mydaemon.out’ has become inaccessible: No such file or directory
    Tue Jul 22 22:35:03 CEST 2014
    Tue Jul 22 22:35:08 CEST 2014
