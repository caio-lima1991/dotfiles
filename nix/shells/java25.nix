{ pkgs }:

pkgs.mkShell {
  packages = [ pkgs.jdk25 pkgs.maven pkgs.gradle ];
  shellHook = ''
    export JAVA_HOME="${pkgs.jdk25}/lib/openjdk"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Java 25 Development Shell Loaded (Maven & Gradle available)"
  '';
}
