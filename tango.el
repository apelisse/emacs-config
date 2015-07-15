(defconst tango-style
  '("gnu"
    (c-tab-always-indent        . nil)
    (c-offsets-alist . ((innamespace . [0])
			(substatement-open . 0)
			(arglist-intro . +)))))

(c-add-style "tango-style" tango-style)

(add-hook 'c++-mode-hook
  '(lambda ()
     (message "loading c++ mode hook")
     (c-set-style "tango-style")))

(add-hook 'python-mode-hook
  '(lambda ()
     (setq python-indent-offset 2)))
