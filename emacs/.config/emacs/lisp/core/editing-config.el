;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Auto-save and backup file handling.
;; =============================================================================

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup/" user-emacs-directory))))

(provide 'editing-config)
