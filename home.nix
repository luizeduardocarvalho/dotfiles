{ config, pkgs, lib, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    ripgrep   
    fd        
    fzf       
    jq      
    lazygit
    neovim
    git
    gh
    direnv
    mise
    aerospace
    nerd-fonts.hack
    nodejs_22
    pnpm
    pulumi
    spotify-player
    firebase-tools
    uv
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/pnpm/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.activation.graphifyy = lib.hm.dag.entryAfter [ "installPackages" ] ''
    $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install --quiet graphifyy \
      || echo "warning: 'uv tool install graphifyy' failed (offline?); run it manually later" >&2
  '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude";
      claude = "CLAUDE_CONFIG_DIR=$HOME/.claude-account1 command claude";
      claude2 = "CLAUDE_CONFIG_DIR=$HOME/.claude-account2 command claude";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      font-size = 15;
      theme = "Rose Pine Moon";
      macos-option-as-alt = true;
      font-family = "Hack Nerd Font";
      background-opacity = 0.8;
      window-padding-x = "10,0";
      background-blur = 50;
      window-decoration = false;
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/direnv/direnvrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/direnv/direnvrc";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/aerospace".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/aerospace";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
