{ pkgs, ... }:
{
  # This local module contains only overrides and additions. The upstream
  # prebuilt module is included directly from the flake inputs in
  # `flake.nix` as `nvf.maximal` to avoid passing `nvf` into this module
  # (that caused an infinite recursion earlier).

  config.vim = {
    # Ensure lazy loader is enabled so lazy.plugins entries are used
    lazy = {
      enable = true;
    };
    # Theme: attempt to load rafi/neo-hybrid.vim at runtime. We add an
    # extraConfig that activates the colorscheme. Installing the plugin
    # may still be required (see lazy.plugins below).
    theme = {
      enable = true;
      # Keep a supported name to satisfy option types; we'll override the
      # actual colorscheme via extraConfig so the neo-hybrid colorscheme is
      # used when the plugin is available.
      name = "onedark";
      extraConfig = ''
        -- Prefer neo-hybrid if available
        pcall(vim.cmd, 'colorscheme neo-hybrid')
      '';
    };
    # Disable codewindow (minimap) to work around upstream codeview issue
    # when using nixpkgs unstable.
    minimap = {
      codewindow = {
        enable = false;
      };
    };
    # Enable neo-tree and map <space>e to toggle it
    filetree = {
      "neo-tree" = {
        enable = true;
        mappings = {
          toggle = "<space>e";
        };
      };
    };

    # Ensure the neo-hybrid theme plugin is available via the lazy plugin
    # mechanism. This requests the plugin by its GitHub repo name; if your
    # flake inputs / pins don't include it, you may need to add it to npins
    # or install it with your plugin manager.
    lazy = {
      plugins = {
        # The attribute name must match the package string (see nvf's lazy wrapper).
        "rafi/neo-hybrid.vim" = {
          package = "rafi/neo-hybrid.vim";
        };
      };
    };

    # Add an explicit fallback keymap so <space>e works even if the lazy
    # loader hasn't loaded neo-tree yet.
    keymaps = [
      {
        key = "<space>e";
        mode = "n";
        action = ":Neotree toggle<CR>";
      }
    ];
  };
}
