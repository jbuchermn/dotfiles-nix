{
  pkgs,
  inputs
}: let
  utils = inputs.nixCats.utils;
  pluginGit = ref: rev: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
  lib = pkgs.lib;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  mkNeovimConfig = { packageName, enabledCategories, aliases }: {
    nixCats = {
      enable = true;
      addOverlays =
        # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];

      packageNames = [ packageName ];

      luaPath = ./.;

      categoryDefinitions.replace = (
        {
          pkgs,
          ...
        } @ packageDef: {
          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = {
            basic = with pkgs; [
              lazygit
              ripgrep
            ];
            lua = with pkgs; [
              lua-language-server
              stylua
            ];
            nix = with pkgs; [
              nixd
              alejandra
            ];
            c = with pkgs; [
              ccls
            ];
            typescript = [
              # servers provided either in dev env or via nixCats.extras
            ];
            python = [
              # server provided either in dev env or via nixCats.extras
            ];
            haskell = [
              # ghc and haskell-language-server need to be provided by dev env
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            basic = with pkgs.vimPlugins; [
              # lazy loading isnt required with a config this small
              # but as a demo, we do it anyway.
              lze
              lzextras
              snacks-nvim
              onedark-nvim
              vim-sleuth
            ];
            haskell = with pkgs.vimPlugins; [
              haskell-tools-nvim
            ];
          };

          # Not loaded automatically at startup - use lazy loading
          optionalPlugins = {
            lua = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            basic = with pkgs.vimPlugins; [
              mini-nvim
              nvim-lspconfig
              vim-startuptime
              nvim-treesitter.withAllGrammars
              lualine-nvim
              lualine-lsp-progress
              gitsigns-nvim
              which-key-nvim
            ];
            extended = with pkgs.vimPlugins; [
              blink-cmp
              nvim-lint
              conform-nvim
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
            markdown = with pkgs.vimPlugins; [
              render-markdown-nvim
              (pluginGit "58f958a2dcfb974963d4bb772ad8c3d8a1c62774" "58f958a2dcfb974963d4bb772ad8c3d8a1c62774" "opdavies/toggle-checkbox.nvim")
            ];
          };

          # shared libraries to be added to LD_LIBRARY_PATH
          sharedLibraries = {
          };

          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            # test = {
            #   CATTESTVAR = "It worked!";
            # };
          };

          python3.libraries = {
            # test = [ (_:[]) ];
          };

          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            # test = [
            #   '' --set CATTESTVAR2 "It worked again!"''
            # ];
          };
        }
      );

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        "${packageName}" = {
          pkgs,
          name,
          ...
        }: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # unwrappedCfgPath = "/path/to/here";
            inherit aliases;

            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
            hosts.python3.enable = true;
            hosts.node.enable = true;
          };

          categories = enabledCategories;

          # anything else to pass and grab in lua with `nixCats.extra`
          extra = {
            nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
            python.pylsp = "${pkgs.python3.withPackages (ps: with ps; [python-lsp-server])}/bin/pylsp";
            typescript.typescript-language-server = "${pkgs.typescript-language-server}/bin/typescript-language-server";
            typescript.svelteserver = "${pkgs.svelte-language-server}/bin/svelteserver";
            typescript.tailwindcss-language-server = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
          };
        };
      };
    };
  };
}
