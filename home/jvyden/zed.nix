{...}:
{
  programs.zed-editor = {
    enable = true;

    extensions = [ "nix" "html" "jetbrains-themes" ];

    userSettings = {
      text_rendering_mode = "grayscale";
      ui_font_family = "IBM Plex Sans";
      ui_font_size = 15.0;
      buffer_font_size = 16.0;
      buffer_font_family = "Less Perfect DOS VGA";
      buffer_line_height.custom = 1.0;

      theme = {
        mode = "system";
        light = "JetBrains Light";
        dark = "JetBrains Dark";
      };

      title_bar = {
        button_layout = "standard";
        show_user_picture = false;
        show_user_menu = false;
        show_sign_in = false;
        show_branch_status_icon = true;
      };

      use_system_window_tabs = true;
      window_decorations = "server";
      on_last_window_closed = "quit_app";
      when_closing_with_no_tabs = "close_window";
      base_keymap = "JetBrains";

      disable_ai = true;

      git.blame.show_avatar = true;

      terminal = {
        toolbar = {
          breadcrumbs = true;
        };
        working_directory = "current_project_directory";
      };

      debugger = {
        stepping_granularity = "statement";
      };

      agent.button = false;
      collaboration_panel.button = false;
      outline_panel.button = true;
      project_panel = {
        hide_root = true;
        scrollbar = {
          horizontal_scroll = true;
          show = "auto";
        };
        git_status = true;
        entry_spacing = "standard";
        default_width = 300.0;
        dock = "left";
      };

      tabs.git_status = true;

      status_bar = {
        show_active_file = true;
        active_encoding_button = "enabled";
        active_language_button = true;
      };

      sticky_scroll.enabled = true;

      autosave.after_delay.milliseconds = 1000;

      auto_update = false;
    };
  };
}
