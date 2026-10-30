;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Vertico — vertical minibuffer completion.
;; =============================================================================

(use-package vertico
  :ensure t
  :init
  (setq vertico-cycle t)
  :config
  (vertico-mode 1))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(provide 'vertico-config)
