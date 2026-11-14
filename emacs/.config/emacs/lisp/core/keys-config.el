;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Global keybindings.
;; =============================================================================

(require 'functions-config)

(declare-function magit-status "magit" (&optional directory))
(declare-function vundo "vundo" (&optional arg))
(declare-function consult-fd "consult" (&optional dir initial))
(declare-function consult-ripgrep "consult" (&optional dir initial))
(declare-function consult-buffer "consult" (&optional source &rest sources))

;; -----------------------------------------------------------------------------
;; Files and search
;; -----------------------------------------------------------------------------

(define-key global-map (kbd "C-c f") #'consult-fd)
(define-key global-map (kbd "C-c g") #'consult-ripgrep)
(define-key global-map (kbd "C-c b") #'consult-buffer)

;; -----------------------------------------------------------------------------
;; Packages
;; -----------------------------------------------------------------------------

(define-key global-map (kbd "C-x g") #'magit-status)
(define-key global-map (kbd "C-x u") #'vundo)

(provide 'keys-config)
