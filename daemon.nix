{ config, lib, pkgs, ... }:

with lib;

let

  scriptFile = pkgs.writeText "daemon.sh" ''
    #!${pkgs.bash}/bin/bash
    while true; do
      date >> "${config.outFile}"
      sleep 5
    done
  '';

  myDaemon = pkgs.stdenv.mkDerivation rec {
    name = "my-daemon-0.1.0";
    builder = ''
      mkdir -p $out/bin
      cp ${scriptFile} $out/bin/daemon
      chmod +x $out/bin/daemon
    '';
  };

in

{

  ###### interface

  options = {

    services.mydaemon {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run my-daemon.";
      };

      outFile = mkOption {
        type = types.path;
        default = /var/my_daemon.out;
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

      serviceConfig.ExecStart = "${myDaemon}/bin/daemon";
    };

    services.cron.systemCronJobs = optional config.services.mydaemon.enable
      "${config.services.mydaemon.period} root rm ${config.services.mydaemon.outFile}";

  };

};
