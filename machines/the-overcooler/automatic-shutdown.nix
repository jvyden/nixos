{ pkgs, ... }:
{
  systemd.timers."automatic-shutdown" = {
    description = "GO TO BED";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = false; # do not shutdown if job missed
      Unit = "automatic-shutdown.service";
    };
  };

  systemd.services."automatic-shutdown" = {
    description = "GO TO BED";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl poweroff";
    };
  };
}
