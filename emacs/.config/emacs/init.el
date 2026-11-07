;; -*- lexical-binding: t; -*-

;; -----------------------------------------------------------------------------
;; Module search path
;; -----------------------------------------------------------------------------

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(dolist (dir '("lisp/core" "lisp/lsp" "lisp/packages"))
  (add-to-list 'load-path (expand-file-name dir user-emacs-directory) t))

(require 'package)
(require 'use-package)

(package-initialize)

;; -----------------------------------------------------------------------------
;; Custom file
;; -----------------------------------------------------------------------------

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil t))

;; -----------------------------------------------------------------------------
;; Core
;; -----------------------------------------------------------------------------

(require 'defaults-config)
(require 'editing-config)
(require 'ui-config)
(require 'session-config)
(require 'functions-config)
(require 'keys-config)

;; -----------------------------------------------------------------------------
;; LSP
;; -----------------------------------------------------------------------------

(require 'eglot-config)
(require 'java-config)
(require 'extra-servers)
(require 'treesit-config)

;; -----------------------------------------------------------------------------
;; Packages
;; -----------------------------------------------------------------------------

(require 'orderless-config)
(require 'vertico-config)
(require 'consult-config)
(require 'completion-config)
(require 'spell-config)
(require 'snippet-config)

(require 'magit-config)
(require 'vundo-config)
(require 'undo-config)
(require 'eat-config)
(require 'dape-config)
