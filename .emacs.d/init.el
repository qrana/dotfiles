;;; package -- Emacs init file
;;; Commentary:
;; Basic Emacs init values

;;; Code:
;; global variables
(setq
 inhibit-startup-screen t
 create-lockfiles nil
 make-backup-files nil
 column-number-mode t
 scroll-error-top-bottom t
 show-paren-delay 0.5
 use-package-always-ensure t
 sentence-end-double-space nil)

;; buffer local variables
(setq-default
 indent-tabs-mode nil
 tab-width 4
 c-basic-offset 4)

;; global keybindings


;; the package manager
(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/"))
 package-archive-priorities '(("melpa-stable" . 1)))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Install material-theme if not installed and enable it
(unless (package-installed-p 'material-theme)
  (package-install 'material-theme))
(load-theme 'material t)

;; Enable evil
(use-package evil
  :demand)
(evil-mode 1)

;; Enable org-mode
(use-package org
  :demand)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; Enable irony backend
(use-package irony
  :config
  (progn
    ;; If irony server was never installed, install it.
    (unless (irony--find-server-executable) (call-interactively #'irony-install-server))

    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)

    ;; Use compilation database first, clang_complete as fallback.
    (setq-default irony-cdb-compilation-databases '(irony-cdb-libclang
                                                      irony-cdb-clang-complete))

    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  ))

;; Use irony with company to get code completion.
(use-package company-irony
  :requires company irony
  :config
  (progn
    (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))))

;; Use irony with flycheck to get real-time syntax checking.
(use-package flycheck-irony
  :requires flycheck irony
  :config
  (progn
    (eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

;; Eldoc shows argument list of the function you are currently writing in the echo area.
(use-package irony-eldoc
  :requires eldoc irony
  :config
  (progn
    (add-hook 'irony-mode-hook #'irony-eldoc)))

;; Enable company (code completition)
(require 'company)
(progn
  (add-hook 'after-init-hook 'global-company-mode)
  (global-set-key (kbd "M-/") 'company-complete-common-or-cycle)
  (setq company-idle-delay 0))

;; Enable flycheck (syntx checker)
(require 'flycheck
  :config
  (progn
    (global-flycheck-mode)))

;; Enable ensime - scala static checker
(use-package ensime
  :ensure t
  :pin melpa-stable)



;; modes
;; (global-display-line-numbers-mode)
(electric-pair-mode)
(electric-indent-mode +1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(windmove-default-keybindings)
(visual-line-mode)

;; 80 column rule
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; Relative line numbers
(require 'linum-relative)
(linum-mode)
(linum-relative-global-mode)
(setq linum-relative-current-symbol "")

;; Stuff added by Custonm

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-babel-load-languages (quote ((emacs-lisp . t) (calc . t))))
 '(org-log-done t)
 '(package-selected-packages
   (quote
    (linum-relative haskell-mode htmlize ensime use-package irony-eldoc flycheck-irony evil company-irony))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here

