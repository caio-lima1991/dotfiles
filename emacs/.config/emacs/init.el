;; =============================================================================
;; 1. GENERAL OPTIONS & EDITOR BEHAVIOR
;; =============================================================================

;; Relative line numbers & line highlights
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(global-hl-line-mode t)

;; Indentation (4 spaces, convert tabs to spaces)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; Case sensitivity for search & completion
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Window splitting preferences
(setq split-height-threshold 80)
(setq split-width-threshold 160)

;; In-Memory Undo Limits & File Backups
(setq undo-limit 67108864)          ; 64MB undo limit
(setq undo-strong-limit 100663296)   ; 96MB
(setq undo-outer-limit 1006632960)  ; 1000MB
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;; Dialog prompts in minibuffer instead of GUI popups
(setq use-dialog-box nil)
(setq confirm-kill-emacs 'y-or-n-p)

;; Clipboard integration
(setq select-enable-clipboard t)

;; Isolate auto-generated Custom settings to a separate file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Exit immediately without asking for confirmation
(setq confirm-kill-emacs nil)
(setq frame-background-mode 'dark)

;; =============================================================================
;; 2. THEME & UI
;; =============================================================================

;; Load Theme
(load-theme 'modus-vivendi t)

;; =============================================================================
;; 3. SESSIONS (per-directory, auto-restore / auto-save)
;; =============================================================================

(require 'desktop)
(setq desktop-path (list user-emacs-directory))
(setq desktop-dirname user-emacs-directory)
(setq desktop-base-file-name "emacs-desktop")
(setq desktop-restore-eager 5)

;; Auto-save session on exit & restore if present
(desktop-save-mode 1)

;; =============================================================================
;; 4. CUSTOM COMMANDS (Copy Path / RelPath)
;; =============================================================================

;; Helper to get project root directory natively
(defun ge-project-root ()
  "Get current project root directory."
  (if-let ((project (project-current)))
      (project-root project)
    default-directory))

(defun my/copy-file-path ()
  "Copy absolute path of current buffer file to clipboard."
  (interactive)
  (if-let ((file (buffer-file-name)))
      (progn
        (kill-new file)
        (message "Copied absolute path: %s" file))
    (message "Buffer is not visiting a file")))

(defun my/copy-relative-file-path ()
  "Copy relative path of current buffer file to clipboard."
  (interactive)
  (if-let ((file (buffer-file-name)))
      (let ((rel-path (file-relative-name file (ge-project-root))))
        (kill-new rel-path)
        (message "Copied relative path: %s" rel-path))
    (message "Buffer is not visiting a file")))

;; =============================================================================
;; 5. NATIVE EGLOT (LSP) HOOKS
;; =============================================================================

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c c a") 'eglot-code-actions))

;; =============================================================================
;; 6. Magit
;; =============================================================================

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; =============================================================================
;; 7. UNDO MANAGEMENT (Vundo & Persistent Session)
;; =============================================================================

;; Visual Undo Tree
(use-package vundo
  :ensure t
  :bind ("C-c u" . vundo))

;; Save undo history to disk across restarts
(use-package undo-fu-session
  :ensure t
  :config
  (setq undo-fu-session-directory (concat user-emacs-directory "undo"))
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (global-undo-fu-session-mode 1))

;; =============================================================================
;; 8. STOW ISOLATION & DUST BINS (~/.local/share/emacs/)
;; =============================================================================

;; Define isolated storage directory under ~/.local/share/emacs/
(defvar my-emacs-data-dir
  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share")))

;; Move custom-file outside Stow
(setq custom-file (expand-file-name "custom.el" my-emacs-data-dir))
(when (file-exists-p custom-file)
  (load custom-file t))

;; Redirect backups, auto-saves, and lockfiles
(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" my-emacs-data-dir)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" my-emacs-data-dir) t))
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" my-emacs-data-dir)
      create-lockfiles nil)

;; Redirect native-compilation (.eln cache) out of Stow
(when (boundp 'native-comp-eln-load-path)
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" my-emacs-data-dir)))

;; Redirect built-in caches (url, transient, recentf, undo-fu, etc.)
(setq url-history-file (expand-file-name "url/history" my-emacs-data-dir)
      recentf-save-file (expand-file-name "recentf" my-emacs-data-dir))

;; =============================================================================
;; 9. VIPER MODE (Level 3 - Full Vi Emulation)
;; =============================================================================

(setq viper-mode 3)
(setq viper-expert-level 3)
(setq viper-inhibit-startup-message t)

(require 'viper)
(viper-mode)
(setq-default viper-mode 3)
