;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Theme, frame and visual elements.
;; =============================================================================

;; -----------------------------------------------------------------------------
;; Line numbers & highlights
;; -----------------------------------------------------------------------------

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(global-hl-line-mode t)

;; -----------------------------------------------------------------------------
;; Theme
;; -----------------------------------------------------------------------------

(load-theme 'modus-vivendi t)

(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(tool-bar-mode -1)

(modify-all-frames-parameters '((undecorated . t)))
(add-to-list 'default-frame-alist '(undecorated . t))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(provide 'ui-config)
