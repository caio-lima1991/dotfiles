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
      eglot-events-buffer-size 0)       ; no unbounded *EGLOT events* growth

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
;; Format on save
;; -----------------------------------------------------------------------------

(defvar my/format-on-save t
  "When non-nil, format the buffer on save through Eglot.")

(defun my/eglot-format-on-save ()
  "Format the current buffer before saving, if Eglot supports it.
Any failure is swallowed so that formatting can never prevent a save."
  (when my/format-on-save
    (ignore-errors
      (when (and (my/eglot-running-p)
                 (eglot-server-capable :documentFormattingProvider))
        (eglot-format-buffer)))))

(add-hook 'before-save-hook #'my/eglot-format-on-save)

(defun my/toggle-format-on-save ()
  "Toggle formatting on save and report the new state."
  (interactive)
  (setq my/format-on-save (not my/format-on-save))
  (message "Format on save %s" (if my/format-on-save "enabled" "disabled")))

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
