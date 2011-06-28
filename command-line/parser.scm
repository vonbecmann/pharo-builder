(define-module (pharo-builder command-line parser)
  #:use-module (oop goops)
  #:use-module (ice-9 format)
  #:export (
	    parse
	    )
)

(define option-spec
       '(
	 (home (value #t) (required? #t))
	 )
)
(define (parse args)
  "hola"
)