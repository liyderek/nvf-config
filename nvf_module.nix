{
  pkgs,
  lib,
  ...
}: let
  neoHybrid = pkgs.vimUtils.buildVimPlugin {
    pname = "neo-hybrid-vim";
    version = "ddc005b";
    src = pkgs.fetchFromGitHub {
      owner = "rafi";
      repo = "neo-hybrid.vim";
      rev = "ddc005b14c6fece50bd495f6a2bac768c3f8e635";
      hash = "sha256-5JPZQi2MGggsHpOg45z7wReTw3jyIYftRU9zfiL32kk=";
    };
  };

  svelteNodeModule = pkgs.runCommand "svelte-node-module" {} ''
    mkdir -p "$out/lib/node_modules/svelte"
    tar -xzf ${
      pkgs.fetchurl {
        url = "https://registry.npmjs.org/svelte/-/svelte-4.2.7.tgz";
        hash = "sha256-z/yCP9OCwth1QqNxO82SG4fe2eZ041GNT3zb+0xEG0E=";
      }
    } -C "$out/lib/node_modules/svelte" --strip-components=1
  '';
in {
  config.vim = {
    viAlias = true;
    vimAlias = true;
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    # vim.opts and vim.options are aliased
    opts = {
      expandtab = false;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      clipboard = "unnamedplus";
    };

    spellcheck = {
      enable = lib.mkForce false;
      programmingWordlist.enable = true;
    };

    lsp = {
      # This must be enabled for the language modules to hook into
      # the LSP API.
      enable = true;

      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = !true; # conflicts with blink in maximal
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;
      presets.harper.enable = true;

      presets.tailwindcss-language-server.enable = true;
      servers.basedpyright.settings = {
        basedpyright.analysis = {
          autoImportCompletions = true;
          typeCheckingMode = "off";
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = "none";
            reportUnknownVariableType = "none";
            reportUnknownMemberType = "none";
            reportUnknownArgumentType = "none";
            reportUnknownParameterType = "none";
            reportMissingTypeStubs = "none";
          };
        };
      };

      servers.typescript-language-server.settings = {
        typescript.preferences = {
          includeCompletionsForModuleExports = true;
          includeCompletionsForImportStatements = true;
        };
        javascript.preferences = {
          includeCompletionsForModuleExports = true;
          includeCompletionsForImportStatements = true;
        };
      };
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    # This section does not include a comprehensive list of available language modules.
    # To list all available language module options, please visit the nvf manual.
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # Languages that will be supported in default and maximal configurations.
      nix.enable = true;
      markdown.enable = true;

      # Languages that are enabled in the maximal configuration.
      bash.enable = true;
      clang.enable = true;
      cmake.enable = true;
      css.enable = true;
      html.enable = true;
      json.enable = true;
      sql.enable = true;
      java.enable = true;
      kotlin.enable = true;
      typescript.enable = true;
      go.enable = true;
      lua.enable = true;
      zig.enable = true;
      python = {
        enable = true;
        extraDiagnostics.enable = false;
      };
      typst.enable = true;
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      toml.enable = true;
      xml.enable = true;
      tex.enable = true;

      # Language modules that are not as common.
      openscad.enable = false;
      arduino.enable = false;
      assembly.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = false;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      glsl.enable = false;
      dart.enable = false;
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = true;
      hcl.enable = false;
      ruby.enable = false;
      fsharp.enable = false;
      just.enable = false;
      make.enable = false;
      qml.enable = false;
      jinja.enable = false;
      svelte = {
        enable = true;
        format = {
          enable = true;
          type = ["prettier"];
        };
      };
      vue.enable = false;
      liquid.enable = false;
      tera.enable = false;
      twig.enable = false;
      gettext.enable = false;
      fluent.enable = false;
      jq.enable = false;

      # Nim LSP is broken on Darwin and therefore
      # should be disabled by default. Users may still enable
      # `vim.languages.vim` to enable it, this does not restrict
      # that.
      # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
      nim.enable = false;
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      blink-indent.enable = true;
      indent-blankline.enable = true;

      # Fun
      cellular-automaton.enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "auto";
      };
    };

    theme.enable = false;

    luaConfigPre = ''
      vim.o.background = "dark"
      pcall(vim.cmd, "colorscheme neohybrid")
    '';

    luaConfigRC.competitest = ''
      require('competitest').setup({
      	local_config_file_name = '.competitest.lua',

      	floating_border = 'rounded',
      	floating_border_highlight = 'FloatBorder',
      	picker_ui = {
      		width = 0.2,
      		height = 0.3,
      		mappings = {
      			focus_next = { 'j', '<down>', '<Tab>' },
      			focus_prev = { 'k', '<up>', '<S-Tab>' },
      			close = { '<esc>', '<C-c>', 'q', 'Q' },
      			submit = { '<cr>' },
      		},
      	},
      	editor_ui = {
      		popup_width = 0.4,
      		popup_height = 0.6,
      		show_nu = true,
      		show_rnu = false,
      		normal_mode_mappings = {
      			switch_window = { '<C-h>', '<C-l>', '<C-i>' },
      			save_and_close = '<C-s>',
      			cancel = { 'q', 'Q' },
      		},
      		insert_mode_mappings = {
      			switch_window = { '<C-h>', '<C-l>', '<C-i>' },
      			save_and_close = '<C-s>',
      			cancel = '<C-q>',
      		},
      	},
      	runner_ui = {
      		interface = 'popup',
      		selector_show_nu = false,
      		selector_show_rnu = false,
      		show_nu = true,
      		show_rnu = false,
      		mappings = {
      			run_again = 'R',
      			run_all_again = '<C-r>',
      			kill = 'K',
      			kill_all = '<C-k>',
      			view_input = { 'i', 'I' },
      			view_output = { 'a', 'A' },
      			view_stdout = { 'o', 'O' },
      			view_stderr = { 'e', 'E' },
      			toggle_diff = { 'd', 'D' },
      			close = { 'q', 'Q' },
      		},
      		viewer = {
      			width = 0.5,
      			height = 0.5,
      			show_nu = true,
      			show_rnu = false,
      		},
      	},
      	popup_ui = {
      		total_width = 0.8,
      		total_height = 0.8,
      		layout = {
      			{ 4, 'tc' },
      			{ 5, { { 1, 'so' }, { 1, 'si' } } },
      			{ 5, { { 1, 'eo' }, { 1, 'se' } } },
      		},
      	},
      	split_ui = {
      		position = 'right',
      		relative_to_editor = true,
      		total_width = 0.3,
      		vertical_layout = {
      			{ 1, 'tc' },
      			{ 1, { { 1, 'so' }, { 1, 'eo' } } },
      			{ 1, { { 1, 'si' }, { 1, 'se' } } },
      		},
      		total_height = 0.4,
      		horizontal_layout = {
      			{ 2, 'tc' },
      			{ 3, { { 1, 'so' }, { 1, 'si' } } },
      			{ 3, { { 1, 'eo' }, { 1, 'se' } } },
      		},
      	},

      	save_current_file = true,
      	save_all_files = false,
      	compile_directory = '.',
      	compile_command = {
      		c = {
      			exec = 'gcc',
      			args = { '-Wall', '$(FNAME)', '-o', './compile/$(FNOEXT)' },
      		},
      		cpp = {
      			exec = 'g++',
      			args = { '-Wall', '$(FNAME)', '-o', './compile/$(FNOEXT)' },
      		},
      		rust = { exec = 'rustc', args = { '$(FNAME)' } },
      		java = { exec = 'javac', args = { '$(FNAME)' } },
      	},
      	running_directory = '.',
      	run_command = {
      		c = { exec = './compile/$(FNOEXT)' },
      		cpp = { exec = './compile/$(FNOEXT)' },
      		rust = { exec = './$(FNOEXT)' },
      		python = { exec = 'python', args = { '$(FNAME)' } },
      		java = { exec = 'java', args = { '$(FNOEXT)' } },
      	},
      	multiple_testing = -1,
      	maximum_time = 5000,
      	output_compare_method = 'squish',
      	view_output_diff = false,

      	testcases_directory = './tcs',
      	testcases_use_single_file = true,
      	testcases_auto_detect_storage = true,
      	testcases_single_file_format = '$(FNOEXT).testcases',
      	testcases_input_file_format = '$(FNOEXT)_input$(TCNUM).txt',
      	testcases_output_file_format = '$(FNOEXT)_output$(TCNUM).txt',

      	companion_port = 27121,
      	receive_print_message = true,
      	template_file = '~/Documents/codeforces/template.$(FEXT)',
      	evaluate_template_modifiers = true,
      	date_format = '%c',
      	received_files_extension = 'cpp',
      	received_problems_path = '$(CWD)/$(PROBLEM).$(FEXT)',
      	received_problems_prompt_path = true,
      	received_contests_directory = '$(CWD)',
      	received_contests_problems_path = '$(PROBLEM).$(FEXT)',
      	received_contests_prompt_directory = true,
      	received_contests_prompt_extension = true,
      	open_received_problems = true,
      	open_received_contests = true,
      	replace_received_testcases = false,
      })
      -- bind space+r+r to :CompetiTest run
      vim.keymap.set(
      	'n',
      	'<leader>rr',
      	'<cmd>:CompetiTest run<cr>',
      	{ noremap = true, silent = true }
      )
      -- bind space+r+p to :CompetiTest receive problem
      vim.keymap.set(
      	'n',
      	'<leader>rp',
      	'<cmd>:CompetiTest receive problem<cr>',
      	{ noremap = true, silent = true }
      )
    '';

    luaConfigRC.dap = let
      codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    in ''
      local dap = require("dap")
      require("dapui").setup()

      local allowed_projects = {
        "/home/derek/Documents/codeforces",
      }

      dap.adapters.codelldb = function(cb, config)
        local cwd = vim.fn.getcwd()
        local is_allowed = vim.tbl_contains(allowed_projects, cwd)

        if is_allowed then
      	local command = {
      	  "/run/current-system/sw/bin/g++",
      	  "-g",
      	  vim.fn.expand("%"),
      	  "-o",
      	  vim.fn.getcwd() .. "/main",
      	  "-D",
      	  "DEBUG",
      	}

      	local output = vim.system(command):wait()
      	print("stdout: " .. (output.stdout or ""))
      	print("stderr: " .. (output.stderr or ""))
        end

        cb({
      	type = "server",
      	port = "12345",
      	executable = {
      	  command = "${codelldb}",
      	  args = { "--port", "12345" },
      	},
        })
      end

      dap.configurations.cpp = {
        {
      	name = "Launch file",
      	type = "codelldb",
      	request = "launch",
      	program = function()
      	  return vim.fn.getcwd() .. "/main"
      	end,
      	cwd = "''${workspaceFolder}",
      	stopOnEntry = false,
        },
      }
    '';

    extraPlugins = {
      # luaConfigPost = ''
      #   local ok, lsp_lines = pcall(require, "lsp_lines")
      #   if ok then
      #     lsp_lines.setup()
      #     vim.diagnostic.config({
      #       virtual_text = false,
      #       virtual_lines = true,
      #     })
      #   end
      # '';

      neo-hybrid-theme = {
        package = neoHybrid;
      };

      competitest = {
        package = pkgs.vimPlugins.competitest-nvim;
      };

      nvim-dap.package = pkgs.vimPlugins.nvim-dap;
      nvim-dap-ui.package = pkgs.vimPlugins.nvim-dap-ui;
    };

    # extraPlugins.lsp-lines = {
    #   package = pkgs.vimPlugins.lsp_lines-nvim;
    # };

    autopairs.nvim-autopairs.enable = true;

    formatter.conform-nvim.setupOpts.formatters.prettier.env = {
      NODE_PATH = "${svelteNodeModule}/lib/node_modules";
    };

    # nvf provides various autocomplete options. The tried and tested nvim-cmp
    # is enabled in default package, because it does not trigger a build. We
    # enable blink-cmp in maximal because it needs to build its rust fuzzy
    # matcher library.
    autocomplete = {
      nvim-cmp.enable = !true;
      blink-cmp = {
        enable = true;
        setupOpts.sources.default = lib.mkForce [
          "lsp"
          "path"
          "snippets"
        ];
      };
    };

    snippets.luasnip.enable = true;

    filetree = {
      neo-tree = {
        enable = true;
      };
    };

    # Ensure lazy loader is enabled.
    lazy = {
      enable = true;
      plugins.avante-nvim.keys = [
        {
          key = "<C-a>";
          mode = [
            "n"
            "v"
            "i"
          ];
          action = "<cmd>lua require('avante.api').zen_mode()<CR>";
          desc = "Avante zen mode";
        }
      ];
      plugins.neo-tree-nvim.keys = [
        {
          key = "<space>e";
          mode = "n";
          action = "<cmd>Neotree position=current toggle<CR>";
          desc = "Toggle Neo-tree fullscreen";
        }
      ];
      plugins.floaterm = {
        package = pkgs.vimPlugins.floaterm;
        setupOpts = {};
        cmd = ["FloatermToggle"];
        keys = [
          {
            key = "<space>p";
            mode = "n";
            action = "<cmd>FloatermToggle<CR>";
            desc = "Toggle Floaterm";
          }
        ];
      };
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
      neogit.enable = true;
    };

    minimap = {
      minimap-vim.enable = false;
      codewindow.enable = false;
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      diffview-nvim.enable = true;
      yanky-nvim.enable = false;
      qmk-nvim.enable = false; # requires hardware specific options
      icon-picker.enable = true;
      surround.enable = true;
      leetcode-nvim.enable = true;
      multicursors.enable = true;
      smart-splits.enable = true;
      undotree.enable = true;
      nvim-biscuits.enable = true;
      grug-far-nvim.enable = true;

      motion = {
        flash-nvim = {
          enable = true;
          mappings.jump = "s";
        };
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };

      images = {
        image-nvim.enable = false;
        img-clip.enable = true;
      };
    };

    notes = {
      neorg = {
        enable = true;
        setupOpts.load."core.dirman".config.workspaces.notes = "~/notes";
      };
      orgmode.enable = false;
      mind-nvim.enable = false;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [
            "90"
            "130"
          ];
        };
      };
      fastaction.enable = true;
    };

    assistant = {
      chatgpt.enable = false;
      copilot = {
        enable = true;
        cmp.enable = true;
      };
      codecompanion-nvim.enable = false;
      avante-nvim = {
        enable = true;
        setupOpts = {
          provider = "openai";
          auto_suggestions_provider = "openai";
          providers.openai = {
            api_key_name = "OPENAI_API_KEY";
            model = "gpt-4o-mini";
          };
          selection.hint_display = "none";
          mappings.zen_mode = "<C-a>";
        };
      };
    };

    session = {
      nvim-session-manager = {
        enable = true;
        setupOpts.autoload_mode = "CurrentDir";
      };
    };

    gestures = {
      gesture-nvim.enable = false;
    };

    comments = {
      comment-nvim.enable = true;
    };

    presence = {
      neocord.enable = true;
    };
  };
}
