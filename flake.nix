{
  description = "Pacotes padrão de desenvolvimento";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "profile";
      paths = with pkgs; [
        # Editores, Shell & Ferramentas de Terminal
        neovim
        tmux
        w3m
        posting
        nb

        # Runtimes & Compiladores
        nodejs_26
        pnpm
        jdk25
        gcc
        go

        # Busca, Navegação & Arquivos
        ripgrep
        fd
        fzf
        stow
        gzip

        # Ferramentas de Dev & Banco de Dados
        tree-sitter

        (usql.overrideAttrs (oldAttrs: {
          tags = [ "most" ];
        }))
      ];
    };
  };
}
