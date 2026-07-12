{...}:
{
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  home-manager.users.jvyden.programs.plasma.powerdevil.AC = {
    autoSuspend.action = "nothing";
    turnOffDisplay.idleTimeout = 300;
  };
}
