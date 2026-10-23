;; =============================================================================
;; EARLY INIT: ISOLATE ALL EMACS RUNTIME DATA & ELPA TO ~/.local/share/emacs/
;; =============================================================================

(eval-and-compile
  (let ((data-dir (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share/"))))
    ;; Move user-emacs-directory out of ~/.config/emacs/
    (setq user-emacs-directory data-dir)

    ;; Redirect package.el (ELPA) directory
    (setq package-user-dir (expand-file-name "elpa/" data-dir))

    ;; Redirect native compilation (.eln) cache immediately
    (when (boundp 'native-comp-eln-load-path)
      (startup-redirect-eln-cache (expand-file-name "eln-cache/" data-dir)))))
