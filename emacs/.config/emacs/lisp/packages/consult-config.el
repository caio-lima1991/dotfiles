;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Consult — search and navigation commands.
;; =============================================================================
;; Requires `fd' and `rg' on PATH. Both skip hidden paths by default, which

(use-package consult
  :ensure t
  :commands (consult-fd consult-ripgrep consult-line consult-buffer)
  :init
  (setq consult-preview-key (list "C-j" "C-SPC")
        consult-narrow-key "<")
  (setq consult-fd-args
        '((if (executable-find "fdfind" 'remote) "fdfind" "fd")
          "--full-path" "--hidden" "--color=never"))
  (setq consult-ripgrep-args
        '("rg" "--null" "--line-buffered" "--color=never" "--max-columns=1000"
          "--path-separator" "/" "--smart-case" "--no-heading" "--with-filename"
          "--line-number" "--search-zip" "--hidden"))
  :config
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(provide 'consult-config)
