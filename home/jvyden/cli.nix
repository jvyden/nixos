{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "jvyden";
        email = "jvyden@jvyden.xyz";
      };
    };
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
    };
  };
}
