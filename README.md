Emacs - atheme
==============
Emacs package to select and load installed themes.

Install
-------
#### Clone
As this package is not on [Melpa](https://melpa.org) (yet), clone this repo and call ```package-install-file``` or simply add a ```load-path``` which points to **atheme** local repo. If you prefer, you could use [quelpa](https://github.com/quelpa/quelpa) as well.

#### Startup
To enable **atheme** on Emacs startup, add the following to your init.el:

```elisp
(require 'atheme)

;; my (installed) themes to choose from or cycle through
;; first theme is default
(athemes-theme-list '(doom-tomorrow-day
                      doom-tomorrow-night
                      dracula
                      gruvbov-dark-medium
                      gruvbov-light-medium
                      leuven
                      material
                      zenburn
                      ;; this theme is a function, so suffix with "-M-x"
                      color-theme-sanityinc-tomorrow-day-M-x
                     ))
;; startup with first theme from athemes-theme-list
(atheme-next-theme)
;; my startup theme
;; (atheme-load-theme 'zenburn)))
```

#### Dependency
This package depends on [ivy](https://melpa.org/#/ivy), so please make sure that has been installed as well. This package does not include themes, these need to be installed separately for example through [Melpa](https://melpa.org).

Usage
-----

#### Interactive functions

- M-x ```atheme-current-theme-message```
- M-x ```atheme-next-theme```
- M-x ```atheme-select-theme```

#### Number prefix
- ```C-u prefix``` to skip atheme selection and auto-select theme

#### Hooks

- ```atheme-pre-load-theme-hook```
- ```atheme-post-load-theme-hook```

##### Hook example

```elisp
;; hook to disable all loaded themes as I prefer one theme only
(add-hook 'atheme-pre-load-theme-hook
          (lambda ()
            (mapc #'disable-theme custom-enabled-themes)))
```

#### Key binding examples

```elisp
(global-set-key (kbd "C-x t") 'atheme-select-theme)
(global-set-key (kbd "<f3>") 'atheme-next-theme)

;; bind one of my favourite themes
(global-set-key (kbd "C-c z")
                 (lambda ()
                   (interactive)
                   (atheme-load-theme 'zenburn)))
```

