;; -*- mode: emacs-lisp; coding: utf-8-emacs -*-

;; Entry config file (`emacs-config.el')
;; The is the entry point for emacs configuration.

;; Let's start emacs-server, pretty useful when committing files from VCS
(server-start)

;; Configure web brower
(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-program "firefox3")

;; Allow disabled functions
(put 'narrow-to-region 'disabled nil) ;; narrow/widen region
