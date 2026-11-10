;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Eglot
;; =============================================================================

;; -----------------------------------------------------------------------------
;; Connection behaviour
;; -----------------------------------------------------------------------------

(setq eglot-sync-connect 1
      eglot-connect-timeout 30
      eglot-autoshutdown t
      eglot-events-buffer-size 0)

;; -----------------------------------------------------------------------------
;; Start Eglot automatically
;; -----------------------------------------------------------------------------

(defun my/eglot-ensure-on-programming ()
  "Start Eglot when a language server is available for this buffer."
  (when (and (or (derived-mode-p 'prog-mode 'text-mode)
                 (derived-mode-p 'lua-ts-mode))
             (not (my/eglot-running-p)))
    (eglot-ensure)))

(defun my/eglot-running-p ()
  "Return non-nil when an Eglot server manages the current buffer."
  (and (fboundp 'eglot-current-server)
       (eglot-current-server)))

(require 'eglot)

(add-hook 'prog-mode-hook #'my/eglot-ensure-on-programming)
(add-hook 'text-mode-hook #'my/eglot-ensure-on-programming)

;; -----------------------------------------------------------------------------
;; ElDoc — signature and documentation for the symbol at point
;; -----------------------------------------------------------------------------

(setq eldoc-idle-delay 0.3
      eldoc-echo-area-use-multiline-p nil)

(with-eval-after-load 'eglot
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose))

(defun my/eglot-documentation-buffer ()
  "Show the full LSP documentation of the symbol at point in its own buffer.
Falls back to a message when the server has nothing to report for the
current position."
  (interactive)
  (let ((doc (eldoc-doc-buffer)))
    (if (and doc (> (buffer-size doc) 0))
        (display-buffer doc)
      (message "No documentation available for the symbol at point"))))

;; -----------------------------------------------------------------------------
;; Keybindings (active only in buffers where Eglot is running)
;; -----------------------------------------------------------------------------

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c c f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c c i") #'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c c d") #'my/eglot-documentation-buffer)
  (define-key eglot-mode-map (kbd "C-c t f") #'my/toggle-format-on-save))

(provide 'eglot-config)
