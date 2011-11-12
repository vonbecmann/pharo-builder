(use-modules (oop goops))
(use-modules (unit-test))
(use-modules ((core vm)
		:select ( print )
		))
(use-modules (pharo-builder))


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
