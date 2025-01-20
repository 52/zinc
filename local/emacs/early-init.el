;;; early-init.el -*- no-byte-compile: t; lexical-binding: t; -*-

;; Author: Max Karou <maxkarou@protonmail.com>
;; URL: https://github.com/52/mOS

;;; Commentary:

;;; Code:

(defun mk/reduce-gc ()
  "Reduce the frequency of garbage collection."
  (setq gc-cons-threshold most-positive-fixnum
        gc-cons-percentage 0.6))

(defun mk/restore-gc ()
  "Restore the frequency of garbage collection."
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1))

(mk/reduce-gc)

(add-hook 'minibuffer-setup-hook #'mk/reduce-gc -50)
(add-hook 'minibuffer-exit-hook #'mk/restore-gc)

(add-hook 'emacs-startup-hook #'mk/restore-gc)
(add-hook 'kill-emacs-hook #'mk/reduce-gc -50)

(setq inhibit-compacting-font-caches t)
(setq frame-inhibit-implied-resize t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq frame-title-format nil)

(setq inhibit-splash-screen t)

(blink-cursor-mode -1)
(scroll-bar-mode   -1)
(menu-bar-mode     -1)
(tool-bar-mode     -1)
(tooltip-mode      -1)

(provide 'early-init)

;;; early-init.el ends here
