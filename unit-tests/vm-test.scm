(define-module (pharo-builder unit-tests vm-test)
  #:use-module (oop goops)
  #:use-module (unit-test)
  #:use-module ((pharo-builder core vm)
		:select ( print )
		)
  #:use-module (pharo-builder pharo-builder)
  )

(define-class <vm-test> (<test-case>)
  )

(define-method (test-vm-print-to-string (self <vm-test>))
  (let* ( 
	 (name "test-vm")
	 (path "/path/to/vm")
	 (fmt "~A virtual machine at ~A \n")
	 (test-vm
	  (vm 
	   "test-vm"
	   "/path/to/vm"))
	 (string-port (open-output-string))
	 (expected (format #f fmt name path)) 
	 )

    (print test-vm string-port)
    (assert-equal expected (get-output-string string-port))
    )
  )
