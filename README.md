Emacs - atheme
==============
Emacs package to select and load installed themes.

Copyright and License
---------------------
Copyright (C) 2015-2019  Free Software Foundation, Inc.

Author: Ernst M. van der Linden <ernst.vanderlinden@ernestoz.com> \
URL: https://github.com/ernstvanderlinden/atheme \
Version: 1.0.0 \
Package-Requires: ((ivy)) \
Keywords: convenience faces

This file is part of GNU Emacs.

This file is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

For a full copy of the GNU General Public License
see <http://www.gnu.org/licenses/>.

Install
-------
#### Clone
As this package is not on melpa (yet), clone this repo and use ```package-install-file``` to install **atheme**. If you prefer, you can use [quelpa](https://github.com/quelpa/quelpa) as well.

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

- M-x atheme-current-theme-message
- M-x atheme-next-theme
- M-x atheme-select-theme

#### Hooks

- atheme-before-load-theme-hook
- atheme-after-load-theme-hook

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
