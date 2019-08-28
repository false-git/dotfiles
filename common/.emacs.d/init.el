;; package
(require 'package)
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package ))

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
(setq display-time-format "%H:%M %m/%d") ; 日時のフォーマット指定
(if window-system nil (menu-bar-mode -1))
(setq vc-follow-symlinks t) ; Version controlされたファイルに対するsymbolic link を開くときは、ファイルの実体を開く
(display-time) ; モードラインに日時を表示
(server-start) ; emacsclient用にemacs-server起動
(global-auto-revert-mode 1) ; ファイルに変更があったら読み込む

;;; ローカル関数
;; Blanced Blaketto
(defun find-matching-paren ()
  "Locate the matching paren.  It's a hack right now."
  (interactive)
  (cond ((looking-at "[[({]") (forward-sexp 1) (backward-char 1))
        ((looking-at "[])}]") (forward-char 1) (backward-sexp 1))
        (t (ding))))
;; c-mode用hook
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
  (c-set-offset 'arglist-intro '++)
  (c-set-offset 'arglist-cont-nonempty 4)
  (c-set-offset 'access-label -2)
  (c-set-offset 'innamespace 0)
  (setq c-basic-offset 4)
  (local-set-key "\^m" 'newline-and-indent)
  (local-set-key "\^cc" 'compile)
  (if (and (boundp 'MULE) (eq window-system 'x)) (font-lock-mode 1))
  (add-hook 'before-save-hook 'clang-format-buffer nil 'local)
  (flycheck-mode t)
  ;;(boil)
  )

;; perl-mode用hook
(defun my-perl-def ()
  (local-set-key "\^m" 'newline-and-indent)
  ;;(boil)
  )
;; text-mode用hook
(defun auto-fill-mode-on ()
  (auto-fill-mode 1)
  (setq fill-column 68)
  ;;(boil)
  )
;; javaのaccessorを追加する
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
;; 現在のregionにあるメンバ変数に対するaccessorを追加する(java)
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
;; emacs22までのtoggle-read-only 
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
(global-set-key "\C-c\C-a" 'insert-accessor-region) ; C-c a でaccessor追加
(global-set-key "\C-l" 'recenter) ; C-l でrecenter
(global-set-key "\C-x\C-q" 'my-toggle-read-only)

;;; hooks
(add-hook 'c-mode-hook 'my-c-def)
(add-hook 'c++-mode-hook 'my-c-def)
(add-hook 'java-mode-hook 'my-c-def)
(add-hook 'perl-mode-hook 'my-perl-def)
(add-hook 'text-mode-hook 'auto-fill-mode-on)
;; 日本語ファイル名をデコード
(eval-after-load "mime"
  '(defadvice mime-entity-filename (around mime-decode activate)
     ad-do-it
     (and ad-return-value
          (setq ad-return-value
                (eword-decode-string (decode-mime-charset-string
                                      ad-return-value
                                      'iso-2022-jp))))))

;;; autoload
;; riece
(autoload 'riece "riece" "Start Riece" t)

;; anything用の設定
(condition-case err
    (progn
      (require 'anything-startup)
      ;; (global-set-key "\^x\^f" 'anything-filelist+)
      (define-key anything-map "\C-p" 'anything-previous-line)
      (define-key anything-map "\C-n" 'anything-next-line)
      (define-key anything-map "\C-v" 'anything-next-page)
      (define-key anything-map "\M-v" 'anything-previous-page)
      (setq anything-command-map-prefix-key "\C-c\C-f")
      (anything-read-string-mode 1)
      )
  (file-error (message "%s" (error-message-string err)))
  )

;; helm用の設定
(condition-case err
    (progn
      (require 'helm)
      (require 'helm-config)
      (global-set-key "\^x\^f" 'helm-find-files)
      (global-set-key "\M-x" 'helm-M-x)
      (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
      (global-set-key "\^z" 'helm-select-action)
      (helm-mode 1)
      )
  (file-error (message "%s" (error-message-string err)))
  )

;; auto-complete用の設定
;; (condition-case err
;;     (progn
;;       (require 'auto-complete-config)
;;       (ac-config-default)
;;       )
;;   (file-error (message "%s" (error-message-string err)))
;; )

;; wanderlust用の設定
(condition-case err
    (progn
      (setq mime-setup-use-signature nil)
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

;; zencoding用の設定
(use-package zencoding-mode
  :commands zencoding-mode
  :init
  (add-hook 'html-mode-hook 'zencoding-mode)
  )

;; yasnippetの設定
(use-package yasnippet
  :config
  (yas/initialize)
  (yas/load-directory "~/.emacs.d/snippets")
  (setq yas/prompt-functions '(yas/dropdown-prompt))
  )

;; xcscopeの設定
(use-package xcscope)

;; org-mode, rememberの設定
(use-package org
  :commands org-mode
  :config
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (setq remember-data-file org-default-notes-file)
  (setq org-mobile-inbox-for-pull (concat org-directory "/flagged.org"))
  (setq org-mobile-directory "~/Dropbox/MobileOrg/")
  (setq org-agenda-files (list org-default-notes-file org-mobile-inbox-for-pull (concat org-directory "/memo.org")))
  (setq org-log-done 'time) ; TODOがDONEになったときに時刻を記録
  (setq org-capture-templates
        '(
          ("t" "Task" entry (file+headline "" "Tasks")
           "* TODO %?\n  CREATED: %U\n  SCHEDULED: %t\n  DEADLINE: %t\n  %a")
          ))
  :bind (("\C-cl" . org-store-link)
         ("\C-cc" . org-capture)
         ("\C-ca" . org-agenda)
         ("\C-cb" . org-iswitchb))
  )

;; multi-term
(use-package multi-term
  :commands multi-term)

;; clang-format
(use-package clang-format
  :config
  (setq clang-format-style-option "llvm")
  (setq clang-format-executable "clang-format-6.0")
  )

;; company
(use-package company
  :config
  (global-company-mode 1)
  (global-set-key (kbd "<C-tab>") 'company-complete)
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (bind-keys :map company-active-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous))
  (bind-keys :map company-search-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous))
  (bind-keys :map company-active-map
             ("<tab>" . company-complete-selection))
  )

;; irony
(use-package irony
  :commands (company-irony irony-mode)
  :config
  (custom-set-variables '(irony-additional-clang-options '("-std=c++17")))
  (add-to-list 'company-backends 'company-irony)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'c-mode-common-hook 'irony-mode)
  )

;; flycheck
(use-package flycheck
  :commands flycheck-mode
  :config
  (setq flycheck-clang-warnings `(,@flycheck-clang-warnings
                                  "no-pragma-once-outside-header"))
  (when (locate-library "flycheck-irony")
    (flycheck-irony-setup))
  )

;; blacken
(use-package blacken
  :init
  (add-hook 'python-mode-hook 'blacken-mode)
  :commands blacken-mode)

;; lsp-mode
(use-package lsp-mode
  :hook ((python-mode c++-mode) . lsp)
;;  :hook (python-mode. lsp)
  :commands lsp
  :config (setq lsp-clients-clangd-executable "clangd-6.0")
  )
(use-package company-lsp
  :commands company-lsp)
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (add-to-list 'company-backends 'company-lsp)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package rtags
  :hook (c++-mode . rtags-start-process-unless-running)
  :config
  (rtags-enable-standard-keybindings)
  (setq rtags-completions-enabled t)
  (setq rtags-display-result-backend 'helm)
  (add-to-list 'company-backends 'company-rtags)
  (bind-keys :map c-mode-base-map
             ("C-." . rtags-find-symbol-at-point)
             ("C-," . rtags-find-references-at-point)
             ("C--" . rtags-location-stack-back)
             ("M-;" . rtags-find-file)
             ("M-." . rtags-find-symbol)
             ("M-," . rtags-find-references)
             ("C-<" . rtags-find-virtuals-at-point)
             ("M-i" . rtags-imenu))
  (bind-keys :map global-map
             ("C-." . rtags-find-symbol-at-point)
             ("C-," . rtags-find-references-at-point)
             ("C--" . rtags-location-stack-back)
             ("M-;" . rtags-find-file)
             ("M-." . rtags-find-symbol)
             ("M-," . rtags-find-references)
             ("C-<" . rtags-find-virtuals-at-point)
             ("M-i" . rtags-imenu))
  )

;; 個別環境用設定の読み込み
(condition-case err
    (load-file "$HOME/.emacs.d/init-local.el")
  (file-error (message "%s" (error-message-string err)))
  )

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
