;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Snippets and LSP-backed completion sources.
;; =============================================================================

;; -----------------------------------------------------------------------------
;; Yasnippet — snippet engine.
;; -----------------------------------------------------------------------------

(use-package yasnippet
  :ensure t
  :demand t
  :init
  (setq yas-snippet-dirs (list (expand-file-name "snippets" user-emacs-directory))
        yas-indent-line 'auto
        yas-also-auto-indent-first-line t
        yas-snippet-revival t
        yas-triggers-in-field t)
  :hook ((prog-mode . yas-minor-mode)
         (eglot-managed-mode . yas-minor-mode))
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;; -----------------------------------------------------------------------------
;; Cape — extra CAPF sources
;; -----------------------------------------------------------------------------

(use-package cape
  :ensure t
  :demand t
  :init
  (defun my/cape-setup ()
    "Append the generic Cape sources after the language server, if any."
    (add-hook 'completion-at-point-functions #'cape-dabbrev nil t)
    (add-hook 'completion-at-point-functions #'cape-keyword nil t))
  :hook (prog-mode . my/cape-setup))

(provide 'snippet-config)
