;; amadeus.el -*- mode: emacs-lisp; coding: utf-8-emacs -*-

;; Amadeus specific configurations
;; This should be loaded only if amadeus computer is recognized.
;; For easing the task, `AMADEUS' will be set in environment
;; so we can load this configuration file.

;; Bind end key
(global-set-key [(select)] 'move-end-of-line) ;; End doesn't work here

;; Amadeus TODO Files
(setq org-agenda-files (quote ("~/TODO_archive" "~/TODO")))

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

;; Load compile options
(load-file "~/.emacs.d/compile-options.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macro expansion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is obviously very specific to c++ ...
(setq c-macro-preprocessor "g++ -E -C -x c++")
(setq c-macro-cppflags (concat compile-flags-gcc3 " -"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-Complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-clang)
(setenv "LD_PRELOAD" "/opt/gcc-4.3.2/lib64/libstdc++.so.6:/opt/gcc-4.3.2/lib64/libgcc_s.so.1")
(defun my-ac-cc-mode-setup ()
;	(setq ac-sources (append '(ac-source-clang) ac-sources)))
	(setq ac-sources '(ac-source-clang))
	(setq ac-clang-flags (split-string compile-flags-gcc4))
	(setq ac-auto-start nil)
	(setq ac-auto-show-menu nil))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
(ac-config-default)
(define-key ac-mode-map "\M-/" 'auto-complete)
