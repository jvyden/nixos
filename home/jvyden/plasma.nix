{ ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        size = 54;
      };
    };

    panels = [
      {
        location = "bottom";
        screen = "all";
        opacity = "translucent";
        floating = true;
        height = 35;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:firefox.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    kwin = {
      titlebarButtons = {
        right = [
          "keep-above-windows"
          "minimize"
          "maximize"
          "close"
        ];
      };
    };
  };
}
