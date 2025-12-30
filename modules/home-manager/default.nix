{ pkgs, ... }: {
  imports = [ ./zsh ./vim ./zellij ];

  home = {
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "vim";
    };
    packages = with pkgs; [
      ripgrep
      unixtools.watch
      coreutils
      starship-jj
    ];
  };

  xdg = {
    enable = true;
  };

  xdg.configFile = {
    "ripgrep/ripgreprc" = {
      source = ../../dotfiles/ripgreprc;
    };
    starship-jj = {
      source = ../../dotfiles/starship-jj;
      recursive = true;
    };
  };

  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    zellij = {
      enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = true;
        format = "$directory \${custom.jj}\${custom.git}$cmd_duration$line_break$character";
        right_format = "$battery$all";

        aws.disabled = true;
        package.disabled = true;

        battery = {
          format = "[$symbol]($style)";
          unknown_symbol = "";
        };

        battery.display = [
          {
            threshold = 30;
            style = "bright-yellow";
            discharging_symbol = "";
            charging_symbol = "";
          }
          {
            threshold = 10;
            style = "bright-red";
            discharging_symbol = "";
            charging_symbol = "";
          }
        ];

        character = {
          success_symbol = "[;](green)";
          error_symbol = "[;](red)";
          vimcmd_symbol = "[;](purple)";
        };

        directory = {
          format = "[$path]($style)[$read_only]($read_only_style)";
          style = "cyan";
        };

        cmd_duration = {
          format = "[$duration]($style)";
          style = "yellow";
        };

        nix_shell = {
          symbol = "";
          format = " [$symbol](#73b1e0)";
          impure_msg = "";
          pure_msg = "";
          style = "bright-black";
        };

        buf = {
          symbol = "󰿘";
          format = " [$symbol](#54d7ff)[( $version)]($style)";
          style = "bright-black";
        };

        golang = {
          symbol = "󰟓";
          format = " [$symbol](#6ecefd)[( $version)]($style)";
          style = "bright-black";
        };

        nodejs = {
          symbol = "󰎙";
          format = " [$symbol](#4f9e3d)[( $version)]($style)";
          version_format = "v$major";
          style = "bright-black";
          not_capable_style = "bright-red";
        };

        python = {
          symbol = "";
          # format = " [$symbol](#2d6291)[( $virtualenv)]($style)";
          format = "( [$symbol](#2d6291)[$pyenv_prefix( $version)( \\($virtualenv\\))]($style))";
          style = "bright-black";
        };

        java = {
          symbol = "";
          format = "( [$symbol](#3a75b0)[( $version)]($style))";
          version_format = "v$major";
          style = "bright-black";
        };

        rust = {
          symbol = "";
          format = "( [$symbol](#0e6756)[( $version)]($style))";
          style = "bright-black";
        };

        terraform = {
          symbol = "";
          format = "( [$symbol](#5245e1)[ $version](bright-black))";
          style = "";
          version_format = "v$major.$minor";
        };

        git_branch = {
          disabled = true;
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          disabled = true;
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)( $ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "";
          untracked = "";
          modified = "";
          staged = "";
          renamed = "";
          deleted = "";
          stashed = "≡";
        };

        git_commit = {
          disabled = true;
          format = "[\($hash$tag\)]($style)";
          style = "bright-black";
        };

        git_state = {
          disabled = true;
          format = "\([$state( $progress_current/$progress_total)]($style)\)";
          style = "bright-black";
        };

        custom = {
          git_branch = {
            command = "starship module git_branch";
            format = "[$symbol($output)]($style)";
          };
          git_status = {
            command = "starship module git_status";
            format = "[$symbol($output)]($style)";
          };
          git_commit = {
            command = "starship module git_commit";
            format = "[$symbol($output)]($style)";
          };
          git_state = {
            command = "starship module git_state";
            format = "[$symbol($output)]($style)";
          };
          git = {
            when = "! jj --ignore-working-copy root";
            format = "\${custom.git_branch}\${custom.git_commit}\${custom.git_state}\${custom.git_status}";
          };
          jj = {
            command = "prompt";
            format = "$output";
            ignore_timeout = true;
            shell = [ "starship-jj" "--ignore-working-copy" "starship" ];
            use_stdin = false;
            when = true;
            # description = "The current jj status";
            # when = "jj --ignore-working-copy root";
            # format = "[$symbol($output)]($style)";
            # style = "bright-black";
            # command = ''
            #   jj log --revisions @ --no-graph --ignore-working-copy --color never --limit 1 --template '
            #     concat(
            #       raw_escape_sequence("\x1b[35m"),
            #       coalesce(bookmarks, change_id.shortest()),
            #       raw_escape_sequence("\x1b[0m"),
            #       " ",
            #       raw_escape_sequence("\x1b[90m"),
            #       if(empty, "∅ "),
            #       coalesce(
            #         truncate_end(27, description.first_line(), "…"),
            #         "(no description set)",
            #       ),
            #       raw_escape_sequence("\x1b[0m"),
            #       if(conflict, raw_escape_sequence("\x1b[91m") ++ "!" ++ raw_escape_sequence("\x1b[0m")),
            #       if(divergent, raw_escape_sequence("\x1b[91m") ++ "¡" ++ raw_escape_sequence("\x1b[0m")),
            #       if(hidden, raw_escape_sequence("\x1b[90m") ++ "¿" ++ raw_escape_sequence("\x1b[0m")),
            #       if(immutable, raw_escape_sequence("\x1b[90m") ++ "" ++ raw_escape_sequence("\x1b[0m")),
            #     )
            #   '
            # '';
          };
        };
      };
    };
    jujutsu = {
      enable = true;
      settings = {
        ui = {
          pager = ":builtin";
        };
        colors = {
          "diff token" = {
            underline = false;
          };
          "diff removed token" = {
            bg = "#cc241d";
            fg = "#ebdbb2";
          };
          "diff added token" = {
            bg = "#98971a";
            fg = "#fbf1c7";
          };
        };
      };
    };
    git = {
      enable = true;
      delta = { enable = true; };
      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
      };
      ignores = [ ".DS_Store" "tf.plan" ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        delta = {
          navigate = true;
        };
        help = {
          autocorrect = 1;
        };
      };
    };
  };
}
