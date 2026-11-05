;; -*- lexical-binding: t; -*-

;; =============================================================================
;; General options and editor behaviour.
;; =============================================================================

(add-to-list 'warning-suppress-types '(files))

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
(setq auto-save-default nil)
(setq make-backup-files nil)

;; =============================================================================
;; Configuração Global de Indentação (Espaços em vez de Tabs)
;; =============================================================================

(setq-default indent-tabs-mode nil)

(setq-default standard-indent 4)
(setq-default tab-width 4)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)))

;; -----------------------------------------------------------------------------
;; Prompts, clipboard and exit behaviour
;; -----------------------------------------------------------------------------

(setq use-dialog-box nil)

(setq select-enable-clipboard t)

(setq confirm-kill-emacs nil)
(setq frame-background-mode 'dark)

;; -----------------------------------------------------------------------------
;; Project
;; -----------------------------------------------------------------------------

(tab-bar-mode 1)
(setq tab-bar-tab-name-function #'tab-bar-tab-name-current-with-count)
(setq project-kill-buffers-display-buffer-list t)

(provide 'defaults-config)

;; =============================================================================
;; VIPER MODE
;; =============================================================================

(setq viper-mode 3)
(setq viper-expert-level 3)
(setq viper-inhibit-startup-message t)

(require 'viper)
(viper-mode)
(setq-default viper-mode 3)
