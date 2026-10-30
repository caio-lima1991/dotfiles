;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Global keybindings.
;; =============================================================================

(require 'functions-config)

(declare-function magit-status "magit" (&optional directory))
(declare-function vundo "vundo" (&optional arg))

;; -----------------------------------------------------------------------------
;; Packages
;; -----------------------------------------------------------------------------

(define-key global-map (kbd "C-x g") #'magit-status)
(define-key global-map (kbd "C-x u") #'vundo)

(provide 'keys-config)
