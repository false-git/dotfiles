;; 共通
(setq debug-on-error t) ; エラーが出たらtraceを出す
(setq make-backup-files nil) ; バックアップファイルを作らない
(setq scroll-step 1) ; 画面外にカーソル移動したら行単位でスクロール
(line-number-mode 1) ; モードラインに行番号を表示
(setq kill-whole-line t) ; C-k で行毎削除
(setq mouse-yank-at-point t) ; マウスの真ん中ボタンで、マウスポインタ位置ではなくカーソル位置にペースト
(setq next-line-add-newlines t) ; 最終行でカーソルの下/C-n で行追加
(setq require-final-newline t) ; 最終行には必ず改行コードを入れる
(setq browse-url-browser-function 'w3m-browse-url) ; w3m使う
(setq display-time-day-and-date t) ; 日時を表示
(if window-system nil (menu-bar-mode -1))
(setq vc-follow-symlinks t) ; Version controlされたファイルに対するsymbolic link を開くときは、ファイルの実体を開く
(display-time) ; モードラインに日時を表示
(server-start) ; emacsclient用にemacs-server起動

;; ローカル関数
; Blanced Blaketto
(defun find-matching-paren ()
  "Locate the matching paren.  It's a hack right now."
  (interactive)
  (cond ((looking-at "[[({]") (forward-sexp 1) (backward-char 1))
        ((looking-at "[])}]") (forward-char 1) (backward-sexp 1))
        (t (ding))))
; c-mode用hook
(defun my-c-def ()
;;  (setq c-argdecl-indent 4 )
;;  (setq c-continued-statement-offset 4)
;;  (setq c-indent-level 4)
;;  (setq c-label-offset -2)
;;  (setq c-tab-always-indent nil )
  (setq tab-width 8)
;;  (setq comment-column 0)
  (c-set-offset 'case-label 2)
  (c-set-offset 'statement-case-intro 2)
  (c-set-offset 'arglist-cont-nonempty 4)
  (c-set-offset 'access-label -2)
  (setq c-basic-offset 4)
  (local-set-key "\^m" 'newline-and-indent)
  (local-set-key "\^cc" 'compile)
  (if (and (boundp 'MULE) (eq window-system 'x)) (font-lock-mode 1))
  ;;(boil)
)
; perl-mode用hook
(defun my-perl-def ()
  (local-set-key "\^m" 'newline-and-indent)
  ;(boil)
)
; text-mode用hook
(defun auto-fill-mode-on ()
  (auto-fill-mode 1)
  (setq fill-column 68)
  ;;(boil)
)
; javaのaccessorを追加する
(defun insert-accessor (type name longname)
  (setq capitalName (concat (upcase (substring name 0 1)) (substring name 1 nil)))
  (insert-string (concat "
    /**
     * " longname "を設定する。
     * @param " name " " longname " 
     */
    public void set" capitalName "(" type " " name ") {
        this." name " = " name ";
    }

    /**
     * " longname "を取得する。
     * @return " longname "
     */
    public " type " get" capitalName "() {
        return " name ";
    }
"))
)
; 現在のregionにあるメンバ変数に対するaccessorを追加する(java)
(defun insert-accessor-region ()
  (interactive)
  (setq text (car kill-ring))
  (while (not (eq text nil))
    (setq p (+ (string-match "\n" text) 1))
    (setq l (substring text 0 p))
    (setq text (substring text p nil))
    (string-match " */\\*+ *\\([^ ]*\\) *\\*/" l)
    (setq longname (match-string 1 l))
    (setq p (+ (string-match "\n" text) 1))
    (if (eq p nil) (setq p (- (length text) 1)))
    (setq l (substring text 0 p))
    (setq text (substring text p nil))
    (string-match ".* \\([^ ]*\\) +\\([^ ]*\\)[=; ]" l)
    (setq type (match-string 1 l))
    (setq name (match-string 2 l))
    (insert-accessor type name longname)
    )
)
; emacs22までのtoggle-read-only 
(defun my-toggle-read-only (&optional verbose)
  "Change read-only status of current buffer, perhaps via version control.

If the buffer is visiting a file registered with version control,
then check the file in or out. Otherwise, just change the read-only flag
of the buffer.
With prefix argument, ask for version number to check in or check out.
Check-out of a specified version number does not lock the file;
to do that, use this command a second time with no argument.

If you bind this function to \\[toggle-read-only], then Emacs checks files
in or out whenever you toggle the read-only flag."
  (interactive "P")
  (if (or (and (boundp 'vc-dired-mode) vc-dired-mode)
          ;; use boundp because vc.el might not be loaded
          (vc-backend buffer-file-name))
      (vc-next-action verbose)
    (toggle-read-only)))

;; グローバルキー定義
(global-set-key "\^x\^p" 'find-matching-paren) ; C-x C-p で対応する括弧に飛ぶ
(global-set-key "\^x\^g" 'goto-line) ; C-x C-g で goto-line
(global-set-key [delete] 'backward-delete-char) ; Deleteキーでdel
(global-set-key "\C-ca" 'insert-accessor-region) ; C-c a でaccessor追加
(global-set-key "\C-l" 'recenter) ; C-l でrecenter
(global-set-key "\C-x\C-q" 'my-toggle-read-only)

;; hooks
(add-hook 'c-mode-hook 'my-c-def)
(add-hook 'c++-mode-hook 'my-c-def)
(add-hook 'java-mode-hook 'my-c-def)
(add-hook 'perl-mode-hook 'my-perl-def)
(add-hook 'text-mode-hook 'auto-fill-mode-on)
; 日本語ファイル名をデコード
(eval-after-load "mime"
  '(defadvice mime-entity-filename (around mime-decode activate)
     ad-do-it
     (and ad-return-value
          (setq ad-return-value
                (eword-decode-string (decode-mime-charset-string
                                      ad-return-value
                                      'iso-2022-jp))))))

;; autoload
; riece
(autoload 'riece "riece" "Start Riece" t)

;; anything用の設定
(condition-case err
    (progn
      (require 'anything-startup)
      (anything-iswitchb-setup)
					;  (global-set-key "\^x\^f" 'anything-filelist+)
      (define-key anything-map "\C-p" 'anything-previous-line)
      (define-key anything-map "\C-n" 'anything-next-line)
      (define-key anything-map "\C-v" 'anything-next-page)
      (define-key anything-map "\M-v" 'anything-previous-page)
      (setq anything-command-map-prefix-key "\C-c\C-f")
      )
  (file-error (message "%s" (error-message-string err)))
)

;; auto-complete用の設定
(condition-case err
    (progn
      (require 'auto-complete-config)
      (add-to-list 'ac-dictionary-directories "/opt/local/share/emacs/site-lisp/ac-dict") ; Mac OS X
      (add-to-list 'ac-dictionary-directories "/usr/local/share/emacs/site-lisp/ac-dict") ; FreeBSD
      (ac-config-default)
      )
  (file-error (message "%s" (error-message-string err)))
)

;; wanderlust用の設定
(condition-case err
    (progn
      (require 'wanderlust-startup)
      (global-set-key "\C-xm" 'wl-draft)
      (global-set-key "\C-xr" 'wl)
      (defvar wl-mail-setup-hook 'auto-fill-mode-on)
      (defun my-wl-folder-def ()
	(local-set-key "i" 'wl-folder-check-all)
	)
      (add-hook 'wl-folder-mode-hook 'my-wl-folder-def)
      )
  (file-error (message "%s" (error-message-string err)))
)

;; windows.el用の設定
(condition-case err
    (progn
      (require 'windows)
      (win:startup-with-window)
      (define-key ctl-x-map "C" 'see-you-again)
      (define-key ctl-x-map "c" 'see-you-again)
      (defun ch-1 ()
	(interactive)
	(win-switch-to-window 1 1)
	)
      (defun ch-2 ()
	(interactive)
	(win-switch-to-window 1 2)
	)
      (defun ch-3 ()
	(interactive)
	(win-switch-to-window 1 3)
	)
      (defun ch-4 ()
	(interactive)
	(win-switch-to-window 1 4)
	)
      (define-key global-map [f1] 'ch-1)
      (define-key global-map [f2] 'ch-2)
      (define-key global-map [f3] 'ch-3)
      (define-key global-map [f4] 'ch-4)
      ;;(setq win:new-frame-offset-x 0)
      ;;(setq win:new-frame-offset-y 0)
      (setq win:resumed-frame-offset-x 4)
      (setq win:resumed-frame-offset-y 4)
      )
  (file-error (message "%s" (error-message-string err)))
)

;; 個別環境用設定の読み込み
(condition-case err
    (load-file "$HOME/.emacs.local")
  (file-error (message "%s" (error-message-string err)))
)


