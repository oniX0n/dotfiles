;;; init.el --- My config -*- lexical-binding: t; -*-


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)


;; DISABLE GUI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq use-dialog-box nil)


;; GENERAL EDITOR
(savehist-mode)
(save-place-mode 1)
(which-key-mode 1)
(setq echo-keystrokes 0.02)
(setq backward-delete-char-untabify-method 'hungry)
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      scroll-margin 5)
(recentf-mode 1)
(electric-pair-mode 1)
(setq recentf-max-saved-items 200)
(setq-default cursor-type 'bar)
(setopt use-short-answers t)
(setq isearch-lazy-count t)
(setq backup-directory-alist '(("." . "~/.config/pemacs/backups/")))
(setq auto-save-file-name-transforms '((".*" "~/.config/pemacs/auto-save/" t)))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package undo-fu-session
  :ensure t
  :config
  (undo-fu-session-global-mode 1))

(use-package multiple-cursors
  :ensure t
  :bind (("C-<"         . mc/mark-next-like-this)
         ("C->"         . mc/mark-previous-like-this)))

(use-package expand-region
  :ensure t
  :bind ("C-#" . er/expand-region))

;; Look
(set-face-attribute 'default nil :family "FiraCode Nerd Font" :height 110)
(global-display-line-numbers-mode)
(global-hl-line-mode)
(setq treesit-font-lock-level 3)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice "~")


(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-gruvbox t)
  (setq ring-bell-function nil
        visible-bell nil))

(use-package nyan-mode
  :ensure t
  :hook (after-init . nyan-mode)
  :config
  (setq nyan-animate-nyancat t))

(use-package indent-bars
  :ensure t
  :hook ((rust-mode rust-ts-mode) . indent-bars-mode)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-starting-column 0)
  (indent-bars-width-frac 0.15)
  (indent-bars-color-by-depth nil)
  (indent-bars-color '(font-lock-comment-face :face-bg nil :blend 0.425))
  (indent-bars-highlight-current-depth nil)
  (indent-bars-display-on-blank-lines 'least))


;; GENERAL PACKAGES 
(use-package magit
  :ensure t)

(use-package delsel
  :ensure t
  :hook (after-init . delete-selection-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-h C-b" . (lambda () (interactive)(embark-bindings t)))))


(use-package consult
  :ensure t
  :bind
  (("C-x C-b" . consult-buffer))
  :config
  (add-to-list 'consult-buffer-filter "\\`\\*"))

(use-package embark-consult
  :ensure t)



;; DIRED
(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("C-c h" . my/dired-toggle-omit)
              ("b" . dired-up-directory)
              ("C-c s" . dired-du-mode))
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-listing-switches "-alh")
  (dired-omit-files "^\\.[^.]")
  (delete-by-moving-to-trash t)
  (dired-dwim-target t)
  :config
  (require 'dired-x)
  :hook
  (dired-mode . my/dired-omit-on-open))

(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

(use-package dired-du
  :ensure t
  :config
  (setopt dired-du-size-format t))

(use-package dired-subtree
  :ensure t
  :bind (:map dired-mode-map
              ("TAB" . dired-subtree-toggle)))

;; EGLOT
(use-package eglot
  :hook (rust-mode . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c d" . my/eglot-rust-open-external-docs))
  :config
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer
                  (:checkOnSave :json-false
                                :diagnostics (:enable :json-false)
                                :inlayHints (:typeHints (:enable t)
                                                        :parameterHints (:enable :json-false))))))


;; don't let eglot provide syntax highlighting
(with-eval-after-load 'eglot
  (dolist (face (face-list))
    (when (string-prefix-p "eglot-semantic-" (symbol-name face))
      (set-face-attribute face nil
                          :inherit 'unspecified
                          :foreground 'unspecified
                          :background 'unspecified
                          :weight 'unspecified
                          :slant 'unspecified
                          :underline 'unspecified
                          :strike-through 'unspecified))))


(setq eglot-code-action-indications nil)

(defun my/eglot-rust-open-external-docs ()
  "Open the docs.rs / std documentation URL for the symbol at point."
  (interactive)
  (let* ((server (eglot--current-server-or-lose))
         (res (jsonrpc-request server :experimental/externalDocs
                               (eglot--TextDocumentPositionParams)))
         ;; Newer rust-analyzer returns {web, local}; older returns a string.
         (url (if (stringp res)
                  res
                (or (plist-get res :web) (plist-get res :local)))))
    (if url
        (browse-url url)
      (user-error "rust-analyzer returned no docs URL for this symbol"))))


;; LANGS

;; rust
(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t))

;; kdl
(use-package kdl-mode
  :ensure t)

;; lisp
(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          eval-expression-minibuffer-setup) . enable-paredit-mode))

;; pkgbuild
;; (use-package pkgbuild-mode
;;   :ensure t)


;; CUSTOM FUNCTIONS


;; C-g DWIM

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- When a window exists which is unfocused and in `my/quittable-window-modes', close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   ((my/get-quittable-windows)
    (my/close-first-quittable-window))
   (t
    (keyboard-quit))))

(defvar my/quittable-window-modes '(help-mode special-mode Info-mode compilation-mode shell-command-mode diff-mode)
  "All the modes which C-g should close in a split window.")

(defun my/get-quittable-windows ()
  "Returns windows which are quittable according to `my/quittable-window-modes'.
Ignores selected window. Returns nil if none such windows exist."
  (seq-filter (lambda (win)
                (with-current-buffer (window-buffer win)
                  (derived-mode-p my/quittable-window-modes))) 
              (delq (selected-window) (window-list))))

(defun my/close-first-quittable-window ()
  "Closes the first window according to `my/quittable-window-modes'."
  (interactive)
  (when-let* ((win (car (my/get-quittable-windows))))
    (quit-window t win)))


;; DIRED OMIT PERSISTANCE


(defvar my/dired-omit-wanted nil
  "Non-nil means dired buffers should have omit mode on")

(defun my/dired-omit-on-open ()
  "Enable omit mode in a new dired buffer if wanted."
  (when my/dired-omit-wanted
    (dired-omit-mode 1)))

(defun my/dired-toggle-omit ()
  "Flip the global omit preference and apply it to all dired buffers."
  (interactive)
  (setq my/dired-omit-wanted (not my/dired-omit-wanted))
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (derived-mode-p 'dired-mode)
        (dired-omit-mode (if my/dired-omit-wanted 1 -1)))))
  (message "Dired omit: %s" (if my/dired-omit-wanted "on" "off")))



;; TREESIT NAVIAGATION


(defun my/ts-next-node (&optional named-only)
  "Move to next syntax node.
With prefix arg NAMED-only it skips anonymous nodes."
  (interactive "P")
  (let* ((pos (point))
         (node (treesit-search-forward
                (treesit-node-at pos)
                (lambda (n) (> (treesit-node-start n) pos))
                nil
                (not named-only))))
    (when node (goto-char (treesit-node-start node)))))

(defun my/ts-prev-node (&optional named-only)
  "Move to previous syntax node.
With prefix arg NAMED-only it skips anonymous nodes."
  (interactive "P")
  (let* ((pos (point))
         (node (treesit-search-forward
                (treesit-node-at pos)
                (lambda (n) (< (treesit-node-start n) pos))
                t
                (not named-only))))
    (when node (goto-char (treesit-node-start node)))))

(defvar-keymap my/ts-nav-mode-map
  "M-n" #'my/ts-next-node
  "M-p" #'my/ts-prev-node)

(define-minor-mode my/ts-nav-mode
  "Syntax tree navigation for tree-sitter buffers."
  :lighter " TSNav"
  :keymap my/ts-nav-mode-map)

(defun my/ts-nav-maybe-enable ()
  "Enable `my/ts-nav-mode' if the current buffer has a tree-sitter parser."
  (when (and
         (fboundp 'treesit-parser-list)
         (treesit-parser-list))
    (my/ts-nav-mode 1)))

(add-hook 'after-change-major-mode-hook #'my/ts-nav-maybe-enable)


;; QUERY REPLACE WHOLE BUFFER

(defun my/query-replace-whole-buffer (orig-fun &rest args)
  "Run ORIG-FUN from the start of the buffer unless a region is active."
  (save-excursion
    (unless (use-region-p)
      (goto-char (point-min)))
    (apply orig-fun args)))

(dolist (fn '(query-replace query-replace-regexp))
  (advice-add fn :around #'my/query-replace-whole-buffer))


;; PROGRAMMING BACKSPACE

(defun my/backward-delete-indent ()
  "If only whitespace is left of cursor delete all of it and go to previous line.
If previous line is empty indent. Otherwise normal backward-delete."
  (interactive)
  (if (and
       (not (use-region-p))
       (not current-prefix-arg)
       (save-excursion
         (skip-chars-backward " \t")
         (bolp)))
      (progn
        (delete-region (line-end-position 0) (point))
        (when (bolp)
          (indent-for-tab-command)))
    (call-interactively #'delete-backward-char)))

(defvar-keymap my/smart-backspace-mode-map
  "DEL" #'my/backward-delete-indent)

(define-minor-mode my/smart-backspace-mode
  "Smart backspace in indentation."
  :lighter " SB"
  :keymap my/smart-backspace-mode-map)

(add-hook 'prog-mode-hook #'my/smart-backspace-mode)



;; !CUSTOM FUNCTIONS


;; GLOBAL KEYS
(keymap-global-set "C-x C-r" #'recentf-open)
(keymap-global-set "C-<tab>" #'mode-line-other-buffer)
(keymap-global-set "C-g"     #'prot/keyboard-quit-dwim)
(keymap-global-set "C-ö" #'undo)
(keymap-global-set "C-ä" #'undo-redo)
(keymap-global-set "C-ü C-ü" #'other-window)
(keymap-global-set "C-ü C-v" #'split-window-vertically)
(keymap-global-set "C-ü C-h" #'split-window-horizontally)
(keymap-global-set "C-ü C-o" #'delete-other-windows)
(keymap-global-set "C-ü C-k" #'delete-window)
