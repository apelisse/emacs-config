;;; commitlog-mode.el --- Major mode for editing commit logs

;; Maintainer: apelisse@gmail.com
;; Created:    Jul 2011
;; Keywords:   commit log git dcvs hg mercurial

(defconst commitlog-version "0.9.0"
  "`commitlog-mode' version number.")

;;; Commentary:

;; This is a very simple mode for correctly printing commit logs within emacs.
;; The goal is to have a bold headline for the title, limited to 50 chars,
;; and all the other text limited to 80 chars. (though length should be configurable).
;; All line text highlighting should be handled by whitespace mode

;;; Code:

;; Let's try to use already existing faces
(defvar commitlog-keywords
  '(("^#.*\\|HG:.*" . font-lock-comment-face)
	("\\`.\\{49,\\}" . font-lock-warning-face)
	("\\`.\\{,49\\}" . font-lock-function-name-face)
	("^.\\{79,\\}" . font-lock-warning-face)))

(defvar commit-msg-mode-hook nil)

(defun commitlog-mode ()
  (interactive)
  (setq major-mode 'commit-msg-mode)
  (setq mode-name "Commit-log")
  (setq font-lock-defaults '(commitlog-keywords t))
  (font-lock-fontify-buffer)
  (run-hooks 'commitlog-mode-hook))

(provide 'commitlog-mode)
