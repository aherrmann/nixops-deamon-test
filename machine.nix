{
  network.description = "Test Daemon";

  runner =
    { config, pkgs, ... }:

    with pkgs.lib;

    let

      mydaemon = import ./daemon.nix { };

    in

    {
      # Daemon
      systemd.services.mydaemon = mydaemon;
      services.mydaemon = {
        enable = true;
        outFile = /var/mydaemon.out;
      };
    };
}
