;; general tweaks 

(add-to-list 'custom-theme-load-path (concat emacs-dir "themes/"))
(load-theme 'dark-laptop t)

;; general look
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(set-fringe-mode 0)

;; no dinging
(setq visible-bell 0)
;(setq ring-bell-function `(lambda ()
;                            (set-face-background 'default "DodgerBlue")
;                            (set-face-background 'default "black")))

;; add new line
(setq next-line-add-newlines t)

;; yes-or-no
(fset 'yes-or-no-p 'y-or-n-p)


;; set font size 
(set-face-attribute 'default nil :height 100)
;;; end of tweak.el
