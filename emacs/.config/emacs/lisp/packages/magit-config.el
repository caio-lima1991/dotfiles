;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Magit — Git interface.
;; =============================================================================
;; The `C-x g' binding is declared in `keys-config.el'.

(use-package magit
  :ensure t
  :commands (magit-status magit-dispatch))

(provide 'magit-config)
