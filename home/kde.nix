{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    workspace.clickItemTo = "select";

    hotkeys.commands = {
      "Launch Konsole" = {
        key = "Meta+Return";
        command = "konsole";
      };
    };

    shortcuts = {
      kwin = {
        "Switch One Desktop Down" = "Ctrl+Alt+Down";
        "Switch One Desktop Up" = "Ctrl+Alt+Up";
        "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
        "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
        "Window One Desktop Down" = "Ctrl+Alt+Shift+Down";
        "Window One Desktop Up" = "Ctrl+Alt+Shift+Up";
        "Window One Desktop to the Left" = "Ctrl+Alt+Shift+Left";
        "Window One Desktop to the Right" = "Ctrl+Alt+Shift+Right";
      };
    };

    configFile."kwinrc"."Windows"."RollOverDesktops" = false;
    configFile."kcminputrc"."Mouse"."cursorTheme" = "Qogir-dark";
    configFile."kdeglobals"."Icons"."Theme" = "Tela-dark";
    configFile."kdeglobals"."KDE"."widgetStyle" = "Lightly";
  };

  home.packages = with pkgs; [
    tela-icon-theme
    qogir-icon-theme # Qogir cursors
    libsForQt5.lightly
  ];
}
