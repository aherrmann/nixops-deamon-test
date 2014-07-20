{ config, lib, pkgs, ... }:

with lib;

let

  myDaemon = pkgs.writeScript "daemon.sh" ''
    #!${pkgs.bash}/bin/bash
    while true; do
      date >> "${config.services.mydaemon.outFile}"
      sleep 5
    done
  '';

in

{

  ###### interface

  options = {

    services.mydaemon = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run my-daemon.";
      };

      outFile = mkOption {
        type = types.str;
        default = "/var/my_daemon.out";
        description = "Where the daemon will write its output to";
      };

      cleanupPeriod = mkOption {
        type = types.str;
        default = "*/5 * * * *";
        description = "When to remove the output file. (Crontab syntax)";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.mydaemon.enable {

    environment.systemPackages = [ myDaemon ];

    systemd.services.mydaemon = {
      description = "A simple test daemon.";

      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${myDaemon}";
    };

    services.cron.systemCronJobs = optional config.services.mydaemon.enable
      "${config.services.mydaemon.cleanupPeriod} root rm ${config.services.mydaemon.outFile}";

  };

}
