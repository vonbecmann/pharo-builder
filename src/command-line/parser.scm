;;; parser.scm --- command line parser

;;; Commentary:
;; parse arguments from command line


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
  "parse home argument from command line"
  (let* ((option-spec '((home (value #t) (required? #f))))
	 (options (getopt-long args option-spec)))
    (option-ref options 'home #f)
    )
  )


;;; parser.scm ends here
