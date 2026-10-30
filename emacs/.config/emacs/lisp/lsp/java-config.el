;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Java support (Eclipse JDT Language Server).
;; =============================================================================

(require 'eglot-config)

(defconst my/jdk-dir (expand-file-name "~/jdk/")
  "Directory holding the JDK installations used for project runtimes.")

(defconst my/jdtls-dir (expand-file-name "jdtls/" my/lsp-dir)
  "Root of the Eclipse JDT Language Server installation.")

(defconst my/jdtls-launcher (expand-file-name "bin/jdtls" my/jdtls-dir)
  "Launcher script for the Eclipse JDT Language Server.")

(defconst my/jdtls-java (expand-file-name "jdk-21.0.12.1+1/bin/java" my/jdk-dir)
  "JDK used to run the JDT Language Server (requires Java 21 or newer).")

(defconst my/jdtls-lombok (expand-file-name "lombok.jar" my/jdtls-dir)
  "Lombok agent injected into the JDT Language Server JVM.")

(defconst my/jdtls-workspaces (expand-file-name "~/.jdtls-workspace/")
  "Per-project JDT Language Server workspace directories.")

(defconst my/java-runtimes
  `((:name "JavaSE-1.7" :path ,(expand-file-name "java-se-7u75-ri" my/jdk-dir))
    (:name "JavaSE-1.8" :path ,(expand-file-name "jdk8u482-b08" my/jdk-dir))
    (:name "JavaSE-21"  :path ,(expand-file-name "jdk-21.0.12.1+1" my/jdk-dir))
    (:name "JavaSE-25"  :path ,(expand-file-name "jdk-25.0.2+10" my/jdk-dir)
     :default t))
  "JDK installations offered to jdtls for building projects.")

(defun my/jdtls-workspace-for (project)
  "Return a stable jdtls workspace directory for PROJECT."
  (let ((name (if project
                  (file-name-nondirectory
                   (directory-file-name (project-root project)))
                "default")))
    (expand-file-name name my/jdtls-workspaces)))

(defun my/jdtls-server-contact (_interactive)
  "Start jdtls for the current project, with Lombok and a per-project workspace."
  (list my/jdtls-launcher
        "--java-executable" my/jdtls-java
        (format "--jvm-arg=-javaagent:%s" my/jdtls-lombok)
        "--jvm-arg=-Xmx1G"
        "-data" (my/jdtls-workspace-for (project-current))))

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
