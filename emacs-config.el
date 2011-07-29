;; emacs-config.el -*- mode: emacs-lisp; coding: utf-8-emacs -*-

;; Entry config file (`emacs-config.el')
;; The is the entry point for emacs configuration.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Server configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Let's start emacs-server, pretty useful when committing files from VCS
(server-start)

;; ;; I actually don't like either pressing C-x k and not selecting a buffer
;; (add-hook 'server-switch-hook
;;   (lambda ()
;;     (when (current-local-map)
;;       (use-local-map (copy-keymap (current-local-map))))
;; 	(when server-buffer-clients
;; 	  (local-set-key (kbd "C-x k") 'server-edit))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Save the desktop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(desktop-save-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is obviously mandatory
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/auto-complete/")
(add-to-list 'load-path "~/.emacs.d/auto-complete-clang/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq tab-width 4)
(setq default-tab-width 4)
(show-paren-mode 1)
(menu-bar-mode -1)
(global-hi-lock-mode 1)
(column-number-mode 1)
(setq confirm-kill-emacs 'yes-or-no-p)	; Confirm quit (avoids mistyping)

;; whitespace
(require 'whitespace)
(setq whitespace-style '(lines-tail trailing face))
(setq whitespace-line-column 79)
(add-hook 'c-mode-common-hook
  '(lambda ()
	 (whitespace-mode t)))
(add-hook 'python-mode-hook
  '(lambda ()
	 (whitespace-mode t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Faces
;; XXX: Should this belong to a 'theme' ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'diff-mode)
(set-face-attribute 'diff-added nil :foreground "Forest Green")
(set-face-attribute 'diff-removed nil :foreground "Firebrick")

;; GUI/nw specifics
(when (boundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Ido things: Interactive modes
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(icomplete-mode t)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Colors for compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(defun compile-with-buffer-name (name command)
   (setq compilation-buffer-name-function
      (lambda (u) name))
   (compile command)
   (setq compilation-buffer-name-function nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-log-done t)
(add-hook 'org-mode-hook
    '(lambda ()
	   (define-key org-mode-map (kbd "C-c l") 'org-store-link)
	   (define-key org-mode-map (kbd "C-c a") 'org-agenda)
	   (define-key org-mode-map (kbd "C-c b") 'org-iswitchb)))
(setq org-agenda-files (quote ("~/todo/TODO.org" "~/todo/TODO.org_archive")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backups
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq version-control t)
(setq delete-old-versions t)
(add-to-list 'backup-directory-alist (cons "." "~/.emacs.d/backups/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emerge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'emerge-startup-hook '(emerge-skip-prefers 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Try to load our special mode for commit messages
(autoload 'commitlog-mode "commitlog-mode"
  "Major mode for editing commit messages." t)
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . commitlog-mode))
(add-to-list 'auto-mode-alist '("hg-editor-.*\.txt$" . commitlog-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'eshell-mode-hook
    '(lambda ()
	   (setenv "GIT_PAGER" "")		; Let's not use the default pager in eshell
	   (setenv "EDITOR" "emacsclient -i")
	   (define-key eshell-mode-map [up] 'previous-line)
	   (define-key eshell-mode-map [down] 'next-line)
	   (define-key eshell-mode-map (kbd "M-r") 'eshell-isearch-backward)
	   (define-key eshell-mode-map (kbd "M-s") 'eshell-isearch-forward)))
(setq eshell-history-size 1000)
(setq eshell-hist-ignoredups t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ipython
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "python-mode.el")
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(require 'ipython)
;; Python requires indentation to be 4 spaces
(add-hook 'python-mode-hook
  '(lambda ()
     (setq indent-tabs-mode nil)
	 (setq py-indent-offset 4)
	 (setq py-smart-indentation nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pylookup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq pylookup-dir "~/.emacs.d/pylookup")
(add-to-list 'load-path pylookup-dir)

(eval-when-compile (require 'pylookup))

(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

(global-set-key "\C-ch" 'pylookup-lookup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global tags (gnu gtags)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/contrib/share/gtags/")

(add-hook 'c-mode-common-hook
  '(lambda ()
	 (gtags-mode 1)))
(autoload 'gtags-mode "gtags" "" t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misceallenous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'before-save-hook
  'delete-trailing-whitespace)
(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

;; Adds a newline at the end of the file
(setq require-final-newline 't)

;; Increase undo limit
(setq undo-limit 100000)

;; Configure web brower
(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-program "firefox")

;; Allow disabled functions
(put 'narrow-to-region 'disabled nil) ;; narrow/widen region
(put 'upcase-region 'disabled nil) ;; upcase region

;; Enter the debugger on error
(setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-Complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Amadeus Specifics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (getenv "AMADEUS")
  (load-file "~/.emacs.d/amadeus.el"))
