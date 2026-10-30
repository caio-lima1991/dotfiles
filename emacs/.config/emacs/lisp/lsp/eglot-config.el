;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Eglot (native LSP client).
;; =============================================================================

(defconst my/lsp-dir (expand-file-name "~/.local/bin/lsp/")
  "Directory holding self-contained language servers.")

(add-to-list 'exec-path my/lsp-dir)
(add-to-list 'exec-path (expand-file-name "bin" my/lsp-dir))
(dolist (server-dir (directory-files my/lsp-dir t "^[^.]" t))
  (let ((bin (expand-file-name "bin" server-dir)))
    (when (file-directory-p bin)
      (add-to-list 'exec-path bin))))

;; -----------------------------------------------------------------------------
;; Connection behaviour
;; -----------------------------------------------------------------------------

(setq eglot-sync-connect 1
      eglot-connect-timeout 30
      eglot-autoshutdown t
      eglot-events-buffer-size 0)      ; no unbounded *EGLOT events* growth

;; -----------------------------------------------------------------------------
;; Start Eglot automatically
;; -----------------------------------------------------------------------------

(defun my/eglot-ensure-on-programming ()
  "Start Eglot when a language server is available for this buffer.
Errors are trapped so that a failure here can never abort the rest of
`prog-mode-hook' / `text-mode-hook'."
  (when (and (derived-mode-p 'prog-mode 'text-mode)
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
;; Keybindings (active only in buffers where Eglot is running)
;; -----------------------------------------------------------------------------

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c c f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c c i") #'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c t f") #'my/toggle-format-on-save))


(provide 'eglot-config)
