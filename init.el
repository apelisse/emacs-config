;; init.el -*- mode: emacs-lisp; coding: utf-8-emacs -*-

;; Entry config file (`init.el')
;; The is the entry point for emacs configuration.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Server configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Let's start emacs-server, pretty useful when committing files from VCS
(load "server")
(unless (server-running-p) (server-start))

(setq default-frame-alist '((font . "Inconsolata-14")))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq default-tab-width 8)
(show-paren-mode 1)
(menu-bar-mode -1)
(global-hi-lock-mode 1)
(column-number-mode 1)
(setq confirm-kill-emacs 'yes-or-no-p)	; Confirm quit (avoids mistyping)
(setq-default fill-column 72)
(setq-default sentence-end-double-space nil)

;; Uniquify
(when (require 'uniquify nil 'noerror)
  (setq uniquify-buffer-name-style 'forward))

;; whitespace
(setq whitespace-style '(lines-tail trailing face))
(setq whitespace-line-column 79)

(defconst linux-cpp-style
  '("linux"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "linux-cpp" linux-cpp-style)

(add-hook 'c-mode-common-hook
  #'(lambda ()
	 (turn-on-auto-fill)
	 (c-set-style "linux-cpp")))
(add-hook 'python-mode-hook
  #'(lambda ()
	 (whitespace-mode t)))
(add-hook 'nxml-mode-hook
  #'(lambda ()
         (setq indent-tabs-mode nil)))
(add-hook 'sh-mode-hook
  #'(lambda ()
         (setq indent-tabs-mode nil)))
(add-hook 'js-mode-hook
  #'(lambda ()
    (setq indent-tabs-mode nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Faces
;; XXX: Should this belong to a 'theme' ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(eval-after-load "diff-mode"
  '(progn
	 (set-face-attribute 'diff-added nil :foreground "Forest Green")
	 (set-face-attribute 'diff-removed nil :foreground "Firebrick")))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Ido things: Interactive modes
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(icomplete-mode t)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Autocomplete
(add-hook 'after-init-hook 'global-company-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-log-done t)
(add-hook 'org-mode-hook
    #'(lambda ()
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
;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Try to load our special mode for commit messages
(autoload 'commitlog-mode "commitlog-mode"
  "Major mode for editing commit messages." t)
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . commitlog-mode))
(add-to-list 'auto-mode-alist '("MERGE_MSG$" . commitlog-mode))
(add-to-list 'auto-mode-alist '("hg-editor-.*\.txt$" . commitlog-mode))

(add-hook 'commitlog-mode-hook
  #'(lambda ()
	 (turn-on-auto-fill)
	 (flyspell-mode t)))

(defun git-mergetool-ediff (local remote base merged)
  (if (file-readable-p base)
	  (ediff-merge-files-with-ancestor local remote base nil merged)
	  (ediff-merge-files local remote nil merged)))

(add-hook 'ediff-mode-hook
  #'(lambda ()
	 (setq ediff-auto-refine 'on)
	 (setq ediff-show-clashes-only 't)
	 (setq ediff-ignore-similar-regions 't)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'eshell-mode-hook
    #'(lambda ()
	   (setenv "GIT_PAGER" "")		; Let's not use the default pager in eshell
	   (setenv "EDITOR" "emacsclient -c")
	   (define-key eshell-mode-map [up] 'previous-line)
	   (define-key eshell-mode-map [down] 'next-line)
	   (define-key eshell-mode-map (kbd "M-r") 'eshell-isearch-backward)
	   (define-key eshell-mode-map (kbd "M-s") 'eshell-isearch-forward)))
(setq eshell-history-size 1000)
(setq eshell-hist-ignoredups t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ipython
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))

;; Python requires indentation to be 4 spaces
(add-hook 'python-mode-hook
  #'(lambda ()
     (setq indent-tabs-mode nil)
	 (setq py-indent-offset 4)
	 (setq py-smart-indentation nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pylookup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq pylookup-dir (concat user-emacs-directory "pylookup"))
(add-to-list 'load-path pylookup-dir)

(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

(global-set-key "\C-ch" 'pylookup-lookup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tramp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tramp-default-method "ssh")

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
(setq browse-url-generic-program "chromium-browser")

;; Allow disabled functions
(put 'narrow-to-region 'disabled nil) ;; narrow/widen region
(put 'upcase-region 'disabled nil) ;; upcase region

;; Enter the debugger on error
;; (setq debug-on-error t)

;;; mmm-mode
(when (require 'mmm-auto nil 'noerror)
  (setq mmm-global-mode 'maybe)
  (mmm-add-mode-ext-class 'html-mode nil 'html-js))

;; Objective-c mode
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))

;; go-mode
(setq gofmt-command "goimports")
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Autocomplete
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Rust mode
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook
          #'(lambda ()
	    (setq rust-format-on-save t)
	    (define-key rust-mode-map (kbd "C-c C-c") 'rust-run)
	    (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
	    (setq indent-tabs-mode nil)))
(add-hook 'rust-mode-hook #'lsp-deferred)

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-display-reborrow-hints nil)

  :custom-face
  (lsp-rust-analyzer-inlay-face ((t (:foreground "gray33" :slant italic :height 110)))))

;; YAML mode
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; markdown-mode
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; Packages installed
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flycheck lsp-ui lsp-mode markdown-mode mmm-mode yaml-mode use-package rust-mode go-mode company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
