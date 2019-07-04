;;; stripes.el --- highlight alternating lines differently -*- lexical-binding: t -*-

;; Copyright (C) 2003 Michael Schierl

;; Author: Michael Schierl <schierlm-public@gmx.de>
;;         Štěpán Němec <stepnem@gmail.com>
;; Maintainer: Štěpán Němec <stepnem@gmail.com>
;; Created: 02 October 2003
;; Keywords: list alternation color
;; Tested-with: GNU Emacs 26
;; Version: 0.3a

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Highlight every even line (or every other `stripes-lcount' lines)
;; with an alternative background color.  Useful for buffers that
;; display lists of any kind, as a guide for your eyes to follow
;; these lines.

;;; Code:
(defconst stripes-version "0.3a" ; FIXME
  "Current version of the stripes.el library.")

(defvar stripes-lcount 1)
(make-variable-buffer-local 'stripes-lcount)

(defface stripes-face
  `((t (:background "#f4f4f4")))
  "Face for alternate lines."
  :group 'stripes)

;;;###autoload
(define-minor-mode stripes-mode "Highlight alternating lines differently."
  (if stripes-mode
      (stripes-create)
    (stripes-remove))
  (when (called-interactively-p 'interactive)
    (if stripes-mode
        (if (= stripes-lcount 1)
            (message "Color alternation mode enabled")
          (message "Color alternation mode (%i lines) enabled"
                   stripes-lcount))
      (message "Color alternation mode disabled"))))

(defun stripes-remove ()
  "Remove all alternation colors."
  (let ((oli (overlays-in (point-min) (point-max))) ol)
    (while oli
      (setq ol (car oli)
            oli (cdr oli))
      (when (eq (overlay-get ol 'face) 'stripes-face)
        (delete-overlay ol)))))

(defun stripes-create ()
  "Colors lines in current buffer alternatively.
This will not monitor changes of the buffer."
  (save-excursion
    (save-restriction
      (widen)
      (stripes-remove)
      (goto-char (point-min))
      (while (not (eobp))
        (forward-line stripes-lcount)
        (let ((ppp (point))
              ovl)
          (unless (eobp)
            (forward-line stripes-lcount)
            (setq ovl (make-overlay ppp (point)))
            (overlay-put ovl 'face 'stripes-face)))))))

(defun stripes-after-change-function (beg end length)
  "After change function for color alternation mode.
Refreshes all the highlighting.  This is slow, but as mostly lists are
not changed that often, it should be acceptable.  Arguments BEG END
and LENGTH are not used."
  (if stripes-mode
      (stripes-create)))

(add-hook 'after-change-functions
          'stripes-after-change-function)

(provide 'stripes)

;;; stripes.el ends here
