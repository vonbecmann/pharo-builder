(define-module (parser-test))
(use-modules (srfi srfi-64))
(use-modules (command-line parser))

(test-begin "parser-test")

(test-equal "parse command line when home exists"
	    "/home/bcontreras/pharo-builder"   
	    (parse '("guile" "--home=/home/bcontreras/pharo-builder"))
	    )

(test-equal "parse command line when home doesn't exists"
	    #f   
	    (parse '("guile"))
	    )

(test-end)
