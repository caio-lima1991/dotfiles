;; -*- lexical-binding: t; -*-

;; =============================================================================
;; Custom commands.
;; =============================================================================

(defun my/project-root ()
  "Return the current project's root directory, or `default-directory'."
  (if-let* ((project (project-current)))
      (project-root project)
    default-directory))

(defun my/copy-file-path ()
  "Copy the absolute path of the current buffer's file to the kill ring."
  (interactive)
  (if-let* ((file (buffer-file-name)))
      (progn
        (kill-new file)
        (message "Copied absolute path: %s" file))
    (message "Buffer is not visiting a file")))

(defun my/copy-relative-file-path ()
  "Copy the current buffer's file path relative to the project root."
  (interactive)
  (if-let* ((file (buffer-file-name)))
      (let ((rel-path (file-relative-name file (my/project-root))))
        (kill-new rel-path)
        (message "Copied relative path: %s" rel-path))
    (message "Buffer is not visiting a file")))

(provide 'functions-config)
