;;; source.scm --- a smalltalk source file

;;; Commentary:
;; 
;;; Code:

(define-module (core source)
  #:use-module (core oscommand)
  #:export (
	    make-source
	    source-name
	    link-at
	    )
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

(define fields '(name 
		 filename 
		 directory
		 ))

(define source
  (make-record-type "source"
		    fields
		    print)
)

(define make-source
  (record-constructor source
		      fields
		      )
)

(define source-name
  (record-accessor source 'name)
)

(define filename
  (record-accessor source 'filename)
)

(define directory
  (record-accessor source 'directory)
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
