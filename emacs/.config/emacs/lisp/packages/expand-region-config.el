;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Expand Region
;; =============================================================================

(use-package expand-region
  :ensure t
  :commands (er/expand-region er/contract-region
             er/mark-inside-pairs er/mark-outside-pairs
             er/mark-inside-quotes er/mark-outside-quotes
             er/mark-word er/mark-defun)
  :bind (("C-="     . er/expand-region)
         ("C--"     . er/contract-region)
         ("C-c i p" . er/mark-inside-pairs)
         ("C-c x p" . er/mark-outside-pairs)
         ("C-c i q" . er/mark-inside-quotes)
         ("C-c x q" . er/mark-outside-quotes)
         ("C-c i w" . er/mark-word)
         ("C-c i d" . er/mark-defun)))

(provide 'expand-region-config)
