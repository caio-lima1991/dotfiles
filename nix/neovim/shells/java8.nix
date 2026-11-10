{ pkgs }:

pkgs.mkShell {
  packages = [ pkgs.jdk8 pkgs.jdk25 pkgs.maven ];
  shellHook = ''
    export JAVA_HOME="${pkgs.jdk8}/lib/openjdk"
    export JAVA_JDTLS="${pkgs.jdk25}/lib/openjdk"
    export JDTLS_RUNTIMES="JavaSE-1.8=$JAVA_HOME,JavaSE-25=$JAVA_JDTLS"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Java 8 Development Shell Loaded"
  '';
}
