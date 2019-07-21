;;; stripes.el --- highlight alternating lines differently -*- lexical-binding: t -*-

;; Copyright (C) 2003 Michael Schierl

;; Author: Michael Schierl <schierlm-public@gmx.de>
;;         Štěpán Němec <stepnem@gmail.com>
;; Maintainer: Štěpán Němec <stepnem@gmail.com>
;; Created: 02 October 2003
;; Keywords: convenience faces
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

(defvar-local stripes-lcount 1)

(defface stripes-face
  `((t (:background "#f4f4f4")))
  "Face for alternate lines."
  :group 'stripes)

;;;###autoload
(define-minor-mode stripes-mode
  "Highlight alternating lines differently." nil nil nil
  (if stripes-mode
      (progn
        (stripes-create)
        (add-hook 'after-change-functions #'stripes-create nil t))
    (stripes-remove)
    (remove-hook 'after-change-functions #'stripes-create t))
  (when (called-interactively-p 'interactive)
    (if stripes-mode
        (if (= stripes-lcount 1)
            (message "Stripes mode enabled")
          (message "Stripes mode (%i lines) enabled"
                   stripes-lcount))
      (message "Stripes mode disabled"))))

(defun stripes-remove ()
  "Remove all alternation colors."
  (remove-overlays nil nil 'face 'stripes-face))

(defun stripes-create (&rest _)
  "Color alternate lines in current buffer differently."
  (stripes-remove)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (forward-line stripes-lcount)
      (let ((p (point)))
        (unless (eobp)
          (forward-line stripes-lcount)
          (overlay-put (make-overlay p (point)) 'face 'stripes-face))))))

(provide 'stripes)

;;; stripes.el ends here
