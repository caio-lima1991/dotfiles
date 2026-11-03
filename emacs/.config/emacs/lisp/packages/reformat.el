(require 'package)

(unless (package-installed-p 'reformat)
  (package-install 'reformat))

(require 'reformat)

(reformat-define google-java-format
  :program "google-java-format"
  :args '("-")
  :modes '(java-mode java-ts-mode))

(add-hook 'java-mode-hook #'google-java-format-on-save-mode)
(add-hook 'java-ts-mode-hook #'google-java-format-on-save-mode)
