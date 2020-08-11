(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)
(tool-bar-mode -1)
(menu-bar-mode -1)

(setq initial-scratch-message nil)

(tooltip-mode nil)

(set-scroll-bar-mode 'right)

(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)

(if (>= emacs-major-version 24)
    (setq-default bidi-display-reordering nil))

(when (>= emacs-major-version 23)
  (global-visual-line-mode 1)
  (setq line-move-visual nil))

(show-paren-mode t)

(blink-cursor-mode 1)

(line-number-mode 1)

(column-number-mode 1)

;; Mac stuff
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(setq visible-bell nil) ;; The default
(setq ring-bell-function 'ignore)
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        ;; use 120 char wide window for largeish displays
        ;; and smaller 80 column windows for smaller displays
        ;; pick whatever numbers make sense for you
        (if (> (x-display-pixel-width) 1280)
            (add-to-list 'default-frame-alist (cons 'width 120))
          (add-to-list 'default-frame-alist (cons 'width 80)))
        ;; for the height, subtract a couple hundred pixels
        ;; from the screen height (for panels, menubars and
        ;; whatnot), then divide by the height of a char to
        ;; get the height we want
        (add-to-list 'default-frame-alist
                     (cons 'height (/ (- (x-display-pixel-height) 200)
                                      (frame-char-height)))))))

(set-frame-size-according-to-resolution)

                                        ;(global-hl-line-mode 1) ; turn on highlighting current line

(delete-selection-mode 1)

(setq expand-region-contract-fast-key ".")

(setq scroll-step 1)

(setq-default fill-column 80)

(setq message-log-max 1000)

(setq-default indent-tabs-mode nil)

(setq-default tab-width 4)

(setq kill-ring-max 200)

(setq require-final-newline t track-eol t)

;; works well with Github
(global-auto-revert-mode t)

(electric-pair-mode 1)
(add-hook
 'rust-mode-hook
 (lambda ()
   (setq-local electric-pair-inhibit-predicate
               `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))
;; (autopair-global-mode)
;; (setq autopair-autowrap t)

(ido-mode t)

(recentf-mode t)
(setq recentf-max-saved-items 200)

(global-undo-tree-mode)

(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-after-kill-buffer-p nil)
(setq uniquify-min-dir-content 2)

(add-hook 'ido-setup-hook 'my-ido-keys)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(defun my-ido-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-;") 'ido-exit-minibuffer)
  (define-key ido-completion-map (kbd "C-.") 'ido-magic-forward-char)
  (define-key ido-completion-map " " 'ido-next-match)
  (define-key ido-completion-map "\C-n" 'ido-next-match)
  (define-key ido-completion-map "\C-o" 'ido-magic-forward-char)
  (define-key ido-completion-map "\C-p" 'ido-prev-match)
  (define-key ido-completion-map "\C-j" 'ido-prev-work-directory)
  (define-key ido-completion-map "\C-l" 'ido-next-work-directory)
  )

;;(defun my-c-mode-hook ()
;; add my personal style and set it for the current buffer
;;(c-add-style "PERSONAL" my-c-style t))

;;(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(setq c-default-style "linux"
      c-basic-offset 4)

(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if (region-active-p) (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if (region-active-p) (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
(global-set-key (kbd "C-k") 'kill-region)

(defun occur-at-point ()
  (interactive)
  (let (default input)
    (when (thing-at-point 'symbol)
      (setq default (buffer-substring
                     (progn (beginning-of-thing 'symbol) (point))
                     (progn (end-of-thing 'symbol) (point)))))
    (if (> emacs-major-version 22)
        (setq input (read-regexp "List lines matching regexp" default))
      (setq input (read-string "List lines matching regexp " nil nil default)))
    (occur-1 input nil (list (current-buffer)))))

;; sets "occur" function
(global-set-key (kbd "M-o") 'occur-at-point)

(global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-.") 'helm-imenu-anywhere)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)

(global-set-key (kbd "C-x v") 'compile)


;; (require 'auto-complete-config)
;; (add-to-list 'load-path "~/.emacs.d/lisp")
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
;; (ac-config-default)

(require 'company)
(add-hook 'global-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-c-headers)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

(add-hook 'company-mode-hook (lambda () (auto-complete-mode -1)))
(global-linum-mode 1)

;; Google's Material Design Theme
;; (load-theme 'material t)


;; (use-package spacemacs-theme
;;   :ensure t
;;   :init
;;   (load-theme 'spacemacs-dark t)
;;   (setq spacemacs-theme-org-agenda-height nil)
;;   (setq spacemacs-theme-org-height nil))

;; (use-package spaceline
;;   :demand t
;;   :init
;;   (setq powerline-default-separator 'arrow-fade)
;;   :config
;;   (require 'spaceline-config)
;;   (spaceline-spacemacs-theme))

;; Avy
(global-set-key (kbd "C-:") 'avy-goto-char-2)

(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin"))
(setq exec-path (append exec-path '("/Library/TeX/texbin")))

(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-region)

;; (require 'auto-complete)
;; (require 'auto-complete-config)
;; (ac-config-default)

(require 'ac-math)
(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`

(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
  (setq ac-sources
        (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
                ac-sources))
  )
()
(add-hook 'LaTeX-mode-hook 'ac-LaTeX-mode-setup)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(exec-path-from-shell-copy-env "virtualenv")
(require 'epc)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)

(use-package rainbow-delimiters
  :ensure t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(require 'ccls)
(use-package lsp-mode
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  :init (setq lsp-keymap-prefix "s-l")
  :hook ((c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package company-lsp :commands company-lsp)
(use-package ccls
  :hook ((c-mode c++-mode) .
         (lambda () (require 'ccls) (lsp))))

(setq global-lsp-lens-mode nil)

(add-hook 'after-init-hook 'global-company-mode)

(package-install 'exec-path-from-shell)
(exec-path-from-shell-initialize)
;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-hook 'python-mode-hook '(lambda ()
                               (setq python-indent 4)))

;; (package-initialize)
;; (elpy-enable)

(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

(set-face-attribute 'default nil :height 140)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (0blayout toml imenu-anywhere helm-lsp helm company-c-headers jedi lsp-treemacs company-lsp ccls lsp-ui lsp-mode toml-mode cargo rust-mode epc all-the-icons doom-modeline markdown-mode+ markdown-mode go-mode go which-key web-mode virtualenv use-package undo-tree spaceline smex rainbow-delimiters pyenv-mode material-theme idomenu hydra flycheck-pos-tip expand-region exec-path-from-shell elpy counsel company-jedi company-irony-c-headers company-irony company-anaconda avy auto-complete-clang-async auto-complete-clang auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 0)))

(global-set-key (kbd "C-c l") 'org-store-link)

(setq-default c-basic-offset 2)

;; (require 'doom-modeline)
;; (doom-modeline-mode 1)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    (quote
;;     (doom-themes all-the-icons doom-modeline markdown-mode+ markdown-mode go-mode go which-key web-mode virtualenv use-package undo-tree spaceline smex rainbow-delimiters pyenv-mode material-theme magit jedi irony-eldoc idomenu hydra flycheck-pos-tip expand-region exec-path-from-shell elpy counsel company-jedi company-irony-c-headers company-irony company-anaconda avy autopair auto-complete-clang-async auto-complete-clang auctex ac-math ac-clang))))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(add-hook 'rust-mode-hook 'cargo-minor-mode)

;;(use-package toml-mode)

(use-package rust-mode
  :hook (rust-mode . lsp))

;; Add keybindings for interacting with Cargo
(use-package cargo
  :hook (rust-mode . cargo-minor-mode))
