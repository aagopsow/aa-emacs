(require 'ess-site)

(autoload 'R-mode "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))
;;(setq inferior-R-program-name "C:/Program Files/R/R-3.5.2/bin/x64/R.exe")

;; must haves according to emacswiki
(setq ess-eval-visibly-p nil)
(setq ess-ask-for-ess-directory nil)

;; shift-enter to send to R buffer
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-prompt-read-only t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
    (progn
	(delete-other-windows)
	(setq w1 (selected-window))
	(setq w1name (buffer-name))
	(setq w2 (split-window w1))
	(R)
	(set-window-buffer w2 "*R*")
	(set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
	(call-interactively 'ess-eval-region)
      (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
	       (local-set-key [(shift return)] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
	  '(lambda()
	       (local-set-key [C-up] 'comint-previous-input)
	       (local-set-key [C-down] 'comint-next-input)))


(setq ess-R-object-tooltip-alist
      '((numeric    . "summary")
        (factor     . "table")
        (integer    . "summary")
        (lm         . "summary")
        (other      . "str")
	(data.frame . "head")))


(defun ess-R-object-tooltip ()
  "Get info for object at point, and display it in a tooltip."
  (interactive)
  (let ((objname (current-word))
        (curbuf (current-buffer))
        (tmpbuf (get-buffer-create "**ess-R-object-tooltip**")))
    (if objname
        (progn
          (ess-command (concat "class(" objname ")\n")  tmpbuf )   
          (set-buffer tmpbuf)
          (let ((bs (buffer-string)))
            (if (not(string-match "\(object .* not found\)\|unexpected" bs))
                (let* ((objcls (buffer-substring 
                                (+ 2 (string-match "\".*\"" bs)) 
                                (- (point-max) 2)))
                       (myfun (cdr(assoc-string objcls 
                                                ess-R-object-tooltip-alist))))
                  (progn
                    (if (eq myfun 0)
                        (setq myfun 
                              (cdr(assoc-string "other" 
                                                ess-R-object-tooltip-alist))))
                    (ess-command (concat myfun "(" objname ")\n") tmpbuf)
                    (let ((bs (buffer-string)))
                      (progn
                        (set-buffer curbuf)
                        (tooltip-show-at-point bs 0 30)))))))))
    (kill-buffer tmpbuf)))


;; my default key map
(define-key ess-mode-map "\C-c\C-g" 'ess-R-object-tooltip)

(provide 'ess-R-object-tooltip)

;(custom-set-faces
;'(tooltip ((t (:background "white" :foreground "blue" :foundry "fixed")))))

;; r parser
(defun ess-indent-region-as-R-function (beg end)
  (let ((string (replace-regexp-in-string
		 "\"" "\\\\\\&"
		 (replace-regexp-in-string ;; how to avoid this double matching?
		  "\\\\\"" "\\\\\\&" (buffer-substring-no-properties beg end))))
	(buf (get-buffer-create "*ess-command-output*")))
    (ess-force-buffer-current "Process to load into:")
    (ess-command (format "local({oo<-options(keep.source=FALSE);
cat('\n',paste(deparse(parse(text=\"%s\")[[1L]]),collapse='\n'),'\n',sep='')
options(oo)})\n"  string) buf)
    (with-current-buffer buf
      (goto-char (point-max))
      ;; (skip-chars-backward "\n")
      (let ((end (point)))
	(goto-char (point-min))
	(goto-char (1+ (point-at-eol)))
	(setq string (buffer-substring-no-properties (point) end))
	))
  (delete-region beg end)
  (insert string)
  ))


(add-hook 'ess-mode-hook '(lambda () (set (make-local-variable 'indent-region-function)
					  'ess-indent-region-as-R-function)))

;; ess debugging
(require 'ess-tracebug)
(add-hook 'ess-post-run-hook 'ess-tracebug)
(setq ess-tracebug-prefix "\M-c")


;;; end of ess-init.el
