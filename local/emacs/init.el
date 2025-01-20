;;; init.el -*- lexical-binding: t; -*-

;; Author: Max Karou <maxkarou@protonmail.com>
;; URL: https://github.com/52/mOS

;;; Commentary:

;;; Code:

;; `evil`
(use-package evil
  :init
  (setq evil-want-integration nil)
  :config
  (evil-mode))

(provide 'init)

;;; init.el ends here
