{...}:
{
  programs.konsole = {
    enable = true;
    defaultProfile = "custom";

    customColorSchemes = {
      linuxTransparent = ./LinuxTransparent.colorscheme;
    };

    profiles.custom = {
      name = "Custom";
      colorScheme = "linuxTransparent";
      font = {
        name = "Less Perfect DOS VGA";
        size = 12.0;
      };
      extraConfig = {
        Appearance = {
          AntiAliasFonts = false;
        };
      };
    };
  };
}
