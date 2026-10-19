{ pkgs }:

pkgs.mkShell {
  packages = [ 
    pkgs.jdk25 
    pkgs.maven 
    pkgs.gradle 
    pkgs.python3 
    pkgs.python3Packages.pip 
    pkgs.nodejs_26 
    pkgs.pnpm 
  ];
  shellHook = ''
    export JAVA_HOME="${pkgs.jdk25}/lib/openjdk"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Default Dev Shell (Java 25, Python 3, Node 26, Maven & Gradle) Loaded"
  '';
}
