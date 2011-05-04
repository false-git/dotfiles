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
  (setq fixed-width-use-QuickDraw-for-ascii t)
  (setq mac-allow-anti-aliasing t)
  (set-face-attribute 'default nil
		      :family "Courier New"
		      :height 140)
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0208
   '("Hiragino Kaku Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0212
   '("Hiragino Kaku Gothic Pro" . "iso10646-1"))
 ;;; Unicode フォント
  (set-fontset-font
   (frame-parameter nil 'font)
   'mule-unicode-0100-24ff
   '("monaco" . "iso10646-1"))
;;; キリル，ギリシア文字設定
;;; 注意： この設定だけでは古代ギリシア文字、コプト文字は表示できない
;;; http://socrates.berkeley.edu/~pinax/greekkeys/NAUdownload.html が必要
;;; キリル文字
  (set-fontset-font
   (frame-parameter nil 'font)
   'cyrillic-iso8859-5
   '("monaco" . "iso10646-1"))
;;; ギリシア文字
  (set-fontset-font
   (frame-parameter nil 'font)
   'greek-iso8859-7
   '("monaco" . "iso10646-1"))
  (setq face-font-rescale-alist
	'(("^-apple-hiragino.*" . 1.2)
	  (".*osaka-bold.*" . 1.2)
	  (".*osaka-medium.*" . 1.2)
	  (".*courier-bold-.*-mac-roman" . 1.0)
	  (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	  (".*monaco-bold-.*-mac-roman" . 0.9)
	  ("-cdac$" . 1.3)))
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(anything-command-map-prefix-key "\C-c\C-f"))
 )

(server-start)
