;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Org — Notas, tarefas e agenda.
;; =============================================================================

(require 'org)

;; -----------------------------------------------------------------------------
;; Diretório do vault (fonte única de verdade)
;; -----------------------------------------------------------------------------

(defvar my/org-directory (expand-file-name "~/org")
  "Diretório raiz do vault Org.")

(defvar my/org-agenda-file (expand-file-name "agenda.org" my/org-directory)
  "Arquivo central de tarefas e agenda.")

(defvar my/org-notes-directory (expand-file-name "notes" my/org-directory)
  "Diretório das notas organizadas por área.")

;; -----------------------------------------------------------------------------
;; Agenda
;; -----------------------------------------------------------------------------

(setq org-agenda-files (list my/org-directory))

(setq org-agenda-start-on-weekday nil)
(setq org-agenda-span 'day)
(setq org-agenda-window-setup 'current-window)
(setq org-agenda-restore-windows-after-quit t)

;; Palavras-chave de fluxo (GTD).
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)")
        (sequence "PROJ(p)" "|" "CANCEL(c)")))

;; Cores das palavras-chave.
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "orange" :weight bold))
        ("NEXT" . (:foreground "cyan" :weight bold))
        ("WAIT" . (:foreground "magenta" :weight bold))
        ("PROJ" . (:foreground "yellow" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))
        ("CANCEL" . (:foreground "gray" :weight bold))))

;; Não usar refile de subtarefas para fora da hierarquia.
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; -----------------------------------------------------------------------------
;; Captura (GTD)
;; -----------------------------------------------------------------------------

(setq org-default-notes-file my/org-agenda-file)
(setq org-capture-templates
      `(("t" "Tarefa" entry
         (file+headline ,my/org-agenda-file "Inbox")
         "* TODO %?\n  %U\n  %a")
        ("n" "Nota rápida" entry
         (file+headline ,my/org-agenda-file "Inbox")
         "* %?\n  %U")
        ("p" "Projeto" entry
         (file+headline ,my/org-agenda-file "Projetos")
         "* PROJ %?\n  %U")))

;; -----------------------------------------------------------------------------
;; Hábitos de escrita
;; -----------------------------------------------------------------------------

(setq org-startup-folded 'content)
(setq org-startup-indented t)
(setq org-return-follows-link t)
(setq org-adapt-indentation nil)
(setq org-hide-emphasis-markers t)
(setq org-pretty-entities t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)

;; Arquivos de backup/auto-save fora do vault.
(setq org-archive-location "%s_archive::* Arquivadas")

;; -----------------------------------------------------------------------------
;; Links entre notas
;; -----------------------------------------------------------------------------

(setq org-link-file-search-max-levels 10)

(provide 'org-config)
