(define-module (project-test))
(use-modules (srfi srfi-64))
(use-modules ((core project)
	      :select (
		       set-up-script-at
		       make-project
		       )
	      :renamer (symbol-prefix-proc 'project:)
	      ))
(use-modules (api))

(test-begin "project-test")

(define artifact-name 'pharo-core)
(define vm-name 'test-vm)
(define test-source (source 'pharov10 "http:/download/url"))
(define test-artifact (artifact artifact-name "http:/download/url" 'pharov10))
(define test-vm (vm vm-name "http:/download/url" "/path/to/vm"))
(define test-project (project:make-project "/test-project" test-vm test-artifact "./package-cache"))

(test-equal "project as string" 
	    (format #f "(pb:project '~a '~a)\n" vm-name artifact-name)
	    (let* ((string-port (open-output-string)))
	      (display test-project string-port) 
	      (get-output-string string-port)))

(test-equal "project's setup script" 
	    "/test-project/set-up.st" 
	    (project:set-up-script-at test-project))

(test-end)


