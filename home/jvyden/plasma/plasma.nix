{ config, ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "GenomeUDCharoite";
      wallpaper = "${../../../assets/wallpapers/bg3.jpg}";
      wallpaperFillMode = "preserveAspectCrop";
      cursor = {
        size = 48;
      };
    };

    session = {
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    kscreenlocker.appearance.wallpaper = config.programs.plasma.workspace.wallpaper;

    panels = [
      {
        location = "bottom";
        screen = "all";
        opacity = "translucent";
        floating = true;
        height = 28;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers = [
                "applications:io.github.cboxdoerfer.FSearch.desktop"
                "applications:firefox.desktop"
                "applications:sable-client-electron.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.keepassxc.KeePassXC.desktop"
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

    input = {
      touchpads = [
        { # red-nugget
          vendorId = "0002";
          productId = "0007";
          name = "SynPS/2 Synaptics TouchPad";
          enable = true;
          accelerationProfile = "none";
          naturalScroll = true;
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          tapAndDrag = true;
          tapToClick = true;
          scrollSpeed = 0.3;
        }
        { # jvyden-thinkpad
          vendorId = "001d";
          productId = "06cb";
          name = "Synaptics tm2964-001";
          enable = true;
          accelerationProfile = "none";
          naturalScroll = true;
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          tapAndDrag = true;
          tapToClick = true;
          scrollSpeed = 0.3;
        }
      ];
    };

    shortcuts = {
      "services/org.kde.touchpadshortcuts.desktop".DisableTouchpad = [ ]; # the nugget is dumb and requires this.
    };

    configFile = {
      # plasma-manager seems to have issues applying the wallpaper properly, force apply this here
      plasmarc.Wallpapers.usersWallpapers = config.programs.plasma.workspace.wallpaper;
      breezerc.Windeco = {
        DrawBackgroundGradient = true;
        TitleAlignment = "AlignLeft";
      };

      kwinrc = {
        Plugins = {
          better_blur_dxEnabled = true;
          blurEnabled = false;
        };
        Effect-better-blur-dx = {
          BlurDecorations = true;
          BlurDocks = true;
          BlurMenus = true;
          BlurStrength = 2;
          Brightness = 150;
          CornerRadius = 25;
          NoiseStrength = 0;
          RefractionMode = 1;
          RefractionNormalPow = 5;
          RefractionRGBFringing = 30;
          RefractionStrength = 2;
          RefractionTextureRepeatMode = 1;
          Saturation = 125;
          WindowClasses = "org.kde.dolphin";
        };
      };
    };
  };

  xdg.dataFile."color-schemes/GenomeUDCharoite.colors".source = ./GenomeUDCharoite.colors;
}
