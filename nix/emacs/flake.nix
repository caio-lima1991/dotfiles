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
        ripgrep
        fd
        fzf
        hurl

        # LSP
        jdt-language-server
        google-java-format

        sqls
        typescript-language-server
        prettier

        #Debuggers
        vscode-extensions.vscjava.vscode-java-debug
      ];
    };
  };
}
