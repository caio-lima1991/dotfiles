;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Language servers not covered by Eglot's built-in table.
;; =============================================================================

(require 'eglot-config)

(defun my/register-lsp (modes command)
  "Register COMMAND as the language server for MODES, if it is installed.
MODES is a list of major-mode symbols; COMMAND is the server command vector."
  (when (executable-find (car command))
    (add-to-list 'eglot-server-programs (cons modes command))))

(with-eval-after-load 'eglot
  (my/register-lsp '(sql-mode sql-ts-mode)
                   '("sqls"))

  (my/register-lsp '(nxml-mode xml-mode)
                   '("lemminx"))

  (my/register-lsp '(angular-mode ng-ts-mode typescript-ts-mode)
                   '("ngserver" "--stdio" "--tsProbeLocations" "" "--ngProbeLocations" "")))

(provide 'extra-servers)
