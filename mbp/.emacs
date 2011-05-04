(setq make-backup-files nil)

(when (>= emacs-major-version 23)
  ;; Emacs 23専用コード
  (define-key global-map [ns-drag-file] 'ns-find-file)
  (require 'anything-startup)
  (anything-iswitchb-setup)
;  (global-set-key "\^x\^f" 'anything-filelist+)
  (define-key anything-map "\C-p" 'anything-previous-line)
  (define-key anything-map "\C-n" 'anything-next-line)
  (define-key anything-map "\C-v" 'anything-next-page)
  (define-key anything-map "\M-v" 'anything-previous-page)
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(anything-command-map-prefix-key "\C-c\C-f"))
  )