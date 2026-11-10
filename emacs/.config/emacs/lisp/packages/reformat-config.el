;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Formatter Configuration (NonGNU ELPA: reformatter)
;; =============================================================================

(use-package reformatter
  :ensure t
  :config
  (reformatter-define google-java-format
    :program "google-java-format"
    :args '("--aosp" "-")
    :mode 'java-mode)

  (add-hook 'java-ts-mode-hook #'google-java-format-on-save-mode)


  (reformatter-define prettier-format
    :program "prettier"
    :args (let ((file (buffer-file-name)))
            (if (and file (not (string-empty-p file)))
                (list "--stdin-filepath" file)
              '("--stdin")))
    :mode 'javascript-mode)

  (dolist (hook '(javascript-ts-mode-hook
                  typescript-mode-hook typescript-ts-mode-hook
                  js-jsx-mode-hook typescript-tsx-mode-hook
                  ng-ts-mode-hook
                  json-mode-hook json-ts-mode-hook
                  css-mode-hook scss-mode-hook
                  html-mode-hook mhtml-mode-hook
                  markdown-mode-hook
                  yaml-mode-hook))
    (add-hook hook #'prettier-format-on-save-mode)))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (add-hook 'before-save-hook
                      (lambda ()
                        (unless (or (bound-and-true-p google-java-format-on-save-mode)
                                    (bound-and-true-p prettier-format-on-save-mode))
                          (ignore-errors
                            (when (eglot-server-capable :documentFormattingProvider)
                              (eglot-format-buffer)))))
                      nil t)))

(provide 'reformat-config)
