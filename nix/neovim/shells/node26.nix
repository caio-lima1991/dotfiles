{ pkgs }:

pkgs.mkShell {
  packages = [ pkgs.nodejs_26 pkgs.pnpm ];
  shellHook = ''
    echo "Node.js 26 Development Shell Loaded"
  '';
}
