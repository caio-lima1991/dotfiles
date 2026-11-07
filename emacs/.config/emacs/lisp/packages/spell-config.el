;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Jinx — on-the-fly spell checking with Enchant.
;; =============================================================================
;;
;; Jinx talks to libenchant through the native `jinx-mod' module, which is
;; compiled automatically on first use. Compiling needs the Enchant headers:
;;
;;     sudo dnf install enchant2-devel
;;
;; The runtime library (libenchant-2) and the hunspell dictionaries for
;; pt_BR/en_US are already installed. Until the headers exist, Jinx stays off
;; with a startup message and the rest of the configuration keeps working.

(require 'completion-config)  ; shares `my/prose-dict-languages'

(defun my/jinx-available-p ()
  "Return non-nil when the Enchant development files are installed."
  (and (executable-find "pkg-config")
       (ignore-errors
         (zerop (call-process "pkg-config" nil nil nil "--exists" "enchant-2")))))

(defvar my/hunspell-user-directories
  (list (expand-file-name "enchant/hunspell/" (xdg-config-home))
        (expand-file-name "hunspell/" (xdg-data-home)))
  "User dictionary directories searched before /usr/share/hunspell.")

(defun my/pt-br-dictionary-broken-p ()
  "Return non-nil when the system pt_BR dictionary mixes UTF-8 and Latin-1."
  (let ((aff "/usr/share/hunspell/pt_BR.aff")
        (dic "/usr/share/hunspell/pt_BR.dic"))
    (and (file-readable-p aff)
         (file-readable-p dic)
         (with-temp-buffer
           (insert-file-contents aff)
           (goto-char (point-min))
           (re-search-forward "^SET ISO8859-1" nil t))
         (with-temp-buffer
           (set-buffer-multibyte nil)
           (insert-file-contents-literally dic)
           (goto-char (point-min))
           (search-forward (unibyte-string #xC3 #xA7) nil t)))))

(defun my/pt-br-dictionary-install ()
  "Install a consistently Latin-1 encoded copy of the pt_BR dictionary."
  (when (my/pt-br-dictionary-broken-p)
    (let ((aff "/usr/share/hunspell/pt_BR.aff")
          (dic "/usr/share/hunspell/pt_BR.dic"))
      (dolist (dir my/hunspell-user-directories)
        (let ((target (expand-file-name "pt_BR.dic" dir)))
          (unless (and (file-exists-p target)
                       (not (file-newer-than-file-p dic target)))
            (make-directory dir t)
            (copy-file aff (expand-file-name "pt_BR.aff" dir) t)
            (unless (zerop (call-process "iconv" nil (list :file target) nil
                                         "-f" "UTF-8" "-t" "ISO-8859-1" dic))
              (ignore-errors (delete-file target))
              (message "Jinx: could not convert the pt_BR dictionary"))))))))

(use-package jinx
  :ensure t
  :demand t
  :bind (("M-$" . jinx-correct)
         ("C-c s c" . jinx-correct)
         ("C-c s b" . jinx-correct-all)
         ("C-c s n" . jinx-next)
         ("C-c s p" . jinx-previous)
         ("C-c s l" . jinx-languages))
  :init
  (setq jinx-languages (string-join my/prose-dict-languages " ")
        jinx-delay 0.2
        jinx-save-languages nil)
  :config
  (my/pt-br-dictionary-install)
  (if (my/jinx-available-p)
      (global-jinx-mode 1)
    (message "Jinx: instale enchant2-devel para ativar o corretor (sudo dnf install enchant2-devel)")))

;; -----------------------------------------------------------------------------
;; Ispell fallback (M-$ outside a Jinx buffer, `ispell-complete-word', ...)
;; -----------------------------------------------------------------------------

(setq ispell-program-name "hunspell"
      ispell-dictionary "pt_BR")

(provide 'spell-config)
