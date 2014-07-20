{
  network.description = "Test Daemon";

  runner =
    { config, pkgs, ... }:

    with pkgs.lib;

    {
      # Daemon
      services.mydaemon = {
        enable = true;
        outFile = /var/mydaemon.out;
      };
    };
}
