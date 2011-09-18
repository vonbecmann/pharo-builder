(define-module (pharo-builder tests pharo-builder-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module (pharo-builder pharo-builder)
  )

(define-class <pharo-builder-test> (<test-case>)
  )

(define-method (test-vm (self <pharo-builder-test>))
  (let* ( 
	 (name "test-vm")
	 (path "/path/to/vm")
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 )
    (assert-true (record? test-vm))
    )
  )