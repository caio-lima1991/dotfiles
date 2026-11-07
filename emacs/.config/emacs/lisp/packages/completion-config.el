;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Corfu — in-buffer completion frontend.
;; =============================================================================

(use-package corfu
  :ensure t
  :demand t
  :init
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator)
  (global-corfu-mode 1))

;; -----------------------------------------------------------------------------
;; Candidate documentation in a side popup
;; -----------------------------------------------------------------------------

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :custom
  (corfu-popupinfo-delay '(0.5 . 0.3))
  :hook (corfu-mode . corfu-popupinfo-mode))

;; -----------------------------------------------------------------------------
;; Candidate history (persisted across sessions)
;; -----------------------------------------------------------------------------

(use-package corfu-history
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-history-mode)
  :config
  (defvar savehist-additional-variables)
  (with-eval-after-load 'savehist
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;; -----------------------------------------------------------------------------
;; Keybindings inside the popup
;; -----------------------------------------------------------------------------

(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "<tab>") #'corfu-complete)
  (define-key corfu-map (kbd "S-<tab>") #'corfu-previous)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous))

;; =============================================================================
;; Prose completion — dictionary and buffer words, phone-keyboard style.
;; =============================================================================

(defvar my/prose-dict-languages '("pt_BR" "en_US")
  "Hunspell dictionaries used for prose completion and spell checking.")

(defvar my/dict-directory
  (expand-file-name "emacs/dict/" (xdg-cache-home))
  "Directory caching the plain-text word lists used by `cape-dict'.")

(defun my/dict--build (source target)
  "Extract the words of hunspell dictionary SOURCE into plain word list TARGET."
  (make-directory (file-name-directory target) t)
  (let ((process-environment (cons "LC_ALL=C" process-environment)))
    (unless (and (zerop (call-process "awk" nil (list :file target) nil
                                      "-F/" "NR > 1 { print $1 }" source))
                 (zerop (call-process "sort" nil nil nil "-u" "-o" target target)))
      (ignore-errors (delete-file target))
      (error "Could not build word list %s" target))))

(defun my/dict-files ()
  "Return the cached word lists for `my/prose-dict-languages'."
  (let (files)
    (dolist (lang my/prose-dict-languages)
      (let ((source (expand-file-name (concat lang ".dic") "/usr/share/hunspell"))
            (target (expand-file-name (concat lang ".txt") my/dict-directory)))
        (when (file-readable-p source)
          (when (or (not (file-exists-p target))
                    (file-newer-than-file-p source target))
            (condition-case err
                (my/dict--build source target)
              (error (message "cape-dict: %s" (error-message-string err)))))
          (when (file-exists-p target)
            (push target files)))))
    (or (nreverse files) '("/usr/share/dict/words"))))

;; -----------------------------------------------------------------------------
;; The built-in `cape-dict' greps for substrings, so with a 300k-word
;; Portuguese list the first N matches are mostly words that merely contain the
;; prefix somewhere, and real prefix candidates never reach the popup. `look'
;; does a binary search on the sorted word lists, returning only true prefixes.
;; -----------------------------------------------------------------------------

(defvar my/prose-dict-limit 500
  "Maximum number of words taken from each dictionary for one completion.")

(defun my/prose--words (prefix)
  "Return words from the prose dictionaries starting with PREFIX.
Candidates from each language are interleaved so that Portuguese and
English suggestions are both visible without scrolling."
  (let ((process-environment (cons "LC_ALL=C" process-environment))
        (lists nil)
        words)
    (dolist (file (my/dict-files))
      (push (vconcat (seq-take (process-lines-ignore-status
                                "look" "-f" prefix file)
                               my/prose-dict-limit))
            lists))
    (setq lists (nreverse lists))
    (dotimes (i (apply #'max 0 (mapcar #'length lists)))
      (dolist (list lists)
        (when (< i (length list))
          (push (aref list i) words))))
    (delete-dups (nreverse words))))

(defun my/prose-dict (&optional interactive)
  "Complete the word at point from the prose dictionaries.
Acts as a Capf unless INTERACTIVE is non-nil."
  (interactive (list t))
  (if interactive
      (cape-interactive #'my/prose-dict)
    (when-let* ((bounds (bounds-of-thing-at-point 'word))
                (beg (car bounds))
                (end (point))
                (prefix (buffer-substring-no-properties beg end))
                (words (and (>= (length prefix) 2) (my/prose--words prefix))))
      `(,beg ,end ,words
             :annotation-function (lambda (_) " Dict")
             :company-kind (lambda (_) 'text)
             :display-sort-function ,#'identity
             :cycle-sort-function ,#'identity
             :exclusive no))))

(defun my/cape-text-setup ()
  "Add phone-keyboard style completion sources to the current text buffer."
  (setq-local completion-styles '(basic)
              completion-ignore-case t
              corfu-auto t
              corfu-auto-delay 0.15
              corfu-auto-prefix 2)
  (remove-hook 'completion-at-point-functions #'ispell-completion-at-point t)
  (add-hook 'completion-at-point-functions
            (cape-capf-super #'cape-dabbrev #'my/prose-dict)
            nil t))

(with-eval-after-load 'cape
  (setq cape-dict-file #'my/dict-files
        cape-dict-limit 2000))

(add-hook 'text-mode-hook #'my/cape-text-setup)

(provide 'completion-config)
