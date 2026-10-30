;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Desktop session persistence.
;; =============================================================================

(require 'desktop)

(setq desktop-path (list user-emacs-directory)
      desktop-dirname user-emacs-directory
      desktop-base-file-name "emacs-desktop"
      desktop-restore-eager 5)

(desktop-save-mode 1)

(provide 'session-config)
