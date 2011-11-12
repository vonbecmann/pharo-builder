(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (command-line parser))

(define-class <parser-test> (<test-case>)
  )

(define-method (test-parse-command-line-when-home-exists (self <parser-test>))
  (let* (
	 (command-line '("guile" "--home=/home/bcontreras/pharo-builder"))
	 (expected "/home/bcontreras/pharo-builder")
	 )
    (assert-equal expected (parse command-line))
    )
)

(define-method (test-parse-command-line-when-home-doesnot-exists (self <parser-test>))
  (let* (
	 (command-line '("guile"))
	 (expected #f)
	 )
    (assert-equal expected (parse command-line))
    )
)