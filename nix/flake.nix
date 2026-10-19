{
  description = "Ambientes de desenvolvimento com Nix Shell e Profile";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "profile";
      paths = with pkgs; [
        neovim
        tmux
        w3m
        posting
        nb
        ripgrep
        fd
        fzf
        stow
        gzip
        hurl
        usql
        tree-sitter
      ];
    };

    devShells.${system} = {
      default = import ./shells/default.nix { inherit pkgs; };
      java25  = import ./shells/java25.nix { inherit pkgs; };
      java8   = import ./shells/java8.nix { inherit pkgs; };
      java7   = import ./shells/java7.nix { inherit pkgs; };
      python3 = import ./shells/python3.nix { inherit pkgs; };
      node26  = import ./shells/node26.nix { inherit pkgs; };
    };
  };
}
