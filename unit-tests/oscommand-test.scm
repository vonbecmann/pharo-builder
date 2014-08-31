(define-module (oscommand-test))
(use-modules (srfi srfi-64))
(use-modules (core oscommand))

(test-begin "oscommand-test")

(test-equal "unzip-is-installed"
	    0 
	    (let* ((unzip-version '("unzip -v")))
	      (call-command-list unzip-version))
	    )

(test-equal "curl-is-installed" 
	    0
	    (let* ((curl-version '("curl -V")))
	      (call-command-list curl-version)))

(test-end)
