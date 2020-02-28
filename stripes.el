;;; stripes.el --- highlight alternating lines differently -*- lexical-binding: t -*-

;; Author: Michael Schierl <schierlm-public@gmx.de>
;;         Štěpán Němec <stepnem@gmail.com>
;; Maintainer: Štěpán Němec <stepnem@gmail.com>
;; Created: 02 October 2003
;; URL: https://gitlab.com/stepnem/stripes-el
;; Keywords: convenience faces
;; License: public domain
;; Tested-with: GNU Emacs 26, 27, 28
;; Version: 0.3a
;; Package-Requires: ((emacs "24.3"))

;;; Commentary:

;; Highlight every even line (or every other `stripes-lcount' lines)
;; with an alternative background color.  Useful for buffers that
;; display lists of any kind, as a guide for your eyes to follow
;; these lines.

;; This is an updated version of Michael's library which can still be
;; found at https://www.emacswiki.org/emacs/stripes.el

;; Before deciding to go the minimal way I also stumbled upon (and
;; discarded just by looking at) the following:

;;   https://github.com/sabof/stripe-buffer

;; ...and an apparently unfinished attempt at rewriting the mess:

;;   https://github.com/michael-heerdegen/stripe-buffer

;;; Code:
(defconst stripes-version "0.3a" ; FIXME
  "Current version of the stripes.el library.")

(defvar-local stripes-lcount 1)

(defface stripes
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
  (remove-overlays nil nil 'face 'stripes))

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
          (overlay-put (make-overlay p (point)) 'face 'stripes))))))

(provide 'stripes)

;;; stripes.el ends here
