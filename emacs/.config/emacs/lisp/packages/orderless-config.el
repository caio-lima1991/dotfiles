;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Orderless — multi-word fuzzy completion style.
;; =============================================================================

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion))))
  :config
  (setq orderless-matching-styles '(orderless-literal
                                    orderless-regexp)))

(provide 'orderless-config)
