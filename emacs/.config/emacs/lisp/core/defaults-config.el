;; -*- lexical-binding: t; -*-

;; =============================================================================
;; General options and editor behaviour.
;; =============================================================================

;; -----------------------------------------------------------------------------
;; Window splitting preferences
;; -----------------------------------------------------------------------------

(setq split-height-threshold 80)
(setq split-width-threshold 160)

;; -----------------------------------------------------------------------------
;; In-memory undo limits
;; -----------------------------------------------------------------------------

(setq undo-limit 67108864)           ; 64MB undo limit
(setq undo-strong-limit 100663296)   ; 96MB
(setq undo-outer-limit 1006632960)   ; 1000MB

;; -----------------------------------------------------------------------------
;; Prompts, clipboard and exit behaviour
;; -----------------------------------------------------------------------------

;; Dialog prompts in minibuffer instead of GUI popups.
(setq use-dialog-box nil)

;; Clipboard integration.
(setq select-enable-clipboard t)

;; Exit immediately without asking for confirmation.
(setq confirm-kill-emacs nil)
(setq frame-background-mode 'dark)

;; -----------------------------------------------------------------------------
;; Project
;; -----------------------------------------------------------------------------

(tab-bar-mode 1)
(setq tab-bar-tab-name-function #'tab-bar-tab-name-current-with-count)
(setq project-kill-buffers-display-buffer-list t)

(provide 'defaults-config)
