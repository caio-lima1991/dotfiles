;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Eat Terminal
;; =============================================================================

(defun my/eat-mode-setup ()
  "Make an Eat buffer behave like a full-screen terminal."
  (display-line-numbers-mode -1)
  (hl-line-mode -1)
  (setq-local truncate-lines t)
  (setq-local word-wrap nil)
  (setq-local show-trailing-whitespace nil))

(declare-function eat-char-mode "eat")

(use-package eat
  :ensure t
  :demand t
  :hook (eat-mode . my/eat-mode-setup)
  :config
  (setq eat-term-name "xterm-256color")
  (when (string-empty-p (or (getenv "COLORTERM") ""))
    (setenv "COLORTERM" "truecolor"))

  (setq eat-very-visible-cursor-type '(box nil nil)
        eat-very-visible-vertical-bar-cursor-type '(bar nil nil)
        eat-very-visible-horizontal-bar-cursor-type '(hbar nil nil))
  )

(provide 'eat-config)
