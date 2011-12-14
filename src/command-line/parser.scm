;;; parser.scm --- command line parser

;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(define-module (command-line parser)
  #:use-module (ice-9 getopt-long)
  #:export (
	    parse
	    )
)


(define (parse args)
  (let* (
	 (option-spec
	  '(
	    (home (value #t) (required? #f))
	    )
	  )
	 (options (getopt-long args option-spec))
	 )
    (option-ref options 'home #f)
    )
)


;;; parser.scm ends here