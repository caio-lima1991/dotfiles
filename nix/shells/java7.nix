{ pkgs }:

pkgs.mkShell {
  packages = [ pkgs.jdk25 pkgs.maven-3_6_3 ];
  shellHook = ''
    export JAVA_HOME="$HOME/jdk/java-se-7u75-ri"
    export JAVA_JDTLS="${pkgs.jdk25}/lib/openjdk"
    export JDTLS_RUNTIMES="JavaSE-1.7=$JAVA_HOME,JavaSE-25=$JAVA_JDTLS"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "Java 7 Development Shell Loaded"
  '';
}
