{
  network.description = "Test Daemon";

  runner =
    { config, pkgs, ... }:

    with pkgs.lib;

    {
      imports = [ ./daemon.nix ];

      # Daemon
      services.mydaemon = {
        enable = true;
        outFile = "/var/mydaemon.out";
      };
    };
}
