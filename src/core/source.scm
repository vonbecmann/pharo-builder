;;; source.scm --- a smalltalk source file

;;; Commentary:
;; 
;;; Code:

(define-module (core source)
  #:use-module (core oscommand)
  #:use-module (srfi srfi-9)
  #:export (
	    make-source
	    source-name
	    link-at
	    )
)

(define-record-type source
  (source-new name filename directory)
  source?
  (name name)
  (filename filename)
  (directory directory)
)

(define (print self port)
  (define fmt
    "source ~S named ~S at directory ~S ~%")
  (display (format #f
		   fmt
		   (source-name self)
		   (filename self)
		   (directory self)) port)
)

(define (make-source name filename directory)
  (source-new name filename directory)
)

(define (source-name self)
  (name self)
)

(define (source-path self)
  (source-path-at self (directory self))
  )

(define (source-path-at self directory)
  (path-join directory (filename self))
  )

(define (link-at self directory)
  (symlink (source-path self) (source-path-at self directory))
  )

(provide 'source)

;;; source.scm ends here
