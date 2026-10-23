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

;; In-Memory Undo Limits
(setq undo-limit 67108864)          ; 64MB undo limit
(setq undo-strong-limit 100663296)   ; 96MB
(setq undo-outer-limit 1006632960)  ; 1000MB

;; Dialog prompts in minibuffer instead of GUI popups
(setq use-dialog-box nil)

;; Clipboard integration
(setq select-enable-clipboard t)

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
;; 5b. TREE-SITTER (Fedora system grammars)
;; =============================================================================
;; Fedora ships grammars as `libtree-sitter-<lang>.so.<abi>` in /usr/lib64.
;; Emacs finds most of them automatically, but a few are named differently and
;; need an override of the form (LANG LIBRARY-BASE-NAME FUNCTION-NAME).

(when (treesit-available-p)
  ;; Help Emacs locate Fedora's grammar libraries (versioned sonames live here).
  (add-to-list 'treesit-extra-load-path "/usr/lib64")

  ;; Fedora names these differently from what Emacs expects internally.
  (setq treesit-load-name-override-list
        '((c-sharp "libtree-sitter-c-sharp" "tree_sitter_c_sharp")
          (php "libtree-sitter-php" "tree_sitter_php")))

  ;; Prefer tree-sitter major modes when the grammar is available; fall back to
  ;; the classic non-treesit mode otherwise.
  (dolist (map '((sh-mode . bash-ts-mode)
                 (c-mode . c-ts-mode)
                 (cmake-mode . cmake-ts-mode)
                 (csharp-mode . csharp-ts-mode)
                 (elixir-mode . elixir-ts-mode)
                 (go-mode . go-ts-mode)
                 (html-mode . html-ts-mode)
                 (java-mode . java-ts-mode)
                 (js-mode . js-ts-mode)
                 (json-mode . json-ts-mode)
                 (lua-mode . lua-ts-mode)
                 (php-mode . php-ts-mode)
                 (python-mode . python-ts-mode)
                 (ruby-mode . ruby-ts-mode)
                 (rust-mode . rust-ts-mode)
                 (toml-mode . toml-ts-mode)
                 (typescript-mode . typescript-ts-mode)
                 (yaml-mode . yaml-ts-mode)))
    (when (fboundp (cdr map))
      (add-to-list 'major-mode-remap-alist map))))

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
;; 8. VIPER MODE (Level 3 - Full Vi Emulation)
;; =============================================================================

(setq viper-mode 3)
(setq viper-expert-level 3)
(setq viper-inhibit-startup-message t)

(require 'viper)
(viper-mode)
(setq-default viper-mode 3)

