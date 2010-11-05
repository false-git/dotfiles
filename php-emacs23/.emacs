;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

(setq debug-on-error t)
(setq make-backup-files nil)
(line-number-mode 1)
(setq kill-whole-line t)
(setq mouse-yank-at-point t)
(setq require-final-newline t )
(global-set-key "\^x\^g" 'goto-line)
(global-set-key "\^l" 'recenter)

(require 'php-mode)

(add-hook 'php-mode-hook
          '(lambda ()
             (require 'php-completion)
             (php-completion-mode t)
             (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
             (when (require 'auto-complete nil t)
             (make-variable-buffer-local 'ac-sources)
             (add-to-list 'ac-sources 'ac-source-php-completion)
             (auto-complete-mode t))
             (setq c-basic-offset 4)
             (setq require-final-newline 'query)
             (setq indent-tabs-mode nil)))
;(setq phpcmp-global-enable-auto-update-tag-files t)

; vc-toggle-read-only
(defun my-toggle-read-only (&optional verbose)
  "Change read-only status of current buffer, perhaps via version control.

If the buffer is visiting a file registered with version control,
then check the file in or out.  Otherwise, just change the read-only flag
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
(global-set-key "\C-x\C-q" 'my-toggle-read-only)

(setq browse-url-browser-function 'w3m-browse-url)

(setq display-time-day-and-date t)
(display-time)
(server-start)
