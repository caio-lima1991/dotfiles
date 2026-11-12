;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Expand Region — aumento incremental da região por unidades semânticas.
;; =============================================================================
;; O `C-=' expande a região pelas unidades que o próprio pacote reconhece e o
;; `C--' contrai. A integração com os text objects treesit é intencionalmente
;; ausente: cada ferramenta mantém a sua responsabilidade isolada.

(use-package expand-region
  :ensure t
  :commands (er/expand-region er/contract-region)
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

(provide 'expand-region-config)
