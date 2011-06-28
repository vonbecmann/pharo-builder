(define-module (pharo-builder tests parser-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder command-line parser)
  )
(define-class <parser-test> (<test-case>)
  )

(define-method (test-parse-commandline (self <parser-test>))
  (let* (
	 (command-line '("guile" "home=/home/bcontreras/pharo-builder"))
	 (expected "/home/bcontreras/pharo-builder")
	 )
    (assert-equal  expected (parse command-line))
    )
)