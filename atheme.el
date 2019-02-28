;;; atheme.el --- select a theme -*- lexical-binding: t -*-

;; Copyright (C) 2015-2019  Free Software Foundation, Inc.

;; Author: Ernst M. van der Linden <ernst.vanderlinden@ernestoz.com>
;; URL: https://github.com/ernstvanderlinden/atheme
;; Version: 1.0.0
;; Package-Requires: ((ivy))
;; Keywords: convenience faces

;; This file is part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; To enable atheme on Emacs startup, add following to your init.el:
;;
;;   (require 'atheme)
;;
;;   ;; my (installed) themes to choose from or cycle through
;;   ;; first theme is default
;;   (athemes-theme-list '(doom-tomorrow-day
;;                         doom-tomorrow-night
;;                         dracula
;;                         gruvbov-dark-medium
;;                         gruvbov-light-medium
;;                         leuven
;;                         material
;;                         zenburn
;;                         ;; this theme is a function, so suffix with "-M-x"
;;                         color-theme-sanityinc-tomorrow-day-M-x
;;                        ))
;;   ;; startup with first theme from athemes-theme-list
;;   (atheme-next-theme)
;;   ;; my startup theme
;;   ;; (atheme-load-theme 'zenburn)))
;; 
;; Interactive functions:
;; 
;;   M-x `atheme-current-theme-message'
;;   M-x `atheme-next-theme'
;;   M-x `atheme-select-theme'
;;   M-x `atheme-disable-current-theme'
;;
;; Hooks:
;;
;;   `atheme-before-load-theme-hook'
;;   `atheme-after-load-theme-hook'
;; 
;;   Hook example:
;;   
;;   ;; hook to disable all loaded themes as I prefer one theme only
;;   (add-hook 'atheme-pre-load-theme-hook
;;             (lambda ()
;;               (mapc #'disable-theme custom-enabled-themes)))
;; 
;; Key binding examples:
;; 
;;   (global-set-key (kbd "C-x t") 'atheme-select-theme)
;;   (global-set-key (kbd "<f3>") 'atheme-next-theme)
;;
;;  ;; bind one of my favourite themes
;;   (global-set-key (kbd "C-c z")
;;                   (lambda ()
;;                     (interactive)
;;                     (atheme-load-theme 'zenburn)))
;;

;;; Code:

(require 'ivy)

(defcustom atheme-pre-load-theme-hook nil
  "Hook before a theme is loaded by calling `atheme-load-theme'."
  :type 'hook)

(defcustom atheme-post-load-theme-hook nil
  "Hook after a theme is loaded by calling `atheme-load-theme'."
  :type 'hook)

(defcustom atheme-theme-list '()
  "List of themes to select from and cycle through."
  :type 'list)

(defcustom atheme-theme-function-suffix "-M-x"
  "Suffix for theme in `atheme-theme-list' if theme is a function.
The theme without suffix is the function which will be called."
  :type 'string)

(setq atheme--current-theme nil
      atheme--next-theme-list '())

(defun atheme--init-p ()
  "Return t if `atheme-init' call is required."
  (not (= (length atheme-theme-list)
          (length atheme--next-theme-list))))

(defun atheme-init ()
  "Initialize `atheme'."
  (if atheme-theme-list
      (setq atheme--next-theme-list atheme-theme-list)
    (error "Variable `atheme-theme-list' is nil")))

(defun atheme-disable-current-theme ()
  (interactive)
  (when atheme--current-theme
    (disable-theme atheme--current-theme)))

(defun atheme-load-theme (theme)
  "Disable current theme and load new THEME."
  (when atheme-pre-load-theme-hook
    (run-hooks 'atheme-pre-load-theme-hook))
  ;; init?
  (when (atheme--init-p)
    (atheme-init))
  ;; disable current theme?
  (atheme-disable-current-theme)
  (setq atheme--current-theme theme
        ;; remove current theme from list
        atheme--next-theme-list (remove atheme--current-theme
                                    atheme--next-theme-list)
        ;; move current theme to end of list
        atheme--next-theme-list (append
                             atheme--next-theme-list
                             (list atheme--current-theme)))
  ;; M-x suffix?
  (if (string-suffix-p atheme-theme-function-suffix
                       (symbol-name atheme--current-theme) t)
      (call-interactively
       (intern (string-remove-suffix
                atheme-theme-function-suffix
                (symbol-name atheme--current-theme))))
    (load-theme atheme--current-theme t))

  (when atheme-post-load-theme-hook
    (run-hooks 'atheme-post-load-theme-hook)))

(defun atheme-next-theme ()
  "Load next theme."
  (interactive)
  ;; init?
  (when (atheme--init-p)
    (atheme-init))
  (atheme-load-theme (car atheme--next-theme-list)))

(defun atheme-select-theme (&optional arg)
  "Select and load a theme.
If `integer' prefix argument ARG is provided, `atheme' will skip `ivy'
auto-select the theme from `atheme-theme-list'."
  (interactive "P")
  (let ((themes atheme-theme-list))
    (if arg
        (atheme-load-theme
         (nth (1- (prefix-numeric-value arg))
              themes))
      (let ((name (ivy-completing-read
                   "Select a theme: " themes)))
        (atheme-load-theme (intern name))))))

(defun atheme-current-theme ()
  "Current theme."
  (atheme--current-theme))

(defun atheme-current-theme-message ()
  "Echos current theme."
  (interactive)
  (message "%s" atheme--current-theme))

(provide 'atheme)
;;; atheme.el ends here
