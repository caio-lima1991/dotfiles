;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Persistent undo history.
;; =============================================================================

(use-package undo-fu-session
  :ensure t
  :init
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'"
                                             "/git-rebase-todo\\'")
        undo-fu-session-directory (expand-file-name "undo-fu-session/"
                                                    user-emacs-directory))
  :config
  (undo-fu-session-global-mode 1))

(provide 'undo-config)
