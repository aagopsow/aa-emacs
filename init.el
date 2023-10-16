(setq aa-emacs-init-file load-file-name)
(setq emacs-dir "~/aa-emacs/")
(setq aa-emacs-config-dir
	(file-name-directory aa-emacs-init-file))
;; set the backup directory
(setq user-emacs-directory aa-emacs-config-dir)

(setq backup-directory-alist
	(list (cons "." (expand-file-name "backup" user-emacs-directory))))

;; set up MELPA
(require 'package)

(setq package-archives '(	
	("melpa" . "http://melpa.org/packages/")
	("gnu" . "http://elpa.gnu.org/packages/")))

;;(add-to-list 'package-archives
;;             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)


(package-refresh-contents)

;; load vendor and custom files
(defvar module-dir (concat emacs-dir "modules/")
  "The core .el files")

;; add to load path
(add-to-list 'load-path module-dir)

;; require packages in modules
(mapc 'load (directory-files module-dir nil "^[^#].*.el$"))

;; disable backup
(setq backup-inhibited t)

;; disable auto save
(setq auto-save-default nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(magit ess)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(keychain-refresh-environment)
