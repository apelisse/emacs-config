;; amadeus.el -*- mode: emacs-lisp; coding: utf-8-emacs -*-

;; Amadeus specific configurations
;; This should be loaded only if amadeus computer is recognized.
;; For easing the task, `AMADEUS' will be set in environment
;; so we can load this configuration file.

;; Bind end key
(global-set-key [(select)] 'move-end-of-line) ;; End doesn't work here

;; Amadeus TODO Files
(setq org-agenda-files (quote ("~/TODO_archive" "~/TODO")))

;; Use bash for shell commands (zsh is way too long to run)
(setq shell-file-name "/bin/bash")

;; Use w3m as we can't run firefox ...
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

;; Eshell amadeus specific: Let's run emacsclient in emacs ...
(add-hook 'eshell-mode-hook
  '(lambda ()
	 (setenv "EDITOR" "emacsclient")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global tags (gnu gtags)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/contrib/share/gtags/")

(add-hook 'c-mode-common-hook
  '(lambda ()
	 (gtags-mode 1)))
(autoload 'gtags-mode "gtags" "" t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color theme
;; TODO: This should be replaced by hard coding coloring
;; I don't want to have a dependency over the color-theme code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/contrib/distfiles/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
   '(progn
     (color-theme-initialize)
     (color-theme-tm)))

(setq get-compile-flags-command "get-compile-flags.py")

(defun get-compile-files-in-dir (dir)
  (with-output-to-string
    (with-current-buffer standard-output
	  (call-process get-compile-flags-command
					nil
					t
					nil
					(concat (locate-dominating-file dir "Description.xml")
							"Description.xml")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-Complete and Macro expansion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-ac-cc-mode-setup ()
;	(setq ac-sources (append '(ac-source-clang) ac-sources)))
  (c-set-style "cc-mode")
  (setq clang-completion-flags (split-string (get-compile-files-in-dir default-directory)))
  (setq clang-completion-suppress-error 't)
  (setq c-macro-preprocessor "g++ -E -C -x c++")
  (setq c-macro-cppflags (concat compile-flags " -"))
  (setenv "LD_LIBRARY_PATH" "/softs/oracle/10.2.0.3/lib64/:/nastools/oracle/products/10.2.0.4/lib:/nastools/mysql/products/5-1-39/lib/mysql:/opt/python-2.6-64/lib:/usr/local/lib::/opt/python-2.6-64/lib:/nastools/gqlplus/lib:/nastools/graphviz/lib/graphviz:/remote/users2/apelisse/contrib/lib:/opt/gcc-4.3.2/lib:/opt/gcc-4.3.2/lib64"))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ipython-command "/opt/python-2.6-64/bin/ipython")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tramp/Ange-ftp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ange-ftp-ftp-program-args '("-i" "-n" "-g" "-v" "-A"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Outline mode for logs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar apslog-mode-hook nil)

;; Use specific hook for apslog
(define-derived-mode apslog-mode outline-mode
  (setq mode-name "APS Log")
  (run-hooks 'apslog-mode-hook))

(add-to-list 'auto-mode-alist '("logAP._\.\*\\.txt\\'" . apslog-mode))
;; Specify outline heading regex, and fold everything
(add-hook 'apslog-mode-hook
  (lambda ()
	(set (make-local-variable 'outline-regexp) "[[:space:]]*==>")
	(hide-sublevels 3)))
