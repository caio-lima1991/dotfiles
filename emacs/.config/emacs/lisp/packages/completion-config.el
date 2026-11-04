;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Corfu — in-buffer completion frontend.
;; =============================================================================

(use-package corfu
  :ensure t
  :demand t
  :init
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator)
  (global-corfu-mode 1))

;; -----------------------------------------------------------------------------
;; Candidate documentation in a side popup
;; -----------------------------------------------------------------------------

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.3))
  :hook (corfu-mode . corfu-popupinfo-mode))

;; -----------------------------------------------------------------------------
;; Candidate history (persisted across sessions)
;; -----------------------------------------------------------------------------

(use-package corfu-history
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-history-mode)
  :config
  (defvar savehist-additional-variables)
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;; -----------------------------------------------------------------------------
;; Keybindings inside the popup
;; -----------------------------------------------------------------------------

(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "<tab>") #'corfu-complete)
  (define-key corfu-map (kbd "S-<tab>") #'corfu-previous)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous))

(provide 'completion-config)
