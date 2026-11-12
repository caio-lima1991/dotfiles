;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Text objects (inside / around), inspirados no Neovim.
;;
;; Cada text object tem duas variantes:
;;   - inside: o conteúdo, sem os delimitadores (ex.: dentro de `"..."' ou `(...)')
;;   - around: o conteúdo com os delimitadores
;;
;; O comando apenas marca a região; a ação (kill, delete, replace) fica a
;; critério do usuário, como no fluxo nativo do Emacs.
;;
;; A resolução de limites é feita exclusivamente por treesit. Em buffers sem
;; parser, os comandos não têm efeito.
;; =============================================================================

(require 'treesit)
(require 'cl-lib)

;; -----------------------------------------------------------------------------
;; Internal helpers
;; -----------------------------------------------------------------------------

(defun my/textobject--mark (beg end)
  "Marcar a região entre BEG e END, movendo o ponto para END."
  (goto-char end)
  (set-mark beg)
  (activate-mark))

(defun my/textobject--treesit-ok-p ()
  "Retornar não-nil se o buffer atual tem árvore treesit utilizável."
  (and (treesit-available-p)
       (treesit-parser-list)))

(defun my/textobject--node-parents (&optional node)
  "Retornar NODE e todos os ancestrais, do mais interno ao mais externo."
  (let ((result nil)
        (current (or node (treesit-node-at (point)))))
    (while current
      (push current result)
      (setq current (treesit-node-parent current)))
    (nreverse result)))

(defun my/textobject--find-node (types)
  "Buscar o primeiro nó cujo tipo esteja em TYPES.

A busca percorre a cadeia de ancestrais do ponto (do mais interno ao mais
externo) e, para cada ancestral, também considera seu filho direto que
case com TYPES — necessário para casos como `call_expression', cujo
`argument_list' é filho e não ancestral."
  (let ((nodes (my/textobject--node-parents))
        (found nil))
    (while (and nodes (not found))
      (let* ((node (car nodes))
             (child (cl-find-if (lambda (c)
                                  (member (treesit-node-type c) types))
                                (treesit-node-children node t))))
        (cond
         ((member (treesit-node-type node) types)
          (setq found node))
         (child
          (setq found child)))
        (setq nodes (cdr nodes))))
    found))

(defun my/textobject--mark-node (node inside-p)
  "Marcar NODE. Se INSIDE-P, marca apenas o conteúdo entre os delimitadores.

Os delimitadores são reconhecidos como os tokens de abertura e fechamento
do nó (parênteses, chaves, aspas ou o par `begin'/`end'). Sem delimitadores
reconhecíveis, INSIDE-P e around coincidem."
  (if (not inside-p)
      (my/textobject--mark (treesit-node-start node) (treesit-node-end node))
    (let* ((start (treesit-node-start node))
           (end (treesit-node-end node))
           (children (treesit-node-children node))
           (opener (car children))
           (closer (car (last children)))
           (openers '("(" "[" "{" "\"" "'" "`" "<"))
           (closers '(")" "]" "}" "\"" "'" "`" ">"))
           (begin-words '("begin" "do" "then"))
           (opener-text (and opener (treesit-node-text opener t)))
           (closer-text (and closer (treesit-node-text closer t))))
      (when (and opener-text closer-text
                 (member opener-text openers)
                 (member closer-text closers))
        (setq start (treesit-node-end opener)
              end (treesit-node-start closer)))
      (when (and opener-text (member opener-text begin-words))
        (setq start (treesit-node-end opener)))
      (when (and closer-text (string= closer-text "end"))
        (setq end (treesit-node-start closer)))
      (my/textobject--mark start end))))

;; -----------------------------------------------------------------------------
;; Public text object commands
;; -----------------------------------------------------------------------------

(defun my/textobject-string (inside-p)
  "Marcar o text object string. INSIDE-P seleciona apenas o conteúdo.

Dentro das aspas quando INSIDE-P, ou incluindo as aspas no modo around."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (my/textobject--find-node '("string" "string_literal"
                                                  "template_string" "string_fragment"))))
      (my/textobject--mark-node node inside-p))))

(defun my/textobject-list (inside-p)
  "Marcar o text object lista. INSIDE-P seleciona apenas o conteúdo.

Identifica `[...]' (array/coleção) pela sintaxe."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (my/textobject--find-node '("list" "array" "array_expression"
                                                  "list_literal" "expression_list"))))
      (my/textobject--mark-node node inside-p))))

(defun my/textobject-par (inside-p)
  "Marcar o text object de parênteses. INSIDE-P seleciona apenas o conteúdo.

Distingue os parênteses de argumento/agrupamento pela sintaxe."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (my/textobject--find-node '("argument_list"
                                                  "parenthesized_expression"
                                                  "formal_parameters"
                                                  "parameter_list"
                                                  "parenthesized_declarator"))))
      (my/textobject--mark-node node inside-p))))

(defun my/textobject-block (inside-p)
  "Marcar o text object bloco. INSIDE-P seleciona apenas o conteúdo.

Identifica o bloco pela sintaxe (corpo, `{}', indentação)."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (my/textobject--find-node '("block" "compound_statement"
                                                  "statement_block" "class_body"
                                                  "declaration_list"))))
      (my/textobject--mark-node node inside-p))))

(defun my/textobject-defun (inside-p)
  "Marcar o text object defun. INSIDE-P seleciona apenas o corpo.

Localiza a definição e separa assinatura de corpo."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (my/textobject--find-node '("function_definition"
                                                  "method_declaration"
                                                  "function_declaration"
                                                  "class_declaration"
                                                  "class_definition"
                                                  "method_definition"))))
      (if inside-p
          (let ((body (treesit-node-child-by-field-name node "body")))
            (if body
                (my/textobject--mark (treesit-node-start body)
                                     (treesit-node-end body))
              (my/textobject--mark-node node t)))
        (my/textobject--mark-node node nil)))))

(defun my/textobject-argument (_inside-p)
  "Marcar o text object argumento.

Identifica o argumento sintático. O argumento não possui delimitadores
próprios, portanto INSIDE-P não altera o resultado."
  (when (my/textobject--treesit-ok-p)
    (when-let* ((node (treesit-node-at (point)))
                (arg (cl-find-if (lambda (n)
                                   (member (treesit-node-type n)
                                           '("argument" "identifier" "formal_parameter"
                                             "parameter" "expression")))
                                 (my/textobject--node-parents node))))
      (my/textobject--mark (treesit-node-start arg) (treesit-node-end arg)))))

;; -----------------------------------------------------------------------------
;; Keybinding wrappers
;; -----------------------------------------------------------------------------

(defun my/inside-string () (interactive) (my/textobject-string t))
(defun my/around-string () (interactive) (my/textobject-string nil))
(defun my/inside-par () (interactive) (my/textobject-par t))
(defun my/around-par () (interactive) (my/textobject-par nil))
(defun my/inside-list () (interactive) (my/textobject-list t))
(defun my/around-list () (interactive) (my/textobject-list nil))
(defun my/inside-block () (interactive) (my/textobject-block t))
(defun my/around-block () (interactive) (my/textobject-block nil))
(defun my/inside-defun () (interactive) (my/textobject-defun t))
(defun my/around-defun () (interactive) (my/textobject-defun nil))
(defun my/inside-argument () (interactive) (my/textobject-argument t))
(defun my/around-argument () (interactive) (my/textobject-argument nil))

(provide 'textobjects-config)
