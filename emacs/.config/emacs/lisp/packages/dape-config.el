;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Dape — Debug Adapter Protocol client.
;; =============================================================================

(declare-function dape-breakpoint-global-mode "dape" (&optional arg))

(use-package dape
  :ensure t
  :demand t
  :init
  (setq dape-buffer-window-arrangement 'right
        dape-key-prefix (kbd "C-c d"))
  :config
  (dape-breakpoint-global-mode 1))

(provide 'dape-config)
