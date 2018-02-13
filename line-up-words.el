(defvar line-up-words-command "line-up-words")

(defun line-up-words ()
  "Tries to align words in the region in an intelligent way."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end) line-up-words-command t t
   shell-command-default-error-buffer t)
  (indent-region (region-beginning) (region-end)))

(provide 'line-up-words)
