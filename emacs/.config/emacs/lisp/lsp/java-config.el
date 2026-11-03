;; =============================================================================
;; Java support (Eclipse JDT Language Server) - Nix-managed version.
;; =============================================================================

(require 'eglot-config)

(defconst my/jdtls-workspaces (expand-file-name "~/.jdtls-workspace/")
  "Per-project JDT Language Server workspace directories.")


(defun my/jdtls-server-contact (_interactive)
  "Start jdtls for the current project, with Lombok and a per-project workspace."
  (let* ((lombok-path (or (substitute-in-file-name "$HOME/.local/share/java/lombok.jar")
                          (executable-find "lombok.jar")))
         (cmd (list (or (executable-find "jdtls") "jdtls")
                    "-data" (my/jdtls-workspace-for (project-current)))))

    (when (and lombok-path (file-exists-p lombok-path))
      (setq cmd (append cmd `(,(format "--jvm-arg=-javaagent:%s" lombok-path)))))
    (append cmd '("--jvm-arg=-Xmx1G"))))

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
