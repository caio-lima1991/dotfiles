;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Java support (Eclipse JDT Language Server) - Nix-managed version.
;; =============================================================================

(require 'eglot-config)

(defconst my/jdtls-workspaces (expand-file-name "~/.jdtls-workspace/")
  "Per-project JDT Language Server workspace directories.")

(defconst my/java-debug-jar-globs
  (list (expand-file-name
         "~/.nix-profile/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar")
        "/run/current-system/sw/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar")
  "Nix locations for the Microsoft Java Debug Server plugin JAR.")

(defun my/java-debug-jar ()
  "Return the Java Debug Server plugin JAR used by Dape, if installed.
JAVA_DEBUG_JAR overrides the search.  By default, the JAR is taken from
the Nix profile or system installation of `vscode-java-debug'."
  (let ((override (getenv "JAVA_DEBUG_JAR")))
    (or (and override (not (string-empty-p override)) (expand-file-name override))
        (seq-find #'file-exists-p
                  (seq-mapcat #'file-expand-wildcards my/java-debug-jar-globs)))))

(defun my/jdtls-server-contact (_interactive)
  "Start jdtls for the current project, with Lombok and a per-project workspace."
  (let* ((lombok-path (or (substitute-in-file-name "$HOME/.local/share/java/lombok.jar")
                          (executable-find "lombok.jar")))
         (java-debug-jar (my/java-debug-jar))
         (cmd (list (or (executable-find "jdtls") "jdtls")
                    "-data" (my/jdtls-workspace-for (project-current)))))

    (when (and lombok-path (file-exists-p lombok-path))
      (setq cmd (append cmd `(,(format "--jvm-arg=-javaagent:%s" lombok-path)))))
    (append cmd
            '("--jvm-arg=-Xmx1G")
            (when java-debug-jar
              (list :initializationOptions
                    `(:bundles [,java-debug-jar]))))))

(defun my/jdtls-workspace-for (project)
  "Return a stable jdtls workspace directory for PROJECT."
  (let ((name (if project
                  (file-name-nondirectory
                   (directory-file-name (project-root project)))
                "default")))
    (expand-file-name name my/jdtls-workspaces)))

(defconst my/java-runtimes
  `((:name "JavaSE-21" :path ,(or (getenv "JDK21_HOME") "java"))
    (:name "JavaSE-25" :path ,(or (getenv "JDK25_HOME") "java")
     :default t))
  "JDK installations offered to jdtls for building projects.")

(with-eval-after-load 'eglot
  (setq eglot-server-programs
        (cons `((java-mode java-ts-mode jdee-mode) . ,#'my/jdtls-server-contact)
              (assq-delete-all 'java-mode
                               (seq-remove (lambda (entry)
                                             (let ((modes (car entry)))
                                               (and (listp modes)
                                                    (memq 'java-ts-mode modes))))
                                           eglot-server-programs)))))

(setq eglot-workspace-configuration
      `(:java (:configuration (:runtimes ,my/java-runtimes
                                 :updateBuildConfiguration "automatic")
              :maven (:settingsFile ,(expand-file-name "~/.m2/settings.xml"))
              :eclipse (:downloadSources t))))

(provide 'java-config)
