(use-modules (oop goops))
(use-modules (unit-test))
(use-modules (core oscommand))


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
