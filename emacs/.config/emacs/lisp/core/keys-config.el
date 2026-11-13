;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Global keybindings.
;; =============================================================================

(require 'functions-config)
(require 'textobjects-config)

(declare-function magit-status "magit" (&optional directory))
(declare-function vundo "vundo" (&optional arg))
(declare-function consult-fd "consult" (&optional dir initial))
(declare-function consult-ripgrep "consult" (&optional dir initial))
(declare-function consult-buffer "consult" (&optional source &rest sources))

(declare-function my/inside-string "textobjects-config" ())
(declare-function my/around-string "textobjects-config" ())
(declare-function my/inside-par "textobjects-config" ())
(declare-function my/around-par "textobjects-config" ())
(declare-function my/inside-list "textobjects-config" ())
(declare-function my/around-list "textobjects-config" ())
(declare-function my/inside-block "textobjects-config" ())
(declare-function my/around-block "textobjects-config" ())
(declare-function my/inside-defun "textobjects-config" ())
(declare-function my/around-defun "textobjects-config" ())
(declare-function my/inside-argument "textobjects-config" ())
(declare-function my/around-argument "textobjects-config" ())

;; -----------------------------------------------------------------------------
;; Files and search
;; -----------------------------------------------------------------------------

(define-key global-map (kbd "C-c f") #'consult-fd)
(define-key global-map (kbd "C-c g") #'consult-ripgrep)
(define-key global-map (kbd "C-c b") #'consult-buffer)

;; -----------------------------------------------------------------------------
;; Text objects (inside / around)
;; -----------------------------------------------------------------------------

(defvar my/textobject-inside-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s") #'my/inside-string)
    (define-key map (kbd "p") #'my/inside-par)
    (define-key map (kbd "l") #'my/inside-list)
    (define-key map (kbd "b") #'my/inside-block)
    (define-key map (kbd "d") #'my/inside-defun)
    (define-key map (kbd "a") #'my/inside-argument)
    map)
  "Mapa de text objects na variante inside (C-c i).")

(defvar my/textobject-around-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s") #'my/around-string)
    (define-key map (kbd "p") #'my/around-par)
    (define-key map (kbd "l") #'my/around-list)
    (define-key map (kbd "b") #'my/around-block)
    (define-key map (kbd "d") #'my/around-defun)
    (define-key map (kbd "a") #'my/around-argument)
    map)
  "Mapa de text objects na variante around (C-c a).")

(define-key global-map (kbd "C-c i") my/textobject-inside-map)
(define-key global-map (kbd "C-c a") my/textobject-around-map)

;; -----------------------------------------------------------------------------
;; Packages
;; -----------------------------------------------------------------------------

(define-key global-map (kbd "C-x g") #'magit-status)
(define-key global-map (kbd "C-x u") #'vundo)

(provide 'keys-config)
