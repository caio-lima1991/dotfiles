{ pkgs }:

pkgs.mkShell {
  packages = [ pkgs.python3 pkgs.python3Packages.pip ];
  shellHook = ''
    echo "Python 3 Development Shell Loaded"
  '';
}
