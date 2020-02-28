;;; stripes.el --- highlight alternating lines differently -*- lexical-binding: t -*-

;; Author: Michael Schierl <schierlm-public@gmx.de>
;;         Štěpán Němec <stepnem@gmail.com>
;; Maintainer: Štěpán Němec <stepnem@gmail.com>
;; Created: 02 October 2003
;; URL: https://gitlab.com/stepnem/stripes-el
;; Keywords: convenience faces
;; License: public domain
;; Version: 0.3pre
;; Tested-with: GNU Emacs 26, 27, 28
;; Package-Requires: ((emacs "24"))

;;; Commentary:

;; Highlight every other `stripes-unit' lines with an alternative
;; background color.  Useful for buffers that display lists of any
;; kind, as a guide for your eyes to follow these lines.

;; Before deciding to go the minimal way I also stumbled upon (and
;; discarded just by looking at) the following:

;;   https://github.com/sabof/stripe-buffer

;; ...and an apparently unfinished attempt at rewriting it:

;;   https://github.com/michael-heerdegen/stripe-buffer

;; Michael Schierl's last version (0.2) this is based off can still be
;; found in the git repository (first commit) or at the EmacsWiki:
;; https://www.emacswiki.org/emacs/stripes.el

;; Corrections and constructive feedback appreciated.

;;; Code:
(defgroup stripes () "Highlight alternating lines differently."
  :group 'convenience)

(defcustom stripes-unit 3 "Number of lines making up a single color unit."
  :type 'integer)

(defface stripes `((((min-colors 88) (background dark))
                    ,(append '(:background "#222222")
                             (unless (version< emacs-version "27")
                               '(:extend t))))
                   (((min-colors 88) (background light))
                    ,(append '(:background "#f4f4f4")
                             (unless (version< emacs-version "27")
                               '(:extend t))))
                   (t (:italic t)))
  "Face for alternate lines.")

;;;###autoload
(define-minor-mode stripes-mode
  "Highlight alternating lines differently.

Highlight every other `stripes-unit' lines with an alternative
background color.  Useful for buffers that display lists of any
kind, as a guide for your eyes to follow these lines." nil nil nil
  (if stripes-mode
      (progn
        (stripes-create)
        (add-hook 'after-change-functions #'stripes-create nil t))
    (stripes-remove)
    (remove-hook 'after-change-functions #'stripes-create t))
  (when (called-interactively-p 'interactive)
    (if stripes-mode
        (if (= stripes-unit 1)
            (message "Stripes mode enabled")
          (message "Stripes mode (%i lines) enabled"
                   stripes-unit))
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
      (forward-line stripes-unit)
      (let ((p (point)))
        (unless (eobp)
          (forward-line stripes-unit)
          (overlay-put (make-overlay p (point)) 'face 'stripes))))))

(provide 'stripes)
;;; stripes.el ends here
