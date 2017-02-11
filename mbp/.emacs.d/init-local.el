;; mac用コード
(when (>= emacs-major-version 23)
  ;; Emacs 23専用コード
  (define-key global-map [ns-drag-file] 'ns-find-file)
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
 )

(if window-system (progn
  ;; 背景色を設定します。
  (add-to-list 'default-frame-alist '(background-color . "lightgray"))
  ;; カーソルの色を設定します。
  (add-to-list 'default-frame-alist '(cursor-color . "dimgray"))
  (add-to-list 'default-frame-alist '(height . 54))
))

(add-hook 'objc-mode-hook 'my-c-def)

(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "~/bin")

;; C-cwで選択した文字列を辞書で引き別バッファに表示します。
(defun dictionary ()
 "dictionary.app"
 (interactive)

 (let ((editable (not buffer-read-only))
       (pt (save-excursion (mouse-set-point last-nonmenu-event)))
       beg end)

   (if (and mark-active
            (<= (region-beginning) pt) (<= pt (region-end)) )
       (setq beg (region-beginning)
             end (region-end))
     (save-excursion
       (goto-char pt)
       (setq end (progn (forward-word) (point)))
       (setq beg (progn (backward-word) (point)))
       ))

   (setq word (buffer-substring-no-properties beg end))
   (let ((win (selected-window))
         (tmpbuf " * dict-process *"))
     (pop-to-buffer tmpbuf)
     (erase-buffer)
     (insert word "\n")
     (start-process "dict-process" tmpbuf "dict" word)
     (select-window win)
     )
 ))
 (define-key global-map (kbd "C-c w") 'dictionary)

(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)

(tool-bar-mode 0)

;;
;; mew
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))
;; (setq mew-name "your name") ;; (user-full-name)
;; (setq mew-user "user name of e-mail address") ;; (user-login-name)
(setq mew-mail-domain "wizard-limit.net")
(setq mew-smtp-server "sv.wizard-limit.net")
(setq mew-proto "%")
;; (setq mew-imap-user "your IMAP account")  ;; (user-login-name)
(setq mew-imap-server "sv.wizard-limit.net")
;(global-set-key [?¥] [?\\])
(global-set-key [?\M-¥] [?\\])
