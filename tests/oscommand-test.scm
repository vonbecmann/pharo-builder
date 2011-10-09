(define-module (pharo-builder tests oscommand-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder core oscommand)
  )

(define-class <oscommand-test> (<test-case>)
  )

(define-method (test-unzip-is-installed (self <oscommand-test>))
  (let* ( 
	 (unzip-version '("unzip -v"))
	 (expected 0)
	 )

    (assert-equal expected (call-command-list unzip-version))
    )
  )

(define-method (test-curl-is-installed (self <oscommand-test>))
  (let* ( 
	 (curl-version '("curl -V"))
	 (expected 0)
	 )

    (assert-equal expected (call-command-list curl-version))
    )
  )
