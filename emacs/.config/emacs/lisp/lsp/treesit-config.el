;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Tree-sitter (system grammars, distribution-agnostic).
;; =============================================================================

(when (treesit-available-p)
  (dolist (libdir '("/usr/lib64" "/usr/lib" "/usr/local/lib64" "/usr/local/lib"))
    (dolist (candidate (list (expand-file-name "tree-sitter" libdir) libdir))
      (when (and (file-directory-p candidate)
                 (directory-files candidate nil "^libtree-sitter-.+\\.so"))
        (add-to-list 'treesit-extra-load-path candidate))))

  (dolist (map '((c-mode . c-ts-mode)
                 (c++-mode . c++-ts-mode)
                 (cmake-mode . cmake-ts-mode)
                 (csharp-mode . csharp-ts-mode)
                 (css-mode . css-ts-mode)
                 (dockerfile-mode . dockerfile-ts-mode)
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
                 (sh-mode . bash-ts-mode)
                 (toml-mode . toml-ts-mode)
                 (typescript-mode . typescript-ts-mode)
                 (tsx-mode . tsx-ts-mode)
                 (yaml-mode . yaml-ts-mode)))
    (let* ((name (string-remove-suffix "-ts-mode" (symbol-name (cdr map))))
           (grammar (intern (or (cdr (assoc name '(("js" . "javascript"))))
                                name))))
      (when (and (fboundp (cdr map))
                 (treesit-language-available-p grammar))
        (add-to-list 'major-mode-remap-alist map)))))

(provide 'treesit-config)
