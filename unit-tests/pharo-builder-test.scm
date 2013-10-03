(define-module (pharo-builder-test))
(use-modules (srfi srfi-64))
(use-modules (core pharo-builder))

(test-begin "pharo-builder-test")

(define directory-name "a-directory")
(define user-directory "user-directory")
(define current-directory "current-directory")
(define package-directory "4")
(define current-project '())
(define fmt "configuration builder at ~S ~% user's directory: ~S ~% current directory: ~S \n package cache directory: ~S \n current ~S \n")

(define expected (format #f fmt directory-name user-directory current-directory package-directory current-project)) 
(define test-pharo-builder 
 (make-pharo-builder
  directory-name
  user-directory
  current-directory
  package-directory
  current-project
  '()
  (make-hash-table)
  (make-hash-table)	     
  ))

(test-equal "pharo-builder as string" 
	    expected 
	    (let* ((string-port (open-output-string)))
	      (write test-pharo-builder string-port)
	      (get-output-string string-port)
	      ))  
(test-end)

