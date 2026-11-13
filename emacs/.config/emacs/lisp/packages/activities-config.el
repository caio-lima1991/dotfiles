;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Activities
;; =============================================================================

(use-package activities
  :ensure t
  :demand t
  :init

  (activities-mode 1)

  (activities-tabs-mode 1)

  (setq edebug-inhibit-emacs-lisp-mode-bindings t)

  :bind
  (("C-x C-a C-n" . activities-new)
   ("C-x C-a C-d" . activities-define)
   ("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-s" . activities-suspend)
   ("C-x C-a C-k" . activities-kill)
   ("C-x C-a RET" . activities-switch)
   ("C-x C-a b" . activities-switch-buffer)
   ("C-x C-a g" . activities-revert)
   ("C-x C-a l" . activities-list)))

(with-eval-after-load 'project
  (define-key project-prefix-map (kbd "a") #'my/activities-project))

;; -----------------------------------------------------------------------------
;; Ponte com o project.el
;; -----------------------------------------------------------------------------

(defun my/activities-current-project-name ()
  "Retorna o nome do projeto atual, ou nil."
  (when-let* ((project (project-current)))
    (project-name project)))

(defun my/activities-project ()
  "Abre a atividade correspondente ao projeto atual.
Se nao houver atividade para o projeto, cria uma a partir do estado atual."
  (interactive)
  (let* ((name (or (my/activities-current-project-name)
                   (user-error "Nenhum projeto atual")))
         (activity (activities-named name)))
    (if activity
        (activities-resume activity)
      (when (y-or-n-p (format "Criar atividade %S a partir do estado atual? " name))
        (activities-define name)))))

;; -----------------------------------------------------------------------------
;; Eat: fora das atividades
;; -----------------------------------------------------------------------------

(declare-function bookmark-prop-get "bookmark" (bookmark-name-or-record prop))

(defun my/activities-eat-make-record ()
  "Registro de bookmark neutro para um buffer Eat."
  `(,(buffer-name)
    (handler . my/activities-eat-handler)
    (default-directory . ,(expand-file-name default-directory))))

(defun my/activities-eat-handler (bookmark)
  "Restaura um `*scratch*' no diretorio de BOOKMARK (sem terminal)."
  (let* ((dir (expand-file-name
               (or (bookmark-prop-get bookmark 'default-directory)
                   default-directory)))
         (buffer (get-buffer-create "*scratch*")))
    (with-current-buffer buffer
      (unless (derived-mode-p 'prog-mode)
        (fundamental-mode))
      (setq default-directory dir))
    (set-buffer buffer)))

(defalias 'my/eat-bookmark-handler #'my/activities-eat-handler)

(with-eval-after-load 'eat
  (add-hook 'eat-mode-hook
            (lambda ()
              (setq-local bookmark-make-record-function
                          #'my/activities-eat-make-record))))

(provide 'activities-config)
